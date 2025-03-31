a=0;
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243'; % Mouse 243 - Day 3
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';            % Mouse 243 - Day 5

a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244'; % Mouse 244 - Day 2
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';            % Mouse 244 - Day 5

a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251'; % Mouse 251 - Day 1
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse251'; % Mouse 251 - Day 2
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150520/Breath-Mouse-251-252-20052015/Mouse251'; % Mouse 251 - Day 3
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150521/Breath-Mouse-251-252-21052015/Mouse251'; % Mouse 251 - Day 4
a=a+1; Dir.pathBasal{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150522/Breath-Mouse-251-252-22052015/Mouse251'; % Mouse 251 - Day 5

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
        
    load newDeltaMoCx
    tDeltaMoCx=ts(tDelta(:,1));
    load newDeltaPaCx
    tDeltaPaCx=ts(tDelta(:,1));
    load newDeltaPFCx
    tDeltaPFCx=ts(tDelta(:,1));
    load RipplesdHPC25
    rip=ts(dHPCrip(:,2)*1E4);
    
   
% >>> generate cross correlogram between SPW-Rs and cortical Delta Waves: 
    for i=1:5
        [CripPF(i,:),BripPF]=CrossCorr(Range(Restrict(tDeltaPFCx,and(EpochToAnalyse{i},SWSEpoch))),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
        [CripPa(i,:),BripPa]=CrossCorr(Range(Restrict(tDeltaPaCx,and(EpochToAnalyse{i},SWSEpoch))),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
        [CripMo(i,:),BripMo]=CrossCorr(Range(Restrict(tDeltaMoCx,and(EpochToAnalyse{i},SWSEpoch))),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
    end
    CripPFCx{a}=CripPF; BripPFCx{a}=BripPF;
    CripPaCx{a}=CripPa; BripPaCx{a}=BripPa;
    CripMoCx{a}=CripMo; BripMoCx{a}=BripMo;

% >>> generate cross correlogram between Delta Waves across Strutures: 
    for i=1:5
        [CdModPF(i,:),BdModPF]=CrossCorr(Range(Restrict(tDeltaPFCx,EpochToAnalyse{i})),Range(Restrict(tDeltaMoCx,EpochToAnalyse{i})),binS,nbin);
        [CdPadPF(i,:),BdPadPF]=CrossCorr(Range(Restrict(tDeltaPFCx,EpochToAnalyse{i})),Range(Restrict(tDeltaPaCx,EpochToAnalyse{i})),binS,nbin);
        [CdModPa(i,:),BdModPa]=CrossCorr(Range(Restrict(tDeltaPaCx,EpochToAnalyse{i})),Range(Restrict(tDeltaMoCx,EpochToAnalyse{i})),binS,nbin);
    end
    CdMoCxdPFCx{a}=CdModPF; BdMoCxdPFCx{a}=BdModPF;
    CdPaCxdPFCx{a}=CdPadPF; BdPaCxdPFCx{a}=BdPadPF;
    CdMoCxdPaCx{a}=CdModPa; BdMoCxdPaCx{a}=BdModPa;
    
end


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

for a=1:length(Dir.pathBasal)
    cd(Dir.pathBasal{a})
    res=pwd;
    load EpochToAnalyse
    load StateEpochSB
        
    load newDeltaMoCx
    tDeltaMoCx=ts(tDelta(:,1));
    load newDeltaPaCx
    tDeltaPaCx=ts(tDelta(:,1));
    load newDeltaPFCx
    tDeltaPFCx=ts(tDelta(:,1));
    load RipplesdHPC25
    rip=ts(dHPCrip(:,2)*1E4);
    
% >>> Define burst period for each cortical structure:
    limBurst=0.6;
    [BurstDeltaEpochPFCx,NbDBuPFCx]=FindDeltaBurst2(tDeltaPFCx,limBurst,1);
    [BEDeltaPFCxBurst,tDeltaPFCxBurst]=Restrict(tDeltaPFCx,BurstDeltaEpochPFCx);
    [BEDeltaPFCxNoBurst,tDeltaPFCxNoBurst]=Restrict(tDeltaPFCx,SWSEpoch-BurstDeltaEpochPFCx);
    
    [BurstDeltaEpochPaCx,NbDBuPaCx]=FindDeltaBurst2(tDeltaPaCx,limBurst,1);
    [BEDeltaPaCxBurst,tDeltaPaCxBurst]=Restrict(tDeltaPaCx,BurstDeltaEpochPaCx);
    [BEDeltaPaCxNoBurst,tDeltaPaCxNoBurst]=Restrict(tDeltaPaCx,SWSEpoch-BurstDeltaEpochPaCx);
    
    [BurstDeltaEpochMoCx,NbDBuMoCx]=FindDeltaBurst2(tDeltaMoCx,limBurst,1);
    [BEDeltaMoCxBurst,tDeltaMoCxBurst]=Restrict(tDeltaMoCx,BurstDeltaEpochMoCx);
    [BEDeltaMoCxNoBurst,tDeltaMoCxNoBurst]=Restrict(tDeltaMoCx,SWSEpoch-BurstDeltaEpochMoCx);
    
% >>> generate cross correlogram between SPW-Rs and cortical Delta Waves (w/without BURST): 
    for i=1:5
        % SPW-Rs versus PFCx delta
        [CripPFBurst(i,:),BripPFB]=CrossCorr(Range(Restrict(ts(tDeltaPFCxBurst),EpochToAnalyse{i})),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
        [CripPFNoBurst(i,:),BripPFNoB]=CrossCorr(Range(Restrict(ts(tDeltaPFCxNoBurst),EpochToAnalyse{i})),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
        % SPW-Rs versus PaCx delta
        [CripPaBurst(i,:),BripPaB]=CrossCorr(Range(Restrict(ts(tDeltaPaCxBurst),EpochToAnalyse{i})),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
        [CripPaNoBurst(i,:),BripPaNoB]=CrossCorr(Range(Restrict(ts(tDeltaPaCxNoBurst),EpochToAnalyse{i})),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
        % SPW-Rs versus MoCx delta
        [CripMoBurst(i,:),BripMoB]=CrossCorr(Range(Restrict(ts(tDeltaMoCxBurst),EpochToAnalyse{i})),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
        [CripMoNoBurst(i,:),BripMoNoB]=CrossCorr(Range(Restrict(ts(tDeltaMoCxNoBurst),EpochToAnalyse{i})),Range(Restrict(rip,EpochToAnalyse{i})),binS,nbin);
    end
    CripPFCxBurst{a}=CripPFBurst; BripPFCxBurst{a}=BripPFB;
    CripPFCxNoBurst{a}=CripPFNoBurst; BripPFCxNoBurst{a}=BripPFNoB;
    CripPaCxBurst{a}=CripPaBurst; BripPaCxBurst{a}=BripPaB;
    CripPaCxNoBurst{a}=CripPaNoBurst; BripPaCxNoBurst{a}=BripPaNoB;
    CripMoCxBurst{a}=CripMoBurst; BripMoCxBurst{a}=BripMoB;
    CripMoCxNoBurst{a}=CripMoNoBurst; BripMoCxNoBurst{a}=BripMoNoB;
    
        
% >>> generate cross correlogram between Delta Waves across Strutures (w/without BURST): 
    for i=1:5
        % delta MoCx versus PFCx delta (PFCx Burst)
        [CdModPFBurst(i,:),BdModPFBurst]=CrossCorr(Range(Restrict(ts(tDeltaPFCxBurst),EpochToAnalyse{i})),Range(Restrict(tDeltaMoCx,EpochToAnalyse{i})),binS,nbin);
        [CdModPFNoBurst(i,:),BdModPFNoBurst]=CrossCorr(Range(Restrict(ts(tDeltaPFCxNoBurst),EpochToAnalyse{i})),Range(Restrict(tDeltaMoCx,EpochToAnalyse{i})),binS,nbin);
        % delta PaCx versus PFCx delta (PFCx Burst)
        [CdPadPFBurst(i,:),BdPadPFBurst]=CrossCorr(Range(Restrict(ts(tDeltaPFCxBurst),EpochToAnalyse{i})),Range(Restrict(tDeltaPaCx,EpochToAnalyse{i})),binS,nbin);
        [CdPadPFNoBurst(i,:),BdPadPFNoBurst]=CrossCorr(Range(Restrict(ts(tDeltaPFCxNoBurst),EpochToAnalyse{i})),Range(Restrict(tDeltaPaCx,EpochToAnalyse{i})),binS,nbin);
        % delta MoCx versus PaCx delta (PaCx Burst)
        [CdModPaBurst(i,:),BdModPaBurst]=CrossCorr(Range(Restrict(ts(tDeltaPaCxBurst),EpochToAnalyse{i})),Range(Restrict(tDeltaMoCx,EpochToAnalyse{i})),binS,nbin);
        [CdModPaNoBurst(i,:),BdModPaNoBurst]=CrossCorr(Range(Restrict(ts(tDeltaPaCxNoBurst),EpochToAnalyse{i})),Range(Restrict(tDeltaMoCx,EpochToAnalyse{i})),binS,nbin);
    end
    CdMoCxdPFCxBurst{a}=CdModPFBurst; BdMoCxdPFCxBurst{a}=BdModPFBurst;
    CdMoCxdPFCxNoBurst{a}=CdModPFNoBurst; BdMoCxdPFCxNoBurst{a}=BdModPFNoBurst;
    CdPaCxdPFCxBurst{a}=CdPadPFNoBurst; BdPaCxdPFCxBurst{a}=BdPadPFBurst;
    CdMoCxdPFCxNoBurst{a}=CdModPFNoBurst; BdMoCxdPFCxNoBurst{a}=BdPadPFNoBurst;
    CdMoCxdPaCxBurst{a}=CdModPaBurst; BdMoCxdPaCxBurst{a}=BdModPaBurst;
    CdMoCxdPFCxNoBurst{a}=CdModPFNoBurst; BdMoCxdPFCxNoBurst{a}=BdModPFNoBurst;
end


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

Mouse243=[1 2];
Mouse244=[3 4];
Mouse251=[5 6 7 8 9];
Mouse252=[10 11 12 13 14];

colorC{1}='r';
colorC{2}='m';
colorC{3}=[0.5 0.5 0.5];
colorC{4}='b';
colorC{5}='c';

smo=1;

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% Plott Cross-correlogram Ripples vs Delta (all structure)
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
BforAll=BripPFCx{Mouse243};
C243=CripPFCx{Mouse243}; CripPFCxM243=mean(C243,3); CripPFCxM243AllDay=mean(C243,1);
C244=CripPFCx{Mouse244}; CripPFCxM244=mean(C244,3); CripPFCxM244AllDay=mean(C244,1);
C251=CripPFCx{Mouse251}; CripPFCxM251=mean(C251,3); CripPFCxM251AllDay=mean(C251,1);
C252=CripPFCx{Mouse252}; CripPFCxM252=mean(C252,3); CripPFCxM252AllDay=mean(C252,1);

C243=CripPaCx{Mouse243}; CripPaCxM243=mean(C243,3); CripPaCxM243AllDay=mean(C243,1);
C244=CripPaCx{Mouse244}; CripPaCxM244=mean(C244,3); CripPaCxM244AllDay=mean(C244,1);
C251=CripPaCx{Mouse251}; CripPaCxM251=mean(C251,3); CripPaCxM251AllDay=mean(C251,1);
C252=CripPaCx{Mouse252}; CripPaCxM252=mean(C252,3); CripPaCxM252AllDay=mean(C252,1);

C243=CripMoCx{Mouse243}; CripMoCxM243=mean(C243,3); CripMoCxM243AllDay=mean(C243,1);
C244=CripMoCx{Mouse244}; CripMoCxM244=mean(C244,3); CripMoCxM244AllDay=mean(C244,1);
C251=CripMoCx{Mouse251}; CripMoCxM251=mean(C251,3); CripMoCxM251AllDay=mean(C251,1);
C252=CripMoCx{Mouse252}; CripMoCxM252=mean(C252,3); CripMoCxM252AllDay=mean(C252,1);


yl=[0 1];

figure('color',[1 1 1]),
hold on, subplot(3,4,1)
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(1,:),smo),'color',colorC{1}),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(2,:),smo),'color',colorC{2}),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(3,:),smo),'color',colorC{3}),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(4,:),smo),'color',colorC{4}),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PFCx delta - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,2)
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM244AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM244(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(4,:),smo),'color',colorC{4}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PFCx delta - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,3)
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(4,:),smo),'color',colorC{4}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PFCx delta - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,4)
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(1,:),smo),'color',colorC{1}),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(2,:),smo),'color',colorC{2}),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(3,:),smo),'color',colorC{3}),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(4,:),smo),'color',colorC{4}),
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PFCx delta - Mouse 252')
hold on, xlim([-1 1])

hold on, subplot(3,4,5)
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(1,:),smo),'color',colorC{1}),
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(2,:),smo),'color',colorC{2}),
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(3,:),smo),'color',colorC{3}),
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(4,:),smo),'color',colorC{4}),
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(5,:),smo),'color',colorC{5}),  
hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PaCx delta - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,6)
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(4,:),smo),'color',colorC{4}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PaCx delta - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,7)
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(4,:),smo),'color',colorC{4}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PaCx delta - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,8)
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(4,:),smo),'color',colorC{4}),  
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PaCx delta - Mouse 252')
hold on, xlim([-1 1])

hold on, subplot(3,4,9)
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(4,:),smo),'color',colorC{4}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus MoCx delta - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,10)
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(4,:),smo),'color',colorC{4}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus MoCx delta - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,11)
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(4,:),smo),'color',colorC{4}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus MoCx delta - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,12)
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252AllDay,smo),'linewidth',3,'color','k'),
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(1,:),smo),'color',colorC{1}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(2,:),smo),'color',colorC{2}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(3,:),smo),'color',colorC{3}),  
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(4,:),smo),'color',colorC{4}), 
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(5,:),smo),'color',colorC{5}),  
hold on, line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus MoCx delta - Mouse 252')
hold on, xlim([-1 1])




% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% Plott Cross-correlogram Delta vs Delta (all structure)
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
BforAll=BdMoCxdPFCx{Mouse243};
C243=CdMoCxdPFCx{Mouse243}; CdMoCxPFCxM243=mean(C243,3);
C244=CdMoCxdPFCx{Mouse244}; CdMoCxPFCxM244=mean(C244,3);
C251=CdMoCxdPFCx{Mouse251}; CdMoCxPFCxM251=mean(C251,3);
C252=CdMoCxdPFCx{Mouse252}; CdMoCxPFCxM252=mean(C252,3);

C243=CdPaCxdPFCx{Mouse243}; CdPaCxdPFCxM243=mean(C243,3);
C244=CdPaCxdPFCx{Mouse244}; CdPaCxdPFCxM244=mean(C244,3);
C251=CdPaCxdPFCx{Mouse251}; CdPaCxdPFCxM251=mean(C251,3);
C252=CdPaCxdPFCx{Mouse252}; CdPaCxdPFCxM252=mean(C252,3);

C243=CdMoCxdPaCx{Mouse243}; CdMoCxdPaCxM243=mean(C243,3);
C244=CdMoCxdPaCx{Mouse244}; CdMoCxdPaCxM244=mean(C244,3);
C251=CdMoCxdPaCx{Mouse251}; CdMoCxdPaCxM251=mean(C251,3);
C252=CdMoCxdPaCx{Mouse252}; CdMoCxdPaCxM252=mean(C252,3);

yl1=[0 9];
yl2=[0 5];
figure, subplot(3,1,1)
hold on, subplot(3,4,1)
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM243(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM243(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM243(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM243(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM243(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl1,'color','k')
hold on, title('delta MoCx versus delta PFCx - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,2)
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM244(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM244(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM244(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM244(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM244(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl1,'color','k')
hold on, title('delta MoCx versus delta PFCx - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,3)
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM251(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM251(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM251(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM251(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM251(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl,'color','k')
hold on, title('delta MoCx versus delta PFCx - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,4)
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM252(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM252(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM252(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM252(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxPFCxM252(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl1,'color','k')
hold on, title('delta MoCx versus delta PFCx - Mouse 252')
hold on, xlim([-1 1])

hold on, subplot(3,4,5)
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM243(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM243(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM243(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM243(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM243(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl1,'color','k')
hold on, title('delta PaCx versus delta PFCx - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,6)
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM244(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM244(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM244(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM244(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM244(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl1,'color','k')
hold on, title('delta PaCx versus delta PFCx - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,7)
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM251(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM251(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM251(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM251(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM251(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl1,'color','k')
hold on, title('delta PaCx versus delta PFCx - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,8)
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM252(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM252(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM252(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM252(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl1,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdPaCxdPFCxM252(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl1,'color','k')
hold on, title('delta PaCx versus delta PFCx - Mouse 252')
hold on, xlim([-1 1])

hold on, subplot(3,4,9)
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM243(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM243(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM243(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM243(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM243(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl2,'color','k')
hold on, title('delta MoCx versus delta PaCx - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,10)
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM244(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM244(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM244(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM244(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM244(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl2,'color','k')
hold on, title('delta MoCx versus delta PaCx - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,11)
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM251(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM251(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM251(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM251(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM251(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl2,'color','k')
hold on, title('delta MoCx versus delta PaCx - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,12)
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM252(1,:),smo),'color',colorC{1}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM252(2,:),smo),'color',colorC{2}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM252(3,:),smo),'color',colorC{3}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM252(4,:),smo),'color',colorC{4}), hold on,line([0 0],yl2,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CdMoCxdPaCxM252(5,:),smo),'color',colorC{5}), hold on,line([0 0],yl2,'color','k')
hold on, title('delta MoCx versus delta PaCx - Mouse 252')
hold on, xlim([-1 1])


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% Plott Cross-correlogram Ripples vs Delta (all structure) BURST
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
BforAll=BripPFCxBurst{Mouse243};
C243=CripPFCxBurst{Mouse243}; CripPFCxM243=mean(C243,3);
C244=CripPFCxBurst{Mouse244}; CripPFCxM244=mean(C244,3);
C251=CripPFCxBurst{Mouse251}; CripPFCxM251=mean(C251,3);
C252=CripPFCxBurst{Mouse252}; CripPFCxM252=mean(C252,3);

C243=CripPaCxBurst{Mouse243}; CripPaCxM243=mean(C243,3);
C244=CripPaCxBurst{Mouse244}; CripPaCxM244=mean(C244,3);
C251=CripPaCxBurst{Mouse251}; CripPaCxM251=mean(C251,3);
C252=CripPaCxBurst{Mouse252}; CripPaCxM252=mean(C252,3);

C243=CripMoCxBurst{Mouse243}; CripMoCxM243=mean(C243,3);
C244=CripMoCxBurst{Mouse244}; CripMoCxM244=mean(C244,3);
C251=CripMoCxBurst{Mouse251}; CripMoCxM251=mean(C251,3);
C252=CripMoCxBurst{Mouse252}; CripMoCxM252=mean(C252,3);

figure('color',[1 1 1]),
hold on, subplot(3,4,1)
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM243(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PFCx delta - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,2)
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM244(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PFCx delta - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,3)
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM251(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PFCx delta - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,4)
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPFCxM252(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PFCx delta - Mouse 252')
hold on, xlim([-1 1])

hold on, subplot(3,4,5)
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM243(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PaCx delta - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,6)
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM244(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PaCx delta - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,7)
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM251(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PaCx delta - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,8)
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripPaCxM252(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus PaCx delta - Mouse 252')
hold on, xlim([-1 1])

hold on, subplot(3,4,9)
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM243(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus MoCx delta - Mouse 243')
hold on, xlim([-1 1])
hold on, subplot(3,4,10)
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM244(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus MoCx delta - Mouse 244')
hold on, xlim([-1 1])
hold on, subplot(3,4,11)
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM251(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus MoCx delta - Mouse 251')
hold on, xlim([-1 1])
hold on, subplot(3,4,12)
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(1,:),smo),'color',colorC{1}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(2,:),smo),'color',colorC{2}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(3,:),smo),'color',colorC{3}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(4,:),smo),'color',colorC{4}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, plot(BforAll/1E3,SmoothDec(CripMoCxM252(5,:),smo),'color',colorC{5}), yl=[0 1]; hold on,line([0 0],yl,'color','k')
hold on, title('SPW-Rs versus MoCx delta - Mouse 252')
hold on, xlim([-1 1])
