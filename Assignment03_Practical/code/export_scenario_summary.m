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
