-- =============================================================================
-- 3. CHEMICAL PROPERTIES DISTRIBUTION
-- =============================================================================

-- What is the metabolites mass (molecular weight) distribution?
-- Groups full_mwt into bins of 50, starting from 50, and ending in 1500.
SELECT 
    (CAST(full_mwt / 50 AS INT) * 50) AS "mass_range_start",
    (CAST(full_mwt / 50 AS INT) * 50) || ' - ' || ((CAST(full_mwt / 50 AS INT) * 50) + 50) AS "bin_label",
    COUNT(molregno) AS "count"
FROM metabolites
GROUP BY mass_range_start
ORDER BY mass_range_start ASC;