# Social Network Assignment 3 Modelling

## Project Overview

This project is an agent-based model (ABM) that simulates how public opinion
changes inside a social network. The case study is public response to
AI-powered learning assistants in education.

The model studies how three groups affect opinion:

- **Citizens**: ordinary users whose opinions change through interaction.
- **Influencers**: highly connected agents with stronger persuasive power.
- **Education experts**: trusted agents who can correct or stabilize opinions.

Citizen opinions range from `-1` to `+1`, where `-1` means strongly against AI
learning assistants and `+1` means strongly supportive.

## Main Scenarios

The simulation compares several conditions:

- **Baseline**: normal trust and balanced social influence.
- **Strong Influencer**: influencers have stronger persuasive effect.
- **Strong Expert**: experts have stronger credibility and correction effect.
- **Low Trust**: citizens have low trust in other citizens, influencers, and
  experts.

Each scenario tracks whether the final public opinion becomes consensus,
polarization, fragmentation, echo chambers, or remains mixed/neutral.

## Project Structure

```text
code/       Octave/MATLAB simulation scripts
gui/        Interactive browser dashboard
results/    Generated graph images for each scenario
report/     Report and analysis summary
README.md   Project information
```

## How to Run the Simulation

Open GNU Octave or MATLAB, then run one of the scripts in the `code` folder:

```matlab
cd code
baseline
strong_influencer
strong_expert
low_trust
```

The scripts generate plots for:

- average opinion over time
- individual citizen opinions
- 3D temporal opinion changes
- final opinion histogram

Saved graph images are stored in the `results` folder.

## How to View the Dashboard

Open this file in a web browser:

```text
gui/index.html
```

The dashboard lets users choose a scenario, adjust model parameters, run the
simulation, and view the resulting graphs interactively.

## Key Findings

- Strong expert influence produced the most stable consensus.
- Strong influencer influence created the widest opinion spread and echo
  chamber behaviour.
- Low trust reduced opinion movement, causing citizens to remain closer to a
  neutral position.
- Network structure and trust both affect whether opinions converge or split.

## Report

The full explanation, equations, scenario results, and discussion are available
in:

```text
report/Assignment03_Report.md
report/analysis_summary.md
```
