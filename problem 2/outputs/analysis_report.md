# Problem 2: Mars Rover Sample Collection Planning using PDDL

## Search and planner configuration

Pyperplan 2.1 was used.

| Scenario | Configuration | Search | Heuristic | Plan length | States expanded | Planning time |
|---|---|---|---|---:|---:|---:|
| Original | Satisficing | Greedy best-first | hFF | 32 | 46 | 0.0042 s |
| Original | Optimal | A* | LM-Cut | 25 | 1791 | 1.4 s |
| Extended dust storm | Satisficing | Greedy best-first | hFF | 40 | 51 | 0.0056 s |
| Extended dust storm | Optimal | A* | LM-Cut | 40 | 15180 | 15.0 s |

For A*, the LM-Cut heuristic is admissible, so the 25-action and 40-action plans produced for their respective scenarios are optimal under the action-cost model (unit cost per action).

## Original scenario — goal verification

The optimal plan has 25 actions. Simulation verified:

- Rock1, Rock2, Rock3, Rock4, and Rock5 are all at Base.
- Bay1 and Bay2 are empty.
- Curiosity is at Base.

The greedy plan also passes verification and contains 32 actions. The difference occurs because greedy best-first prefers immediate heuristic estimates and does not guarantee the shortest plan, whereas A* continues searching until it proves the optimal solution.

## Optimal plan uses of both bays and the drill

The 25-action plan begins at Base and moves to SiteB and SiteD. No drill is needed at those soft-rock sites; the rover deposits Rock4 and Rock2 after collecting them. It then visits:

1. SiteE to pick up Drill1.
2. SiteF to collect Rock5 into Bay1.
3. SiteE and SiteC to collect the hard Rock3 into Bay2.
4. Base to deposit both hard rocks.
5. SiteB and SiteD to collect Rocks2 and Rock4.
6. Base for their deposit.
7. SiteA to collect and deposit Rock1.

Both Bay1 and Bay2 are therefore used as one-rock transport capacity, allowing the rover to collect two nearby samples before returning to Base.

## Dust-storm extended scenario

The Base–SiteB route is absent in both directions. The route SiteB↔SiteD remains available, so the one-way SiteC→SiteD route is the only relevant special route but is not necessary for the returned A* and greedy plans.

In the generated A* plan, the rover reaches SiteD through the one-way route `SiteC → SiteD`, then continues to SiteB through `SiteD → SiteB`.

`Base → SiteA → SiteC → SiteD → SiteB ...`

The Route `SiteC → SiteD` is therefore used, while the reverse `SiteD → SiteC` is never required. Rock4 is collected at SiteD, Rock2 at SiteB, and the dust-storm closure does not block these locations because their connectivity to Base is bypassed through SiteA and SiteC.

Verification confirmed Rock1 through Rock7 at Base, both bays empty, and Curiosity at Base.

## Plan-length analysis

The original scenario's optimal plan is shorter: 25 actions versus the greedy plan's 32 actions. The extended scenario happens to have the same length (40 actions) for both searches, although A* expands substantially more states and takes longer because it proves optimality.

This demonstrates that a satisficing planner is generally faster and may miss better plans, while an optimal planner guarantees minimum length but can require much more search effort.

## Generated plan verification

`verify_plans.py` simulated every action and reported VERIFIED for all four generated solution files:

- `original_gbf.soln`: 32 actions, valid
- `original_astar.soln`: 25 actions, valid
- `extended_gbf.soln`: 40 actions, valid
- `extended_astar.soln`: 40 actions, valid
