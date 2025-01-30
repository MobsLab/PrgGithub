%This code has the goal to sum up the main function of my internship in a
%context where they are usefull
%Don't hesitate to contact me if you have any questions :
%tom.mariani68@gmail.com 


%Launch DATA 
PipeLaunchDATA_TM()

%Important variables are 
    % DATAtable = Table structure : a field is a datatable of a mouse with 
        %OB_Frequency and a lot of predictors that can be used : uncomment
        %the following line to see which one 
        %disp(DATAtable.(Mice{1}).Properties.VariableNames
    % Mice = Cell Array : names of all mice that are in the DATAtable
    % MiceNumber = length(Mice)
%For Information, other Datatable can be used (and their corresponding Mice):
    % DATAtableDZP is for Diazepam Mice
    % DATAtableWV : OB Frequency has been obtained with the
        %"wavelet" method, see BM for more info 
    % DATAtableSBF : OB Frequency has been obtained with spectrogram and 
        %multiplication by a certain frequency  
    % DATAtableCleared : DATAtable but without some designated outliers 
        %thresholdNumObservation (50) points of observation are required 
        %thresholdFreezSafeExistence (10) points in safe side are required 
        
% Let's fit our first model 
coefAnalysisCorrected = PipeLineSelectionPred_TM(DATAtableCleared, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisCorrected", "noConstraintsxlearningSigGTxcorrection");

%Here basically, we choose to work on cleared Database
%we choose one predictor : Exponential(Time Since Last Shock / tau) 
%where tau = 30 seconds see my report to see why
%But we choose in options learning SigGT meaning that we add in predictors 
%a sigmoid of global time with 2 hyperparameters the slope (ls) and the 
%middle point (lp) (which is in interaction with the position by a fixed
%sigmoid) 
%noConstraints means that we don't choose a constrained model
%correction means that we use a logscale for the slope of sigmoid (ls)

%coefAnalysisCorrected is a structure where you can find the R2 of the
%model with different ls and lp 
%a side effect of tis function : we add a field in global variable Models
%that contains the models for each mouse

%We add the global variable to our workspace
global Models 

%We want to discover the fitted data of our model so we use a dashboard to
%evaluate our model 
GuiDashboard_TM(DATAtableCleared, Models.AnalysisCorrected, "AnalysisCorrected",...
    coefAnalysisCorrected)

%you can switch mouse by clicking on previous and next 
%Documentations will be soon written to exploit all the potential of this
%dashboard because there is a lot of hidden fonctionnalities :) 

%If you want to have a look at performances of the model without the
%details on each mouse, uncomment the following line
%PanelLinearModel(DATAtableCleared, Models.AnalysisCorrected, "AnalysisCorrected")


% Let's fit our second model on diazepam mice to compare it to the others
coefAnalysisDZPCorrected = PipeLineSelectionPred_TM(DATAtableDZP, {'ExpTimeSinceLastShockGlobal'}, ...
    "AnalysisDZPCorrected", "noConstraintsxlearningSigGTxcorrection");

%Here it is the same as before but for Diazepam Mice 

%Let's have a look at the differences between these models 
Gui_ModelsComparisonUnpaired(Models.AnalysisCorrected, Models.AnalysisDZPCorrected,  ...
    "Saline", "Diazepam",  MiceCleared, MiceDZP, coefAnalysisCorrected, coefAnalysisDZPCorrected)

%choose the predictors that matches : here it's simple because they have
%the same : so click on 
    %Constant - Constant 
    %ExpTimeSinceLastShockGlobal - ExpTimeSinceLastShockGlobal
    %SigPosxSigGlobalTime - SigPosxSigGlobalTime
%If you want to be more accurate with the comparison, you have to remove
%the Saline Mice that received PAG aversive stimulations : just replace
%MiceCleared by MiceEyelidCleared


%If we want to optimize an other hyperparameter 
%Warning this calculus take a lot of time (around 30minutes by mouse) 
%coefFinalFullLearn = PipeLineSelectionPred_TM(DATAtableCleared, {},...
%    "FinalFullLearn", "noConstraintsxlearningSigGTxlearningExpTSLSxcorrection");

%It's quite the same as before
%Except the fact that we add in options "learningExpTSLS" meaning that
%coefFinalFullLearn now contains more fields with the R2 obtains when
%varying all the hyperparameters
%If you d'ont want to run the function you can load the results here :
FullLearning = load('~/Dropbox/Kteam/PrgMatlab/Tom/FullLearning.mat');
coefFinalFullLearn = FullLearning.coefFinalFullLearn;
Models.FinalFullLearn = FullLearning.Models.FinalFullLearn;


%Lets compare the model with optimization on tau and without
Gui_ModelsComparison(DATAtableCleared, Models.FinalFullLearn, Models.AnalysisCorrected, ...
    "Tau Optimized", "Tau Fixed", coefFinalFullLearn, coefAnalysisCorrected)

%Here you can switch between mice with the popup menu 
%the comparison between models here is easier as the last one because we fit
%predictors on the same data, we have the same mice 
