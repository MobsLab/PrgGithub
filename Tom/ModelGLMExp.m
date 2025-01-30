function [theta_optimal, historical_cost] = ModelGLMExp(X,y)
    %X = [1 2 3 ; 2 3 4; 3 4 5; 4 5 6; 5 6 7];
    %y = [2; 5; 8; 10; 13];
    
    [theta_optimal, historical_cost] = FitModel(X,y);

    

end

function [theta_optimal, historical_cost] = FitModel(X,y)
% X : array predictors size : m x y
    %/!\ le premier predicteur subit une optimisation exponentielle a 2 parametres 
% Y : array observed size : m x 1 
    theta_initial = rand(size(X,2)+1,1);  % Initialiser les paramètres à des valeurs arbitraires, 
    disp(size(X,2))
    learning_rate = 0.0001;
    num_iterations = 1000000;
    disp(['lr' learning_rate "num_iter" num_iterations]);

    [theta_optimal, historical_cost] = gradient_descent(X, y, theta_initial, learning_rate, num_iterations);
end

function [theta_optimal, historical_cost] = gradient_descent(X, y, theta_initial, learning_rate, num_iterations)
    m = length(y);  % Nombre d'exemples d'entraînement
    historical_cost = zeros(1, num_iterations);  % Pour enregistrer l'historique des coûts pour l'analyse
    theta = theta_initial;

    gradient = zeros(size(X,2)+1,1);
    figure;
    plot(y), hold on
    predplot = plot(y);
    
    for iteration = 1:num_iterations
        % Calculer la prédiction
        y_pred = predictionExp_theta(X, theta);

        % Calculer le gradient de la fonction de coût par rapport aux paramètres
        gradient(1) = mean(2 * (y_pred - y) .* exp(theta(2) * X(:, 1)));
        gradient(2) = mean(2 * theta(1) * X(:, 1) .* (y_pred - y) .* exp(theta(2) * X(:, 1)));
        gradient(3:end) = mean(2 * (y_pred - y) .* X(:, 2:end),1);

        % Mettre à jour les paramètres en fonction du gradient et du taux d apprentissage
        theta(1) = theta(1) - learning_rate * gradient(1);
        theta(2) = theta(2) - learning_rate * gradient(2);
        theta(3:end) = theta(3:end) - learning_rate * gradient(3:end);

        % Calculer et enregistrer le coût actuel
        current_cost = cost_function(y_pred, y);
        historical_cost(iteration) = current_cost;

        % Afficher le coût toutes les 100 itérations
        if mod(iteration, num_iterations/20) == 0
            fprintf('Iteration %d, Coût : %f\n', iteration, current_cost);
        end
        
        if mod(iteration, num_iterations/100) == 0 || iteration<50
            delete(predplot)
            predplot = plot(y_pred);
            pause(0.1)
        end
    end

    theta_optimal = theta;
end

function y_pred = predictionExp_theta(X, theta)
    y_pred = theta(1) * exp(theta(2) * X(:, 1)) + sum(X(:, 2:end) * theta(3:end));
end

function cost = cost_function(y_pred, y_obs)
    cost = mean((y_pred - y_obs).^2);
end