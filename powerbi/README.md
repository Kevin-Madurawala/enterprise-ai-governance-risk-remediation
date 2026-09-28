# Power BI Report

The final report was built in Power BI Desktop from the corrected CSV source tables in `/data`.

## Data model

- `departments[Department_ID]` **1 → many** `ai_systems[Department_ID]`
- `ai_systems[AI_System_ID]` **1 → 1** `risk_assessments[AI_System_ID]`
- `ai_systems[AI_System_ID]` **1 → many** `governance_controls[AI_System_ID]`
- `ai_systems[AI_System_ID]` **1 → many** `ai_incidents[AI_System_ID]`

## Core DAX measures

```DAX
Total AI Systems =
DISTINCTCOUNT(ai_systems[AI_System_ID])
```

```DAX
High-Risk Systems =
CALCULATE(
    DISTINCTCOUNT(ai_systems[AI_System_ID]),
    risk_assessments[Risk_Level] = "High"
)
```

```DAX
Critical Systems =
CALCULATE(
    DISTINCTCOUNT(ai_systems[AI_System_ID]),
    risk_assessments[Risk_Level] = "Critical"
)
```

```DAX
Control Coverage % =
DIVIDE(
    CALCULATE(
        COUNTROWS(governance_controls),
        governance_controls[Control_Status] = "Implemented",
        governance_controls[Control_Effectiveness] = "Effective"
    ),
    COUNTROWS(governance_controls),
    0
)
```

```DAX
Open Incidents =
CALCULATE(
    COUNTROWS(ai_incidents),
    ai_incidents[Status] IN {"Open", "Investigating"}
)
```

```DAX
High-Severity Incidents =
CALCULATE(
    COUNTROWS(ai_incidents),
    ai_incidents[Severity] = "High"
)
```

```DAX
Weak Controls =
CALCULATE(
    COUNTROWS(governance_controls),
    governance_controls[Control_Status] IN {"Missing", "Partial"}
        || governance_controls[Control_Effectiveness] IN {"Not Effective", "Partially Effective"}
)
```

## Report pages

1. **Executive Overview** — KPI cards, risk distribution, high/critical systems by department, Top 10 systems by inherent risk, control status/effectiveness, incident type/severity.
2. **AI Risk Analysis** — inherent risk by department and AI type, six risk-category averages, department-by-risk matrix.
3. **Governance & Controls** — control coverage by department, weak controls by category, detailed control-gap table.
4. **AI System Detail** — single-select system slicer with system-specific risk score, risk level, weak controls, incidents, controls, and incident history.

## Validated KPI outputs

| KPI | Value |
|---|---:|
| Total AI Systems | 50 |
| High-Risk Systems | 26 |
| Critical Systems | 5 |
| Control Coverage | 74% |
| Open / Investigating Incidents | 8 |
| High-Severity Incidents | 20 |

Static vector previews are stored in `/powerbi/screenshots` so the report can be reviewed directly in GitHub.
