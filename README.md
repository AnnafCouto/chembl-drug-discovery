# ChEMBL Drug Discovery Analytics 🧬📊

![Python](https://img.shields.io/badge/Python-3.10%2B-blue?style=flat&logo=python)
![SQL](https://img.shields.io/badge/SQL-Advanced-orange?style=flat&logo=sqlite)
![Database](https://img.shields.io/badge/Database-ChEMBL%20v36-green)
![Status](https://img.shields.io/badge/Status-Completed-success)
![License](https://img.shields.io/badge/License-MIT-purple)

## 📌 Project Overview

This project utilizes **Advanced SQL** and **Python** to extract actionable business and scientific insights from **ChEMBL**, a large-scale open bioactivity database managed by EMBL-EBI.

Leveraging my background as a **Biotechnologist and MSc in Analytical Chemistry**, I acted as a Data Analyst to transform **complex relational scientific data** into intelligence regarding pharmaceutical market trends, product quality compliance (Lipinski's Rule), and bioactivity profiling.

**Key Objectives:**
1.  **Scientific Impact:** Evaluate the "popularity" of compounds based on academic citations and identify key publishing journals.
2.  **Market Trends:** Analyze the historical evolution of metabolite discovery using Time Series logic.
3.  **Data Validation:** Audit approved drugs against "Lipinski's Rule of 5" to measure theoretical compliance vs. real-world application.
4.  **Target Analysis:** Filter and rank high-potency compounds for human targets using complex multi-table joins.

---

## 🛠️ Tech Stack & Skills

* **Database:** SQLite (ChEMBL Database Version 36).
* **Languages:** SQL (Dialect: SQLite), Python (Pandas, Matplotlib/Seaborn).
* **Tools:** DBeaver (SQL execution), VS Code (Scripting).
* **Key SQL Techniques:**
    * ✅ **Window Functions** (`SUM() OVER`) for running totals (cumulative analysis).
    * ✅ **CTEs (Common Table Expressions)** for modularizing complex logic.
    * ✅ **Advanced Joins** connecting 4+ tables (Metabolites → Activities → Assays → Targets).
    * ✅ **Data Cleaning** (Handling `NULL`s, String Manipulation, Deduplication).

---

## 🗂 Repository Structure

The SQL logic is modularized into 6 sequential scripts to ensure reproducibility and maintainability:

* **`01_setup_views.sql`**: Initial setup and data cleaning (creating Views with molecular weight filters).
* **`02_scientific_literature.sql`**: Bibliometric analysis (citations and top journals).
* **`03_mass_distribution.sql`**: Physical property distribution (Data Binning).
* **`04_drug_properties.sql`**: "Druggability" audit (Lipinski's Rule validation).
* **`05_activity_potency.sql`**: Potency ranking (IC50) for *Homo sapiens* targets.
* **`06_historical_discovery.sql`**: Time-series analysis of discovery trends.

---

## 📊 Business Questions & Insights

### 1. Scientific Literature Evaluation 📚
**The Business Question:** *Which metabolites drive the most academic research and which journals are the primary sources of this knowledge?*

**The Solution:** Aggregated citation counts from the `docs` and `compound_records` tables.

#### **A. Top 10 Most Cited Metabolites**
> **Insight:** The analysis reveals that established antibiotics (e.g., **ciprofloxacin, rifampin, vancomycin**) and chemotherapy agents (e.g., **doxorubicin, paclitaxel**) dominate scientific literature. The high prominence of **Chloroquine** reflects the surge in drug repurposing research related to recent global health crises (COVID-19).

| Rank | Metabolite Name | Citations (DOI) |
| :--- | :--- | :--- |
| 1 | DOXORUBICIN | 2323 |
| 2 | CIPROFLOXACIN | 1668 |
| 3 | PACLITAXEL | 1387 |
| 4 | CHLOROQUINE | 1316 |
| 5 | RIFAMPIN | 1111 |

#### **B. Top Journals by Metabolite Mentions**
> The *Journal of Medicinal Chemistry* stands out as the leading repository of bioactivity data.

| Rank | Journal Name | Metabolite Mentions |
| :--- | :--- | :--- |
| 1 | J Med Chem | 653,827 |
| 2 | Bioorg Med Chem Lett | 445,282 |
| 3 | Eur J Med Chem | 297,752 |

---

### 2. "Lipinski's Rule of 5" Compliance Audit ⚖️

> **Concept Note:** Lipinski's Rule of 5 (Ro5) is a guideline used to predict oral "druggability." Poor absorption is likely if a compound violates specific thresholds (MW > 500, LogP > 5, etc.).

**The Business Question:** *What percentage of approved oral drugs actually strictly follow Lipinski's Rule of 5?*

**The Solution:** Calculated compliance percentages using conditional aggregation, strictly filtering for `max_phase = 4` (Approved) and `oral = 1`.

| Ro5 Violations | Count of Drugs | Percentage |
| :--- | :--- | :--- |
| **0 (Compliant)** | **1,418** | **77.36%** |
| 1 | 256 | 13.97% |
| 2 | 143 | 7.80% |
| 3 | 15 | 0.82% |

> **Insight:** The analysis demonstrates that **77% of approved oral drugs are fully compliant**. However, nearly **22% of successful drugs violate at least one criterion**, reinforcing that while Ro5 is an excellent screening tool, it is not an absolute barrier for drug success.

![Lipinski Violations Chart](images/lipinski_violations.png)
*(Chart generated via Python)*

---

### 3. Bioactivity & Potency Profiling 🎯

**The Business Question:** *Which metabolites show the highest potency (lowest IC50) specifically against Homo sapiens targets?*

**The Solution:** Executed a 4-level JOIN strategy to link chemical structures to biological targets, ensuring correct organism filtering and data quality.

> **Result:** The query successfully extracted a ranked list of compounds with activity in the picomolar/nanomolar range, which are critical candidates for the initial phases of Drug Discovery.

---

### 4. Historical Evolution of Drug Discovery 📈
**The Business Question:** *How has the volume of new metabolite discoveries evolved over the last decades?*

**The Solution:** Utilized `GROUP BY` on publication years and a **Window Function** to calculate the cumulative sum (running total) of discoveries.

| Year | New Metabolites | Accumulated Total |
| :--- | :--- | :--- |
| ... | ... | ... |
| 1990 | 9,607 | 87,825 |
| 1995 | 15,921 | 156,914 |
| ... | ... | ... |

> **Insight:** The analysis shows a consistent exponential growth in the identification of new metabolites, accelerating significantly after the year 2000. This is likely driven by the advent of High-Throughput Screening (HTS) and High-Resolution Mass Spectrometry (HRMS) technologies.

![Historical Evolution Graph](images/historical_growth.png)
*(Chart generated via Python)*

---

## 📚 References

1.  **Data & Analysis:** Couto, A. C. (2025). *ChEMBL Drug Discovery Analytics: Portfolio Project*.
2.  Benet, L. Z., Hosey, C. M., Ursu, O., & Oprea, T. I. (2016). BDDCS, the Rule of 5 and Drugability. *Advanced Drug Delivery Reviews*, 101, 89–98.
3.  Lambev, M., Mihaylova, S., & Georgieva, D. (2025). Machine Learning-Based Prediction of Rule Violations for Drug-Likeness Assessment in Peptide Molecules Using Random Forest Models. *International Journal of Molecular Sciences*, 26(17), 8407.
4.  Sebaugh, J. L. (2011). Guidelines for accurate EC50/IC50 estimation. *Pharmaceutical Statistics*, 10(2), 128–134.

---

## ⚖️ License & Data Attribution

**Code License:** MIT License.

**Data Source:**
This analysis uses data from **ChEMBL** (EMBL-EBI), licensed under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/).

---

### 📬 Contact
**Anna Clara Couto**
* [LinkedIn](https://www.linkedin.com/in/annacouto/)
