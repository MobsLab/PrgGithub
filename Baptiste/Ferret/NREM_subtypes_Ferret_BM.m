

clear all

cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20241211_TORCs/')
cd('/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240123_long/')
cd('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long/')


%%
smootime = 10;
Frequency_HPC = {[.2 2.8],[2.8 6]};
Frequency_OB = {[.5 4]};
LineHeight = 9.5;
Cols={[0 0 1],[.8 .5 .2],[1 0 0],[0 1 0]};
Colors.N1 = [.8 .5 .2];
Colors.N2 = [1 0 0];
Colors.REM = 'g';
Colors.Wake = 'b';
Colors.Noise = 'k';
c = [2 4];

%% define epochs
load('SleepScoring_OBGamma.mat', 'Sleep', 'Wake', 'Epoch', 'TotalNoiseEpoch', 'SWSEpoch', 'REMEpoch')
% load('SleepScoring_OBGamma.mat', 'Sleep', 'Wake', 'Epoch', 'TotalNoiseEpoch', 'SmoothTheta', 'SWSEpoch', 'Info', 'ThetaEpoch', 'REMEpoch')


% N1-N2
load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP = Restrict(LFP , SWSEpoch);
FilDelta = FilterLFP(LFP,Frequency_OB{1},1024);
hilbert_delta = abs(hilbert(Data(FilDelta)));
SmoothDelta_OB = tsd(Range(LFP),runmean(hilbert_delta,ceil(smootime/median(diff(Range(LFP,'s'))))));


figure
gamma_thresh = GetGaussianThresh_BM(log10(Data(SmoothDelta_OB)), 0, 1);
makepretty


N1 = and(thresholdIntervals(SmoothDelta_OB , 10^gamma_thresh , 'Direction' , 'Below') , SWSEpoch);
N2 = SWSEpoch-N1;

N1 = mergeCloseIntervals(N1 , 2e4);
N1 = dropShortIntervals(N1 , 2e4);
N2 = mergeCloseIntervals(N2 , 2e4);
N2 = dropShortIntervals(N2 , 2e4);

N1 = N1-or(Wake , TotalNoiseEpoch);
N2 = N2-or(Wake , TotalNoiseEpoch);

%% Spectro
for m=1:4
    try
        if m==1
            load('H_Low_Spectrum.mat')
            Range_Low = Spectro{3};
        elseif m==2
            load('B_Low_Spectrum.mat')
        elseif m==3
            load('PFCx_Low_Spectrum.mat')
        elseif m==4
            load('AuCx_Low_Spectrum.mat')
        end
        
        Sptsd{m} = tsd(Spectro{2}*1e4 , Spectro{1});
        for states=1:4
            if states==1
                State = Wake;
            elseif states==2
                State = N1;
            elseif states==3
                State = N2;
            elseif states==4
                State = REMEpoch;
            end
            
            Dur_State(states) = sum(DurationEpoch(State))/3600e4;
            
            Sp_ByState{m}{states} = Restrict(Sptsd{m} , and(State,Epoch)-TotalNoiseEpoch);
            if m<5
                if states==1
                    Sp_ByState_clean{m}{states} = CleanSpectro(Sp_ByState{m}{states} , Range_Low , 8);
                    Mean_Spec{m}(states,:) = nanmean(Data(Sp_ByState_clean{m}{states}));
                else
                    Mean_Spec{m}(states,:) = nanmean(Data(Sp_ByState{m}{states}));
                end
            end
        end
    end
end


Wake = or(Wake , TotalNoiseEpoch);


%%
figure
subplot(441)
imagesc(Range(Sptsd{1})/3.6e7 , Range_Low , runmean(runmean(log10(Data(Sptsd{1})'),2)',100)'), axis xy
ylabel('Frequency_a_l_l (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis(c)
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(N1,LineHeight,Colors.N1,'timescaling',3.6e7);
PlotPerAsLine(N2,LineHeight,Colors.N2,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('HPC')
makepretty_BM2

subplot(445)
imagesc(linspace(0,Dur_State(2),length(Sp_ByState{1}{2})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{1}{2})'),2)',100)'), axis xy
ylabel('Frequency_N_1 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis(c)
makepretty_BM2

subplot(449)
imagesc(linspace(0,Dur_State(3),length(Sp_ByState{1}{3})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{1}{3})'),2)',100)'), axis xy
ylabel('Frequency_N_2 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis(c)
makepretty_BM2

subplot(4,4,13)
imagesc(linspace(0,Dur_State(4),length(Sp_ByState{1}{4})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{1}{4})'),2)',100)'), axis xy
ylabel('Frequency_R_E_M (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis(c)
makepretty_BM2


subplot(442)
imagesc(Range(Sptsd{1})/3.6e7 , Range_Low , runmean(runmean(log10(Data(Sptsd{2})'),2)',100)'), axis xy
ylabel('Frequency_a_l_l (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis(c)
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(N1,LineHeight,Colors.N1,'timescaling',3.6e7);
PlotPerAsLine(N2,LineHeight,Colors.N2,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('OB')
makepretty_BM2

subplot(446)
imagesc(linspace(0,Dur_State(2),length(Sp_ByState{2}{2})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{2}{2})'),2)',100)'), axis xy
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis(c)
makepretty_BM2

subplot(4,4,10)
imagesc(linspace(0,Dur_State(3),length(Sp_ByState{2}{3})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{2}{3})'),2)',100)'), axis xy
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis(c)
makepretty_BM2

subplot(4,4,14)
imagesc(linspace(0,Dur_State(4),length(Sp_ByState{2}{4})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{2}{4})'),2)',100)'), axis xy
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis(c)
makepretty_BM2




figure
subplot(121)
for st=2:4
    plot(Range_Low , Mean_Spec{1}(st,:) , 'Color' , Cols{st}), hold on
end
xlabel('Frequency (Hz)'), xlim([0 10])
makepretty

subplot(122)
for st=2:4
    plot(Range_Low , Mean_Spec{2}(st,:) , 'Color' , Cols{st}), hold on
end
xlabel('Frequency (Hz)'), xlim([0 10])
makepretty

a=suptitle('Brynza'); a.FontSize=20;
a=suptitle('Shropshire'); a.FontSize=20;
a=suptitle('Labneh'); a.FontSize=20;



