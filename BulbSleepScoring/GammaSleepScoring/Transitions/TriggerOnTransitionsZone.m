clear all, close all

% Load names of all mice to use
AllSlScoringMice
SaveFolderName='/media/DataMOBSSlSc/SleepScoringMice/DesychrnoisationAtTransitions/';
smootime=1;
for mm=1:m
    figure
    mm
    tic
    try
        for i=1:4
            Points{i}=[];
        end
        cd(filename2{mm})
        %     load('MapsTransitionProba.mat')
        clear TotalNoiseEpoch NoiseEpoch GndNoiseEpoch
        load('StateEpochSB.mat','SWSEpoch','Wake','smooth_Theta','smooth_ghi','gamma_thresh','TotalNoiseEpoch','NoiseEpoch','GndNoiseEpoch')%     %Find transition zone
        
        try
            load('TransLims.mat')
        catch
            try,
                load(' TransLims.mat')
            catch
                load('TransLimsGam.mat')
                
            end
        end
        
        if exist('H_Low_Spectrum.mat')>0
            load([ filename2{mm} 'H_Low_Spectrum.mat'])
            SptsdH=tsd(Spectro{2}*1e4,Spectro{1});
        else
            clear SptsdH
        end
        load('H_Low_Spectrum.mat')
        mnH=mean(Spectro{1}(:,20:end)');
        HPowtsd=tsd(Spectro{2}*1e4,runmean(mnH',ceil(smootime/median(diff(Spectro{2})))));
        
        Wake=dropShortIntervals(Wake,5*1e4);
        SleepAll=or(SWSEpoch,REMEpoch);
        SleepAll=dropShortIntervals(SleepAll,5*1e4);
        WakeBeg=Restrict(ts(Start(TransitionEpoch)),Wake);
        [a,bWkBe]=intersect(Range(ts(Start(TransitionEpoch))),Range(WakeBeg));
        WakeEnd=Restrict(ts(Stop(TransitionEpoch)),Wake);
        [a,bWkEn]=intersect(Range(ts(Stop(TransitionEpoch))),Range(WakeEnd));
        SleepBeg=Restrict(ts(Start(TransitionEpoch)),SleepAll);
        [a,bSlBe]=intersect(Range(ts(Start(TransitionEpoch))),Range(SleepBeg));
        SleepEnd=Restrict(ts(Stop(TransitionEpoch)),SleepAll);
        [a,bSlEn]=intersect(Range(ts(Stop(TransitionEpoch))),Range(SleepEnd));
        
        
        [aft_cellG,bef_cellG]=transEpoch(SleepAll,Wake);

        fig=figure;
        %%Wk to Sleep
        temp=(subset(TransitionEpoch,(intersect(bWkBe,bSlEn))));temp=mergeCloseIntervals(temp,1e4);
        [M{mm,1},T{mm,1}]=PlotRipRaw(HPowtsd,Start(temp,'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
        [M{mm,2},T{mm,2}]=PlotRipRaw(smooth_ghi,Start(temp,'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
        subplot(221)
        TransHPowtsd=Restrict(HPowtsd,temp);
        TransSmGamma=Restrict(smooth_ghi,Range(TransHPowtsd));
        plot(Data(TransSmGamma),Data(TransHPowtsd),'.')
        subplot(223)
        dur=Stop(temp,'s')-Start(temp,'s');a=[dur,T{mm,1}];a=sortrows(a);
        imagesc(M{mm,1}(:,1),1:size(T{mm,1},1),zscore(a(:,2:end)')'), hold on
        line([0 0],ylim,'linewidth',2,'color','w')
        plot(a(:,1),[1:length(dur)],'linewidth',2,'color','r')

        [M{mm,3},T{mm,3}]=PlotRipRaw(HPowtsd,Start(bef_cellG{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
        [M{mm,4},T{mm,4}]=PlotRipRaw(smooth_ghi,Start(bef_cellG{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
        
        %Sleep to Wk
        temp=(subset(TransitionEpoch,(intersect(bSlBe,bWkEn))));temp=mergeCloseIntervals(temp,1e4);
        [M{mm,5},T{mm,5}]=PlotRipRaw(HPowtsd,Start(temp,'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
        [M{mm,6},T{mm,6}]=PlotRipRaw(smooth_ghi,Start(temp,'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
        
        subplot(222)
        TransHPowtsd=Restrict(HPowtsd,temp);
        TransSmGamma=Restrict(smooth_ghi,Range(TransHPowtsd));
        plot(Data(TransSmGamma),Data(TransHPowtsd),'.');
        
        subplot(224)
        dur=Stop(temp,'s')-Start(temp,'s');a=[dur,T{mm,5}];a=sortrows(a);
        imagesc(M{mm,5}(:,1),1:size(T{mm,5},1),zscore(a(:,2:end)')'), hold on
        line([0 0],ylim,'linewidth',2,'color','w')
        plot(a(:,1),[1:length(dur)],'linewidth',2,'color','r')

        [M{mm,7},T{mm,7}]=PlotRipRaw(HPowtsd,Start(bef_cellG{2,1},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
        [M{mm,8},T{mm,8}]=PlotRipRaw(smooth_ghi,Start(bef_cellG{2,1},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
        saveas(fig,[SaveFolderName,'Mouse',num2str(mm),'.png'])  
        saveas(fig,[SaveFolderName,'Mouse',num2str(mm),'.fig'])
        close all
    end
end




figure
subplot(121)
for m=1:mm
    plot(M{m,1}(:,1),zscore(M{m,1}(:,2)),'k'), hold on
    plot(M{m,1}(:,1),zscore(M{m,3}(:,2)),'r'), hold on
end
title('Wk to sleep')
subplot(122)
for m=1:mm
    plot(M{m,1}(:,1),zscore(M{m,5}(:,2)),'k'), hold on
    plot(M{m,1}(:,1),zscore(M{m,7}(:,2)),'r'), hold on
end
title('Sl to wk')


figure
subplot(221)
temp=[];temp2=[];
for m=1:mm
    temp=[temp,zscore(M{m,1}(:,2))];
    temp2=[temp2,zscore(M{m,2}(:,2))];
end
plot(M{m,1}(:,1),mean(temp')),hold on
plot(M{m,2}(:,1),mean(temp2'))
legend('HPC','OB')
line([0 0],ylim)
title('Wk to sleep - norm')

subplot(222)
temp=[];temp2=[];
for m=1:mm
    temp=[temp,zscore(M{m,3}(:,2))];
    temp2=[temp2,zscore(M{m,4}(:,2))];
end
plot(M{m,3}(:,1),mean(temp')),hold on
plot(M{m,4}(:,1),mean(temp2'))
line([0 0],ylim)
title('Wk to sleep - trans zone')


subplot(223)
temp=[];temp2=[];
for m=1:mm
    temp=[temp,zscore(M{m,5}(:,2))];
    temp2=[temp2,zscore(M{m,6}(:,2))];
end
plot(M{m,5}(:,1),mean(temp')),hold on
plot(M{m,6}(:,1),mean(temp2'))
line([0 0],ylim)
title('Sl to wk - norm')

subplot(224)
temp=[];temp2=[];
for m=1:mm
    temp=[temp,zscore(M{m,7}(:,2))];
    temp2=[temp2,zscore(M{m,8}(:,2))];
end
plot(M{m,7}(:,1),mean(temp')),hold on
plot(M{m,8}(:,1),mean(temp2'))
line([0 0],ylim)
title('Sl to wk - trans zone')


