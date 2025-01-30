
%% Drugs

clear all

SleepInfo = GetSleepSessions_Drugs_BM;

EpochName = {'Beginning','Just_Bef_Inj','Just_Aft_Inj','SleepPre','SleepPost','First_Sleep_Aft_Inj','FreezeAccEpoch','MovingEpoch','Pre','Post','Twenty_Bef_Inj','Twenty_Aft_Inj'};
% EpochName = {'Beginning','Just_Bef_Inj','Just_Aft_Inj','SleepPre','SleepPost','First_Sleep_Aft_Inj','MovingEpoch','Pre','Post'};

Drug = {'Saline','','','Nicotine'}

time_aft_inj = 10; % in minutes
smootime = 1;
interp_value = 100;

for drug=[1 4]
    for mouse=1:size(SleepInfo.path{drug},2)
        
        cd(SleepInfo.path{drug}{mouse})
        
        clear SmoothGamma SmoothAcc Smooth_HR SmoothSpeed Smooth_EMG ep FreezeAccEpoch OB_Sp_tsd HPC_Sp_tsd PFC_Sp_tsd HPC_VHigh_Sp_tsd FilLFP
        
        load('SleepScoring_OBGamma.mat', 'Epoch_Drugs', 'SmoothGamma', 'Sleep','Wake')
        % Gamma
        load('ChannelsToAnalyse/Bulb_deep.mat'); load(['LFPData/LFP' num2str(channel) '.mat'])
        FilGamma=FilterLFP(LFP,[50 70],1024);
        HilGamma=abs(hilbert(Data(FilGamma)));
        smooth_ghi=tsd(Range(FilGamma),runmean_BM(HilGamma,ceil(smootime/median(diff(Range(FilGamma,'s'))))));
        % Accelero
        load('behavResources.mat', 'MovAcctsd')
        SmoothAcc = tsd(Range(MovAcctsd),runmean_BM(Data(MovAcctsd),30));
        % Speed
        load('behavResources.mat', 'Vtsd')
        SmoothSpeed = tsd(Range(Vtsd) , runmean_BM(Data(Vtsd), ceil(smootime/median(diff(Range(Vtsd,'s'))))));
        % Ripples density
%         try
%             load('SWR.mat', 'ripples', 'RipplesEpoch'), load('LFPData/LFP0.mat')
%             tRipples = ts(ripples(:,2)*1e4);
%         catch
%             tRipples = [];
%         end
%         tRipples = ts(ripples(:,2)*1e4);
%         [Y,X] = hist(Range(tRipples,'s'),[0:1:max(Range(LFP,'s'))]);
%         Y = runmean(Y,3);
%         SmoothRipDensity = tsd(X'*1E4,Y');
        
        % OB Low
        load('B_Low_Spectrum.mat')
        OB_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
        
        Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Spectro{2}*1e4 , Spectro{1});
        Smooth_Respi = tsd(Range(Spectrum_Frequency),runmean_BM(Data(Spectrum_Frequency),ceil(smootime/median(diff(Range(Spectrum_Frequency,'s'))))));
        
        % HPC Low
        load('H_Low_Spectrum.mat')
        HPC_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
        
        % Epochs
        Beginning = intervalSet(0 , 10*60e4);
        
        Just_Bef_Inj = intervalSet(Stop(Epoch_Drugs{1})-600e4 , Stop(Epoch_Drugs{1}));
        Just_Aft_Inj = intervalSet(Start(Epoch_Drugs{2}) , Start(Epoch_Drugs{2})+60e4*time_aft_inj);
        
        Twenty_Bef_Inj = intervalSet(Stop(Epoch_Drugs{1})-1200e4 , Stop(Epoch_Drugs{1}));
        Twenty_Aft_Inj = intervalSet(Start(Epoch_Drugs{2}) , Start(Epoch_Drugs{2})+1200e4);
        
        
        SleepPre = and(Sleep ,Epoch_Drugs{1});
        SleepPost = and(Sleep , or(Epoch_Drugs{2} , Epoch_Drugs{3}));
        
        ep = find(DurationEpoch(SleepPost)>300e4, 1);
        First_Sleep_Aft_Inj = intervalSet(Start(subset(Sleep,ep)) , Start(subset(Sleep,ep))+300e4);
        
        
        %         Wake_Just_Aft_Inj = and(Wake , Just_Aft_Inj);
        %         FreezeAccEpoch=thresholdIntervals(Restrict(SmoothAcc,Wake_Just_Aft_Inj),1.7e7,'Direction','Below');
        %         FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        %         FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,2*1e4);
        %         MovingEpoch = Wake_Just_Aft_Inj-FreezeAccEpoch;
        
        FreezeAccEpoch=thresholdIntervals(SmoothAcc,1.7e7,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,2*1e4);
        FreezeAccEpoch = and(FreezeAccEpoch,Wake);
        MovingEpoch = Wake-FreezeAccEpoch;
        
        try
            FreezeEpochAcc.All{drug}(mouse) = FreezeAccEpoch;
        catch
            FreezeEpochAcc.All{drug}(mouse) = intervalSet([],[]);
        end
        
        %         FreezeAcc{mouse} = FreezeAccEpoch;
        
        for epoch = 1:length(EpochName)
            
            if epoch==1; Epoch_to_use = Beginning;
            elseif epoch==2; Epoch_to_use = Just_Bef_Inj;
            elseif epoch==3; Epoch_to_use = Just_Aft_Inj;
            elseif epoch==4; Epoch_to_use = SleepPre;
            elseif epoch==5; Epoch_to_use = SleepPost;
            elseif epoch==6; Epoch_to_use = First_Sleep_Aft_Inj;
            elseif epoch==7; Epoch_to_use = FreezeAccEpoch;
            elseif epoch==8; Epoch_to_use = MovingEpoch;
            elseif epoch==9; Epoch_to_use = Epoch_Drugs{1};
            elseif epoch==10; Epoch_to_use = Epoch_Drugs{2};
            end
            
            
            % Respi
            try
                Respi_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(Smooth_Respi , Epoch_to_use)))) , Data(Restrict(Smooth_Respi , Epoch_to_use)) , linspace(0,1,interp_value));
                Respi_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(Smooth_Respi , Epoch_to_use)));
            catch
                Respi_evol.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
                Respi_mean.(EpochName{epoch}){drug}(mouse) = NaN;
            end
%             % Ripples density
%             try
%                 RipDensity_evol.(EpochName{epoch}){drug}(mouse,:) = interp1(linspace(0,1,length(Data(Restrict(SmoothRipDensity , Epoch_to_use)))) , Data(Restrict(SmoothRipDensity , Epoch_to_use)) , linspace(0,1,interp_value));
%                 RipDensity_mean.(EpochName{epoch}){drug}(mouse) = nanmean(Data(Restrict(SmoothRipDensity , Epoch_to_use)));
%             catch
%                 RipDensity_evol.(EpochName{epoch}){drug}(mouse,:) = NaN(1,interp_value);
%                 RipDensity_mean.(EpochName{epoch}){drug}(mouse,:) = NaN;
%             end
%             % Ripples number
%             try
%                 RipDensity_numb.(EpochName{epoch}){drug}(mouse,:) = length(Start(and(RipplesEpoch , Epoch_to_use)));
%             catch
%                 RipDensity_numb.(EpochName{epoch}){drug}(mouse,:) = NaN;
%             end
            % OB Low
            try
                OB_Low.(EpochName{epoch}){drug}(mouse,:) = nanmean(Data(Restrict(OB_Sp_tsd , Epoch_to_use)));
            catch
                OB_Low.(EpochName{epoch}){drug}(mouse,:) = NaN(1,261);
            end
            
            Accelero.(EpochName{epoch}).(Drug{drug}){mouse} = Restrict(MovAcctsd,Epoch_to_use);
            
            try
                FzEpoch.(EpochName{epoch}){drug}(mouse) = and(Epoch_to_use,FreezeAccEpoch);
            catch
                FzEpoch.(EpochName{epoch}){drug}(mouse) = intervalSet([],[]);
            end
            
            % Freeze time
            FreezeTime.(EpochName{epoch}){drug}(mouse) = sum(DurationEpoch(FzEpoch.(EpochName{epoch}){drug}(mouse)))/60e4;
            
            try
                FreezeProp.(EpochName{epoch}){drug}(mouse) =  FreezeTime.(EpochName{epoch}){drug}(mouse)/ (sum(DurationEpoch(Epoch_to_use))/60e4);
            catch
                FreezeProp.(EpochName{epoch}){drug}(mouse) = 0;
            end
            
        end
        disp([num2str(mouse) ' ' num2str(drug)])
    end
end



for drug=[4]
    for mouse=1:size(SleepInfo.path{drug},2)
        for epoch = [2 3 9 10]
            
            if epoch==1; Epoch_to_use = Beginning;
            elseif epoch==2; Epoch_to_use = Just_Bef_Inj;
            elseif epoch==3; Epoch_to_use = Just_Aft_Inj;
            elseif epoch==4; Epoch_to_use = SleepPre;
            elseif epoch==5; Epoch_to_use = SleepPost;
            elseif epoch==6; Epoch_to_use = First_Sleep_Aft_Inj;
            elseif epoch==7; Epoch_to_use = FreezeAccEpoch;
            elseif epoch==8; Epoch_to_use = MovingEpoch;
            elseif epoch==9; Epoch_to_use = Epoch_Drugs{1};
            elseif epoch==10; Epoch_to_use = Epoch_Drugs{2};
            end
            
            MeanSpectroFz.(Name{drug}).(EpochName{epoch})(mouse,:) = nanmean(Data(SpectroBulbFz.(Name{drug}).(EpochName{epoch}){mouse}))
                        
        end
    end
end


%%


X=[1:2];
Legends={'Before Injection','After Injection'};
Cols={[0.3 0.3 0.3],[0.3 0.3 0.3]};

figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeTime.Just_Bef_Inj{1, 4} FreezeTime.Just_Aft_Inj{1, 4}},Cols,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
ylabel('time spent freezing (minutes)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Just_Bef_Inj{1, 4} FreezeProp.Just_Aft_Inj{1, 4}},Cols,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
ylabel('prop of freezing')

mtitle('freezing right before and after the injection')

%%

X=[1:2];
Legends={'Saline','Nicotine'};
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3]};

figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Just_Aft_Inj{1, 1} FreezeProp.Just_Aft_Inj{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('prop of freezing')
title('Right after')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Post{1, 1} FreezeProp.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('prop of freezing')
title('Whole post session')


mtitle('freezing right after the injection')

%%


X=[1:2];
Legends={'Saline','Nicotine'};
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3]};

figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeTime.Just_Aft_Inj{1, 1} FreezeTime.Just_Aft_Inj{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('freeze time (min)')
title('Right after')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeTime.Post{1, 1} FreezeTime.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('freeze time (min)')
title('Whole post session')


mtitle('freezing right after the injection')


%%
X=[1:2];
Legends={'Saline','Nicotine'};
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3]};

figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeTime.Post{1, 1} FreezeTime.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('time spent freezing (minutes)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Post{1, 1} FreezeProp.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('prop of freezing')

mtitle('freezing for the whole post session')


%%


X=[1:4];
Legends={'Saline','Nicotine','Saline','Nicotine'};
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[0.7 0.7 0.7],[0.3 0.3 0.3]};

figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeTime.Pre{1, 1} FreezeTime.Pre{1, 4} FreezeTime.Post{1, 1} FreezeTime.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('time spent freezing (minutes)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Pre{1, 1} FreezeProp.Pre{1, 4} FreezeProp.Post{1, 1} FreezeProp.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('prop of freezing')

mtitle('freezing for the whole post session')


%%


figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeTime.Pre{1, 4} FreezeTime.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
ylabel('time spent freezing (minutes)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Pre{1, 4} FreezeProp.Post{1, 4}  },Cols,X,Legends,'showpoints',1,'paired',1);
makepretty_CH
ylabel('prop of freezing')

mtitle('freezing for the whole session')



figure, hold on
for i = 1:11
    PlotPerAsLine(FreezeEpoch.Post{1, 4}(1, i) , 1, 'k', 'linewidth',1);
    ylim([0.5 1.5])
end
    
    
X=[1:2];
Legends={'Saline (n = 13)','Nicotine (n = 11)'};
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3]};
    


figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Post{1, 1} FreezeProp.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('prop of freezing')
title('whole session')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Just_Aft_Inj{1, 1} FreezeProp.Just_Aft_Inj{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('prop of freezing')
title('first 10 min')

mtitle('Proportion of freezing after Nicotine Injection')



    
X=[1:4];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post'};
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[0.7 0.7 0.7],[0.3 0.3 0.3]};
    

figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Pre{1, 1} FreezeProp.Post{1, 1} FreezeProp.Pre{1, 4} FreezeProp.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('prop of freezing')
title('whole session')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Just_Bef_Inj{1, 1} FreezeProp.Just_Aft_Inj{1, 1} FreezeProp.Just_Bef_Inj{1, 4} FreezeProp.Just_Aft_Inj{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0)
makepretty_CH
ylabel('prop of freezing')
title('10 min before or after')


    
X=[1:4];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post'};
Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[0.7 0.7 0.7],[0.3 0.3 0.3]};
    

figure('color',[1 1 1])

subplot(121)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Pre{1, 1} FreezeProp.Post{1, 1} FreezeProp.Pre{1, 4} FreezeProp.Post{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0);
makepretty_CH
ylabel('prop of freezing')
title('whole session')

subplot(122)
MakeSpreadAndBoxPlot3_SB({FreezeProp.Twenty_Bef_Inj{1, 1} FreezeProp.Twenty_Aft_Inj{1, 1} FreezeProp.Twenty_Bef_Inj{1, 4} FreezeProp.Twenty_Aft_Inj{1, 4}},Cols,X,Legends,'showpoints',1,'paired',0)
makepretty_CH
ylabel('prop of freezing')
title('10 min before or after')




figure
for mouse = 1:size(SleepInfo.path{4},2)
    subplot(11,1,mouse)
    plot(Range(Acctsd.Just_Bef_Inj.Nicotine{1,mouse}),Data(Acctsd.Just_Bef_Inj.Nicotine{1,mouse}),'b')
    hold on,     plot(Range(Acctsd.Just_Aft_Inj.Nicotine{1,mouse}),Data(Acctsd.Just_Aft_Inj.Nicotine{1,mouse}),'r')
    PlotPerAsLine(FreezeEpoch.All{1,4}(mouse) , 1e9, 'k', 'linewidth',2,'timescaling', 1);
    xlim([min(Range(Acctsd.Just_Bef_Inj.Nicotine{1,mouse})) max(Range(Acctsd.Just_Aft_Inj.Nicotine{1,mouse}))]);
end






Col4=[1 0.6 0];
Col3=[1 0.4 0];
Col2=[1 0.2 0];
Col1=[1 0 0];



figure, hold on

s1 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFz.Nicotine.twomin,'color',Col1);
s2 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFz.Nicotine.fourmin,'color',Col2);
s3 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFz.Nicotine.sixmin,'color',Col3);
s4 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFz.Nicotine.eightmin,'color',Col4);

    legend([s1.mainLine s2.mainLine s3.mainLine s4.mainLine],'0-2','2-4','4-6','6-8');
    
xlim([0 10])
makepretty



figure, hold on

s1 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzCorr.Nicotine.twomin,'color',Col1);
s2 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzCorr.Nicotine.fourmin,'color',Col2);
s3 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzCorr.Nicotine.sixmin,'color',Col3);
s4 = Plot_MeanSpectrumForMice_BM(MeanSpectroBulbFzCorr.Nicotine.eightmin,'color',Col4);

    legend([s1.mainLine s2.mainLine s3.mainLine s4.mainLine],'0-2','2-4','4-6','6-8');
    
xlim([0 10])
makepretty










