clear all
[Dir,KeepFirstSessionOnly,CtrlEphys]=GetRightSessionsFor4HzPaper('CtrlAllDataSpikes');

neur = 1;
for mm = 1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    load('SpikeData.mat')
    load('behavResources.mat')
    if not(exist('FreezeAccEpoch'))
        FreezeAccEpoch = FreezeEpoch;
    end
    FreezeAccEpoch = mergeCloseIntervals(FreezeAccEpoch,3*1e4);
    for i = 1:length(S)
        %         [fh,sq,sweeps] = RasterPETH(S{i}, ts(Stop(FreezeAccEpoch)), -10000, +15000,'BinSize',100);
        FreezeAccEpochSh = dropShortIntervals(FreezeAccEpoch,7*1e4);
        [C, B] = CrossCorr((Stop(FreezeAccEpochSh)),Range(S{i}),20,500);, plot(B/1e3,C)
        AllNeurSh(neur,:) = C;
        FreezeAccEpochLg = FreezeAccEpoch-dropShortIntervals(FreezeAccEpoch,7*1e4);
        [C, B] = CrossCorr((Stop(FreezeAccEpochLg)),Range(S{i}),20,500);, plot(B/1e3,C)
        AllNeurLg(neur,:) = C;
        neur = neur+1;
    end
    
    
    load('B_Low_Spectrum.mat')
    Sptsd_B = tsd(Spectro{2}*1e4,Spectro{1});
    FreqRange=[3,6];
    TotEpoch = intervalSet(0,max(Range(Sptsd_B)));
    Spec_B=Data(Sptsd_B);
    FreqBand=tsd(Range(Sptsd_B),(nanmean(Spec_B(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))')'));
    
    FreezeAccEpochSh = FreezeAccEpoch-dropShortIntervals(FreezeAccEpoch,7*1e4);
    try
        clear FreezeEndTemp
        for k = 1:length(Start(FreezeAccEpochSh))-1
            FreezeEndTemp(k,:) = Data(Restrict(FreqBand,intervalSet(Stop(subset(FreezeAccEpochSh,k))-2*1e4,Stop(subset(FreezeAccEpochSh,k))+2*1e4)))/nanmean(Data(FreqBand));
        end
        OBSh(mm,:) = nanmean(FreezeEndTemp);
    end
    
    try
        FreezeAccEpochLg = dropShortIntervals(FreezeAccEpoch,7*1e4);
        clear FreezeEndTemp
        for k = 1:length(Start(FreezeAccEpochLg))-1
            FreezeEndTemp(k,:) = Data(Restrict(FreqBand,intervalSet(Stop(subset(FreezeAccEpochLg,k))-2*1e4,Stop(subset(FreezeAccEpochLg,k))+2*1e4)))/nanmean(Data(FreqBand));
        end
        OBLg(mm,:) = nanmean(FreezeEndTemp);
    end
    
end

        figure
OBSh2 = OBSh;
OBSh2(OBSh==0)=NaN;
OBLg2 = OBLg;
OBLg2(OBLg==0)=NaN;
plot(nanmean(OBLg2))
hold on
plot(nanmean(OBSh2))

neur = 1;
for mm = 1:length(Dir.path)
    mm
    cd(Dir.path{mm})
    load('SpikeData.mat')
    load('behavResources.mat')
    if not(exist('FreezeAccEpoch'))
        FreezeAccEpoch = FreezeEpoch;
    end
    FreezeAccEpoch = mergeCloseIntervals(FreezeAccEpoch,3*1e4);


    load('B_Low_Spectrum.mat')
    Sptsd_B = tsd(Spectro{2}*1e4,Spectro{1});
    FreqRange=[3,6];
    TotEpoch = intervalSet(0,max(Range(Sptsd_B)));
    
    Spec_B=Data(Sptsd_B);
    FreqBand=tsd(Range(Sptsd_B),nanmean(Spec_B(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))')');
    for k = 1:length(Start(FreezeAccEpoch))-1
        FreezeEnd{mm}(k,:) = Data(Restrict(FreqBand,intervalSet(Stop(subset(FreezeAccEpoch,k))-2*1e4,Stop(subset(FreezeAccEpoch,k))+2*1e4)))/nanmean(Data(FreqBand));
    end
    
    for k = 1:length(Start(FreezeAccEpoch))-1
        Dur{mm}(k) = Stop(subset(FreezeAccEpoch,k)) - Start(subset(FreezeAccEpoch,k));
        StartFreeze = nanmean(Data(Restrict(FreqBand,intervalSet(Start(subset(FreezeAccEpoch,k)),Start(subset(FreezeAccEpoch,k))+2*1e4))));
        EndFreeze = nanmean(Data(Restrict(FreqBand,intervalSet(Stop(subset(FreezeAccEpoch,k))-2*1e4,Stop(subset(FreezeAccEpoch,k))))));
        BegEndFreezing{mm}(k,:) = (StartFreeze-EndFreeze)./(StartFreeze+EndFreeze);
    end
    
    
    % clear AccEnd
    % for k = 1:length(Start(FreezeAccEpoch))-1
    %     temp = Data(Restrict(MovAcctsd,intervalSet(Stop(subset(FreezeAccEpoch,k))-2*1e4,Stop(subset(FreezeAccEpoch,k))+2*1e4)));
    %     AccEnd(k,:) = temp(1:200);
    % end
    
    Q = MakeQfromS(S,0.2*1e4);
    Q = tsd(Range(Q),zscore(Data(Q)));
    Wvect = full(nanmean(Data(Restrict(Q,FreezeAccEpoch)))-nanmean(Data(Restrict(Q,TotEpoch-FreezeAccEpoch))));
    QDat = full(Data(Q));
    
    QPos = tsd(Range(Q),nanmean(QDat(:,Wvect>0),2));
    QNeg = tsd(Range(Q),nanmean(QDat(:,Wvect<0),2));
    
    %  plot(Range(Q),Data(Q)*Wvect')
    %  hold on
    %  plot(Range(Restrict(Q,FreezeAccEpoch)),Data(Restrict(Q,FreezeAccEpoch))*Wvect')
    Projtsd = tsd(Range(Q),Data(Q)*Wvect');
    for k = 1:length(Start(FreezeAccEpoch))-1
        SpikeEnd{mm}(k,:) = Data(Restrict(Projtsd,intervalSet(Stop(subset(FreezeAccEpoch,k))-2*1e4,Stop(subset(FreezeAccEpoch,k))+2*1e4)));
        SpikeEndP{mm}(k,:) = Data(Restrict(QPos,intervalSet(Stop(subset(FreezeAccEpoch,k))-2*1e4,Stop(subset(FreezeAccEpoch,k))+2*1e4)));
        SpikeEndN{mm}(k,:) = Data(Restrict(QNeg,intervalSet(Stop(subset(FreezeAccEpoch,k))-2*1e4,Stop(subset(FreezeAccEpoch,k))+2*1e4)));
        
    end
    clf
    Val{mm} = (mean(FreezeEnd{mm}(:,1:5)')-mean(FreezeEnd{mm}(:,end-5:end)'));
    
    
    % figure
    % subplot(131)
    % A = (sortrows([BegEndFreezing';FreezeEnd']'));
    % imagesc(A(:,2:end))
    %
    % subplot(132)
    % A = (sortrows([BegEndFreezing';SpikeEnd']'));
    % imagesc(A(:,2:end))
    %
    % % subplot(133)
    % % A = (sortrows([BegEndFreezing';AccEnd']'));
    % % imagesc(A(:,2:end))
    %
    % figure
    % subplot(131)
    % A = (sortrows([Val;FreezeEnd']'));
    % imagesc(A(:,2:end))
    %
    % subplot(132)
    % A = (sortrows([Val;SpikeEnd']'));
    % imagesc(A(:,2:end))
    %
    % subplot(133)
    % A = (sortrows([Val;AccEnd']'));
    % imagesc(A(:,2:end))
    %
end


H=[];Sp = [];
OB = [];
for mm = 1:length(Val)
% H = [H,-BegEndFreezing{mm}'];
H = [H,Val{mm}];

Sp = [Sp;SpikeEndP{mm}];
OB = [OB;FreezeEnd{mm}];
end

figure
subplot(121)
A = (sortrows([H',Sp]))';
imagesc(A(2:end,:)')
clim([-5 5])
subplot(122)
A = (sortrows([H',OB]))';
imagesc(A(2:end,:)')
clim([0.1 2.5])

