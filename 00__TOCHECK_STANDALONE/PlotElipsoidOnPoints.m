%PlotElipsoidOnPoints

%# generate data
num = 50;
X = [ mvnrnd([0.5 1.5], [0.025 0.03 ; 0.03 0.16], num) ; ...
      mvnrnd([1 1], [0.09 -0.01 ; -0.01 0.08], num)   ];
G = [1*ones(num,1) ; 2*ones(num,1)];

gscatter(X(:,1), X(:,2), G)
axis equal, hold on

for k=1:2
    %# indices of points in this group
    idx = ( G == k );

    %# substract mean
    Mu = mean( X(idx,:) );
    X0 = bsxfun(@minus, X(idx,:), Mu);

    %# eigen decomposition [sorted by eigen values]
    [V D] = eig( X0'*X0 ./ (sum(idx)-1) );     %#' cov(X0)
    [D order] = sort(diag(D), 'descend');
    D = diag(D);
    V = V(:, order);

    t = linspace(0,2*pi,100);
    e = [cos(t) ; sin(t)];        %# unit circle
    VV = V*sqrt(D);               %# scale eigenvectors
    e = bsxfun(@plus, VV*e, Mu'); %#' project circle back to orig space

    %# plot cov and major/minor axes
    plot(e(1,:), e(2,:), 'Color','k');
    quiver(Mu(1),Mu(2), VV(1,1),VV(2,1), 'Color','k')
    quiver(Mu(1),Mu(2), VV(1,2),VV(2,2), 'Color','k')
end
