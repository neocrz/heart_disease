# Heart Disease — Clinical Factor Analysis

**Language:** English · [Português (Brasil)](README.pt-BR.md)

Exploratory and predictive analysis of the **UCI Heart Disease (Cleveland)** dataset.
The project studies how clinical and demographic variables relate to the presence of
coronary disease and compares five classification models for the diagnosis task.

The analysis lives in [`note.ipynb`](note.ipynb) (written in Portuguese).

## Overview

- **Goal:** identify which clinical variables are associated with angiographic heart
  disease and evaluate how well different classifiers can predict it.
- **Data:** 303 patients, 13 predictors, 1 binary target.
- **Methods:** distribution analysis, Cramér's V (categorical), ANOVA (numeric),
  correlation heatmap, and five supervised models.
- **Outcome:** `Random Forest` performed best (86% accuracy, AUC 0.921); chest pain
  type and heart condition showed the strongest association with the diagnosis.

## Dataset

| Item | Value |
| --- | --- |
| Name | Heart Disease |
| Source | [UCI ML Repository — dataset 45](https://archive.ics.uci.edu/dataset/45/heart+disease) |
| Patients | 303 |
| Features | 13 |
| Target | `num` — 0 = no disease (164), 1 = disease (139) |
| Missing values | None in the cached CSVs (imputed during loading) |
| License | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode) |

The original `num` column has values 0–4. It is binarized to `0` (no disease) and
`1` (any degree of disease). `ca` is filled with its mean and `thal` with its mode
when the raw dataset is downloaded.

### Variables

| Column | Meaning | Type |
| --- | --- | --- |
| `age` | Age (years) | Numeric |
| `sex` | Gender (0 = female, 1 = male) | Categorical |
| `cp` | Chest pain type (1–4) | Categorical |
| `trestbps` | Resting blood pressure (mm Hg) | Numeric |
| `chol` | Serum cholesterol (mg/dL) | Numeric |
| `fbs` | Fasting blood sugar > 120 mg/dL | Categorical |
| `restecg` | Resting ECG results (0–2) | Categorical |
| `thalach` | Maximum heart rate achieved (bpm) | Numeric |
| `exang` | Exercise-induced angina | Categorical |
| `oldpeak` | ST depression induced by exercise (mm) | Numeric |
| `slope` | Slope of peak ST segment (1–3) | Categorical |
| `ca` | Number of major vessels (0–3) | Numeric |
| `thal` | Heart condition (3, 6, 7) | Categorical |
| `num` | Diagnosis — target | Categorical |

Column descriptions are available in [`data_dict.csv`](data_dict.csv) (English) and
[`data_dict_pt.csv`](data_dict_pt.csv) (Portuguese).

## Repository structure

```
.
├── note.ipynb            # Full analysis notebook (EDA + statistics + models)
├── data/
│   ├── datasetX.csv      # Cached feature matrix (303 × 13)
│   └── datasety.csv      # Cached target column (303 × 1)
├── data_dict.csv         # Data dictionary (English)
├── data_dict_pt.csv      # Data dictionary (Portuguese)
├── flake.nix             # Nix dev shell with Python 3.11 + scientific stack
├── ucimlrepo.nix         # Local package definition for ucimlrepo
├── .envrc                # direnv integration (`use flake`)
├── README.md             # English documentation
└── README.pt-BR.md       # Portuguese (Brazil) documentation
```

## Methodology

1. **Loading and cleaning** — load cached CSVs, or fetch from UCI with `ucimlrepo`
   and impute missing values when the cache is absent. The binarized dataset is then
   written back to `data/`.
2. **Exploratory analysis** — histograms and KDE for numeric variables, bar charts for
   categorical variables, and the target distribution.
3. **Inferential statistics**
   - Cramér's V (via chi-square) to measure association between categorical features
     and the target.
   - One-way ANOVA to compare numeric feature means across diagnosis groups.
   - A correlation heatmap combining Pearson (numeric) and Cramér's V (categorical)
     coefficients against the target.
4. **Modeling** — 70/30 train–test split (`random_state=42`, 212 train / 91 test).
   Logistic Regression uses a `ColumnTransformer` with `StandardScaler` and
   `OneHotEncoder`; the other models are trained on the raw feature matrix.
5. **Evaluation** — classification report (precision, recall, F1), accuracy, AUC-ROC,
   ROC curves, confusion matrices, and Random Forest feature importance.

## Models and results

| Model | Accuracy | Macro F1 | AUC-ROC |
| --- | :---: | :---: | :---: |
| Logistic Regression | 0.81 | 0.81 | 0.896 |
| Decision Tree | 0.77 | 0.77 | 0.753 |
| **Random Forest** | **0.86** | **0.86** | **0.921** |
| Gaussian Naive Bayes | 0.80 | 0.80 | 0.881 |
| Neural Network (MLP 50-30) | 0.70 | 0.70 | 0.833 |

## Key findings

- **Strongest associations with diagnosis:** chest pain type (`cp`, V = 0.520) and
  heart condition (`thal`, V = 0.522), followed by exercise-induced angina
  (`exang`, 0.425) and ST slope (`slope`, 0.389).
- **Significant numeric differences** between diagnosis groups: age, resting blood
  pressure, maximum heart rate, ST depression, and number of vessels (p < 0.05).
- **Cholesterol (`chol`) was not significant** (p = 0.139) and showed weak
  discriminative power in this sample.
- **Random Forest** delivered the best balance of accuracy and AUC. Its top features
  were chest pain (0.149), heart condition (0.147), number of vessels (0.139), and
  maximum heart rate (0.104).

## Getting started

### Requirements

- [Nix](https://nixos.org/) with flakes enabled (recommended), or Python 3.11 with
  the packages listed in `flake.nix`.

### Setup

```bash
# Option A: direnv
direnv allow

# Option B: enter the dev shell directly
nix develop
```

The dev shell provides JupyterLab, pandas, NumPy, SciPy, scikit-learn, seaborn,
matplotlib, imbalanced-learn, XGBoost, and a locally packaged `ucimlrepo`.

### Run the analysis

```bash
jupyter lab note.ipynb
```

If `data/datasetX.csv` and `data/datasety.csv` are missing, the notebook downloads
the dataset from UCI, cleans it, and caches both files in `data/`.

## Limitations and next steps

- Small sample (303 patients) and a single holdout split; cross-validation would give
  more stable estimates.
- No systematic hyperparameter tuning.

## License

The dataset is distributed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode).
