-- =============================================================================
-- 4. DRUGGABILITY & LIPINSKI RULES
-- =============================================================================

-- How much of the metabolites have proven biological activity as oral drugs (clinical trials passed phase 4)
-- but don't conform to the Lipinski's rule of 5?
SELECT 
    cp.num_ro5_violations AS "violations", 
    COUNT(m.molregno) AS "drugs", 
    ROUND(COUNT(m.molregno) * 100.0 / SUM(COUNT(m.molregno)) OVER (), 2) || " %" AS "drugs_percentage"
FROM metabolites m 
    JOIN molecule_dictionary md
        ON m.molregno = md.molregno
    JOIN compound_properties cp
        ON m.molregno = cp.molregno
WHERE (md.max_phase = 4
        AND md.oral = 1
        AND cp.num_ro5_violations IS NOT NULL)
GROUP BY cp.num_ro5_violations
ORDER BY cp.num_ro5_violations DESC;