function agents = initialize_agents(params)
%INITIALIZE_AGENTS Create opinions and influence levels.

    rng(params.seed, 'twister');

    agents = struct();

    % Citizens begin with diverse opinions from strongly against to strongly support.
    agents.O_citizens = -1 + 2 * rand(params.N, 1);

    % Influencers are intentionally stronger and more extreme.
    base_influencer_opinions = [0.95; 0.90; -0.95; -0.90; 0.95; -0.90; 0.70; -0.70; 0.80; -0.75];
    agents.O_influencers = base_influencer_opinions(1:params.I);

    % Experts are balanced or moderately supportive of the AI education policy.
    base_expert_opinions = [0.35; 0.45; 0.50; 0.25; 0.55];
    agents.O_experts = base_expert_opinions(1:params.E);

    agents.citizen_influence = params.citizen_influence * ones(params.N, 1);
    agents.influencer_strength = params.influencer_strength * ones(params.I, 1);
    agents.expert_strength = params.expert_strength * ones(params.E, 1);
end
