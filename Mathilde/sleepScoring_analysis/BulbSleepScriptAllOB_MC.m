clear all, close all
AllSleepScorMice_MC;


%Sleep Scoring Using Olfactory Bulb and Hippocampal LFP
for mm=1:m
    %     try
    cd(filename2{mm})
    tic
    %% Step 1 - channels to use and 2 spectra
    close all
    filename=cd;
    if filename(end)~='/'
        filename(end+1)='/';
    end
    scrsz = get(0,'ScreenSize');
    chB=load('StateEpochSB.mat','chB');chB=chB.chB;
    load(['LFPData/LFP',num2str(chB),'.mat']);
    LFP;
    
    r=Range(LFP);
    TotalEpoch=intervalSet(0*1e4,r(end));
    mindur=3; %abs cut off for events;
    ThetaI=[3 3]; %merge and drop
    mw_dur=5; %max length of microarousal
    sl_dur=15; %min duration of sleep around microarousal
    ms_dur=10; % max length of microsleep
    wa_dur=20; %min duration of wake around microsleep
    
    if exist('B_Low_Spectrum.mat')==0
        LowSpectrumSB(filename,chB,'B');
        disp('Bulb Spectrum done')
    end
    ThreshEpoch=TotalEpoch;
    
    
    
    load StateEpochSB Epoch
    Epoch;
    
    TotalEpoch=and(TotalEpoch,Epoch);
    TotalEpoch=CleanUpEpoch(TotalEpoch);
    ThreshEpoch=and(ThreshEpoch,Epoch);
    ThreshEpoch=CleanUpEpoch(ThreshEpoch);
    close all;
    save('StateEpochSBAllOB.mat','chB')
    
    Find1015Epoch(ThreshEpoch,ThetaI,chB,filename);
    
    close all;
    
    %% Step 3 - Behavioural Epochs
    FindBehavEpochsAllOB(TotalEpoch,mindur,mw_dur,sl_dur,ms_dur,wa_dur,filename)
    
    %% Step 4 - Sleep scoring figure
    PlotEp=TotalEpoch;
    
    SleepScoreFigureAllOB(filename,PlotEp)
    toc
    %     load('StateEpochSBAllOB','REMEpoch');REMEpoch1=REMEpoch;
    %     load('StateEpochSB','REMEpoch','smooth_ghi');
    %     a=size(Data(Restrict(smooth_ghi,REMEpoch1)),1);
    %     b=size(Data(Restrict(smooth_ghi,and(REMEpoch1,REMEpoch))),1); %SS
    %     Ratio(mm)=b/a;
    %
    %     catch
    %        disp([num2str(mm) 'failed'])
    %     end
end


for mm=1:m
    cd(filename2{mm})
    load('StateEpochSBAllOB.mat','REMEpoch','SWSEpoch','smooth_1015','TenFif_thresh');REMEpoch1=REMEpoch;SWSEpoch1=SWSEpoch;
    load('StateEpochSB','REMEpoch','Sleep','SWSEpoch');
    a=size(Data(Restrict(smooth_1015,REMEpoch)),1);
    b=size(Data(Restrict(smooth_1015,and(REMEpoch1,REMEpoch))),1);
    Ratio(mm,1)=b/a;
    a=size(Data(Restrict(smooth_1015,SWSEpoch)),1);
    b=size(Data(Restrict(smooth_1015,and(SWSEpoch,SWSEpoch1))),1);
    Ratio(mm,2)=b/a;    
    [Y{mm},X{mm}]=hist(log(Data(Restrict(smooth_1015,Sleep))),100)
    Thresh(mm)=TenFif_thresh;
end




figure
clf
cols=gray(m+2);
for mm=1:m
    [val,ind]=max(Y{mm});
    Limit = X{mm}(ind);
    plot(X{mm}-Limit,Y{mm}./sum(Y{mm}),'color','k','linewidth',2),hold on
plot(log(Thresh(mm))-Limit,0.002*mm+0.015,'k*')
end

figure
bar([1,2],mean(Ratio),'Facecolor',[0.6 0.6 0.6]), hold on
errorbar([1,2],mean(Ratio),stdError(Ratio),'k.'), xlim([0.5 2.5])
set(gca,'XTick',[1,2],'XTickLabel',{'REM','SWS'})
box off



cd /media/DataMOBSSlSc/SleepScoringMice/M251/21052015
load('StateEpochSBAllOB','REMEpoch','smooth_1015','TenFif_thresh');
load('StateEpochSB','REMEpoch','Sleep','SWSEpoch','smooth_Theta','theta_thresh');
timestamps=Range(Restrict(smooth_Theta,Sleep));
ThetaData=Data(smooth_Theta);
timestamps=ts(timestamps(1:1000:end));
smooth_ThetaDwnS=Restrict(smooth_Theta,timestamps);
smooth_1015DwnS=Restrict(smooth_1015,timestamps);
clf
plot(log(Data(smooth_ThetaDwnS)),log(Data(smooth_1015DwnS)),'.','color',[0.6 0.6 0.6])
hold on
line(log([theta_thresh theta_thresh]),ylim,'color','k','linewidth',3)
line(xlim,log([TenFif_thresh TenFif_thresh]),'color','k','linewidth',3)
box off
set(gca,'XTick',[-1:1:2],'YTick',[4.5:0.5:6.5])

timestamps=Range((smooth_Theta));
ThetaData=Data(smooth_Theta);
timestamps=ts(timestamps(1:1000:end));
smooth_ThetaDwnS=Restrict(smooth_ghi,timestamps);
smooth_1015DwnS=Restrict(smooth_1015,timestamps);
clf
plot(log(Data(smooth_ThetaDwnS)),log(Data(smooth_1015DwnS)),'.','color',[0.6 0.6 0.6])





for mm=1:m
    cd(filename2{mm})
    load('StateEpochSBAllOB.mat','REMEpoch','SWSEpoch','smooth_1015','TenFif_thresh');REMEpoch1=REMEpoch;SWSEpoch1=SWSEpoch;
    load('StateEpochSB','REMEpoch','Sleep','SWSEpoch');
    
    a=size(Data(Restrict(smooth_1015,REMEpoch)),1);    
    b=size(Data(Restrict(smooth_1015,and(REMEpoch1,REMEpoch))),1);
    Ratio(mm,1)=b/a;
    a=size(Data(Restrict(smooth_1015,SWSEpoch)),1);
    b=size(Data(Restrict(smooth_1015,and(SWSEpoch,SWSEpoch1))),1);
    Ratio(mm,2)=b/a;    
    
    a=size(Data(Restrict(smooth_1015,REMEpoch1)),1);
    b=size(Data(Restrict(smooth_1015,and(REMEpoch1,REMEpoch))),1);
    Ratio(mm,3)=b/a;
    a=size(Data(Restrict(smooth_1015,SWSEpoch1)),1);
    b=size(Data(Restrict(smooth_1015,and(SWSEpoch,SWSEpoch1))),1);
    Ratio(mm,4)=b/a;    
end

a=nanmean(Ratio);
Data = [a;1-a];

subplot(121)
bar(Data(:,1:2)','stacked'), hold on
errorbar([1,2],(Data(1,1:2)),stdError(Ratio(:,1:2)),'k.')
ylabel('% scored as REM / NREM by OB')
set(gca,'FontSize',20)
box off
xlim([0.5 2.5])
ylim([0 1.2])
set(gca,'XTick',[1,2],'XTickLabel',{'HPC REM','HPC NREM'})

subplot(122)
bar(Data(:,3:4)','stacked'), hold on
errorbar([1,2],(Data(1,3:4)),stdError(Ratio(:,3:4)),'k.')
ylabel('% scored as REM / NREM by HPC')
set(gca,'FontSize',20)
box off
xlim([0.5 2.5])
ylim([0 1.2])
set(gca,'XTick',[1,2],'XTickLabel',{'OB REM','OB NREM'})


