clear all
MouseToAvoid=[560,117,431]; % mice with noisy data to exclude
dt_end=0.5;

for k =1:5
    if k==1
        SessionNames={'UMazeCondExplo_PreDrug', 'UMazeCondBlockedShock_PreDrug', 'UMazeCondBlockedSafe_PreDrug'};
    elseif k==2
        SessionNames={'UMazeCondExplo_PostDrug', 'UMazeCondBlockedShock_PostDrug', 'UMazeCondBlockedSafe_PostDrug'};
    elseif k==3
        SessionNames={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
    elseif k==4
        SessionNames={'UMazeCond_EyeShock', 'UMazeCondBlockedShock_EyeShock', 'UMazeCondBlockedSafe_EyeShock'};
    elseif k==5
        SessionNames={'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock' };
    elseif k==6
        SessionNames={'UMazeCond_PreDrug_TempProt', 'UMazeCondBlockedShock_PreDrug_TempProt', 'UMazeCondBlockedSafe_PreDrug_TempProt'};
    elseif k==7
        SessionNames={'ExtinctionBlockedShock_PostDrug_TempProt', 'ExtinctionBlockedSafe_PostDrug_TempProt'};
    elseif k==8
        SessionNames={'UMazeCond'};
    end
    disp(SessionNames{1})
    
    clear SpecData SpecDataH SpecDataHLo AllSpecHPC AllSpec NumRip DurPer HRInfo Spectrogram FreezingTime FzEpochLg
    Files=PathForExperimentsEmbReact(SessionNames{1});
    Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
    for mm=1:length(Files.path)
        
        disp(['Mouse ', num2str(Files.ExpeInfo{mm}{1}.nmouse)])
        AllInfo.OBFreqWV{mm}=[];
        AllInfo.OBFreqPT{mm}=[];
        AllInfo.HBRate{mm}=[];
        AllInfo.HBVar{mm}=[];
        AllInfo.Ripples{mm}=[];
        AllInfo.Position{mm}=[];
        AllInfo.Freeze{mm}=[];
        AllInfo.PeakShock{mm}=[]; AllInfo.PeakSafe{mm}=[];
        AllInfo.TroughShock{mm}=[]; AllInfo.TroughSafe{mm}=[];

        for ss=1:length(SessionNames)
            Files=PathForExperimentsEmbReact(SessionNames{ss});
            Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
            for c=1:length(Files.path{mm})
                
                clear RipBand LocalFreq Spectro Behav
                cd(Files.path{mm}{c})
                load('behavResources_SB.mat')
                dt=median(diff(Range(Behav.Vtsd,'s')));
                if not(isempty(Behav.FreezeAccEpoch))
                    FreezeEpoch=Behav.FreezeAccEpoch;
                else
                    FreezeEpoch=Behav.FreezeEpoch;
                end
                
                clear TotalNoiseEpoch smooth_ghi
                load('StateEpochSB.mat','TotalNoiseEpoch','smooth_ghi')
                RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));
                
                %% resample everything
                
                load('InstFreqAndPhase_B.mat')
                TimeBins = [0:0.5:max(Range(LocalFreq.WV,'s'))];
                
                dat = Data(LocalFreq.WV);
                dat(dat>15) = NaN;
                dat(dat==min(dat)) = NaN;
                LocalFreq.WV = tsd(Range(LocalFreq.WV),dat);
                LocalFreq.WV = DownSampleByBlocks(LocalFreq.WV,0.5,'median');
                LocalFreq.WV = tsd(TimeBins*1e4,interp1(Range(LocalFreq.WV,'s'),Data(LocalFreq.WV),TimeBins)');
                
                dat2 = Data(LocalFreq.PT);
                dat2 = movmedian(naninterp(dat2),6);
                LocalFreq.PT = tsd(Range(LocalFreq.PT),dat2);
                LocalFreq.PT = DownSampleByBlocks(LocalFreq.PT,0.5,'median');
                LocalFreq.PT = tsd(TimeBins*1e4,interp1(Range(LocalFreq.PT,'s'),Data(LocalFreq.PT),TimeBins)');
                
                AllInfo.OBFreqWV{mm}=[AllInfo.OBFreqWV{mm};Data(LocalFreq.WV)];
                AllInfo.OBFreqPT{mm}=[AllInfo.OBFreqPT{mm};Data(LocalFreq.PT)];
                
                
                % Heart rate
                if exist('HeartBeatInfo.mat')
                    load('HeartBeatInfo.mat')
                    EKG.HBVar = DownSampleByBlocks(EKG.HBRate,0.5,'std');
                    EKG.HBVar = tsd(TimeBins*1e4,interp1(Range(EKG.HBVar,'s'),Data(EKG.HBVar),TimeBins)');
                    
                    EKG.HBRate = DownSampleByBlocks(EKG.HBRate,0.5,'mean');
                    EKG.HBRate = tsd(TimeBins*1e4,interp1(Range(EKG.HBRate,'s'),Data(EKG.HBRate),TimeBins)');
                    AllInfo.HBRate{mm}=[AllInfo.HBRate{mm};Data(EKG.HBRate)];
                    AllInfo.HBVar{mm}=[AllInfo.HBVar{mm};Data(EKG.HBVar)];
                else
                    AllInfo.HBRate{mm}=[AllInfo.HBRate{mm};NaN(length(TimeBins),1)];
                    AllInfo.HBVar{mm}=[AllInfo.HBVar{mm};NaN(length(TimeBins),1)];
                end
                
                % Ripples
                clear channel
                if exist('ChannelsToAnalyse/dHPC_rip.mat')==2
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    if not(isempty(channel))
                        load(['LFPData/LFP',num2str(channel),'.mat'])
                        % tike timepoints above the threshold
                        FiltLFP = FilterLFP(LFP, [120 250], 1024); %filter
                        signal_squared = abs(Data(FiltLFP));
                        meanVal = mean(signal_squared);
                        stdVal = std(signal_squared);
                        
                        % smooth for downsampling
                        SquaredFiltLFP = tsd(Range(FiltLFP),double(signal_squared-meanVal)>5*stdVal);
                        RipBand = DownSampleByBlocks(SquaredFiltLFP,0.5,'mean');
                        RipBand = tsd(TimeBins*1e4,interp1(Range(RipBand,'s'),Data(RipBand),TimeBins)');
                        AllInfo.Ripples{mm}=[AllInfo.Ripples{mm};Data(RipBand)];
                    else
                        AllInfo.Ripples{mm}=[AllInfo.Ripples{mm};NaN(length(TimeBins),1)];
                        
                    end
                else
                    AllInfo.Ripples{mm}=[AllInfo.Ripples{mm};NaN(length(TimeBins),1)];
                    
                end
                
                % Position
                Behav.LinearDist = DownSampleByBlocks(Behav.LinearDist,0.5,'mean');
                Behav.LinearDist = tsd(TimeBins*1e4,interp1(Range(Behav.LinearDist,'s'),Data(Behav.LinearDist),TimeBins)');
                AllInfo.Position{mm}=[AllInfo.Position{mm};Data(Behav.LinearDist)];
                
                % Freezing Or Not
                FreezeBins = Range(Restrict(ts(TimeBins*1e4),Behav.FreezeEpoch),'s');
                FreezeBehav = ones(1,length(TimeBins));
                FreezeBehav((FreezeBins*2)-1)= 0;
                AllInfo.Freeze{mm}=[AllInfo.Freeze{mm},FreezeBehav];
                
                % Freezing bout number
                
                % cumulative number of stims
                
                
            end
        end
    end
    
    
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis
    if k ==1
        save('PreDrugAnalysis_FzTypesbis.mat','AllInfo')
    elseif k==2
        save('PostDrugAnalysis_FzTypesbis.mat','AllInfo')
    elseif k==3
        save('PostDrugExtAnalysis_FzTypesbis.mat','AllInfo')
    elseif k==4
        save('EyeshockNotreatmentAnalysis_FzTypesbis.mat','AllInfo')
    elseif k==5
        save('EyeshockExtNotreatmentAnalysis_FzTypesbis.mat','AllInfo')
    elseif k==6
        save('TempFLXProtPreDrugAnalysis_FzTypesbis.mat','AllInfo')
    elseif k==7
        save('TempFLXProtPostDrugExtAnalysis_FzTypesbis.mat','AllInfo')
    elseif k==8
        save('PAGAnalysis_FzTypesbis.mat','AllInfo')
    end
end

figure
AllOB=[];AllHV=[];AllHR=[];AllRip=[];AllPos=[];
load('PAGAnalysis_FzTypesbis.mat')
load('EyeshockNotreatmentAnalysis_FzTypesbis.mat')
load('EyeshockExtNotreatmentAnalysis_FzTypesbis.mat')

for mm= 1 :length(AllInfo.OBFreqPT)
    AllOB = [AllOB ;(AllInfo.OBFreqPT{mm}(AllInfo.Freeze{mm}==0))];
    AllHR = [AllHR ;AllInfo.HBRate{mm}(AllInfo.Freeze{mm}==0)];
    AllHV = [AllHV ;AllInfo.HBVar{mm}(AllInfo.Freeze{mm}==0)];
    AllRip = [AllRip ;AllInfo.Ripples{mm}(AllInfo.Freeze{mm}==0)];
    AllPos = [AllPos ;AllInfo.Position{mm}(AllInfo.Freeze{mm}==0)];
    
%     plot3(log(AllInfo.OBFreqPT{mm}(AllInfo.Freeze{mm}==0)),(AllInfo.HBRate{mm}(AllInfo.Freeze{mm}==0)),AllInfo.HBVar{mm}(AllInfo.Freeze{mm}==0),'k.')
    scatter((AllInfo.OBFreqPT{mm}(AllInfo.Freeze{mm}==0)),AllInfo.Position{mm}(AllInfo.Freeze{mm}==0),5,AllInfo.Ripples{mm}(AllInfo.Freeze{mm}==0)>0,'filled')
    hold on
end
