-- =============================================================================
-- 1. VIEW SETUP & DATA CLEANING
-- =============================================================================

-- It is best to create a View with all metabolites filtered with their key (molregno and chembl_id),
-- since all following queries will be using metabolites data

-- Drop metabolites view if already exists
DROP VIEW IF EXISTS metabolites;

-- Select all metabolites from compound properties and molecule_dictionary.
-- Conditions for metabolites (WHERE clause):
--  - 50 <= cp.full_mwt <= 1500 (small size) and
--  - cp.full_molformula containing at least one "C" atom.
CREATE VIEW metabolites AS
SELECT m.molregno, m.chembl_id, cp.full_mwt, cp.full_molformula, m.pref_name AS "name"
FROM molecule_dictionary m
    JOIN compound_properties cp
        ON m.molregno = cp.molregno
WHERE (cp.full_mwt <= 1500
        AND cp.full_mwt >= 50
        AND cp.full_molformula LIKE "%C%")
GROUP BY m.molregno;

-- Check for duplicates
SELECT COUNT(molregno) - COUNT(DISTINCT(molregno)) AS "duplicates"
FROM metabolites;
-- No duplicates (0) found

-- How many metabolites there are in the ChEMBL database?
SELECT COUNT(DISTINCT(molregno))
FROM metabolites;
-- There are 2.833.449 metabolites in the ChEMBL database