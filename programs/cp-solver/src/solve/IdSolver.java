package solve;

import java.util.Iterator;

import problem.CoupledTask;
import problem.Problem;
import problem.Solution;
import choco.Choco;
import choco.cp.model.CPModel;
import choco.cp.solver.CPSolver;
import choco.cp.solver.search.BranchingFactory;
import choco.cp.solver.search.integer.valselector.MinVal;
import choco.kernel.common.logging.ChocoLogging;
import choco.kernel.model.variables.integer.IntegerVariable;
import choco.kernel.model.variables.scheduling.TaskVariable;
import choco.kernel.solver.ContradictionException;
import choco.kernel.solver.variables.scheduling.TaskVar;


/** Solver for the Identical Coupled Tasks Scheduling Problem */
public class IdSolver {
	//============= Fields =============//
	//         ( Private scope )        //

	/** The problem */
	private Problem pb;
	
	/** The constraint programming solver */
	private CPSolver solver;
	
	/** This variable is set to true if the problem has been solved */
	private boolean solved;

	/** Stores the task variables.<br>
	 * a tasks are indexed from 0 to length/2-1<br>
	 * b tasks are indexed from length/2 to length-1 */
	private TaskVariable[] tasks;
	
	/** Precedence variables.
	 * Implies a total ordering. Branching is done on
	 * these variables first */
	private IntegerVariable[] predbool;
	
	
	//============= Constructors =============//
	/** Constructor
	 * @param pb the problem */
	public IdSolver(Problem prob) {
		pb = prob;
		solver = new CPSolver();
		solved = false;
		tasks = null;
	}
	

	//============= Methods =============//
	/**	Generates the constraint programming model
	 * Only the first task is taken into account
	 * @return the model */
	private CPModel makeModel()  {
		// Model and general usage data
		CPModel model = new CPModel();
		Iterator<CoupledTask> tsk = pb.getTaskIterator();
		CoupledTask t = tsk.next();
		final int num_tasks = t.getMultiplicity();
		final int UB = pb.computeUpperBound();
		
		// Tasks creation
		int max = 2*num_tasks;
		tasks = new TaskVariable[max];
		//tasks = new TaskVariable[2*num_tasks];
		
		for(int j = 0; j < num_tasks; ++j) {
			// Makes the two corresponding tasks
			tasks[j] = Choco.makeTaskVar("a"+ j, UB, t.getA());
			tasks[j+num_tasks] = Choco.makeTaskVar("b"+ j, UB, t.getB());

			// Exact gap constraint
			model.addConstraint(
					Choco.eq(
							Choco.minus(tasks[j+num_tasks].start(), tasks[j].end()),
							t.getL()
					)
			);

			// Precedence constraints (break symmetries)
			if (j == 0)
				model.addConstraint(Choco.eq(tasks[0].start(),0));
			else
				model.addConstraint(
					Choco.leq(
						Choco.minus(tasks[j].start(), tasks[j-1].start()),
						t.getA()+t.getB()+t.getL()
					)
				);
			
			for (int i = 0; i < j; ++i) {
				model.addConstraint(Choco.precedence(tasks[i], tasks[j]));
				model.addConstraint(Choco.precedence(tasks[i+num_tasks], tasks[j+num_tasks]));
			}
		}
		
		// The following booleans state precedences between a and b tasks
		predbool = new IntegerVariable[num_tasks * num_tasks];
		int cpt = 0;
		for (int i = num_tasks; i < 2*num_tasks; i++) {
			for (int j = 0; j < num_tasks; j++) {
				predbool[cpt] = Choco.makeBooleanVar("Pred(a"+j+", b"+i+")");
				model.addConstraint(Choco.precedenceDisjoint(tasks[i], tasks[j], predbool[cpt]));
				cpt++;
			}
		}
		
		// Creates additionnal - fake tasks to be resized and placed later
		// in order to help energetic reasoning on the disjunctive constraint
		// by modeling "dead" timeslots
		for (int i = 2*num_tasks; i < max; ++i) {
			tasks[i] = Choco.makeTaskVar("g"+i, 0, UB, new IntegerVariable("a"+i, 0, t.getL()));
		}
		
		// Add disjunctive constraint
		model.addConstraint(Choco.disjunctive(tasks));
		
		return model;
	}
	
	
	/** Solve the problem */
	public void solve() {
		if (!solved) {
			//ChocoLogging.toSilent();
			ChocoLogging.toVerbose();
			//ChocoLogging.setVerbosity(Verbosity.SEARCH);
			ChocoLogging.setEveryXNodes(10000);
			//ChocoLogging.setLoggingMaxDepth(20);
			
			//BranchingFactory.setTimes(solver);
			solver.read(makeModel());

			// Lower bound through LP relaxation
			/* solver.post(new LinearProgrammingLB(
					solver.getVar(Arrays.copyOfRange(tasks, 0, tasks.length/2)),
					solver.getMakespan(),
					pb.getTask(0)
			));	*/
			
			// Set some fakish tasks to fill in the gap
			//solver.post(new MandatoryGaps(solver.getVar(tasks)));

			// New goals :
			// 1st : branch on precedences
			// 2nd : branch on starting times
			solver.clearGoals();	
			solver.addGoal(BranchingFactory.domWDeg(solver, solver.getVar(predbool), new MinVal()));
			//solver.addGoal(new AssignVar(new DomOverWDeg(solver,solver.getVar(predbool)), new MinVal()));
			solver.addGoal(BranchingFactory.setTimes(solver));
			
			try {
				solver.propagate();
				//System.out.println("Root propagate -> "+solver.getMakespan().pretty());
			} catch (ContradictionException e) {
				e.printStackTrace();
			}

			//solver.setGeometricRestart(20, 1.4);
			//solver.minimize(solver.getMakespan(), false);
			//solver.minimize(solver.getVar(tasks[tasks.length-1].end()), false);
			solver.minimize(solver.getVar(tasks[2*pb.getNumTasks()-1].end()), false);
			printSol();
			solved = true;
		}
	}
	
	
	/** Print statistics and solution */
	public void printSol() {
		System.out.println("============== Problem solved ==============");
		System.out.println("Makespan: "+solver.getObjectiveValue());
		System.out.println("Elapsed time: "+solver.getTimeCount());
		System.out.println(solver);
		System.out.println("============================================");
		for (TaskVar<?> t: solver.getVar(tasks)) {
			System.out.println(t.getName()+"\t"+t.getEST());
		}
		System.out.println("============================================");
	}

	/** Check feasibility
	 * @return true iff the solution is feasible */
	public boolean isFeasible() {
		solve();
		return solver.isFeasible();
	}
	
	
	/** Draw computed schedule */
	public void drawSchedule() {
		if (!isFeasible()) {
			System.out.println("Cannot draw : Solution is not feasible");
			return;
		}
		Solution s = new Solution(pb, solver);
		s.drawSchedule();
		//s.drawToFile();
	}
	
	public Solution getSolution() {
		if (!isFeasible()) {
			System.err.println("No solution found!");
			System.exit(1);
		}
		return new Solution(pb, solver);
	}
}
