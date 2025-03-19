clear all,

cd
MiceNumber=[490,507,508,509,510,512,514];

num_bootstraps = 100;
FreqLims=[2.5:0.3:11];
LookAtneurons = 0; % whether or not to make plots
fig = figure;

for mm = 1:length(MiceNumber)
    cd(['/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/justmaze/Mouse',num2str(MiceNumber(mm))])
    % Get concatenated variables
    load('timebins.mat')
    t = data*1E4;
    % Spikes
    load('Spk_times.mat')
    S_concat = data;
    % OB Spectrum
    load('OBSpec.mat')
    OBSpec_concat = data;
    % FreezingEpoch
    load('FzStartStop.mat')
    FzEp_concat = intervalSet(data(:,1)*1E4,data(:,2)*1E4);
    % LinearPosition
    load('LinPos.mat')
    LinPos_concat = tsd(t,data);
    
    
    % InstFreq
    load('BreathFreq.mat')
    instfreq_concat_Both = tsd(t,data);
    
    
    
    linpos=Data((LinPos_concat));
    ToPlot=Data((instfreq_concat_Both));
    Dat = zscore(log(((OBSpec_concat)))');
    
    
    % get rid of ends
    ToPlot = ToPlot(3:end-3);
    Dat = Dat(:,3:end-3);
    linpos = linpos(3:end-3);
    
    MeanSpk{mm}=[];
    Occup{mm}=[];
    
    for sp=1:length(S_concat)
        [Y,X]=hist(S_concat{sp}*1E4,t);
        spike_count=tsd(X,Y');
        %                     dat=Data(Restrict(spike_count,FzEp_concat));
        dat=Data((spike_count));
        dat = dat(3:end-3);
        AllSpkAnova=[];
        AllIdAnova = [];
        
        for k=1:length(FreqLims)-1
            
            Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
            %             MeanSpk{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
            MeanSpk{mm}(sp,k)=nanmean(dat(Bins));
            Occup{mm}(k)=length(Bins);
            occup = length(Bins)/length(ToPlot);
            
            
        end
        
    end
end


%
AllSpk = [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
for mm=1:length(MiceNumber)
    AllSpk=[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
    
    
end
ZScSp = smooth2a(nanzscore(AllSpk(:,1:25)')',0,2);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
ZScSp = (nanzscore(AllSpk(:,1:25)'));
imagesc(FreqLims,1:length(ind),smooth2a(ZScSp(:,ind)',0,2))
colormap parula
xlabel('OB Frequency')
ylabel('# SU ordered by preferred frequency')
