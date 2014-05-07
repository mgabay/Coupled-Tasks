package solve;

import java.util.Iterator;

import problem.CoupledTask;
import problem.Problem;
import problem.Solution;
import choco.Choco;
import choco.cp.model.CPModel;
import choco.cp.solver.CPSolver;
import choco.kernel.common.logging.ChocoLogging;
import choco.kernel.common.logging.Verbosity;
import choco.kernel.model.variables.scheduling.TaskVariable;
import choco.kernel.solver.ContradictionException;

/** Coupled Tasks Scheduling Problem Solver, using Choco */
public class CTSolver {
	//============= Fields =============//
	//         ( Private scope )        //

	/** The problem */
	private Problem pb;
	
	/** The constraint programming solver */
	private CPSolver solver;
	
	/** This variable is set to true if the problem has been solved */
	private boolean solved;

	
	//============= Constructors =============//
	/** Constructor
	 * @param pb the problem */
	public CTSolver(Problem prob) {
		pb = prob;
		solver = new CPSolver();
		solved = false;
	}
	

	//============= Methods =============//
	/**	Generates the constraint programming model
	 * @return the model */
	private CPModel makeModel()  {
		// Model and general usage data
		CPModel model = new CPModel();
		final int num_tasks = pb.getNumTasks();
		final int UB = pb.computeUpperBound();
		
		// Tasks creation
		int count = 0;
		Iterator<CoupledTask> tsk = pb.getTaskIterator();
		TaskVariable[] tasks = new TaskVariable[2*num_tasks];

		while (tsk.hasNext()) {
			CoupledTask t = tsk.next();
			for(int j = 0; j < t.getMultiplicity(); ++j) {
				// Makes the two corresponding tasks
				tasks[count] = Choco.makeTaskVar("a"+ count, UB, t.getA());
				tasks[count+num_tasks] = Choco.makeTaskVar("b"+ count, UB, t.getB());
				
				// Exact gap constraint
				model.addConstraint(
						Choco.eq(
								Choco.minus(tasks[count+num_tasks].start(), tasks[count].end()),
								t.getL()
						)
				);
				
				// Precedence constraints (break symmetries)
				if (j > 0) {
					model.addConstraint(Choco.precedence(tasks[count-1], tasks[count]));
					model.addConstraint(Choco.precedence(tasks[count+num_tasks-1], tasks[count+num_tasks]));
				}
				++count;
			}
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
			ChocoLogging.setVerbosity(Verbosity.SOLUTION);
			solver.read(makeModel());
			
			try {
				solver.propagate();
				System.out.println(solver.getMakespan().pretty());
			} catch (ContradictionException e) {
				e.printStackTrace();
			}
			solver.minimize(solver.getMakespan(), false);
			System.out.println(solver.getObjectiveValue());
			solved = true;
		}
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
	}
}
