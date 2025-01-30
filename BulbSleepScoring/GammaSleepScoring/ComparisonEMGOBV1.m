%% This code compares results from EMG and OB gamma sleep scoring

%Get list of mice to use
EMGmice;



%% Print out the EMG and OB time courses
for mm=3:4
    cd (filename{mm,1})
    load('StateEpochSB.mat','smooth_ghi','SWSEpoch','REMEpoch','Wake')
    TotEpoch=intervalSet(0,max(Range(smooth_ghi)));
    SWSEpoch1=SWSEpoch;
    REMEpoch1=REMEpoch;
    Wake1=Wake;
    Wake1=TotEpoch-SWSEpoch1-REMEpoch1;
    fig=figure;
    subplot(211)
    plot(Range(smooth_ghi,'s'),Data(smooth_ghi))
    load('StateEpochEMGSB.mat','EMGData','SWSEpoch','REMEpoch','Wake')
    Wake=TotEpoch-SWSEpoch-REMEpoch;
    title('Gamma')
    subplot(212)
    plot(Range(EMGData,'s'),Data(EMGData))
    xlim([0 max(Range(smooth_ghi,'s'))])
    title('EMG')
    
    fig2=figure;
    subplot(211)
    PlotSleepStage(Wake1,SWSEpoch1,REMEpoch1,0,[1 1],[],1);
    set(gca,'ytick',[2:5])
    set(gca,'yticklabel',{'SWS','','REM','Wake'})
    ylim([1 6])
    title('Gamma')
    subplot(212)
    load('TransLimsEMG.mat')
    PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[1 1],[],1);
    set(gca,'TickLength',[0 0],'XTick',[0:3600:25000],'XTickLabel',{'0','1','2','3','4','5','6'})
    set(gca,'ytick',[2:5])
    set(gca,'yticklabel',{'SWS','','REM','Wake'})
    ylim([1 6])
    title('EMG')
    
    try
    fig3=figure;
    subplot(211)
    load('TransLimsGam.mat')
    PlotAbortedTransitions(AbortTrans,0)
    title('Gamma')
    subplot(212)
    load('TransLimsEMG.mat')
    PlotAbortedTransitions(AbortTrans,0)
    title('EMG')
        saveas(fig3,['/media/DataMOBSSlSc/SleepScoringMice/CompEMGMice/TransitionGrams',num2str(mm),'.fig'])
    saveFigure(fig3,['TransitionGrams',num2str(mm)],'/media/DataMOBSSlSc/SleepScoringMice/CompEMGMice/')
    end
    
    saveas(fig,['/media/DataMOBSSlSc/SleepScoringMice/CompEMGMice/TimeSeries',num2str(mm),'.fig'])
    saveFigure(fig,['TimeSeries',num2str(mm)],'/media/DataMOBSSlSc/SleepScoringMice/CompEMGMice/')
    saveas(fig2,['/media/DataMOBSSlSc/SleepScoringMice/CompEMGMice/HypnoGrams',num2str(mm),'.fig'])
    saveFigure(fig2,['HypnoGrams',num2str(mm)],'/media/DataMOBSSlSc/SleepScoringMice/CompEMGMice/')
    
    close all
end


%% Trigger EMG on OB transitions and OB on EMG transitions
% figures per mouse
% average over mice
for mm=1:m
    mm
    cd (filename{mm,1})
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake','smooth_ghi')
    TotEpoch=intervalSet(0,max(Range(smooth_ghi)));
    Wake=TotEpoch-SWSEpoch-REMEpoch;
    Wake=mergeCloseIntervals(Wake,3*1e4);
    
    load('StateEpochEMGSB.mat','EMGData','EMG_thresh')
    [aft_cell,bef_cell]=transEpoch(Or(SWSEpoch,REMEpoch),Wake);
    PlotRipRaw(EMGData,Start(bef_cell{1,2},'s'),5000);%beginning of all sleep that is preceded by Wake
    PlotRipRaw(EMGData,Start(bef_cell{2,1},'s'),5000);%beginning of all Wake  that is preceded by sleep
    load('StateEpochEMGSB.mat','SWSEpoch','REMEpoch','Wake')
    TotEpoch=intervalSet(0,max(Range(EMGData)));
    clear EMGData
    Wake=TotEpoch-SWSEpoch-REMEpoch;
    Wake=mergeCloseIntervals(Wake,3*1e4);
    [aft_cell,bef_cell]=transEpoch(Or(SWSEpoch,REMEpoch),Wake);
    PlotRipRaw(smooth_ghi,Start(bef_cell{1,2},'s'),5000);%beginning of all sleep that is preceded by Wake
    PlotRipRaw(smooth_ghi,Start(bef_cell{2,1},'s'),5000);%beginning of all Wake  that is preceded by sleep
   pause
   close all
end


%% OB microawakenings
% Look at EMG activity distribution
for mm=1:m
    cd (filename{mm,1})
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake','smooth_ghi','gamma_thresh')
    % Get microarousals absed on gamma
    Sleep=Or(SWSEpoch,REMEpoch);
    MicroWake=SandwichEpoch(Wake,Sleep,10*1e4,15*1e4);
    MicroWake=intervalSet(Start(MicroWake)-5*1e4,Stop(MicroWake));
    load('StateEpochEMGSB.mat','EMGData')
    % Look at Gamma and EMG power during these MAs
    maxonGamma=[];meanonGamma=[];
    for kk=1:length(Start(MicroWake))
        maxonGamma(kk,1)=max(Data(Restrict(EMGData,subset(MicroWake,kk))));
        maxonGamma(kk,2)=max(Data(Restrict(smooth_ghi,subset(MicroWake,kk))));
        meanonGamma(kk,1)=mean(Data(Restrict(EMGData,subset(MicroWake,kk))));
        meanonGamma(kk,2)=mean(Data(Restrict(smooth_ghi,subset(MicroWake,kk))));
    end
    
    
    load('StateEpochEMGSB.mat','SWSEpoch','REMEpoch','Wake','EMG_thresh')
    % Get microarousals based on EMG
    Sleep=Or(SWSEpoch,REMEpoch);
    MicroWake=SandwichEpoch(Wake,Sleep,10*1e4,15*1e4);
    MicroWake=intervalSet(Start(MicroWake)-5*1e4,Stop(MicroWake));
    % Look at Gamma and EMG power during these MAs
    maxonEMG=[];meanonEMG=[];
    for kk=1:length(Start(MicroWake))
        maxonEMG(kk,1)=max(Data(Restrict(EMGData,subset(MicroWake,kk))));
        maxonEMG(kk,2)=max(Data(Restrict(smooth_ghi,subset(MicroWake,kk))));
        meanonEMG(kk,1)=mean(Data(Restrict(EMGData,subset(MicroWake,kk))));
        meanonEMG(kk,2)=mean(Data(Restrict(smooth_ghi,subset(MicroWake,kk))));
    end
    
    % Plot
    fig=figure;
    subplot(121)
    [Y,X]=hist(log(Data(EMGData)),1000);
    plot(X,Y/max(Y),'k'), hold on
    plot(log(maxonEMG(:,1)),0.9,'.k')
    plot(log(meanonEMG(:,1)),0.85,'*k')
    plot(log(maxonGamma(:,1)),0.6,'.r')
    plot(log(meanonGamma(:,1)),0.55,'*r')
    line(log([EMG_thresh EMG_thresh]),[0 1],'color','k')
    title(strcat('EMG - ',num2str(length(meanonEMG)),'MAs'))
    subplot(122)
    [Y,X]=hist(log(Data(smooth_ghi)),1000);
    plot(X,Y/max(Y),'r'), hold on
    plot(log(maxonEMG(:,2)),0.9,'.k')
    plot(log(meanonEMG(:,2)),0.85,'*k')
    plot(log(maxonGamma(:,2)),0.6,'.r')
    plot(log(meanonGamma(:,2)),0.55,'*r')
    line(log([gamma_thresh gamma_thresh]),[0 1],'color','r')
    title(strcat('Gamma - ',num2str(length(maxonGamma)),'MAs'))
    
    saveas(fig,['/media/DataMOBSSlSc/SleepScoringMice/CompEMGMice/MADistributions',num2str(mm),'.fig'])
    saveas(fig,['/media/DataMOBSSlSc/SleepScoringMice/CompEMGMice/MADistributions',num2str(mm),'.eps'])
    
end



%% OB and EMG microawakening
% Common vs different --> duration / spectra
nn=0;
clear Sp SpP
for mm=1:m
    mm
    cd (filename{mm,1})
    load('H_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    if exist('PFC_Low_Spectrum.mat')>0
        load('PFC_Low_Spectrum.mat')
        SptsdP=tsd(Spectro{2}*1e4,Spectro{1});
        nn=nn+1;
    else
        clear SptsdP
    end
    
    
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake','smooth_ghi','gamma_thresh')
    % Get microarousals absed on gamma
    Sleep=SWSEpoch;
    Wake1=Wake;
    Sleep1=Sleep;
    MicroWake=SandwichEpoch(Wake,Sleep,15*1e4,10*1e4);
    load('StateEpochEMGSB.mat','EMGData','EMG_thresh')
    % Look at Gamma and EMG power during these MAs
    MWAgree{1,mm}=[];MWDur{1,mm}=[];
    ww=1;
    for kk=1:length(Start(MicroWake))
        temp=Restrict(EMGData,subset(MicroWake,kk));
        if size(Range(temp),1)~=0
            tempInt=thresholdIntervals(temp,EMG_thresh);
            MWDur{1,mm}(ww)=(Stop(subset(MicroWake,kk))-Start(subset(MicroWake,kk)))/1e4;
            if not(isempty(max(Stop(tempInt)-Start(tempInt))/1e4))
                MWAgree{1,mm}(ww)=max(Stop(tempInt)-Start(tempInt))/1e4;
            else
                MWAgree{1,mm}(ww)=0;
            end
            ww=ww+1;
        end
    end
    Sp{1,mm}=mean(Data(Restrict(Sptsd,subset(MicroWake,find(MWAgree{1,mm}<3)))));
    Sp{2,mm}=mean(Data(Restrict(Sptsd,subset(MicroWake,find(MWAgree{1,mm}>3)))));
    Sp{3,mm}=mean(Data(Restrict(Sptsd,MicroWake)));
    try
        SptsdP;
        SpP{1,nn}=mean(Data(Restrict(SptsdP,subset(MicroWake,find(MWAgree{1,mm}<3)))));
        SpP{2,nn}=mean(Data(Restrict(SptsdP,subset(MicroWake,find(MWAgree{1,mm}>3)))));
        SpP{3,nn}=mean(Data(Restrict(SptsdP,MicroWake)));
    end
    
    load('StateEpochEMGSB.mat','SWSEpoch','REMEpoch','Wake','EMG_thresh')
    % Get microarousals based on EMG
    Sleep=SWSEpoch;
    MicroWake=SandwichEpoch(Wake,Sleep,15*1e4,10*1e4);
    MWAgree{2,mm}=[];MWDur{2,mm}=[];
    ww=1;
    for kk=1:length(Start(MicroWake))
        temp=Restrict(smooth_ghi,subset(MicroWake,kk));
        if size(Range(temp),1)~=0
            tempInt=thresholdIntervals(temp,gamma_thresh);
            MWDur{2,mm}(ww)=(Stop(subset(MicroWake,kk))-Start(subset(MicroWake,kk)))/1e4;
            if not(isempty(max(Stop(tempInt)-Start(tempInt))/1e4))
                MWAgree{2,mm}(ww)=max(Stop(tempInt)-Start(tempInt))/1e4;
            else
                MWAgree{2,mm}(ww)=0;
            end
            ww=ww+1;
        end
    end
    Sp{4,mm}=mean(Data(Restrict(Sptsd,subset(MicroWake,find(MWAgree{2,mm}<3)))));
    Sp{5,mm}=mean(Data(Restrict(Sptsd,subset(MicroWake,find(MWAgree{2,mm}>3)))));
    Sp{6,mm}=mean(Data(Restrict(Sptsd,MicroWake)));
    Sp{7,mm}=mean(Data(Restrict(Sptsd,And(Wake,Wake1))));
    Sp{8,mm}=mean(Data(Restrict(Sptsd,And(Sleep,Sleep1))));
    try
        
        SptsdP;
        SpP{4,nn}=mean(Data(Restrict(SptsdP,subset(MicroWake,find(MWAgree{2,mm}<3)))));
        SpP{5,nn}=mean(Data(Restrict(SptsdP,subset(MicroWake,find(MWAgree{2,mm}>3)))));
        SpP{6,nn}=mean(Data(Restrict(SptsdP,MicroWake)));
        SpP{7,nn}=mean(Data(Restrict(SptsdP,And(Wake,Wake1))));
        SpP{8,nn}=mean(Data(Restrict(SptsdP,And(Sleep,Sleep1))));s
    end
    
    
end

figure
cols=jet(8);
sum=reshape([Sp{7,:}],263,m)+reshape([Sp{8,:}],263,m);
for k=[1,2,4,5,7,8]
    temp=reshape([Sp{k,:}],263,m);
    for i=1:m
       temp(:,i)=temp(:,i)./mean(sum(:,i));
    end
  %errorbar(mean(zscore(reshape([Sp{k,:}],263,m))'),stdError(zscore(reshape([Sp{k,:}],263,m))'),'color',cols(k,:))
  plot(Spectro{3},nanmean(temp'),'color',cols(k,:),'linewidth',3)
   hold on
end
%legend({'Gamma-Disagree','Gamma-Agree','All Gamma','EMG-Disagree','EMG-Agree','All EMG','Wake','Sleep'})
legend({'Gamma-Disagree','Gamma-Agree','EMG-Disagree','EMG-Agree','Wake','Sleep'})
    
figure
cols=jet(8);
sum=reshape([SpP{7,:}],263,5)+reshape([SpP{8,:}],263,5);
for k=[1,2,4,5,7,8]
temp=reshape([SpP{k,:}],263,5);
    for i=1:5
       temp(:,i)=temp(:,i)./mean(sum(:,i));
    end
  plot(Spectro{3},nanmean(temp'),'color',cols(k,:),'linewidth',3)
   hold on   
end
%legend({'Gamma-Disagree','Gamma-Agree','All Gamma','EMG-Disagree','EMG-Agree','All EMG','Wake','Sleep'})
legend({'Gamma-Disagree','Gamma-Agree','EMG-Disagree','EMG-Agree','Wake','Sleep'})

figure
temp=[];
for i=1:m
   temp=[temp,MWDur{2,i}];
end
subplot(121)
hist(temp,50)
title(['EMG MA' num2str(length(temp))])
temp=[];
for i=1:m
   temp=[temp,MWDur{1,i}];
end
subplot(122)
hist(temp,50)
title(['Gamm MA' num2str(length(temp))])

figure
temp=[];
for i=1:m
   temp=[temp,MWDur{2,i}(MWAgree{2,i}>0)];
end
ylim([0 60])
subplot(121)
hist(temp,50)
title(['EMG MA' num2str(length(temp))])
temp=[];
for i=1:m
   temp=[temp,MWDur{1,i}(MWAgree{1,i}>0)];
end
subplot(122)
hist(temp,50)
title(['Gamm MA' num2str(length(temp))])
ylim([0 15])






%% OB and EMG microawakening
% Common vs different --> duration / spectra
nn=0;
clear Sp SpP
for mm=1:m
    mm
    cd (filename{mm,1})
    load('H_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    if exist('PFC_Low_Spectrum.mat')>0
        load('PFC_Low_Spectrum.mat')
        SptsdP=tsd(Spectro{2}*1e4,Spectro{1});
        nn=nn+1;
    else
        clear SptsdP
    end
    
    
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake','smooth_ghi','gamma_thresh')
    % Get microarousals absed on gamma
    Sleep=REMEpoch;
    Wake1=Wake;
    Sleep1=Sleep;
    MicroWake=SandwichEpoch(Wake,Sleep,15*1e4,10*1e4);
    load('StateEpochEMGSB.mat','EMGData','EMG_thresh')
    % Look at Gamma and EMG power during these MAs
    MWAgree{1,mm}=[];MWDur{1,mm}=[];
    ww=1;
    for kk=1:length(Start(MicroWake))
        temp=Restrict(EMGData,subset(MicroWake,kk));
        if size(Range(temp),1)~=0
            tempInt=thresholdIntervals(temp,EMG_thresh);
            MWDur{1,mm}(ww)=(Stop(subset(MicroWake,kk))-Start(subset(MicroWake,kk)))/1e4;
            if not(isempty(max(Stop(tempInt)-Start(tempInt))/1e4))
                MWAgree{1,mm}(ww)=max(Stop(tempInt)-Start(tempInt))/1e4;
            else
                MWAgree{1,mm}(ww)=0;
            end
            ww=ww+1;
        end
    end
    Sp{1,mm}=mean(Data(Restrict(Sptsd,subset(MicroWake,find(MWAgree{1,mm}<3)))));
    Sp{2,mm}=mean(Data(Restrict(Sptsd,subset(MicroWake,find(MWAgree{1,mm}>3)))));
    Sp{3,mm}=mean(Data(Restrict(Sptsd,MicroWake)));
    try
        SptsdP;
        SpP{1,nn}=mean(Data(Restrict(SptsdP,subset(MicroWake,find(MWAgree{1,mm}<3)))));
        SpP{2,nn}=mean(Data(Restrict(SptsdP,subset(MicroWake,find(MWAgree{1,mm}>3)))));
        SpP{3,nn}=mean(Data(Restrict(SptsdP,MicroWake)));
    end
    
    load('StateEpochEMGSB.mat','SWSEpoch','REMEpoch','Wake','EMG_thresh')
    % Get microarousals based on EMG
    Sleep=REMEpoch;
    MicroWake=SandwichEpoch(Wake,Sleep,15*1e4,10*1e4);
    MWAgree{2,mm}=[];MWDur{2,mm}=[];
    ww=1;
    for kk=1:length(Start(MicroWake))
        temp=Restrict(smooth_ghi,subset(MicroWake,kk));
        if size(Range(temp),1)~=0
            tempInt=thresholdIntervals(temp,gamma_thresh);
            MWDur{2,mm}(ww)=(Stop(subset(MicroWake,kk))-Start(subset(MicroWake,kk)))/1e4;
            if not(isempty(max(Stop(tempInt)-Start(tempInt))/1e4))
                MWAgree{2,mm}(ww)=max(Stop(tempInt)-Start(tempInt))/1e4;
            else
                MWAgree{2,mm}(ww)=0;
            end
            ww=ww+1;
        end
    end
    Sp{4,mm}=mean(Data(Restrict(Sptsd,subset(MicroWake,find(MWAgree{2,mm}<3)))));
    Sp{5,mm}=mean(Data(Restrict(Sptsd,subset(MicroWake,find(MWAgree{2,mm}>3)))));
    Sp{6,mm}=mean(Data(Restrict(Sptsd,MicroWake)));
    Sp{7,mm}=mean(Data(Restrict(Sptsd,And(Wake,Wake1))));
    Sp{8,mm}=mean(Data(Restrict(Sptsd,And(Sleep,Sleep1))));
    try
        
        SptsdP;
        SpP{4,nn}=mean(Data(Restrict(SptsdP,subset(MicroWake,find(MWAgree{2,mm}<3)))));
        SpP{5,nn}=mean(Data(Restrict(SptsdP,subset(MicroWake,find(MWAgree{2,mm}>3)))));
        SpP{6,nn}=mean(Data(Restrict(SptsdP,MicroWake)));
        SpP{7,nn}=mean(Data(Restrict(SptsdP,And(Wake,Wake1))));
        SpP{8,nn}=mean(Data(Restrict(SptsdP,And(Sleep,Sleep1))));s
    end
    
    
end

figure
cols=jet(8);
sum=reshape([Sp{7,:}],263,m)+reshape([Sp{8,:}],263,m);
for k=[1,2,4,5,7,8]
    temp=reshape([Sp{k,:}],263,m);
    for i=1:m
       temp(:,i)=temp(:,i)./mean(sum(:,i));
    end
  %errorbar(mean(zscore(reshape([Sp{k,:}],263,m))'),stdError(zscore(reshape([Sp{k,:}],263,m))'),'color',cols(k,:))
  plot(Spectro{3},nanmean(temp'),'color',cols(k,:),'linewidth',3)
   hold on
end
%legend({'Gamma-Disagree','Gamma-Agree','All Gamma','EMG-Disagree','EMG-Agree','All EMG','Wake','Sleep'})
legend({'Gamma-Disagree','Gamma-Agree','EMG-Disagree','EMG-Agree','Wake','Sleep'})
    
figure
cols=jet(8);
sum=reshape([SpP{7,:}],263,4)+reshape([SpP{8,:}],263,4);
for k=1:8
temp=reshape([SpP{k,:}],263,4);
    for i=1:4
       temp(:,i)=temp(:,i)./mean(sum(:,i));
    end
  plot(Spectro{3},nanmean(temp'),'color',cols(k,:),'linewidth',3)
   hold on   
end
legend({'Gamma-Disagree','Gamma-Agree','All Gamma','EMG-Disagree','EMG-Agree','All EMG','Wake','Sleep'})

figure
temp=[];
for i=1:m
   temp=[temp,MWDur{2,i}];
end
subplot(121)
hist(temp,50)
title(['EMG MA' num2str(length(temp))])
temp=[];
for i=1:m
   temp=[temp,MWDur{1,i}];
end
subplot(122)
hist(temp,50)
title(['Gamm MA' num2str(length(temp))])

figure
temp=[];
for i=1:m
   temp=[temp,MWDur{2,i}(MWAgree{2,i}>0)];
end
ylim([0 60])
subplot(121)
hist(temp,50)
title(['EMG MA' num2str(length(temp))])
temp=[];
for i=1:m
   temp=[temp,MWDur{1,i}(MWAgree{1,i}>0)];
end
subplot(122)
hist(temp,50)
title(['Gamm MA' num2str(length(temp))])
ylim([0 15])


