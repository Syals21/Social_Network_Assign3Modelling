# Person 1 Model Notes

## Assignment Fit

This Octave ABM uses:

- 100 citizen agents, within the required 50-200 range.
- 5 influencer agents, within the required 3-10 range.
- 3 education expert agents, within the required 1-5 range.
- 75 time steps, within the required 50-100 range.
- Citizen opinions in the range `[-1, +1]`.
- Random adjacency matrices for citizen-citizen, citizen-influencer, and citizen-expert links.
- Trust matrices in the range `[0, 1]`.

The assignment PDF says the maximum group size is two persons. The practical plan has three roles, so this Person 1 work can be merged with the GUI or report work if the instructor enforces the two-person limit.

## Files

- `main.m` runs all four scenarios.
- `scenario_config.m` stores baseline and experiment parameters.
- `initialize_agents.m` creates citizen, influencer, and expert opinions.
- `build_network.m` creates random networks and trust matrices.
- `run_simulation.m` applies the opinion update equation.
- `classify_result.m` labels the final opinion pattern.
- `export_results.m` writes CSV outputs for the GUI and report.
- `export_scenario_summary.m` writes the combined scenario comparison CSV.

## Opinion Update

For every citizen `i` at each time step:

```text
O_i(t+1) = O_i(t)
           + direct_effect
           + average_effect
           + expert_effect
           + influencer_effect
```

The implemented effects are:

```text
direct_effect = alpha * T_ij * citizen_influence_j * (O_j - O_i)
average_effect = beta * (mean_neighbour_opinion - O_i)
expert_effect = gamma * trust_expert * expert_strength * (mean_expert_opinion - O_i)
influencer_effect = delta * trust_influencer * influencer_strength * (mean_influencer_opinion - O_i)
```

After every update, opinions are clipped to `[-1, +1]`.

## Scenarios

- `baseline`: normal influence, normal trust, normal expert correction.
- `strong_influencer`: stronger influencer effect, higher influencer trust, and lower influencer link probability so citizens are more likely to follow different extreme influencers instead of averaging all influencers together.
- `strong_expert`: stronger expert correction, higher expert trust, higher expert connectivity.
- `low_trust`: reduced trust across all agent types and weaker update effects.

## CSV Outputs

Each scenario exports:

- `SCENARIO_opinion_history.csv`
- `SCENARIO_average_history.csv`
- `SCENARIO_final_opinions.csv`
- `SCENARIO_A_cc.csv`
- `SCENARIO_A_ci.csv`
- `SCENARIO_A_ce.csv`
- `SCENARIO_summary.csv`

The combined comparison table is:

- `scenario_summary.csv`
