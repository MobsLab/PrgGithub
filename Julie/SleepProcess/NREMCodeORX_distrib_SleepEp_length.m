% 25.01.2018
% Pour figure orexin Papier Marie
clear all
sav=0;


%% pour Julie
if 1
Dir=PathForExperimentsMLnew('BASAL');
figure; numF=gcf; hold on
figure('Position',[        94          50        1796         907]); numF_gamma=gcf; hold on
binrange=[[0:2:2000] 10000 100000];
EpDistrib=nan(length(Dir.path), length(binrange));
MovThreshMat=nan(length(Dir.path),1);
for man=1:length(Dir.path)
    disp(' ');disp(Dir.path{man})
    try
        cd(Dir.path{man}); disp('ok')
        clear Movtsd MovAcctsd Mmov MovThresh
        load('behavResources.mat','Movtsd','MovAcctsd')
        if ~exist('Movtsd','var');
            disp('use MovAcctsd')
            Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
            rg=Range(Movtsd);
            val=SmoothDec(Data(Movtsd),5);
            Mmov=tsd(rg(1:10:end),val(1:10:end));
        else
            Mmov=Movtsd;
            disp('use Movtsd')
        end
        figure(numF_gamma),subplot(3,10,man)
        MovThresh=GetGammaThresh(Data(Mmov),0,0);% 0: no user confirmation for tresh
        title(Dir.name{man});
        %close
        MovThresh=exp(MovThresh); % c'est cette etape qui est mega important
        MovThreshMat(man)=MovThresh;
        Immob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
        mergeSleep=3; 
        dropSpleep=3;%3s
        Immob=mergeCloseIntervals(Immob,mergeSleep*1E4);
        Immob=dropShortIntervals(Immob,dropSpleep*1E4);
        [x_out,n_out]=hist(Stop(Immob,'s')-Start(Immob,'s'),binrange); 
        EpDistrib(man,:)=x_out;
        figure(numF),
        plot(n_out, x_out); xlim([0 2000]);%, 
        title(Dir.name{man})
    catch
        disp('problem')
        keyboard
    end
end
figure, numF_distrib_allmice=gcf; plot(n_out, nansum(EpDistrib)); xlim([0 50]);
figure, numF_distrib_allmice=gcf; plot(n_out, nanmean(EpDistrib)), hold on, plot(n_out, nanmean(EpDistrib),'.'); xlim([0 50]);title('mean')
if sav
    cd('/media/DataMOBsRAIDN/ProjetOREXIN/PapierNREM')
    res=pwd
    save('DistribSleepEp', 'Dir','mergeSleep','dropSpleep','EpDistrib','MovThreshMat')
    saveas(numF.Number,'DistribSleepEp.fig')
    saveFigure(numF.Number,'DistribSleepEp', res)
    saveas(numF_gamma.Number,'MovThresh_Basal.fig')
    saveas(numF_distrib_allmice.Number,'DistribSleepEp_allmice.fig')
end

for i=1:3
    for j=1:10
        subplot(3,10, 10*(i-1)+j), hold on
        xlim([14 20])
    end
end


end
%% OREXIN MICE
clear 
DirORX.path{1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse554/20170719_BasalSleep/OREXIN-Mouse-554-19072017';
DirORX.path{2}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h';
DirORX.path{3}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h';
DirORX.name={'554';'570';'571';};
Dir=DirORX;
figure; numF=gcf; hold on
binrange=[[0:2:2000] 10000 100000];
EpDistrib=nan(length(Dir.path), length(binrange));
for man=1:length(Dir.path)
    disp(' ');disp(Dir.path{man})
    try
        cd(Dir.path{man}); disp('ok')
        clear Movtsd MovAcctsd Mmov MovThresh
        load('behavResources.mat','Movtsd','MovAcctsd')
        if ~exist('Movtsd','var');
            disp('use MovAcctsd')
            Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
            rg=Range(Movtsd);
            val=SmoothDec(Data(Movtsd),5);
            Mmov=tsd(rg(1:10:end),val(1:10:end));
        else
            Mmov=Movtsd;
            disp('use Movtsd')
        end
        MovThresh=GetGammaThresh(Data(Mmov),0);% 0: no user confirmation for tresh
        title(Dir.name{man});
        %close
        MovThresh=exp(MovThresh); % c'est cette etape qui est mega important
        Immob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
        mergeSleep=3; 
        dropSpleep=3;%3s
        Immob=mergeCloseIntervals(Immob,mergeSleep*1E4);
        Immob=dropShortIntervals(Immob,dropSpleep*1E4);
        [x_out,n_out]=hist(Stop(Immob,'s')-Start(Immob,'s'),binrange); 
        EpDistrib(man,:)=x_out;
        figure(numF),
        plot(n_out, x_out); xlim([0 2000]);%subplot(3,10,man), 
        title(Dir.name{man})
    catch
        disp('problem')
        keyboard
    end
end
figure, plot(n_out, sum(EpDistrib)); xlim([0 50]);
if sav
    cd('/media/DataMOBsRAIDN/ProjetOREXIN/PapierNREM')
    res=pwd
    save('DistribSleepEp', 'Dir','mergeSleep','dropSpleep','EpDistrib')
    saveas(numF.Number,'DistribSleepEp.fig')
    saveFigure(numF.Number,'DistribSleepEp', res)
end


%% initiate
DoSB=1;
Dir=PathForExperimentsMLnew('BASALlongSleep');  
%Dir=PathForExperimentsMLnew('BASAL');
%Dir=PathForExperimentsMLnew('Spikes');% code SB

DirORX.path{1}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse554/20170719_BasalSleep/OREXIN-Mouse-554-19072017';
DirORX.path{2}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse570/20171019-BasalSleep-8-20h';
DirORX.path{3}='/media/DataMOBsRAIDN/ProjetOREXIN/DataSleep/Mouse571/20171019-BasalSleep-8-20h';
for man=1:length(Dir.path)
    cd(DirORX.path{man}); disp(' ');disp(DirORX.path{man})
    
    SleepScoringAccelerometer('user_confirmation',0,'minduration',3)
end