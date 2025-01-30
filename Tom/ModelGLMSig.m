function [theta_optimal, historical_cost] = ModelGLMSig(X,y)
    %X = [1 2 3 ; 2 3 4; 3 4 5; 4 5 6; 5 6 7];
    %y = [2; 5; 8; 10; 13];
    
    [theta_optimal, historical_cost] = FitModel(X,y);

    

end

function [theta_optimal, historical_cost] = FitModel(X,y)
% X : array predictors size : m x n
    %/!\ le premier predicteur subit une optimisation exponentielle a 2 parametres 
% Y : array observed size : m x 1 
    n = size(X,2)+2;
    theta_initial = ones(n,1)/sqrt(n);  % Initialiser les paramètres à des valeurs arbitraires, 
    %theta_initial = [0.5 10 2.5 0.5]';
    learning_rate =  0.1*ones(length(theta_initial),1);
    learning_rate(3) = learning_rate(3)*10;
    learning_rate(2) = learning_rate(2)*10;
    num_iterations = 100000;
    disp(['lr' learning_rate(1) "num_iter" num_iterations]);

    [theta_optimal, historical_cost] = gradient_descent(X, y, theta_initial, learning_rate, num_iterations);
end

function [theta_optimal, historical_cost] = gradient_descent(X, y, theta_initial, learning_rate, num_iterations)
    m = length(y);  % Nombre d'exemples d'entraînement
    historical_cost = zeros(1, num_iterations);  % Pour enregistrer l'historique des coûts pour l'analyse
    theta = theta_initial;

    gradient = zeros(size(X,2)+2,1);
    figure;
    plot(y, 'x'), hold on
    predplot = plot(y);
    
    heavyBall = true;
    if heavyBall
        % Calculer la prédiction
        y_pred = predictionSig_theta(X, theta);

        % Calculer le gradient de la fonction de coût par rapport aux paramètres
        gradient(1) = mean(2 * (y_pred - y) ./ (1 + exp(-theta(2) * (X(:, 1) - theta(3)))) );
        gradient(2) = mean(2 * (y_pred - y) .* (theta(1) * (X(:, 1) - theta(3)) ...
            .* exp(- theta(2) * (X(:, 1)) - theta(3))) ./ ((1 + exp(-theta(2) * (X(:, 1) - theta(3)))) .^ 2));
        gradient(3) = mean(2 * (y_pred - y) .* (theta(1) * (- theta(2)) ...
            * exp(- theta(2) * (X(:, 1)) - theta(3))) ./ ((1 + exp(-theta(2) * (X(:, 1) - theta(3)))) .^ 2));
        gradient(4:end) = mean(2 * (y_pred - y) .* X(:, 2:end),1);
        
        momentum = gradient;
        gamma = 0.3;
    end
    
    for iteration = 1:num_iterations
        % Calculer la prédiction
        y_pred = predictionSig_theta(X, theta);

        % Calculer le gradient de la fonction de coût par rapport aux paramètres
        gradient(1) = mean(2 * (y_pred - y) ./ (1 + exp(-theta(2) * (X(:, 1) - theta(3)))) );
        gradient(2) = mean(2 * (y_pred - y) .* (theta(1) * (X(:, 1) - theta(3)) ...
            .* exp(- theta(2) * (X(:, 1)) - theta(3))) ./ ((1 + exp(-theta(2) * (X(:, 1) - theta(3)))) .^ 2));
        gradient(3) = mean(2 * (y_pred - y) .* (theta(1) * (- theta(2)) ...
            * exp(- theta(2) * (X(:, 1)) - theta(3))) ./ ((1 + exp(-theta(2) * (X(:, 1) - theta(3)))) .^ 2));
        gradient(4:end) = mean(2 * (y_pred - y) .* X(:, 2:end),1);

        % Mettre à jour les paramètres en fonction du gradient et du taux d apprentissage
        %theta = theta - learning_rate .* gradient;

        momentum = gamma * momentum + (1-gamma)*learning_rate .* gradient;
        theta = theta - momentum;
        
        % Calculer et enregistrer le coût actuel
        current_cost = cost_function(y_pred, y);
        historical_cost(iteration) = current_cost;

        % Afficher le coût toutes les 100 itérations
        if mod(iteration, num_iterations/20) == 0
            disp(theta')
            disp(gradient') 
            disp(momentum)
            fprintf('Iteration %d, Coût : %f\n', iteration, current_cost);
        end
        
        
        if mod(iteration, 10) == 0   
            delete(predplot)
            predplot = plot(y_pred, 'o');
            pause(0.005)
        end 
    end

    theta_optimal = theta;
end

function sigx = sigmoid(X, theta)
    sigx = theta(1) ./ (1 + exp(-theta(2) * (X(:, 1) - theta(3))));
end 

function y_pred = predictionSig_theta(X, theta)
    y_pred = sigmoid(X,theta) + X(:, 2:end) * theta(4:end);
end

function cost = cost_function(y_pred, y_obs)
    cost = mean((y_pred - y_obs).^2);
end