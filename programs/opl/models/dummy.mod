float a = ...;
float b = ...;
float L = ...;
int   n = ...;
range Tasks = 1..n;
range MinusTasks = 2..n;

dvar float+ t[Tasks];

minimize t[n];

subject to {
    forall ( i in MinusTasks )
	orderingTasks:	
	    t[i] >= t[i-1] + a;
    forall ( i , j in Tasks : i < j) {
	noOverlap:
	    t[j] <= (t[i] + L) || t[j] >= t[i] + a + L + b;
    }
}

execute DISPLAY {
    writeln("t = ", t);
    writeln("Optimal = ", t[n]+a+L+b);
}
