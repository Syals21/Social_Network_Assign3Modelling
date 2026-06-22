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
