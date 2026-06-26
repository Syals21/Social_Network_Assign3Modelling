% This script simulates how opinions change in a social network.
% Run it from this folder with:
%   octave low_trust.m

clear;
clc;

fprintf('Opinion Dynamics ABM: AI Learning Assistants\n');
script_file = mfilename('fullpath');
if isempty(script_file)
    script_dir = pwd;
else
    script_dir = fileparts(script_file);
end

output_dir = fullfile(script_dir, '..', 'results');
if exist(output_dir, 'dir') ~= 7
    mkdir(output_dir);
end

scenario_name = 'low_trust';
fprintf('Scenario: %s\n', scenario_name);

    % These values set the population size and simulation length.
    N = 100;             % The number of citizens is within the required range.
    I = 5;               % The number of influencers is within the required range.
    E = 3;               % The number of education experts is within the required range.
    time_steps = 100;    % The number of time steps is within the required range.

    seed = 2133;

    % These probabilities control how connected the agents are.
    p_cc = 0.08;         % This controls citizen-to-citizen links.
    p_ci = 0.45;         % This controls citizen-to-influencer links.
    p_ce = 0.30;         % This controls citizen-to-expert links.

    % These rates control how strongly opinions move after interaction.
    alpha = 0.05;        % This controls direct citizen influence.
    beta = 0.12;         % This controls neighbour averaging.
    gamma = 0.10;        % This controls expert influence.
    delta = 0.10;        % This controls influencer influence.

    % These values give different agent roles different influence levels.
    citizen_influence = 0.35;
    influencer_strength_value = 1.25;
    expert_strength = 0.75;

    % These ranges describe how much citizens trust each connected agent type.
    trust_cc_min = 0.25;
    trust_cc_max = 0.75;
    trust_ci_min = 0.35;
    trust_ci_max = 0.80;
    trust_ce_min = 0.60;
    trust_ce_max = 0.95;

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

    fprintf('  agents: citizens=%d, influencers=%d, experts=%d, time steps=%d\n', ...
            N, I, E, time_steps);
    fprintf('  network probabilities: citizen=%.2f, influencer=%.2f, expert=%.2f\n', ...
            p_cc, p_ci, p_ce);
    fprintf('  update rates: alpha=%.2f, beta=%.2f, gamma=%.2f, delta=%.2f\n', ...
            alpha, beta, gamma, delta);

    % The initial opinions and fixed role opinions are created here.
    rand('seed', seed);
    randn('seed', seed);

    % Citizen opinions begin with a mix of negative, neutral, and positive views.
    O_citizens = -1 + 2 * rand(N, 1);

    % Influencers are given stronger opinions so their social effect can be tested.
    base_influencer_opinions = [0.95; 0.90; -0.95; -0.90; 0.95; -0.90; 0.70; -0.70; 0.80; -0.75];
    O_influencers = base_influencer_opinions(1:I);

    % Experts are kept closer to balanced or moderately supportive opinions.
    base_expert_opinions = [0.35; 0.45; 0.50; 0.25; 0.55];
    O_experts = base_expert_opinions(1:E);

    citizen_influence_vector = citizen_influence * ones(N, 1);
    influencer_strength = influencer_strength_value * ones(I, 1);

    % The social network and trust values are generated randomly for each scenario.
    rand('seed', seed + 1000);
    randn('seed', seed + 1000);

    A_cc = double(rand(N, N) < p_cc);
    A_cc = A_cc - diag(diag(A_cc));       % Citizens should not connect to themselves.

    A_ci = double(rand(N, I) < p_ci);
    A_ce = double(rand(N, E) < p_ce);

    T_cc = (trust_cc_min + (trust_cc_max - trust_cc_min) * rand(N, N)) .* A_cc;
    T_ci = (trust_ci_min + (trust_ci_max - trust_ci_min) * rand(N, I)) .* A_ci;
    T_ce = (trust_ce_min + (trust_ce_max - trust_ce_min) * rand(N, E)) .* A_ce;

    % The simulation stores both individual opinions and the population average.
    O = O_citizens;
    opinion_history = zeros(time_steps, N);
    average_history = zeros(time_steps, 1);

    opinion_history(1, :) = O';
    average_history(1) = mean(O);

    for t = 2:time_steps
        O_new = O;

        for i = 1:N
            current_opinion = O(i);

            % A citizen may be directly influenced by one connected citizen.
            neighbours = find(A_cc(i, :) > 0);
            if isempty(neighbours)
                direct_effect = 0;
                average_effect = 0;
            else
                selected_position = ceil(rand * length(neighbours));
                j = neighbours(selected_position);
                trust_ij = T_cc(i, j);

                direct_effect = alpha ...
                              * trust_ij ...
                              * citizen_influence_vector(j) ...
                              * (O(j) - O(i));

                mean_neighbour_opinion = mean(O(neighbours));
                average_effect = beta * (mean_neighbour_opinion - O(i));
            end

            % Connected experts pull opinions toward a more balanced position.
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

            % Connected influencers can move opinions more strongly.
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

        % Opinion values are kept inside the allowed range.
        O = max(-1, min(1, O_new));
        opinion_history(t, :) = O';
        average_history(t) = mean(O);
    end

    final_opinions = O;

    % Summary values are used to classify the final opinion pattern.
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

    % Each scenario is shown using the required plots.
    time_axis = 1:time_steps;
    citizen_axis = 1:N;
    scenario_title = strrep(scenario_name, '_', ' ');

    figure('Name', ['Results - ' scenario_title]);

    subplot(2, 2, 1);
    plot(time_axis, average_history, 'b-', 'LineWidth', 2);
    grid on;
    ylim([-1 1]);
    xlabel('Time step');
    ylabel('Average opinion');
    title('2D Average Opinion Over Time');

    subplot(2, 2, 2);
    plot(time_axis, opinion_history);
    grid on;
    ylim([-1 1]);
    xlabel('Time step');
    ylabel('Citizen opinion');
    title('2D Individual Citizen Opinions');

    subplot(2, 2, 3);
    surf(time_axis, citizen_axis, opinion_history');
    shading interp;
    xlabel('Time step');
    ylabel('Citizen ID');
    zlabel('Opinion');
    zlim([-1 1]);
    title('3D Temporal Opinion Plot');
    view(45, 30);

    subplot(2, 2, 4);
    hist(final_opinions, 20);
    grid on;
    xlim([-1 1]);
    xlabel('Final opinion');
    ylabel('Number of citizens');
    title(['Final Histogram: ' classification]);

    drawnow;

    % The combined graph is saved so it can be used in the report or website.
    graph_file = fullfile(output_dir, [scenario_name '_graphs.png']);
    try
        print(graph_file, '-dpng', '-r150');
    catch
        fprintf('  graph image could not be saved, but the figure was created.\n');
    end

    fprintf('  final mean = %.4f, std = %.4f, class = %s\n', ...
            final_mean, final_std, classification);
    fprintf('  positive share = %.2f, negative share = %.2f, neutral share = %.2f, echo score = %.2f\n', ...
            share_positive, share_negative, share_neutral, echo_score);

    if strcmp(classification, 'consensus')
        fprintf('  interpretation: most citizens moved toward a similar opinion.\n');
    elseif strcmp(classification, 'polarization')
        fprintf('  interpretation: both supportive and opposing opinion groups remain strong.\n');
    elseif strcmp(classification, 'fragmentation')
        fprintf('  interpretation: final opinions remain widely spread across the population.\n');
    elseif strcmp(classification, 'echo_chambers')
        fprintf('  interpretation: connected citizens tend to share similar final opinions.\n');
    else
        fprintf('  interpretation: public opinion remains moderate or mixed.\n');
    end
fprintf('\nDone. Graph image saved in ../results\n');

