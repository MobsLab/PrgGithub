
clear all

Dir1 = PathForExperimentsOB({'Labneh'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Labneh'}, 'freely-moving','none');
Dir{1} = MergePathForExperiment(Dir1,Dir2);

Dir1 = PathForExperimentsOB({'Brynza'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Brynza'}, 'freely-moving','none');
Dir{2} = MergePathForExperiment(Dir1,Dir2);

Dir1 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','saline');
Dir2 = PathForExperimentsOB({'Shropshire'}, 'freely-moving','none');
Dir{3} = MergePathForExperiment(Dir1,Dir2);

%%
for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'],'Epoch','TotalNoiseEpoch','Sleep',...
            'Wake', 'SWSEpoch', 'REMEpoch', 'Epoch_01_05')
        if sum(DurationEpoch(SWSEpoch))/3600e4>1
            
            N1 = SWSEpoch-Epoch_01_05;
            N2 = and(SWSEpoch , Epoch_01_05);
            TotEpoch = or(Epoch , TotalNoiseEpoch);
            [REMEpoch, N2, N1, Wake] = cleanSleepStates_BM(REMEpoch, N2, N1, Wake, TotEpoch);
            CleanStates.Wake = Wake;
            CleanStates.N1 = N1;
            CleanStates.N2 = N2;
            CleanStates.REM = REMEpoch;
            CleanStates.Sleep = or(or(REMEpoch , N1) , N2);
            
            for m=1:8
                try
                    if m==1
                        load([Dir{ferret}.path{sess} filesep 'B_Low_Spectrum.mat'])
                        RANGE = Spectro{3};
                        Range_Low = Spectro{3};
                    elseif m==2
                        load([Dir{ferret}.path{sess} filesep 'PFCx_Low_Spectrum.mat'])
                    elseif m==3
                        load([Dir{ferret}.path{sess} filesep 'H_Low_Spectrum.mat'])
                    elseif m==4
                        load([Dir{ferret}.path{sess} filesep 'AuCx_Low_Spectrum.mat'])
                    elseif m==5
                        load([Dir{ferret}.path{sess} filesep 'B_Middle_Spectrum.mat'])
                        RANGE = Spectro{3};
                        Range_Middle = Spectro{3};
                    elseif m==6
                        load([Dir{ferret}.path{sess} filesep 'PFCx_Middle_Spectrum.mat'])
                    elseif m==7
                        load([Dir{ferret}.path{sess} filesep 'H_Middle_Spectrum.mat'])
                    elseif m==8
                        load([Dir{ferret}.path{sess} filesep 'AuCx_Middle_Spectrum.mat'])
                    end
                    
                    Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
                    for states=1:4
                        if states==1
                            State = CleanStates.Wake;
                        elseif states==2
                            State = CleanStates.N1;
                        elseif states==3
                            State = CleanStates.N2;
                        elseif states==4
                            State = CleanStates.REM;
                        end
                        
                        Sp_ByState = Restrict(Sptsd , and(State,Epoch)-TotalNoiseEpoch);
                        if m<5
                            if states==1
                                Sp_ByState_clean = CleanSpectro(Sp_ByState , RANGE , 8);
                                Mean_Spec{ferret}{sess}{m}(states,:) = nanmean(Data(Sp_ByState_clean));
                            else
                                Mean_Spec{ferret}{sess}{m}(states,:) = nanmean(Data(Sp_ByState));
                            end
                        else
                            Mean_Spec{ferret}{sess}{m}(states,:) = nanmean(log10(Data(Sp_ByState)));
                        end
                    end
                end
            end
            clear Sptsd Sp_ByState Sp_ByState_clean
            
            disp(sess)
        end
    end
end

for ferret=1:3
    for m=1:8
        for states=1:4
            for sess=1:length(Dir{ferret}.path)
                try
                    Mean_Spec_all{ferret}{m}{states}(sess,:) = Mean_Spec{ferret}{sess}{m}(states,:);
                end
            end
            try, Mean_Spec_all{ferret}{m}{states}(Mean_Spec_all{ferret}{m}{states}==0) = NaN; end
        end
    end
end

Mean_Spec_all{ferret}{4}{1}(8,:) = NaN;
ferret=2; states=1; sess=5;
for m=1:4
    Mean_Spec_all{ferret}{m}{states}(sess,:) = NaN;
end

%% figures
Cols={[0 0 1],[1 .5 0],[1 0 0],[0 1 0]};
ferret=3;

figure
for m=1:3
    subplot(1,3,m)
    for states=1:4
        
        Data_to_use = Mean_Spec_all{ferret}{m}{states};
        Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
        h=shadedErrorBar(Range_Low , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
        color= Cols{states}; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
        
    end
    xlabel('Frequency (Hz)')
    if m==1; ylabel('Power (a.u.)'), f=get(gca,'Children'); legend([f(7),f(5),f(3),f(1)],'Wake','IS','NREM','REM'); elseif m==5, ylabel('power (log scale)'), end
    if m==1, title('OB'), end
    if m==2, title('PFC'), end
    if m==3, title('HPC'), end
    xlim([0 10])
    makepretty
end

figure, m = 5;
for states=1:4
    Data_to_use = log10(Mean_Spec_all{ferret}{m}{states});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(Range_Middle , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
    color= Cols{states}; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
end
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([20 100])
    makepretty


%% spectrogram
% 
% cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240202_saline/')
% load('SleepScoring_OBGamma.mat','Wake', 'Sleep', 'SWSEpoch', 'REMEpoch')
% 
% H_Low = load('H_Low_Spectrum.mat');
% H_Low_Sptsd = tsd(H_Low.Spectro{2}*1e4 , H_Low.Spectro{1});
% H_Low_Sptsd_Sleep = Restrict(H_Low_Sptsd , Sleep);
% H_Low_Sptsd_NREM = Restrict(H_Low_Sptsd , SWSEpoch);
% 
% B_Low = load('B_Low_Spectrum.mat');
% B_Low_Sptsd = tsd(B_Low.Spectro{2}*1e4 , B_Low.Spectro{1});
% B_Low_Sptsd_Sleep = Restrict(B_Low_Sptsd , Sleep);
% B_Low_Sptsd_NREM = Restrict(B_Low_Sptsd , SWSEpoch);
% 
% B_UltraLow = load('B_UltraLow_Spectrum.mat');
% B_UltraLow_Sptsd = tsd(B_UltraLow.Spectro{2}*1e4 , B_UltraLow.Spectro{1});
% B_UltraLow_Sptsd_Sleep = Restrict(B_UltraLow_Sptsd , Sleep);
% B_UltraLow_Sptsd_NREM = Restrict(B_UltraLow_Sptsd , SWSEpoch);
% 
% B_High = load('B_Middle_Spectrum.mat');
% B_High_Sptsd = tsd(B_High.Spectro{2}*1e4 , B_High.Spectro{1});
% B_High_Sptsd_Sleep = Restrict(B_High_Sptsd , Sleep);
% B_High_Sptsd_NREM = Restrict(B_High_Sptsd , SWSEpoch);
% 
% P_Low = load('PFCx_Low_Spectrum.mat');
% P_Low_Sptsd = tsd(P_Low.Spectro{2}*1e4 , P_Low.Spectro{1});
% P_Low_Sptsd_Sleep = Restrict(P_Low_Sptsd , Sleep);
% P_Low_Sptsd_NREM = Restrict(P_Low_Sptsd , SWSEpoch);
% 
% 
% load('B_Low_Spectrum.mat')
% 
% 
% 
% figure
% subplot(511)
% imagesc(B_High.Spectro{2}/60 , B_High.Spectro{3} , runmean(runmean(log10(B_High.Spectro{1}'),1)',1e2)'), axis xy
% ylim([20 100]), caxis([1.8 4])
% colormap jet
% PlotPerAsLine(Wake,95,'b','timescaling',60e4);
% PlotPerAsLine(SWSEpoch,95,'r','timescaling',60e4);
% PlotPerAsLine(REMEpoch,95,'g','timescaling',60e4);
% 
% subplot(512)
% imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10(H_Low.Spectro{1}'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([1.5 4])
% 
% subplot(513)
% imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10(P_Low.Spectro{1}'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([1.5 4])
% 
% subplot(514)
% imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10(B_Low.Spectro{1}'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([2.5 4])
% 
% subplot(515)
% imagesc(Spectro{2}/60 , Spectro{3} , runmean(runmean(log10(B_UltraLow.Spectro{1}'),1)',15)'), axis xy
% caxis([1.8 4])
% 
% 
% 
% figure
% subplot(511)
% imagesc(Range(B_High_Sptsd_Sleep,'s')/60 , B_High.Spectro{3} , runmean(runmean(log10(Data(B_High_Sptsd_Sleep)'),1)',1e2)'), axis xy
% ylim([20 100]), caxis([1.8 4])
% colormap jet
% 
% subplot(512)
% imagesc(Range(H_Low_Sptsd_Sleep,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(H_Low_Sptsd_Sleep)'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([1.5 4.5])
% 
% subplot(513)
% imagesc(Range(P_Low_Sptsd_Sleep,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(P_Low_Sptsd_Sleep)'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([1.5 4])
% 
% subplot(514)
% imagesc(Range(B_Low_Sptsd_Sleep,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(B_Low_Sptsd_Sleep)'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([2.5 4])
% 
% subplot(515)
% imagesc(Range(B_UltraLow_Sptsd_Sleep,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(B_UltraLow_Sptsd_Sleep)'),1)',15)'), axis xy
% caxis([1.8 4])
% 
% 
% 
% 
% figure
% subplot(511)
% imagesc(Range(B_High_Sptsd_NREM,'s')/60 , B_High.Spectro{3} , runmean(runmean(log10(Data(B_High_Sptsd_NREM)'),1)',1e2)'), axis xy
% ylim([20 100]), caxis([1.8 4])
% colormap jet
% 
% subplot(512)
% imagesc(Range(H_Low_Sptsd_NREM,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(H_Low_Sptsd_NREM)'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([1.5 4.5])
% 
% subplot(513)
% imagesc(Range(P_Low_Sptsd_NREM,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(P_Low_Sptsd_NREM)'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([1.5 4])
% 
% subplot(514)
% imagesc(Range(B_Low_Sptsd_NREM,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(B_Low_Sptsd_NREM)'),1)',1e2)'), axis xy
% ylim([0 10]), caxis([2.5 4])
% 
% subplot(515)
% imagesc(Range(B_UltraLow_Sptsd_NREM,'s')/60 , Spectro{3} , runmean(runmean(log10(Data(B_UltraLow_Sptsd_NREM)'),1)',15)'), axis xy
% caxis([1.8 4])
% 
% 
% 
