# 🦀 Nuptial coloration in fiddler crabs as an indicator of reproductive quality 🦀
[![DOI](https://zenodo.org/badge/971561730.svg)](https://doi.org/10.5281/zenodo.17410848)
   
_Diogo J. A. Silva & Daniel M. A. Pessoa_
     
***
**Status**: Accepted
   
**Journal**: [Behavioral Ecology](https://academic.oup.com/beheco)
   
**Paper citation**: ****
   
## Abstract 
   
Why do some male fiddler crabs turn white in mating season? Our study reveals this color change signals maturity and greater attractiveness to females. In many animals, bright colors help attract mates, but we did not understand what the white coloration meant in these crabs. By comparing white vs. dark males, we discovered the white color honestly reveals a male's
development and reproductive potential, helping females choose the best reproductive mates in mudflats. In this repository, you will find coloration data (reflectance) of the body of males and females, as well as the spreadsheets from the associated experiments.

## Date of data collection

All data described in the paper (force, color, size, and mass measurements) were collected 
between April and December 2022. Data on gonadal maturity were collected from May to July 2023, 
while data on mate selection were collected in October 2024.

## Geographic location of data collection

Barra do Rio – Extremoz – Rio Grande do Norte, Brazil (5°40’36.5” S 35°13’20.5” W).

## Information about funding sources that supported the collection and curation of the data

This work was supported by the Coordenacao de Aperfeicoamento de Pessoal de Nivel Superior - CAPES (grant numbers 001, 043/2012); the Conselho Nacional de Desenvolvimento Cientifico e Tecnologico – Brazil (grant numbers 478222/2006-8, 474392/2013-9); and the Programa de Apoio aos Nucleos de Excelencia – FAPERN/CNPq (grant number 25674/2009). 

## ACCESS INFORMATION

CC0 1.0 Universal (Public Domain Dedication)

## Content of the repository
   
1. __data__: the `data` folder contains:  
    * The raw data, including spreadsheets with experimental data and reflectance measurements.
    * The processed versions of the experimental data.
   
2. __outputs__: the `outputs` folder contains:  
    * The figures generated for the manuscript (Figures 2, 3, 4, and 5).
   
3. __scripts__: the `scripts` folder contains:  
    * R scripts (.R) to import and clean reflectance and raw data, fit models, and generate figures used in the manuscript.
   
### Folder structure and variables

-   📁 data
    -   📁 raw
        -   📁 nuptial_reflectance (contains crab reflectance spectra in procspec files from field measurements)
        -   📁 reflectances (contains crab reflectance spectra from both field and lab measurements)
        -   📁 reflectancias_modelo (contains crab model reflectance spectra)
        -   🟩 dados_maturidade.xlsx (raw data spreadsheet from the gonadal maturity experiment)   
            __Variables__:   
                  • _ID_: ID of individual crabs.  
                  • _sexo_: sex of the crabs (male or female).  
                  • _cor_: color of the crabs (a = yellow, b = white or bright, e = dark carapace).  
                  • _quela_h_: claw length (mm).  
                  • _quela_v_: claw width (mm).  
                  • _cara_h_: carapace length (mm).  
                  • _cara_v_: carapace width (mm).  
                  • _maturacao_: gonadal maturation status (RU = rudimentary, ED = developing, DE = developed).  
                  • _data_: date of collection.  
        -   🟩 data_force.xlsx (raw data spreadsheet from the lab measurements)   
            __Variables__:   
                  • _ID_: crab ID.  
                  • _claw_size_: claw length (mm).  
                  • _carapace_size_: carapace width (mm).  
                  • _claw_type_: whether it was original (brachychelous) or regenerated (leptochelous).  
                  • _carapace_color_: whether it was white (b) or dark (e).  
                  • _force1_: first claw pinch force measurement.  
                  • _force2_: second claw pinch force measurement.  
                  • _force3_: third claw pinch force measurement.  
                  • _max_force_: the strongest claw pinch measurement.  
                  • _weight_mg_: claw mass in milligrams.  
                  • _weight_g_: claw mass in grams.  
                  • _data_: collection date.
        -   🟩 mate_choice.xlsx (raw data spreadsheet from the mate choice experiment)   
            __Variables__:   
                  • _ID_: crab ID   
                  • _color_: carapace color of the crab (white or dark)   
                  • _choice_: if the famale choose a male (1) or not choose (0)   
                  • _no_choice_: number of females that made no choice   
                  • _experimento_: if it was a pilot experiment or oficial experiment   
                  • _date_: collection date   
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
          - 📊 Figure_mate-choice.png
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
        
## SOFTWARE VERSIONS
   
R version 4.5.2 (2025-10-31 ucrt)   
   
# loaded packages and versions:   
   
 • tidyverse: 2.0.0   
 • pavo: 2.9.0   
 • colorspec: 1.0.0 #remotes::install_github("Diogojackson/colorspec/colorspec")   
 • dplyr: 1.1.4   
 • readxl: 1.4.5   
 • inspectdf: 0.0.12.1   
 • forcats: 1.0.1   
 • rstatix: 0.7.3   
 • broom: 1.0.10   
 • cowplot: 1.2.0   
 • ggpubr: 0.6.2   
 • ggdist: 3.3.3   
 • car: 3.1.5   
 • fitdistrplus: 1.2.6   
 • caret: 7.0.1   
 • performance: 0.16.0   

***
When using the __data available__ in this repository, please cite the original publication and dataset.

For any further information, contact: **diogojackson@hotmail.com**  

**Citation:**

> ****
   
**Dataset DOI:**
   
[![DOI](https://zenodo.org/badge/971561730.svg)](https://doi.org/10.5281/zenodo.17410848)
   
> Diogo Silva. (2025). DiogoJackson/nuptial_manuscript: First release (FirstRelease). Zenodo. https://doi.org/10.5281/zenodo.17410849

***

