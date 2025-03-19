% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
% Get directories
CtrlEphys=[242;243;244;248;253;254;258;259;299;394;395;402;403;450;451]';
OBXEphys=[230,249,250,291,297,298];
AllMice=[CtrlEphys,OBXEphys];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',AllMice);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Frequency bands to scan through
FreqRange=[1:12;[3:14]];
% Name of possible different structures
FieldNames={'OB1','OB2','OBLoc','HPC1','HPC2','HPCLoc','PFCx'};
% Freq bands specific to each area - only used for NM coupling
FiltBand=[3,6;3,6;3,6;5.5,8.5;5.5,8.5;5.5,8.5;3,6];
%Where to save things
FolderName='NeuronLFPCoupling';
% Number of bootstraps for statistics
DoStats=500;
% NM Ratios of phases to try, as in Scheffer-Teixeira 2016
MNRatio=[1,1;1,1.5;1,2;1,3;1,4;1,5];
nbin=30;
% Parameters for triggered spectro
for mm=1:length(Dir.path)
    mm
    clear chH chH1 chH2 Dur Mov LFPAll ChanAll
    cd(Dir.path{mm})
    if exist('SpikeData.mat')>0
        
        mkdir(FolderName)
        load('behavResources.mat')
        load('StateEpochSB.mat','TotalNoiseEpoch')
        FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
        FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
        if sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))>10
            TotEpoch=intervalSet(0,max(Range(Movtsd)));
            MovEpoch=TotEpoch-FreezeEpoch;
            MovEpoch=MovEpoch-TotalNoiseEpoch;
            MovEpoch=dropShortIntervals(MovEpoch,3*1e4);
            
            
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
            
            
            % Get PFcx LFP
            clear y LFP
            load('ChannelsToAnalyse/PFCx_deep.mat')
            chP=channel;
            clear LFP, load(['LFPData/LFP',num2str(chP),'.mat']);
            LFPAll.PFCx=LFP;
            ChanAll.PFCx=chP;
            
            
            % Get Neurons
            load LFPData/InfoLFP.mat
            chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
            load('SpikeData.mat')
            
            %% get the n° of the neurons of PFCx
            numtt=[]; % nb tetrodes ou montrodes du PFCx
            load LFPData/InfoLFP.mat
            chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
            load('SpikeData.mat')
            
            
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
            
            if exist([FolderName,'/NeuronModFreqAllStructCorrected.mat'])>0
                movefile([FolderName,'/NeuronModFreqAllStructCorrected.mat'],[FolderName,'/FzNeuronModFreqAllStructCorrected.mat'])
            end
            
            for cc=1:length(FieldNames)
                if not(isempty(ChanAll.(FieldNames{cc})))
                    % Phase coupling filtered signals - done in another code
                    % with dense array of frequencies (NeuronModulationAllFreqAllStruc)
                    
                    % Phase coupling filtered signals in specific regions of
                    % interest
                    % Freezing
                    if exist([FolderName,'/FzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])==0
                        disp([FolderName,'/FzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])
                        SpBand=FiltBand(cc,:);
                        Fil=FilterLFP(LFPAll.(FieldNames{cc}),SpBand,1024);
                        channel=ChanAll.(FieldNames{cc});
                        save(['FilteredLFP/FilSpecificBand',FieldNames{cc},'.mat'],'Fil','SpBand','channel')
                        for i=1:length(numNeurons)
                            [PhasesSpikes{i},mu{i},Kappa{i},pval{i}]=SpikeLFPModulationTransform(S{numNeurons(i)},Fil,FreezeEpoch,nbin,1,1);
                        end
                        save([FolderName,'/FzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'],'PhasesSpikes','mu','Kappa','pval','channel','SpBand','FreezeEpoch','-v7.3')
                        clear PhasesSpikes mu Kappa channel pval SpBand Fil
                    end
                    
                    %Movement
                    if exist([FolderName,'/NoFzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])==0
                        disp([FolderName,'/NoFzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'])
                        SpBand=FiltBand(cc,:);
                        Fil=FilterLFP(LFPAll.(FieldNames{cc}),SpBand,1024);
                        channel=ChanAll.(FieldNames{cc});
                        save(['FilteredLFP/FilSpecificBand',FieldNames{cc},'.mat'],'Fil','SpBand','channel')
                        for i=1:length(numNeurons)
                            [PhasesSpikes{i},mu{i},Kappa{i},pval{i}]=SpikeLFPModulationTransform(S{numNeurons(i)},Fil,MovEpoch,nbin,0,1);
                        end
                        save([FolderName,'/NoFzNeuronModFreqSpecificBandCorrected_',FieldNames{cc},'.mat'],'PhasesSpikes','mu','Kappa','pval','channel','SpBand','MovEpoch','-v7.3')
                        clear PhasesSpikes mu Kappa channel pval SpBand Fil
                    end
                    
                    
                    % Phase coupling, peak detection
                    % freezing
                    if exist([FolderName,'/FzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])==0
                        disp([FolderName,'/FzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])
                        load(['FilteredLFP/MiniMaxiLFP',FieldNames{cc},'.mat'],'PhaseInterpol');
                        Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
                        dat=Data(Sig1);tps=Range(Sig1);
                        tps(isnan(dat))=[]; dat(isnan(dat))=[];
                        Sig1=tsd(tps,dat);
                        
                        for i=1:length(numNeurons)
                            Stemp{numNeurons(i)}=Restrict(S{numNeurons(i)},intervalSet(min(Range(Sig1)),max(Range(Sig1))));
                            [PhasesSpikes.Real{i},mu.Real{i},Kappa.Real{i},pval.Real{i}]=SpikeLFPModulationTransform(Stemp{numNeurons(i)},Sig1,FreezeEpoch,nbin,1,1);
                            a=Range(Stemp{numNeurons(i)});
                            b=diff(a);
                            b=b(randperm(length(b)));
                            S1=tsd(cumsum(b),cumsum(b));
                            [PhasesSpikes.Rnd{i},mu.Rnd{i},Kappa.Rnd{i},pval.Rnd{i}]=SpikeLFPModulationTransform(S1,Sig1,FreezeEpoch,nbin,0,1);
                            clear S1 a b
                        end
                        channel=ChanAll.(FieldNames{cc});
                        save([FolderName,'/FzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'],'PhasesSpikes','mu','Kappa','pval','channel','FreezeEpoch','-v7.3')
                        clear PhasesSpikes mu Kappa channel pval Sig1
                    end
                    
                    % movement
                    if exist([FolderName,'/NoFzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])==0
                        disp([FolderName,'/NoFzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])
                        load(['FilteredLFP/MiniMaxiLFP',FieldNames{cc},'.mat'],'PhaseInterpol');
                        Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
                        dat=Data(Sig1);tps=Range(Sig1);
                        tps(isnan(dat))=[]; dat(isnan(dat))=[];
                        Sig1=tsd(tps,dat);
                        
                        for i=1:length(numNeurons)
                            Stemp{numNeurons(i)}=Restrict(S{numNeurons(i)},intervalSet(min(Range(Sig1)),max(Range(Sig1))));
                            [PhasesSpikes.Real{i},mu.Real{i},Kappa.Real{i},pval.Real{i}]=SpikeLFPModulationTransform(Stemp{numNeurons(i)},Sig1,MovEpoch,nbin,0,1);
                            a=Range(Stemp{numNeurons(i)});
                            b=diff(a);
                            b=b(randperm(length(b)));
                            S1=tsd(cumsum(b),cumsum(b));
                            [PhasesSpikes.Rnd{i},mu.Rnd{i},Kappa.Rnd{i},pval.Rnd{i}]=SpikeLFPModulationTransform(S1,Sig1,MovEpoch,nbin,0,1);
                            clear S1 a b
                        end
                        channel=ChanAll.(FieldNames{cc});
                        save([FolderName,'/NoFzNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'],'PhasesSpikes','mu','Kappa','pval','channel','MovEpoch','-v7.3')
                        clear PhasesSpikes mu Kappa channel pval Sig1
                    end
                    
                    %% All data
                    if exist([FolderName,'/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])==0
                        disp([FolderName,'/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'])
                        load(['FilteredLFP/MiniMaxiLFP',FieldNames{cc},'.mat'],'PhaseInterpol');
                        Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
                        dat=Data(Sig1);tps=Range(Sig1);
                        tps(isnan(dat))=[]; dat(isnan(dat))=[];
                        Sig1=tsd(tps,dat);
                        
                        for i=1:length(numNeurons)
                            Stemp{numNeurons(i)}=Restrict(S{numNeurons(i)},intervalSet(min(Range(Sig1)),max(Range(Sig1))));
                            [PhasesSpikes.Real{i},mu.Real{i},Kappa.Real{i},pval.Real{i}]=SpikeLFPModulationTransform(Stemp{numNeurons(i)},Sig1,TotEpoch,nbin,0,1);
                            a=Range(Stemp{numNeurons(i)});
                            b=diff(a);
                            b=b(randperm(length(b)));
                            S1=tsd(cumsum(b),cumsum(b));
                            [PhasesSpikes.Rnd{i},mu.Rnd{i},Kappa.Rnd{i},pval.Rnd{i}]=SpikeLFPModulationTransform(S1,Sig1,MovEpoch,nbin,0,1);
                            clear S1 a b
                        end
                        channel=ChanAll.(FieldNames{cc});
                        save([FolderName,'/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_',FieldNames{cc},'.mat'],'PhasesSpikes','mu','Kappa','pval','channel','MovEpoch','-v7.3')
                        clear PhasesSpikes mu Kappa channel pval Sig1
                    end

                end
            end
            clear  chH chH2 chH1 Chans HPCChannels FreezeEpoch ChanAll LFPAll MovEpoch
            
        end
    end
end

