AllFileTypes={'Calibration' 'EPM' 'Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction' 'SoundHab' 'SoundCond' 'SoundTest' 'CtxtHab' 'CtxtCond' 'CtxtTest' 'CtxtTestCtrl' 'HabituationNight' 'TestPreNight' 'UMazeCondNight' 'TestPostNight' 'ExtinctionNight'};

mindur=3; %abs cut off for events;
smootime=3;
for ff=5:length(AllFileTypes)
    Files=PathForExperimentsEmbReact(AllFileTypes{ff});
    for mm=1:length(Files.path)
        for c=1:length(Files.path{mm})
            clear chH chB SleepyEpoch gamma_thresh
            cd(Files.path{mm}{c})
            Files.path{mm}{c}
            
                try
                    load('ChannelsToAnalyse/dHPC_deep.mat')
                    chH=channel;
                catch
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    chH=channel;
                end
                if exist('H_Low_Spectrum.mat')==0
                LowSpectrumSB(Files.path{mm}{c},chH,'H');
                disp('Hpc spectrum done')
                end
            
            if exist('B_Low_Spectrum.mat')==0
                try
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    chB=channel;
                end
                LowSpectrumSB(Files.path{mm}{c},chB,'B');
                disp('OB spectrum done')
            end
            
            if not(exist('StateEpochSB.mat'))
                Epoch=FindNoiseEpoch(Files.path{mm}{c},chH); 
            else
                load('StateEpochSB.mat','Epoch')
            end
            
            close all
            vars = whos('-file','behavResources.mat');
            if not(ismember('SleepyEpoch', {vars.name})) |  not(ismember('smooth_ghi', {vars.name})) |  not(ismember('gamma_thresh', {vars.name}))
                try
                FileName=FindSleepFile(Files.ExpeInfo{mm}{c}.nmouse,Files.ExpeInfo{mm}{c}.date);
                catch
                    FileName=FindSleepFile(Files.ExpeInfo{mm}.nmouse,Files.ExpeInfo{mm}.date);
                end
                cd(FileName{1})
                load('StateEpochSB.mat','gamma_thresh','chB')
                cd(Files.path{mm}{c})
                load(['LFPData/LFP',num2str(chB),'.mat'])
                FilGamma=FilterLFP(LFP,[50 70],1024);
                HilGamma=hilbert(Data(FilGamma));
                H=abs(HilGamma);
                tot_ghi=tsd(Range(LFP),H);
                smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
                sm_ghi=Data(smooth_ghi);
                sleepper=thresholdIntervals(smooth_ghi,gamma_thresh,'Direction','Below');
                sleepper=mergeCloseIntervals(sleepper,mindur*1e4);
                SleepyEpoch=dropShortIntervals(sleepper,mindur*1e4);
                SleepyEpoch=and(SleepyEpoch,Epoch);
                fig=figure;
                plot(Range(smooth_ghi,'s'),Data(smooth_ghi)),hold on
                line(xlim,[gamma_thresh gamma_thresh],'color','r')
                title(num2str(sum(Stop(SleepyEpoch,'s')-Start(SleepyEpoch,'s'))))
                keyboard
                saveas(fig,'SleepyEpoch.png')
                close(fig)
                save('behavResources.mat','SleepyEpoch','smooth_ghi','gamma_thresh','-append');
            

            end
            
        end
    end
end


%% Exemple of problematic sessions
Files=PathForExperimentsEmbReact('Calibration');

AllGamma=[];
for c=1:length(Files.path{end})
    cd(Files.path{end}{c})
    load('behavResources.mat')
    AllGamma=[AllGamma;Data(smooth_ghi)];
    
end
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse471/20161024
load('StateEpochSB.mat')
figure