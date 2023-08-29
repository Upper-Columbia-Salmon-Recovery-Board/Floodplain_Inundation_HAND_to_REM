
# ------------------------------------------------------ 
#
#       Script to calculate elevation profile from Relative Elevation Model
#
# ------------------------------------------------------ 
# Installed topoDistance to use to calculate elevation profile along stream

library(topoDistance)
library(raster)
library(rprofile)


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


Methow_Tx_03_profile <- matrix(ncol = 2, byrow = TRUE,
             c(-120.129819,  48.207812,
               -120.117481, 48.210671 ))



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
Methow_Fwn_03_profile_x_seq = seq(from=Methow_Fwn_03_profile_x[1],to=Methow_Fwn_03_profile_x[2],by=(abs(Methow_Fwn_03_profile_x[1]-Methow_Fwn_03_profile_x[2])/1000)  )
Methow_Fwn_03_profile_y_seq = seq(from=Methow_Fwn_03_profile_y[1],to=Methow_Fwn_03_profile_y[2],by=(abs(Methow_Fwn_03_profile_y[1]-Methow_Fwn_03_profile_y[2])/1000)  )
Methow_Fwn_03_transect = cbind(Methow_Fwn_03_profile_x_seq, Methow_Fwn_03_profile_y_seq)
Methow_Fwn_03_transect_elev = extract(raster_Methow_Fwn_03_B, Methow_Fwn_03_transect)

plot(raster_Methow_Fwn_03_B)
lines(Methow_Fwn_03_transect)
 


Water_Area_Fxn(Methow_Fwn_03_transect_elev, Methow_Fwn_03_profile_x_seq, 3078)


