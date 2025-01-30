% Calculate spectra,coherence and Granger
clear all
% Get data
close all

rmpath('/home/vador/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
FolderName='NeuronLFPCoupling_OB4HzPaper';

nbin = 30;

for mm=4:length(Dir.path)
    Dir.path{mm}
    cd(Dir.path{mm})
    
    load('behavResources.mat')
    tpsmax=max(Range(Movtsd));
    
    if exist('SpikeData.mat')>0
        
        mkdir(FolderName)
        mkdir('FilteredLFP')
        
        clear numNeurons chR Sig1 LFP Breathtsd
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('SpikeData.mat')
        load('BreathingInfo.mat')
        
        %% get the n° of the neurons of PFCx
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        load('ChannelsToAnalyse/Respi.mat'); chR=channel;
        
        
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
        
        
        clear LFP
        load(['LFPData/LFP',num2str(chR),'.mat'])
        clear ph mu Kappa pval FR FFTAC
        TotEpoch = intervalSet(min(Range(LFP)),max(Range(LFP)));
        
        % MiniMaxi on respi
        disp(['FilteredLFP','/RespiPhaseMiniMaxi.mat'])
        channel=chR;
        
        Y=interp1(Range(Breathtsd,'s'),[0:2*pi:2*pi*(length(Breathtsd)-1)],Range(LFP,'s'));
        PhaseInterpol=tsd(Range(LFP),mod(Y+pi,2*pi));
        Sig1=tsd(Range(PhaseInterpol),-sin(mod(Data(PhaseInterpol),2*pi)-pi/2));
        save(['FilteredLFP','/RespiPhaseMiniMaxi.mat'],'channel','PhaseInterpol','-v7.3')
        
        
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
        
        save([FolderName,'/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_Respi.mat'],'PhasesSpikes','mu','Kappa','pval','channel','-v7.3')
        clear PhasesSpikes mu Kappa channel pval Sig1
        
    end
    close all
end

