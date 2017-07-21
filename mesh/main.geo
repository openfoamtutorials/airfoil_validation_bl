Include "naca.geo";
Include "WindTunnel.geo";
Include "parameters.geo";

// Units are multiples of chord.

ce = 0;
Point(ce++) = {0, 0, 0};

Call SymmetricAirfoil;

WindTunnelHeight = 20;
WindTunnelLength = 40;
WindTunnelLc = 3;
Call WindTunnel;

Surface(ce++) = {WindTunnelLoop, AirfoilLoop};
TwoDimSurf = ce - 1;

cellDepth = 0.1;

ids[] = Extrude {0, 0, cellDepth}
{
	Surface{TwoDimSurf};
	Layers{1};
	Recombine;
};

ids1[] = Extrude {0, 0, cellDepth}
{
	Surface{upperTeSurface};
	Layers{1};
	Recombine;
};

ids2[] = Extrude {0, 0, cellDepth}
{
	Surface{lowerTeSurface};
	Layers{1};
	Recombine;
};

ids3[] = Extrude {0, 0, cellDepth}
{
	Surface{BlSurface};
	Layers{1};
	Recombine;
};

Physical Surface("outlet") = {ids[2]};
Physical Surface("walls") = {ids[{3, 5}]};
Physical Surface("inlet") = {ids[4]};
Physical Surface("airfoil") = {ids1[5], ids2[5], ids3[5]};
Physical Surface("frontAndBack") = {ids[0], TwoDimSurf, ids1[0], ids2[0], ids3[0], upperTeSurface, lowerTeSurface, BlSurface};
Physical Volume("volume") = {ids[1], ids1[1], ids2[1], ids3[1]};

