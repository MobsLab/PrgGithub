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
InputInfo.x0=[1,5];
FitFunction=@ErrorModelWeightedSum;
ConstraintFunction=@ErrorModelWeightedSumConstr;
% weighted sum and a little lag
% InputInfo.x0=[1,5,-0.05,-0.01];
% FitFunction=@ErrorModelWeightedDelaySum;
% ConstraintFunction=@ErrorModelWeightedSumDelayConstr;
% InputInfo.MaxDel=0.1;

for mm=6:length(Dir.path)
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
    TrialDur=4*1e4;
    % Prepare the data set
    TrialSetAll=OrganizeDataOBHPCPFCxFit(AllLFP,FreezeEpoch,TrialDur);
    NumTrials=size(TrialSetAll.HPC,1);
    
    % Real Data - OBHPC
    for nt=1:NumTrials
        AllTrials=[1:NumTrials];AllTrials(nt)=[];
        TrialSet.HPC=TrialSetAll.HPC(AllTrials,:);
        TrialSet.OB=TrialSetAll.OB(AllTrials,:);
        TrialSet.PFCx=TrialSetAll.PFCx(AllTrials,:);
        %     TrialSet.PFCx=0.5*TrialSet.OB-5.5*TrialSet.HPC;
        [x.RealDataOBHPC(nt,:),fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction);
        % Now get error on left out trial
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        %     TrialSet.PFCx=0.5*TrialSet.OB-5.5*TrialSet.HPC;
        Err.RealDataOBHPC(nt)=ErrorModelWeightedSum(x.RealDataOBHPC(nt,:));
    end
    
    % Shuffle Data  OBHPC
    for nt=1:NumTrials
        AllTrials=[1:NumTrials];AllTrials(nt)=[];
        TrialSet.HPC=TrialSetAll.HPC(AllTrials,:);
        TrialSet.OB=TrialSetAll.OB(AllTrials,:);
        TrialSet.PFCx=TrialSetAll.PFCx(AllTrials,:);
        %TrialSet.PFCx=0.5*TrialSet.OB-5.5*TrialSet.HPC;
        TrialSet.OB=TrialSet.OB(circshift([1:length(AllTrials)]',2),:);
        TrialSet.HPC=TrialSet.HPC(circshift([1:length(AllTrials)]',5),:);
        [x.ShuffDataOBHPC(nt,:),fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction);
        % Now get error on left out trial
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        %    TrialSet.PFCx=0.5*TrialSet.OB-5.5*TrialSet.HPC;
        Err.ShuffDataOBHPC(nt)=ErrorModelWeightedSum(x.ShuffDataOBHPC(nt,:));
    end
    
    % Real Data - OBHPC
    for nt=1:NumTrials
        % Now get error on left out trial
        TrialSet.HPC=TrialSetAll.HPC(nt,:);
        TrialSet.OB=TrialSetAll.OB(nt,:);
        TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
        Err.RealDataJustHPC(nt)=min([ErrorModelWeightedSum([0,1]),ErrorModelWeightedSum([0,-1])]);
        Err.RealDataJustOB(nt)=min([ErrorModelWeightedSum([1,0]),ErrorModelWeightedSum([-1,0])]);

    end
    
    
   % mkdir('LFPReconstruction')
save('LFPReconstruction/LFPReconstrucionWeightedSum.mat','x','Err','InputInfo','ConstraintFunction','FitFunction')
clear x Err
end


for mm=1:11
    cd(Dir.path{mm})
    
%     clear FreezeEpoch x Err
%     try
%         load('ChannelsToAnalyse/dHPC_deep.mat')
%         chH=channel;
%     catch
%         load('ChannelsToAnalyse/dHPC_rip.mat')
%         chH=channel;
%     end
%     load(['LFPData/LFP',num2str(chH),'.mat']);
%     FilLFP=FilterLFP(LFP,[1 30],1024);
%     AllLFP.HPC=FilLFP;
%     
%     load('ChannelsToAnalyse/Bulb_deep.mat')
%     chB=channel;
%     load(['LFPData/LFP',num2str(chB),'.mat']);
%     FilLFP=FilterLFP(LFP,[1 30],1024);
%     AllLFP.OB=FilLFP;
%     
%     load('ChannelsToAnalyse/PFCx_deep.mat')
%     chP=channel;
%     load(['LFPData/LFP',num2str(chP),'.mat']);
%     FilLFP=FilterLFP(LFP,[1 30],1024);
%     AllLFP.PFCx=FilLFP;
%     
    load('behavResources.mat')
    TrialDur=4*1e4;
    % Prepare the data set
    TrialSetAll=OrganizeDataOBHPCPFCxFit(AllLFP,FreezeEpoch,TrialDur);
    NumTrials=size(TrialSetAll.HPC,1);
        load('LFPReconstruction/LFPReconstrucionWeightedSum.mat')
    AllX.mean(mm,:)=mean(x.RealDataOBHPC);
    AllX.std(mm,:)=std(x.RealDataOBHPC);
    AllErr.Real(mm,:)=mean(Err.RealDataOBHPC);
    AllErr.Shuff(mm,:)=prctile(Err.ShuffDataOBHPC,5);
% 
%     for nt=1:NumTrials
%         TrialSet.HPC=TrialSetAll.HPC(nt,:);
%         TrialSet.OB=TrialSetAll.OB(nt,:);
%         TrialSet.PFCx=TrialSetAll.PFCx(nt,:);
%         [y,PFCModel]=ModelWeightedSum(mean(x.RealDataOBHPC(:,:)));
%         subplot(311)
%         plot(PFCModel), hold on
%         plot(TrialSet.PFCx,'r')
%         subplot(312)
%         [y,PFCModel]=ModelWeightedSum([1,0]);
%         plot(PFCModel), hold on
%         plot(TrialSet.PFCx,'r')
%         subplot(313)
%         [y,PFCModel]=ModelWeightedSum([0,-1]);
%         plot(PFCModel), hold on
%         plot(TrialSet.PFCx,'r')
% 
%         keyboard
% clf
%     end
end

figure
subplot(221)
hist(fval,20)
subplot(223)
hist(fvalSh,20)
subplot(222)
hist(x(:,1)./x(:,2),20), hold on
line([1 1]*-0.5/5.5,ylim)
subplot(224)
hist(xSh(:,1)./xSh(:,2),20), hold on
line([1 1]*-0.5/5.5,ylim)




