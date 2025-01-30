clear all
%% EMG mice
% EMG
m=1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M147';
filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
filename{m,2}=7;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M177';
filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178';
filename{m,2}=18;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M177';
filename{m,2}=9;
m=m+1;
filename{m,1}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-23022014/M178';
filename{m,2}=18;
figure
clear emg gam
load('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/EMGTransitions.mat','EMGthresh')
for mm=1:m
    mm
    cd(filename{mm,1})
    load('StateEpochSB.mat')
    clear MicroWake
    load(['LFPData/LFP',num2Str(filename{mm,2}),'.mat'])
    
    FilLFP=FilterLFP(LFP,[50 300],1024);
    smootime=1;
    EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
    EMGData=Restrict(EMGData,Epoch);
    %     subplot(3,2,mm)
        [Y,X]=hist(log(Data(Restrict(EMGData,Epoch))),1000);
        Y=Y/sum(Y);
        st_ = [1.07e-2 9 0.101 3.49e-3 13 0.21];
        [cf2,goodness2]=createFit2gauss(X,Y,st_);
        a= coeffvalues(cf2);
        b=intersect_gaussians(a(2), a(5), a(3), a(6));
        [~,ind]=max(Y);
        subplot(121)
        plot(X,Y)
    %     hold on
    %     h_ = plot(cf2,'fit',0.95);
    %     set(h_(1),'Color',[1 0 0],...
    %         'LineStyle','-', 'LineWidth',2,...
    %         'Marker','none', 'MarkerSize',6);
    %     line([(EMGthresh{mm}) (EMGthresh{mm})],[0 max(Y)],'linewidth',4,'color','R')
    %     keyboard
    WakeEMG=thresholdIntervals(EMGData,exp(EMGthresh{mm}),'Direction','Above');
    WakeEMG=mergeCloseIntervals(WakeEMG,0.1*1e4);
    WakeEMG=dropShortIntervals(WakeEMG,0.1*1e4);    WakeEMG=CleanUpEpoch(WakeEMG);
    SleepEMG=Epoch-WakeEMG;
    SleepEMG=mergeCloseIntervals(SleepEMG,10*1e4);
    SleepEMG=dropShortIntervals(SleepEMG,4*1e4);    SleepEMG=CleanUpEpoch(SleepEMG);
    
    WakeGamma=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Above');
    WakeGamma=mergeCloseIntervals(WakeGamma,0.1*1e4);
    WakeGamma=dropShortIntervals(WakeGamma,0.1*1e4);    WakeGamma=CleanUpEpoch(WakeGamma);    
    SleepGamma=Epoch-WakeGamma;
    SleepGamma=mergeCloseIntervals(SleepGamma,10*1e4);
    SleepGamma=dropShortIntervals(SleepGamma,4*1e4);    SleepGamma=CleanUpEpoch(SleepGamma);
    GoodSleep=And(SleepGamma,SleepEMG);
    GoodSleep=mergeCloseIntervals(GoodSleep,10*1e4);
    GoodSleep=dropShortIntervals(GoodSleep,4*1e4);
    GoodSleep=CleanUpEpoch(GoodSleep);
    
    MicroWake{1}=SandwichEpoch(WakeEMG,GoodSleep-WakeEMG,10*1e4,15*1e4);
    MicroWake{2}=SandwichEpoch(WakeGamma,GoodSleep-WakeGamma,10*1e4,15*1e4);
%  
%     load('B_High_Spectrum.mat')
%     Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
%     load('H_Low_Spectrum.mat')
%     SptsdH=tsd(Spectro{2}*1e4,Spectro{1});
%     load('H_High_Spectrum.mat')
%     SptsdHH=tsd(Spectro{2}*1e4,Spectro{1});
%     load('PFC_High_Spectrum.mat')
%     SptsdPH=tsd(Spectro{2}*1e4,Spectro{1});
%     load('PFC_Low_Spectrum.mat')
%     SptsdP=tsd(Spectro{2}*1e4,Spectro{1});
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])

    for g=1:2
        dat{mm,g}=[]; datH{mm,g}=[]; sortdat{mm,g}=[];sortdat2{mm,g}=[];RorS{mm,g}=[];datHH{mm,g}=[];datP{mm,g}=[];datPH{mm,g}=[];
        dat{mm,g+2}=[]; datH{mm,g+2}=[]; sortdat{mm,g+2}=[];sortdat2{mm,g+2}=[];RorS{mm,g+2}=[];datHH{mm,g+2}=[];datP{mm,g+2}=[];datPH{mm,g+2}=[];
        dat{mm,g+3}=[]; datH{mm,g+3}=[]; sortdat{mm,g+3}=[];sortdat2{mm,g+3}=[];RorS{mm,g+3}=[];datHH{mm,g+3}=[];datP{mm,g+3}=[];datPH{mm,g+3}=[];

%         dat{mm,g+2}=[dat{mm,g+2},(nanmean(log(Data(Restrict(Sptsd,GoodSleep))'),2))];
%         datH{mm,g+2}=[datH{mm,g+2},(nanmean(log(Data(Restrict(SptsdH,GoodSleep))'),2))];
%         datHH{mm,g+2}=[datHH{mm,g+2},(nanmean(log(Data(Restrict(SptsdHH,GoodSleep))'),2))];
%         datPH{mm,g+2}=[datPH{mm,g+2},(nanmean(log(Data(Restrict(SptsdPH,GoodSleep))'),2))];
%         datP{mm,g+2}=[datP{mm,g+2},(nanmean(log(Data(Restrict(SptsdP,GoodSleep))'),2))];
        
%         dat{mm,g+3}=[dat{mm,g+3},(nanmean(log(Data(Restrict(Sptsd,Wake))'),2))];
%         datH{mm,g+3}=[datH{mm,g+3},(nanmean(log(Data(Restrict(SptsdH,Wake))'),2))];
%         datHH{mm,g+3}=[datHH{mm,g+3},(nanmean(log(Data(Restrict(SptsdHH,Wake))'),2))];
%         datPH{mm,g+3}=[datPH{mm,g+3},(nanmean(log(Data(Restrict(SptsdPH,Wake))'),2))];
%         datP{mm,g+3}=[datP{mm,g+3},(nanmean(log(Data(Restrict(SptsdP,Wake))'),2))];
        
        for k=1:length(Start(MicroWake{g}))
%             temp=log(Data(Restrict(Sptsd,subset(MicroWake{g},k)))');
%             sortdat{mm,g}(k)=mean(mean(temp(13:20,:)));
            sortdat2{mm,g}(k)=mean(Data(Restrict(smooth_ghi,subset(MicroWake{g},k))));
%             dat{mm,g}=[dat{mm,g},(nanmean(log(Data(Restrict(Sptsd,subset(MicroWake{g},k)))'),2))];
%             datH{mm,g}=[datH{mm,g},(nanmean(log(Data(Restrict(SptsdH,subset(MicroWake{g},k)))'),2))];
%             datHH{mm,g}=[datHH{mm,g},(nanmean(log(Data(Restrict(SptsdHH,subset(MicroWake{g},k)))'),2))];
%             datPH{mm,g}=[datPH{mm,g},(nanmean(log(Data(Restrict(SptsdPH,subset(MicroWake{g},k)))'),2))];
%             datP{mm,g}=[datP{mm,g},(nanmean(log(Data(Restrict(SptsdP,subset(MicroWake{g},k)))'),2))];
            
            rlong=length(Data(Restrict(LFP,And(REMEpoch,subset(MicroWake{g},k)))));
            slong=length(Data(Restrict(LFP,And(SWSEpoch,subset(MicroWake{g},k)))));
            if slong>rlong
                RorS{mm,g}=[RorS{mm,g},1];
            elseif rlong>slong
                RorS{mm,g}=[RorS{mm,g},2];
            else
                RorS{mm,g}=[RorS{mm,g},0];
            end
            GammaLong=length(Data(Restrict(LFP,And(WakeGamma,subset(MicroWake{g},k)))));
            EMGLong=length(Data(Restrict(LFP,And(WakeEMG,subset(MicroWake{g},k)))));
            ActLong=length(Data(Restrict(LFP,subset(MicroWake{g},k))));
            if GammaLong>10
                CommGam{mm,g}(k)=1;
            else
                CommGam{mm,g}(k)=0;
            end
            if EMGLong>10
                CommEMG{mm,g}(k)=1;
            else
                CommEMG{mm,g}(k)=0;
            end
            
        end
            Dur{mm,g}=(Stop(MicroWake{g})-Start(MicroWake{g}))/1e4;
    end
    Gam_Thresh{mm}=gamma_thresh;
    MicroWakeEp{mm}=MicroWake;
end

save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/EMGTransitionsV3.mat','EMGthresh','MicroWakeEp',...
   'RorS','Dur','Gam_Thresh','sortdat','sortdat2','CommGam','CommEMG','Out','-v7.3')


%% Distribution of event length
figure
temp1=[]; temp2=[];
for mm=1:m
temp1=[temp1;(Dur{mm,1}(RorS{mm,1}~=2))];
temp2=[temp2;(Dur{mm,2}(RorS{mm,2}~=2))];
end
[Y,X]=hist(temp2,50);
plot(X,Y,'linewidth',3)
hold on
[Y1,X1]=hist(temp1,50);
plot(X1,Y1,'r','linewidth',3)

figure
temp1=[]; temp2=[];
for mm=1:m
temp1=[temp1;(Dur{mm,1}(RorS{mm,1}~=2 & CommGam{mm,1}==0))];
temp2=[temp2;(Dur{mm,1}(RorS{mm,1}~=2 & CommGam{mm,1}==1))];
end
[Y2,X2]=hist(temp2,30);
[Y1,X1]=hist(temp1,30);
plot(X2,Y2/sum(Y2),'linewidth',3), hold on % Common
plot(X1,Y1/sum(Y1),'r','linewidth',3) % Different

%% Triggered amplitude of signal
clear Out
sizedt=25000;
for mm=1:m
    mm
    cd(filename{mm,1})
    clear LFPDat
    load('StateEpochSB.mat','smooth_ghi','SWSEpoch','Wake','Epoch','REMEpoch')
    load(['LFPData/LFP',num2Str(filename{mm,2}),'.mat'])
    FilLFP=FilterLFP(LFP,[50 300],1024);
    smootime=1;
    EMGData=tsd(Range(FilLFP),runmean(Data(( FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
    EMGData=Restrict(EMGData,Epoch);
    
    cd(filename{mm,1})
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    LFPDat{1}=Restrict(LFP,Epoch);
    LFPFil{1}=FilterLFP(LFPDat{1},[0.1 40],1024);
    LFPFilG{1}=FilterLFP(LFPDat{1},[40 80],1024);
    load('PFC_High_Spectrum.mat','ch');
    load(['LFPData/LFP',num2str(ch),'.mat'])
    LFPDat{2}=Restrict(LFP,Epoch);
    LFPFil{2}=FilterLFP(LFPDat{2},[0.1 40],1024);
    LFPFilG{2}=FilterLFP(LFPDat{2},[40 80],1024);

    [aft_cell,bef_cell]=transEpoch(And(SWSEpoch,Epoch),And(Wake,Epoch));
    for k=1:2
        Out{1,1}{k,mm}=TSDTransitions(LFPDat{k},bef_cell{2,1},sizedt); % SWS-->Wake
        Out{2,1}{k,mm}=TSDTransitions(LFPDat{k},bef_cell{1,2},sizedt); % Wake-->SWS
        Out{1,1}{k+2,mm}=TSDTransitions(LFPFil{k},bef_cell{2,1},sizedt); % SWS-->Wake
        Out{2,1}{k+2,mm}=TSDTransitions(LFPFil{k},bef_cell{1,2},sizedt); % Wake-->SWS
        Out{1,1}{k+4,mm}=TSDTransitions(LFPFilG{k},bef_cell{2,1},sizedt); % SWS-->Wake
        Out{2,1}{k+4,mm}=TSDTransitions(LFPFilG{k},bef_cell{1,2},sizedt); % Wake-->SWS
    end
    
    for g=1
        for k=1:2
            Out{3,g}{k,mm}=TSDTransitions(LFPDat{k},And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
            Out{4,g}{k,mm}=TSDTransitions(LFPDat{k},And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
            Out{3,g}{k+2,mm}=TSDTransitions(LFPFil{k},And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
            Out{4,g}{k+2,mm}=TSDTransitions(LFPFil{k},And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
            Out{3,g}{k+4,mm}=TSDTransitions(LFPFilG{k},And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
            Out{4,g}{k+4,mm}=TSDTransitions(LFPFilG{k},And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
        end
    end
%     for g=2
%         for k=1:2
%             Out{3,g}{k,mm}=TSDTransitions(LFPDat{k},And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
%             Out{4,g}{k,mm}=TSDTransitions(LFPDat{k},And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
%             Out{3,g}{k+2,mm}=TSDTransitions(LFPFil{k},And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
%             Out{4,g}{k+2,mm}=TSDTransitions(LFPFil{k},And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
%             Out{3,g}{k+4,mm}=TSDTransitions(LFPFilG{k},And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
%             Out{4,g}{k+4,mm}=TSDTransitions(LFPFilG{k},And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
% 
%         end
%     end
            Out{1,1}{7,mm}=TSDTransitions(smooth_ghi,bef_cell{2,1},sizedt); % SWS-->Wake
            Out{2,1}{7,mm}=TSDTransitions(smooth_ghi,bef_cell{1,2},sizedt); % Wake-->SWS
            Out{1,1}{8,mm}=TSDTransitions(EMGData,bef_cell{2,1},sizedt); % SWS-->Wake
            Out{2,1}{8,mm}=TSDTransitions(EMGData,bef_cell{1,2},sizedt); % Wake-->SWS
for g=1
            Out{3,g}{7,mm}=TSDTransitions(smooth_ghi,And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
            Out{4,g}{7,mm}=TSDTransitions(smooth_ghi,And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
            Out{3,g}{8,mm}=TSDTransitions(EMGData,And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
            Out{4,g}{8,mm}=TSDTransitions(EMGData,And(subset(MicroWakeEp{mm}{g},find(CommGam{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
end
% for g=2
%             Out{3,g}{7,mm}=TSDTransitions(smooth_ghi,And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
%             Out{4,g}{7,mm}=TSDTransitions(smooth_ghi,And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==0) & RorS{mm,g}~=2),Epoch),sizedt); %MicroWake(gammasleep)
%             Out{3,g}{8,mm}=TSDTransitions(EMGData,And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==1 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammawake)
%             Out{4,g}{8,mm}=TSDTransitions(EMGData,And(subset(MicroWakeEp{mm}{g},find(CommEMG{mm,g}==0 & RorS{mm,g}~=2)),Epoch),sizedt); %MicroWake(gammasleep)
% end
end

dt=20;
timeaxis=[-dt:median(diff(Range(smooth_ghi,'s'))):dt-median(diff(Range(smooth_ghi,'s')))];
%% Look at triggered signals
for l=1:8
   figure 
   subplot(221)
%    temp=[];
%    for mm=1:m
%        try
%            temp=[temp;runmean(mean(Out{1,1}{l,mm}.^2,1),500)];
%        end
%    end
%    plot(timeaxis,nanmean(ZScoreWiWindow(temp,[1:10000])),'color','k'), hold on
%    title('Sleep to Wake')
%    
%    subplot(222)
%    temp=[];
%    for mm=1:m
%        try
%            temp=[temp;runmean(mean(Out{2,1}{l,mm}.^2,1),500)];
%        end
%    end
%    plot(timeaxis,nanmean(ZScoreWiWindow(temp,[1:10000])),'color','k'), hold on
%    title('Wake to Sleep')

%    subplot(223)
   temp=[];
   for mm=1:m
       try
           temp=[temp;runmean(mean(Out{3,1}{l,mm}.^2,1),500)];
       end
   end
   plot(timeaxis,nanmean(ZScoreWiWindow(temp,[1:10000])),'color','k'), hold on
   temp=[];
   for mm=1:m
       try
           temp=[temp;runmean(mean(Out{4,1}{l,mm}.^2,1),500)];
       end
   end
   plot(timeaxis,nanmean(ZScoreWiWindow(temp,[1:10000])),'color','r'), hold on
      title('EMG Events')
      legend({'AgreeGamm','Disagree Gamma'})

%    subplot(224)
%    temp=[];
%    for mm=1:m
%        try
%            temp=[temp;runmean(mean(Out{3,2}{l,mm}.^2,1),500)];
%        end
%    end
%    plot(timeaxis,nanmean(ZScoreWiWindow(temp,[1:10000])),'color','k'), hold on
%    temp=[];
%    for mm=1:m
%        try
%            temp=[temp;runmean(mean(Out{4,2}{l,mm}.^2,1),500)];
%        end
%    end
%    plot(timeaxis,nanmean(ZScoreWiWindow(temp,[1:10000])),'color','r'), hold on
%    title('Gamma Events')
%          legend({'Agree EMG','Disagree EMG'})

end

dt=20;
timeaxis=[-dt:median(diff(Range(smooth_ghi,'s'))):dt-median(diff(Range(smooth_ghi,'s')))];
%% Look at triggered signals
for l=1:8
   figure 
   subplot(221)
   temp=[];
   for mm=1:m
       try
           temp=[temp;runmean(mean(Out{1,1}{l,mm}.^2,1),500)];
       end
   end
   plot(timeaxis,nanmean(temp),'color','k','linewidth',2), hold on
   title('Sleep to Wake')
   
   subplot(222)
   temp=[];
   for mm=1:m
       try
           temp=[temp;runmean(mean(Out{2,1}{l,mm}.^2,1),500)];
       end
   end
   plot(timeaxis,nanmean(temp),'color','k','linewidth',2), hold on
   title('Wake to Sleep')

   subplot(223)
   temp=[];
   for mm=1:m
       try
           temp=[temp;runmean(mean(Out{3,1}{l,mm}.^2,1),500)];
       end
   end
   plot(timeaxis,nanmean(temp),'color','k','linewidth',2), hold on
   temp=[];
   for mm=1:m
       try
           temp=[temp;runmean(mean(Out{4,1}{l,mm}.^2,1),500)];
       end
   end
   plot(timeaxis,nanmean(temp),'color','r','linewidth',2), hold on
      title('EMG Events')
      legend({'AgreeGamm','Disagree Gamma'})

   subplot(224)
   temp=[];
   for mm=1:m
       try
           temp=[temp;runmean(mean(Out{3,2}{l,mm}.^2,1),500)];
       end
   end
   plot(timeaxis,nanmean(temp),'color','k','linewidth',2), hold on
   temp=[];
   for mm=1:m
       try
           temp=[temp;runmean(mean(Out{4,2}{l,mm}.^2,1),500)];
       end
   end
   plot(timeaxis,nanmean(temp),'color','r','linewidth',2), hold on
   title('Gamma Events')
         legend({'Agree EMG','Disagree EMG'})

end

%% Ripples
figure
tempS=[];
tempW=[];
for mm=1:m
    cd(filename{mm,1})
    load('RipplesDat2.mat')
        if length(Start(subset(MicroWakeEp{mm}{1},CommGam{mm,1}==1)))>0
    [C, BS] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEp{mm}{1},CommGam{mm,1}==1)), 1000, 40);
        end
    tempS=[tempS,C];
    % plot(BS/1E3,C,'b'), hold on
    if length(Start(subset(MicroWakeEp{mm}{1},CommGam{mm,1}==0)))>0
        [C, BW] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEp{mm}{1},CommGam{mm,1}==0)), 1000, 40);
    end
    %  plot(BW/1E3,C,'k'), hold on
    tempW=[tempW,C];
end
subplot(211)
plot(BW/1E3,mean(tempW'),'b','linewidth',2)
hold on
plot(BS/1E3,mean(tempS'),'r','linewidth',2)
tempS=[];
tempW=[];
title('EMG Events')
legend({'AgreeGamm','Disagree Gamma'})
for mm=1:m
    cd(filename{mm,1})
    load('RipplesDat2.mat')
    if length(Start(subset(MicroWakeEp{mm}{2},CommEMG{mm,2}==1)))>0
        [C, BS] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEp{mm}{2},CommEMG{mm,2}==1)), 1000, 40);
    end
    tempS=[tempS,C];
    %plot(BS/1E3,C,'b'), hold on
    if length(Start(subset(MicroWakeEp{mm}{2},CommEMG{mm,2}==0)))>0
        [C, BW] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEp{mm}{2},CommEMG{mm,2}==0)), 1000, 40);
    end
    % plot(BW/1E3,C,'k'), hold on
    tempW=[tempW,C];
end
subplot(212)
plot(BW/1E3,mean(tempW'),'b','linewidth',2)
hold on
plot(BS/1E3,mean(tempS'),'r','linewidth',2)
title('Gamma Events')
legend({'Agree EMG','Disagree EMG'})

%% Triggered amplitude of signal
% sizedt=25000;
% for mm=1:m
%     mm
%         cd(filename{mm,1})
%     clear LFPDat
%     load('StateEpochSB.mat','smooth_ghi','SWSEpoch','Wake','Epoch')
%     load(['LFPData/LFP',num2Str(filename{mm,2}),'.mat'])  
%     FilLFP=FilterLFP(LFP,[50 300],1024);
%     smootime=1;
%     EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
%     EMGData=Restrict(EMGData,Epoch);
% 
%     cd(filename{mm,1})
%     load('ChannelsToAnalyse/dHPC_rip.mat')
%     load(['LFPData/LFP',num2str(channel),'.mat'])
%     LFPDat{1}=Restrict(LFP,Epoch);
%     load('PFC_High_Spectrum.mat','ch');
%     load(['LFPData/LFP',num2str(ch),'.mat'])
%     LFPDat{2}=Restrict(LFP,Epoch);
%     load('B_High_Spectrum.mat','ch');
%     load(['LFPData/LFP',num2str(ch),'.mat'])
%     LFPDat{3}=Restrict(LFP,Epoch);
%     
%     [aft_cell,bef_cell]=transEpoch(And(SWSEpoch,Epoch),And(Wake,Epoch));
%     for g=1:4
%         for k=1:3
%             Out{1,g}{k,mm}=TSDTransitions(LFPDat{k},bef_cell{2,1},sizedt); % SWS-->Wake
%             Out{2,g}{k,mm}=TSDTransitions(LFPDat{k},bef_cell{1,2},sizedt); % Wake-->SWS
%             Out{3,g}{k,mm}=TSDTransitions(LFPDat{k},And(subset(MicroWakeEp{mm}{g},find(RorS{mm,g}==1)),Epoch),sizedt); %MicroWake(gammasleep)
%             Out{4,g}{k,mm}=TSDTransitions(LFPDat{k},And(subset(MicroWakeEp{mm}{g},find(RorS{mm,g}==0)),Epoch),sizedt); %MicroWake(gammawake)
%         end
%         Out{1,g}{4,mm}=TSDTransitions(smooth_ghi,bef_cell{2,1},sizedt); % SWS-->Wake
%         Out{2,g}{4,mm}=TSDTransitions(smooth_ghi,bef_cell{1,2},sizedt); % Wake-->SWS
%         Out{3,g}{4,mm}=TSDTransitions(smooth_ghi,And(subset(MicroWakeEp{mm}{g},find(RorS{mm,g}==1)),Epoch),sizedt); %MicroWake(gammasleep)
%         Out{4,g}{4,mm}=TSDTransitions(smooth_ghi,And(subset(MicroWakeEp{mm}{g},find(RorS{mm,g}==0)),Epoch),sizedt); %MicroWake(gammawake)
%         Out{1,g}{5,mm}=TSDTransitions(EMGData,bef_cell{2,1},sizedt); % SWS-->Wake
%         Out{2,g}{5,mm}=TSDTransitions(EMGData,bef_cell{1,2},sizedt); % Wake-->SWS
%         Out{3,g}{5,mm}=TSDTransitions(EMGData,And(subset(MicroWakeEp{mm}{g},find(RorS{mm,g}==1)),Epoch),sizedt); %MicroWake(gammasleep)
%         Out{4,g}{5,mm}=TSDTransitions(EMGData,And(subset(MicroWakeEp{mm}{g},find(RorS{mm,g}==0)),Epoch),sizedt); %MicroWake(gammawake)
%     end
% end
% 
SubTit={'SWS-->Wake','Wake-->SWS','MicroWake(gammasleep)','MicroWake(gammawake)'};
dt=20;
timeaxis=[-dt:median(diff(Range(smooth_ghi,'s'))):dt-median(diff(Range(smooth_ghi,'s')))];
for g=1:4
for kk=1:5
   figure
   for k=1:4
   subplot(2,2,k)
   temp=[];
   for mm=1:m
       try
       temp=[temp;runmean(mean(Out{k,g}{kk,mm}.^2,1),100)];
       end
   end
   plot(timeaxis,mean(temp)), hold on
   title([SubTit{k},num2str(g)])
   end
end
end


%% Superpose Microwakes HPC signal
cols=[1,0,0;0,1,0;0,0,1;1,0,1];
figure
for g=1:4
    kk=1; % HPC
    k=4; % MicroWake : Sleep for OB
    
    temp=[];
    for mm=1:m
        try
            temp=[temp;runmean(mean(Out{k,g}{kk,mm}.^2,1),500)];
            %/std(runmean(mean(Out{k,g}{kk,mm}.^2,1),500))
        end
    end
    plot(timeaxis,mean(zscore(temp')'),'color',cols(g,:)), hold on
end


%% Ripples relation to microWake

for mm=1:m
    close all
    cd(filename{mm,1})
    load('StateEpochSB.mat','Epoch')
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    [Rip,usedEpoch]=FindRipplesKarimSB(LFP,Epoch);
    [M,T]=PlotRipRaw(LFP,Rip,50,0);
    saveas(gcf,'RipplesPlot2.png')
    saveas(gcf,'RipplesPlot2.fig')
    save('RipplesDat2.mat','Rip','usedEpoch')
end


clf
tempS=[];
tempW=[];
for mm=1:m
    cd(filename{mm,1})
    load('RipplesDat2.mat')
    [C, BS] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEMGEp{mm},RorS{mm}==1)), 1000, 40);
    tempS=[tempS,C];
    plot(BS/1E3,C,'b'), hold on
    [C, BW] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEMGEp{mm},RorS{mm}==0)), 1000, 40);
    plot(BW/1E3,C,'k'), hold on
    tempW=[tempW,C];
end

figure
plot(BW/1E3,mean(tempW'),'k')
hold on
plot(BS/1E3,mean(tempS'),'b')

