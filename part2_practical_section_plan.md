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

## Step-by-Step Work Plan

### Step 1: Understand and Define the Model

Prepare the model design before coding.

Tasks:

- Define citizen, influencer, and expert agents.
- Decide default parameter values.
- Decide how trust is represented.
- Decide how random network links are generated.
- Write the opinion update equation.
- Decide how to classify final outcomes.

Suggested default parameters:

```text
citizens = 100
influencers = 5
experts = 3
time_steps = 75
alpha = 0.05
beta = 0.08
gamma = 0.05
delta = 0.06
citizen_influence = 0.2
influencer_influence = 0.8
expert_influence = 0.5
baseline_trust = 0.5
expert_trust = 0.7
```

### Step 2: Build the Agent Classes or Data Structures

Create a structure for each agent type.

Each agent should store:

- Agent ID
- Agent type: citizen, influencer, or expert
- Opinion
- Influence level
- Trust values
- Network neighbours

The simplest method is to use dictionaries or a `dataclass`.

### Step 3: Build the Random Network

Create the social network.

Tasks:

- Generate random citizen-citizen connections.
- Add influencers with many citizen connections.
- Add experts with moderate citizen connections.
- Store all neighbours for each agent.
- Store trust values for connected pairs.

Recommended:

- Citizens connect randomly with probability around `0.05` to `0.10`.
- Influencers connect to many citizens, around `30%` to `60%` of citizens.
- Experts connect to around `20%` to `40%` of citizens.

### Step 4: Implement Opinion Updating

For each time step:

- Loop through all citizens.
- Calculate direct influence from connected agents.
- Calculate average neighbour opinion.
- Calculate expert effect.
- Calculate influencer effect.
- Update citizen opinion.
- Clip opinion to `[-1, +1]`.
- Store individual and average opinions for plotting.

Important:

- Update all citizens using the old opinions from the current time step.
- Apply the new opinions only after all citizens are calculated. This avoids order bias.

### Step 5: Create the Four Scenarios

Create a function such as:

```text
run_scenario(scenario_name, parameters)
```

Each scenario should use the same simulation structure but different parameter values.

Suggested scenario changes:

| Scenario | Main parameter change |
|---|---|
| Baseline | Normal values |
| Strong Influencer Impact | Increase `delta` and `influencer_influence` |
| Strong Expert Intervention | Increase `gamma` and `expert_trust` |
| Low Trust Environment | Reduce all trust values |

### Step 6: Generate Graphs and Tables

For each scenario, generate:

- Line graph of average opinion over time
- Line graph showing individual citizen opinions over time
- 3D temporal plot where x = time, y = citizen ID, z = opinion
- Final opinion histogram
- Summary table with mean, variance, standard deviation, minimum, maximum, and classification

Suggested classification rules:

```text
Consensus:
  final standard deviation < 0.20
  and most opinions are near the same side

Polarization:
  many citizens near -1 and many citizens near +1
  and final standard deviation is high

Fragmentation:
  several separated opinion groups appear

Neutral or mixed:
  average opinion near 0
  and no clear consensus or two-sided polarization

Echo chamber:
  connected subgroups keep different average opinions
```

### Step 7: Build the GUI

The GUI should allow the user to:

- Select scenario
- Set number of citizens
- Set number of influencers
- Set number of experts
- Set time steps
- Adjust influencer strength
- Adjust expert trust or expert strength
- Adjust general trust
- Run simulation
- View plots and summary findings

Minimum functional GUI:

- Dropdown or buttons for scenario selection
- Run button
- Display area for plots
- Text summary of final classification

### Step 8: Run Experiments and Save Results

Run every scenario at least once. Better: run each scenario three times with different random seeds and report average results.

For each scenario, save:

- Graph images
- Summary table
- Main findings
- Parameter settings

Suggested files:

```text
results/baseline_average_opinion.png
results/baseline_individual_opinions.png
results/baseline_3d_temporal_plot.png
results/baseline_histogram.png
results/scenario_summary.csv
```

### Step 9: Write the Short Report

The report must be 2-5 pages.

Required report sections:

- Model design
- Equations
- Experiments
- Analysis and discussion
- Conclusion

Suggested report structure:

```text
1. Introduction
2. Model Design
3. Opinion Update Equations
4. Simulation Experiments
5. Results and Discussion
6. Conclusion
```

### Step 10: Final Submission Checklist

Submit:

- ABM source code in Python or Octave
- Simulation result graphs
- Simulation result tables
- Short report, 2-5 pages

Before submission, check:

- All four scenarios are included.
- GUI runs without error.
- Plots are clearly labelled.
- Report explains equations and findings.
- Results answer all six analysis questions.
- Code comments are clear enough for the instructor to follow.

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

## Suggested Timeline

### Day 1

- Person 1 completes model design and first working baseline simulation.
- Person 2 prepares plotting functions.
- Person 3 prepares report outline and analysis table template.

### Day 2

- Person 1 completes all four scenarios.
- Person 2 completes GUI and required plots.
- Person 3 starts writing model design and equations section.

### Day 3

- Group runs experiments and checks results.
- Person 3 completes analysis and discussion.
- Person 2 exports final graphs.
- Person 1 cleans code and comments.

### Final Day

- Combine source code, graphs, tables, and report.
- Test the GUI on another computer if possible.
- Confirm all assignment requirements are satisfied.
- Submit through the Learning Portal.

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
