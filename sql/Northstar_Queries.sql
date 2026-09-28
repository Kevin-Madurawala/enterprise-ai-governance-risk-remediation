-- NorthStar Manufacturing: AI Governance Analysis
-- Portfolio project using synthetic data.
-- Governance_Priority_Score in Query 8 is a project-defined prioritization metric, not an official NIST/ISO formula.
-- Query 7 uses 2026-09-28 as the project snapshot date for overdue-control analysis.

--Query  1: High-Risk AI Systems by Department
SELECT d.Department_Name,
COUNT(*) AS High_Risk_AI_Systems
FROM ai_systems AS a
JOIN departments AS d
ON a.Department_ID = d.Department_ID
JOIN risk_assessments AS r 
ON a.AI_System_ID = r.AI_System_ID
WHERE r.Risk_Level IN ('High', 'Critical')
GROUP BY d.Department_Name
ORDER BY High_Risk_AI_Systems DESC;

--Query 2: AI Systems Ranked By Risk
SELECT
a.AI_System_ID,
a.System_Name,
d.Department_Name,
r.Overall_Risk_Score,
r.Risk_Level
FROM ai_systems as a
JOIN departments as d
ON a.Department_ID = d.Department_ID
JOIN risk_assessments as r
ON a.AI_System_ID = r.AI_System_ID
ORDER BY r.Overall_Risk_Score DESC;

-- Query 3: High-Risk AI Systems with Weak or Missing Controls
SELECT
a.AI_System_ID,
a.System_Name,
d.Department_Name,
r.Overall_Risk_Score,
r.Risk_Level,
c.Control_Category,
c.Control_Name,
c.Control_Status,
c.Control_Effectiveness
FROM ai_systems as a
JOIN departments as d
ON a.Department_ID = d.Department_ID
JOIN risk_assessments as r
ON a.AI_System_ID = r.AI_System_ID
JOIN governance_controls as c
ON a.AI_System_ID = c.AI_System_ID
WHERE r.Risk_Level IN ('High', 'Critical')
AND (c.Control_Status IN ('Missing', 'Partial') 
OR c.Control_Effectiveness IN ('Not Effective', 'Partially Effective'))
ORDER BY
r.Overall_Risk_Score DESC,
a.AI_System_ID;

-- Query 4: Control Coverage by Department
SELECT
d.Department_Name,
COUNT(c.Control_ID) AS Total_Controls,
SUM(CASE 
		WHEN c.Control_Status = 'Implemented'
			AND c.Control_Effectiveness = 'Effective'
		THEN 1
		ELSE 0
	END 
) AS Effective_Controls,
ROUND(
	100.0 *
	SUM(
		CASE
			WHEN c.Control_Status = 'Implemented'
				AND c.Control_Effectiveness = 'Effective'
			THEN 1
			ELSE 0
		END
	)/ COUNT (c.Control_ID),
	1
) AS Control_Coverage_Percent
FROM governance_controls AS c
JOIN ai_systems AS a
ON c.AI_System_ID = a.AI_System_ID
JOIN departments AS d
ON a.Department_ID = d.Department_ID
GROUP BY d.Department_Name
ORDER BY Control_Coverage_Percent ASC;

-- Query 5: AI Systems with the Most Incidents
SELECT 
a.AI_System_ID,
a.System_Name,
d.Department_Name,
COUNT (i.Incident_ID) AS Incident_Count
FROM ai_incidents AS i
JOIN ai_systems AS a
ON i.AI_System_ID = a.AI_System_ID
JOIN departments AS d
ON a.Department_ID = d.Department_ID
GROUP BY
a.AI_System_ID,
a.System_Name,
d.Department_Name
ORDER BY Incident_Count DESC;

-- Query 6: High-Risk AI Systems with Severe Incidents
SELECT
a.AI_System_ID,
a.System_Name,
d.Department_Name,
r.Overall_Risk_Score,
r.Risk_Level,

COUNT(i.Incident_ID) AS Total_Incidents,

SUM(
	CASE
		WHEN i.Severity = 'High' THEN 1
		ELSE 0
	END
) AS High_Severity_Incidents,

SUM(
	CASE
		WHEN i.Severity = 'High' THEN 3
		WHEN i.Severity = 'Medium' THEN 2
		WHEN i.Severity = 'Low' THEN 1
		ELSE 0
	END
) AS Incident_Severity_Score

FROM ai_systems AS a
JOIN departments AS d
ON a.Department_ID = d.Department_ID
JOIN risk_assessments AS r
ON a.AI_System_ID = r.AI_System_ID
JOIN ai_incidents AS i
ON a.AI_System_ID = i.AI_System_ID

WHERE r.Risk_Level IN ('High', 'Critical')

GROUP BY
a.AI_System_ID,
a.System_Name,
d.Department_Name,
r.Overall_Risk_Score,
r.Risk_Level

ORDER BY
High_Severity_Incidents DESC,
Incident_Severity_Score DESC,
r.Overall_Risk_Score DESC;

-- Query 7: AI Systems with Overdue Governance Controls
SELECT
    a.AI_System_ID,
    a.System_Name,
    d.Department_Name,
    r.Risk_Level,
    r.Overall_Risk_Score,
    COUNT(c.Control_ID) AS Overdue_Controls
FROM governance_controls AS c
JOIN ai_systems AS a
    ON c.AI_System_ID = a.AI_System_ID
JOIN departments AS d
    ON a.Department_ID = d.Department_ID
JOIN risk_assessments AS r
    ON a.AI_System_ID = r.AI_System_ID
WHERE date(c.Next_Review_Date) < date('2026-09-28')
GROUP BY
    a.AI_System_ID,
    a.System_Name,
    d.Department_Name,
    r.Risk_Level,
    r.Overall_Risk_Score
ORDER BY
    Overdue_Controls DESC,
    r.Overall_Risk_Score DESC;

-- Query 8: AI Systems Requiring Immediate Governance Attention

WITH Weak_Controls AS (
    SELECT
        AI_System_ID,
        COUNT(*) AS Weak_Control_Count
    FROM governance_controls
    WHERE Control_Status IN ('Missing', 'Partial')
       OR Control_Effectiveness IN ('Not Effective', 'Partially Effective')
    GROUP BY AI_System_ID
),

Incident_Summary AS (
    SELECT
        AI_System_ID,
        COUNT(*) AS Total_Incidents,

        SUM(
            CASE
                WHEN Severity = 'High' THEN 1
                ELSE 0
            END
        ) AS High_Severity_Incidents

    FROM ai_incidents
    GROUP BY AI_System_ID
)

SELECT
    a.AI_System_ID,
    a.System_Name,
    d.Department_Name,
    r.Overall_Risk_Score,
    r.Risk_Level,

    COALESCE(w.Weak_Control_Count, 0) AS Weak_Controls,

    COALESCE(i.Total_Incidents, 0) AS Total_Incidents,

    COALESCE(i.High_Severity_Incidents, 0)
        AS High_Severity_Incidents,

    ROUND(
        r.Overall_Risk_Score
        + COALESCE(w.Weak_Control_Count, 0) * 0.5
        + COALESCE(i.High_Severity_Incidents, 0) * 1.0,
        2
    ) AS Governance_Priority_Score

FROM ai_systems AS a

JOIN departments AS d
    ON a.Department_ID = d.Department_ID

JOIN risk_assessments AS r
    ON a.AI_System_ID = r.AI_System_ID

LEFT JOIN Weak_Controls AS w
    ON a.AI_System_ID = w.AI_System_ID

LEFT JOIN Incident_Summary AS i
    ON a.AI_System_ID = i.AI_System_ID

WHERE r.Risk_Level IN ('High', 'Critical')

ORDER BY Governance_Priority_Score DESC;
