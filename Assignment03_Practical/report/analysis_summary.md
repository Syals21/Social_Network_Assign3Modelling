# Analysis Summary

## Scenario Comparison Table

| Scenario | Final Mean | Final Std | Min | Max | Classification | Main Interpretation |
|---|---|---|---|---|---|---|
| Baseline | 0.2532 | 0.1767 | -0.266 | 0.558 | Mixed / Neutral | Normal interaction produces a mild positive lean but not full agreement |
| Strong Influencer | 0.2586 | 0.5205 | — | — | Echo Chambers | Population splits into several locally-agreeing opinion clusters (echo score 0.67) |
| Strong Expert | 0.3731 | 0.0936 | — | — | Consensus | Tightest, most unified distribution; strongest stabilizing effect observed |
| Low Trust | 0.1335 | 0.0942 | — | — | Mixed / Neutral | Opinion movement suppressed; citizens cluster near neutral rather than fragmenting |

*(Std = standard deviation, the spread of final opinions across all citizens.
Lower std = more agreement; higher std = more disagreement/spread.)*

## Impact of Each Role

- **Citizens**: low individual influence per interaction, but their averaging
  effect with neighbours is what drives baseline convergence even without any
  influencer/expert intervention.
- **Influencers**: strongest destabilizing force in this model — high
  connectivity plus high strength produced the widest final spread (std =
  0.521) of all four scenarios.
- **Experts**: strongest stabilizing force — high trust plus high correction
  strength produced the narrowest final spread (std = 0.094) while still
  shifting the population toward a clear, moderately supportive mean.

## System Stability

- **Baseline**: stable, converges within ~20–30 steps to a moderate lean.
- **Strong Influencer**: stable *within clusters*, but the clusters disagree
  with each other — society-wide instability disguised as local stability.
- **Strong Expert**: most stable overall; fastest, tightest convergence.
- **Low Trust**: stable but stagnant; opinions barely move from a damped
  near-neutral position rather than diverging or fragmenting.

## Answers to Required Discussion Questions

**1. Can a small number of influencers dominate public opinion?**
Yes, in terms of spread — 5 influencers with high strength and connectivity
produced the largest final variance of any scenario (std = 0.521). But the
outcome was not a single dominant opinion; it was several sub-groups each
aligning with a nearby influencer, echoing real-world echo-chamber
phenomena rather than one-sided domination.

**2. Does increasing education expert influence always lead to consensus?**
Not universally — only under the conditions tested (experts sharing one
fixed, moderate opinion, and being well-connected/trusted). If experts
disagreed with each other or were poorly connected, the same increase in
"expert strength" would not guarantee consensus.

**3. What happens when the averaging effect is very strong? Is this
realistic?**
A strong averaging effect pulls citizens toward their *local* neighbourhood
mean, which can create fast internal agreement within tightly-connected
groups even if the wider society disagrees — a realistic echo-chamber /
filter-bubble effect, but one that can misrepresent true society-wide
sentiment if taken as the whole picture.

**4. Which factor is most important in preventing polarization: trust,
experts, or network structure?**
Expert trust and strength had the clearest stabilizing effect in these
results (lowest variance, clear directional consensus). Network structure
mattered mainly in how it distributed each agent type's reach, rather than
independently preventing polarization.

**5. Policy recommendation:**
Increase experts' visibility (connectivity to the public) and public trust
in experts, since this produced the most stable, clearly interpretable
consensus in the simulation. Rather than trying to silence or compete with
influencers directly, policymakers should invest in making credible experts
more reachable and trusted within the same social network influencers
already dominate.
