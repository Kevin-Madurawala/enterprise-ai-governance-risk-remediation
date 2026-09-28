# Data Audit & Corrections

## Corrections made

- Fixed the shifted `risk_assessments` mapping. `AI001` remains unchanged; risk dimensions for `AI002`–`AI050` were realigned to the correct systems.
- Removed the orphan 51st risk-assessment row with blank IDs.
- Recalculated all weighted overall risk scores and risk levels from the six risk dimensions.
- Updated the remediation plan to replace `AI034` with the corrected top-five system `AI015 — Access Risk Analyzer`.
- Updated the project timeline so the access-risk validation work matches the corrected remediation plan.
- Corrected spreadsheet labels `Dependancy` → `Dependency` and `Success Matrics` → `Success Metrics`.
- Updated Query 7's portfolio snapshot date to `2026-09-28`.

## Validated core counts

- Departments: 9
- AI systems: 50
- Risk assessments: 50
- Governance controls: 150
- AI incidents: 40
- Controls per AI system: 3

## Correct risk distribution

- Critical: 5
- High: 26
- Moderate: 17
- Low: 2

## Correct critical systems

- AI001 — Resume Screening Assistant (4.20)
- AI010 — Internal Knowledge Assistant (4.10)
- AI015 — Access Risk Analyzer (4.15)
- AI033 — Customer Credit Risk Model (4.50)
- AI046 — Employee Attrition Predictor (4.55)

## Governance Priority Score — corrected top five

1. AI033 — Customer Credit Risk Model: 7.50
2. AI046 — Employee Attrition Predictor: 6.55
3. AI001 — Resume Screening Assistant: 6.20
4. AI010 — Internal Knowledge Assistant: 6.10
5. AI015 — Access Risk Analyzer: 5.65

## Expected Power BI KPI values after refresh

- Total AI Systems: 50
- High-Risk Systems: 26
- Critical Systems: 5
- Control Coverage: 74%
- Open / Investigating Incidents: 8
- High-Severity Incidents: 20

No broken foreign keys, duplicate AI/control/incident IDs, invalid 1–5 risk values, or reversed control dates were found in the corrected source data.
