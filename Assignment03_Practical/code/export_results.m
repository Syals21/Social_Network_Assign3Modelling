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
