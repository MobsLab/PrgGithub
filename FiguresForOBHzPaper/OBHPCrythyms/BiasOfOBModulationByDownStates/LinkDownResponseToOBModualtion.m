load('SpikeData.mat')
load('DownState.mat')

for sp = 1:length(S)
[C(sp,:), B] = CrossCorr(Stop(down_PFCx,'s'),Range(S{sp},'s'),0.001,200);
end

DatMat = zscore(C(:,101:end)')';

for sp = 1:length(S)
[C(sp,:), B] = CrossCorr(Start(down_PFCx,'s'),Range(S{sp},'s'),0.001,200);
end

DatMat = zscore(C(:,1:101)')';

[EigVect,EigVals]=PerformPCA(DatMat);

load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N3_LocalBulb_left_ActivitySpike.mat')
HSOB = HS;
ModInfoOB = ModInfo;
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N3_LFP28Spike.mat')
clf
for eig = 1:3
    
    subplot(3,5,(eig-1)*5+1)
    plot(DatMat'*EigVect(:,eig))
    [val,ind] = sort(EigVect(:,eig));
    
    subplot(3,5,(eig-1)*5+2)
    HS_Moy = zeros(18,40);
    for i = 1:length(S)
        HS_Moy = HS_Moy + (HS{i}./nanmedian(HS{i})).*EigVect(i,eig);
    end
    imagesc(HS_Moy), axis xy, colorbar
        
    subplot(3,5,(eig-1)*5+3)
    plot(zscore(ModInfo.mu.Transf(1,ind))), hold on
    plot(zscore(ModInfo.mu.Transf(2,ind)))
    plot(zscore(ModInfo.mu.Transf(3,ind)))

    subplot(3,5,(eig-1)*5+4)
    HS_Moy = zeros(18,40);
    for i = 1:length(S)
        HS_Moy = HS_Moy + (HSOB{i}./nanmedian(HSOB{i})).*EigVect(i,eig);
    end
    imagesc(HS_Moy), axis xy, colorbar

        subplot(3,5,(eig-1)*5+5)
    plot(zscore(ModInfoOB.mu.Transf(1,ind))), hold on
    plot(zscore(ModInfoOB.mu.Transf(2,ind)))
    plot(zscore(ModInfoOB.mu.Transf(3,ind)))

end

figure
WhicFreq = 2;
PLim = 0.001;
clf
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N3_LocalBulb_left_ActivitySpike.mat','ModInfo')
subplot(4,6,[1,7,13])
imagesc(B(101:end),1:187,sortrows([ModInfo.pval.Transf(WhicFreq,:);SmoothDec(DatMat,[0.01 1])']'))
line([0.08 0.08],[0 1]*sum(ModInfo.pval.Transf(WhicFreq,:)<PLim),'linewidth',3)
title('N3')
ylabel('Num of Neurons')
xlabel('time since down (ms)')
subplot(4,6,19)
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)>PLim,:)),'b')
hold on
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)<PLim,:)),'r')
xlabel('time since down (ms)')
ylabel('FR zscore')
ylim([-2 4])
legend('NoSig','Sig')

load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N2_LocalBulb_left_ActivitySpike.mat','ModInfo')
subplot(4,6,[1,7,13]+1)
imagesc(sortrows([ModInfo.pval.Transf(WhicFreq,:);SmoothDec(DatMat,[0.01 1])']'))
line([80 80],[0 1]*sum(ModInfo.pval.Transf(WhicFreq,:)<PLim),'linewidth',3)
title('N2')
ylabel('Num of Neurons')
xlabel('time since down (ms)')
subplot(4,6,19+1)
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)>PLim,:)),'b')
hold on
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)<PLim,:)),'r')
xlabel('time since down (ms)')
ylabel('FR zscore')
ylim([-2 4])
legend('NoSig','Sig')


load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N1_LocalBulb_left_ActivitySpike.mat','ModInfo')
subplot(4,6,[1,7,13]+2)
imagesc(sortrows([ModInfo.pval.Transf(WhicFreq,:);SmoothDec(DatMat,[0.01 1])']'))
line([80 80],[0 1]*sum(ModInfo.pval.Transf(WhicFreq,:)<PLim),'linewidth',3)
title('N1')
ylabel('Num of Neurons')
xlabel('time since down (ms)')
subplot(4,6,19+2)
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)>PLim,:)),'b')
hold on
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)<PLim,:)),'r')
xlabel('time since down (ms)')
ylabel('FR zscore')
ylim([-2 4])
legend('NoSig','Sig')

load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_REM_LocalBulb_left_ActivitySpike.mat','ModInfo')
subplot(4,6,[1,7,13]+3)
imagesc(sortrows([ModInfo.pval.Transf(WhicFreq,:);SmoothDec(DatMat,[0.01 1])']'))
line([80 80],[0 1]*sum(ModInfo.pval.Transf(WhicFreq,:)<PLim),'linewidth',3)
title('REM')
ylabel('Num of Neurons')
xlabel('time since down (ms)')
subplot(4,6,19+3)
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)>PLim,:)),'b')
hold on
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)<PLim,:)),'r')
xlabel('time since down (ms)')
ylabel('FR zscore')
ylim([-2 4])
legend('NoSig','Sig')

load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_WAKE_LocalBulb_left_ActivitySpike.mat','ModInfo')
subplot(4,6,[1,7,13]+4)
imagesc(sortrows([ModInfo.pval.Transf(WhicFreq,:);SmoothDec(DatMat,[0.01 1])']'))
line([80 80],[0 1]*sum(ModInfo.pval.Transf(WhicFreq,:)<PLim),'linewidth',3)
title('Wake')
ylabel('Num of Neurons')
xlabel('time since down (ms)')
subplot(4,6,19+4)
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)>PLim,:)),'b')
hold on
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)<PLim,:)),'r')
xlabel('time since down (ms)')
ylabel('FR zscore')
ylim([-2 4])
legend('NoSig','Sig')

load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_Wake_GoodOscill_LocalBulb_left_ActivitySpike.mat','ModInfo')
subplot(4,6,[1,7,13]+5)
imagesc(sortrows([ModInfo.pval.Transf(WhicFreq,:);SmoothDec(DatMat,[0.01 1])']'))
line([80 80],[0 1]*sum(ModInfo.pval.Transf(WhicFreq,:)<PLim),'linewidth',3)
title('Wake Good Oscill')
ylabel('Num of Neurons')
xlabel('time since down (ms)')
subplot(4,6,19+5)
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)>PLim,:)),'b')
hold on
plot(B(101:end),nanmean(DatMat(ModInfo.pval.Transf(WhicFreq,:)<PLim,:)),'r')
xlabel('time since down (ms)')
ylabel('FR zscore')
ylim([-2 4])
legend('NoSig','Sig')


figure
for k = 1:3
load(['/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N',num2str(k),'_LocalBulb_left_ActivityDelta.mat'],'ModInfo','HS','PhaseSpikes')
AngleMat = [2*pi/40:2*pi/20:4*pi-2*pi/40];
subplot(3,3,(k-1)*3+1)
imagesc(AngleMat,mean(FilterBands),HS{1}), axis xy
title('Start Down')
xlabel('Phase')
ylabel(['N' num2str(k) '-' num2str(length(PhaseSpikes.Transf{1}))])
subplot(3,3,(k-1)*3+2)
imagesc(AngleMat,mean(FilterBands),HS{2}), axis xy
title('Stop Down')
xlabel('Phase')
subplot(3,3,(k-1)*3+3)
plot(mean(FilterBands),ModInfo.Kappa.Transf)
legend('Start','Stop')
ylim([0 0.8])
title('Kappa as fct of freq')
xlabel('Freq')
end



load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_REM_LocalBulb_left_ActivitySpike.mat','ModInfo')
ModInfoAll.Rem = ModInfo;
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_WAKE_LocalBulb_left_ActivitySpike.mat','ModInfo')
ModInfoAll.Wake = ModInfo;
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N1_LocalBulb_left_ActivitySpike.mat','ModInfo')
ModInfoAll.N1 = ModInfo;
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N2_LocalBulb_left_ActivitySpike.mat','ModInfo')
ModInfoAll.N2 = ModInfo;
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_N3_LocalBulb_left_ActivitySpike.mat','ModInfo')
ModInfoAll.N3 = ModInfo;
load('/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep/RayleighFreqAnalysis/Rayleigh_BandWidthLarge_Wake_GoodOscill_LocalBulb_left_ActivitySpike.mat','ModInfo')
ModInfoAll.WakeGood = ModInfo;

ModInfoAll.WakeGood.Kappa.Transf(ModInfoAll.WakeGood.pval.Transf'<0.05) = NaN;
ModInfoAll.Wake.Rem.Transf(ModInfoAll.Rem.pval.Transf'<0.05 & ModInfoAll.Wake.pval.Transf'<0.05) = NaN;
plot(sum(ModInfoAll.Wake.pval.Transf'<0.05 & ModInfoAll.Rem.pval.Transf'<0.05)/size(ModInfoAll.Wake.pval.Transf,2))



%% How informative is modulation in one state about others
PLim = 0.05;
EpochNames = {'N3','N2','N1','Rem','Wake'}
for ep = 1:5
    for ep2=1:5
        for Freq = 1:18
            J = [sum(ModInfoAll.(EpochNames{ep}).pval.Transf(Freq,:)'>PLim & ModInfoAll.(EpochNames{ep2}).pval.Transf(Freq,:)'>PLim),sum(ModInfoAll.(EpochNames{ep}).pval.Transf(Freq,:)'>PLim & ModInfoAll.(EpochNames{ep2}).pval.Transf(Freq,:)'<PLim);...
                sum(ModInfoAll.(EpochNames{ep}).pval.Transf(Freq,:)'<PLim & ModInfoAll.(EpochNames{ep2}).pval.Transf(Freq,:)'>PLim),sum(ModInfoAll.(EpochNames{ep}).pval.Transf(Freq,:)'<PLim & ModInfoAll.(EpochNames{ep2}).pval.Transf(Freq,:)'<PLim)];
            J = J./sum(J(:));
            X = ModInfoAll.(EpochNames{ep}).Kappa.Transf(Freq,:);
            Y = ModInfoAll.(EpochNames{ep2}).Kappa.Transf(Freq,:);
            NanVals = isnan(X)|isnan(Y);
            X(NanVals) = [];
            Y(NanVals) = [];
            [R,P] = corrcoef(X,Y);
            Corr.(EpochNames{ep}).(EpochNames{ep2})(Freq) = R(1,2);
            PerSig.(EpochNames{ep}).(EpochNames{ep2})(Freq) = nansum(ModInfoAll.(EpochNames{ep}).pval.Transf(Freq,:)'<PLim & ModInfoAll.(EpochNames{ep2}).pval.Transf(Freq,:)'<PLim);

            
            MI.(EpochNames{ep}).(EpochNames{ep2})(Freq) = nansum(nansum(J.*log2(J./(sum(J,2).*sum(J,1)))));
        end
    end
end


clf
subplot(141)
plot(mean(FilterBands),MI.N1.Wake)
hold on
plot(mean(FilterBands),MI.N2.Wake)
plot(mean(FilterBands),MI.N3.Wake)
plot(mean(FilterBands),MI.Rem.Wake)
xlim([0 10])
legend({'N1','N2','N3','Rem'})
title('MI of wake with other states')

subplot(142)
plot(mean(FilterBands),MI.N1.Rem)
hold on
plot(mean(FilterBands),MI.N2.Rem)
plot(mean(FilterBands),MI.N3.Rem)
plot(mean(FilterBands),MI.Rem.Wake)
xlim([0 10])
legend({'N1','N2','N3','Wake'})
title('MI of Rem with other states')

subplot(143)
plot(mean(FilterBands),MI.N1.N3)
hold on
plot(mean(FilterBands),MI.N2.N3)
plot(mean(FilterBands),MI.Rem.N3)
plot(mean(FilterBands),MI.Wake.N3)
xlim([0 10])
legend({'N1','N2','REM','Wake'})
title('MI of N3 with other states')

subplot(144)
plot(mean(FilterBands),MI.N2.N1)
hold on
plot(mean(FilterBands),MI.N3.N1)
plot(mean(FilterBands),MI.Rem.N1)
plot(mean(FilterBands),MI.Wake.N1)
xlim([0 10])
legend({'N2','N3','REM','Wake'})
title('MI of N1 with other states')


