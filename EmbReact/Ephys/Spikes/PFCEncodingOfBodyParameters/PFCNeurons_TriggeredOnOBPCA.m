clear all,
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'UMazeCond'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
Dir{1} = PathForExperimentsEmbReact(SessionNames{1});
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
NumLimsAll=[10,20,30,40];

for sess=1:length(SessionNames)
    for mm=1:length(MiceNumber)
        for d=1:length(Dir{sess}.path)
            if Dir{sess}.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                FolderList = Dir{sess}.path {d};
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
                Dat=zscore(log(Data(Restrict(OBSpec_concat,FzEp_concat)))');
                [EigVect,EigVals]=PerformPCA(Dat);
                x=Range(Restrict(OBSpec_concat,FzEp_concat),'s');
                fig=figure;
                fig.Position=[680,558,860,820];
                for k=1:3
                    subplot(3,4,1+(k-1)*4)
                    ToPlot=EigVect(:,k)'*Dat;
                    plot(x,ToPlot), hold on
                    line([0;0],[0*0+min(ylim);0*0+max(ylim)],'color','k')
                    ylabel(['Comp' num2str(k)])
                    title(num2str(round(100*EigVals(k)/sum(EigVals))))
                    
                    subplot(3,4,2+(k-1)*4)
                    plot(Spectro{3},EigVect(:,k))
                    
                    subplot(3,4,3+(k-1)*4)
                    [val,ind]=sort(ToPlot);
                    imagesc((Dat(:,ind))), axis xy, clim([-3 3]);
                    
                    subplot(3,4,4+(k-1)*4)
                    hist(ToPlot,100);
                end
                saveas(fig.Number,[SaveFolder,'OBPCAMouse',num2str(MiceNumber(mm)),'.png'])
                saveas(fig.Number,[SaveFolder,'OBPCAMouse',num2str(MiceNumber(mm)),'.fig'])
                close all

                
                for nmlm=1:length(NumLimsAll)
                    NumLims=NumLimsAll(nmlm);
                    fig=figure;
                    fig.Position=[271,2,1297,952];
                    for h=1:6
                        MeanSpk=[];
                        Occup=[];
                        if h==4
                            ToPlot=Data(Restrict(instfreq_concat_PT,FzEp_concat));
                            Titre = 'PeakTroughInstFreq';
                        elseif h==5
                            ToPlot=Data(Restrict(instfreq_concat_WV,FzEp_concat));
                            Titre = 'WaveletInstFreq';
                        elseif h==6
                            ToPlot=Data(Restrict(instfreq_concat_Both,FzEp_concat));
                            Titre = 'MeanInstFreq';
                        else
                            ToPlot=EigVect(:,h)'*Dat;
                            Titre = ['comp',num2str(h)];
                        end
                        ToPlot=ToPlot-percentile(ToPlot,5);
                        ToPlot=ToPlot./percentile(ToPlot,98);
                        for sp=1:length(S_concat)
                            [Y,X]=hist(Range(S_concat{sp}),Range(OBSpec_concat));
                            spike_count=tsd(X,Y');
                            dat=Data(Restrict(spike_count,FzEp_concat));
                            for k=1:NumLims
                                Bins=find(ToPlot>(k-1)*1/NumLims & ToPlot<(k)*1/NumLims);
                                MeanSpk(sp,k)=nansum(dat(Bins))./length(Bins);
                                Occup(k)=length(Bins);
                            end
                        end
                        clear OBData linData
                        for k=1:NumLims
                            Bins=find(ToPlot>(k-1)*1/NumLims & ToPlot<(k)*1/NumLims);
                            OBData(k,:)=nanmean(Dat(:,Bins)');
                            [Y,X]=hist(linpos(Bins)',[0.1:0.1:1]);
                            linData(k,:)=Y/sum(Y);
                        end
                        subplot(4,6,h)
                        [val,ind]=max(nanzscore(MeanSpk'));
                        tempmat=sortrows([ind',nanzscore(MeanSpk')']);
                        imagesc(tempmat(:,2:end))
                        title(Titre)
                        clim([-2 2]);
                        if h==1
                            ylabel('NeuronNum')
                        end
                        subplot(4,6,h+6)
                        imagesc(corr(tempmat(:,2:end)')),clim([-1 1]);
                        if h==1
                            ylabel('NeuronNum')
                        end
                        subplot(4,6,h+12)
                        imagesc([1:NumLims],Spectro{3},OBData')
                        axis xy
                        if h==1
                            ylabel('Frequency Hz')
                        end
                        subplot(4,6,h+18)
                        %                     plot(Occup,'linewidth',2,'color','k')
                        imagesc(linData')
                        axis xy
                        if h==1
                            ylabel('Position On Maze')
                        end
                    end
                    saveas(fig.Number,[SaveFolder,'PFCUnitOBPCAmouse',num2str(MiceNumber(mm)),'NumBins',num2str(NumLims),'.png'])
                    saveas(fig.Number,[SaveFolder,'PFCUnitOBPCAmouse',num2str(MiceNumber(mm)),'NumBins',num2str(NumLims),'.fig'])
                    close all
                end
            end
        end
        
        
    end
    
end




