package problem;

import java.awt.Color;
import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import resources.StdDraw;
import choco.cp.solver.CPSolver;
import choco.kernel.common.util.iterators.DisposableIterator;
import choco.kernel.solver.variables.scheduling.TaskVar;


/** Stores and draws a solution */
public class Solution {
	//============= Fields =============//
	//         ( Private scope )        //
	/** The problem */
	private Problem pb;
	
	/** The solver */
	private CPSolver solver;

	/** Drawing offset */
	private static final int offset = 2;

	
	//============= Constructors =============//
	/** Constructor
	 * @param pb the problem
	 * @param solv solver used */
	public Solution(Problem pb, CPSolver solv) {
		this.pb = pb;
		this.solver = solv;
	}


	//============= Methods =============//
	/** Draw the final schedule */
	public void drawSchedule() {
		setCanvas();
		drawTasks();
	}
	
	/** Creates a file, named according to
	 * the current time and date and save
	 * the schedule into this file */
	public void drawToFile() {
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd_HH:mm:ss");
		Date date = new Date();
		
		File file = new File(dateFormat.format(date)+".png");
		drawToFile(file.getAbsolutePath());
	}

	/** Save the schedule into a file with the given name */
	public void drawToFile(String filename) {
		drawSchedule();
		StdDraw.save(filename);
	}
	
	/** Initialize the drawing area */
	private void setCanvas() {
		StdDraw.clear();
		StdDraw.setCanvasSize(1024,256);
		StdDraw.setYscale(0, 1.9);
		StdDraw.setXscale(0, solver.getObjectiveValue().intValue() + 2);
	}
	
	
	/** Draw the tasks */
	@SuppressWarnings("rawtypes")
	private void drawTasks() {
		DisposableIterator<TaskVar> tv = solver.getTaskVarIterator();
		
		// Draw and color the task
		// Assumes that task name ix aX or bX with X its number
		while (tv.hasNext()) {
			TaskVar t = tv.next();
			float x = t.start().getVal();
			float y = t.end().getVal();
			Random r = new Random(Integer.parseInt(t.getName().substring(1))*1000);

			StdDraw.setPenColor(Color.getHSBColor(r.nextFloat(),r.nextFloat(),r.nextFloat()));
			StdDraw.filledRectangle((x+y)/2+offset, 1, (y-x)/2, .5);
			StdDraw.setPenColor(Color.BLACK);
			StdDraw.rectangle((x+y)/2+offset, 1, (y-x)/2, .5);
		}
	}


	public Problem getPb() {
		return pb;
	}


	public CPSolver getSolver() {
		return solver;
	}
	
	public int getMakespan() {
		return solver.getObjectiveValue().intValue();
	}
}
