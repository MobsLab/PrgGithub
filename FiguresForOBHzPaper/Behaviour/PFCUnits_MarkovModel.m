clear all,% close all
%% INITIATION

%% DATA LOCALISATION
[Dir,KeepFirstSessionOnly]=GetRightSessionsFor4HzPaper('CtrlAllDataSpikes');
SaveFolder='/media/DataMOBsRAIDN/ProjetAversion/AnalysisStartStopFreezing_LinkWith4Hz/';
StrucNames= {'HPCVars','OBVars'};

stepsize=3;
pernum=500;

for m=1:length(KeepFirstSessionOnly)
    
    %% Go to file location
    mm=KeepFirstSessionOnly(m);
    disp(Dir.path{mm})
    cd(Dir.path{mm})
    clear Spec FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    
    %% load data
    % Epochs
    load('behavResources.mat')
    load('StateEpochSB.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=and(FreezeEpoch,TotEpoch);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,4*1e4);
    FreezeEpochBis=FreezeEpoch;
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-4*1e4,Stop(LitEp)+4*1e4);
        if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    
    EndSessionTime = max(Range(Movtsd,'s'));
    
    % Spikes
    load('SpikeData.mat')
    load LFPData/InfoLFP.mat
    chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
    numtt=[]; % nb tetrodes ou montrodes du PFCx
    
    for cc=1:length(chans)
        for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
            if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                numtt=[numtt,tt];
            end
        end
    end
    
    numNeurons=[]; % neurones du PFCx
    for i=1:length(S);
        if ismember(TT{i}(1),numtt)
            numNeurons=[numNeurons,i];
        end
    end
    
    numMUA=[];
    for k=1:length(numNeurons)
        j=numNeurons(k);
        if TT{j}(2)==1
            numMUA=[numMUA, k];
        end
    end
    numNeurons(numMUA)=[];
    
    load('MeanWaveform.mat')
    
    tps = [0:stepsize:EndSessionTime]*1e4;
    FakeData = tsd((tps),[1:length(tps)]');
    BinData_FZ_ind = Data(Restrict(FakeData,FreezeEpoch));
    BinData_FZ_val = zeros(1,length(tps));
    BinData_FZ_val(BinData_FZ_ind)=1;
    BinData_FZ_val_Change=diff(BinData_FZ_val);
    BinData_FZ_val(end)=[];
    
    for sp=1:length(numNeurons)
        NeurFiring = hist(Range(S{numNeurons(sp)}),tps)';
        NeurFiring(end) = [];
        
        % Transitions From Active State
        ActToAct = find(BinData_FZ_val(1:end-1)==0 & BinData_FZ_val(2:end)==0);
        ActToFz = find(BinData_FZ_val(1:end-1)==0 & BinData_FZ_val(2:end)==1);
        % Transitions From Freezing State
        FzToFz = find(BinData_FZ_val(1:end-1)==1 & BinData_FZ_val(2:end)==1);
        FzToAct = find(BinData_FZ_val(1:end-1)==1 & BinData_FZ_val(2:end)==0);
        
        % Same number of bins in all cases
        Sizes = [length(ActToAct),length(FzToFz)];
        ActToAct = ActToAct(randperm(length(ActToAct)));
        ActToAct = ActToAct(1:min(Sizes));
        FzToFz = FzToFz(randperm(length(FzToFz)));
        FzToFz = FzToFz(1:min(Sizes));
        
        % Transitions From Active State
        alpha=[];
        beta=[];
        ActToAct_NeurFiring = NeurFiring(ActToAct);
        ActToFz_NeurFiring = NeurFiring(ActToFz);
        minval=min([ActToAct_NeurFiring;ActToFz_NeurFiring]);
        maxval=max([ActToAct_NeurFiring;ActToFz_NeurFiring]);
        delval=(maxval-minval)/10;
        ValsToTest=[minval:delval:maxval];
        for z=ValsToTest
            alpha=[alpha,sum(ActToAct_NeurFiring>z)/length(ActToAct_NeurFiring)];
            beta=[beta,sum(ActToFz_NeurFiring>z)/length(ActToFz_NeurFiring)];
        end
        RocVal_ActTrans{m}(sp)=sum(beta-alpha)/length(beta)+0.5;
        RocAlpha_ActTrans{m}(sp,:)=alpha;
        RocBeta_ActTrans{m}(sp,:)=beta;
        
        % random
        for per = 1:pernum
            ToShuffle = [ActToAct_NeurFiring;ActToFz_NeurFiring];
            ToShuffle = ToShuffle(randperm(length(ToShuffle)));
            ActToAct_NeurFiring_Shuffled = ToShuffle(1:length(ActToAct_NeurFiring));
            ActToFz_NeurFiring_Shuffled = ToShuffle(length(ActToAct_NeurFiring)+1:end);
            for z=ValsToTest
                alpha=[alpha,sum(ActToAct_NeurFiring_Shuffled>z)/length(ActToAct_NeurFiring_Shuffled)];
                beta=[beta,sum(ActToFz_NeurFiring_Shuffled>z)/length(ActToFz_NeurFiring_Shuffled)];
            end
            RocVal_ActTrans_rand{m}(sp,per)=sum(beta-alpha)/length(beta)+0.5;
        end
        lim(1) = percentile(RocVal_ActTrans_rand{m}(sp,:),0.99);
        lim(2) = percentile(RocVal_ActTrans_rand{m}(sp,:),0.01);
        IsSig_ActTrans{m}(sp,1) =  RocVal_ActTrans{m}(sp)>lim(1);
        IsSig_ActTrans{m}(sp,2) =  RocVal_ActTrans{m}(sp)<lim(2);
        

         % Transitions From Freezing State
        alpha=[];
        beta=[];
        FzToFz_NeurFiring = NeurFiring(FzToFz);
        FzToAct_NeurFiring = NeurFiring(FzToAct);
        minval=min([FzToFz_NeurFiring;FzToAct_NeurFiring]);
        maxval=max([FzToFz_NeurFiring;FzToAct_NeurFiring]);
        delval=(maxval-minval)/10;
        ValsToTest=[minval:delval:maxval];
        for z=ValsToTest
            alpha=[alpha,sum(FzToFz_NeurFiring>z)/length(FzToFz_NeurFiring)];
            beta=[beta,sum(FzToAct_NeurFiring>z)/length(FzToAct_NeurFiring)];
        end
        RocVal_FzTrans{m}(sp)=sum(beta-alpha)/length(beta)+0.5;
        RocAlpha_FzTrans{m}(sp,:)=alpha;
        RocBeta_FzTrans{m}(sp,:)=beta;
        
        % random
        for per = 1:pernum
            ToShuffle = [FzToFz_NeurFiring;FzToAct_NeurFiring];
            ToShuffle = ToShuffle(randperm(length(ToShuffle)));
            FzToFz_NeurFiring_Shuffled = ToShuffle(1:length(FzToFz_NeurFiring));
            FzToAct_NeurFiring_Shuffled = ToShuffle(length(FzToFz_NeurFiring)+1:end);
            for z=ValsToTest
                alpha=[alpha,sum(FzToFz_NeurFiring_Shuffled>z)/length(FzToFz_NeurFiring_Shuffled)];
                beta=[beta,sum(FzToAct_NeurFiring_Shuffled>z)/length(FzToAct_NeurFiring_Shuffled)];
            end
            RocVal_FzTrans_rand{m}(sp,per)=sum(beta-alpha)/length(beta)+0.5;
        end
        lim(1) = percentile(RocVal_FzTrans_rand{m}(sp,:),0.99);
        lim(2) = percentile(RocVal_FzTrans_rand{m}(sp,:),0.01);
        IsSig_FzTrans{m}(sp,1) =  RocVal_FzTrans{m}(sp)>lim(1);
        IsSig_FzTrans{m}(sp,2) =  RocVal_FzTrans{m}(sp)<lim(2);      
    end
end

X = abs([RocVal_ActTrans{:}]-0.5);
Y = abs([RocVal_FzTrans{:}]-0.5);
[p,h,stats]=ModIndexPlot(X,Y)
            
            
Fz_sig = [];Act_sig=[];
for m=1:length(KeepFirstSessionOnly)
   Fz_sig=[Fz_sig,sum(sum(IsSig_FzTrans{m}'))];
   Act_sig=[Act_sig,sum(sum(IsSig_ActTrans{m}'))];
end
     
            
Fz_sig = [];Act_sig=[];
for m=1:length(KeepFirstSessionOnly)
   Fz_sig=[Fz_sig,RocVal_FzTrans{m}(sum(IsSig_FzTrans{m}')>0)];
   Act_sig=[Act_sig,RocVal_ActTrans{m}(sum(IsSig_ActTrans{m}')>0)];
end

   [p,h,stats]=ModIndexPlot(Act_sig,Fz_sig)
