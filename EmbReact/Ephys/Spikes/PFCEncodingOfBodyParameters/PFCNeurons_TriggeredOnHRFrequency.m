clear all,
MiceNumber=[507,508,509,510];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'UMazeCond'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_UMazeCond/Cond5
load('B_Low_Spectrum.mat')
Dir{1} = PathForExperimentsEmbReact(SessionNames{1});
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
FreqLims=[8:0.2:13];
LookAtneurons = 0; % whether or not to make plots
fig = figure;
for sess=1:length(SessionNames)
    for mm=1:length(MiceNumber)
        for d=1:length(Dir{sess}.path)
            if Dir{sess}.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                disp(num2str(Dir{sess}.ExpeInfo{d}{1}.nmouse))
                FolderList = Dir{sess}.path{d};
                
                % Get concatenated variables
                % Spikes
                S_concat=ConcatenateDataFromFolders_SB(FolderList,'spikes');
                % OB Spectrum
                OBSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','B_Low');
                % FreezingEpoch
                FzEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
                % LinearPosition
                LinPos_concat=ConcatenateDataFromFolders_SB(FolderList,'linearposition');
                y=interp1(Range(LinPos_concat),Data(LinPos_concat),Range(OBSpec_concat));
                LinPos_concat = tsd(Range(OBSpec_concat),y);
                
                
                % InstFreq
                heartrate=ConcatenateDataFromFolders_SB(FolderList,'heartrate');
                y=interp1(Range(heartrate),Data(heartrate),Range(OBSpec_concat));
                heartrate = tsd(Range(OBSpec_concat),y);
                
                linpos=Data((LinPos_concat));
                ToPlot=Data((heartrate));
                Dat=zscore(log(Data((OBSpec_concat)))');
                
                
                % get rid of ends
                ToPlot = ToPlot(3:end-3);
                Dat = Dat(:,3:end-3);
                linpos = linpos(3:end-3);
                
                MeanSpk{mm}=[];
                Occup{mm}=[];
                
                for sp=1:length(S_concat)
                    [Y,X]=hist(Range(S_concat{sp}),Range(OBSpec_concat));
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
                        MinBins =  floor(min(Occup{mm}(Occup{mm}>20))/5);
                        if MinBins==0
                            keyboard
                        else
                            for k=1:length(FreqLims)-1
                                Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
                                RandTrials = randperm(Occup{mm}(k));
                                if isempty(Bins) | length(Bins)<20
                                    for perm = 1:5
                                        MeanSpk_Err{mm}(sp,k,perm) = 0;
                                    end
                                else
                                    for perm = 1:5
                                        MeanSpk_Err{mm}(sp,k,perm) = nansum(dat(Bins(RandTrials((perm-1)*MinBins+1:(perm)*MinBins))))./MinBins;
                                    end
                                end
                            end
                            
                            errorbar(FreqLims(1:end-1),nanmean(squeeze(MeanSpk_Err{mm}(sp,:,:))'),stdError(squeeze(MeanSpk_Err{mm}(sp,:,:))'))
                            makepretty
                            saveas(fig.Number,[SaveFolder filesep 'AllNeurTuning_UmazeBehav' filesep 'tuning_HR' num2str(mm) '_' num2str(sp),'.png'])
                        end
                        
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
            end
        end
    end
end

save('HRTuning_PFC.mat','AllR2','AllRRand','AllPAnova','AllInfo','AllSpkAn','SpikeID','MouseID')

%
AllR2 = [];
AllRRand = [];
AllSpk = [];
AllPAnova= [];
AllInfo= [];
AllSpkAn = [];
MiceToKeep = [2:5];
SpikeID = [];
MouseID = [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
IsPFCNeuron = IsPFCNeuron(MiceToKeep);
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
ZScSp = naninterp(ZScSp);
imagesc(FreqLims,1:length(ind),smooth2a(ZScSp(:,ind)',0,2))
colormap parula
xlabel('OB Frequency')
ylabel('# SU ordered by preferred frequency')

figure
subplot(411)
mm=3;
sp = 31;
temp = smooth2a(squeeze(MeanSpk_Err{mm}(sp,:,:)),1,0);
errorbar(FreqLims(1:end-1),nanmean(temp'),stdError(temp'),'k')
makepretty
xlim([7 14])

subplot(412)
mm=1;
sp = 15;
temp = smooth2a(squeeze(MeanSpk_Err{mm}(sp,:,:)),1,0);
errorbar(FreqLims(1:end-1),nanmean(temp'),stdError(temp'),'k')
makepretty
xlim([7 14])

subplot(413)
mm=2;
sp = 25;
temp = smooth2a(squeeze(MeanSpk_Err{mm}(sp,:,:)),1,0);
errorbar(FreqLims(1:end-1),nanmean(temp'),stdError(temp'),'k')
makepretty
xlim([7 14])

subplot(414)
mm=3;
sp = 42;
temp = smooth2a(squeeze(MeanSpk_Err{mm}(sp,:,:)),1,0);
errorbar(FreqLims(1:end-1),nanmean(temp'),stdError(temp'),'k')
makepretty
xlim([7 14])

figure
pie([126,20,25,56]/length(AllPAnova))
m = magma(4);
colormap([0,0,0;m(2:end,:)])
colormap([1,1,1;m(2:end,:)])



