%% Look at calibration sessions

clear all
Files=PathForExperimentsEmbReact('Calibration');

% Get good freezing thresholds


for mm=4
    mm
    endday=0;
    hold off
    for c=1:length(Files.path{mm})
        cd(Files.path{mm}{c})
        clear Imdifftsd Movtsd
        load('behavResources.mat')
        plot(Range(Movtsd,'s')+endday,Data(Movtsd)), hold on
        endday=endday+max(Range(Movtsd,'s'));
    end
    keyboard

    [x,th_immob_m]=ginput(1);
    for c=1:length(Files.path{mm})
        cd(Files.path{mm}{c})
        load('behavResources.mat','Movtsd')
        FreezeEpoch_m=thresholdIntervals(Movtsd,th_immob_m,'Direction','Below');
        FreezeEpoch_m=mergeCloseIntervals(FreezeEpoch_m,0.3*1E4);
        FreezeEpoch_m=dropShortIntervals(FreezeEpoch_m,2*1E4);
        save('behavResources.mat','th_immob_m','FreezeEpoch_m','-append')
    end
end



% Look at evolution of behave with voltage
ActVoltage=[3.5,1.5,2,2,3,4,2.5,2];
for mm=4
    mm
    BaseLineMov=[];
    clear StimInfo
    for c=1:length(Files.path{mm})
        cd(Files.path{mm}{c})
        load('behavResources.mat')
        load('LFPData/DigInfo.mat')
        load('ExpeInfo.mat')
        StimEpoch=thresholdIntervals(DigTSD{2},0.9,'Direction','Above');
        StimTimes=Start(StimEpoch,'s');
        Movtsd=tsd([0;Range(Movtsd)],[mean(Data(Movtsd));Data(Movtsd)]);
        if c==1
            BaseLineMov=nanmean(Data(Movtsd));
        end
        [M,T]=PlotRipRaw(Movtsd,StimTimes(1:4),5000,0);close;
        StimInfo(c,1)=mean(mean(T(:,9:11)))./BaseLineMov;
        [M,T]=PlotRipRaw(Movtsd,StimTimes,1000,0);close;
        StimInfo(c,2)=mean(mean(T(:,9:11)))./BaseLineMov;
        AftStim=intervalSet(30*1e4,180*1e4);
        StimInfo(c,3)=length(Data(Restrict(Movtsd,and(FreezeEpoch_m,AftStim))))./length(Data(Restrict(Movtsd,AftStim)));
        StimInfo(c,4)=ExpeInfo.StimulationInt;
        try,StimInfo(c,5)=ExpeInfo.StimulationDur;catch,StimInfo(c,5)=200;end
        
    end
    keyboard
    a=[StimInfo(:,4),-StimInfo(:,5)];
    [a,index]=sortrows(a);a=a(:,1);
    [a,ia,ic]=unique(a);
    StimInfo=StimInfo(index(ia),:);
    
    fig=figure;
    subplot(211)
    plot(StimInfo(:,4),StimInfo(:,2),'-*'),hold on
    line([1 1]*ActVoltage(mm),ylim)
    title(['Mouse',num2str(ExpeInfo.nmouse)])
    ylabel('Jump size (AU)')
    subplot(212)
    plot(StimInfo(:,4),StimInfo(:,3),'-*'),hold on
    line([1 1]*ActVoltage(mm),ylim)
    xlabel('Voltage')
    ylabel('FreezeTime (%)')
    saveas(fig,['/media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/Calibration/CalibrationMouse',num2str(ExpeInfo.nmouse),'.fig'])
    saveas(fig,['/media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/Calibration/CalibrationMouse',num2str(ExpeInfo.nmouse),'.png'])
    close all
    
end
