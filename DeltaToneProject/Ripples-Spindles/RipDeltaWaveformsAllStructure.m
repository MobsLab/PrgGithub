a=0;
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';            % Mouse 243 - Day 5

a=0;
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';            % Mouse 244 - Day 5

a=0;
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251 - Day 2
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251'; % Mouse 251 - Day 3
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5

a=0;
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse252'; % Mouse 252 - Day 1
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252'; % Mouse 252 - Day 2
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse252'; % Mouse 252 - Day 3
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse252'; % Mouse 252 - Day 4
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse252'; % Mouse 252 - Day 5

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%---------------------------------------------------------------------------------------------------------------------------------------------------
%                                                       LOAD  EPOCH & DELTA for BASAL SLEEP
%---------------------------------------------------------------------------------------------------------------------------------------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
binS=10;nbin=1000;smo=0.5;

for a=1:length(Dir.pathBasal)
    cd(Dir.pathBasal{a})
    res=pwd;
    load EpochToAnalyse
    load StateEpochSB SWSEpoch
    load RipplesdHPC25
    rip=ts(dHPCrip(:,2)*1E4);
    
    
    % >>> generate LFP Waveforms during SPW-Rs:
    res=pwd;
    load([res,'/ChannelsToAnalyse/PFCx_deep']); PFCx_deep=channel;
    load([res,'/ChannelsToAnalyse/PFCx_sup']); PFCx_sup=channel;
    load([res,'/ChannelsToAnalyse/dHPC_rip']); dHPC_rip=channel;
    
    
    clear LFP
    load([res,'/LFPData/LFP',num2str(dHPC_rip)]);
    rawLFP_dHPC{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
    clear LFP
    load([res,'/LFPData/LFP',num2str(PFCx_deep)]);
    rawLFP_PFCx_deep{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
    clear LFP
    load([res,'/LFPData/LFP',num2str(PFCx_sup)]);
    rawLFP_PFCx_sup{a}=PlotRipRaw(LFP,Range(rip)/1E4,1000);close
    
end

A=rawLFP_dHPC{1};a1=A(:,1);a2=A(:,2);
B=rawLFP_dHPC{2};b1=B(:,1);b2=B(:,2);
C=rawLFP_dHPC{3};c1=C(:,1);c2=C(:,2);
D=rawLFP_dHPC{4};d1=D(:,1);d2=D(:,2);
E=rawLFP_dHPC{5};e1=E(:,1);e2=E(:,2);
rip_dHPC_1=mean([a1,b1,c1,d1,e1],2);
rip_dHPC_2=mean([a2,b2,c2,d2,e2],2);

A=rawLFP_PFCx_deep{1};a1=A(:,1);a2=A(:,2);
B=rawLFP_PFCx_deep{2};b1=B(:,1);b2=B(:,2);
C=rawLFP_PFCx_deep{3};c1=C(:,1);c2=C(:,2);
D=rawLFP_PFCx_deep{4};d1=D(:,1);d2=D(:,2);
E=rawLFP_PFCx_deep{5};e1=E(:,1);e2=E(:,2);
rip_PFCx_deep_1=mean([a1,b1,c1,d1,e1],2);
rip_PFCx_deep_2=mean([a2,b2,c2,d2,e2],2);

A=rawLFP_PFCx_sup{1};a1=A(:,1);a2=A(:,2);
B=rawLFP_PFCx_sup{2};b1=B(:,1);b2=B(:,2);
C=rawLFP_PFCx_sup{3};c1=C(:,1);c2=C(:,2);
D=rawLFP_PFCx_sup{4};d1=D(:,1);d2=D(:,2);
E=rawLFP_PFCx_sup{5};e1=E(:,1);e2=E(:,2);
rip_PFCx_sup_1=mean([a1,b1,c1,d1,e1],2);
rip_PFCx_sup_2=mean([a2,b2,c2,d2,e2],2);


figure('color',[1 1 1]),
hold on, subplot(2,1,1)
hold on, plot(rip_dHPC_1,rip_dHPC_2,'k','linewidth',1)
hold on, xlim([-0.05 0.05])
hold on, subplot(2,1,2)
hold on, plot(rip_PFCx_deep_1,rip_PFCx_deep_2,'b','linewidth',1)
hold on, plot(rip_PFCx_sup_1,rip_PFCx_sup_2,'r','linewidth',1)



