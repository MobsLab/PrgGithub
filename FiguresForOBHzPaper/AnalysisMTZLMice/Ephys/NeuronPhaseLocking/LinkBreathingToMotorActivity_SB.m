
%%%%%%%%
clear all
load('BreathingInfo_ZeroCross.mat')
load('SleepSubstages.mat')
load('LFPData/LFP34.mat')
load('NeuronModulation/NeuronMod_Respi_ZeroCross_total_nonoise.mat')
load('/media/nas4/ProjetMTZL/Mouse778/20181218/NeuronResponseToMovement/Results.mat')

Acc=LFP;
A=tsd(Range(Acc),[0;diff(Data(Acc))]);
Ep=thresholdIntervals(A,1,'Direction','Above');
Ep=mergeCloseIntervals(Ep,2E4);
Ep=dropShortIntervals(Ep,0.5E4)


load('BreathingInfo_ZeroCross.mat')

AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
st=Start(AccBurst);

clear PhRespi
for i=-20:20
[PhRespi(i+21,:),b]=hist([Data(Restrict(PhaseInterpol,intervalSet(st+(i-1)*1E3,st+i*1E3)))],[0:0.2:2*pi]);
end
[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
load('SpikeData.mat')

for n=1:length(numNeurons)
    PhaseNeur = tsd(Range(Restrict(S{numNeurons(n)},epoch)),PhasesSpikes.Transf{n});
    subplot(231)
    bar(Range(sq{n},'s'),Data(sq{n}))
    subplot(232)
    imagesc([-20:20]/10,[0.2:0.2:2*pi-0.2],PhRespi(:,2:end-1)')
    subplot(233)
    spikingdat = Data(sq{n});
    spikingdat(1:20) = [];
    spikingdat(end-19:end) = [];
    
    plot([[0.2:0.2:2*pi-0.2],[0.2:0.2:2*pi-0.2]+2*pi],[nanmean([PhRespi(:,2:end-1).*repmat(spikingdat,1,30)]),nanmean([PhRespi(:,2:end-1).*repmat(spikingdat,1,30)])])
    subplot(2,2,3)
    EpShor = intervalSet(st-2*1e4,st+2*1e4);
    EpShor = mergeCloseIntervals(EpShor,2*1e4);
    nhist({[Data(Restrict(PhaseNeur,EpShor));Data(Restrict(PhaseNeur,EpShor))+2*pi],[Data(Restrict(PhaseNeur,Epoch{5})),Data(Restrict(PhaseNeur,Epoch{5}))+2*pi]},'noerror')
    yyaxis right
    plot([[0.2:0.2:2*pi-0.2],[0.2:0.2:2*pi-0.2]+2*pi],[nanmean([PhRespi(:,2:end-1).*repmat(spikingdat,1,30)]),nanmean([PhRespi(:,2:end-1).*repmat(spikingdat,1,30)])])
    
    subplot(2,2,4)
    EpShor = intervalSet(st,st+2*1e4);
    EpShor = mergeCloseIntervals(EpShor,2*1e4);
    nhist({[Data(Restrict(PhaseNeur,EpShor));Data(Restrict(PhaseNeur,EpShor))+2*pi],[Data(Restrict(PhaseNeur,Epoch{5})),Data(Restrict(PhaseNeur,Epoch{5}))+2*pi]},'noerror')
    yyaxis right
    plot([[0.2:0.2:2*pi-0.2],[0.2:0.2:2*pi-0.2]+2*pi],[nanmean([PhRespi(21:end,2:end-1).*repmat(spikingdat(21:end),1,30)]),nanmean([PhRespi(21:end,2:end-1).*repmat(spikingdat(21:end),1,30)])])
    pause
    clf
end
   %
    %
    %     xedf = b ;
    %     fedf = cumsum(nanmean([PhRespi(:,:).*repmat(Data(sq{n}),1,30)]));
    %     Funct=2*pi*(fedf);
    %
    %     % Correct phases
    %     bins = discretize(Data(PhaseNeur,shor), xedf);
    %
    %     % if the LFP phases do not completely cover range of phases, there will
    %     % be nans in 'bins' --> match to closest bin
    %     if sum(isnan(bins))>0
    %         BinsToFix=find(isnan(bins));
    %         TempPhaseVar=Data(phaseSpike{1});
    %         for fix=1:length(BinsToFix)
    %             [val,ind]=min(abs(TempPhaseVar(BinsToFix(fix))-xedf));
    %             bins(BinsToFix(fix))=ind;
    %         end
    %     end
    %     TransPh=Funct(bins);
    %
    %     % Get Phase distributions of LFP
    %     PhasesSpikes.Nontransf=Data(phaseSpike{1});
    %     PhasesSpikes.Transf=TransPh;
    %
        pause
        clf
    
end


%%%
clear all,
FileName{1} = '/media/nas4/ProjetMTZL/Mouse778/24102018';
FileName{2} = '/media/nas4/ProjetMTZL/Mouse778/20181213';
FileName{3} = '/media/nas4/ProjetMTZL/Mouse778/20181218';

figure(6)
for f = 1:3
    cd(FileName{f})
    load('NeuronResponseToMovement/Results.mat','sq','sweeps','AccBurst')
    
     load('LFPData/LFP34.mat')
    a = Data(LFP);
    a(a<-3.5e4)=NaN;
    a(a>-1)=NaN;
    aint = naninterp(a);
    A=tsd(Range(LFP),[0;diff(aint)]);
    LFPClean = tsd(Range(LFP),aint);
    LFPClean = tsd(Range(LFP),Data(LFPClean)-movmean(Data(LFPClean),1250*60))
    [MAcc,TAcc]=PlotRipRaw(LFPClean,Start(AccBurst,'s'),5000,0,0);
    subplot(3,1,f)
imagesc(MAcc(:,1),1:size(TAcc,1),zscore(TAcc')')
clim([-2 2])
SaveM(f,:) = MAcc(:,2)';
SaveMZSc(f,:) = nanmean(zscore(TAcc')');
    for n = 1:length(sq)
        AllNeur{f}(n,:) = Data(sq{n});
    end
end
figure(3)
for f = 1:3
subplot(3,1,f)
Mat = zscore(AllNeur{f}')';
[val,ind] = sort(mean(Mat(:,40:50)'));
imagesc(MAcc(:,1),1:size(Mat,2),Mat(ind,:))
clim([-2 2])
end

Binsize = 0.05*1e4;
S{1} = tsd([0;Range(S{1});max(Range(LFP))],[0;Range(S{1});max(Range(LFP))]);
Q = MakeQfromS(S,Binsize);

    
%% Look at dfferent MTZL movement
clear all
load('NeuronResponseToMovement/Results.mat','sq','sweeps','AccBurst')

load('LFPData/LFP34.mat')
a = Data(LFP);
a(a<-3.5e4)=NaN;
a(a>-1)=NaN;
aint = naninterp(a);
A=tsd(Range(LFP),[0;diff(aint)]);
LFPClean = tsd(Range(LFP),aint);
LFPClean = tsd(Range(LFP),Data(LFPClean)-movmean(Data(LFPClean),1250*60))
[MAcc,TAcc]=PlotRipRaw(LFPClean,Start(AccBurst,'s'),5000,0,0);

[EigVect,EigVals]=PerformPCA(zscore(TAcc')');
times = Start(AccBurst);
timesStp = Stop(AccBurst);

[val,ind] = sort(EigVect(:,2));
timesNormMove = sort(times(ind(1:700)));
timesWeirdMove = sort(times(ind(950:1250)));
timesNormMoveStp = sort(timesStp(ind(1:700)));
timesWeirdMoveStp = sort(timesStp(ind(950:1250)));
load('BreathingInfo_ZeroCross.mat')

AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));

Ep = AccBurst;
st=Start(Ep);
for i=-20:20
[h(i+21,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(st+(i-1)*1E3,st+i*1E3))),[0:0.2:2*pi]);
end
subplot(311)
imagesc(h')
st=timesNormMove;
for i=-20:20
[h(i+21,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(st+(i-1)*1E3,st+i*1E3))),[0:0.2:2*pi]);
end
subplot(312)
imagesc(h')
st=timesWeirdMove;
for i=-20:20
[h(i+21,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(st+(i-1)*1E3,st+i*1E3))),[0:0.2:2*pi]);
end
subplot(313)
imagesc(h')



load('SpikeData.mat')
mkdir('NeuronResponseToMovement')
mkdir('NeuronResponseToMovement/IndividualNeuronFigsNormMov')
mkdir('NeuronResponseToMovement/IndividualNeuronFigsWeirdMov')
[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);

clear sq sweeps
for n=1:length(numNeurons)
    [fh,sq{n},sweeps{n}] = RasterPETH(S{numNeurons(n)}, ts(timesNormMove), -4*1e4,+4*1e4,'BinSize',1E3,'Markers',{ts(timesNormMoveStp)},'MarkerTypes',{'ro','r'});title(cellnames{n})
    title(TT{n})
    saveas(fh.Number,['NeuronResponseToMovement/IndividualNeuronFigsNormMov/', cellnames{n},'.png'])
    clf
end
save('NeuronResponseToMovement/ResultsNormMov.mat','sq','sweeps','timesNormMove')
        
clear sq sweeps
for n=1:length(numNeurons)
    [fh,sq{n},sweeps{n}] = RasterPETH(S{numNeurons(n)}, ts(timesWeirdMove), -4*1e4,+4*1e4,'BinSize',1E3,'Markers',{ts(timesWeirdMoveStp)},'MarkerTypes',{'ro','r'});title(cellnames{n})
    title(TT{n})
    saveas(fh.Number,['NeuronResponseToMovement/IndividualNeuronFigsWeirdMov/', cellnames{n},'.png'])
    clf
end
save('NeuronResponseToMovement/ResultsWeirdMov.mat','sq','sweeps','timesWeirdMove')
    
clear AllNeur
load('NeuronResponseToMovement/Results.mat','sq','sweeps','timesWeirdMove')
for n = 1:length(sq)
    AllNeur(n,:) = Data(sq{n});
end
subplot(311)
imagesc(zscore(AllNeur')')

load('NeuronResponseToMovement/ResultsNormMov.mat','sq','sweeps','timesNormMove')
for n = 1:length(sq)
    AllNeur(n,:) = Data(sq{n});
end
subplot(312)
imagesc(zscore(AllNeur')')

load('NeuronResponseToMovement/ResultsWeirdMov.mat','sq','sweeps','timesWeirdMove')
for n = 1:length(sq)
    AllNeur(n,:) = Data(sq{n});
end
subplot(313)
imagesc(zscore(AllNeur')')

    
load('LFPData/LFP35.mat')
a = Data(LFP);
a(a<-2.8e4)=NaN;
a(a>-0.8e4)=NaN;
aint = naninterp(a);
A=tsd(Range(LFP),[0;diff(aint)]);
subplot(121)
plot(Range(LFP,'s'),aint-2e4), hold on
subplot(122)
plot(Range(LFP,'s'),Data(A)-2e4), hold on

load('LFPData/LFP33.mat')
a = Data(LFP);
a(a<-2.8e4)=NaN;
a(a>-0.8e4)=NaN;
aint = naninterp(a);
A=tsd(Range(LFP),[0;diff(aint)]);
subplot(121)
plot(Range(LFP,'s'),aint-4e4), hold on
subplot(122)
plot(Range(LFP,'s'),Data(A)-4e4), hold on


cd /media/nas4/ProjetMTZL/Mouse778/20181213
figure
load('LFPData/LFP34.mat')
a = Data(LFP);
a(a<-3.2e4)=NaN;
a(a>-2.4e4)=NaN;
aint = naninterp(a);
plot(Range(LFP,'s'),aint)
A=tsd(Range(LFP),[0;diff(aint)]);
subplot(121)
plot(Range(LFP,'s'),aint), hold on
subplot(122)
plot(Range(LFP,'s'),Data(A)), hold on

load('LFPData/LFP35.mat')
a = Data(LFP);
a(a<-2.8e4)=NaN;
a(a>-0.8e4)=NaN;
aint = naninterp(a);
A=tsd(Range(LFP),[0;diff(aint)]);
subplot(121)
plot(Range(LFP,'s'),aint-2e4), hold on
subplot(122)
plot(Range(LFP,'s'),Data(A)-2e4), hold on

load('LFPData/LFP33.mat')
a = Data(LFP);
a(a<-2.8e4)=NaN;
a(a>-0.8e4)=NaN;
aint = naninterp(a);
A=tsd(Range(LFP),[0;diff(aint)]);
subplot(121)
plot(Range(LFP,'s'),aint-4e4), hold on
subplot(122)
plot(Range(LFP,'s'),Data(A)-4e4), hold on


    % Get periods of relative imombilit
    Asmoothed = tsd(Range(A),abs(runmean(Data(A),5000)));
    ActiveEpoch = thresholdIntervals(Asmoothed,0.2,'Direction','Above');
    ActiveEpoch = mergeCloseIntervals(ActiveEpoch,20*1e4);
    ActiveEpoch = dropShortIntervals(ActiveEpoch,60*1e4);
    ActiveEpoch = mergeCloseIntervals(ActiveEpoch,300*1e4);
    TotalEpoch = intervalSet(0,max(Range(LFP)));
    UnActiveEpoch = TotalEpoch-ActiveEpoch;
    
        AccBurst = thresholdIntervals(A,300,'Direction','Above');
    AccBurst = dropShortIntervals(AccBurst,0.2*1e4);
    AccBurst = mergeCloseIntervals(AccBurst,15*1e4);
    AccBurst = dropShortIntervals(AccBurst,1*1e4);
    AccBurst = dropLongIntervals(AccBurst,50*1e4);
    AccBurst = and(AccBurst,UnActiveEpoch);
    numevents= length(Start(AccBurst))

 figure(1)
    subplot(2,1,f)
    LFPClean = tsd(Range(LFP),aint);
    plot(Range(Restrict(LFP,UnActiveEpoch),'s'),Data(Restrict(LFPClean,UnActiveEpoch))), hold on
    plot(Range(Restrict(LFP,AccBurst),'s'),Data(Restrict(LFPClean,AccBurst))), hold on
    totime= sum(Stop(UnActiveEpoch,'s')-Start(UnActiveEpoch,'s'))/3600;
    numevents= length(Start(AccBurst));
    title([num2str(totime) 'hrs ' num2str(numevents) 'events'])
    
    figure(2)
    subplot(2,2,f)
    dens = length(Start(AccBurst)) ./ max(Range(LFP,'s'));
    hist(diff(Start((AccBurst),'s')),500)
    xlim([0 500])
    title(num2str(dens))
    subplot(2,2,f+2)
    dens = length(Start(AccBurst)) ./ max(Range(LFP,'s'));
    hist(Stop(AccBurst,'s')-Start(AccBurst,'s'),200)
    xlim([0 500])
    max(Range(LFP,'s'))
    sum(Stop(UnActiveEpoch,'s')-Start(UnActiveEpoch,'s'))
    
    
    
    
    %% Old stuff
    st=Start(Ep);
for i=1:20
[h(i,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(st+(i-1)*1E3,st+i*1E3))),[0:0.2:2*pi]);
end


en=End(Ep);
for i=1:20
[he(i,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(en+(i-1)*1E3,en+i*1E3))),[0:0.2:2*pi]);
end



en=End(Ep);
for i=1:20
[Ytemp,b]=hist(Data(Restrict(PhaseNeur,intervalSet(st+(i-1)*1E3,st+i*1E3))),[0:0.2:2*pi]);
hs(i,:) = Ytemp/sum(Ytemp);
end



for n=1:10
    PhaseNeur = tsd(Range(Restrict(S{n},epoch)),PhasesSpikes.Transf{n});
for i=1:20
[Ytemp,b]=hist(Data(Restrict(PhaseNeur,intervalSet(st+(i-1)*1E3,st+i*1E3))),[0:0.2:2*pi]);
hs(i,:) = Ytemp;
hs2(i,:) = Ytemp/sum(Ytemp);
end

figure,
subplot(2,1,1), imagesc(hs'), title(cellnames{n})
subplot(2,1,2), imagesc(hs2')
end




for n=1:10
    PhaseNeur = tsd(Range(Restrict(S{n},epoch)),PhasesSpikes.Transf{n});
for i=1:20
[Ytemp,b]=hist(Data(Restrict(PhaseNeur,intervalSet(en+(i-1)*1E3,en+i*1E3))),[0:0.2:2*pi]);
hs(i,:) = Ytemp;
hs2(i,:) = Ytemp/sum(Ytemp);
end

figure,
subplot(2,1,1), imagesc(hs'), title(cellnames{n})
subplot(2,1,2), imagesc(hs2')
end



n=n+1;figure, [fh,sq,sweeps] = RasterPETH(S{n}, ts(Start(Ep)), -50000,+75000,'BinSize',500,'Markers',{ts(End(Ep))},'MarkerTypes',{'ro','r'});title(cellnames{n})

for i=1:20
[he(i,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(en+(i-1)*1E3,en+i*1E3))),[0:0.2:2*pi]);
end



load('LFPData/LFP34.mat')
a = Data(LFP);
a(a<-3.5e4)=NaN;
a(a>-1)=NaN;
aint = naninterp(a);
A=tsd(Range(LFP),[0;diff(aint)]);
LFPClean = tsd(Range(LFP),aint);
LFPClean = tsd(Range(LFP),Data(LFPClean)-movmean(Data(LFPClean),1250*60))
[MAcc,TAcc]=PlotRipRaw(LFPClean,Start(AccBurst,'s'),5000,0,0);

[EigVect,EigVals]=PerformPCA(zscore(TAcc')');
times = Start(AccBurst);
timesStp = Stop(AccBurst);

[val,ind] = sort(EigVect(:,2));
subplot(131)
imagesc(MAcc(:,1),1:size(TAcc,1),sortrows([EigVect(:,2),zscore(TAcc')']))
clim([-3 3])


load('BreathingInfo_ZeroCross.mat')
AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
[MResp,TResp]=PlotRipRaw(PhaseInterpol,Start(AccBurst,'s'),5000,0,0);
subplot(132)
imagesc(MAcc(:,1),1:size(TAcc,1),sortrows([EigVect(:,2),(TResp')']))


subplot(133)
Q = MakeQfromS(S,0.2*1e4);
Qdat = Data(Q);
for n = 1 :size(Qdat,2)
   [MSp,TSp]=PlotRipRaw(tsd(Range(Q),Qdat(:,n)),Start(AccBurst,'s'),5000,0,0); 
imagesc(MAcc(:,1),1:size(TAcc,1),SmoothDec(sortrows([EigVect(:,2),zscore(TSp')']),[0.5 0.5]))
pause

end


tempA = A(1:400,6250:6750);
hist(tempA(:))
subplot(121)
hist(tempA(:),30)
xlim([2 2*pi])
subplot(122)
tempA = A(900:1300,6250:7000);
hist(tempA(:),30)
xlim([2 2*pi])

timessorted = times(ind);
Ep1 = intervalSet(sort(timessorted(1:400)),sort(timessorted(1:400))+2*1e4);
Ep2 = intervalSet(sort(timessorted(900:1300)),sort(timessorted(900:1300))+2*1e4);

for n = 1 :size(Qdat,2)
    PhaseNeur = tsd(Range(Restrict(S{n},epoch)),PhasesSpikes.Transf{n});
    subplot(2,4,1)
    hist(Data(PhaseNeur),30),xlim([0 2*pi])
    title('all')
    subplot(2,4,2)
    hist(Data(Restrict(PhaseNeur,Ep1)),30),xlim([0 2*pi])
    title('Ep1')
    subplot(2,4,3)
    hist(Data(Restrict(PhaseNeur,Ep2)),30),xlim([0 2*pi])
    title('Ep2')
    [MSp,TSp]=PlotRipRaw(tsd(Range(Q),Qdat(:,n)),Start(AccBurst,'s'),5000,0,0);
    subplot(2,4,[4,8])
    imagesc(MAcc(:,1),1:size(TAcc,1),SmoothDec(sortrows([EigVect(:,2),zscore(TSp')']),[0.5 0.5]))
    clim([-2 2])

    subplot(2,4,5)
    plot(MSp(:,1),MSp(:,2))
    [MSp,TSp]=PlotRipRaw(tsd(Range(Q),Qdat(:,n)),sort(timessorted(1:400)/1e4),5000,0,0);
    subplot(2,4,6)
    plot(MSp(:,1),MSp(:,2))
    [MSp,TSp]=PlotRipRaw(tsd(Range(Q),Qdat(:,n)),sort(timessorted(900:1300)/1e4),5000,0,0);
    subplot(2,4,7)
    plot(MSp(:,1),MSp(:,2))
    
   
    pause
end


for i=-20:20
[h(i+21,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(st+(i-1)*1E3,st+i*1E3))),[0:0.2:2*pi]);
end
