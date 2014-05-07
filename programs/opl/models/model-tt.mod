execute PARAMS {
    //cplex.tilim = 600; // stops and returns the current solution after 100 seconds
	//cplex.threads = 8; // Number of threads
}

int a = ...;
int b = ...;
int L = ...;
int n = ...;
range Tasks = 1..n;
range MinusTasks = 2..n;

int s = a + L + b;

dvar int+ t[Tasks];
int greedy[Tasks];
int grd;
int M;
float G = floor(L / a + 2);
dvar boolean y[Tasks][Tasks];


execute GREEDY {
	var cour = 0;
	var deb = 1;
	for (var i in Tasks) {
		greedy[i] = cour;
		if (cour + 2*a > greedy[deb] + a + L) {
			cour = greedy[i] + a + L + b;
			deb = i + 1;
		} else {
			cour = greedy[i] + a;
		}
	}
	grd = greedy[n];
	M = 2 * grd + L;
	M = grd;
}


minimize t[n];

subject to {
	t[1] == 0;
    t[2] == 9;
    t[3] == 14;
    t[4] == 24;
    t[5] == 14+5+15+4;
    t[6] == t[4]+5+15+4;
    t[7] == t[6]+5;
	
    forall ( i , j in Tasks : i >= j) {
		y[i][j] == 0;
	}


    forall ( i in MinusTasks ) {
		orderingTasks:	
	    	t[i] >= t[i-1] + a;
		no_separation:
			t[i] <= t[i-1] + s;
	}

    //forall ( i , j in Tasks : i < j) {
    forall ( i , j in Tasks : i < j) {
		if (i + G > j) {
			init_y_pred:
				y[i][j] >= y[i][j - 1];
			overlap_down:
				t[j] - t[i] <= L + y[i][j] * M;
			overlap_up:
				t[j] - t[i] >= s * y[i][j];
		}

		/********************************************************/
		/* 		This can be used to replace M : 		        */
		/*	t[i] + L - t[j] >= L - t[j] >= L - t[n] >= L - grd  */
		/*												        */
		/********************************************************/
    }
}

execute DISPLAY {
    writeln("t = ", t);
    writeln("y = ", y);
    writeln("Optimal = ", t[n]+a+L+b);
}
