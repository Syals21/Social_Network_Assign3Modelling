# Assignment 3 – Part 2 (Practical Section)
## Opinion Dynamics in a Social Network: AI Learning Assistants in Education

**Course:** STTHK2133 Modelling & Simulation, A252
**Group Members:** [Your names here]

---

## 1. Model Design

### 1.1 Purpose

This Agent-Based Model (ABM) simulates how public opinion about the Ministry of
Education's proposed AI-powered learning assistants evolves through repeated
social interaction. The goal is to observe whether public opinion converges
toward support, splits into opposing camps (polarization), stays scattered
(fragmentation), or settles into locally-agreeing clusters (echo chambers).

### 1.2 Agents

Three agent types were implemented, matching the assignment brief:

| Agent type | Count | Opinion range | Role |
|---|---|---|---|
| **Citizens** | 100 | Random, U(-1, +1) | Main population; low individual influence; update opinions through interaction |
| **Influencers** | 5 | Fixed, strong/extreme (e.g. ±0.70 to ±0.95) | High connectivity, high persuasive strength; spread opinions quickly |
| **Education Experts** | 3 | Fixed, near-neutral to moderately supportive (0.25–0.55) | High credibility; moderate strength; correct extreme opinions |

Citizen opinion `O_i` lies in [-1, +1], where -1 = strongly against AI tutors
and +1 = strongly supportive. Influencer and expert opinions are fixed for the
duration of a run — they broadcast opinions rather than being persuaded
themselves, which is a standard simplification in opinion-dynamics models and
keeps the model's cause-and-effect chain easy to interpret.

### 1.3 Trust

Rather than a single trust value, each citizen has a personal trust level
toward each agent type it is connected to:

- `T_cc` — trust between citizens (base range 0.25–0.75)
- `T_ci` — trust in influencers (base range 0.35–0.80)
- `T_ce` — trust in experts (base range 0.60–0.95, reflecting their higher credibility)

These are stored as trust matrices, masked by the network's adjacency
matrices, so trust only exists where a connection exists.

### 1.4 Network Structure

A random network (Erdős–Rényi style) connects citizens to each other and to
influencers/experts:

- Citizen–citizen links: connection probability `p_cc = 0.08`
- Citizen–influencer links: connection probability `p_ci = 0.30–0.45` (varies by scenario)
- Citizen–expert links: connection probability `p_ce = 0.30–0.40` (varies by scenario)

Influencers and experts are deliberately given a higher connection probability
than ordinary citizens, reflecting their real-world high connectivity/reach.

---

## 2. Equations

Every time step, each citizen's opinion is updated by summing four effects:

**Direct influence** (one randomly chosen connected citizen):

```
direct_effect = alpha * T_cc(i,j) * citizen_influence(j) * (O_j - O_i)
```

**Averaging effect** (pull toward the mean opinion of all connected citizens):

```
average_effect = beta * (mean(O_neighbours) - O_i)
```

**Expert correction** (pull toward the mean opinion of connected experts):

```
expert_effect = gamma * trust_expert * expert_strength * (mean(O_experts) - O_i)
```

**Influencer effect** (pull toward the mean opinion of connected influencers):

```
influencer_effect = delta * trust_influencer * influencer_strength * (mean(O_influencers) - O_i)
```

**Combined update, then clipped to the valid range:**

```
O_i(t+1) = O_i(t) + direct_effect + average_effect + expert_effect + influencer_effect
O_i(t+1) = max(-1, min(1, O_i(t+1)))
```

`alpha`, `beta`, `gamma`, and `delta` are the four "dials" that were retuned
for each scenario to test different social conditions.

---

## 3. Experiments

All scenarios used the same population size (100 citizens, 5 influencers,
3 experts) over 100 time steps, with only the listed parameters changed
between runs, so that differences in outcome can be attributed to the
scenario condition rather than random setup differences.

| Parameter | Baseline | Strong Influencer | Strong Expert | Low Trust |
|---|---|---|---|---|
| alpha (direct) | 0.05 | 0.05 | 0.05 | 0.05 |
| beta (averaging) | 0.12 | 0.12 | 0.12 | 0.06 |
| gamma (expert) | 0.10 | 0.10 | 0.25 | 0.04 |
| delta (influencer) | 0.10 | 0.35 | 0.10 | 0.05 |
| influencer strength | 1.25 | 2.50 | 1.25 | 1.25 |
| expert strength | 0.75 | 0.75 | 1.25 | 0.75 |
| trust in citizens | 0.25–0.75 | 0.25–0.75 | 0.25–0.75 | 0.05–0.30 |
| trust in influencers | 0.35–0.80 | 0.75–1.00 | 0.35–0.80 | 0.05–0.30 |
| trust in experts | 0.60–0.95 | 0.60–0.95 | 0.80–1.00 | 0.10–0.35 |

---

## 4. Results

| Scenario | Final Mean | Final Std | Classification (auto-computed) |
|---|---|---|---|
| Baseline | 0.253 | 0.177 | Mixed / Neutral |
| Strong Influencer | 0.259 | 0.521 | Echo Chambers |
| Strong Expert | 0.373 | 0.094 | Consensus |
| Low Trust | 0.134 | 0.094 | Mixed / Neutral |

*(See `results/*_graphs.png` for the full 2D average-opinion, 2D individual-opinion,
3D temporal, and histogram plots for each scenario, generated directly by the
Octave scripts in `code/`.)*

### 4.1 Baseline

Opinions rise gradually from a random start toward a mild positive lean
(mean ≈ 0.25) and settle within ~20–30 time steps. The final histogram is a
single broad hump slightly right of centre — most citizens end up mildly
supportive, but a meaningful minority remain neutral or mildly opposed. This
was classified as "mixed/neutral" rather than full consensus because the
spread (std = 0.177) was still too wide to count as tight agreement.

### 4.2 Strong Influencer

The individual-opinion plot visibly splits into several parallel bands
instead of one converging line — some citizens cluster near +0.8, others
near -0.7, others in between. The final standard deviation (0.521) is by far
the highest of the four scenarios. The model's own echo-score (0.67) shows
that most edges connect citizens who ended up agreeing with each other —
meaning the population split into several locally-agreeing sub-groups rather
than one unified opinion. This matches the scenario's intended test:
increasing influencer connectivity and persuasive strength produced
**echo-chamber-style fragmentation**, not full-society polarization into
just two camps.

### 4.3 Strong Expert

This scenario produced the tightest final distribution of all four (std =
0.094) and the highest final mean opinion (0.373). The individual-opinion
plot shows nearly all citizen lines converging into a narrow band by around
time step 20. Increasing trust in experts and expert correction strength
successfully pulled outlying opinions toward the expert's moderately
supportive stance, confirming the theoretical expectation that credible,
evidence-based sources stabilize public opinion and reduce variance.

### 4.4 Low Trust

Contrary to the intuitive expectation that low trust would cause
fragmentation, this scenario produced the *lowest* combined spread alongside
Strong Expert (std = 0.094), but centred close to neutral (mean = 0.134),
with 73% of citizens landing within a narrow neutral band. The 2D average
opinion plot shows a slow, nearly flat climb rather than a sharp trend in
either direction. The interpretation is that when trust in *everyone*
(citizens, influencers, and experts alike) is low, citizens barely respond to
any social signal — so instead of scattering unpredictably, they stay close
to a damped, near-neutral average. This is an important nuance: **low trust
suppresses movement rather than causing wild disagreement**, at least under
this model's assumptions.

---

## 5. Analysis and Discussion

**Does the system show consensus, polarization, fragmentation, or echo
chambers?** Strong Expert showed clear consensus; Strong Influencer showed
echo-chamber-style clustering; Baseline and Low Trust both landed in a
mixed/neutral zone, though for different reasons (Baseline had residual
diversity from normal interaction, Low Trust had suppressed movement from
low trust).

**Can a small number of influencers dominate public opinion?** Yes. With
only 5 influencers connected to a large share of the 100 citizens (p_ci up to
0.45) and a strength value more than double the baseline, the influencer
scenario produced the widest opinion spread of all runs. However, the result
was not one dominant opinion overriding everyone — it was several
opinion clusters forming around different influencers, which is arguably a
more realistic outcome than one influencer converting the entire population.

**Does increasing education expert influence always lead to consensus?** In
this simulation, yes — but this should not be read as a universal law. The
model gives experts a single, fixed, moderately-supportive opinion; if
real-world experts disagreed with each other, or if some parts of the
population were not connected to any expert, consensus would be far less
guaranteed. The result shows experts *can* stabilize opinion when trusted and
well-connected, not that they always will in every configuration.

**What happens when the averaging effect is very strong? Is this realistic?**
A strong averaging effect pulls each citizen toward their local neighbourhood
mean regardless of the wider population. Taken to an extreme, this would
cause tightly-connected sub-groups to snap to internal agreement quickly,
even if that agreement is disconnected from the rest of society — a
recognisable real-world echo-chamber effect (e.g., social media filter
bubbles). It is realistic as a *local* phenomenon but can misrepresent
society-wide opinion if the network itself is not well-mixed.

**Which factor is most important in preventing polarization: trust,
experts, or network structure?** Based on these four runs, **expert
trust/strength** had the strongest stabilizing effect — it produced the
lowest variance of any scenario while still nudging the population in a
clear (supportive) direction. Network structure mattered indirectly: because
experts and influencers were both connected to a meaningful share of
citizens, their relative strength/trust settings were what tipped the
outcome, not the network shape itself.

**Policy recommendation.** If experts are given strong connectivity to the
public (high `p_ce`) and are seen as highly credible (high trust), they can
meaningfully anchor public opinion toward a moderate, informed consensus and
counteract the volatility introduced by highly persuasive influencers. A
policymaker seeking to stabilize opinion on AI-in-education should therefore
prioritize increasing both expert visibility (connectivity) and public trust
in experts, rather than attempting to suppress influencers directly.

---

## 6. Conclusion

This ABM demonstrates that public opinion on AI-in-education is highly
sensitive to *who* the public is listening to and *how much* they trust
them, more so than to raw population size or network density. Strengthening
trusted, credible expert voices produced the most stable and clearly
supportive outcome (Strong Expert: mean 0.373, std 0.094), while amplifying
influencer reach and strength produced a fragmented, echo-chamber-like
society (Strong Influencer: std 0.521) rather than outright two-sided
polarization. Interestingly, simply lowering trust across the board did not
produce chaos — it suppressed opinion change altogether, leaving the
population clustered near neutral. These findings suggest that the Ministry
of Education's public communication strategy should focus on building and
deploying trusted expert voices within the existing social network, rather
than competing directly with influencers for reach.
