% STTHK2133 Assignment 3 - Part 2
% Person 1 deliverable: Octave ABM engine and scenario simulation.
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
