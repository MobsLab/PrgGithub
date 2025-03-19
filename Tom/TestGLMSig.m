X = rand(500,2);
X(:,1) = (1:500)/100; %serie temporelle
X(:,2) = ones(500,1); %terme constant

Y = 0.1*rand(500,1)+0.25;
Y(end/2:end) = Y(end/2:end)-0.5;

[theta, costs] = ModelGLMSig(X,Y);

x = (1:500) /100;
plot(theta(1) ./ (1+exp(-theta(2) * (x - theta(3)))))

% ... plot(0.5 ./ (1 + exp(-100 * (x - 2.5)))+0.25) ... 