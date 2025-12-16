-- =============================================================================
-- 2. SCIENTIFIC LITERATURE EVALUATION
-- =============================================================================

-- A. Top 10 Most Cited Metabolites
SELECT 
    m.name, 
    COUNT(d.doi) AS "citations"
FROM metabolites m 
    JOIN compound_records cr
        ON m.molregno = cr.molregno
    JOIN docs d
        ON cr.doc_id = d.doc_id
GROUP BY m.molregno
ORDER BY COUNT(d.doi) DESC 
LIMIT 10;

-- B. Top 10 Journals by Metabolite Mentions
SELECT 
    d.journal, 
    COUNT(m.molregno) AS "metabolites_mentions"
FROM metabolites m 
    JOIN compound_records cr
        ON m.molregno = cr.molregno
    JOIN docs d
        ON cr.doc_id = d.doc_id
GROUP BY d.journal
HAVING d.journal IS NOT NULL
ORDER BY COUNT(m.molregno) DESC 
LIMIT 10;