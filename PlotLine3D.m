function dis=PlotLine3D(X1,X2,X3,plo)


if plo
figure('color',[1 1 1])
end

X=[zscore(X1),zscore(X2),zscore(X3)];



plot3(X(:,1),X(:,2),X(:,3),'bo');
grid on;
maxlim = max(abs(X(:)))*1.1;
axis([-maxlim maxlim -maxlim maxlim -maxlim maxlim]);
axis square
view(-23.5,5);

%%
% Next, we fit a plane to the data using PCA. The coefficients for the first
% two principal components define vectors that form a basis for the plane.
% The third PC is orthogonal to the first two, and its coefficients define the
% normal vector of the plane.
[coeff,score,roots] = princomp(X);
basis = coeff(:,1:2);
%%
normal = coeff(:,3);
%%
% That's all there is to the fit. But let's look closer at the results, and
% plot the fit along with the data.

%%
% Because the first two components explain as much of the variance in the data
% as is possible with two dimensions, the plane is the best 2-D linear
% approximation to the data. Equivalently, the third component explains the
% least amount of variation in the data, and it is the error term in the
% regression. The latent roots (or eigenvalues) from the PCA define the
% amount of explained variance for each component.
pctExplained = roots' ./ sum(roots);

%%
% The first two coordinates of the principal component scores give the
% projection of each point onto the plane, in the coordinate system of the
% plane. To get the coordinates of the fitted points in terms of the original
% coordinate system, we multiply each PC coefficient vector by the
% corresponding score, and add back in the mean of the data. The residuals
% are simply the original data minus the fitted points.
[n,p] = size(X);
meanX = mean(X,1);
Xfit = repmat(meanX,n,1) + score(:,1:2)*coeff(:,1:2)';
residuals = X - Xfit;

%% Fitting a line to 3-D data
% Fitting a straight line to the data is even simpler, and because of the
% nesting property of PCA, we can use the components that have already been
% computed. The direction vector that defines the line is given by the
% coefficients for the first principal component. The second and third PCs
% are orthogonal to the first, and their coefficients define directions
% that are perpendicular to the line. The equation of the line is |meanX +
% t*dirVect|.
dirVect = coeff(:,1);

%%
% The first coordinate of the principal component scores gives the
% projection of each point onto the line. As with the 2-D fit, the PC
% coefficient vectors multiplied by the scores the gives the fitted points
% in the original coordinate system.
Xfit1 = repmat(meanX,n,1) + score(:,1)*coeff(:,1)';

%%
% Plot the line, the original data, and their projection to the line.
t = [min(score(:,1))-.2, max(score(:,1))+.2];
endpts = [meanX + t(1)*dirVect'; meanX + t(2)*dirVect'];
plot3(endpts(:,1),endpts(:,2),endpts(:,3),'k-');

Xa = [X(:,1) Xfit1(:,1) nan*ones(n,1)];
Xb = [X(:,2) Xfit1(:,2) nan*ones(n,1)];
Xc = [X(:,3) Xfit1(:,3) nan*ones(n,1)];
hold on
dis=sqrt((Xa(:,1)-Xa(:,2)).^2+(Xb(:,1)-Xb(:,2)).^2+(Xc(:,1)-Xc(:,2)).^2);
plot3(Xa',Xb',Xc','k-', X(:,1),X(:,2),X(:,3),'ko');
scatter3(X(:,1),X(:,2),X(:,3),40,dis,'filled')
hold off
maxlim = max(abs(X(:)))*1.1;
axis([-maxlim maxlim -maxlim maxlim -maxlim maxlim]);
axis square
view(-23.5,5);
grid on

%%
% While it appears that some of the projections in this plot are not
% perpendicular to the line, that's just because we're plotting 3-D data
% in two dimensions. In a live |MATLAB| figure window, you could
% interactively rotate the plot to different perspectives to verify that
% the projections are indeed perpendicular, and to get a better feel for
% how the line fits the data. 