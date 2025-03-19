
Path_SD_2Fz_BM

clearvars -except Dir_SensoryExposC57cage Dir_SensoryExposCD1cage Dir_SleepPostSD
States={'Sleep','Wake','NREM','REM'};

for exp=1%:3
    if exp==1
        DIR = Dir_SleepPostSD.path;
    elseif exp==2
        DIR = Dir_SensoryExposCD1cage.path;
    elseif exp==3
        DIR = Dir_SensoryExposC57cage.path;
    end
    for mouse=1:length(DIR)
        cd(DIR{mouse}{1})
        
        if exp>1
            OB_Low_Mean_Fz{exp}(1,:) = NaN(1,249);
            
            try
                load('behavResources.mat', 'MovAcctsd')
                thtps_immob = 2;
                th_immob_Acc = 1.7e7;
                smoofact_Acc = 30;
                NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
                FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
                FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
                FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
                
                load('StateEpochSB.mat','SmoothGamma')
                SleepyEpoch=thresholdIntervals(SmoothGamma,Gamma_Thresh{mouse},'Direction','Below');
                SleepyEpoch=mergeCloseIntervals(SleepyEpoch,3*1e4);
                SleepyEpoch=dropShortIntervals(SleepyEpoch,3*1e4);
                
                FreezeAccEpoch = FreezeAccEpoch-SleepyEpoch;
                
                FreezeTime{exp}(mouse) = sum(DurationEpoch(FreezeAccEpoch))/1e4;
                FreezeTimeProp{exp}(mouse) = sum(DurationEpoch(FreezeAccEpoch))/max(Range(NewMovAcctsd));
                Acc_Values_Fz{exp}(mouse) = nanmean(log10(Data(Restrict(NewMovAcctsd , FreezeAccEpoch))));
                
                try
                    load('ChannelsToAnalyse/EMG.mat')
                    load(['LFPData/LFP' num2str(channel) '.mat'])
                    FilLFP = FilterLFP(LFP,[50 300],1024);
                    FilLFP = Restrict(FilLFP,FreezeAccEpoch);
                    EMGData = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(.02/median(diff(Range(FilLFP,'s'))))));
                    EMGVals{exp}(mouse) = nanmean(log10(Data(EMGData)));
                end
                
                OB_Low = load('Bulb_deep_Low_Spectrum.mat');
                OB_Low_Sptsd = tsd(OB_Low.Spectro{2}*1e4 , OB_Low.Spectro{1});
                RangeLow = OB_Low.Spectro{3};
                
                OB_Low_Fz{exp,mouse} = Restrict(OB_Low_Sptsd , FreezeAccEpoch);
                if size(Data(OB_Low_Fz{exp,mouse}),1)~=0
                    OB_Low_Mean_Fz{exp}(mouse,:) = nanmean(Data(OB_Low_Fz{exp,mouse}));
                else
                    OB_Low_Mean_Fz{exp}(mouse,:) = NaN(1,249);
                end
                
                load('SWR.mat', 'tRipples')
                Rip_density{exp}(mouse) = length(Restrict(tRipples , FreezeAccEpoch))/(sum(DurationEpoch(FreezeAccEpoch))/1e4);
                
            end
        else
            try
                load('SleepScoring_OBGamma.mat', 'Info','Wake','Sleep','REMEpoch','SWSEpoch','Epoch')
                Gamma_Thresh{mouse} = Info.gamma_thresh;
                FirstHourEpoch = intervalSet(0,90*60*1e4);
                
                for state=1:length(States)
                    if state==1 % sleep
                        Epoch_to_use{1} = Sleep;
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                        Epoch_to_use{1} = and(Epoch_to_use{1} , FirstHourEpoch);
                        Epoch_to_use{2} = Epoch;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , FirstHourEpoch);
                    elseif state==2 % wake
                        Epoch_to_use{1} = Wake;
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                        Epoch_to_use{1} = and(Epoch_to_use{1} , FirstHourEpoch);
                        Epoch_to_use{2} = Epoch;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , FirstHourEpoch);
                        Epoch_to_use{3} = Sleep;
                        Epoch_to_use{3} = and(Epoch_to_use{3} , FirstHourEpoch);
                    elseif state==3 % NREM
                        Epoch_to_use{1} = SWSEpoch;
                        Epoch_to_use{1} = and(Epoch_to_use{1} , FirstHourEpoch);
                        Epoch_to_use{2} = Sleep;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , FirstHourEpoch);
                    elseif state==4 % REM
                        Epoch_to_use{1} = REMEpoch;
                        Epoch_to_use{1} = and(Epoch_to_use{1} , FirstHourEpoch);
                        %                             Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,90*60e4));
                        Epoch_to_use{2} = Sleep;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , FirstHourEpoch);
                        %                             Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,90*60e4));
                    end
                    Prop.(States{state})(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                end
                
            end
        end
        disp(DIR{mouse}{1})
    end
    if exp>1
        OB_Low_Mean_Fz{exp}(OB_Low_Mean_Fz{exp}==0) = NaN;
        FreezeTime{exp}(FreezeTime{exp}==0) = NaN;
        Rip_density{exp}(Rip_density{exp}==0) = NaN;
        Rip_density{exp}(Rip_density{exp}==0) = NaN;
        EMGVals{exp}(EMGVals{exp}==0) = NaN;
        Acc_Values_Fz{exp}(Acc_Values_Fz{exp}==0) = NaN;
        Fz_prop(exp) = 1-sum(isnan(FreezeTime{exp}))/length(FreezeTime{exp});
        EMGVals{1}(27:30)=NaN;
    end
end



Cols={[1 .5 .5],[.5 .5 1]};
Legends={'SD','exposure homecage'};
X=1:2;


figure
MakeSpreadAndBoxPlot3_SB(FreezeTime(2:3),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (s)')
set(gca , 'Yscale','log')
title('time spent freezing')






%% Sleep



Dir_ctrl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
Dir_ctrl=RestrictPathForExperiment(Dir_ctrl,'nMice',[1423 1424 1425 1426 1433 1434 1449 1450 1451 1414 1439 1440 1437]);


DirSocialDefeat_classic1 = PathForExperiments_SD_MC('SleepPostSD');
DirSocialDefeat_mCherry_saline1 = PathForExperiments_SD_MC('SleepPostSD_mCherry_retroCre_PFC_VLPO_SalineInjection');
DirSocialDefeat_BM_saline1 = PathForExperiments_SD_MC('SleepPostSD_noDREADD_BM_mice_SalineInjection');
DirSocialDefeat_mCherry_saline = MergePathForExperiment(DirSocialDefeat_mCherry_saline1,DirSocialDefeat_BM_saline1);
DirSocialDefeat_classic = MergePathForExperiment(DirSocialDefeat_classic1,DirSocialDefeat_mCherry_saline);



clearvars -except Dir_ctrl DirSocialDefeat_classic
States={'Sleep','Wake','NREM','REM'};

clear Prop
for exp=1:2
    if exp==1
        DIR = Dir_ctrl.path;
    elseif exp==2
        DIR = DirSocialDefeat_classic.path;
    end
    for mouse=1:length(DIR)
        cd(DIR{mouse}{1})
        
%         try
            load('SleepScoring_Accelero.mat', 'Info','Wake','Sleep','REMEpoch','SWSEpoch','Epoch')
%             Gamma_Thresh{mouse} = Info.gamma_thresh;
            FirstHourEpoch = intervalSet(0,90*60*1e4);
            Sto = Stop(Sleep);
%             FirstSleepHour = intervalSet(0, Sto(find(cumsum(DurationEpoch(Sleep)./(240*60*1e4))>1,1,'first')));
            SecondPhase = intervalSet(3*60*60*1e4,4*60*60*1e4);
            
            for state=1:length(States)
                if state==1 % sleep
                    Epoch_to_use{1} = Sleep;
                    Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                    Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                    Epoch_to_use{1} = and(Epoch_to_use{1} , FirstHourEpoch);
                    Epoch_to_use{2} = Epoch;
                    Epoch_to_use{2} = and(Epoch_to_use{2} , FirstHourEpoch);
                elseif state==2 % wake
                    Epoch_to_use{1} = Wake;
                    Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                    Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                    Epoch_to_use{1} = and(Epoch_to_use{1} , FirstHourEpoch);
                    Epoch_to_use{2} = Epoch;
                    Epoch_to_use{2} = and(Epoch_to_use{2} , FirstHourEpoch);
                    Epoch_to_use{3} = Sleep;
                    Epoch_to_use{3} = and(Epoch_to_use{3} , FirstHourEpoch);
                elseif state==3 % NREM
                    Epoch_to_use{1} = SWSEpoch;
                    Epoch_to_use{1} = and(Epoch_to_use{1} , FirstHourEpoch);
                    Epoch_to_use{2} = Sleep;
                    Epoch_to_use{2} = and(Epoch_to_use{2} , FirstHourEpoch);
                elseif state==4 % REM
                    Epoch_to_use{1} = REMEpoch;
                    Epoch_to_use{1} = and(Epoch_to_use{1} , SecondPhase);
                    %                             Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,90*60e4));
                    Epoch_to_use{2} = Epoch;
                    Epoch_to_use{2} = and(Epoch_to_use{2} , SecondPhase);
                    %                             Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,90*60e4));
                end
                Prop.(States{state}){exp}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
            end
            
%         end
        disp(DIR{mouse}{1})
    end
end
Prop.Wake{1}(Prop.Wake{1}==0)=NaN;
Prop.Wake{2}(Prop.Wake{2}==0)=NaN;
% Prop.REM{1}(or(isnan(Prop.Wake{1}) , Prop.Wake{1}>.8))=NaN;
% Prop.REM{2}(or(isnan(Prop.Wake{2}) , Prop.Wake{2}>.8))=NaN;
Prop.REM{1}(isnan(Prop.Wake{1}))=NaN;
Prop.REM{2}(isnan(Prop.Wake{2}))=NaN;

Cols={[.3 .3 .3],[.8 .3 .3]};
Legends={'Ctrl','SDS'};
X=1:2;


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Wake prop')
subplot(122)
MakeSpreadAndBoxPlot3_SB(Prop.REM,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM prop')



