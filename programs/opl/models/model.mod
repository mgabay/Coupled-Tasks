/*execute PARAMS {
    cplex.tilim = 100; // stops and returns the current solution after 100 seconds
	cplex.threads = 2; // Number of threads
}*/

float a = ...;
float b = ...;
float L = ...;
float   n = ...;
range Tasks = 1..n;
range MinusTasks = 2..n;

float M = (a+L+b)*n;
float s = a + L + b;

float t_bound = 638 - s;

dvar float+ t[Tasks];
dvar boolean y[Tasks][Tasks];


minimize t[n];

subject to {
	// Initialization
	t[1] == 0;
	t[n] >= t_bound;
	t[n] <= t[n-4] + L;				// a28 <= b24 - a = a24 + a + L - a = a24 + L
	y[23][28] == 1;
	//t[n] >= a + t[n-5] + L;
	y[n][n] == 0;
    forall ( i , j in Tasks : i < j) {
		fixDiag:
			y[i][i] == 0;

		// Chose one of these two constraints
		fixY:
	    	//y[j][i] == 0;
	    	y[i][j] == 1 - y[j][i];
	}

    forall ( i in MinusTasks )
		orderingTasks:	
	    	t[i] >= t[i-1] + a;

    forall ( i , j in Tasks : i < j) {
	//cutY:
	//    y[i][j] >= y[i][j-1];
		noOverlap1:
	    	t[j] <= (t[i] + L) + M * y[i][j];
	    noOverlap2:
			t[j] + M * (1 - y[i][j]) >= t[i] + s;
    }
}

execute DISPLAY {
    writeln("t = ", t);
    writeln("y = ", y);
    writeln("Optimal = ", t[n]+a+L+b);
    writeln("y(15,19) = ", y[15][19]);
    writeln("M = ", M);
}
