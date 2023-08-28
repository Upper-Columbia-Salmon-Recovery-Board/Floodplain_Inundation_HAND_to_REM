

# ------------------------------------------------------ 
#
#       Script to pull cell values for ORNL HAND data
#
# ------------------------------------------------------ 


# ------------------------------------------------------ 
#    Read data
# ------------------------------------------------------ 

file_path_x = "P:/GIS/Prioritization/Step 2/CCT_Floodplain/HAND_data/170200/ORNL_output/hydrogeo-fulltable-170200.csv"
HAND_table = read.csv( file_path_x)


# ------------------------------------------------------ 
#    Remove small areas
# ------------------------------------------------------ 

# HAND_table = HAND_table[which(HAND_table$AREASQKM > 5),]

catchID_x = 23080542 # Wenatchee River near monitor # 10 yr flood is 650 m3/sec
catchID_x = 24382829 # Methow RIver near Methow (town) # 10 yr flood is 600 m3/sec
catchID_x = 24382829 # Methow RIver at bend in river by highway NORTH of Methow, south of Carlton # 10 yr flood is 600 m3/sec
catchID_x = 24382831 # same as above (Methow between Methow and Carlton), so w/ 10 yr flood 600 m3/sec, it's a 3.3 m stage height

catchID_x = 24383383 #  Methow above Wolf Creek, 10 yr flood, 232 m3/sec, stage height is 1 m 
catchID_x = 947020293 # Methow by central pivot in Big Valley, 

catchID_x = 23081548 # Mission creek just above Sand Creek, 10 yr flood is 11 m3/sec
catchID_x = 23081514 # Mission Creek in Cashmere, 10yr flood is 22 m3/sec

HAND_table_X = HAND_table[which(HAND_table$CatchId == catchID_x),]

# ------------------------------------------------------ 
#    Calculate velocity
# ------------------------------------------------------ 

# Manning formulate = V = u_m/n X R_h^0.67 * S^0.5
# u_m = constant based on units
# n = manning's number
# R_h = hydraulg radius
# S = slope

u_m = 1 # 1 for R_h in meters, velocity will be in meters per second

HAND_table_X$velocity_Manning = (u_m/HAND_table_X$Roughness)*(HAND_table_X$HydraulicRadius..m.^0.67) * (HAND_table_X$SLOPE)^0.5



View(HAND_table_X)



