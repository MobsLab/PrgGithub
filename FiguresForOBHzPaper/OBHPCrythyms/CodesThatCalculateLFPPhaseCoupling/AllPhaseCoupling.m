% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[254,253,258,299,395,403,451,248,244,402,230,249,250,291,297,298];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
% Freq bands specific to each area - only used for NM coupling
FiltBand=[3,6;3,6;3,6;5.5,8.5;5.5,8.5;5.5,8.5;3,6];
%Where to save things
FolderName='LFPPhaseCoupling';
% Number of bootstraps for statistics
DoStats=500;
% NM Ratios of phases to try, as in Scheffer-Teixeira 2016
MNRatio=[1,1;1,1.5;1,2;1,3;1,4;1,5;1.5,1;2,1;3,1;4,1;5,1];

% Parameters for triggered spectro
 for mm=1:length(Dir.path)
    mm
    clear chH chH1 chH2 Dur Mov LFPAll ChanAll
    cd(Dir.path{mm})
    mkdir(FolderName)
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
    
    [ChanAll,LFPAll]=GetChannelsLFPPhaseCouplingOBHzProject(1);
    
    AllCombi=combnk([1:length(FieldNames)],2);
    
    for cc=1:length(AllCombi)
        if not(strcmp(FieldNames{AllCombi(cc,1)}(1:2),FieldNames{AllCombi(cc,2)}(1:2)))
            if not(isempty(ChanAll.(FieldNames{AllCombi(cc,1)}))) & not(isempty(ChanAll.(FieldNames{AllCombi(cc,2)})))
                % Phase coupling filtered signals
                if exist(['LFPPhaseCoupling/FzPhaseCoupling',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'])==0
                    disp(['LFPPhaseCoupling/FzPhaseCoupling',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'])
                    DatLoaded=load(['FilteredLFP/FzFilLFP',FieldNames{AllCombi(cc,1)},'.mat'],'Phase');
                    Phase{1}=DatLoaded.Phase;
                    DatLoaded=load(['FilteredLFP/FzFilLFP',FieldNames{AllCombi(cc,2)},'.mat'],'Phase');
                    Phase{2}=DatLoaded.Phase;
                    [Index,IndexRand,Phase]=PhaseCouplingSlowOscillSameFreq(Phase,[],FreqRange,FreezeEpoch,DoStats,0);
                    channel=[ChanAll.(FieldNames{AllCombi(cc,1)}),ChanAll.(FieldNames{AllCombi(cc,2)})];
                    save([FolderName,'/FzPhaseCoupling',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'],'Index','FreqRange','IndexRand','channel','FreezeEpoch','-v7.3')
                    clear Phase Index IndexRand channel
                end
                % Phase coupling filtered signals in specific regions of
                % interest with MN coupling
                %if exist(['LFPPhaseCoupling/FzPhaseCouplingMN',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'])==0
                    disp(['LFPPhaseCoupling/FzPhaseCouplingMN',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'])
                    
                    if exist(['FilteredLFP/FilSpecificBand',FieldNames{AllCombi(cc,1)},'.mat'])>0
                        load(['FilteredLFP/FilSpecificBand',FieldNames{AllCombi(cc,1)},'.mat'],'Fil')
                        Sig1=Fil;
                    else
                        SpBand=FiltBand(AllCombi(cc,1),:);
                        Fil=FilterLFP(LFPAll.(FieldNames{AllCombi(cc,1)}),SpBand,1024);
                        channel=ChanAll.(FieldNames{AllCombi(cc,1)});
                        save(['FilteredLFP/FilSpecificBand',FieldNames{AllCombi(cc,1)},'.mat'],'Fil','SpBand','channel')
                        Sig1=Fil;
                    end
                    
                    if exist(['FilteredLFP/FilSpecificBand',FieldNames{AllCombi(cc,2)},'.mat'])>0
                        load(['FilteredLFP/FilSpecificBand',FieldNames{AllCombi(cc,2)},'.mat'],'Fil')
                        Sig2=Fil;
                    else
                        SpBand=FiltBand(AllCombi(cc,2),:);
                        Fil=FilterLFP(LFPAll.(FieldNames{AllCombi(cc,2)}),SpBand,1024);
                        channel=ChanAll.(FieldNames{AllCombi(cc,2)});
                        save(['FilteredLFP/FilSpecificBand',FieldNames{AllCombi(cc,2)},'.mat'],'Fil','SpBand','channel')
                        Sig2=Fil;
                    end
                    
                    [Index,IndexRand,FinalSig]=PhaseCouplingSlowOscillMNRatio(Sig1,Sig2,FreezeEpoch,DoStats,0,MNRatio);
                    channel=[ChanAll.(FieldNames{AllCombi(cc,1)}),ChanAll.(FieldNames{AllCombi(cc,2)})];
                    save([FolderName,'/FzPhaseCouplingMN',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'],'Index','MNRatio','IndexRand','channel','FreezeEpoch','-v7.3')
                    clear Phase Index IndexRand channel Sig1 Sig2 Fil
             %   end
                
             % Phase coupling, peak detection
             if exist(['LFPPhaseCoupling/FzPhaseCouplingMiniMaxi',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'])==0
                 disp(['LFPPhaseCoupling/FzPhaseCouplingMiniMaxi',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'])
                 DatLoaded=load(['FilteredLFP/MiniMaxiLFP',FieldNames{AllCombi(cc,1)},'.mat'],'PhaseInterpol');
                 Sig1=DatLoaded.PhaseInterpol;
                 DatLoaded=load(['FilteredLFP/MiniMaxiLFP',FieldNames{AllCombi(cc,2)},'.mat'],'PhaseInterpol');
                 Sig2=DatLoaded.PhaseInterpol;
                 [Index,IndexRand]=PhaseCouplingSlowOscillSameFreqMiniMaxi(Sig1,Sig2,FreezeEpoch,DoStats,0,MNRatio)
                 channel=[ChanAll.(FieldNames{AllCombi(cc,1)}),ChanAll.(FieldNames{AllCombi(cc,2)})];
                 save([FolderName,'/FzPhaseCouplingMiniMaxi',FieldNames{AllCombi(cc,1)},'_',FieldNames{AllCombi(cc,2)},'.mat'],'Index','MNRatio','IndexRand','channel','FreezeEpoch','-v7.3')
                 clear Phase Index IndexRand channel Sig1 Sig2
             end
             
            end
        end
    end
    
    clear  chH chH2 chH1 Chans HPCChannels FreezeEpoch ChanAll LFPAll
    
end

