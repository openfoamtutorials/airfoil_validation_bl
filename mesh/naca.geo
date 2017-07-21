Include "Vector.geo";

// This returns normalized y for a symmetric airfoil.
Macro NACA00
    // x is the normalized chord position in [0, c].
    // XX is the last 2 digits, which dictates maximum thickness.
    // NACA0012 for XX = 12, and maximum thickness is 0.12 of chord.
    y = 0.2969 * x^0.5;
    y += -0.1260 * x;
    y += -0.3516 * x^2;
    y += 0.2843 * x^3;
    y += -0.1015 * x^4;
    y *= 5.0 * XX / 100.0;
Return

Macro RotateAirfoilPoint
    // rotates pointId about quarter-chord.
    // aoa is the angle of attack in degrees.
    Rotate {{0, 0, 1}, {0.25, 0, 0}, -aoa * Pi / 180.0}
    {
        Point{pointId};
    }
Return

Macro SymmetricAirfoil
    // draws a symmetric airfoil, given XX as in NACA00XX.
    // PointCount specifies number of points.
    // Draws le at {0, 0} and te at {1, 0}.
    // ce is the current point id.
    // AirfoilLc is the length characteristic on airfoil surface.
    // aoa is the angle of attack in degrees.
    // Results: le, te, upper[], lower[], AirfoilSurface
    x = 0;
    increment = 1.0 / PointCount;
    Point(ce++) = {0, 0, 0, AirfoilLc};
    pointId = ce - 1;
    Call RotateAirfoilPoint;
    le = pointId;
    Point(ce++) = {1, 0, 0, AirfoilLc};
    pointId = ce - 1;
    Call RotateAirfoilPoint;
    te = pointId;
    upper[] = {};
    lower[] = {};
    For x In {increment: 1 - increment: increment}
        Call NACA00;
        Point(ce++) = {x, y, 0, AirfoilLc};
        pointId = ce - 1;
        Call RotateAirfoilPoint;
        upper = {pointId, upper[]};
        Point(ce++) = {x, -y, 0, AirfoilLc};
        pointId = ce - 1;
        Call RotateAirfoilPoint;
        lower += pointId;
    EndFor
    Line(ce++) = {te, upper[0]};
    upperTe = ce - 1;
    Line(ce++) = {lower[#lower[] - 1], te};
    lowerTe = ce - 1;
    BSpline(ce++) = {upper[], le, lower[]};
    AirfoilSurface = ce - 1;
    Line Loop(ce++) = {upperTe, AirfoilSurface, lowerTe};
    AirfoilLoop = ce - 1;

    Arguments[]  = {te, upper[], le, lower[]};
    Call Offset;
    Line(ce++) = {upper[0], blPoints[0]};
    upperVertical = ce - 1;
    Line(ce++) = {te, blPoints[#blPoints[] - 1]};
    teVertical = ce - 1;
    Line(ce++) = {blPoints[#blPoints[] - 1], blPoints[0]};
    upperBlLine = ce - 1;
    Line(ce++) = {lower[#lower[] - 1], blPoints[#blPoints[] - 2]};
    lowerVertical = ce - 1;
    Line(ce++) = {blPoints[#blPoints[] - 2], blPoints[#blPoints[] - 1]};
    lowerBlLine = ce - 1;
    Transfinite Line{upperVertical, teVertical, lowerVertical} = 10 Using Progression 1.2;
    Transfinite Line{upperBlLine, upperTe, lowerBlLine, lowerTe} = 1;
    Transfinite Line{BlLine, AirfoilSurface} = 1.0 / AirfoilLc Using Bump 4;
    Line Loop(ce++) = {teVertical, upperBlLine, -upperVertical, -upperTe};
    Surface(ce++) = ce - 2;
    upperTeSurface = ce - 1;
    Line Loop(ce++) = {lowerVertical, lowerBlLine, -teVertical, -lowerTe};
    Surface(ce++) = ce - 2;
    lowerTeSurface = ce - 1;
    Line Loop(ce++) = {upperVertical, BlLine, -lowerVertical, -AirfoilSurface};
    Surface(ce++) = ce - 2;
    BlSurface = ce - 1;
    Transfinite Surface{upperTeSurface, lowerTeSurface, BlSurface};
    Recombine Surface{upperTeSurface, lowerTeSurface, BlSurface};

    Line Loop(ce++) = {upperBlLine, BlLine, lowerBlLine};
    AirfoilLoop = ce - 1;
Return

Macro Offset
    points[] = Arguments[];
    distance = 0.01;
    blPoints[] = {};
    For p In {0: #points[] - 1}
        start  = points[p];
        middle = points[(p + 1) % #points[]];
        finish = points[(p + 2) % #points[]];
        Arguments[] = {Point{start}, Point{middle}, Point{finish}};
        Call Bisector;
        Arguments[] = Results[];
        Arguments[3] = distance;
        Call Scale;
        middle = points[(p + 1) % #points[]];
        Arguments[] = {Point{middle}, Results[{0:2}]};
        Call Translated;
        Point(ce++) = {Results[0], Results[1], Results[2]};
        blPoints[] += ce - 1;
    EndFor
    BSpline(ce++) = blPoints[{0:#blPoints[] - 2}];
    BlLine = ce - 1;
Return

