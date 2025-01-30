clear all,
CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
% close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
numNeurons=[];
num=1;
StrucNames={'OB' 'HPC'}
KeepFirstSessionOnly=[1,5:length(Dir.path)];
Ep={'Fz','NoFz'};
FieldNames={'OB1','HPCLoc'};
nbin=30;
num=1;
for mm=KeepFirstSessionOnly
    Dir.path{mm}
    
    cd(Dir.path{mm})
    if exist('FilteredLFP/MiniMaxiLFPOB1.mat')>0
        load('FilteredLFP/MiniMaxiLFPOB1.mat')
        
        clear FreezeEpoch MovAcctsd
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
        
        
        InstBr=1./diff(AllPeaks(1:2:end,1));
        InstBrtps=AllPeaks(1:2:end,1);InstBrtps=InstBrtps(1:length(InstBr));
        y=interp1(InstBrtps,InstBr,[0:0.01:max(InstBrtps)]);
        BrFrtsd=tsd([0:0.01:max(InstBrtps)]'*1e4,y');
        AllBRFz{num}=Data(Restrict(BrFrtsd,FreezeEpoch));
        AllBRNoFz{num}=Data(Restrict(BrFrtsd,NoFreezeEpoch));
        num=num+1;
    end
end