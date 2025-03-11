
clear all

DirAtropine = PathForExperimentsAtropine_MC('Atropine');
DirSaline = GetSleepSessions_Drugs_BM;


for drug=1:2
    for mouse=1:6
        
        if drug==1
            DIR = DirAtropine.path{mouse}{1};
        else
            DIR = DirSaline.path{1}{mouse};
        end
        load([DIR filesep 'SleepScoring_OBGamma.mat'], 'SmoothGamma')
        load([DIR filesep 'behavResources.mat'], 'MovAcctsd')
        try
            load([DIR filesep 'B_Middle_Spectrum.mat'])
            Range_Middle = Spectro{3};
        catch
            load([DIR filesep 'B_High_Spectrum.mat'])
            Range_High = Spectro{3};
        end
        
        Smooth_Acc = tsd(Range(MovAcctsd) , movmean(log10(Data(MovAcctsd)),30,'omitnan'));
        Moving = thresholdIntervals(Smooth_Acc , 7.2 , 'Direction' , 'Above');
        Moving = mergeCloseIntervals(Moving , 1e4);
        Moving = dropShortIntervals(Moving , 2e4);
        
        % epochs
        Before_Injection = intervalSet(0 , 13e7);
        After_Injection = intervalSet(15e7 , 32e7);
        
        % spectro
        B_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
        OB_Sp_Bef{drug}{mouse} = Restrict(B_Sptsd , Before_Injection);
        OB_Sp_Aft{drug}{mouse} = Restrict(B_Sptsd , After_Injection);
        
        % mean spectrum
        OB_MeanSp_Bef{drug}(mouse,:) = nanmean(Data(Restrict(OB_Sp_Bef{drug}{mouse} , Moving)));
        OB_MeanSp_Aft{drug}(mouse,:) = nanmean(Data(Restrict(OB_Sp_Aft{drug}{mouse} , Moving)));
        
        % mean values
        Acc_atrop_bef{drug}{mouse} = Data(Restrict(Smooth_Acc , Before_Injection));
        Acc_atrop_aft{drug}{mouse} = Data(Restrict(Smooth_Acc , After_Injection));
        Gamma_atrop_bef{drug}{mouse} = Data(Restrict(SmoothGamma , Before_Injection));
        Gamma_atrop_aft{drug}{mouse} = Data(Restrict(SmoothGamma , After_Injection));
        
        disp([drug mouse])
    end
end


%% figures
Cols = {[.3 .3 .3],[.3 1 .3]};
X = 1:2;
Legends = {'Saline','Atropine'};


figure
[~,MaxPowerValues1] = Plot_MeanSpectrumForMice_BM(Spectro{3}.*OB_MeanSp_Bef{1} , 'color' , 'k');
[~,MaxPowerValues2] = Plot_MeanSpectrumForMice_BM(Spectro{3}.*OB_MeanSp_Bef{2} , 'color' , 'k');
[~,MaxPowerValues3,Freq_Max1] = Plot_MeanSpectrumForMice_BM((Spectro{3}.*OB_MeanSp_Aft{1})./MaxPowerValues1');
[~,MaxPowerValues4,Freq_Max2] = Plot_MeanSpectrumForMice_BM((Spectro{3}.*OB_MeanSp_Aft{2})./MaxPowerValues2');
clf
subplot(1,4,1:2)
Plot_MeanSpectrumForMice_BM(Spectro{3}.*OB_MeanSp_Aft{1} , 'color' , 'g' , 'power_norm_value' , MaxPowerValues1);
Plot_MeanSpectrumForMice_BM(Spectro{3}.*OB_MeanSp_Aft{2} , 'color' , 'k' , 'power_norm_value' , MaxPowerValues2);
xlim([20 100]), ylim([0 1.2])
makepretty, axis square
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Atropine');

subplot(143)
MakeSpreadAndBoxPlot3_SB({MaxPowerValues4 MaxPowerValues3},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB gamma power (norm)')
makepretty_BM2

subplot(144)
MakeSpreadAndBoxPlot3_SB({Freq_Max2 Freq_Max1},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('OB gamma freq (Hz)')
makepretty_BM2



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Wake_prop_Aft_Inj{2} Wake_prop_Aft_Inj{1}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Wake proportion')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB({MeanAcc_Sleep_Aft_Inj{2} MeanAcc_Sleep_Aft_Inj{1}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Motion during sleep')
makepretty_BM2





%% tools

for drug=1:2
    figure
    for mouse=1:6
        subplot(6,2,(mouse-1)*2+1)
        try
            imagesc(Range(OB_Sp_Bef{drug}{mouse},'s')/60 , Range_Middle , runmean(runmean(log10(Range_Middle.*Data(OB_Sp_Bef{drug}{mouse})),1e3)',1)), axis xy, ylim([20 100]), caxis([4.5 5.5])
        catch
            imagesc(Range(OB_Sp_Bef{drug}{mouse},'s')/60 , Range_High , runmean(runmean(log10(Range_High.*Data(OB_Sp_Bef{drug}{mouse})),1e3)',1)), axis xy, ylim([20 100]), caxis([4.5 5.5])
        end
        hline(60,'-r')
        subplot(6,2,(mouse-1)*2+2)
        try
            imagesc(Range(OB_Sp_Aft{drug}{mouse},'s')/60 , Range_Middle , runmean(runmean(log10(Range_Middle.*Data(OB_Sp_Aft{drug}{mouse})),1e3)',1)), axis xy, ylim([20 100]), caxis([4.5 5.5])
        catch
            imagesc(Range(OB_Sp_Aft{drug}{mouse},'s')/60 , Range_High , runmean(runmean(log10(Range_High.*Data(OB_Sp_Aft{drug}{mouse})),1e3)',1)), axis xy, ylim([20 100]), caxis([4.5 5.5])
        end
        hline(60,'-r')
    end
end

for drug=1:2
    figure
    for mouse=1:6
        subplot(6,2,(mouse-1)*2+1)
        D = Acc_atrop_bef{drug}{mouse};
        [Y,X]=hist(D,1000);
        Y=Y/sum(Y);
        plot(X,Y), hold on
        D = Acc_atrop_aft{drug}{mouse};
        [Y,X]=hist(D,1000);
        Y=Y/sum(Y);
        plot(X,Y)
        
        subplot(6,2,(mouse-1)*2+2)
        D = log10(Gamma_atrop_bef{drug}{mouse});
        [Y,X]=hist(D,1000);
        Y=Y/sum(Y);
        plot(X,Y), hold on
        D = log10(Gamma_atrop_aft{drug}{mouse});
        [Y,X]=hist(D,1000);
        Y=Y/sum(Y);
        plot(X,Y)
    end
end



%% Open field test
clear all

for mouse=1:2
    if mouse==1
        M = '1500';
    elseif mouse==2
        M = '1533';
    end
    
    figure
    
    cd(['/media/nas7/Atropine/Mouse' M '/OF_Pre'])
    load('B_High_Spectrum.mat')
    B_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
    B_Sp_clean = CleanSpectro_BM(B_Sp_tsd,Spectro{3},7,.15);
    B_MeanSp_Bef(mouse,:) = nanmean(Data(B_Sp_clean));
    load('behavResources.mat', 'MovAcctsd')
    Smooth_Acc = tsd(Range(MovAcctsd) , movmean(log10(Data(MovAcctsd)),30,'omitnan'));
    
    subplot(231)
    imagesc(Range(B_Sp_clean,'s')/60 , Spectro{3} , runmean(runmean(log10(Spectro{3}.*Data(B_Sp_clean)),1e3)',1))
    axis xy, ylim([20 100]), caxis([4.5 5.2])
    subplot(234)
    plot(Range(Smooth_Acc,'s') , Data(Smooth_Acc))
    MeanAcc(1,mouse) = nanmean(Data(MovAcctsd));
    subplot(133)
    plot(Spectro{3} , B_MeanSp_Bef(mouse,:)), hold on
    
    cd(['/media/nas7/Atropine/Mouse' M '/OF_Post'])
    load('B_High_Spectrum.mat')
    B_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
    B_Sp_clean = CleanSpectro_BM(B_Sp_tsd,Spectro{3},7,.15);
    B_MeanSp_Aft(mouse,:) = nanmean(Data(B_Sp_clean));
    load('behavResources.mat', 'MovAcctsd')
    Smooth_Acc = tsd(Range(MovAcctsd) , movmean(log10(Data(MovAcctsd)),30,'omitnan'));
    
    subplot(232)
    imagesc(Range(B_Sp_clean,'s')/60 , Spectro{3} , runmean(runmean(log10(Spectro{3}.*Data(B_Sp_clean)),1e3)',1))
    axis xy, ylim([20 100]), caxis([4.5 5.2])
    subplot(235)
    plot(Range(Smooth_Acc,'s') , Data(Smooth_Acc))
    MeanAcc(2,mouse) = nanmean(Data(MovAcctsd));
    ylim([6 8.5])
    subplot(133)
    plot(Spectro{3} , B_MeanSp_Aft(mouse,:)), hold on
end


figure
subplot(121)
plot(Spectro{3} , B_MeanSp_Bef(1,:) , 'k')
hold on
plot(Spectro{3} , B_MeanSp_Aft(1,:) , 'g')
xlabel('Frequency (Hz)'), ylabel('PDF')
makepretty

subplot(122)
plot(Spectro{3} , movmean(B_MeanSp_Bef(2,:),3) , 'k')
hold on
plot(Spectro{3} , B_MeanSp_Aft(2,:) , 'g')
xlabel('Frequency (Hz)'), ylabel('PDF')
makepretty



%% EMG
clear all

DirAtropine = PathForExperimentsAtropine_MC('Atropine');
DirSaline = GetSleepSessions_Drugs_BM;
smootime = 3;


cd(DirAtropine.path{7}{1})
cd(DirAtropine.path{6}{1})


load('SleepScoring_OBGamma.mat', 'SmoothGamma')
load('behavResources.mat', 'MovAcctsd')
Smooth_Acc = tsd(Range(MovAcctsd) , movmean(log10(Data(MovAcctsd)),30,'omitnan'));

load('ChannelsToAnalyse/EMG.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
FilLFP=FilterLFP(LFP,[50 300],1024);
Smooth_EMG = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));

Before_Injection = intervalSet(0 , 13e7);
After_Injection = intervalSet(15e7 , 32e7);

% mean values
drug=1; mouse=1;
Acc_atrop_bef{drug}{mouse} = Data(Restrict(Smooth_Acc , Before_Injection));
Acc_atrop_aft{drug}{mouse} = Data(Restrict(Smooth_Acc , After_Injection));
Gamma_atrop_bef{drug}{mouse} = Data(Restrict(Restrict(SmoothGamma , Smooth_Acc) , Before_Injection));
Gamma_atrop_aft{drug}{mouse} = Data(Restrict(Restrict(SmoothGamma , Smooth_Acc) , After_Injection));
EMG_atrop_bef{drug}{mouse} = Data(Restrict(Restrict(Smooth_EMG , Smooth_Acc) , Before_Injection));
EMG_atrop_aft{drug}{mouse} = Data(Restrict(Restrict(Smooth_EMG , Smooth_Acc) , After_Injection));

        
figure
subplot(131)
D = Acc_atrop_bef{drug}{mouse};
[Y,X]=hist(D,1000);
Y=Y/sum(Y);
plot(X,Y), hold on
D = Acc_atrop_aft{drug}{mouse};
[Y,X]=hist(D,1000);
Y=Y/sum(Y);
plot(X,Y)

subplot(132)
D = log10(Gamma_atrop_bef{drug}{mouse});
[Y,X]=hist(D,1000);
Y=Y/sum(Y);
plot(X,Y), hold on
D = log10(Gamma_atrop_aft{drug}{mouse});
[Y,X]=hist(D,1000);
Y=Y/sum(Y);
plot(X,Y)

subplot(133)
D = log10(EMG_atrop_bef{drug}{mouse});
[Y,X]=hist(D,1000);
Y=Y/sum(Y);
plot(X,Y), hold on
D = log10(EMG_atrop_aft{drug}{mouse});
[Y,X]=hist(D,1000);
Y=Y/sum(Y);
plot(X,Y)


figure
subplot(121)
X = log10(EMG_atrop_bef{drug}{mouse});
Y = log10(Gamma_atrop_bef{drug}{mouse});
plot(X(1:500:end) , Y(1:500:end) , '.k'), hold on
X = log10(EMG_atrop_aft{drug}{mouse});
Y = log10(Gamma_atrop_aft{drug}{mouse});
plot(X(1:500:end) , Y(1:500:end) , '.g')
axis square
xlabel('EMG power (log)'), ylabel('OB gamma power (log)')
makepretty_BM2
legend('Before atropine','After atropine')

subplot(122)
X = log10(EMG_atrop_bef{drug}{mouse});
Y = log10(Gamma_atrop_bef{drug}{mouse});
plot(X(1:500:end) , Y(1:500:end) , '.k'), hold on
X = log10(EMG_atrop_aft{drug}{mouse});
Y = log10(Gamma_atrop_aft{drug}{mouse});
plot(X(1:500:end) , Y(1:500:end) , '.g')
axis square
xlabel('EMG power (log)'), ylabel('OB gamma power (log)')
makepretty_BM2

