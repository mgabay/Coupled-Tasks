execute PARAMS {
    //cplex.tilim = 600; // stops and returns the current solution after 100 seconds
	//cplex.threads = 2; // Number of threads
}

float a = ...;
float b = ...;
float L = ...;
int   n = ...;
range Tasks = 1..n;
range MinusTasks = 2..n;

float s = a + L + b;

dvar float+ t[Tasks];
float greedy[Tasks];
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
}


minimize t[n];

subject to {
    forall ( i in MinusTasks )
		orderingTasks:	
	    	t[i] >= t[i-1] + a;
	t[n] <= greedy[n];
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

main {
	thisOplModel.generate();

	var def = thisOplModel.modelDefinition;
	var data = new IloOplDataSource("data_base_2.dat")
	var opl = new IloOplModel(def, cplex);
	opl.addDataSource(data);
	opl.generate();

	var vectors = new IloOplCplexVectors();
	vectors.attach(opl.t, opl.greedy);
	vectors.setVectors(cplex);

	cplex.solve();
	writeln(opl.printSolution());
	writeln(opl.greedy);

	opl.end();
	0;
}
