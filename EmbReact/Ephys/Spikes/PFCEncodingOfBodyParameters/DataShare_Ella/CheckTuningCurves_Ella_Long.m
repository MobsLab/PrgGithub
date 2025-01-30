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
            MeanSpk{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
            Occup{mm}(k)=length(Bins);
            occup = length(Bins)/length(ToPlot);
            % do the anova on one half o data, get tuning curve
            % on other
            MeanSpk_Half{mm}(sp,k)=nansum(dat(Bins(1:2:end)))./(length(Bins)/2);
            MeanSpk_HalfAn{mm}(sp,k)=nansum(dat(Bins(2:2:end)))./(length(Bins)/2);
            AllSpkAnova=[AllSpkAnova;dat(Bins(2:2:end))];
            AllIdAnova = [AllIdAnova;dat(Bins(2:2:end))*0+k];
            
        end
        
        [pvalanova,tbl,stats] = anova1(AllSpkAnova,AllIdAnova,'off');
        PvalAnovaInfo{mm}(sp) = pvalanova;
        % Get error bars on tuning curve
        if pvalanova<0.01
            MinBins =  floor(min(Occup{mm})/5);
            for k=1:length(FreqLims)-1
                Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
                RandTrials = randperm(Occup{mm}(k));
                for perm = 1:5
                    MeanSpk_Err{mm}(sp,k,perm) = nansum(dat(Bins(RandTrials((perm-1)*MinBins+1:(perm)*MinBins))))./MinBins;
                end
            end
            %
            %                         errorbar(FreqLims(1:end-1),nanmean(squeeze(MeanSpk_Err{mm}(sp,:,:))'),stdError(squeeze(MeanSpk_Err{mm}(sp,:,:))'))
            %                         makepretty
            %                         saveas(fig.Number,[SaveFolder filesep 'AllNeurTuning_UmazeBehav' filesep 'tuning_' num2str(mm) '_' num2str(sp),'.png'])
        end
        
        
        occ  =(Occup{mm}/sum(Occup{mm}));
        meanrate=sum(sum(MeanSpk{mm}(sp,:).*occ));
        
        Info{mm}(sp) = nansum(occ.*MeanSpk{mm}(sp,:).*log2(MeanSpk{mm}(sp,:)/meanrate));
        Infospike{mm}(sp) = Info{mm}(sp)/meanrate;
        
        
        [R,P]=corrcoef(ToPlot,dat);
        RSpk{mm}(sp)=R(1,2);
        PSpk{mm}(sp)=P(1,2);
        if LookAtneurons
            if P(1,2)<0.01
                subplot(121)
                plot(runmean(ToPlot,2),runmean(dat,2),'.')
                subplot(122)
                bar(FreqLims(1:end-1),MeanSpk{mm}(sp,:))
                keyboard
                clf
            end
        end
        
        for btstrp = 1:1000
            num=ceil(rand*length(ToPlot));
            ToPlot_rand = fliplr([ToPlot(num+1:end);ToPlot(1:num)]);
            [R,P]=corrcoef(ToPlot_rand,dat);
            RSpk_btstrp{mm}(sp,btstrp) = R(1,2);
            PSpk_btstrp{mm}(sp,btstrp) = P(1,2);
        end
    end
    
    OBData{mm}=[];
    linData{mm}=[];
    for k=1:length(FreqLims)-1
        Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
        OBData{mm}(k,:)=nanmean(Dat(:,Bins)');
        [Y,X]=hist(linpos(Bins)',[0.1:0.1:1]);
        linData{mm}(k,:)=Y/sum(Y);
    end
end


%
AllR2 = [];
AllRRand = [];
AllSpk = [];
AllPAnova= [];
AllInfo= [];
AllSpkAn = [];
SpikeID = [];
MouseID = [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
for mm=1:length(MiceNumber)
    AllR2 = [AllR2,RSpk{mm}(find(IsPFCNeuron{mm}))];
    AllRRand = [AllRRand,(RSpk_btstrp{mm}(find(IsPFCNeuron{mm}),:)')];
    AllSpk=[AllSpk;(MeanSpk_Half{mm}(find(IsPFCNeuron{mm}),:))];
    AllSpkAn=[AllSpkAn;(MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:))];
    AllPAnova = [AllPAnova,(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm})))];
    AllInfo= [AllInfo,(Infospike{mm}(find(IsPFCNeuron{mm})))];
    SpikeID = [SpikeID,1:length((PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))))];
    MouseID = [MouseID,[1:length((PvalAnovaInfo{mm}(find(IsPFCNeuron{mm}))))]*0+MiceNumber(mm)];
    
    
end
plim = 0.05/(length(AllPAnova));
ZScSp = smooth2a(nanzscore(AllSpkAn(AllPAnova<plim,1:25)')',0,2);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
ZScSp = (nanzscore(AllSpk(AllPAnova<plim,1:25)'));
imagesc(FreqLims,1:length(ind),smooth2a(ZScSp(:,ind)',0,2))
colormap parula
xlabel('OB Frequency')
ylabel('# SU ordered by preferred frequency')

figure
subplot(411)
mm=1;
sp = 14;
temp = smooth2a(squeeze(MeanSpk_Err{mm}(sp,:,:)),1,0);
errorbar(FreqLims(1:end-1),nanmean(temp'),stdError(temp'),'k')
makepretty
xlim([1 12])

subplot(412)
mm=3;
sp = 24;
temp = smooth2a(squeeze(MeanSpk_Err{mm}(sp,:,:)),1,0);
errorbar(FreqLims(1:end-1),nanmean(temp'),stdError(temp'),'k')
makepretty
xlim([1 12])

subplot(413)
mm=4;
sp = 16;
temp = smooth2a(squeeze(MeanSpk_Err{mm}(sp,:,:)),1,0);
errorbar(FreqLims(1:end-1),nanmean(temp'),stdError(temp'),'k')
makepretty
xlim([1 12])

subplot(414)
mm=4;
sp = 63;
temp = smooth2a(squeeze(MeanSpk_Err{mm}(sp,:,:)),1,0);
errorbar(FreqLims(1:end-1),nanmean(temp'),stdError(temp'),'k')
makepretty
xlim([1 12])

pie([0.59,0.06,0.08,0.27])
