function y_pred = predictionExp_theta(X, theta)
    y_pred = theta(1) * exp(theta(2) * X(:, 1)) + sum(X(:, 2:end) * theta(3:end));
end