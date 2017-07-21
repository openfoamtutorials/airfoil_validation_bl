# airfoil_validation_bl

NACA0012 OpenFOAM results are compared to experimental data.

1. Set the desired angle of attack: variable "aoa" (degrees) in mesh/parameters.geo.
2. Gmsh meshing: gmsh -3 -o main.msh mesh/main.geo
3. OpenFOAM (see script for sub-steps): ./run.sh
4. Open "view.foam" in ParaView and/or view force coefficients in ./case/postProcessing/.

TODO:
1. Proper point-bunching near LE and TE.

