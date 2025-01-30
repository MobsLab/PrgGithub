function output1=MainBinnueSelfEntropy(numchannels,dataDir,quantLevels,tempOrder)
%% Experiment using data from ...
% 
% Some explanations about how to set up the methods
% 
%     Method order: please take the order into account because afterwards
%     you should set autoPairwiseTarDriv or handPairwiseTarDriv that need
%     the precise order of the methods
% 
%     binue                                 
%     binnue                                                       
%     linue                              
%     linnue                                                  
%     nnue
%     nnnue
%     neunetnue
% 
% 
%     Parameters to specify for each method
% 
%    binnue

    idTargets             = [1:numchannels];
    idDrivers             = [numchannels:-1:1];
    idOtherLagZero        = [0,0];
    modelOrder            = tempOrder;
    multi_bivAnalysis     = 'biv';
    numQuantLevels        = quantLevels;
    entropyFun            = @evaluateNonUniformEntropy;
    preProcessingFun      = @quantization;
    secondTermCaseVect    = [1 1];
    numSurrogates         = 100;
    alphaPercentile       = 0.05;
    ******** Set the following fields together *******
    genCondTermFun        = @generateConditionalTerm;%@generateConditionalTerm_selectionVar;%@generateCondTermLagZero
    usePresent            = 0;
    scalpConduction       = 0;
% **************************************************





    %% ***************************************************
    %% PAY ATTENTION: to run this example you should just set the path at lines 146, 153 and 196 according to your operating system and folder in which MuTE is stored
    %% PAY ATTENTION: maybe MATLAB can report errors because you are not able to run the parallel session, so by default the parfor in parametersAndMethods, line 250
    %%                and in callingMethods, line 18, are set as for
    %% ***************************************************

 %% Set MuTE folder path including also all the subfolders, for instance
    mutePath = ('/media/DISK_1/Dropbox/Kteam/PrgMatlab/MuTE_onlineVersion/'); % Adjust according to your path -> just an example: mutePath = '/home/alessandro/Scrivania/MuTE/';
    cd(mutePath);
    addpath(genpath(pwd));
    
    nameDataDir  = 'TestRandData/';
    
    %% Set the directory in which the data files are stored. In this directory the outcome of the experiments will be stored too.
    dataDir      = ['/media/DISK_1/Dropbox/Kteam/PrgMatlab/MuTE_onlineVersion/exampleToolbox/' nameDataDir]; % Adjust according to your path -> just as example: dataDir = ['/home/alessandro/Scrivania/MuTE/' nameMainDir];
    
    % *****************************************************
    %% PAY ATTENTION: if you are able to run the parallel session you can set numProcessors > 1
    numProcessors               = 0;
    % *****************************************************



        
    %% EXPERIMENTS
    
  

    cd(dataDir);

%%  Defining the strings to load the data files
    dataFileName    = 'Data1';
    dataLabel       = '';
    dataExtension   = '.mat';
    

%%     making storing folders
    
    resDir          = [dataDir dataFileName '_' dataLabel '/'];
    if (~exist([dataDir 'resDir'],'dir'))
        mkdir(resDir);
    end
    copyDir   = [resDir 'entropyMatrices' dataLabel '/'];
    if (~exist([resDir 'copyDir'],'dir'))
        mkdir(copyDir);
    end
    

%%    defining result directories 

    cd(dataDir);
    resultDir           = [resDir 'results' dataLabel '/'];
%     if (~exist([resDir 'resultDir'],'dir'))
%         mkdir(resultDir);
%     end
    % *****************************************************  
      % *****************************************************
    %% Indicate the path of the mexa64 file to run the nearest neighbour method. 
    %% PAY ATTENTION: maybe this file should be compiled on your own machine. This file is important to run nnue and nnnue methods.
    %% By default these methods are commented to avoid any error
    nnMexa64Path = '/media/DISK_1/Dropbox/Kteam/PrgMatlab/MuTE_onlineVersion/OpenTSTOOL/tstoolbox/mex/mexa64/'; % Adjust according to your path -> just an example nnMexa64Path = '/home/alessandro/Scrivania/MuTE/OpenTSTOOL/tstoolbox/mex/mexa64/';
    % *****************************************************

%%  Defining the experiment parameters
    channels             = 1:numchannels;
    samplingRate         = 1;
    pointsToDiscard      = 0;
    listRealization      = dir([dataDir [dataFileName '*' dataLabel '*' dataExtension]]);
    autoPairwiseTarDriv  = [0 0 0 0 0 0 0 0];
    handPairwiseTarDriv  = [1 0 0 0 0 0 0 0];
    
    
%   neunetnue parameters
    threshold           = 0.008;
    valThreshold        = 0.6;
    numHiddenNodes      = 0.3;
    
    
    
%  
       %% STATISTICAL METHODS

    fprintf('\n******************************\n\n');
    disp('Computing statistical methods...');
    fprintf('\n\n');

    tic
    [output1,params1]               = parametersAndMethods(listRealization,samplingRate,pointsToDiscard,channels,autoPairwiseTarDriv,...
                                      handPairwiseTarDriv,resultDir,dataDir,copyDir,numProcessors,...
                                    'binnueSelf',idTargets,idDrivers,idOtherLagZero,'multiv',numQuantLevels,entropyFun,preProcessingFun,...
                                    secondTermCaseVect,numSurrogates,alphaPercentile,genCondTermFun,usePresent,scalpConduction);
                                
    close all
                                
                                close all
    toc


    fprintf('\n\n');
    disp('...computation done!');
    fprintf('\n\n');
    
    close all
    cd(mutePath);
    exit;


    
    
end