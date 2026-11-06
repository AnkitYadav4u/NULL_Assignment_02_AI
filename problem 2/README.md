# Problem 2: Mars Rover Sample Collection Planning using PDDL

## Files

- `Domain.pddl`: STRIPS/typing rover domain.
- `Problem.pddl`: Original five-rock scenario.
- `Problem_extended.pddl`: Seven-rock dust-storm scenario.
- `planner_output/`: Pyperplan logs and `.soln` plans for four searches.
- `outputs/analysis_report.md`: Search comparison, final-state verification, and discussion.
- `outputs/screenshots/`: PNG screenshots of the four planner runs and plan verification.
- `verify_plans.py`: Simulates the generated plans without external planners.

## Local environment

The `plplanner` virtual environment is stored only as a local tool environment:

```bash
python3 -m venv .venv
.venv/bin/pip install pyperplan
```

## Generate plans

```bash
.venv/bin/pyperplan -s gbf -H hff Domain.pddl Problem.pddl
.venv/bin/pyperplan -s astar -H lmcut Domain.pddl Problem.pddl
.venv/bin/pyperplan -s gbf -H hff Domain.pddl Problem_extended.pddl
.venv/bin/pyperplan -s astar -H lmcut Domain.pddl Problem_extended.pddl
```

## Verify plans

```bash
.venv/bin/python verify_plans.py
```

Generated plans are retained in `planner_output/*.soln`.
