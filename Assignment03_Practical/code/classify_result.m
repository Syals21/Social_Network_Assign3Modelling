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
