clear all,
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'UMazeCond'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
load('B_Low_Spectrum.mat')
Dir{1} = PathForExperimentsEmbReact(SessionNames{1});
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
FreqLims=[2.5:0.15:6];
LookAtneurons = 0; % whether or not to make plots

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
                instfreq_concat_PT=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
                y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),Range(OBSpec_concat));
                instfreq_concat_PT = tsd(Range(OBSpec_concat),y);
                instfreq_concat_WV=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
                instfreq_concat_WV=Restrict(instfreq_concat_WV,ts(Range(OBSpec_concat)));
                y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),Range(OBSpec_concat));
                y(y>15)=NaN;
                y=naninterp(y);
                instfreq_concat_WV = tsd(Range(OBSpec_concat),y);
                instfreq_concat_Both = tsd(Range(OBSpec_concat),nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
                
                
                linpos=Data(Restrict(LinPos_concat,FzEp_concat));
                ToPlot=Data(Restrict(instfreq_concat_Both,FzEp_concat));
                Dat=zscore(log(Data(Restrict(OBSpec_concat,FzEp_concat)))');
                
                % get rid of ends
                ToPlot = ToPlot(3:end-3);
                Dat = Dat(:,3:end-3);
                linpos = linpos(3:end-3);
                
                MeanSpk{mm}=[];
                Occup{mm}=[];
                
                for sp=1:length(S_concat)
                    [Y,X]=hist(Range(S_concat{sp}),Range(OBSpec_concat));
                    spike_count=tsd(X,Y');
                    dat=Data(Restrict(spike_count,FzEp_concat));
                    dat = dat(3:end-3);   
                    AllSpkAnova=[];
                    AllIdAnova = [];

                    for k=1:length(FreqLims)-1
                        Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
                        MeanSpk{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
                        Occup{mm}(k)=length(Bins);
                        occup = length(Bins)/length(ToPlot);    
                        AllSpkAnova=[AllSpkAnova;dat(Bins)];
                        AllIdAnova = [AllIdAnova;dat(Bins)*0+k];
                    end
                    
                    
                    [pvalanova,tbl,stats] = anova1(AllSpkAnova,AllIdAnova,'off');
                    PvalAnovaInfo{mm}(sp) = pvalanova;
                    
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
        end
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCOnOBFrequency
 save('PFCUnitFiringOnOBFrequency.mat','OBData','linData','PSpk','RSpk','PSpk_btstrp','RSpk_btstrp','MeanSpk',...
     'Info','Infospike','Occup','PvalAnovaInfo')
save('PFCUnitFiringOnOBFrequency.mat','PvalAnovaInfo','-append')
% 
AllR2 = [];
AllRRand = [];
AllSpk = [];
AllPAnova= [];
AllInfo= [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
for mm=1:length(MiceNumber)
    AllR2 = [AllR2,RSpk{mm}(find(IsPFCNeuron{mm}))];
    AllRRand = [AllRRand,(RSpk_btstrp{mm}(find(IsPFCNeuron{mm}),:)')];
    AllSpk=[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
    AllPAnova = [AllPAnova,(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm})))];
    AllInfo= [AllInfo,(Infospike{mm}(find(IsPFCNeuron{mm})))];
end
clf
[Y,X] = hist(AllR2,[-0.3:0.01:0.3]);
bar(X,Y/sum(Y))
hold on
% [Y2,X] = hist(AllR2(abs(GoodNeur)>0),[-0.3:0.01:0.3]);
% bar(X,Y2/sum(Y2))
[Y,X] = hist(AllRRand,[-0.3:0.01:0.3]);
stairs(X,nanmean(Y')/sum(nanmean(Y')),'linewidth',4,'color','k')


GoodNeur = [];
PNeur = [];
RNeur = [];

for mm=1:length(MiceNumber)
    for sp=1:length(RSpk{mm})
        if IsPFCNeuron{mm}(sp)==1
            
            if RSpk{mm}(sp)>prctile(RSpk_btstrp{mm}(sp,:),97.5)
                GoodNeur = [GoodNeur,1];
            elseif RSpk{mm}(sp)<prctile(RSpk_btstrp{mm}(sp,:),2.5);
                GoodNeur = [GoodNeur,-1];
            else
                GoodNeur = [GoodNeur,0];
            end
            PNeur = [PNeur,PSpk{mm}(sp)];
            RNeur = [RNeur,RSpk{mm}(sp)];            
            
        end
    end
end



