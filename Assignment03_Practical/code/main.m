% STTHK2133 Assignment 3 - Part 2
% Person 1 deliverable: single-file Octave ABM engine.
%
% This version is written as a plain script without local functions so it
% works in older GNU Octave versions too.
%
% Run from this folder with:
%   octave main.m

clear;
clc;

fprintf('Opinion Dynamics ABM: AI Learning Assistants\n');
fprintf('Running all scenarios...\n\n');

scenarios = {'baseline', 'strong_influencer', 'strong_expert', 'low_trust'};
summary_rows = cell(length(scenarios), 6);

output_dir = fullfile('..', 'results');
if exist(output_dir, 'dir') ~= 7
    mkdir(output_dir);
end

for s = 1:length(scenarios)
    scenario_name = scenarios{s};
    fprintf('Scenario: %s\n', scenario_name);

    % -----------------------------
    % Scenario configuration
    % -----------------------------
    N = 100;             % citizens, assignment range: 50-200
    I = 5;               % influencers, assignment range: 3-10
    E = 3;               % education experts, assignment range: 1-5
    time_steps = 75;     % assignment range: 50-100

    seed = 2133;

    % Network probabilities.
    p_cc = 0.08;         % citizen-citizen links
    p_ci = 0.45;         % citizen-influencer links
    p_ce = 0.30;         % citizen-expert links

    % Opinion update rates.
    alpha = 0.05;        % direct one-to-one citizen influence
    beta = 0.12;         % neighbour averaging / social pressure
    gamma = 0.10;        % expert correction
    delta = 0.10;        % influencer pressure

    % Influence strengths.
    citizen_influence = 0.35;
    influencer_strength_value = 1.25;
    expert_strength = 0.75;

    % Trust ranges.
    trust_cc_min = 0.25;
    trust_cc_max = 0.75;
    trust_ci_min = 0.35;
    trust_ci_max = 0.80;
    trust_ce_min = 0.60;
    trust_ce_max = 0.95;

    if strcmp(scenario_name, 'baseline')
        seed = 2133;

    elseif strcmp(scenario_name, 'strong_influencer')
        seed = 2134;
        delta = 0.35;
        influencer_strength_value = 2.50;
        p_ci = 0.20;
        trust_ci_min = 0.75;
        trust_ci_max = 1.00;

    elseif strcmp(scenario_name, 'strong_expert')
        seed = 2135;
        gamma = 0.25;
        expert_strength = 1.25;
        p_ce = 0.40;
        trust_ce_min = 0.80;
        trust_ce_max = 1.00;

    elseif strcmp(scenario_name, 'low_trust')
        seed = 2136;
        trust_cc_min = 0.05;
        trust_cc_max = 0.30;
        trust_ci_min = 0.05;
        trust_ci_max = 0.30;
        trust_ce_min = 0.10;
        trust_ce_max = 0.35;
        beta = 0.06;
        gamma = 0.04;
        delta = 0.05;
    end

    % -----------------------------
    % Agent initialization
    % -----------------------------
    rng(seed, 'twister');

    % Citizens begin with diverse opinions from strongly against to strongly support.
    O_citizens = -1 + 2 * rand(N, 1);

    % Influencers are intentionally stronger and more extreme.
    base_influencer_opinions = [0.95; 0.90; -0.95; -0.90; 0.95; -0.90; 0.70; -0.70; 0.80; -0.75];
    O_influencers = base_influencer_opinions(1:I);

    % Experts are balanced or moderately supportive of the AI education policy.
    base_expert_opinions = [0.35; 0.45; 0.50; 0.25; 0.55];
    O_experts = base_expert_opinions(1:E);

    citizen_influence_vector = citizen_influence * ones(N, 1);
    influencer_strength = influencer_strength_value * ones(I, 1);

    % -----------------------------
    % Random network and trust setup
    % -----------------------------
    rng(seed + 1000, 'twister');

    A_cc = double(rand(N, N) < p_cc);
    A_cc = A_cc - diag(diag(A_cc));       % remove citizen self-links

    A_ci = double(rand(N, I) < p_ci);
    A_ce = double(rand(N, E) < p_ce);

    T_cc = (trust_cc_min + (trust_cc_max - trust_cc_min) * rand(N, N)) .* A_cc;
    T_ci = (trust_ci_min + (trust_ci_max - trust_ci_min) * rand(N, I)) .* A_ci;
    T_ce = (trust_ce_min + (trust_ce_max - trust_ce_min) * rand(N, E)) .* A_ce;

    % -----------------------------
    % Simulation
    % -----------------------------
    O = O_citizens;
    opinion_history = zeros(time_steps, N);
    average_history = zeros(time_steps, 1);

    opinion_history(1, :) = O';
    average_history(1) = mean(O);

    for t = 2:time_steps
        O_new = O;

        for i = 1:N
            current_opinion = O(i);

            % Direct citizen-to-citizen influence from one connected neighbour.
            neighbours = find(A_cc(i, :) > 0);
            if isempty(neighbours)
                direct_effect = 0;
                average_effect = 0;
            else
                selected_position = randi(length(neighbours));
                j = neighbours(selected_position);
                trust_ij = T_cc(i, j);

                direct_effect = alpha ...
                              * trust_ij ...
                              * citizen_influence_vector(j) ...
                              * (O(j) - O(i));

                mean_neighbour_opinion = mean(O(neighbours));
                average_effect = beta * (mean_neighbour_opinion - O(i));
            end

            % Education expert correction effect.
            connected_experts = find(A_ce(i, :) > 0);
            if isempty(connected_experts)
                expert_effect = 0;
            else
                trust_expert = mean(T_ce(i, connected_experts));
                mean_expert_opinion = mean(O_experts(connected_experts));
                expert_effect = gamma ...
                              * trust_expert ...
                              * expert_strength ...
                              * (mean_expert_opinion - current_opinion);
            end

            % Influencer effect.
            connected_influencers = find(A_ci(i, :) > 0);
            if isempty(connected_influencers)
                influencer_effect = 0;
            else
                trust_influencer = mean(T_ci(i, connected_influencers));
                mean_influencer_opinion = mean(O_influencers(connected_influencers));
                mean_influencer_strength = mean(influencer_strength(connected_influencers));
                influencer_effect = delta ...
                                  * trust_influencer ...
                                  * mean_influencer_strength ...
                                  * (mean_influencer_opinion - current_opinion);
            end

            O_new(i) = current_opinion ...
                     + direct_effect ...
                     + average_effect ...
                     + expert_effect ...
                     + influencer_effect;
        end

        % Keep all opinions inside the assignment range [-1, +1].
        O = max(-1, min(1, O_new));
        opinion_history(t, :) = O';
        average_history(t) = mean(O);
    end

    final_opinions = O;

    % -----------------------------
    % Classification
    % -----------------------------
    final_mean = mean(final_opinions);
    final_std = std(final_opinions);
    final_min = min(final_opinions);
    final_max = max(final_opinions);

    share_positive = mean(final_opinions > 0.35);
    share_negative = mean(final_opinions < -0.35);
    share_neutral = mean(abs(final_opinions) <= 0.20);

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

    if final_std < 0.15 && abs(final_mean) > 0.35
        classification = 'consensus';
    elseif share_positive > 0.20 && share_negative > 0.20 && final_std > 0.35
        classification = 'polarization';
    elseif echo_score > 0.65 && final_std > 0.25
        classification = 'echo_chambers';
    elseif final_std > 0.45
        classification = 'fragmentation';
    elseif share_neutral > 0.45
        classification = 'mixed_neutral';
    else
        classification = 'mixed_neutral';
    end

    % -----------------------------
    % CSV export
    % -----------------------------
    prefix = fullfile(output_dir, scenario_name);

    csvwrite([prefix '_opinion_history.csv'], opinion_history);
    csvwrite([prefix '_average_history.csv'], average_history);
    csvwrite([prefix '_final_opinions.csv'], final_opinions);

    csvwrite([prefix '_A_cc.csv'], A_cc);
    csvwrite([prefix '_A_ci.csv'], A_ci);
    csvwrite([prefix '_A_ce.csv'], A_ce);

    scenario_file = [prefix '_summary.csv'];
    fid = fopen(scenario_file, 'w');
    fprintf(fid, 'scenario,final_mean,final_std,final_min,final_max,classification\n');
    fprintf(fid, '%s,%.6f,%.6f,%.6f,%.6f,%s\n', ...
            scenario_name, final_mean, final_std, final_min, final_max, classification);
    fclose(fid);

    summary_rows{s, 1} = scenario_name;
    summary_rows{s, 2} = final_mean;
    summary_rows{s, 3} = final_std;
    summary_rows{s, 4} = final_min;
    summary_rows{s, 5} = final_max;
    summary_rows{s, 6} = classification;

    fprintf('  final mean = %.4f, std = %.4f, class = %s\n', ...
            final_mean, final_std, classification);
end

% Combined summary CSV for report comparison.
fid = fopen(fullfile(output_dir, 'scenario_summary.csv'), 'w');
fprintf(fid, 'scenario,final_mean,final_std,final_min,final_max,classification\n');

for i = 1:size(summary_rows, 1)
    fprintf(fid, '%s,%.6f,%.6f,%.6f,%.6f,%s\n', ...
            summary_rows{i, 1}, summary_rows{i, 2}, summary_rows{i, 3}, ...
            summary_rows{i, 4}, summary_rows{i, 5}, summary_rows{i, 6});
end

fclose(fid);

fprintf('\nDone. CSV files saved in ../results\n');
