package constraints;

import choco.kernel.solver.ContradictionException;
import choco.kernel.solver.constraints.global.scheduling.AbstractTaskSConstraint;
import choco.kernel.solver.variables.integer.IntDomainVar;
import choco.kernel.solver.variables.scheduling.TaskVar;


/** This constraint identify mandatory gaps and fix
 * some tasksin there to help energetic reasoning */
@SuppressWarnings("rawtypes")
public class MandatoryGaps extends AbstractTaskSConstraint {		
	public MandatoryGaps(TaskVar[] taskvars) {
		super(taskvars, (IntDomainVar[])null, (IntDomainVar)null);
	}

	
	@Override
	public void propagate() throws ContradictionException {
		identifyGaps();
	}

	public void identifyGaps() {
		int gap;
		for (TaskVar<?> t: taskvars) {
			gap = (t.getEST() + t.getMinDuration()) - (t.getLCT() - t.getMinDuration());
			if (gap > 0)
				System.out.println(t.getName()+":\t"+(t.getLCT() - t.getMinDuration())+"->"+(t.getEST() + t.getMinDuration()));
		}
	}
	
}
