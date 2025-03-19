clear all
SessionNames={'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' };
for mm=1:5
    SpecData{mm}.Shock=[];SpecData{mm}.Safe=[];
    for ss=1:length(SessionNames)
        Files=PathForExperimentsEmbReact(SessionNames{ss});
        MouseToAvoid=[560]; % mice with noisy data to exclude
        Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
        
        for c=1:3
            cd(Files.path{mm}{c})
            load('behavResources.mat')
            dt=median(diff(Range(Behav.Movtsd,'s')));
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            load('B_Low_Spectrum.mat')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
%             RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            
            %% On the safe side
            LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-TTLInfo.StimEpoch;
            SpecData{mm}.Safe=[SpecData{mm}.Safe;Data(Restrict(Sptsd,LitEp))];
            
            %% On the shock side
            LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-TTLInfo.StimEpoch;
            SpecData{mm}.Shock=[SpecData{mm}.Shock;Data(Restrict(Sptsd,LitEp))];
            
        end
    end
end