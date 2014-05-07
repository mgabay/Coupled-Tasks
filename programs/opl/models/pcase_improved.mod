execute PARAMS {
    //cplex.tilim = 600;
    //cplex.threads = 2;
}

int a = ...;
int b = ...;
int L = ...;
int alpha1 = ...;
int alpha2 = ...;
int beta1 = ...;
int beta2 = ...;

range bt1 = 1..beta1;
range b1 = 2..beta1;
range bt2 = 1..beta2;
range b2 = 2..beta2;

int gamma1 = L - alpha1 * a - beta1 * (a+b);
int gamma2 = L - alpha2 * a - beta2 * (a+b);

dvar int+ t[bt1];
dvar int+ x[bt1];
dvar int+ s[bt2];
dvar int+ y[bt2];
dvar boolean z[bt2][bt1];


subject to {
    // On place les ba

    sum (i in bt1) x[i] <= alpha1;
    t[1] == gamma1 + x[1] * a; 
    forall ( i in b1 ) {
		t[i] == t[i-1] + b + a + x[i] * a;
	}
    L >= t[beta1] + a + b;

    sum (i in bt2) y[i] <= alpha2;
    s[1] == y[1] * a + b;
    forall ( i in b2 ) {
		s[i] == s[i-1] + a + b + y[i] * a;
	}
    L >= s[beta2] + a + gamma2;

    // No overlap :
    forall ( i in bt2, j in bt1 ) {
		//s[i] >= t[j] + b || s[i] + a <= t[j];
		s[i] - t[j] + L * z[i][j] >= b;
		t[j] - s[i] + L * (1-z[i][j]) >= a;
	}

}

execute DISPLAY {
    writeln("Gain = ", gamma1 + gamma2);
    writeln("t = ", t);
    writeln("s = ", s);
    writeln("x = ", x);
    writeln("y = ", y);
}
