
water_area_ft2_x = 286/0.09290304  # ft2 (286 was m2)
elevation_profile_height_x = Methow_Fwn_03_transect_elev # feet
elevation_profile_x_values = Methow_Fwn_03_profile_x_seq # decimal degree
top_height_ft_x = 30 # the top height to search to (feet)
increment_ft = 0.1
# estimated_start_height_ft = 0.9*3.28084 # 0.9 was in m

ft_per_decimal_degree = 241388

Water_Area_Fxn = function(elevation_profile_height_x, elevation_profile_x_values,  water_area_ft2_x, top_height_ft_x, increment_ft){
  
  # decimal degree increment 
  length_transect_decimal_degree = abs(elevation_profile_x_values[1] - elevation_profile_x_values[length(elevation_profile_x_values)])
  length_transect_feet = length_transect_decimal_degree * ft_per_decimal_degree
  increment_decimal_degree = length_transect_feet/length(elevation_profile_x_values)
  
  # --------------- sequence through elevation increments to get water area -----------
  seq_elev = seq(increment_ft,top_height_ft_x,by=increment_ft)
  i = 0 
  for(elev_x in seq_elev){
    i = i + 1
    # ------------- calculate water area --------- 
    elevation_profile_height_x_CALC = elevation_profile_height_x[which(elevation_profile_height_x<elev_x)]
    water_area_CALC = sum((elev_x -  elevation_profile_height_x_CALC  ))
    
    # ------------- if initial under-shoot, now an over-shoot ---------------
    if(water_area_ft2_x > water_area_initial & water_area_ft2_x  < water_area_CALC){break}

  }
  return(elev_x)

}




