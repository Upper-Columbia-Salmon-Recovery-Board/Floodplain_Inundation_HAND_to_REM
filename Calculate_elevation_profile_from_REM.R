
# ------------------------------------------------------ 
#
#       Script to calculate elevation profile from Relative Elevation Model
#
# ------------------------------------------------------ 

#library(topoDistance)
library(raster) # used the "extract" package
#library(rprofile)

# ------------------------------------------------------ 
#  Parameters
# ------------------------------------------------------ 

top_height_ft_x = 30 # the top height to search to (feet)
increment_ft = 0.1 # increments (in feet) to increase stage height to reach wetted area

# ------------------------------------------------------ 
#  Read in REM data
# ------------------------------------------------------ 

raster_Methow_Tx_03_path = "P:/GIS/LiDAR/Methow_LiDAR/Methow_LiDAR/Methow_Texas_03_REM.tif"
raster_Methow_Fwn_03_path = "P:/GIS/LiDAR/Methow_LiDAR/Methow_LiDAR/Methow_Fawn_03_REM.tif"
raster_Methow_Fwn_03_path = "P:/GIS/LiDAR/Methow_LiDAR/Methow_LiDAR/Methow_Fawn_03_REM.tif"
raster_Methow_Fwn_03_path_B = "P:/GIS/LiDAR/Methow_LiDAR/Methow_LiDAR/Methow_Fawn_03_REM_WGS.tif"


raster_Methow_Tx_03 = raster(raster_Methow_Tx_03_path)
raster_Methow_Fwn_03 = raster(raster_Methow_Fwn_03_path)
raster_Methow_Fwn_03_B = raster(raster_Methow_Fwn_03_path_B)

# ------------------------------------------------------ 
#  Calculate elevation profile
# ------------------------------------------------------ 

# ---------------- choose your profile points (x=lon, y=lat for each point) -------------
Methow_Tx_03_profile_x = c(-120.130542, -120.118118)
Methow_Tx_03_profile_y = c(48.207896,48.210431)

number_of_cross_sectional_points = 1000
# -------------- generate x and y points for the cross-sectional transect ----------
Methow_Tx_03_profile_x_seq = seq(from=Methow_Tx_03_profile_x[1],to=Methow_Tx_03_profile_x[2],by=(abs(Methow_Tx_03_profile_x[1]-Methow_Tx_03_profile_x[2])/number_of_cross_sectional_points)  )
Methow_Tx_03_profile_y_seq = seq(from=Methow_Tx_03_profile_y[1],to=Methow_Tx_03_profile_y[2],by=(abs(Methow_Tx_03_profile_y[1]-Methow_Tx_03_profile_y[2])/number_of_cross_sectional_points)  )

Methow_Tx_03_transect = cbind(Methow_Tx_03_profile_x_seq, Methow_Tx_03_profile_y_seq)
Methow_Tx_03_transect_elev = extract(raster_Methow_Tx_03, Methow_Tx_03_transect)

flood_stage_elev_Methow_Tx_03 = Water_Area_Fxn(Methow_Tx_03_transect_elev, Methow_Tx_03_profile_x_seq, 3078, top_height_ft_x, increment_ft)

# -------------------- generate transect ----------------
Methow_Fwn_03_profile <- matrix(ncol = 2, byrow = TRUE,
                               c(-120.295597,48.516600,
                                 -120.277442, 48.524048))

long = Methow_Fwn_03_profile[,1]
lat = Methow_Fwn_03_profile[,2]

# ------------ example ----------
r <- raster(ncol=36, nrow=18, vals=1:(18*36))
xy <- cbind(-50, seq(-80, 80, by=20))
extract(r, xy)


Methow_Fwn_03_profile_x = c(-120.295597, -120.277442)
Methow_Fwn_03_profile_y = c(48.516600, 48.524048)
Methow_Fwn_03_profile_x_seq = seq(from=Methow_Fwn_03_profile_x[1],to=Methow_Fwn_03_profile_x[2],by=(abs(Methow_Fwn_03_profile_x[1]-Methow_Fwn_03_profile_x[2])/number_of_cross_sectional_points)  )
Methow_Fwn_03_profile_y_seq = seq(from=Methow_Fwn_03_profile_y[1],to=Methow_Fwn_03_profile_y[2],by=(abs(Methow_Fwn_03_profile_y[1]-Methow_Fwn_03_profile_y[2])/number_of_cross_sectional_points)  )
Methow_Fwn_03_transect = cbind(Methow_Fwn_03_profile_x_seq, Methow_Fwn_03_profile_y_seq)
Methow_Fwn_03_transect_elev = extract(raster_Methow_Fwn_03_B, Methow_Fwn_03_transect)

plot(raster_Methow_Fwn_03_B)
lines(Methow_Fwn_03_transect)
 


Water_Area_Fxn(Methow_Fwn_03_transect_elev, Methow_Fwn_03_profile_x_seq, 3078)


