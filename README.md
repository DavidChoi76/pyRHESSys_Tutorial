# RHESsys Model Simulation in Binder

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/DavidChoi76/rhessys_binder_test.git/master)

This GitHub repository developed to simulate RHESsys Model as an example of Coweeta subwatershed 18, NC, USA.

Try out RHESsys Model Simulation with a brief interactive tutorial by clicking the Launch Binder button above. It will launch a "Binder" application using the code in this repository.

When JupyterHub starts, you can find "rhessys_example_download.ipynb".
1) Open "rhessys_example_download.ipynb" notebook and execute codes.
 - Get notebooks, source code etc from HydroShare resource :https://www.hydroshare.org/resource/726ad560948d4c88b6ca7ef8b3d44cba/
2) Open 1_Preprocessing_to_Create_RHESsys_Model_Input_using_GRASS_GIS_and_R-script_on_Collaborative_Modeling_Framework.ipynb notebook
 - The notebook include
   1. Create Project Directory and Download Raw GIS Data from HydroShare
   2. Set GRASS Database and GISBASE Environment
   3. Preprocessing GIS Data for RHESsys Model using GRASS GIS and R script
   4. Preprocess Time series data for RHESsys Model
   5. Construct worldfile and flowtable to RHESSys

3) Open 2_RHESsys_Model_Simulation_on_Collaborative_Modeling_Framework.ipynb notebook
   1. Download and compile RHESsys Execution file
   2. Simulate RHESsys model
   3. Plotting RHESsys output
   
