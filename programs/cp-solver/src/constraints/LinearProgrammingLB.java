package constraints;

import ilog.concert.IloException;
import ilog.concert.IloNumVar;
import ilog.cplex.IloCplex;
import problem.CoupledTask;
import choco.kernel.solver.ContradictionException;
import choco.kernel.solver.constraints.global.scheduling.AbstractTaskSConstraint;
import choco.kernel.solver.variables.integer.IntDomainVar;
import choco.kernel.solver.variables.scheduling.TaskVar;

@SuppressWarnings("rawtypes")
public class LinearProgrammingLB extends AbstractTaskSConstraint {
	/** Makespan variables - used for upper and lower bounds */
	private IntDomainVar makespan;
	
	/** A task - its details are required to build the model **/
	private CoupledTask task;
	
	
	/** Constructor */
	public LinearProgrammingLB(TaskVar[] taskvars, IntDomainVar makespan, CoupledTask ct) {
		super(taskvars, null, makespan);
		this.makespan = makespan;
		this.task = ct;
	}

	
	@Override
	public void propagate() throws ContradictionException {
		double d = solve();
		makespan.updateInf((int)Math.ceil(d)+task.getA() + task.getL() + task.getB(),this,false);
	}

	
	/** Initializes the solver, runs the model and catch exceptions */
	private double solve() {
		double objValue = 0.0;
		try {
			IloCplex cplex = new IloCplex();
			cplex.setOut(null); // No logging
			makeModel(cplex);
			if ( cplex.solve() ) {
				// update objective
				objValue = cplex.getObjValue();
			}
			cplex.end();
		} catch (IloException e) {
			e.printStackTrace();
		}
		return objValue;
	}
	
	
	/** Build the LP model using current domains */
	private void makeModel(IloCplex cplex) throws IloException {
		int len = taskvars.length;
		int window = task.getA()+task.getB()+task.getL();	// window size
		int numTasks = task.getL()/task.getA() + 2;			// max #tasks in a window
		int bigM = makespan.getSup();						// a M value
		

		// Starting times variables //
		double[] lbt = new double[len];
		double[] ubt = new double[len];
		// Bounds using variables domains
		for (int i = 0; i < len; ++i) {
			lbt[i] = taskvars[i].getEST();
			ubt[i] = taskvars[i].getLST();
		}
		// Create variables
		IloNumVar[] t = cplex.numVarArray(len, lbt, ubt);
		
		
		// Placement variables //
		double[][] lby = new double[len][len];
		double[][] uby = new double[len][len];
		// Bounds
		for (int i = 0; i < len; ++i) {
			for (int j = 0; j < len; ++j) {
				lby[i][j] = 0;
				uby[i][j] = i >= j ? 0 : 1;
			}
		}
		// Create variables
		IloNumVar[][] y = new IloNumVar[len] [];
		for (int i = 0; i < len; ++i) {
			y[i] = cplex.numVarArray(len, lby[i], uby[i]);
		}


		// Objective //
		cplex.addMinimize(t[len-1]); // minimize last start date
		
		
		// Constraints //
		// t[i] >= t[i-1] + a;
        // t[i] <= t[i-1] + s;
		for (int i = 1; i < len; ++i) {
			// t[i] >= t[i-1] + a;
			cplex.addGe(
					cplex.sum(t[i], cplex.prod(-1.0, t[i-1])),
					task.getA()
			);
			
			// t[i] <= t[i-1] + s;
			cplex.addLe(
					cplex.sum(t[i], cplex.prod(-1.0, t[i-1])),
					window
			);
		}
		
		// y[i][j] >= y[i][j - 1];
		for (int i = 0; i < len; ++i) {
			for (int j = i+1; j < len; ++j) {
				cplex.addGe(y[i][j], y[i][j-1]);
			}
		}
		
		// Overlap constaints
		// Remark that we only need to take the following decisions
		// if aj is not already too far away (>= ti + a + L + b) from ai
        // t[j] - t[i] <= L + y[i][j] * M;  --	either aj starts before bj 
        // t[j] - t[i] >= s * y[i][j];		--	or aj starts after bj
		for (int i = 0; i < len; ++i) {
			for (int j = i+1; j < i + numTasks && j < len; ++j) {
		        // t[j] - t[i] <= L + y[i][j] * M
				cplex.addLe(
						cplex.sum(t[j], cplex.prod(-1.0, t[i]), cplex.prod(-1.0*bigM, y[i][j])),
						task.getL()
				);
				// t[j] - t[i] >= s * y[i][j];
				cplex.addGe(
						cplex.sum(t[j], cplex.prod(-1.0, t[i]), cplex.prod(-1.0*window, y[i][j])),
						0.0
				);
			}
		}
	}
}
