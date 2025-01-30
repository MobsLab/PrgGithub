%% Ripple detection
%INPUTINFO structure

clear all
InputInfo.thresh=[3,5];
InputInfo.duration=[0.015,0.02,0.2]*1000;
InputInfo.MakeEventFile=1;
InputInfo.EventFileName='HPCRipples';
InputInfo.SaveRipples=1;

SessNames={'SleepPreUMaze' 'UMazeCond' 'SleepPostUMaze' 'SoundTest' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'UMazeCondNight'};

for ss=4:5
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if not(Dir.ExpeInfo{d}{dd}.nmouse==117) & not(isempty(Dir.ExpeInfo{d}{dd}.Ripples)) & not(isnan(Dir.ExpeInfo{d}{dd}.Ripples))
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})
                load('ChannelsToAnalyse/dHPC_rip.mat')
                load(['LFPData/LFP',num2str(channel),'.mat'])
                
                if Dir.ExpeInfo{d}{dd}.SleepSession==1
                    load('StateEpochSB.mat','SWSEpoch')
                    InputInfo.Epoch=SWSEpoch;
                else
                    load('behavResources.mat')
                    load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                    InputInfo.Epoch=Behav.FreezeEpoch-SleepyEpoch;
                end
                
                if not(isempty(Start(InputInfo.Epoch)))
                    FindRipplesSB(LFP,InputInfo);
                end
                clear LFP
                InputInfo=rmfield(InputInfo,'Epoch');
                
                if exist('H_VHigh_Spectrum.mat')==0
                    VeryHighSpectrum([cd filesep],channel,'H')
                end
                
                
                load('Ripples.mat')
                load('ChannelsToAnalyse/dHPC_rip.mat')
                load(['LFPData/LFP',num2str(channel),'.mat']);
                FilLFP=FilterLFP(LFP,[120 220],1024);clear LFP
                sqred=Data(FilLFP).^2;
                sqred=(sqred-mean(sqred))./std(sqred);
                SqredTsd=tsd(Range(FilLFP),sqred);
                ripples=Rip;
                
                for rr=1:size(Rip,1)
                    Rip(rr,4)=max(Data(Restrict(SqredTsd,intervalSet(Rip(rr,1)*1e4,Rip(rr,3)*1e4))));
                end
                [maps,data,stats] = RippleStats([Range(FilLFP,'s'),Data(FilLFP)],Rip);
                [C, B] = CrossCorr(Rip(:,1),Rip(:,1),0.001,200);
                stats.acg.data=C;
                stats.acg.t=B*10;

                save('Ripples.mat','maps','data','stats','-append')
                clear  maps data stats Rip ripples FilLFP sqred SqredTsd C B


            end
        end
    end
end