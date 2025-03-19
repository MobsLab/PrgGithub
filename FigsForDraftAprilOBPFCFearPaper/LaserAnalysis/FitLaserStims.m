% Options
InputInfo.subsample=1;
InputInfo.SampleRate=1250;
InputInfo.MaxFunEvals_Data=10000;
InputInfo.MaxIter_Data=10000;
InputInfo.Display=0;

x0=[1,2,0.005,1,2,0.005];
InputInfo.x0=x0;
InputInfo.MaxKernelDur=0.1;

% INPUTS
Dir.path={
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
    };

for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:end);Dir.name{k}=strrep(Dir.name{k},'/','_');
end

AllFreq=[1,2,4,7,10,13,15,20];
Structures={'PFCx','PiCx','dHPC'};
Sides={'Left','Right'}

global TrialSet time InputInfo

cd(Dir.path{d})
clear AllLFP
load('StimInfo.mat')

load('ChannelsToAnalyse/Bulb_deep_left.mat')
AllChans.Bulb.Left=channel;
load('ChannelsToAnalyse/Bulb_deep_right.mat')
AllChans.Bulb.Right=channel;
load('ChannelsToAnalyse/PFCx_deep_left.mat')
AllChans.PFCx.Left=channel;
load('ChannelsToAnalyse/PFCx_deep_right.mat')
AllChans.PFCx.Right=channel;
try,load('ChannelsToAnalyse/dHPC_rip.mat')
    AllChans.dHPC.Right=channel;
catch
    load('ChannelsToAnalyse/dHPC_deep.mat')
    AllChans.dHPC.Right=channel;
end
load('ChannelsToAnalyse/PiCx_left.mat')
AllChans.PiCx.Left=channel;
load('ChannelsToAnalyse/PiCx_right.mat')
AllChans.PiCx.Right=channel;
load('LFPData/DigInfo4.mat')
Laser=DigTSD;
StimsTTL=thresholdIntervals(Laser,0.9998,'Direction','Above');

for freq=1:length(AllFreq)
    Stims=find(StimInfo.Freq==AllFreq(freq));
    StimEpoch=intervalSet(StimInfo.StartTime(:)*1e4,StimInfo.StopTime(:)*1e4);
    StimEpoch=intervalSet(Start(StimEpoch)-5*1e4,Stop(StimEpoch)+5*1e4);
    
    OBChan=AllChans.Bulb.(Sides{sd});
    PFCCHan=AllChans.PFCx.(Sides{sd});
    PiCxChan=AllChans.PiCx.(Sides{sd});
    if sd==2
        dHPCChan=AllChans.dHPC.(Sides{sd});
    end
    fig=figure;set(fig,'Position',[680 5580 1500 720])
    subplot(141)
    load(['LFPData/LFP' num2str(OBChan) '.mat'])
    TrialSet.In=OrganizeDataForKernelFitting(LFP,StimEpoch,39.5*1e4);
    load(['LFPData/LFP' num2str(PFCCHan) '.mat'])
    TrialSet.Out=OrganizeDataForKernelFitting(LFP,StimEpoch,39.5*1e4);
    [x,fval,exitflag,output,lambda,grad,hessian]=FitTheDataKernal(TrialSet,@ErrorModelLaserAlphaFunction,@ErrorModelAlphaFunctionConstr); 
end





