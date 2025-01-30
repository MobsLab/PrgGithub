function output = BatchViewReconstructionMean(varargin)

%BatchReconstructionCycle - Bayesian reconstruction of the rat's position
% 
%           
%
%  USAGE
%
%    output = BatchViewReconstructionMean(varargin);
%
%    =========================================================================
%     Properties    Values
%    ----------------------------------------------------------------------
%     'k'          number of iterations per cycle - phase division (default = 6)      
%    =========================================================================
%
%
%  STORAGE
%
%    Figures:
%     * Mean of the centered estimation matrix in [0,2pi]
%

output=[];

% Parameters
k = 12;
nVariables = 243;

%eid & name
eidEstim = '"Estimation matrix"';
eidX = '"Position Bin"';

%Loop over variables
for i = 1:nVariables,
    
    if i==243 || (i>56 && i<62),
        continue;
    end
    
    % Find variable in the database
    DBUse('BayesReconstruction');
    s = int2str(i);
    StructEstimation = DBSelectVariables(['eid = ' eidEstim ' limit ' s ',1;'],'info','on');
    StructPos = DBSelectVariables(['eid = ' eidX ' limit ' s ',1;'],'info','on');
    
    %Name of the figure
    name = StructPos.name{1};
    
    if ~strcmp(name,StructEstimation.name{1}),
        e = i
    end
    
    % Estimation Matrix and position vector
    estimation = StructEstimation.v{1};
    pos = StructPos.v{1};
    %nBins
    nBins = size(estimation,1);
    
    % Center the estimation matrix and reshape it to get a (nBins x k x []) matrix 
    estimationCent = CenterMat(estimation,pos);
    n = floor(size(estimationCent,2)/k)*k; 
    estim = reshape(estimationCent(:,1:n),nBins,k,[]);
    estim = mean(estim,3);
    
    %Store figure
    DBUse('ViewReconstructionK12');
    fig = figure;hold on;
    PlotColorMap(estim);   
    DBInsertFigure(fig,'Estimation centered averaged',name,'','',{'BatchViewReconstructionMean'});
    close(fig);
   
    
end

