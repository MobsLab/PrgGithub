function output = ViewRecontructionMean(res)

output = [];
k = 6; %number of iterations per cycle
nConditions = size(res,1);

conditions = {'PAf 1','PAb 1','PAf 2','PAb 2','A'};
fig = figure;

for j = 1:nConditions,
    
    % estimation is the probability matrix and x is the timestamp-position vector
    estimation = res{j,1};
    x = res{j,2};
    %number of position bin    
    nBins = size(estimation,1); 

    %Center the estimation matrix around the real position
    pos = ceil( x(:,2) * nBins);
    estimationCent = CenterMat(estimation,pos);

    %Average
    n = floor(size(estimationCent,2)/k)*k; 
    estim = reshape(estimationCent(:,1:n),nBins,k,[]);
    estim = mean(estim,3);

    subplot(3,2,j);
    hold on;
    PlotColorMap(estim);
    title(conditions{j})

end
