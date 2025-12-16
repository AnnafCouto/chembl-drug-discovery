-- =============================================================================
-- 5. BIOLOGICAL ACTIVITY & POTENCY
-- =============================================================================

-- What are the 10 most potent (smaller IC50) metabolites regarding activity in humans?
SELECT 
    m.pref_name AS name, 
    top_activities.ic50, 
    top_activities.units
FROM (
    SELECT 
        a.molregno, 
        a.standard_value AS "IC50", 
        a.standard_units AS "units"
    FROM activities a
        JOIN assays aa ON a.assay_id = aa.assay_id
        JOIN target_dictionary td ON aa.tid = td.tid
    WHERE a.standard_type = 'IC50'
        AND a.potential_duplicate = 0
        AND td.organism = 'Homo sapiens'
        AND a.standard_value IS NOT NULL
        AND a.standard_value > 0  
) AS top_activities 
JOIN molecule_dictionary m
    ON top_activities.molregno = m.molregno
WHERE m.pref_name IS NOT NULL
ORDER BY top_activities.IC50 ASC 
LIMIT 10;