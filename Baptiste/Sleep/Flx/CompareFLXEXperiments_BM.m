clear all

load('/media/nas4/ProjetEmbReact/REMsampleMarie.mat')

File{1}{1}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K001/Baseline1';
File{1}{2}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K001/Baseline2';
File{1}{3}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K001/Flx2';
File{1}{4}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K001/Flx5';
File{1}{5}='/media/nas4/ProjetEmbReact/Mouse1001/20191111';
File{1}{6}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK001/Flx15';
Day{1} = [-2,-1,2,5,11,15];

File{2}{1}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K002/Baseline1';
File{2}{2}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K002/Baseline2';
File{2}{3}='/media/nas4/ProjetEmbReact/Mouse1002/20191107';
File{2}{4}='/media/nas4/ProjetEmbReact/Mouse1002/20191111';
File{2}{5}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK002/Flx15/'
%File{2}{6}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK002/Flx18/'
Day{2} = [-2,-1,2,6,15];

File{3}{1}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K003/Baseline2/Intan';
File{3}{2}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K003/Flx2/Intan';
File{3}{3}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K003/Flx4/Intan';
File{3}{4}='/media/mobsmorty/DataMOBS111/Baptiste/Chronic Flx/K003/Flx12';
File{3}{5}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK003/Flx22';
Day{3} = [-1,2,4,12,22];

File{4}{1}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK009/Baseline1/';
File{4}{2}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK009/Baseline2/';
File{4}{3}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK009/Flx2/';
File{4}{4}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK009/Flx5/';
File{4}{5}='/media/mobsmorty/DATAMOBs119/Chronic Flx/MK009/Flx6/';
Day{4} = [-2,-1,2,5,6];

File{5}{1}='/media/nas4/ProjetEmbReact/Mouse875/20190411/';
File{5}{2}='/media/nas4/ProjetEmbReact/Mouse875/20190514/';
File{5}{3}='/media/nas4/ProjetEmbReact/Mouse875/20190516/';
File{5}{4}='/media/nas4/ProjetEmbReact/Mouse875/20190523/';
File{5}{5}='/media/nas4/ProjetEmbReact/Mouse875/20190530/';
Day{5} = [-1,2,7,14,21];

File{6}{1}='/media/nas4/ProjetEmbReact/Mouse876/20190411/';
File{6}{2}='/media/nas4/ProjetEmbReact/Mouse876/20190507/';
File{6}{3}='/media/nas4/ProjetEmbReact/Mouse876/20190509/';
File{6}{4}='/media/nas4/ProjetEmbReact/Mouse876/20190516/';
File{6}{5}='/media/nas4/ProjetEmbReact/Mouse876/20190523/';
Day{6} = [-1,2,7,14,21];

File{7}{1}='/media/nas4/ProjetEmbReact/Mouse877/20190417/';
File{7}{2}='/media/nas4/ProjetEmbReact/Mouse877/20190513/';
File{7}{3}='/media/nas4/ProjetEmbReact/Mouse877/20190520/';
File{7}{4}='/media/nas4/ProjetEmbReact/Mouse877/20190527/';
Day{7} = [-1,7,14,21];






ZTh=[8 :1/6: 20]*3600; % time of the day (s), step of 10min

clear rem
clf
for mouse = 1:7
    for k = 1:length(File{mouse})
        cd(File{mouse}{k})
        disp(File{mouse}{k})
        
        clear REMEpoch SWSEpoch NewtsdZT Sleep
        load('SleepScoring_OBGamma','REMEpoch','SWSEpoch','Wake','Sleep')
        rem{mouse}(k) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
        
        
        load('behavResources.mat')
        WhatTime = tsd(Range(NewtsdZT),double(mod(Data(NewtsdZT)/(3600*1e4),24)));
        
        
        
        dat = Data(WhatTime);
        rg = Range(WhatTime);
        A = find(dat>10 & dat<19);
        LittleEpoch = intervalSet(rg(A(1)),rg(A(end)));
        RemLocal = and(REMEpoch,LittleEpoch);
        NREMLocal = and(SWSEpoch,LittleEpoch);
        
        remJustDay{mouse}(k) = sum(Stop(RemLocal)-Start(RemLocal))./(sum(Stop(NREMLocal)-Start(NREMLocal))+sum(Stop(RemLocal)-Start(RemLocal)));
        
        for h = 0:2:22
            A = find(dat>h & dat<(h+2));
            if not(isempty(A))
                LittleEpoch = intervalSet(rg(A(1)),rg(A(end)));
                
                RemLocal = and(REMEpoch,LittleEpoch);
                NREMLocal = and(SWSEpoch,LittleEpoch);
                WakeLocal = and(Wake,LittleEpoch);
                Sleeplocal = and(Sleep,LittleEpoch);
                
                rem_hrbyhr{mouse}(k,h/2+1) = sum(Stop(RemLocal)-Start(RemLocal))./(sum(Stop(NREMLocal)-Start(NREMLocal))+sum(Stop(RemLocal)-Start(RemLocal)));
                sleep_hrbyhr{mouse}(k,h/2+1) = (sum(Stop(Sleeplocal)-Start(Sleeplocal)))./(sum(Stop(WakeLocal)-Start(WakeLocal))+sum(Stop(Sleeplocal)-Start(Sleeplocal)));
                
            else
                disp('bou')
                rem_hrbyhr{mouse}(k,h/2+1) = NaN;
                sleep_hrbyhr{mouse}(k,h/2+1)  = NaN;
            end
        end
    end
    
    subplot(2,4,mouse)
    plot(Day{mouse},100*rem{mouse},'.-','linewidth',4,'color','r')
    hold on
    plot(Day{mouse},100*remJustDay{mouse},'.-','linewidth',4,'color','b')
    
    xlim([-3 23])
    ylim([0 20])
    line(xlim,[1 1]*prctile(DataREM,75),'color',[0.6 0.6 0.6])
    line(xlim,[1 1]*prctile(DataREM,25),'color',[0.6 0.6 0.6])
    line(xlim,[1 1]*nanmean(DataREM),'color','k')
    xlabel('Days on Fluo')
    ylabel('% REM')
    set(gca,'FontSize',12,'FontWeight','bold','linewidth',2)
    box off
    
end

figure
for mouse = 1:6
    subplot(2,3,mouse)
    hold on
        for day = 1:size(rem_hrbyhr{mouse},1)
            
            if Day{mouse}(day)<0
                plot(1:2:23,100*rem_hrbyhr{mouse}(day,:),'color','k','linewidth',2)
            else
                plot(1:2:23,100*rem_hrbyhr{mouse}(day,:),'color','r','linewidth',2)
            end
            ylim([0 30])
%             xlim([10 19])
        end
end

figure
for mouse = 1:6
    subplot(2,3,mouse)
    hold on
        for day = 1:size(rem_hrbyhr{mouse},1)
            
            if Day{mouse}(day)<0
                plot(1:2:23,100*sleep_hrbyhr{mouse}(day,:),'color','k','linewidth',2)
            else
                plot(1:2:23,100*sleep_hrbyhr{mouse}(day,:),'color','r','linewidth',2)
            end
            ylim([0 100])
%                         xlim([10 19])

        end
end
