

---

# REAL IMPACT OF DWELL TIMES BETWEEN CASH, TOTO, MOBILE APP, AND KEYCARD – B&H BUSES

## Overview

This project focuses on understanding how **dwell times** (the time a bus spends at a stop) are influenced by various factors, such as payment methods and ticket types. By analyzing data from the Route 7 bus service in Brighton, UK, the project aims to uncover inefficiencies and propose strategies to enhance passenger boarding and operational efficiency.

---

## Objectives

The primary goals of this project are:
1. To determine how different payment methods (cash, TOTO, mobile app, keycard) impact dwell times.
2. To analyze passenger behaviors, such as boarding patterns and ticket usage.
3. To identify hidden trends and correlations in the data that can inform policy and operational decisions.
4. To propose actionable recommendations for improving bus service efficiency.

---

## Key Features

### 1. **Data Cleaning and Preprocessing**
   - Reads and processes data from three Excel files: `Route_7_Concessionary_data_Ticketer.xlsx`,ticketData from E.P. 
     Morris,Route_7_GPS_data
   - Handles missing data using visualization tools like `missingno` and implements strategies for imputation or exclusion.
   - Renames and restructures columns for clarity and usability in analysis.
   - Proportional Imputations for columns.

### 2. **Exploratory Data Analysis (EDA)**
   - Generates descriptive statistics to summarize key features of the dataset.
   - Visualizes the distribution of dwell times across different payment methods.
   - Explores relationships between ticket sub-classes and trip characteristics.

### 3. **Statistical Modeling**
   - Implements regression models using `statsmodels` to assess the statistical significance of various factors affecting 
     dwell times.
   - Tests hypotheses regarding the efficiency of different payment methods.
   - Implements Cross validation and feature importance.

### 4. **Data Visualization**
   - Creates detailed plots using `matplotlib` and `seaborn`, such as:
     - Boxplots and histograms to analyze the distribution of dwell times.
     - Heatmaps to identify missing data patterns.
     - Pairplots and correlation matrices to explore relationships between variables.

## Results and Insights

### Expected Outcomes:
- **Payment Methods Analysis**:
  Quantitative comparison of dwell times based on different payment modes, highlighting the most efficient method.
- **Passenger Boarding Efficiency**:
  Insights into how ticket classes and transaction times influence boarding speed.
- **Operational Improvements**:
  Data-driven recommendations for reducing dwell times and improving passenger flow.

### Example Visuals:
- Heatmaps to identify missing data patterns and correlations.
- Boxplots comparing dwell times across payment methods.
- Regression output tables summarizing key predictors of dwell times.

---

## Dataset Details

The data is sourced from three separate dataset:
- **ticketData from E.P. Morris**: Companies database.
- **Route_7_Concessionary_data_ticketer from the Ticketer system**: database from bus ticketer machine.
- **Route_7_GPS_data**: Satelite data.

---

## Technologies and Libraries

The project relies on the following tools and libraries:
- **Data Manipulation and Analysis**:
  - `pandas` for managing structured data.
  - `numpy` for numerical computations.
- **Visualization**:
  - `matplotlib` and `seaborn` for plotting and graphing insights.
- **Statistical Analysis**:
  - `statsmodels` for regression analysis and hypothesis testing.
- **Data Preprocessing**:
  - `missingno` for identifying and handling missing values.
- **Machine Learning** (if applicable in further analysis):
  - `sklearn` for preprocessing and advanced modeling.

---

## Usage Guide

1. Open the Jupyter Notebook:
   ```bash
   jupyter notebook B&H Buses.ipynb
   ```

2. Follow the step-by-step instructions within the notebook to:
   - Load and preprocess the dataset.
   - Conduct exploratory data analysis (EDA).
   - Build and interpret statistical models.
   - Visualize and interpret the results.

3. Use the insights to identify operational inefficiencies and suggest improvements.

---



---

## Folder Structure

```
Final-Year-Project-Python/
├── B&H BUSES.ipynb   # Jupyter Notebook containing the analysis
├── B&H BUSES.html
├── Route_7_Concessionary_data_Ticketer.xlsx   # Dataset
├── ticketData.csv           # dataset
├── Route_7_GPS_Data.xlsx    # dataset
├── Final Year project-Updated.pdf   # pdf file
└── README.md                  # Project documentation
```



## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

Let me know if there’s anything else you'd like to refine or add!

