# 🦀 Nuptial coloration in fiddler crabs as an indicator of reproductive quality 🦀
   
_Diogo J. A. Silva & Daniel M. A. Pessoa_
     
***
**Status**: Submitted
   
**Journal**: [Behavioral Ecology](https://academic.oup.com/beheco)

**DOI**: [****](****)

## Repository Overview

This repository contains the data, scripts, and outputs associated with the manuscript  
**“Nuptial coloration in fiddler crabs as an indicator of reproductive quality.”**

## Content of the repository

1. __data__: the `data` folder contains:  
    * The raw data, including spreadsheets with experimental data and reflectance measurements.
    * The processed versions of the experimental data.

2. __outputs__: the `outputs` folder contains:  
    * The figures generated for the manuscript (Figures 2, 3, 4, and 5).

3. __scripts__: the `scripts` folder contains:  
    * R scripts (.R) to import and clean reflectance and raw data, fit models, and generate figures used in the manuscript.

### Folder structure

-   📁 data
    -   📁 raw
        -   📁 nuptial_reflectance (contains crab reflectance spectra from field measurements)
        -   📁 reflectances (contains crab reflectance spectra from both field and lab measurements)
        -   📁 reflectancias_modelo (contains crab model reflectance spectra)
        -   🟩 dados_maturidade.xlsx (raw data spreadsheet from the gonadal maturity experiment)
        -   🟩 data_force.xlsx (raw data spreadsheet from the lab measurements)
        -   🟩 mate_choice.xlsx (raw data spreadsheet from the mate choice experiment)
        -   🟩 pfowl_transmittance.csv (peafowl ocular transmittance)
    -   📁 processed
         - 🟩 01_reflet_carapace_type.csv (reflectance spreadsheet)
         - 🟩 01_reflet_carapace_with_background.csv (reflectance spreadsheet with background)
         - 🟩 01_reflet_claw_color.csv (reflectance spreadsheet of claws from light and dark males)
         - 🟩 01_reflet_claw_type.csv (reflectance spreadsheet of leptochelous and brachychelous claws)
         - 🟩 03_data-force_clean.csv (cleaned version of data_force.xlsx)
         - 🟩 04_data_master.csv (main dataset used in data analysis)
         - 🟩 maturation_data_clean.csv (cleaned version of dados_maturidade.xlsx)
-   📁 outputs
    -    📁 figures
          - 📊 Figure_2_vismodel.png
          - 📊 Figure_3_morphofunctional-traits.png
          - 📊 Figure_4_gonadal-maturity.png
          - 📊 Figure_5_mate-choice.png
    -    📁 tables
          - 🟩 01_summary_cor.csv (colorimetric variables)
          - 🟩 01_vis-all.csv (visual model results)
          - 🟩 01_vismodel_carapace_color.csv (visual model results for carapace color)
          - 🟩 01_vismodel_fiddlercrab.csv (visual model results for fiddler crab vision only)
          - 🟩 01_visual-results.csv (visual model results with colorimetric variables)
          - 🟩 02_vis.results.clean.csv (cleaned visual model results with colorimetric variables)
          - 🟩 mann_whitney_result.csv (summary of Mann–Whitney test results)
          - 🟩 shapiro_test_result.csv (summary of Shapiro–Wilk test results)
-   📁 scripts
    -    🔵 00_ADD_reflectance-data.R (import procspec reflectance data, create a spreadsheet, and save it)
    -    🔵 01_C_reflectance-data.R (clean reflectance spreadsheet)
    -    🔵 01_D_vismodels.R (run visual models)
    -    🔵 02_C_data-force.R (clean data-force spreadsheet)
    -    🔵 02_C_vismodel-results.R (clean visual model results)
    -    🔵 03_ADD_data-master.R (create master dataset)
    -    🔵 03_D_mann-whitney_carapace-type.R (perform Mann–Whitney test for carapace type, i.e., light vs dark males)
    -    🔵 03_S_mann-whitney_carapace-type.R (plot boxplots for Mann–Whitney results, i.e., Figure_2_vismodels)
    -    🔵 04_D_glm_weight-and-force.R (fit models for weight and force)
    -    🔵 04_S_glm_weight-and-force.R (plot boxplots and scatterplots for fitted models)
    -    🔵 05_C_maturation.R (clean maturation data)
    -    🔵 05_D_maturation.R (run maturation statistics)
    -    🔵 05_S_maturation.R (plot stacked bar chart for maturation)
    -    🔵 06_D_mate-choice.R (fit binomial model and plot donut chart)
        

***
When using the __data available__ in this repository, please cite the original publication and dataset.

For any further information, contact: **diogojackson@hotmail.com**  

**Citation:**

> ****
   
***



