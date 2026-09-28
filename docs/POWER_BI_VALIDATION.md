# Power BI Final Validation

The final PBIX was refreshed against the corrected source data and the report structure was rechecked after refresh.

## Confirmed KPI values

- Total AI Systems: **50**
- High-Risk Systems: **26**
- Critical Systems: **5**
- Control Coverage: **74%**
- Open / Investigating Incidents: **8**
- High-Severity Incidents: **20**

## Confirmed report pages

1. **Executive Overview** — KPI cards, risk distribution, departmental exposure, controls, incidents, Top 10 inherent-risk systems
2. **AI Risk Analysis** — department/AI-type averages, six-category risk comparison, department risk matrix
3. **Governance & Controls** — control coverage, weak-control categories, detailed control-gap table
4. **AI System Detail** — single-select system slicer, risk score, risk level, weak controls, incidents, control detail, incident detail

## Final report checks

- Top 10 inherent-risk visual uses the average Overall Risk Score and descending sort.
- Control Coverage axis is formatted as a percentage.
- AI System Detail slicer uses single selection and filters cards/tables correctly.
- Page 4 card labels are simplified to Risk Score, Risk Level, Weak Controls, and Incidents.
- The final screenshots and PBIX in the repository reflect the corrected source data.
