execute PARAMS {
    //cplex.tilim = 600; // stops and returns the current solution after 100 seconds
	//cplex.threads = 2; // Number of threads
}

int a = ...;
int b = ...;
int L = ...;
int n = ...;
range Tasks = 1..n;
range MinusTasks = 2..n;

int s = a + L + b;

dvar int+ t[Tasks];
dvar int+ j;
int greedy[Tasks];
int grd;
//dvar boolean y[Tasks][Tasks];


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
}


minimize t[n];

subject to {
	//t[n] <= grd;


    forall ( i in MinusTasks ) {
		/* a first
		t[i] == a * (i-1) => j >= i; 
		t[i] >= a * (i-1) + 1 => j <= i - 1; 
		*/

		/* ba first */
		t[i] == (a + b) * (i-1) => j >= i; 
		t[i] >= (a + b) * (i-1) + 1 => j <= i - 1; 

		t[i] <= s && i >= j + 1 => t[i] == t[i-1] + a; 
	}

    forall ( i in MinusTasks ) {
		orderingTasks:	
	    	t[i] >= t[i-1] + a;
		no_separation:
			t[i] <= t[i-1] + s;
	}
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
    writeln("j = ", j);
    //writeln("y = ", y);
    writeln("Optimal = ", t[n]+a+L+b);
}
