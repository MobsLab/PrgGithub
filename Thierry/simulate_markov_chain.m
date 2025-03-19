%% Fonction : Simulation d'une chaîne de Markov
function simulated_states = simulate_markov_chain(transition_matrix, initial_state, num_steps)
    % Simuler une chaîne de Markov à partir d'une matrice de transition
    num_states = size(transition_matrix, 1);
    simulated_states = zeros(1, num_steps);
    simulated_states(1) = initial_state; % État initial
    
    for step = 2:num_steps
        current_state = simulated_states(step - 1);
        % Tirage au sort de l'état suivant selon les probabilités de transition
        next_state = randsample(1:num_states, 1, true, transition_matrix(current_state, :));
        simulated_states(step) = next_state;
    end
end