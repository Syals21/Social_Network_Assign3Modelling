function params = scenario_config(scenario_name)
%SCENARIO_CONFIG Return model settings for one simulation scenario.

    params = struct();
    params.scenario_name = scenario_name;

    params.N = 100;             % citizens, assignment range: 50-200
    params.I = 5;               % influencers, assignment range: 3-10
    params.E = 3;               % education experts, assignment range: 1-5
    params.time_steps = 75;     % assignment range: 50-100

    params.seed = 2133;
    params.output_dir = fullfile('..', 'results');

    % Network probabilities.
    params.p_cc = 0.08;         % citizen-citizen links
    params.p_ci = 0.45;         % citizen-influencer links
    params.p_ce = 0.30;         % citizen-expert links

    % Opinion update rates.
    params.alpha = 0.05;        % direct one-to-one citizen influence
    params.beta = 0.12;         % neighbour averaging / social pressure
    params.gamma = 0.10;        % expert correction
    params.delta = 0.10;        % influencer pressure

    % Influence strengths.
    params.citizen_influence = 0.35;
    params.influencer_strength = 1.25;
    params.expert_strength = 0.75;

    % Trust ranges.
    params.trust_cc_min = 0.25;
    params.trust_cc_max = 0.75;
    params.trust_ci_min = 0.35;
    params.trust_ci_max = 0.80;
    params.trust_ce_min = 0.60;
    params.trust_ce_max = 0.95;

    if strcmp(scenario_name, 'baseline')
        params.seed = 2133;

    elseif strcmp(scenario_name, 'strong_influencer')
        params.seed = 2134;
        params.delta = 0.35;
        params.influencer_strength = 2.50;
        params.p_ci = 0.20;
        params.trust_ci_min = 0.75;
        params.trust_ci_max = 1.00;

    elseif strcmp(scenario_name, 'strong_expert')
        params.seed = 2135;
        params.gamma = 0.25;
        params.expert_strength = 1.25;
        params.p_ce = 0.40;
        params.trust_ce_min = 0.80;
        params.trust_ce_max = 1.00;

    elseif strcmp(scenario_name, 'low_trust')
        params.seed = 2136;
        params.trust_cc_min = 0.05;
        params.trust_cc_max = 0.30;
        params.trust_ci_min = 0.05;
        params.trust_ci_max = 0.30;
        params.trust_ce_min = 0.10;
        params.trust_ce_max = 0.35;
        params.beta = 0.06;
        params.gamma = 0.04;
        params.delta = 0.05;

    else
        error('Unknown scenario: %s', scenario_name);
    end
end
