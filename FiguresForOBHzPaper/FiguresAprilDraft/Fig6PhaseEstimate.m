clear all,
CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
% close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEARMac('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
numNeurons=[];
num=1;
StrucNames={'OB' 'HPC'}
KeepFirstSessionOnly=[1,5:length(Dir.path)];
Ep={'Fz','NoFz'};
FieldNames={'OB1','HPCLoc'};
nbin=30;

for mm=KeepFirstSessionOnly
    Dir.path{mm}
    cd(Dir.path{mm})
    clear FreezeEpoch MovAcctsd
    if exist('NeuronLFPCoupling/FzNeuronModFreqMiniMaxiPhaseCorrected_HPCLoc.mat')>0
        
        % Get Freeze and NoFreeze Epochs of equal length
        load('behavResources.mat')
        DurFz=sum(Stop(FreezeEpoch)-Start(FreezeEpoch));
        if exist('MovAcctsd')
            MovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),100));
        else
            MovAcctsd=Movtsd;
        end
        for i=1:100
            PrcVal=prctile(Data(MovAcctsd),i);
            LitEp=thresholdIntervals(MovAcctsd,PrcVal,'Direction','Above',PrcVal);
            LitEp=LitEp-FreezeEpoch;
            LitEp=dropShortIntervals(LitEp,3*1E4);
            DurNFztemp(i)=sum(Stop(LitEp)-Start(LitEp));
        end
        [vall,ind]=min(abs((DurNFztemp-DurFz)));
        PrcVal=prctile(Data(MovAcctsd),ind);
        NoFreezeEpoch=thresholdIntervals(MovAcctsd,PrcVal,'Direction','Above',PrcVal);
        NoFreezeEpoch=NoFreezeEpoch-FreezeEpoch;
        NoFreezeEpoch=dropShortIntervals(NoFreezeEpoch,3*1E4);
        MovEpoch=NoFreezeEpoch;
        
%         load('FilteredLFP/MiniMaxiLFPHPC1.mat')
%         load(['LFPData/LFP',num2str(channel),'.mat'])

        load('FilteredLFP/MiniMaxiLFPHPCLoc.mat')
        load(['LFPData/LocalHPCActivity.mat'])
        FilLFPP=FilterLFP(LFP,[1 15],1024);
        dat=Data(FilLFPP);
        tps=Range(LFP);
        Amp=interp1(AllPeaks(:,1),dat(ceil(AllPeaks(:,1)*1250)),Range(LFP,'s'));
        tps(isnan(Amp))=[];
        dat(isnan(Amp))=[];
        Amp(isnan(Amp))=[];
        Err=sqrt((Amp-dat).^2./(Amp+dat).^2);
        Errtsd=tsd(tps,Err);
        TotErr(num,1)=mean(Data(Restrict(Errtsd,MovEpoch)));
        TotErr(num,2)=mean(Data(Restrict(Errtsd,FreezeEpoch)));
        clear Err MovEpoch FreezeEpoch dat Amp tps
        
        load('FilteredLFP/MiniMaxiLFPOB1.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        close all
        load('behavResources.mat')
        load('StateEpochSB.mat','TotalNoiseEpoch')
        FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
        FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
        TotEpoch=intervalSet(0,max(Range(Movtsd)));
        MovEpoch=TotEpoch-FreezeEpoch;
        MovEpoch=MovEpoch-TotalNoiseEpoch;
        MovEpoch=dropShortIntervals(MovEpoch,3*1e4);
        FilLFPP=FilterLFP(LFP,[1 15],1024);
        dat=Data(FilLFPP);
        tps=Range(LFP);
        Amp=interp1(AllPeaks(:,1),dat(ceil(AllPeaks(:,1)*1250)),Range(LFP,'s'));
        tps(isnan(Amp))=[];
        dat(isnan(Amp))=[];
        Amp(isnan(Amp))=[];
        Err=sqrt((Amp-dat).^2./(Amp+dat).^2);
        Errtsd=tsd(tps,Err);
        TotErr(num,3)=mean(Data(Restrict(Errtsd,MovEpoch)));
        TotErr(num,4)=mean(Data(Restrict(Errtsd,FreezeEpoch)));
        num=num+1;
    end
end

figure
Cols1=[0,109,219;146,0,0]/263;
g=bar([1:4],mean(TotErr)); hold on
set(g,'FaceColor','w','EdgeColor','w')
plotSpread(TotErr,'distributionColors',{Cols1(2,:),Cols1(1,:),Cols1(2,:),Cols1(1,:)},'showMM',0)
[p(1),h]=signrank(TotErr(:,1),TotErr(:,2));
[p(2),h]=signrank(TotErr(:,3),TotErr(:,4));
sigstar({{1,2},{3,4}},p)
set(gca,'Layer','top','XTickLabel',{'Act','Fz','Act','Fz'},'Fontsize',15)
box off
ylabel('Mean square err')

cd /Volumes/My Passport/Project4Hz/Mouse402/FEAR-Mouse-402-EXT-24-envB_raye_161026_164106
figure
load('Bbis_Low_Spectrum.mat')
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
clim([-0 6.5])
ylim([1 20])
load('FilteredLFP/MiniMaxiLFPOB1.mat')

frtemp=1./diff(AllPeaks(1:2:end,1))';
tpstemp=AllPeaks(1:2:end,1)*1E4;
tpstemp=tpstemp(1:length(frtemp));
FreqOBtsd=tsd(tpstemp,frtemp');
hold on,plot(Range(FreqOBtsd,'s'),runmean(Data(FreqOBtsd),1),'k')
xlim([630 750])
box off
set(gca,'XTick',[],'FontSize',20)

figure
imagesc(Spectro{2},Spectro{3},log(Spectro{1}'))
axis xy
clim([-0 6.5])
ylim([1 20])
load('FilteredLFP/MiniMaxiLFPOB1.mat')

frtemp=1./diff(AllPeaks(1:2:end,1))';
tpstemp=AllPeaks(1:2:end,1)*1E4;
tpstemp=tpstemp(1:length(frtemp));
FreqOBtsd=tsd(tpstemp,frtemp');
hold on,plot(Range(FreqOBtsd,'s'),runmean(Data(FreqOBtsd),5),'k')
xlim([0 800])
box off
set(gca,'XTick',[],'FontSize',20)

