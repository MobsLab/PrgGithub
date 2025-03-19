function [SpecData,NumRip,DurPer,Spectrogram,GammaOB,HRInfo]=GetSpectraDataForTwoFreezingOverview(SessionNames)

MouseToAvoid=[560,117,431]; % mice with noisy data to exclude
Files=PathForExperimentsEmbReact(SessionNames{1});
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);

for mm=1:length(Files.path)
    % Initilaize matrices
    SpecData.OB{mm}.Shock=[];SpecData.OB{mm}.Safe=[];
    SpecData.HHi{mm}.Shock=[];SpecData.HHi{mm}.Safe=[];
    SpecData.HLo{mm}.Shock=[];SpecData.HLo{mm}.Safe=[];
    
    AllSpecHPC{mm}=[];AllSpec{mm}=[];
    for ss=1:length(SessionNames)
        Files=PathForExperimentsEmbReact(SessionNames{ss});
        Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
        
        for c=1:length(Files.path{mm})
            
            cd(Files.path{mm}{c})
            
            % load epochs
            load('behavResources_SB.mat')
            dt=median(diff(Range(Behav.Vtsd,'s')));
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            clear TotalNoiseEpoch smooth_ghi SleepyEpoch
            load('StateEpochSB.mat','TotalNoiseEpoch','smooth_ghi')
            TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch),Stop(TTLInfo.StimEpoch)+2*1e4);
            RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));
            
            try, % only for PAG recordings with sleep problem
                load('StateEpochSB.mat','SleepyEpoch')
                RemovEpoch = or(RemovEpoch,SleepyEpoch);
            end
            
            % load spectra
            load('B_Low_Spectrum.mat')
            fLow=Spectro{3};
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            load('H_Low_Spectrum.mat')
            SptsdHLo=tsd(Spectro{2}*1e4,Spectro{1});
            
            % only for mice with ripples
            if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                clear Rip Riptsd RiptsdSL maps stats data
                load('H_VHigh_Spectrum.mat')
                SptsdH=tsd(Spectro{2}*1e4,Spectro{1});
                fHigh=Spectro{3};
                try
                    load('RipplesSleepThresh.mat')
                    RiptsdSL=ts(RipplesR(:,2)*10);
                    load('Ripples.mat')
                    Riptsd=ts(RipplesR(:,2)*10);
                catch
                    if  not(isempty(Start(FreezeEpoch-RemovEpoch)))
                        disp('ripple problem')
                        Riptsd=ts(0.1*1e4);
                        RiptsdSL=ts(0.1*1e4);
                    end
                end
            end
            
            %% On the safe side
            
            LitEp=dropShortIntervals(and(FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch,3*1e4);
            
            SpecData.OB{mm}.Safe=[SpecData.OB{mm}.Safe;Data(Restrict(Sptsd,LitEp))];
            SpecData.HLo{mm}.Safe=[SpecData.HLo{mm}.Safe;Data(Restrict(SptsdHLo,LitEp))];
            GammaOB.Safe(mm,c+(ss-1)*3)=nanmean(Data(Restrict(smooth_ghi,LitEp)));
            DurPer.Safe.Sess(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
            DurPer.Safe.Sleep(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));

            if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                SpecData.HHi{mm}.Safe=[SpecData.HHi{mm}.Safe;Data(Restrict(SptsdH,LitEp))];
                if not(isempty(Start(LitEp)))
                    NumRip.Safe.Sess(mm,c+(ss-1)*3)=length(Range(Restrict(Riptsd,LitEp)));
                    NumRip.Safe.Sleep(mm,c+(ss-1)*3)=length(Range(Restrict(RiptsdSL,LitEp)));
                    [Spectrogram.Safe{mm,c+(ss-1)*3},S,t]=AverageSpectrogram(SptsdH,fHigh,ts(Range(Restrict(Riptsd,LitEp))),5,200,0,0,0);
                else
                    NumRip.Safe.Sess(mm,c+(ss-1)*3)=NaN;
                    NumRip.Safe.Sleep(mm,c+(ss-1)*3)=NaN;
                    Spectrogram.Safe{mm,c+(ss-1)*3} = nan(length(fHigh),201);
                end
            else
                NumRip.Safe.Sess(mm,c+(ss-1)*3)=NaN;
                NumRip.Safe.Sleep(mm,c+(ss-1)*3)=NaN;
            end
            
            %% On the shock side
            LitEp=dropShortIntervals(and(FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch,3*1e4);
            SpecData.OB{mm}.Shock=[SpecData.OB{mm}.Shock;Data(Restrict(Sptsd,LitEp))];
            SpecData.HLo{mm}.Shock=[SpecData.HLo{mm}.Shock;Data(Restrict(SptsdHLo,LitEp))];
            DurPer.Shock.Sess(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));
            DurPer.Shock.Sleep(mm,c+(ss-1)*3)=nansum(Stop(LitEp,'s')-Start(LitEp,'s'));

            if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                SpecData.HHi{mm}.Shock=[SpecData.HHi{mm}.Shock;Data(Restrict(SptsdH,LitEp))];
                if not(isempty(Start(LitEp)))
                    NumRip.Shock.Sess(mm,c+(ss-1)*3)=length(Range(Restrict(Riptsd,LitEp)));
                    NumRip.Shock.Sleep(mm,c+(ss-1)*3)=length(Range(Restrict(RiptsdSL,LitEp)));
                    [Spectrogram.Shock{mm,c+(ss-1)*3},S,t]=AverageSpectrogram(SptsdH,fHigh,ts(Range(Restrict(Riptsd,LitEp))),5,200,0,0,0);
                else
                    NumRip.Shock.Sess(mm,c+(ss-1)*3)=NaN;
                    NumRip.Shock.Sleep(mm,c+(ss-1)*3)=NaN;
                    Spectrogram.Shock{mm,c+(ss-1)*3} = nan(length(fHigh),201);
                end
            else
                NumRip.Shock.Sess(mm,c+(ss-1)*3)=NaN;
                NumRip.Shock.Sleep(mm,c+(ss-1)*3)=NaN;
            end
            GammaOB.Shock(mm,c+(ss-1)*3)=nanmean(Data(Restrict(smooth_ghi,LitEp)));
            
            if exist('ChannelsToAnalyse/EKG.mat')
                load('HeartBeatInfo.mat')
                LitEp=dropShortIntervals(and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch,3*1e4);
                [HRInfo.Shk{mm,c+(ss-1)*3},HRSliceBySlice.Shk{mm,c+(ss-1)*3},SliceDur.Shk{mm,c+(ss-1)*3}]=CharacterizeHeartRateEpoch(EKG,LitEp,2);
                LitEp=dropShortIntervals(and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch,5*1e4);
                [HRInfo.Sf{mm,c+(ss-1)*3},HRSliceBySlice.Sf{mm,c+(ss-1)*3},SliceDur.Sf{mm,c+(ss-1)*3}]=CharacterizeHeartRateEpoch(EKG,LitEp,2);
                LitEp=dropShortIntervals(intervalSet(0,max(Range(EKG.HBRate)))-RemovEpoch,5*1e4);
                [HRInfo.Mv{mm,c+(ss-1)*3},HRSliceBySlice.Mv{mm,c+(ss-1)*3},SliceDur.Mv{mm,c+(ss-1)*3}]=CharacterizeHeartRateEpoch(EKG,LitEp,2);
                
            end
        end
        
    end
end

end