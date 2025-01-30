% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories

Dir1 = PathForExperimentFEAR('Fear-electrophy');
Dir2 = PathForExperimentFEAR('Fear-electrophy-opto');
Dir = MergePathForExperiment(Dir1,Dir2);



% Name of possible different structures
% FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
FieldNames={'OB1','PFCx'};
% Freq bands specific to each area
% FiltBand=[3,6;3,6;3,6;5.5,8.5;5.5,8.5;5.5,8.5;3,6];
FiltBand=[3,6;3,6];

% for minim axi phase
OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 20];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;


%Where to save things
FolderName='NeuronLFPCoupling_OB4HzPaper';

nbin=30;

for mm=68:length(Dir.path)
    disp(num2str(mm))
    if exist(Dir.path{mm})>0
        clear chH chH1 chH2 Dur Mov LFPAll ChanAll S TotalNoiseEpoch Movtsd
        cd(Dir.path{mm})
        if exist('SpikeData.mat')>0
            load('SpikeData.mat')
            if not(isempty(cellnames))
                disp(['        ', Dir.path{mm}])
                mkdir(FolderName)
                mkdir('FilteredLFP')
                load('behavResources.mat')
                
                
                try
                    % Get HPC LFP
                    if exist('LFPData/LocalHPCActivity.mat')>0
                        load('LFPData/InfoLFP.mat')
                        clear LFP, load('LFPData/LocalHPCActivity.mat')
                        LFPAll.HPCLoc=LFP;
                        ChanAll.HPCLoc=HPCChannels;
                        
                        ChanAll.HPC1=HPCChannels(1);
                        clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC1),'.mat']);
                        LFPAll.HPC1=LFP;
                        
                        ChanAll.HPC2=HPCChannels(2);
                        clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC2),'.mat']);
                        LFPAll.HPC2=LFP;
                    else
                        ChanAll.HPCLoc=[];
                        LFPAll.HPCLoc=[];
                        try
                            load('ChannelsToAnalyse/dHPC_deep.mat')
                            chH=channel;
                        catch
                            load('ChannelsToAnalyse/dHPC_rip.mat')
                            chH=channel;
                        end
                        ChanAll.HPC1=chH;
                        clear LFP, load(['LFPData/LFP',num2str(ChanAll.HPC1),'.mat']);
                        LFPAll.HPC1=LFP;
                        
                        ChanAll.HPC2=[];
                        LFPAll.HPC2=[];
                    end
                end
                
                try
                    % Get OB LFP
                    if exist('LFPData/LocalOBActivity.mat')>0
                        load('LFPData/InfoLFP.mat')
                        clear LFP, load('LFPData/LocalOBActivity.mat')
                        LFPAll.OBLoc=LFP;
                        ChanAll.OBLoc=OBChannels;
                        
                        ChanAll.OB1=OBChannels(1);
                        clear LFP, load(['LFPData/LFP',num2str(ChanAll.OB1),'.mat']);
                        LFPAll.OB1=LFP;
                        
                        ChanAll.OB2=OBChannels(2);
                        clear LFP, load(['LFPData/LFP',num2str(ChanAll.OB2),'.mat']);
                        LFPAll.OB2=LFP;
                    elseif exist('ChannelsToAnalyse/Bulb_deep.mat')>0
                        LFPAll.OBLoc=[];
                        ChanAll.OBLoc=[];
                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        ChanAll.OB1=channel;
                        clear LFP, load(['LFPData/LFP',num2str(ChanAll.OB1),'.mat']);
                        LFPAll.OB1=LFP;
                        
                        ChanAll.OB2=[];
                        LFPAll.OB2=[];
                    else
                        ChanAll.OBLoc=[];
                        LFPAll.OBLoc=[];
                        ChanAll.OB1=[];
                        LFPAll.OB1=[];
                        ChanAll.OB2=[];
                        LFPAll.OB2=[];
                    end
                end
                
                try
                    % Get PFcx LFP
                    clear y LFP
                    load('ChannelsToAnalyse/PFCx_deep.mat')
                    chP=channel;
                    clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
                    LFPAll.PFCx=LFP;
                    ChanAll.PFCx=chP;
                    TotEpoch=intervalSet(0,max(Range(LFP)));
                end
                
                % Get Neurons
                load LFPData/InfoLFP.mat
                chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
                load('SpikeData.mat')
                
                %% get the n° of the neurons of PFCx
                numtt=[]; % nb tetrodes ou montrodes du PFCx
                load LFPData/InfoLFP.mat
                chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
                
                
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
                
                for cc=1:length(FieldNames)
                    if not(isempty(ChanAll.(FieldNames{cc})))
                        
                        % Phase coupling filtered signals in specific regions of
                        % interest
                        % All data -filtered
                        
                        %                 if exist([FolderName,'/AllEpochNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])==0
                        disp([FolderName,'/AllEpochNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])
                        SpBand=FiltBand(cc,:);
                        if exist(['FilteredLFP/FilSpecificBand',FieldNames{cc},'.mat'])>0
                            load(['FilteredLFP/FilSpecificBand',FieldNames{cc},'.mat'],'Fil','SpBand','channel')
                        else
                            Fil=FilterLFP(LFPAll.(FieldNames{cc}),SpBand,1024);
                            channel=ChanAll.(FieldNames{cc});
                            save(['FilteredLFP/FilSpecificBand',FieldNames{cc},'.mat'],'Fil','SpBand','channel')
                        end
                        for i=1:length(numNeurons)
                            [PhasesSpikes_temp{i},mu{i},Kappa{i},pval{i}] = SpikeLFPModulationTransform(S{numNeurons(i)},Fil,TotEpoch,nbin,0,1);
                            PhasesSpikes.Nontransf{i} = tsd(Range(S{numNeurons(i)}),PhasesSpikes_temp{i}.Nontransf);
                            PhasesSpikes.Transf{i} = tsd(Range(S{numNeurons(i)}),PhasesSpikes_temp{i}.Transf);
                        end
                        PhasesSpikes.Transf = tsdArray(PhasesSpikes.Transf);
                        PhasesSpikes.Nontransf = tsdArray(PhasesSpikes.Nontransf);
                        
                        save([FolderName,'/AllEpochNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'],'PhasesSpikes','mu','Kappa','pval','channel','SpBand','FreezeEpoch','-v7.3')
                        clear PhasesSpikes mu Kappa channel pval SpBand FilPhasesSpikes_temp
                        %                 end
                        
                        
                        % Belluscio methd
                        if exist(['FilteredLFP','/MiniMaxiLFP',FieldNames{cc},'.mat'])==0
                            disp(['FilteredLFP','/MiniMaxiLFP',FieldNames{cc},'.mat'])
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
                            save(['FilteredLFP','/MiniMaxiLFP',FieldNames{cc},'.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')
                            clear AllPeaks PhaseInterpol
                        end
                        
                        %% All data - peak trough
                        %                 if exist([FolderName,'/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])==0
                        disp([FolderName,'/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])
                        clear PhaseInterpol PhasesSpikes
                        load(['FilteredLFP/MiniMaxiLFP',FieldNames{cc},'.mat'],'PhaseInterpol');
                        Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
                        dat=Data(Sig1);tps=Range(Sig1);
                        tps(isnan(dat))=[]; dat(isnan(dat))=[];
                        Sig1=tsd(tps,dat);
                        
                        for i=1:length(numNeurons)
                            Stemp=Restrict(S{numNeurons(i)},intervalSet(min(Range(Sig1)),max(Range(Sig1))));
                            [PhasesSpikes_temp{i},mu{i},Kappa{i},pval{i}] = SpikeLFPModulationTransform(Stemp,Sig1,TotEpoch,nbin,0,1);
                            PhasesSpikes.Nontransf{i} = tsd( Range(Stemp),PhasesSpikes_temp{i}.Nontransf);
                            PhasesSpikes.Transf{i} = tsd( Range(Stemp),PhasesSpikes_temp{i}.Transf);
                            clear Stemp
                        end
                        channel=ChanAll.(FieldNames{cc});
                        
                        save([FolderName,'/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'],'PhasesSpikes','mu','Kappa','pval','channel','-v7.3')
                        clear PhasesSpikes mu Kappa channel pval Sig1
                        %                 end
                        
                    end
                end
                clear  chH chH2 chH1 Chans HPCChannels FreezeEpoch ChanAll LFPAll MovEpoch
            else
                disp(['        ', Dir.path{mm}])
                disp('del SpikeData')
                delete('SpikeData.mat')
            end
        end
    end
end