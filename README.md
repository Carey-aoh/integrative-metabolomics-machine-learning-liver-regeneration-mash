# integrative-metabolomics-machine-learning-liver-regeneration-mash

Official code for *"Integrative Untargeted Metabolomics and Machine Learning for Assessing Liver Regeneration After Partial Hepatectomy in MASH"*.

This repository implements a complete analytical pipeline for predicting liver regeneration in MASH (Metabolic dysfunction-associated steatohepatitis) using serum metabolomics data. The pipeline integrates multiple machine learning approaches to achieve high predictive performance.

## 🔍 Key Findings

- **High predictive accuracy**: Stacked ensemble model achieved **R² = 0.922** for predicting liver regeneration
- **Feature selection**: **5 key metabolites** identified by MUVR (Variable Selection in Multivariate Analysis)
- **Ensemble architecture**: Combines KNN, LASSO, Bayesian Ridge (BR), and Partial Least Squares (PLS) models

## 📊 Study Overview

| Aspect | Description |
| :--- | :--- |
| **Objective** | Predict liver regeneration after partial hepatectomy in MASH using serum metabolomics |
| **Key method** | Stacked ensemble machine learning (KNN + LASSO + BR + PLS) |
| **Feature selection** | MUVR (Variable Selection in Multivariate Analysis) |
| **Performance** | R² = 0.922 (5 selected metabolites) |

## 🧰 Requirements

- **R** (≥4.0)
  - Required packages: `MUVR`, `ggplot2`, `tidyverse`
- **Python** (≥3.8)
  - Required packages: `numpy`, `pandas`, `scikit-learn`, `matplotlib`, `seaborn`, `shap`

## 📁 Repository Structure
integrative-metabolomics-machine-learning-liver-regeneration-mash/
│
├── .gitignore # Git ignore file
│
├── python/
│ ├── Heatmap.ipynb # Metabolite heatmap visualization
│ └── ml+bootstrap+stacking+SHAP.ipynb # Core ML pipeline: bootstrap + stacking ensemble + SHAP
│
├── r/
│ ├── MUVR.R # Variable selection using MUVR
│ └── PCA+Trajectory.R # PCA analysis and trajectory visualization
│
├── output/
│ ├── figures/ # Generated plots (heatmaps, PCA, SHAP)
│ └── tables/ # Selected metabolites, model performance
│
├── README.md
└── LICENSE

## 🚀 Workflow

### Step 1: Variable Selection (R)
Run `r/MUVR.R` to identify the 5 most important metabolites for predicting liver regeneration.

### Step 2: PCA & Trajectory Analysis (R)
Run `r/PCA+Trajectory.R` to visualize metabolic profiles and regeneration patterns.

### Step 3: Heatmap Visualization (Python)
Run `python/Heatmap.ipynb` to generate heatmaps of selected metabolite expression.

### Step 4: Ensemble Model Training (Python)
Run `python/ml+bootstrap+stacking+SHAP.ipynb` to:
- Train stacked ensemble (KNN + LASSO + BR + PLS)
- Evaluate via bootstrap resampling
- Interpret predictions using SHAP
