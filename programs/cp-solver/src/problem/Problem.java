package problem;

import java.util.Iterator;
import java.util.Vector;

public class Problem {
	//============= Fields =============//
	//         ( Package scope )        //
	
	/** Tasks list */
	Vector<CoupledTask> tasks;

	
	//============= Constructors =============//
	/** Default constructor */
	public Problem() {
		tasks = new Vector<CoupledTask>();
	}

	
	//============= Getters =============//
	/** Return the i^th task
	 * @param i task's rank
	 * @return i^th task */
	public CoupledTask getTask(int i) {
		return tasks.get(i);
	}
	
	/** Return an iterator on the tasks
	 * @return an iterator on the list of coupled tasks */
	public Iterator<CoupledTask> getTaskIterator() {
		return tasks.iterator();
	}
	
	
	//============= Methods =============//
	/** Adds a given task to the instance
	 * @param t the task */
	public void addCoupledTask(CoupledTask t) {
		tasks.add(t);
	}
	
	/** Compute the total number of tasks (not of operations) and return it.
	 * Total #ops = 2*#tasks.
	 * @return Total number of tasks */
	public int getNumTasks() {
		int num = 0;
		for (CoupledTask t: tasks) num += t.multiplicity;
		return num;
	}
	
	/** Computes a greedy ~ ugly upper bound
	 * (greedy single type block schedule) */
	public int computeUpperBound() {
		int C = 0;
		for (CoupledTask t: tasks) {
			int a = Math.max(t.a, t.b);
			int b = Math.min(t.a, t.b);
			// Now a >= b
			int num_blocks = t.multiplicity / (t.L/a+1); // Number of blocks
			int rem = t.multiplicity % (t.L/a+1); // Remaining
			C += num_blocks * (a*(1+t.L/a)+t.L+b);
			if (rem != 0)
				C += rem*a+t.L+b;
		}
		return C;
	}
	
	/** Computes total time spent processing operations */
	public int totalProcessingTime() {
		int p = 0;
		for (CoupledTask t: tasks)
			p += (t.a+t.b)*t.multiplicity;
		return p;
	}
}