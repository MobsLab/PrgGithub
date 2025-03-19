%MainLFPReconstruction
clear all
global TrialSet time InputInfo
% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
% Get directories
CtrlEphys=[253,258,299,395,403,451,248,244,254,402];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');

%% Do fit with chosen fit function
% Options
InputInfo.subsample=1;
InputInfo.SampleRate=1250;
InputInfo.MaxFunEvals_Data=10000;
InputInfo.MaxIter_Data=10000;
InputInfo.Display=0;

% Just fo weighted sum
% InputInfo.x0=[1,5];
% FitFunction=@ErrorModelWeightedSum;
% ConstraintFunction=@ErrorModelWeightedSumConstr;
% weighted sum and a little lag
% InputInfo.x0=[1,5,-0.05,-0.01];
% FitFunction=@ErrorModelWeightedDelaySum;
% ConstraintFunction=@ErrorModelWeightedSumDelayConstr;
% InputInfo.MaxDel=0.1;
% Alpha functions
x0=[1,2,0.005,1,2,0.005];
InputInfo.x0=x0;
InputInfo.MaxKernelDur=0.1;
FitFunction=@ErrorModelAlphaFunction;
ConstraintFunction=@ErrorModelAlphaFunctionConstr;
TrialDur=4*1e4;
FitFunctionBis=@ErrorModelAlphaFunctionOBFixedHPCRes;
ConstraintFunctionBis=@ErrorModelAlphaFunctionOBFixedHPCResConstr;

for mm=11:-1:3
    mm
    cd(Dir.path{mm})
    clear FreezeEpoch x Err
    try
        load('ChannelsToAnalyse/dHPC_deep.mat')
        chH=channel;
    catch
        load('ChannelsToAnalyse/dHPC_rip.mat')
        chH=channel;
    end
    load(['LFPData/LFP',num2str(chH),'.mat']);
    FilLFP=FilterLFP(LFP,[0.01 30],1024);
    AllLFP.HPC=FilLFP;
    
    load('ChannelsToAnalyse/Bulb_deep.mat')
    chB=channel;
    load(['LFPData/LFP',num2str(chB),'.mat']);
    FilLFP=FilterLFP(LFP,[0.01 30],1024);
    AllLFP.OB=FilLFP;
    
    load('ChannelsToAnalyse/PFCx_deep.mat')
    chP=channel;
    load(['LFPData/LFP',num2str(chP),'.mat']);
    FilLFP=FilterLFP(LFP,[0.01 30],1024);
    AllLFP.PFCx=FilLFP;
    
    load('behavResources.mat')
    % Prepare the data set
    TrialSetAll=OrganizeDataOBHPCPFCxFit(AllLFP,FreezeEpoch,TrialDur);
    NumTrials=size(TrialSetAll.HPC,1);
    
    % Real Data - OBHPC
    for nt=1:min(NumTrials,20)
        AllTrials=[1:NumTrials];AllTrials(nt)=[];
        TrialSet.HPC=TrialSetAll.HPC(AllTrials,:);
        TrialSet.OB=TrialSetAll.OB(AllTrials,:);
        TrialSet.PFCx=TrialSetAll.PFCx(AllTrials,:);
        [x.RealDataOBHPC(nt,:),fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction);
        % Now get error on left out trial
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.RealDataOBHPC(nt)=feval(FitFunction,x.RealDataOBHPC(nt,:));
    end
    
    % Shuffle Data  OBHPC
    for nt=1:min(NumTrials,20)
        AllTrials=[1:NumTrials];AllTrials(nt)=[];
        TrialSet.HPC=TrialSetAll.HPC(AllTrials,:);
        TrialSet.OB=TrialSetAll.OB(AllTrials,:);
        TrialSet.PFCx=TrialSetAll.PFCx(AllTrials,:);
        TrialSet.OB=TrialSet.OB(circshift([1:length(AllTrials)]',2),:);
        TrialSet.HPC=TrialSet.HPC(circshift([1:length(AllTrials)]',5),:);
        [x.ShuffDataOBHPC(nt,:),fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction);
        % Now get error on left out trial
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.ShuffDataOBHPC(nt)=feval(FitFunction,x.ShuffDataOBHPC(nt,:));
    end
    
    % Real Data - JustHPC
    for nt=1:min(NumTrials,20)
        AllTrials=[1:NumTrials];AllTrials(nt)=[];
        TrialSet.HPC=TrialSetAll.HPC(AllTrials,:);
        TrialSet.OB=0*TrialSetAll.OB(AllTrials,:);
        TrialSet.PFCx=TrialSetAll.PFCx(AllTrials,:);
        [x.RealDataJustHPC(nt,:),fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction);
        % Now get error on left out trial
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=0*TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.RealDataJustHPC(nt)=feval(FitFunction,x.RealDataJustHPC(nt,:));
    end
    
    % Shuffle Data  JustHPC
    for nt=1:min(NumTrials,20)
        AllTrials=[1:NumTrials];AllTrials(nt)=[];
        TrialSet.HPC=TrialSetAll.HPC(AllTrials,:);
        TrialSet.OB=0*TrialSetAll.OB(AllTrials,:);
        TrialSet.PFCx=TrialSetAll.PFCx(AllTrials,:);
        TrialSet.OB=TrialSet.OB(circshift([1:length(AllTrials)]',2),:);
        TrialSet.HPC=TrialSet.HPC(circshift([1:length(AllTrials)]',5),:);
        [x.ShuffDataJustHPC(nt,:),fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction);
        % Now get error on left out trial
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=0*TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.ShuffDataJustHPC(nt)=feval(FitFunction,x.ShuffDataJustHPC(nt,:));
    end
    
  
    % Real Data - JustOB
    for nt=1:min(NumTrials,20)
        AllTrials=[1:NumTrials];AllTrials(nt)=[];
        TrialSet.HPC=0*TrialSetAll.HPC(AllTrials,:);
        TrialSet.OB=TrialSetAll.OB(AllTrials,:);
        TrialSet.PFCx=TrialSetAll.PFCx(AllTrials,:);
        [x.RealDataJustOB(nt,:),fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction);
        TrialSet.HPC=TrialSetAll.HPC(AllTrials,:);
        InputInfo.FixedOB=x.RealDataJustOB(nt,1:3);
        InputInfo.x0=x0(4:end);
        [xtemp,fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunctionBis,ConstraintFunctionBis);
        x.RealDataOBFixedHPCRed(nt,:)=[x.RealDataJustOB(nt,1:3),xtemp];
        InputInfo.x0=x0;
        % Now get  erroron left out trial
        TrialSet.HPC=0*TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.RealDataJustOB(nt)=feval(FitFunction,x.RealDataJustOB(nt,:));
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.RealDataOBFixedHPCRed(nt)=feval(FitFunction,x.RealDataOBFixedHPCRed(nt,:));
    end
    
    % Shuffle Data  JustOB
    for nt=1:min(NumTrials,20)
        AllTrials=[1:NumTrials];AllTrials(nt)=[];
        TrialSet.HPC=0*TrialSetAll.HPC(AllTrials,:);
        TrialSet.OB=TrialSetAll.OB(AllTrials,:);
        TrialSet.PFCx=TrialSetAll.PFCx(AllTrials,:);
        TrialSet.OB=TrialSet.OB(circshift([1:length(AllTrials)]',2),:);
        TrialSet.HPC=TrialSet.HPC(circshift([1:length(AllTrials)]',5),:);
        [x.ShuffDataJustOB(nt,:),fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction);
        TrialSet.HPC=TrialSetAll.HPC(AllTrials,:);
        InputInfo.FixedOB=x.ShuffDataJustOB(nt,1:3);
        InputInfo.x0=x0(4:end);
        [xtemp,fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunctionBis,ConstraintFunctionBis);
        x.ShuffDataOBFixedHPCRed(nt,:)=[x.ShuffDataJustOB(nt,1:3),xtemp];
        InputInfo.x0=x0;
        % Now get  erroron left out trial
        TrialSet.HPC=0*TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.ShuffDataJustOB(nt)=feval(FitFunction,x.ShuffDataJustOB(nt,:));
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.ShuffDataOBFixedHPCRed(nt)=feval(FitFunction,x.ShuffDataOBFixedHPCRed(nt,:));
        
    end
    
    
    
    save('LFPReconstruction/LFPReconstrucionAlphaFunction.mat','x','Err','InputInfo','ConstraintFunction','FitFunction')
    clear x Err
end
