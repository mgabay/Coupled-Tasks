import java.io.File;

import problem.CoupledTask;
import problem.Problem;
import problem.Solution;
import solve.IdSolver;


/** Main class */
public class Main {

	public static void main(String[] args) {		
		int a = 5, b = 3, L = 100, n = 12;

		for (n = 10; n < 100; ++n) {
			// Create idct problem
			Problem pb = new Problem();
			pb.addCoupledTask(new CoupledTask(a,b,L,n));

			// Solve problem
			//CTSolver solver = new CTSolver(pb);
			IdSolver solver = new IdSolver(pb);
			solver.solve();
			
			Solution s = solver.getSolution();
			//s.drawSchedule();
			File file = new File(a+"-"+b+"-"+L+"-"+n+"-C"+s.getMakespan()+".png");
			s.drawToFile(file.getAbsolutePath());
		}
	}

}
