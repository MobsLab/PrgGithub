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

    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])

    for g=1:2
        dat{mm,g}=[]; datH{mm,g}=[]; sortdat{mm,g}=[];sortdat2{mm,g}=[];RorS{mm,g}=[];datHH{mm,g}=[];datP{mm,g}=[];datPH{mm,g}=[];
        dat{mm,g+2}=[]; datH{mm,g+2}=[]; sortdat{mm,g+2}=[];sortdat2{mm,g+2}=[];RorS{mm,g+2}=[];datHH{mm,g+2}=[];datP{mm,g+2}=[];datPH{mm,g+2}=[];
        dat{mm,g+3}=[]; datH{mm,g+3}=[]; sortdat{mm,g+3}=[];sortdat2{mm,g+3}=[];RorS{mm,g+3}=[];datHH{mm,g+3}=[];datP{mm,g+3}=[];datPH{mm,g+3}=[];

        
        for k=1:length(Start(MicroWake{g}))
            sortdat2{mm,g}(k)=mean(Data(Restrict(smooth_ghi,subset(MicroWake{g},k))));
            
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
load('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/EMGTransitionsV3.mat')
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

figure
temp1=[]; temp2=[]; temp3=[]; temp4=[];
for mm=1:m
temp1=[temp1;(Dur{mm,1}(RorS{mm,1}~=2 & CommGam{mm,1}==1))];
temp2=[temp2;(Dur{mm,1}(RorS{mm,1}~=2 & CommGam{mm,1}==0))];
temp3=[temp3;(Dur{mm,2}(RorS{mm,2}~=2 & CommEMG{mm,2}==1))];
temp4=[temp4;(Dur{mm,2}(RorS{mm,2}~=2 & CommEMG{mm,2}==0))];
end
temp1=length(temp1);temp2=length(temp2);
temp3=length(temp3);temp4=length(temp4);
bar([1:2],[temp1/(temp1+temp2),temp2/(temp1+temp2);temp3/(temp3+temp4),temp4/(temp3+temp4)],'Stack')
set(gcf,'colormap',[[0 0 1];[1 0 0]])
ylim([0 1.05]), xlim([0.5 1.5])
set(gca,'XTick',[1,2],'XTickLabel',{'EMG','GammaOB'})

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

end

dt=20;
timeaxis=[-dt:median(diff(Range(smooth_ghi,'s'))):dt-median(diff(Range(smooth_ghi,'s')))];
PlotTypes={'HPC','PFCx','HPCLow','PFCxLow','HPCGamma','PFCxGamma','OBGamma','EMGPower'}
%% Look at triggered signals

figure
subplot(121)
line([-20 20],[0 0],'color','k','linewidth',2)
hold on
temp=[];
l=8;
for mm=[1,2,5]
    try
        A=(mean(Out{3,1}{l,mm},1)); % Common
        temp=[temp;log(A)-(EMGthresh{mm})];
    end
end
%plot(timeaxis,nanmean(temp),'color','b','linewidth',3), hold on % same
g=shadedErrorBar(timeaxis,nanmean(temp),[stdError(temp);stdError(temp)],'b'), hold on % same

temp=[];
for mm=[1,2,5]
    try
        A=(mean(Out{4,1}{l,mm},1));
        temp=[temp;log(A)-(EMGthresh{mm})];
        
    end
end
g=shadedErrorBar(timeaxis,nanmean(temp),[stdError(temp);stdError(temp)],'r') % different

l=7
subplot(122)
line([-20 20],[0 0],'color','k','linewidth',2)
hold on
temp=[];
for mm=[1,2,5]
    try
        A=(mean(Out{3,1}{l,mm},1));
        temp=[temp;log(A)-log(Gam_Thresh{mm})];
    end
end
g=shadedErrorBar(timeaxis,nanmean(temp),[stdError(temp);stdError(temp)],'b'), hold on % same
temp=[];
for mm=[1,2,5]
    try
        A=(mean(Out{4,1}{l,mm},1));
        temp=[temp;log(A)-log(Gam_Thresh{mm})];
        
    end
end
g=shadedErrorBar(timeaxis,nanmean(temp),[stdError(temp);stdError(temp)],'r') % different
legend({'AgreeGamm','Disagree Gamma'})
ylabel('Mean')

% Transitions
figure
subplot(121)
temp=[];
temp2=[];
for mm=[1,2,5]
    % SWS--> Wake
    A=runmean(mean(Out{1,1}{7,mm},1),500);
    temp=[temp;zscore(A)];
    A=runmean(mean(Out{1,1}{8,mm},1),500);
    temp2=[temp2;zscore(A)];
end
line([0 0],[-1.5 3],'color','k','linewidth',2)
hold on
g=shadedErrorBar(timeaxis,nanmean(temp),[stdError(temp);stdError(temp)],'b') % different
g=shadedErrorBar(timeaxis,nanmean(temp2),[stdError(temp2);stdError(temp2)],'k') % different
subplot(122)
temp=[];
temp2=[];
for mm=[1,2,5]
    % SWS--> Wake
    A=runmean(mean(Out{2,1}{7,mm},1),500);
    temp=[temp;zscore(A)];
    A=runmean(mean(Out{2,1}{8,mm},1),500);
    temp2=[temp2;zscore(A)];
end
line([0 0],[-1.5 3],'color','k','linewidth',2)
hold on
g=shadedErrorBar(timeaxis,nanmean(temp),[stdError(temp);stdError(temp)],'b') % different
g=shadedErrorBar(timeaxis,nanmean(temp2),[stdError(temp2);stdError(temp2)],'k') % different



%% Ripples
figure
%%removing sessions with too few of one kind of transition
tempS=[];
tempW=[];
for mm=[1,2,5]
    cd(filename{mm,1})
    load('RipplesDat2.mat')
        if length(Start(subset(MicroWakeEp{mm}{1},RorS{mm,1}~=2 & CommGam{mm,1}==1)))>0
    [C, BS] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEp{mm}{1},RorS{mm,1}~=2 & CommGam{mm,1}==1)), 1000, 40);
        end
            tempS=[tempS,C];
end
for mm=1:m
    cd(filename{mm,1})
    load('RipplesDat2.mat')

    if length(Start(subset(MicroWakeEp{mm}{1},RorS{mm,1}~=2 & CommGam{mm,1}==0)))>0
        [C, BW] = CrossCorr(Rip(:,3)*1e4, Start(subset(MicroWakeEp{mm}{1},RorS{mm,1}~=2 & CommGam{mm,1}==0)), 1000, 40);
    end
    tempW=[tempW,C];
end
subplot(211)
errorbar(BW/1E3,nanmean(tempW'),stdError(tempW'),'r','linewidth',2)% different
hold on
errorbar(BS/1E3,nanmean(tempS'),stdError(tempS'),'b','linewidth',2)% same
title('EMG Events')
legend({'AgreeGamm','Disagree Gamma'})


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

