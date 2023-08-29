---
title: "Flooplain Inunidation Calculation"
output: html_document
date: "2023-08-28"
---


# Steps to generating Floodplain Inundation

### Step 1: Generate Relative Elevation Models (REMs)

Use [RiverREM](https://github.com/OpenTopography/RiverREM) or [GGL Tool](https://github.com/helstab/GGLREM) to generate REM in reach(es). 

### Step 2: Generate Discharge of desired flood return interval

Pull discharge from [VIC hydorologic model data](https://www.fs.usda.gov/research/rmrs/projects/us-stream-flow-metrics). These data include a 1.5-year, 10-year, and 25-year peak discharge.

### Step 3:  Generate velocity for reach(es)  

Generate Velocity from flood discharge (from VIC). Use the [Oak Ridge National Laboratory Continental floodplain inundation mapping](https://cfim.ornl.gov/data/) project data to identify the wetted area for that VIC discharge. Note this data set assumes a Manning's roughness of 0.05 to calculate stream velocity.

### Step 4: Generate cross-sectional elevation profile

At each point along the reach where one generates a wetted area, in R  generate elevation profile. One way to do this is a combination of the “extract” function from the raster package to generation the cross-section elevation profile. Then the Water_Area_Fxn function uses incremental stage height steps to "fill up" the profile until the cross-sectional area inundated is equal to the wetted area from the previous step. This value is the "stage height" for the next step.


### Step 5: Map the floodplain inundation

With the REM (from Step 1) – map the floodplain based on the stage height from Step 4. For a continuous floodplain, merge all inundated reach sections.

