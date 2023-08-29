
# ------------------------------------------------------------------------
#
#     Function to pull wetted area from VIC flood discharge
#
# ------------------------------------------------------------------------

# ------------- parameters to test --------
test_y_n  = "no"
if(test_y_n == "yes"){
  Hand_table_for_fxn_x = HAND_table_X
  # estimated_start_height_ft = 0.9*3.28084 # 0.9 was in m
}

# -----------------------------------------------------------------------
#           FUNCTION
# -----------------------------------------------------------------------

Wetted_Area_from_Discharge = function(Hand_table_for_fxn_x, flood_discharge_x ){
  
  # -------------------- identify if flood discharge is identical to a HAND discharge -----
  flood_identical = any(Hand_table_for_fxn_x$`Discharge (m3s-1)` == flood_discharge_x)
  
  # --------------------------- if flood discharge and a HAND discharge identical, pull wetted area ------------
  if(flood_identical){
    wetted_area_m2_output_x = Hand_table_for_fxn_x$`WetArea (m2)`
  }else{
    
  # --------------------- if no identical flood discharge, average between two ---------
  
    # get higher and lower discharge
    greater_discharge = min(which(Hand_table_for_fxn_x$`Discharge (m3s-1)` > flood_discharge_x) )
    lower_discharge = max(which(Hand_table_for_fxn_x$`Discharge (m3s-1)` < flood_discharge_x) ) 
    
    # ----- difference between VIC discharge and HAND discharge  -------
    discharge_dif = Hand_table_for_fxn_x$`Discharge (m3s-1)`[greater_discharge] - Hand_table_for_fxn_x$`Discharge (m3s-1)`[lower_discharge]
    discharge_above_low = flood_discharge_x - Hand_table_for_fxn_x$`Discharge (m3s-1)`[lower_discharge]
    portion_above_low = discharge_above_low / discharge_dif
    
    # ----- calculate wetted area between greater and lower  -------
    wetted_area_dif = Hand_table_for_fxn_x$`WetArea (m2)`[greater_discharge] - Hand_table_for_fxn_x$`WetArea (m2)`[lower_discharge]
    wetted_area_m2_output_x = wetted_area_dif*portion_above_low +  Hand_table_for_fxn_x$`WetArea (m2)`[lower_discharge]
    
  }
  
  # ---------- convert wetted area to ft2 -----------
  wetted_area_ft2_output_x =  wetted_area_m2_output_x * 10.76391
  
  return(wetted_area_ft2_output_x)
  
}
  
