package problem;

/** Defines a coupled task */

public class CoupledTask {
	//============= Fields =============//
	//         ( Package scope )        //
	
	/** First operation */
	int a;
	
	/** Second operation */
	int b;

	/** Exact gap */
	int L;
	
	/** Multiplicity */
	int multiplicity;

	
	//============= Constructors =============//
	/**
	 * Constructor
	 * @param a first operation's length
	 * @param b second operation's length
	 * @param L fixed gap duration
	 * @param m multiplicity
	 */
	public CoupledTask(int a, int b, int L, int m) {
		this.a = a; this.b = b; this.L = L;
		this.multiplicity = m;
	}


	//============= Getters =============//
	public int getA() {
		return a;
	}

	public int getB() {
		return b;
	}

	public int getL() {
		return L;
	}

	public int getMultiplicity() {
		return multiplicity;
	}
}
