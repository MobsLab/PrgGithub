close all, clear all
AllFileTypes={'Calibration' 'EPM' 'Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction' 'SoundHab' 'SoundCond' 'SoundTest' 'CtxtHab' 'CtxtCond' 'CtxtTest' 'CtxtTestCtrl' 'HabituationNight' 'TestPreNight' 'UMazeCondNight' 'TestPostNight' 'ExtinctionNight'};

mindur=3; %abs cut off for events;
smootime=3;
fig1=figure;fig2=figure;
for ff=7
    Files=PathForExperimentsEmbReact(AllFileTypes{ff});
    
    for mm=1:length(Files.path)
        try
            for c=1:length(Files.path{mm})
                
                clear chH chB SleepyEpoch gamma_thresh
                cd(Files.path{mm}{c})
                clear smooth_ghi
                load('behavResources.mat','smooth_ghi','SleepyEpoch')
                try smooth_ghi
                catch
                    load('StateEpochSB.mat','smooth_ghi')
                    
                end
                TotEpoch=intervalSet(0,max(Range(smooth_ghi)));
                smooth_ghi1=smooth_ghi;
                All{mm}=Data(smooth_ghi1);
                %             try
                %                 FileName=FindSleepFile_EmbReact_SB(Files.ExpeInfo{mm}{c}.nmouse,Files.ExpeInfo{mm}{c}.date);
                %             catch
                %                 FileName=FindSleepFile(Files.ExpeInfo{mm}.nmouse,Files.ExpeInfo{mm}.date);
                %             end
                %             cd(FileName{1})
                %             load('StateEpochSB.mat','smooth_ghi','gamma_thresh')
                %             figure(fig1)
                %             subplot(4,2,mm)
                %             nhist({log(Data(smooth_ghi)),log(Data(smooth_ghi1))})
                %             line(log([gamma_thresh gamma_thresh]),ylim,'color','k')
                %             title(num2str(Files.ExpeInfo{mm}.nmouse))
                %             figure(fig2)
                %             subplot(4,2,mm)
                subplot(4,4,mm)
                plot(Range(smooth_ghi1,'s'),Data(smooth_ghi1)),hold on
                AlLTogether(mm,:) = interp1(Range(smooth_ghi1,'s'),Data(smooth_ghi1),[1:956]);
                %             line(xlim,([gamma_thresh gamma_thresh]),'color','k')
                %             SleepVals(mm)=length(Data(Restrict(smooth_ghi,and(TotEpoch,SleepyEpoch))))./length(Data(Restrict(smooth_ghi,TotEpoch)));
            end
        end
    end
end

figure
plot(zscore(AlLTogether'))
hold on
plot(nanmean(zscore(AlLTogether')'),'linewidth',4,'color','k')
xlabel('time (s)')
ylabel('Zscore gamma')
makepretty
plot(nanmean(zscore(AlLTogether')'),'linewidth',4,'color','k')
title('gamma ecvolution, first explo Hab')