# Part 2 Practical Section Plan

Assignment: STTHK2133 Modeling & Simulation A252 - Assignment 3  
Topic: Opinion Dynamics in a Social Network  
Submission date: 27 June 2026 via Learning Portal

## Important Group Note

The assignment PDF states that the maximum group size is two persons. This plan divides the practical work into three tasks because the group requested a three-person division. Before using this three-person structure, confirm with the instructor that a group of three is allowed. If only two people are allowed, merge Person 3's reporting/analysis work into Person 1 and Person 2.

## Practical Section Goal

Build an Agent-Based Model (ABM) to simulate how public opinion changes over time about the Ministry of Education introducing AI-powered learning assistants in secondary schools and universities.

The model should help answer:

- Will public opinion converge toward support for AI?
- Will society become polarized?
- Can misinformation or strong influencers affect adoption?
- Which interventions can increase public acceptance?

The simulation must classify the final opinion pattern as consensus, polarization, fragmentation, echo chambers, or mixed/neutral.

## Required Agents

### 1. Citizens

Required number: 50-200 agents.

Each citizen must have:

- Opinion `O_i` in the range `[-1, +1]`
  - `-1` = strongly against AI
  - `0` = neutral
  - `+1` = strongly support AI
- Trust `T_ij` in other agents, range `[0, 1]`
- Low influence level
- Network connections to other agents

Main role:

- Interact with other citizens, influencers, and experts.
- Update opinions based on direct influence and neighbour average opinion.

### 2. Influencers

Required number: 3-10 agents in the setup. The role description also mentions 4-10, so choose a value that satisfies both, such as 5 or 6.

Each influencer should have:

- High connectivity, meaning many citizens follow or are connected to them
- Strong influence strength
- Often strong or extreme opinions

Main role:

- Spread opinions quickly through the network.
- Test whether a small number of influential agents can shift public opinion or create polarization.

### 3. Education Experts

Required number: 1-5 agents in the setup. The role description also mentions 2-5, so choose a value that satisfies both, such as 3.

Each expert should have:

- High credibility and high trust from citizens
- Moderate influence strength
- Balanced or evidence-based opinions, usually near neutral or moderately supportive

Main role:

- Stabilize public opinion.
- Reduce extreme opinions.
- Provide corrective or factual influence.

## Required Network Structure

Use a random network.

Recommended approach:

- Use Python with `networkx`.
- Create a random network for citizen-citizen connections.
- Add influencer-citizen links with higher degree than normal citizens.
- Add expert-citizen links with moderate degree but higher trust.

Suggested network settings:

- Citizens: `N = 100`
- Influencers: `I = 5`
- Experts: `E = 3`
- Time steps: `T = 75`
- Initial citizen opinions: random values from `[-1, +1]`

These values are inside the assignment requirements and are manageable for coding, plotting, and analysis.

## Required Interaction Rules

The opinion update should combine four effects.

### 1. Direct Influence

When citizen `i` interacts with connected agent `j`, citizen `i` moves slightly toward agent `j`'s opinion.

Suggested formula:

```text
direct_effect = alpha * T_ij * influence_j * (O_j - O_i)
```

Where:

- `alpha` = direct interaction learning rate
- `T_ij` = trust of citizen `i` toward agent `j`
- `influence_j` = influence strength of the connected agent
- `O_j - O_i` = opinion difference

### 2. Averaging Effect

Citizen `i` is also affected by the average opinion of neighbours.

Suggested formula:

```text
average_effect = beta * (mean_neighbour_opinion - O_i)
```

Where:

- `beta` = strength of social pressure or averaging effect
- `mean_neighbour_opinion` = average opinion of connected neighbours

Expected result:

- Gradual convergence
- Possible echo chamber formation if the network has separated groups

### 3. Education Expert Effect

Experts reduce extremism by pulling citizens toward a balanced expert view.

Suggested formula:

```text
expert_effect = gamma * trust_expert * (mean_expert_opinion - O_i)
```

Where:

- `gamma` = expert intervention strength
- `trust_expert` = citizen trust toward experts
- `mean_expert_opinion` = average opinion of connected experts

Expected result:

- More stable opinions
- Lower variance
- Less extreme opinions

### 4. Influencer Effect

Influencers have stronger persuasive power and can move opinions faster.

Suggested formula:

```text
influencer_effect = delta * trust_influencer * influencer_strength * (mean_influencer_opinion - O_i)
```

Where:

- `delta` = influencer effect strength
- `trust_influencer` = citizen trust toward influencers
- `influencer_strength` = high influence value
- `mean_influencer_opinion` = average opinion of connected influencers

Expected result:

- Fast diffusion of opinion
- Possible polarization
- Possible domination by a small number of influencers

### Complete Opinion Update

For every citizen at each time step:

```text
O_i(t+1) = O_i(t)
           + direct_effect
           + average_effect
           + expert_effect
           + influencer_effect
```

After updating, clip the opinion value so it stays inside `[-1, +1]`.

```text
O_i(t+1) = max(-1, min(1, O_i(t+1)))
```

## Required Simulation Scenarios

Run at least four scenarios.

### Scenario 1: Baseline Model

Purpose:

- Observe whether opinions naturally converge or remain mixed.

Settings:

- Normal interaction among citizens, influencers, and experts
- Moderate trust
- Moderate influencer strength
- Moderate expert effect

Expected analysis:

- Does the population move toward consensus?
- Is the final opinion distribution still mixed?

### Scenario 2: Strong Influencer Impact

Purpose:

- Analyze whether society becomes polarized or quickly aligned.

Settings:

- Increase influencer strength
- Keep experts and trust at normal baseline values

Expected analysis:

- Do influencers dominate average public opinion?
- Does the final histogram show extreme groups?
- Does the 2D/3D temporal plot show fast movement?

### Scenario 3: Strong Expert Intervention

Purpose:

- Check whether experts reduce polarization and stabilize opinions.

Settings:

- Increase trust in experts
- Increase expert intervention strength
- Keep influencer strength moderate

Expected analysis:

- Does variance decrease?
- Do extreme opinions move toward neutral or moderate support?
- Does expert intervention always create consensus?

### Scenario 4: Low Trust Environment

Purpose:

- Observe whether fragmentation or instability occurs.

Settings:

- Reduce trust across all agents
- Keep influence strengths similar to baseline

Expected analysis:

- Does the system fail to converge?
- Are opinions unstable or fragmented?
- Are echo chambers more visible?

## Required Outputs

The model must produce:

- Interactive system with functional GUI
- 2D temporal plot of average opinion over time
- 2D temporal plot of individual citizen opinions over time
- 3D temporal plot of individual opinions
- Histogram of final opinions
- Network visualization, optional but recommended
- Short explanation of findings

Recommended Python libraries:

- `numpy` for calculations
- `pandas` for results tables
- `networkx` for random network construction
- `matplotlib` for 2D, 3D, and histogram plots
- `tkinter`, `streamlit`, or `gradio` for GUI

For a simple assignment-friendly GUI, use `tkinter` if no web interface is needed. Use `streamlit` if the group wants a cleaner interactive dashboard.

## Analysis Questions to Answer in the Report

For each scenario, answer:

- Does the system show consensus, polarization, fragmentation, or echo chambers?
- What is the impact of citizens, influencers, and experts?
- Is the system stable or unstable?

Then answer these overall questions:

1. Can a small number of influencers dominate public opinion? Explain using simulation results.
2. Does increasing education expert influence always lead to consensus? Why or why not?
3. What happens when the averaging effect is very strong? Is this realistic in real society?
4. Which factor is most important in preventing polarization: trust, experts, or network structure?
5. If you were a policy maker, how would you use education experts to stabilize public opinion?

## Three-Person Task Division

### Person 1: Model Design and Core Simulation

Main responsibility:

- Build the ABM engine.

Tasks:

- Define agents and parameters.
- Implement random network generation.
- Implement opinion update rules.
- Implement all four scenarios.
- Store simulation results for every time step.
- Make sure opinions stay inside `[-1, +1]`.

Deliverables:

- Core Python simulation file.
- Scenario parameter settings.
- Saved raw results for all scenarios.

Suggested files:

```text
simulation.py
model_config.py
results/scenario_summary.csv
```

### Person 2: GUI, Visualizations, and Experiment Output

Main responsibility:

- Build the interactive system and produce required plots.

Tasks:

- Create the GUI.
- Add controls for scenario and parameters.
- Connect GUI to the simulation function.
- Generate 2D average opinion plots.
- Generate individual opinion temporal plots.
- Generate 3D temporal plots.
- Generate final opinion histograms.
- Optional: create network visualization.

Deliverables:

- GUI file or dashboard file.
- All required graphs.
- Visual result folder.

Suggested files:

```text
app.py
plotting.py
results/*.png
```

### Person 3: Analysis, Report, and Final Packaging

Main responsibility:

- Interpret results and prepare final submission.

Tasks:

- Create result tables from scenario outputs.
- Classify each scenario as consensus, polarization, fragmentation, echo chamber, or mixed.
- Answer all analysis questions.
- Write the 2-5 page report.
- Check that equations and model design are clearly explained.
- Prepare final submission folder.

Deliverables:

- Short report.
- Analysis table.
- Final checklist.

Suggested files:

```text
report.docx or report.pdf
analysis_summary.md
submission_checklist.md
```

## Recommended Final Folder Structure

```text
Assignment03_Practical/
  code/
    simulation.py
    plotting.py
    app.py
    model_config.py
  results/
    baseline_average_opinion.png
    baseline_individual_opinions.png
    baseline_3d_temporal_plot.png
    baseline_histogram.png
    strong_influencer_average_opinion.png
    strong_expert_average_opinion.png
    low_trust_average_opinion.png
    scenario_summary.csv
  report/
    Assignment03_Report.pdf
  README.md
```

## Practical Section Completion Checklist

- [ ] 50-200 citizens included.
- [ ] 3-10 influencers included.
- [ ] 1-5 education experts included.
- [ ] Opinions initialized randomly in `[-1, +1]`.
- [ ] Random network structure implemented.
- [ ] Direct influence rule implemented.
- [ ] Averaging effect implemented.
- [ ] Expert effect implemented.
- [ ] Influencer effect implemented.
- [ ] 50-100 time steps used.
- [ ] Baseline scenario completed.
- [ ] Strong influencer scenario completed.
- [ ] Strong expert intervention scenario completed.
- [ ] Low trust scenario completed.
- [ ] Interactive GUI completed.
- [ ] 2D average opinion plot completed.
- [ ] 2D individual opinion plot completed.
- [ ] 3D temporal opinion plot completed.
- [ ] Final opinion histogram completed.
- [ ] Optional network visualization completed.
- [ ] Short explanation of findings completed.
- [ ] Report includes model design.
- [ ] Report includes equations.
- [ ] Report includes experiments.
- [ ] Report includes analysis and discussion.
- [ ] Report includes conclusion.
- [ ] Source code, graphs, tables, and report are ready for submission.
