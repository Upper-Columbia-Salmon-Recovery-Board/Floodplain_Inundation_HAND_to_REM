---
title: "Floodplain Inunidation Calculation"
output: html_document
date: "2023-08-28"
---


# Steps to Generate Floodplain Inundation Map

### Step 1: Generate Relative Elevation Models (REMs)

Use [RiverREM](https://github.com/OpenTopography/RiverREM) or [GGL Tool](https://github.com/helstab/GGLREM) to generate REM in reach(es). This requires DTMs in .tif format at using python to run the RiverREM model. TIF needs to be in GCS_WGS_1984 projection.

### Step 2: Generate Discharge of desired flood return interval

Pull discharge from [VIC hydorologic model data](https://www.fs.usda.gov/research/rmrs/projects/us-stream-flow-metrics). These data include a 1.5-year, 10-year, and 25-year peak discharge.

### Step 3:  Generate wetted area at flood discharge for reach(es)  

Generate Velocity from flood discharge (from VIC). Use the [Oak Ridge National Laboratory Continental floodplain inundation mapping](https://cfim.ornl.gov/data/) project which was established to generate continental Height Above Nearest Drainage (HAND) data. These data are used in this process to identify the wetted area based on a given VIC discharge. The wetted area can be found in the hydrogeo-fulltable-HUCID.csv table, and the CatchID can be pulled from the catchmask.tif	(which both can be downlaoded from the ORNL website). Note this data set assumes a Manning's roughness of 0.05 to calculate stream velocity.

### Step 4: Calculate flood stage height from cross-sectional elevation profile

At each point along the reach where one generates a wetted area, in R  generate elevation profile. This uses the {Calculate_elevation_profile_from_REM.R}(https://github.com/Upper-Columbia-Salmon-Recovery-Board/Floodplain_Inundation_HAND_to_REM/blob/main/Calculate_elevation_profile_from_REM.R) script which pulls the function from the [FUNCTION_calculate_flood_stage_height.R](https://github.com/Upper-Columbia-Salmon-Recovery-Board/Floodplain_Inundation_HAND_to_REM/blob/main/FUNCTION_calculate_flood_stage_height.R) This script uses the “extract” function from the [raster package](https://rspatial.org/raster/pkg/1-introduction.html) to generation the cross-section elevation profile. Then the Water_Area_Fxn function uses incremental stage height steps to "fill up" the profile until the cross-sectional area inundated is equal to the wetted area from the previous step. This value is the "stage height" for the next step.

### Step 5: Map the floodplain inundation

With the REM (from Step 1) – map the floodplain based on the stage height from Step 4. For a continuous floodplain, merge all inundated reach sections.

# How to Run the Code

### Runing the Code 
The [**Main_script_generate_flood_stage_height.R**](https://github.com/Upper-Columbia-Salmon-Recovery-Board/Floodplain_Inundation_HAND_to_REM/blob/main/MAIN_script_generate_flood_stage_height.R) is the script that reads in the R libraries, sets parameters, reads in the spreadsheet with reach/transect information, and reads in and loops through the functions. This Main script runs the first function [**FUNCTION_pull_wetted_area_from_discharge.R**](https://github.com/Upper-Columbia-Salmon-Recovery-Board/Floodplain_Inundation_HAND_to_REM/blob/main/FUNCTION_pull_wetted_area_from_discharge.R) to pull the flooded wetted area based on the VIC discharge in the spreadsheet. The second function is the [**FUNCTION_calculate_flood_stage_height.R**](https://github.com/Upper-Columbia-Salmon-Recovery-Board/Floodplain_Inundation_HAND_to_REM/blob/main/FUNCTION_calculate_flood_stage_height.R) which calculates the elevation profile between the transect endpoints, and "fills" that cross section based on the wetted area and outputs the stage height when the wetted area is reached.

Other code is in the GitHub page, but this code was "practice" code and not required to run the Main script.

### Spreadsheet

The [spreadsheet](https://github.com/Upper-Columbia-Salmon-Recovery-Board/Floodplain_Inundation_HAND_to_REM/blob/main/Spreadsheet_HAND_CatchID_ReachInfo.xlsx) includes information about each transect. This includes:

 - *CatchID*: is the ID for the ORNL HAND data set polygon
 - *UCSRB_Reach*: reach name corresponding to the UCSRB reach network
 - *Notes*: not required to run model, just notes for the user
 - *Ten_year_flood_VIC_m3_sec*: 10-year flood dishcarge (m3/sec) based on VIC. (This should probably be names "flood discharge" since you could put in 2-year flood discharge or whatever)
 - *lat_X*: two lat/lon points are the end points of the transects 




