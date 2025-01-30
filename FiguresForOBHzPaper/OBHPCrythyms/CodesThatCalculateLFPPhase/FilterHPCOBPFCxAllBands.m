% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphys=[242;243;244;248;253;254;258;259;299;394;395;402;403;450;451]';
OBXEphys=[230,249,250,291,297,298];
AllMice=[CtrlEphys,OBXEphys];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',AllMice);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
FreqRange=[1:12;[3:14]];
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
FiltBand=[3,6;3,6;3,6;5.5,8.5;5.5,8.5;5.5,8.5;3,6];

FolderName='FilteredLFP';
OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 20];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;

% Parameters for triggered spectro
for mm=3:length(Dir.path)
    clear chH chH1 chH2 Dur Mov LFPAll ChanAll
    cd(Dir.path{mm})
    disp(Dir.path{mm})
    mkdir(FolderName)
    load('behavResources.mat')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
     [ChanAll,LFPAll]=GetChannelsLFPPhaseCouplingOBHzProject(1);

    for cc=1:length(FieldNames)
        if not(isempty(LFPAll.(FieldNames{cc})))
            
            % Filtering and Hilbert
            if exist([FolderName,'/FzFilLFP',FieldNames{cc},'.mat'])==0
                disp([FolderName,'/FzFilLFP',FieldNames{cc},'.mat'])
                Signal=LFPAll.(FieldNames{cc});
                channel=ChanAll.(FieldNames{cc});
                % Step one : for each mini-epoch filter in freq ranges, get instantaneous phase with Hilbert
                if (length(Start(FreezeEpoch)))>0
                    for p=1:length(Start(FreezeEpoch))
                        LitEpoch=subset(FreezeEpoch,p);
                        for f=1:size(FreqRange,2)
                            for s=1:2
                                LFPFil{p,f}=FilterLFP(Restrict(Signal,LitEpoch),FreqRange(:,f),1024);
                                Hil=hilbert(Data(LFPFil{p,f}));
                                Phase{p,f}=tsd(Range(LFPFil{p,f}),phase(Hil));
                            end
                        end
                    end
                    
                    save([FolderName,'/FzFilLFP',FieldNames{cc},'.mat'],'channel','FreqRange','LFPFil','Phase','FreezeEpoch','-v7.3')
                    clear Phase LFPFil
                end
            end
            
            % Belluscio methd
            if exist([FolderName,'/MiniMaxiLFP',FieldNames{cc},'.mat'])==0
                disp([FolderName,'/MiniMaxiLFP',FieldNames{cc},'.mat'])
                % MiniMaxi
                Signal=LFPAll.(FieldNames{cc});
                channel=ChanAll.(FieldNames{cc});
                AllPeaks=FindPeaksForFrequency(Signal,OptionsMiniMaxi,0);
                AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
                Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(Signal,'s'));
                if AllPeaks(1,2)==1
                    PhaseInterpol=tsd(Range(Signal),mod(Y,2*pi));
                else
                    PhaseInterpol=tsd(Range(Signal),mod(Y+pi,2*pi));
                end
                save([FolderName,'/MiniMaxiLFP',FieldNames{cc},'.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
                clear AllPeaks PhaseInterpol
            end
            
            
            if exist(['FilteredLFP/FilSpecificBand',FieldNames{cc},'.mat'])==0
                disp(['FilteredLFP/FilSpecificBand',FieldNames{cc},'.mat']);
                SpBand=FiltBand(cc,:);
                Fil=FilterLFP(LFPAll.(FieldNames{cc}),SpBand,1024);
                channel=ChanAll.(FieldNames{cc});
                save(['FilteredLFP/FilSpecificBand',FieldNames{cc},'.mat'],'Fil','SpBand','channel')
                clear Fil SpBand channel
            end
        end
    end
    
    clear LFPFil Phase FreezeEpoch LFPFil
end


