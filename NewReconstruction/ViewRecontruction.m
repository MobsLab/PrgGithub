function output = ViewRecontruction(estimation,x)

nBins = size(estimation,1); 
k = 6;

%Center
pos = ceil( x(:,2) * nBins);
estimationCent = CenterMat(estimation,pos);

%average
n = floor(size(estimationCent,2)/k)*k; 
estim = reshape(estimationCent(:,1:n),nBins,k,[]);
estim = mean(estim,3);

fig = figure;hold on;
PlotColorMap(estim);

output = estim;