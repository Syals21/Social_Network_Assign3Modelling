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
