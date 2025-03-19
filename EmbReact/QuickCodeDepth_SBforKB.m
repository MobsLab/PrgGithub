clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];
ChanOfInterest = [16,20,4,8,3];

Binsize = 0.1*1e4;
SpeedLim = 2;

mm = 5;
mm
clear Dir
Dir = GetAllMouseTaskSessions(MiceNumber(mm));
x1 = strfind(Dir,'UMazeCond');
ToKeep = find(~cellfun(@isempty,x1));
Dir = Dir(ToKeep);

% Get Spectra different channels
for d = 1:length(Dir)
    cd(Dir{d})
    for k = 1:length(ChanOfInterest)
        LoadSpectrumML(ChanOfInterest(k),Dir{d});
    end
end

% Get Spectra from local
for d = 1:length(Dir)
    cd(Dir{d})
    load('LFPData/LFP16.mat'); LFP1 = LFP;
    load('LFPData/LFP3.mat'); LFP2 = LFP;
    
    LFP = tsd(Range(LFP),Data(LFP1)-Data(LFP2));
    
    [params,movingwin,suffix]=SpectrumParametersML('low');
    
    [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
    
    save('SpectrumDataL/Spectrum16vs3.mat','Sp','t','f','params','movingwin','-v7.3')
    
end

% Get spike phase locking
for d = 1:length(Dir)
    cd(Dir{d})
    load('SpikeData.mat')
    mkdir('NeuronModulationDifferentDepths')
%     for k = 1:length(ChanOfInterest)
%         channel = ChanOfInterest(k);
%         load(['LFPData/LFP',num2str(ChanOfInterest(k)),'.mat']);
%         SpBand = [2 6];
%         Fil=FilterLFP(LFP,[2 6],1024);
%         TotalEpoch = intervalSet(0,max(Range(LFP)));
%         clear PhasesSpikes mu Kappa pval
%         for i=1:length(S)
%             [PhasesSpikes{i},mu{i},Kappa{i},pval{i}]=SpikeLFPModulationTransform(S{i},Fil,TotalEpoch,30,0,1);
%         end
%         
%         
%         save([cd filesep 'NeuronModulationDifferentDepths/NeuronModFreqSpecificBand2to6_',num2str(ChanOfInterest(k)),'.mat'],'PhasesSpikes','mu','Kappa','pval','channel','SpBand','TotalEpoch','-v7.3')
%         clear PhasesSpikes mu Kappa channel pval SpBand Fil
%     end
    SpBand = [2 6];
    
    channel = [16 4];
    load('LFPData/LFP16.mat'); LFP1 = LFP;
    load('LFPData/LFP4.mat'); LFP2 = LFP;
            TotalEpoch = intervalSet(0,max(Range(LFP)));

    LFP = tsd(Range(LFP),Data(LFP1)-Data(LFP2));
    Fil=FilterLFP(LFP,[2 6],1024);
    clear PhasesSpikes mu Kappa pval
    for i=1:length(S)
        [PhasesSpikes{i},mu{i},Kappa{i},pval{i}]=SpikeLFPModulationTransform(S{i},Fil,TotalEpoch,30,0,1);
    end
    save([cd filesep 'NeuronModulationDifferentDepths/NeuronModFreqSpecificBand2to6_LocalBis.mat'],'PhasesSpikes','mu','Kappa','pval','channel','SpBand','TotalEpoch','-v7.3')
    clear PhasesSpikes mu Kappa channel pval SpBand Fil
    
end

clear Spec
for k = 1:length(ChanOfInterest)
    Spec{k} = ConcatenateDataFromFolders_SB(Dir,'Spectrum','spec_chan_num',num2str(ChanOfInterest(k)));
end
Spec{k+1} = ConcatenateDataFromFolders_SB(Dir,'Spectrum','spec_chan_num','16vs8');
Spec{k+2} = ConcatenateDataFromFolders_SB(Dir,'Spectrum','spec_chan_num','16vs4');
Spec{k+3} = ConcatenateDataFromFolders_SB(Dir,'Spectrum','spec_chan_num','16vs3');

FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');

clf
cols = [jet(5);[0 0 0];[0.8 0.8 0.8];[0.4 0.4 0.4]]
for k = 1:length(ChanOfInterest)+3
    plot(f,nanmean(log(Data(Restrict(Spec{k},FreezeEpoch-NoiseEpoch)))),'linewidth',3,'color',cols(k,:)), 
    hold on
end
legend({'16','20','4','8','3','16vs8','16vs4','16vs3'})
xlabel('Frequency(Hz)')
ylabel('Power (log)')
box off
set(gca,'LineWidth',2,'FontSize',15)


% Local
clear mu Kappa pval
for i=1:length(numNeurons)
    AllPhaseSpikes.Local{i} = [];
end


for d = 1:length(Dir)
    cd(Dir{d})
    
    load('SpikeData.mat')
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    load('behavResources_SB.mat')
    
    load([cd filesep 'NeuronModulationDifferentDepths/NeuronModFreqSpecificBand2to6_Local.mat'],'PhasesSpikes')
    for i=1:length(numNeurons)
        Phasetsd = tsd(Range(S{numNeurons(i)}),PhasesSpikes{numNeurons(i)}.Transf);
        
        AllPhaseSpikes.Local{i} = [AllPhaseSpikes.Local{i};Data(Restrict(Phasetsd,Behav.FreezeAccEpoch))];
    end
end
for i=1:length(numNeurons)
    [mu.Local(i), Kappa.Local(i), pval.Local(i), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllPhaseSpikes.Local{i});
end

% Localbis
for i=1:length(numNeurons)
    AllPhaseSpikes.LocalBis{i} = [];
end


for d = 1:length(Dir)
    cd(Dir{d})
    
    load('SpikeData.mat')
    [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
    load('behavResources_SB.mat')
    
    load([cd filesep 'NeuronModulationDifferentDepths/NeuronModFreqSpecificBand2to6_LocalBis.mat'],'PhasesSpikes')
    for i=1:length(numNeurons)
        Phasetsd = tsd(Range(S{numNeurons(i)}),PhasesSpikes{numNeurons(i)}.Transf);
        AllPhaseSpikes.LocalBis{i} = [AllPhaseSpikes.LocalBis{i};Data(Restrict(Phasetsd,Behav.FreezeAccEpoch))];
    end
end

for i=1:length(numNeurons)
    [mu.LocalBis(i), Kappa.LocalBis(i), pval.LocalBis(i), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllPhaseSpikes.LocalBis{i});
end


for k = 1:length(ChanOfInterest)
    for i=1:length(numNeurons)
        AllPhaseSpikes.NonLocal{k}{i} = [];
    end
    
    
    for d = 1:length(Dir)
        cd(Dir{d})
        
        load('SpikeData.mat')
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        load('behavResources_SB.mat')
        
        load([cd filesep 'NeuronModulationDifferentDepths/NeuronModFreqSpecificBand2to6_',num2str(ChanOfInterest(k)),'.mat'],'PhasesSpikes')
        for i=1:length(numNeurons)
            Phasetsd = tsd(Range(S{numNeurons(i)}),PhasesSpikes{numNeurons(i)}.Transf);
            
            AllPhaseSpikes.NonLocal{k}{i} = [AllPhaseSpikes.NonLocal{k}{i};Data(Restrict(Phasetsd,Behav.FreezeAccEpoch))];
        end
    end
    for i=1:length(numNeurons)
        [mu.NonLocal{k}(i), Kappa.NonLocal{k}(i), pval.NonLocal{k}(i), Rmean, delta, sigma,confDw,confUp] = CircularMean(AllPhaseSpikes.NonLocal{k}{i});
    end
end

cols = [jet(5);[0 0 0];[0.8 0.8 0.8]]
PvalPerChan = []
for k = 1:length(ChanOfInterest)
    PvalPerChan(k) = nansum(pval.NonLocal{k}<0.05)./length(pval.NonLocal{k});
end
PvalPerChan(k+1) = nansum(pval.Local<0.05)./length(pval.Local);
PvalPerChan(k+2)= nansum(pval.LocalBis)./length(pval.LocalBis);
figure
for p = 1:length(PvalPerChan)
bar(p,PvalPerChan(p),'FaceColor',cols(p,:)), hold on
end
set(gca,'Xtick',[1:p],'XTickLabel',{'16','20','4','8','3','16vs8','16vs4'})
ylabel('Prop sig units')
box off
set(gca,'LineWidth',2,'FontSize',15)
xtickangle(45)

figure
cols = [jet(5);[0 0 0];[0.8 0.8 0.8]]
for k = 1:length(ChanOfInterest)
    AllKappa{k} = Kappa.NonLocal{k}(pval.NonLocal{k}<0.05);
end
AllKappa{k+1}= Kappa.Local(pval.Local<0.05);
AllKappa{k+2}= Kappa.LocalBis(pval.LocalBis<0.05);
for c = 1:length(cols)
    Cols{c} = cols(c,:);
end
MakeSpreadAndBoxPlot_SB(AllKappa,Cols,1:7)
set(gca,'Xtick',[1:p],'XTickLabel',{'16','20','4','8','3','16vs8','16vs4'})
ylabel('Kappa for sig units')
box off
set(gca,'LineWidth',2,'FontSize',15)
xtickangle(45)

figure
for k = 1:length(ChanOfInterest)
    AllKappa{k} = mu.NonLocal{k}(pval.NonLocal{k}<0.05);
end
AllKappa{k+1}= mu.Local(pval.Local<0.05);
AllKappa{k+2}= mu.LocalBis(pval.LocalBis<0.05);

Tit = {'16','20','4','8','3','16vs8','16vs4'};
figure
for k = 1:length(ChanOfInterest)+2
    subplot(7,1,k)
    [Y,X] = hist(AllKappa{k},10);
    Y = Y/sum(Y);
    bar([X,X+2*pi],[Y,Y],'FaceColor',cols(k,:))
    title(Tit{k})
    box off
set(gca,'LineWidth',2,'FontSize',15)
% xlabel('Phase')
% ylabel('Spike count')
end
