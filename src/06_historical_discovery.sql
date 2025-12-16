-- =============================================================================
-- 6. HISTORICAL TRENDS
-- =============================================================================

-- What is the accumulated growth metabolites discovery historically?
WITH historical_discovery AS (
    SELECT m.molregno, MIN(d.year) AS "discovery_year"
    FROM metabolites m 
        JOIN compound_records cr
            ON m.molregno = cr.molregno
        JOIN docs d
            ON cr.doc_id = d.doc_id
    WHERE d.year IS NOT NULL
    GROUP BY m.molregno
)
SELECT 
    discovery_year, 
    COUNT(molregno) AS "metabolites_count",
    SUM(COUNT(molregno)) OVER(ORDER BY discovery_year) AS "accumulated_metabolites_count"
FROM historical_discovery
GROUP BY discovery_year
ORDER BY discovery_year ASC;