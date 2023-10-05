# ------------------------------------------------------------------------
#
#     Function to identify stage height for given wetted area (from a specific flood discharge)
#
# ------------------------------------------------------------------------


# ------------- parameters to test --------
test_y_n  = "no"
if(test_y_n == "yes"){
  water_area_ft2_x = wetted_area_ft_2_x
  elevation_profile_height_x = transect_elev # feet
  elevation_profile_x_values = lon_cross_section_points # decimal degree
  top_height_ft_x = 30 # the top height to search to (feet)
  increment_ft = 0.1
  # estimated_start_height_ft = 0.9*3.28084 # 0.9 was in m
}

# ------------- length of feet per decimal degree --------
ft_per_decimal_degree = 241388

# -----------------------------------------------------------------------
#           FUNCTION
# -----------------------------------------------------------------------

Calculate_Flood_Stage_Fxn = function(elevation_profile_height_x, elevation_profile_x_values,  water_area_ft2_x, top_height_ft_x, increment_ft){
  
  # ----------- convert transect to decimal degree increment -------------
  length_transect_decimal_degree = abs(elevation_profile_x_values[1] - elevation_profile_x_values[length(elevation_profile_x_values)])
  length_transect_feet = length_transect_decimal_degree * ft_per_decimal_degree
  increment_decimal_degree = length_transect_feet/length(elevation_profile_x_values)
  
  # --------------------------------------------------------------------------
  #   convert points to "NA" that are at the ends and are at "0"
  # --------------------------------------------------------------------------
  mid_point = round( length(elevation_profile_x_values)/2 )
  
  # --------- points on beginning of transect  ------
  max_points_start = which(elevation_profile_height_x == max(elevation_profile_height_x[1:mid_point], na.rm=T) )
  if(max_points_start != 1){  # only remove "0" if beginning of transect is not the highest point
    elevation_profile_height_x[1:(max_points_start-1)] = NA
  }
  # --------- points on end of transect ------
  max_points_end = which(elevation_profile_height_x == max(elevation_profile_height_x[mid_point:length(elevation_profile_height_x)], na.rm=T) )
  if(max_points_end != length(elevation_profile_height_x) ){  # only remove "0" if end of transect is not the highest point
    elevation_profile_height_x[ (max_points_end+1):length(elevation_profile_height_x)] = NA
  }
  
  
  # --------------- sequence through elevation increments to get water area -----------
  seq_elev = seq(increment_ft,top_height_ft_x,by=increment_ft)
  i = 0 
  water_area_CALC = 0
  for(elev_x in seq_elev){
    i = i + 1
    water_area_CALC_prev = water_area_CALC  # save previous water area calc
    # ------------- calculate water area --------- 
    elevation_profile_height_x_CALC = elevation_profile_height_x[which(elevation_profile_height_x<elev_x)]
    water_area_CALC = sum((elev_x -  elevation_profile_height_x_CALC  ))
    
    # ------------- once calculated water area overtakes the stage height --------
    if(water_area_ft2_x  < water_area_CALC){
      water_area_CALC_DIF = water_area_CALC - water_area_CALC_prev # difference in increment water areas
      water_area_portion_above = (water_area_ft2_x-water_area_CALC_prev)/water_area_CALC_DIF # calculate portion between wetted areas
      elev_output_x = seq_elev[i-1] + (increment_ft*water_area_portion_above) # calculate portion between increment
    }
    else {elev_output_x = NA}
  }
  return(round(elev_output_x,2))

}




