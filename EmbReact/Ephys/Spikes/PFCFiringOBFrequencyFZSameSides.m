clear all,
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'UMazeCond'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
Dir{1} = PathForExperimentsEmbReact(SessionNames{1});
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
FreqLims=[2.5:0.15:6];
load('B_Low_Spectrum.mat')

for sess=1:length(SessionNames)
    for mm=2:length(MiceNumber)
        for d=1:length(Dir{sess}.path)
            if Dir{sess}.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                disp(num2str(Dir{sess}.ExpeInfo{d}{1}.nmouse))
                FolderList = Dir{sess}.path {d};
                % Get concatenated variables
                % Spikes
                S_concat=ConcatenateDataFromFolders_SB(FolderList,'spikes');
                % OB Spectrum
                OBSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','B_Low');
                % FreezingEpoch
                FzEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
                % ZoneEpoch
                ZnEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','zoneepoch');
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
                
                
                % LinearPosition
                LinPos_concat=ConcatenateDataFromFolders_SB(FolderList,'linearposition');
                y=interp1(Range(LinPos_concat),Data(LinPos_concat),Range(OBSpec_concat));
                LinPos_concat = tsd(Range(OBSpec_concat),y);
            end
        end
        
        clear Hist_s
        for sp=1:length(S_concat)
            Hist_s(sp,:)=hist(Range(S_concat{sp},'s'),[0:1:max(Range(OBSpec_concat,'s'))]);
        end
        Hist_tsd=tsd([0:1:max(Range(OBSpec_concat,'s'))]*1e4,Hist_s');
        
        freq_subsampled = interp1(Range(instfreq_concat_Both),Data(instfreq_concat_Both),Range(Hist_tsd));
        freq_subsampled = tsd(Range(Hist_tsd),naninterp(freq_subsampled));
        
        lin_subsampled = interp1(Range(LinPos_concat),Data(LinPos_concat),Range(Hist_tsd));
        lin_subsampled = tsd(Range(Hist_tsd),naninterp(lin_subsampled));
        
        SafeEpoch = and(FzEp_concat,or(ZnEp_concat{2},ZnEp_concat{5}));
        ShockEpoch = and(FzEp_concat,ZnEp_concat{1});
        
        
        %% Different average Freq
        fig=figure;
        plot(Spectro{3},nanmean((Data(Restrict(OBSpec_concat,SafeEpoch)))),'b')
        hold on
        plot(Spectro{3},nanmean((Data(Restrict(OBSpec_concat,ShockEpoch)))),'r')
        xlim([0 20])
        legend('Safe','Shock')
        saveas(fig.Number,[SaveFolder,'OBSpecTwoKindsFreezing_M',num2str(MiceNumber(mm)),'.fig'])
        saveas(fig.Number,[SaveFolder,'OBSpecTwoKindsFreezing_M',num2str(MiceNumber(mm)),'.png'])
        
        
        fig=figure;
        subplot(3,3,[2,3,5,6])
        X1=zscore(Data(Restrict(Hist_tsd,SafeEpoch)));
        X2=zscore(Data(Restrict(Hist_tsd,ShockEpoch)));
        NeuronCorr = corr(X1',X2');
        NeuronCorr = [Data(Restrict(freq_subsampled,SafeEpoch)),NeuronCorr];
        NeuronCorr = sortrows(NeuronCorr);
        NeuronCorr = NeuronCorr(:,2:end);
        NeuronCorr = [Data(Restrict(freq_subsampled,ShockEpoch)),NeuronCorr'];
        NeuronCorr = sortrows(NeuronCorr);
        NeuronCorr = NeuronCorr(:,2:end);
        imagesc(SmoothDec(NeuronCorr,1))
        axis xy
        colormap redblue
        clim([-0.1 0.1])
        subplot(3,3,[1,4])
        plot(runmean(sort(Data(Restrict(freq_subsampled,ShockEpoch))),2))
        axis tight
        line(xlim,[4 4]), ylim([1.5 6.5])
        view(90,-90)
        xlabel('Shock')
        subplot(3,3,[8,9])
        plot(runmean(sort(Data(Restrict(freq_subsampled,SafeEpoch))),2))
        axis tight
        line(xlim,[4 4]), ylim([1.5 6.5])
        xlabel('Safe')
        saveas(fig.Number,[SaveFolder,'CorrelationBetweenTwoSides_M',num2str(MiceNumber(mm)),'.fig'])
        saveas(fig.Number,[SaveFolder,'CorrelationBetweenTwoSides_M',num2str(MiceNumber(mm)),'.png'])
        
        X1=zscore(Data(Restrict(Hist_tsd,SafeEpoch)));
        X2=zscore(Data(Restrict(Hist_tsd,ShockEpoch)));
        fig=figure;
        subplot(2,2,1)
        NeuronCorr = corr(X1',X1');
        NeuronCorr = [Data(Restrict(freq_subsampled,SafeEpoch)),NeuronCorr];
        NeuronCorr = sortrows(NeuronCorr);
        NeuronCorr = NeuronCorr(:,2:end);
        NeuronCorr = [Data(Restrict(freq_subsampled,SafeEpoch)),NeuronCorr'];
        NeuronCorr = sortrows(NeuronCorr);
        NeuronCorr = NeuronCorr(:,2:end);
        imagesc(SmoothDec(NeuronCorr,2))
        axis xy
        colormap redblue
        clim([-0.1 0.1]);
        title('safe')
        subplot(2,2,3)
        [val,ind] = sort(Data(Restrict(freq_subsampled,SafeEpoch)));
        dat=Data(Restrict(lin_subsampled,SafeEpoch));
        plot(dat(ind))
        ylabel('Position')
        axis tight
        subplot(2,2,2)
        NeuronCorr = corr(X2',X2');
        NeuronCorr = [Data(Restrict(freq_subsampled,ShockEpoch)),NeuronCorr];
        NeuronCorr = sortrows(NeuronCorr);
        NeuronCorr = NeuronCorr(:,2:end);
        NeuronCorr = [Data(Restrict(freq_subsampled,ShockEpoch)),NeuronCorr'];
        NeuronCorr = sortrows(NeuronCorr);
        NeuronCorr = NeuronCorr(:,2:end);
        imagesc(SmoothDec(NeuronCorr,2))
        axis xy
        colormap redblue
        clim([-0.1 0.1]);
        title('shock')
        subplot(2,2,4)
        [val,ind] = sort(Data(Restrict(freq_subsampled,ShockEpoch)));
        dat=Data(Restrict(lin_subsampled,ShockEpoch));
        plot(dat(ind))
        axis tight
        ylabel('Position')
        
        saveas(fig.Number,[SaveFolder,'AutoCorrSperateSides_M',num2str(MiceNumber(mm)),'.fig'])
        saveas(fig.Number,[SaveFolder,'AutoCorrSperateSides_M',num2str(MiceNumber(mm)),'.png'])
        
        close all
        
        
        
    end
end

