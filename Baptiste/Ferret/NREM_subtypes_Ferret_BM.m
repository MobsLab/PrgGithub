
cd('/media/nas8/OB_ferret_AG_BM/Shropshire/freely-moving/20250107_LSP_saline')

for m=1:8
    try
        
        for states=1:4
            if states==1
                State = Wake;
            elseif states==2
                State = SWSEpoch-Epoch_01_05;
            elseif states==3
                State = and(SWSEpoch , Epoch_01_05);
            elseif states==4
                State = REMEpoch;
            end
            
            Sp_ByState{m}{states} = Restrict(Sptsd{m} , and(State,Epoch)-TotalNoiseEpoch);
            
        end
    end
end


smootime = 10;
load('ChannelsToAnalyse/dHPC_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])

LFP = Restrict(LFP , SWSEpoch);
Frequency = {[.2 2.8],[2.8 5.5]};
FilDelta = FilterLFP(LFP,Frequency{1},1024);
FilTheta = FilterLFP(LFP,Frequency{2},1024);
hilbert_delta = abs(hilbert(Data(FilDelta)));
hilbert_theta = abs(hilbert(Data(FilTheta)));
hilbert_delta(hilbert_delta>3e3) = 3e3;   
hilbert_theta(hilbert_theta>1.2e3) = 1.2e3;
delta_ratio = hilbert_delta./hilbert_theta;
DeltaRatioTSD = tsd(Range(FilTheta), delta_ratio);
SmoothDelta = tsd(Range(DeltaRatioTSD),runmean(Data(DeltaRatioTSD),ceil(20/median(diff(Range(DeltaRatioTSD,'s'))))));


N1 = and(SWSEpoch , thresholdIntervals(SmoothDeltaOB , 10^2.722 , 'Direction' , 'Below'));
N2 = and(SWSEpoch , thresholdIntervals(SmoothDeltaOB , 10^2.722 , 'Direction' , 'Above'));



figure
[Y,X]=hist(log10(Data(Restrict(SmoothDelta , N2))),1000);
Y=runmean(Y,5)/sum(Y);
plot(X,runmean(Y,5) , 'k')
makepretty
xlabel('theta2/delta2 HPC, N2 (log)')
ylabel('PDF')
axis square
xlim([-.15 .65])
v=vline(.3,'-r'); v.LineWidth=5;


N2_n = and(N2 , thresholdIntervals(SmoothTheta2 , 10^.3 , 'Direction' , 'Below'));
N3 = and(N2 , thresholdIntervals(SmoothTheta2 , 10^.3 , 'Direction' , 'Above'));






figure
m=1;
subplot(421)
imagesc(linspace(0,sum(DurationEpoch(N1))./60e4,length(Restrict(Sptsd{m} , N1))) , Range_Low , runmean(runmean(log10(Data(Restrict(Sptsd{m} , N1))'),2)',100)'), axis xy
ylabel('N1'), title('OB'), caxis([3 5.5])
makepretty

subplot(423)
imagesc(linspace(0,sum(DurationEpoch(N2_n))./60e4,length(Restrict(Sptsd{m} , N2_n))) , Range_Low , runmean(runmean(log10(Data(Restrict(Sptsd{m} , N2_n))'),2)',100)'), axis xy
ylabel('N2'), caxis([3 5.5])
makepretty

subplot(425)
imagesc(linspace(0,sum(DurationEpoch(N3))./60e4,length(Restrict(Sptsd{m} , N3))) , Range_Low , runmean(runmean(log10(Data(Restrict(Sptsd{m} , N3))'),2)',100)'), axis xy
ylabel('N3'), caxis([3 5.5])
makepretty

subplot(427)
imagesc(linspace(0,sum(DurationEpoch(REMEpoch))./60e4,length(Restrict(Sptsd{m} , REMEpoch))) , Range_Low , runmean(runmean(log10(Data(Restrict(Sptsd{m} , REMEpoch))'),2)',100)'), axis xy
xlabel('time (min)'), ylabel('REM'), caxis([3 5.5])
makepretty


m=3;
subplot(422)
imagesc(linspace(0,sum(DurationEpoch(N1))./60e4,length(Restrict(Sptsd{m} , N1))) , Range_Low , runmean(runmean(log10(Data(Restrict(Sptsd{m} , N1))'),2)',100)'), axis xy
title('HPC'), caxis([3 5.5])
makepretty

subplot(424)
imagesc(linspace(0,sum(DurationEpoch(N2_n))./60e4,length(Restrict(Sptsd{m} , N2_n))) , Range_Low , runmean(runmean(log10(Data(Restrict(Sptsd{m} , N2_n))'),2)',100)'), axis xy
caxis([3 5.5])
makepretty

subplot(426)
imagesc(linspace(0,sum(DurationEpoch(N3))./60e4,length(Restrict(Sptsd{m} , N3))) , Range_Low , runmean(runmean(log10(Data(Restrict(Sptsd{m} , N3))'),2)',100)'), axis xy
caxis([3 5.5])
makepretty

subplot(428)
imagesc(linspace(0,sum(DurationEpoch(REMEpoch))./60e4,length(Restrict(Sptsd{m} , REMEpoch))) , Range_Low , runmean(runmean(log10(Data(Restrict(Sptsd{m} , REMEpoch))'),2)',100)'), axis xy
caxis([3 5.5])
xlabel('time (min)')
makepretty


Cols = {[.8 .5 .2],[1 0 0],[.8 .2 .2],[0 1 0]};

figure
subplot(221), m=1;
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N1)) ), 'Color' , Cols{1})
hold on
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N2_n)) ), 'Color' , Cols{2})
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N3)) ), 'Color' , Cols{3})
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , REMEpoch)) ), 'Color' , Cols{4})
ylabel('Power (a.u.)'), xlim([0 10])
legend('N1','N2','N3','REM');
title('OB')
makepretty

subplot(222), m=3;
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N1)) ), 'Color' , Cols{1})
hold on
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N2_n)) ), 'Color' , Cols{2})
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N3)) ), 'Color' , Cols{3})
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , REMEpoch)) ), 'Color' , Cols{4})
xlim([0 10])
title('HPC')
makepretty

subplot(223), m=2;
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N1)) ), 'Color' , Cols{1})
hold on
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N2_n)) ), 'Color' , Cols{2})
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N3)) ), 'Color' , Cols{3})
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , REMEpoch)) ), 'Color' , Cols{4})
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([0 10])
title('PFC')
makepretty

subplot(224), m=4;
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N1)) ), 'Color' , Cols{1})
hold on
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N2_n)) ), 'Color' , Cols{2})
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , N3)) ), 'Color' , Cols{3})
plot(Range_Low , nanmean(Data(Restrict(Sptsd{m} , REMEpoch)) ), 'Color' , Cols{4})
xlabel('Frequency (Hz)'), xlim([0 10])
title('AuC')
makepretty



load('ChannelsToAnalyse/Bulb_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
LFP = tsd(Range(LFP) , Data(LFP));
Fil_Delta = FilterLFP(Restrict(LFP , Sleep),[.5 4],1024);
tEnveloppe = tsd(Range(Fil_Delta), abs(hilbert(Data(Fil_Delta))) );
SmoothDeltaOB  = tsd(Range(tEnveloppe), runmean(Data(tEnveloppe), ...
    ceil(smootime/median(diff(Range(tEnveloppe,'s'))))));

figure
[Y,X]=hist(log10(Data(Restrict(SmoothDeltaOB , SWSEpoch))),1000);
Y=runmean(Y,5)/sum(Y);
plot(X,runmean(Y,5) , 'k')
makepretty

N1 = and(SWSEpoch , thresholdIntervals(SmoothDeltaOB , 10^2.722 , 'Direction' , 'Below'));
N2 = and(SWSEpoch , thresholdIntervals(SmoothDeltaOB , 10^2.722 , 'Direction' , 'Above'));





%%



for ferret=1:3
    for sess=1:length(Dir{ferret}.path)
        load([Dir{ferret}.path{sess} filesep 'SleepScoring_OBGamma.mat'],'Epoch','TotalNoiseEpoch','Sleep',...
            'Wake', 'SWSEpoch', 'REMEpoch', 'Epoch_01_05')
        if sum(DurationEpoch(SWSEpoch))/3600e4>1
            
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
                    
                    
                    Sptsd{m} = tsd(Spectro{2}*1e4 , Spectro{1});
                    for states=1:4
                        if states==1
                            State = Wake;
                        elseif states==2
                            State = SWSEpoch-Epoch_01_05;
                        elseif states==3
                            State = and(SWSEpoch , Epoch_01_05);
                        elseif states==4
                            State = REMEpoch;
                        end
                        
                        Dur_State(state) = sum(DurationEpoch(State))/3600e4;

                        Sp_ByState{m}{states} = Restrict(Sptsd{m} , and(State,Epoch)-TotalNoiseEpoch);
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





figure
subplot(421)
imagesc(Range(Sptsd{3})/3.6e7 , Range_Low , runmean(runmean(log10(Data(Sptsd{3})'),2)',100)'), axis xy
ylabel('Frequency_a_l_l (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5.5])
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('HPC')
makepretty_BM2

subplot(423)
imagesc(linspace(0,Dur_State(2),length(Sp_ByState{3}{2})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{3}{2})'),2)',100)'), axis xy
ylabel('Frequency_R_E_M (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5.5])
makepretty_BM2

subplot(425)
imagesc(linspace(0,Dur_State(3),length(Sp_ByState{3}{3})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{3}{3})'),2)',100)'), axis xy
ylabel('Frequency_N_1 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5.5])
makepretty_BM2

subplot(427)
imagesc(linspace(0,Dur_REM,length(Sp_ByState{3}{4})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{3}{4})'),2)',100)'), axis xy
ylabel('Frequency_N_2 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5.5])
makepretty_BM2


subplot(422)
imagesc(Range(Sptsd{1})/3.6e7 , Range_Low , runmean(runmean(log10(Data(Sptsd{1})'),2)',100)'), axis xy
ylabel('Frequency_a_l_l (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5.5])
PlotPerAsLine(Wake,LineHeight,Colors.Wake,'timescaling',3.6e7);
PlotPerAsLine(SWSEpoch,LineHeight,Colors.SWS,'timescaling',3.6e7);
PlotPerAsLine(REMEpoch,LineHeight,Colors.REM,'timescaling',3.6e7);
title('OB')
makepretty_BM2

subplot(424)
imagesc(linspace(0,Dur_State(2),length(Sp_ByState{1}{2})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{1}{2})'),2)',100)'), axis xy
ylabel('Frequency_R_E_M (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5.5])
makepretty_BM2

subplot(426)
imagesc(linspace(0,Dur_State(2),length(Sp_ByState{1}{3})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{1}{3})'),2)',100)'), axis xy
ylabel('Frequency_N_1 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5.5])
makepretty_BM2

subplot(428)
imagesc(linspace(0,Dur_State(2),length(Sp_ByState{1}{4})) , Range_Low , runmean(runmean(log10(Data(Sp_ByState{1}{4})'),2)',100)'), axis xy
ylabel('Frequency_N_2 (Hz)')
colormap jet, ylim([0 10]), hline([4 6],'--r'), caxis([3 5.5])
makepretty_BM2








