clear all
channelLow=5;
load(['LFPData/LFP',num2str(channelLow),'.mat'])
LFPlow=LFP;
channelHigh=5;
load(['LFPData/LFP',num2str(channelHigh),'.mat'])
LFPHigh=LFP;

% Whiten
[y, ARmodel] = WhitenSignal(Data(LFPHigh),[],1,[],2);
% Spectrogram
params.Fs=1/median(diff(Range(LFPHigh,'s')));
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[30 190];
params.tapers=[2 3];
movingwin=[0.1 0.01];
disp('... Calculating spectrogramm.');
[Sp,t,f]=mtspecgramc(y,movingwin,params);
Spz=Sp;
while sum(sum((Spz<=0)))>0
Spz(Spz<=0)=NaN;
Spz = naninterp(Spz);
end
% log transform
Spz=zscore(log(Spz));
% % PCA

% Do direct factor analysis
nfact=10;
[lambda,psi,T,stats] = factoran(Spz,nfact,'rotate','varimax');
%
% % calculate explained variance
% clear Val
% for k=1:nfact
% A=lambda(:,k)'*Spz';
% Val(k)=sum(A.^2);
% end

params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2];
params.tapers=[3 5];
CohPlots=[1,6;2,7;3,8;4,9;5,10;16,21;17,22;18,23;19,24;20,25];
LamPlots=[11,12,13,14,15,26,27,28,29,30];

figure
for l=1:10
    l
    Vals=(lambda(:,l)'*Sp')';
    Vals=interp1(t,Vals,Range(LFP,'s'));
    
    GFLLFP=tsd(Range(LFP),Vals);
    
    [C{l},phi,S12,S1,S2,tC,fC,confC,phistd]=cohgramc(Data(LFPlow),Data(GFLLFP),movingwin,params);
    figure(1)
    subplot(6,5,CohPlots(l,:))
    imagesc(tC,fC,C{l}'), hold on
    axis xy
    plot(nanmean(C{l})*100,fC,'k','linewidth',2)
    subplot(6,5,LamPlots(l))
    plot(f,lambda(:,l))
    xlim([min(f) max(f)])
    C{l}(1,:)=[];
end
figure
for l=1:10
plot(fC, runmean(nanmean(C{l}),8)./mean(log(Spectro{1})),'linewidth',2)
hold on
end


