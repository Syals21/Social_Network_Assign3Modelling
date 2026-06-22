% STTHK2133 Assignment 3 - Part 2
% Person 1 deliverable: single-file Octave ABM engine.
%
% Run from this folder with:
%   octave main.m

clear;
clc;

fprintf('Opinion Dynamics ABM: AI Learning Assistants\n');
fprintf('Running all scenarios...\n\n');

scenarios = {'baseline', 'strong_influencer', 'strong_expert', 'low_trust'};
summary_rows = cell(length(scenarios), 6);

for s = 1:length(scenarios)
    scenario_name = scenarios{s};
    fprintf('Scenario: %s\n', scenario_name);

    params = scenario_config(scenario_name);
    agents = initialize_agents(params);
    network = build_network(params);
    result = run_simulation(params, agents, network);
    summary = classify_result(result.final_opinions, network.A_cc);

    export_results(params, result, summary, network);

    summary_rows{s, 1} = scenario_name;
    summary_rows{s, 2} = summary.final_mean;
    summary_rows{s, 3} = summary.final_std;
    summary_rows{s, 4} = summary.final_min;
    summary_rows{s, 5} = summary.final_max;
    summary_rows{s, 6} = summary.classification;

    fprintf('  final mean = %.4f, std = %.4f, class = %s\n', ...
            summary.final_mean, summary.final_std, summary.classification);
end

export_scenario_summary(summary_rows);

fprintf('\nDone. CSV files saved in ../results\n');

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

function network = build_network(params)
%BUILD_NETWORK Create random adjacency and trust matrices.

    rng(params.seed + 1000, 'twister');

    network = struct();

    A_cc = rand(params.N, params.N) < params.p_cc;
    A_cc = double(A_cc);
    A_cc = A_cc - diag(diag(A_cc));       % remove self-links

    network.A_cc = A_cc;
    network.A_ci = double(rand(params.N, params.I) < params.p_ci);
    network.A_ce = double(rand(params.N, params.E) < params.p_ce);

    network.T_cc = random_range(params.N, params.N, params.trust_cc_min, params.trust_cc_max) .* network.A_cc;
    network.T_ci = random_range(params.N, params.I, params.trust_ci_min, params.trust_ci_max) .* network.A_ci;
    network.T_ce = random_range(params.N, params.E, params.trust_ce_min, params.trust_ce_max) .* network.A_ce;
end

function values = random_range(rows, cols, lo, hi)
    values = lo + (hi - lo) * rand(rows, cols);
end

function result = run_simulation(params, agents, network)
%RUN_SIMULATION Apply the ABM opinion update over time.

    O = agents.O_citizens;
    opinion_history = zeros(params.time_steps, params.N);
    average_history = zeros(params.time_steps, 1);

    opinion_history(1, :) = O';
    average_history(1) = mean(O);

    for t = 2:params.time_steps
        O_new = O;

        for i = 1:params.N
            current_opinion = O(i);

            direct_effect = calculate_direct_effect(i, O, params, agents, network);
            average_effect = calculate_average_effect(i, O, params, network);
            expert_effect = calculate_expert_effect(i, current_opinion, params, agents, network);
            influencer_effect = calculate_influencer_effect(i, current_opinion, params, agents, network);

            O_new(i) = current_opinion ...
                     + direct_effect ...
                     + average_effect ...
                     + expert_effect ...
                     + influencer_effect;
        end

        O = max(-1, min(1, O_new));
        opinion_history(t, :) = O';
        average_history(t) = mean(O);
    end

    result = struct();
    result.opinion_history = opinion_history;
    result.average_history = average_history;
    result.final_opinions = O;
end

function direct_effect = calculate_direct_effect(i, O, params, agents, network)
    neighbours = find(network.A_cc(i, :) > 0);

    if isempty(neighbours)
        direct_effect = 0;
        return;
    end

    selected_position = randi(length(neighbours));
    j = neighbours(selected_position);
    trust_ij = network.T_cc(i, j);

    direct_effect = params.alpha ...
                  * trust_ij ...
                  * agents.citizen_influence(j) ...
                  * (O(j) - O(i));
end

function average_effect = calculate_average_effect(i, O, params, network)
    neighbours = find(network.A_cc(i, :) > 0);

    if isempty(neighbours)
        average_effect = 0;
    else
        mean_neighbour_opinion = mean(O(neighbours));
        average_effect = params.beta * (mean_neighbour_opinion - O(i));
    end
end

function expert_effect = calculate_expert_effect(i, current_opinion, params, agents, network)
    connected_experts = find(network.A_ce(i, :) > 0);

    if isempty(connected_experts)
        expert_effect = 0;
    else
        trust_expert = mean(network.T_ce(i, connected_experts));
        mean_expert_opinion = mean(agents.O_experts(connected_experts));
        expert_effect = params.gamma ...
                      * trust_expert ...
                      * params.expert_strength ...
                      * (mean_expert_opinion - current_opinion);
    end
end

function influencer_effect = calculate_influencer_effect(i, current_opinion, params, agents, network)
    connected_influencers = find(network.A_ci(i, :) > 0);

    if isempty(connected_influencers)
        influencer_effect = 0;
    else
        trust_influencer = mean(network.T_ci(i, connected_influencers));
        mean_influencer_opinion = mean(agents.O_influencers(connected_influencers));
        influencer_strength = mean(agents.influencer_strength(connected_influencers));
        influencer_effect = params.delta ...
                          * trust_influencer ...
                          * influencer_strength ...
                          * (mean_influencer_opinion - current_opinion);
    end
end

function summary = classify_result(final_opinions, A_cc)
%CLASSIFY_RESULT Calculate summary statistics and final pattern label.

    summary = struct();
    summary.final_mean = mean(final_opinions);
    summary.final_std = std(final_opinions);
    summary.final_min = min(final_opinions);
    summary.final_max = max(final_opinions);

    share_positive = mean(final_opinions > 0.35);
    share_negative = mean(final_opinions < -0.35);
    share_neutral = mean(abs(final_opinions) <= 0.20);
    echo_score = calculate_echo_score(final_opinions, A_cc);

    if summary.final_std < 0.15 && abs(summary.final_mean) > 0.35
        summary.classification = 'consensus';
    elseif share_positive > 0.20 && share_negative > 0.20 && summary.final_std > 0.35
        summary.classification = 'polarization';
    elseif echo_score > 0.65 && summary.final_std > 0.25
        summary.classification = 'echo_chambers';
    elseif summary.final_std > 0.45
        summary.classification = 'fragmentation';
    elseif share_neutral > 0.45
        summary.classification = 'mixed_neutral';
    else
        summary.classification = 'mixed_neutral';
    end
end

function echo_score = calculate_echo_score(final_opinions, A_cc)
    same_sign_links = 0;
    total_links = 0;

    for i = 1:length(final_opinions)
        neighbours = find(A_cc(i, :) > 0);
        for k = 1:length(neighbours)
            j = neighbours(k);
            if sign(final_opinions(i)) == sign(final_opinions(j))
                same_sign_links = same_sign_links + 1;
            end
            total_links = total_links + 1;
        end
    end

    if total_links == 0
        echo_score = 0;
    else
        echo_score = same_sign_links / total_links;
    end
end

function export_results(params, result, summary, network)
%EXPORT_RESULTS Save scenario CSV files for GUI and report use.

    if exist(params.output_dir, 'dir') ~= 7
        mkdir(params.output_dir);
    end

    prefix = fullfile(params.output_dir, params.scenario_name);

    csvwrite([prefix '_opinion_history.csv'], result.opinion_history);
    csvwrite([prefix '_average_history.csv'], result.average_history);
    csvwrite([prefix '_final_opinions.csv'], result.final_opinions);

    csvwrite([prefix '_A_cc.csv'], network.A_cc);
    csvwrite([prefix '_A_ci.csv'], network.A_ci);
    csvwrite([prefix '_A_ce.csv'], network.A_ce);

    scenario_file = [prefix '_summary.csv'];
    fid = fopen(scenario_file, 'w');
    fprintf(fid, 'scenario,final_mean,final_std,final_min,final_max,classification\n');
    fprintf(fid, '%s,%.6f,%.6f,%.6f,%.6f,%s\n', ...
            params.scenario_name, summary.final_mean, summary.final_std, ...
            summary.final_min, summary.final_max, summary.classification);
    fclose(fid);
end

function export_scenario_summary(summary_rows)
%EXPORT_SCENARIO_SUMMARY Save one comparison table for all scenarios.

    output_dir = fullfile('..', 'results');
    if exist(output_dir, 'dir') ~= 7
        mkdir(output_dir);
    end

    fid = fopen(fullfile(output_dir, 'scenario_summary.csv'), 'w');
    fprintf(fid, 'scenario,final_mean,final_std,final_min,final_max,classification\n');

    for i = 1:size(summary_rows, 1)
        fprintf(fid, '%s,%.6f,%.6f,%.6f,%.6f,%s\n', ...
                summary_rows{i, 1}, summary_rows{i, 2}, summary_rows{i, 3}, ...
                summary_rows{i, 4}, summary_rows{i, 5}, summary_rows{i, 6});
    end

    fclose(fid);
end
