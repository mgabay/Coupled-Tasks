execute PARAMS {
    //cplex.tilim = 600; // stops and returns the current solution after 100 seconds
	//cplex.threads = 2; // Number of threads
}

int a = ...;
int b = ...;
int L = ...;
int   n = ...;
int bound = ...;
range Tasks = 1..n;
range MinusTasks = 2..n;

//int M = bound;
int s = a + L + b;
int t_bound = bound - s;

dvar int+ t[Tasks];
//dvar boolean y[Tasks][Tasks];


//minimize t[n];

subject to {
    t[n] <= t_bound;
    forall ( i in MinusTasks )
		orderingTasks:	
	    	t[i] >= t[i-1] + a;
    forall ( i , j in Tasks : i < j) {
		noOverlap:
	    	t[j] <= (t[i] + L) || t[j] >= t[i] + s;
	    	//t[j] <= (t[i] + L) + M * y[i][j];
	    	//t[j] + M * (1 - y[i][j]) >= t[i] + s;
		//cplY:
		//    y[i][j] == 1 - y[j][i];
		//cutY:
		//    y[i][j] >= y[i][j-1];
    }
}

execute DISPLAY {
    writeln("t = ", t);
    //writeln("y = ", y);
    writeln("Optimal = ", t[n]+a+L+b);
}
