%% Compress frames
clear all
Options.DownSample=1;
Options.RemoveMask=1;
Options.Visualization=0;
MouseToAvoid=[560,117]; % mice with noisy data to exclude
SessNames={'Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction',...
    'SoundHab' 'SoundCond' 'SoundTest',...
    'CtxtHab' 'CtxtCond' 'CtxtTest' 'CtxtTestCtrl',...
    'HabituationNight' 'TestPreNight' 'UMazeCondNight' 'TestPostNight' 'ExtinctionNight',...
    'Habituation_EyeShockTempProt' 'TestPre_EyeShockTempProt' 'WallHabSafe_EyeShockTempProt' 'WallHabShock_EyeShockTempProt' 'WallCondShock_EyeShockTempProt' 'WallCondSafe_EyeShockTempProt' ,...
    'TestPost_EyeShockTempProt' 'WallExtShock_EyeShockTempProt' 'WallExtSafe_EyeShockTempProt',...
    'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock',...
    'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock',...
    'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};
pb=1;

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);  
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})

            if (exist('RipplesSleepThresh.mat'))
                
                load('RipplesSleepThresh.mat')
                load('ChannelsToAnalyse/dHPC_rip.mat')
                load(['LFPData/LFP',num2str(channel),'.mat']);
                FilLFP=FilterLFP(LFP,[120 220],1024);clear LFP
                sqred=Data(FilLFP).^2;
                sqred=(sqred-mean(sqred))./std(sqred);
                SqredTsd=tsd(Range(FilLFP),sqred);
                ripples=Rip;
                if size(Rip,1)>3
                for rr=1:size(Rip,1)
                    Rip(rr,4)=max(Data(Restrict(SqredTsd,intervalSet(Rip(rr,1)*1e4,Rip(rr,3)*1e4))));
                end
                [maps,data,stats] = RippleStats([Range(FilLFP,'s'),Data(FilLFP)],Rip);
                [C, B] = CrossCorr(Rip(:,1),Rip(:,1),0.001,200);
                stats.acg.data=C;
                stats.acg.t=B*10;
                else
                    maps=[];
                    data=[];
                    stats=[];
                end
                save('RipplesSleepThresh.mat','maps','data','stats','-append')
                clear  maps data stats Rip ripples FilLFP sqred SqredTsd C B
                
            end
        end
    end
end

