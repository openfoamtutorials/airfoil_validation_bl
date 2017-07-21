// This contains subroutines to get vector directions.
// All Macros expect Arguments[] and outputs Results[].

Macro Vector
    start  = Arguments[0];
    finish = Arguments[1];
    vector[] = Point{finish};
    coord[]  = Point{start};
    vector[0] -= coord[0];
    vector[1] -= coord[1];
    vector[2] -= coord[2];
    Results[] = vector[];
Return

Macro Scale
    Results[] = Arguments[{0:2}];
    Results[0] *= Arguments[3];
    Results[1] *= Arguments[3];
    Results[2] *= Arguments[3];
Return

Macro Magnitude
    Results[0] = Sqrt(Arguments[0]^2 + Arguments[1]^2 + Arguments[2]^2);
Return

Macro Normalize
    Call Magnitude;
    Arguments[3] = 1.0 / Results[0];
    Call Scale;
Return

Macro Bisector
    start  = Arguments[0];
    middle = Arguments[1];
    finish = Arguments[2];
    Arguments[] = {middle, start};  Call Vector;
    bisector[] = Results[];
    Arguments[] = {middle, finish}; Call Vector;
    bisector[0] += Results[0];
    bisector[1] += Results[1];
    bisector[2] += Results[2];
    Arguments[0] = bisector[0] / 2.0;
    Arguments[1] = bisector[1] / 2.0;
    Arguments[2] = bisector[2] / 2.0;
    Call Normalize;
Return

Macro Add
    Results[0] = Arguments[0] + Arguments[3];
    Results[1] = Arguments[1] + Arguments[4];
    Results[2] = Arguments[2] + Arguments[5];
Return

Macro Cross
    Results[0] = Arguments[0] * Arguments[4] - Arguments[1] * Arguments[3];
Return

Macro Translated
    point = Arguments[0];
    Results[] = Point{point};
    Results[0] += Arguments[1];
    Results[1] += Arguments[2];
    Results[2] += Arguments[3];
Return

Macro Dot
    Results[0] = Arguments[0] * Arguments[3];
    Results[0] += Arguments[1] * Arguments[4];
    Results[0] += Arguments[2] * Arguments[5];
Return

Macro Angle
    firstVector[] = Arguments[{0:2}];
    secondVector[] = Arguments[{3:5}];
    Arguments[] = firstVector[];
    Call Normalize;
    firstNorm[] = Results[];
    Arguments[] = secondVector[];
    Call Normalize;
    secondNorm[] = Results[];
    Arguments[] = {firstNorm[], secondNorm[]};
    Call Dot;
    Results[0] = Acos(Results[0]);
Return
