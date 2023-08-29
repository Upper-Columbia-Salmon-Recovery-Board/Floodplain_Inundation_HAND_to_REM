
# ------------------------------------------------------------------------
#
#     Main Script
#
# ------------------------------------------------------------------------

# ------------------------------------------------------ 
#  Packages
# ------------------------------------------------------ 

library(readxl)
library(raster)

# ------------------------------------------------------ 
#  Set Parameters
# ------------------------------------------------------ 

top_height_ft_x = 30 # the top height to search to (feet)
increment_ft = 0.1 # increments (in feet) to increase stage height to reach wetted area
number_of_cross_sectional_points = 1000 # number of cross-sectional points 

# ------------------------------------------------------------------------
#   Read in Functions
# ------------------------------------------------------------------------

script_path = "C:/Users/ryan/Documents/GitHub/LiDAR_Processing/Floopldain_Inundation/"
source(paste(script_path, 'FUNCTION_calculate_flood_stage_height.R', sep="")) 
source(paste(script_path, 'FUNCTION_pull_wetted_area_from_discharge.R', sep="")) 

# ------------------------------------------------------------------------
#   Read in ORNL HAND data (https://cfim.ornl.gov/data/)
# ------------------------------------------------------------------------

file_path_x = "P:/GIS/Prioritization/Step 2/CCT_Floodplain/HAND_data/170200/ORNL_output/hydrogeo-fulltable-170200.csv"
HAND_table = readr::read_csv(file_path_x)

# ------------------------------------------------------ 
#    CatchID to pull stage height
# ------------------------------------------------------ 

catchID_list = read_excel("C:/Users/ryan/Documents/GitHub/LiDAR_Processing/Floopldain_Inundation/Spreadsheet_HAND_CatchID_ReachInfo.xlsx", sheet="Sheet1")

# ------------------------------------------------------ 
#    Loop through each point to generate flood stage height
# ------------------------------------------------------ 

flood_stage_data_frame = c()

for(row_x in 1:nrow(catchID_list) ){
  
  # ------------------------------------------------------ 
  #    Read in data related to this point
  # ------------------------------------------------------ 
  
  # ---------- ORNL HAND CatchID ---------
  catchID_x = catchID_list$CatchID[row_x]
  reach_x = catchID_list$UCSRB_Reach[row_x]
  # ---------- VIC flood discharge -------
  flood_discharge_x = catchID_list$Ten_year_flood_VIC_m3_sec[row_x]
  # ------------ raster path ------------
  raster_path = catchID_list$REM_Tif_Path[row_x]
  #raster_path = substring(raster_path,1, nchar(raster_path)-1) # strip extra characters
  # ------------ both latitude points -------
  lon_end_points = c(catchID_list$lon_1[row_x], catchID_list$lon_2[row_x])
  lat_end_points = c(catchID_list$lat_1[row_x], catchID_list$lat_2[row_x])
  
  # ------------- pull HAND data for the CatchID -----
  HAND_table_X = HAND_table[which(HAND_table$CatchId == catchID_x),]
  
  # --------- pull wetted area for the specific discharge ----------
  wetted_area_ft_2_x = Wetted_Area_from_Discharge(HAND_table_X, flood_discharge_x)
  
  # --- read RASTER data --------------
  raster_reach = raster(raster_path)
  
  # -------- generate points along transect -------
  lon_end_1 = lon_end_points[which(lon_end_points == min(lon_end_points))]
  lon_end_2 = lon_end_points[which(lon_end_points == max(lon_end_points))]
  lat_end_1 = lat_end_points[which(lat_end_points == min(lat_end_points))]
  lat_end_2 = lat_end_points[which(lat_end_points == max(lat_end_points))]
  lon_cross_section_points = seq(from=lon_end_1, to=lon_end_2, by=(abs(lon_end_1-lon_end_2)/number_of_cross_sectional_points)  )
  lat_cross_section_points = seq(from=lat_end_1, to=lat_end_2, by=(abs(lat_end_1-lat_end_2)/number_of_cross_sectional_points)  )
  transect_x = cbind(lon_cross_section_points, lat_cross_section_points)  # lat and lon points along transect
  # --------- calculate elevation along transect --------
  transect_elev = extract(raster_reach, transect_x)  # cross sectional elevation profile
  # -------------- calculate flood stage height ----------
  flood_stage_height_x = Calculate_Flood_Stage_Fxn(transect_elev, lon_cross_section_points, wetted_area_x, top_height_ft_x, increment_ft)
  
  # ----------- add to output ----------
  output_x = as.data.frame(t( c(reach_x,catchID_x,wetted_area_ft_2_x, flood_stage_height_x) ) )
  flood_stage_data_frame = rbind(flood_stage_data_frame, output_x)
  
}





