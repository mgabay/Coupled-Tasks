execute PARAMS {
    //cplex.tilim = 600; // stops and returns the current solution after 100 seconds
	//cplex.threads = 2; // Number of threads
}

int a[3] = ...;
int b[3] = ...;
int L[3] = ...;
int n = 3.;
range Tasks = 1..n;
range MinusTasks = 2..n;

int s = a + L + b;

dvar int+ t[Tasks];
dvar int+ mspan;
int M = 100;
dvar boolean y[Tasks][Tasks];

minimize mspan;

subject to {
    forall (i in Tasks) {
        mspan >= t[i];
    }
	
    forall ( i , j in Tasks : i >= j) {
		y[i][j] == 0;
	}


    forall ( i in MinusTasks ) {
		orderingTasks:	
	    	t[i] >= t[i-1] + a;
		no_separation:
			t[i] <= t[i-1] + s;
	}

    forall ( i , j in Tasks : i < j) {
		init_y_pred:
			y[i][j] >= y[i][j - 1];
		overlap_down:
			t[j] - t[i] <= L + y[i][j] * M;
		overlap_up:
			t[j] - t[i] >= s * y[i][j];
    }
}

execute DISPLAY {
    writeln("t = ", t);
    writeln("y = ", y);
    writeln("Optimal = ", t[n]+a+L+b);
}
