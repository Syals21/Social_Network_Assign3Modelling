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

- Use GNU Octave adjacency matrices.
- Create a random `N x N` matrix for citizen-citizen connections.
- Create an `N x I` matrix for influencer-citizen links with higher degree than normal citizens.
- Create an `N x E` matrix for expert-citizen links with moderate degree but higher trust.

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

Recommended tools:

- GNU Octave for the ABM simulation engine.
- Octave matrix operations for opinions, trust, and network adjacency.
- Octave figure windows for graph results.
- A single HTML file containing the GUI, CSS, and JavaScript.
- Browser-side JavaScript for the interactive dashboard and plots.

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

### Person 1: Octave ABM Engine and Scenario Simulation

Main responsibility:

- Build the full ABM simulation engine using GNU Octave.
- Produce graph results directly in Octave for screenshots and report analysis.

Tasks:

- Create the main Octave file `main.m`.
- Keep the Octave work in one file only: `main.m`.
- Use matrices/vectors instead of complicated object-oriented code because Octave works well with matrix calculations.
- Represent citizen opinions as a vector:

```text
O_citizens = N x 1 vector
```

- Represent influencer opinions as a vector:

```text
O_influencers = I x 1 vector
```

- Represent expert opinions as a vector:

```text
O_experts = E x 1 vector
```

- Represent the random social network using adjacency matrices:

```text
A_cc = N x N citizen-to-citizen network
A_ci = N x I citizen-to-influencer network
A_ce = N x E citizen-to-expert network
```

- Represent trust using matrices:

```text
T_cc = N x N citizen trust toward citizens
T_ci = N x I citizen trust toward influencers
T_ce = N x E citizen trust toward experts
```

- Initialize:
  - `N = 100` citizens
  - `I = 5` influencers
  - `E = 3` education experts
  - `time_steps = 75`
  - Citizen opinions randomly between `-1` and `+1`
  - Influencer opinions using stronger values, for example some near `+0.8` and some near `-0.8`
  - Expert opinions near neutral or moderately supportive, for example `0.2` to `0.5`

- Build the random network:
  - Citizen-citizen links: random probability around `0.05` to `0.10`
  - Influencer-citizen links: higher connection rate, around `0.30` to `0.60`
  - Expert-citizen links: moderate connection rate, around `0.20` to `0.40`
  - Remove self-links from `A_cc`

- Implement the opinion update equation for every citizen:

```text
O_i(t+1) = O_i(t)
           + direct_effect
           + average_effect
           + expert_effect
           + influencer_effect
```

- Calculate the effects in Octave:

```text
average_effect = beta * (mean_neighbour_opinion - O_i)
expert_effect = gamma * trust_expert * (mean_expert_opinion - O_i)
influencer_effect = delta * trust_influencer * influencer_strength * (mean_influencer_opinion - O_i)
```

- Clip all updated opinions so they remain inside `[-1, +1]`:

```octave
O_new = max(-1, min(1, O_new));
```

- Store the result at every time step:

```text
opinion_history = time_steps x N matrix
average_history = time_steps x 1 vector
```

- Implement all four scenarios:
  - `baseline`
  - `strong_influencer`
  - `strong_expert`
  - `low_trust`

- For each scenario, display graph results in Octave:
  - 2D average opinion over time
  - 2D individual citizen opinions over time
  - 3D temporal opinion plot
  - Final opinion histogram
  - Printed summary statistics in the Octave command window

Suggested Octave script structure inside `main.m`:

```text
1. Clear workspace and define scenario names.
2. Loop through the four scenarios.
3. Set parameters for the current scenario.
4. Initialize citizens, influencers, experts, network links, and trust matrices.
5. Run the opinion update loop.
6. Classify the final result.
7. Open one Octave figure for the scenario.
8. Save the figure as a PNG image in `results/`.
9. Print summary statistics in the Octave command window.
```

Minimum graph outputs:

```text
results/baseline_graphs.png
results/strong_influencer_graphs.png
results/strong_expert_graphs.png
results/low_trust_graphs.png
```

Deliverables:

- Working Octave ABM engine.
- Four scenario simulations.
- Octave graph figures or saved graph images for Person 2 and Person 3.
- Short notes explaining the model parameters and equations.

Suggested files:

```text
code/main.m
results/*_graphs.png
```

### Person 2: HTML GUI, Visualizations, and Experiment Display

Main responsibility:

- Build a functional single-file HTML GUI that can run the ABM interactively in the browser.
- Keep the GUI aligned with the Octave model parameters and scenario logic.

Tasks:

- Create only `index.html` for the GUI.
- Put all CSS inside a `<style>` tag in `index.html`.
- Put all JavaScript inside a `<script>` tag in `index.html`.
- Design the first screen as the actual simulation dashboard, not a landing page.
- Add a scenario selector with four options:
  - Baseline Model
  - Strong Influencer Impact
  - Strong Expert Intervention
  - Low Trust Environment
- Add parameter inputs for number of citizens, influencers, experts, and time steps.
- Add sliders for averaging effect, expert effect, and influencer effect.
- Add a `Run Model` button and a `Reset` button.
- Implement the ABM update logic in JavaScript so the published GitHub Pages GUI works without Octave.
- Add an optional section that displays matching Octave graph images from `results/` when those images exist.
- Add short text explanations beside or below each scenario result.
- Display the selected scenario's:
  - Average opinion over time
  - Individual citizen opinions over time
  - 3D temporal plot
  - Final opinion histogram
  - Summary statistics and classification

Required GUI sections:

- Header/title: `Opinion Dynamics ABM: AI Learning Assistants`
- Scenario selector
- Parameter controls
- Run/reset controls
- Summary panel showing:
  - Final mean opinion
  - Final standard deviation
  - Minimum opinion
  - Maximum opinion
  - Classification
- Plot area for the four required graphs
- Short findings box where the result explanation can be shown for the selected scenario
- Optional Octave graph image preview

Suggested single-file GUI structure:

```text
gui/index.html
```

Suggested JavaScript functions:

```text
scenarioDefaults(scenarioName)
buildScenarioParams()
runSimulation(params)
plotResults(result)
plotFallbackResults(result)
updateSummary(result)
updateFindings(result)
showScenarioScreenshot(scenarioName)
```

Suggested plot details:

- Average opinion plot:
  - x-axis = time step
  - y-axis = average opinion
  - y-range = `[-1, +1]`

- Individual opinion plot:
  - x-axis = time step
  - y-axis = opinion
  - one faint line for each citizen
  - y-range = `[-1, +1]`

- 3D temporal plot:
  - x-axis = time step
  - y-axis = citizen ID
  - z-axis = opinion

- Histogram:
  - x-axis = final opinion
  - bins from `-1` to `+1`
  - y-axis = number of citizens

GUI requirements:

- Must be readable on a laptop screen.
- Must include clear labels and legends.
- Must allow switching between all four scenarios.
- Must show the classification result for each scenario.
- Must work as a published GitHub Pages page using only the single HTML file.

Deliverables:

- Functional HTML GUI.
- JavaScript code that runs the ABM and redraws all result plots.
- Optional Octave graph screenshots/images displayed inside the GUI.
- Screenshots of each scenario's plots for the report.

Suggested files:

```text
gui/index.html
gui/screenshots/baseline_dashboard.png
gui/screenshots/strong_influencer_dashboard.png
gui/screenshots/strong_expert_dashboard.png
gui/screenshots/low_trust_dashboard.png
```

### Person 3: Analysis, Report Writing, and Final Packaging

Main responsibility:

- Interpret the simulation results, answer the assignment analysis questions, and prepare the final submission package.

Tasks:

- Read the Octave command window summary from Person 1.
- Review the Octave graph screenshots from Person 2.
- Create a scenario comparison table with:
  - Scenario name
  - Final average opinion
  - Final standard deviation
  - Minimum opinion
  - Maximum opinion
  - Classification
  - Main interpretation
- Classify each scenario as one of:
  - Consensus
  - Polarization
  - Fragmentation
  - Echo chamber
  - Mixed or neutral
- Write the 2-5 page report.
- Include the Octave model design:
  - Citizen agents
  - Influencer agents
  - Expert agents
  - Random network structure
  - Trust matrices
  - Opinion range `[-1, +1]`
- Include the core equations:
  - Direct influence
  - Averaging effect
  - Expert effect
  - Influencer effect
  - Final opinion update equation
- Include experiment settings:
  - Number of citizens
  - Number of influencers
  - Number of experts
  - Time steps
  - Parameter changes for the four scenarios
- Include results:
  - At least one plot or screenshot per scenario
  - Scenario comparison table
  - Short explanation of what happened in each scenario
- Answer the required analysis questions:
  - Whether each scenario shows consensus, polarization, fragmentation, or echo chambers
  - Impact of citizens, influencers, and experts
  - System stability
  - Whether small numbers of influencers can dominate opinion
  - Whether expert influence always creates consensus
  - What happens when averaging effect is strong
  - Whether trust, experts, or network structure is most important in preventing polarization
  - How policymakers should use education experts to stabilize public opinion
- Prepare the final folder for submission.
- Check that file names are clear and that the code can run.
- Write a short `README.md` explaining how to run:
  - The Octave simulation
  - The HTML GUI

Deliverables:

- Final 2-5 page report.
- Analysis summary table.
- Final submission folder.
- README/run instructions.

Suggested files:

```text
report/Assignment03_Report.docx or report/Assignment03_Report.pdf
report/analysis_summary.md
README.md
submission_checklist.md
```

## Recommended Final Folder Structure

```text
Assignment03_Practical/
  code/
    main.m
  gui/
    index.html
    screenshots/
      baseline_dashboard.png
      strong_influencer_dashboard.png
      strong_expert_dashboard.png
      low_trust_dashboard.png
  results/
    baseline_graphs.png
    strong_influencer_graphs.png
    strong_expert_graphs.png
    low_trust_graphs.png
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
