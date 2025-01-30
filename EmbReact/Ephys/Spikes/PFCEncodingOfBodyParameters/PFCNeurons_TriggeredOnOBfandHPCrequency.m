clear all,
MiceNumber=[490,507,508,509,510,512,514];
epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'UMazeCond'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
Dir{1} = PathForExperimentsEmbReact(SessionNames{1});
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing/';
FreqLims=[0:0.15:12];
global strsz se; strsz=3; se= strel('disk',strsz);

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
                % HPC Spectrum 
                HPCSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','H2_Low');
                
                % FreezingEpoch
                FzEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
                
                % LinearPosition
                LinPos_concat=ConcatenateDataFromFolders_SB(FolderList,'linearposition');
                y=interp1(Range(LinPos_concat),Data(LinPos_concat),Range(OBSpec_concat));
                LinPos_concat = tsd(Range(OBSpec_concat),y);
                
                
                % InstFreq - OB
                instfreq_concat_PT_B=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
                y=interp1(Range(instfreq_concat_PT_B),Data(instfreq_concat_PT_B),Range(OBSpec_concat));
                instfreq_concat_PT_B = tsd(Range(OBSpec_concat),y);
                instfreq_concat_WV_B=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
                instfreq_concat_WV_B=Restrict(instfreq_concat_WV_B,ts(Range(OBSpec_concat)));
                y=interp1(Range(instfreq_concat_WV_B),Data(instfreq_concat_WV_B),Range(OBSpec_concat));
                y(y>15)=NaN;
                y=naninterp(y);
                instfreq_concat_WV_B = tsd(Range(OBSpec_concat),y);
                instfreq_concat_Both_B = tsd(Range(OBSpec_concat),nanmean([Data(instfreq_concat_WV_B),Data(instfreq_concat_PT_B)]')');
                
                % InstFreq - HPC
                instfreq_concat_PT_H=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','H','method','PT');
                y=interp1(Range(instfreq_concat_PT_H),Data(instfreq_concat_PT_H),Range(HPCSpec_concat));
                instfreq_concat_PT_H = tsd(Range(HPCSpec_concat),y);
                instfreq_concat_WV_H=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','H','method','WV');
                instfreq_concat_WV_H=Restrict(instfreq_concat_WV_H,ts(Range(HPCSpec_concat)));
                y=interp1(Range(instfreq_concat_WV_H),Data(instfreq_concat_WV_H),Range(HPCSpec_concat));
                y(y>15)=NaN;
                y=naninterp(y);
                instfreq_concat_WV_H = tsd(Range(HPCSpec_concat),y);
                instfreq_concat_Both_H = tsd(Range(HPCSpec_concat),nanmean([Data(instfreq_concat_WV_H),Data(instfreq_concat_PT_H)]')');

                HpcPower = Data(HPCSpec_concat);
                HpcPower = nanmean(HpcPower(:,80:120)')'./nanmean(HpcPower(:,20:60)')';
                HpcPower = interp1(Range(HPCSpec_concat),HpcPower,Range(instfreq_concat_Both_H));
                HpcPower = tsd(Range(HPCSpec_concat),HpcPower);
                
                
                %% All data
                linpos=Data((LinPos_concat));
                Freq_B=Data((instfreq_concat_Both_B));
                Freq_H=Data((instfreq_concat_Both_H));
                Dat_B=(log(Data((OBSpec_concat)))');
                Dat_H=(log(Data((HPCSpec_concat)))');
                HpcPowerDat=Data((HpcPower));
                
                % get rid of ends
                Freq_B = Freq_B(3:end-3);
                Freq_H = Freq_H(3:end-3);
                Dat_H = Dat_H(:,3:end-3);
                linpos = linpos(3:end-3);
                HpcPowerDat = HpcPowerDat(3:end-3);
                  
                  
                dt = median(diff(Range(instfreq_concat_Both_H,'s')));
                % HPC and OB link spikes
                MeanSpk_HB{mm}=[];
                Occup_HB{mm}=[];
                for sp=1:length(S_concat)
                    [Y,X]=hist(Range(S_concat{sp}),Range(instfreq_concat_Both_H));
                    spike_count=tsd(X,Y');
                    dat=Data((spike_count));
                    dat = dat(3:end-3);
                    for k=1:length(FreqLims)-1
                        for l = 1:length(FreqLims)-1
                            Bins=find(Freq_H>FreqLims(k) & Freq_H<FreqLims(k+1) & Freq_B>FreqLims(l) & Freq_B<FreqLims(l+1));
                            MeanSpk_HB{mm}(sp,k,l)=nansum(dat(Bins))./(length(Bins)*dt);
                            Occup_HB{mm}(k,l)=length(Bins);
                        end
                    end
                    A = imdilate(Occup_HB{mm}>3,se);
                    Bound = bwboundaries(A);
                    B = squeeze(MeanSpk_HB{mm}(sp,:,:));
                    B(~A) = NaN;
                    MeanSpk_HB{mm}(sp,:,:) = B;
                    clf
                    subplot(3,3,[1,4])
                    plot(squeeze(nanmean(MeanSpk_HB{mm}(sp,:,:),3)),FreqLims(1:end-1))
                    axis xy
                    ylim([FreqLims(1),FreqLims(end)])
                    ylabel('HPCFrequency')
                    subplot(3,3,[8,9])
                    plot(FreqLims(1:end-1),squeeze(nanmean(MeanSpk_HB{mm}(sp,:,:),2)))
                    xlim([FreqLims(1),FreqLims(end)])
                    ylabel('OBFrequency')
                    colorbar
                    MeanSpk_HB{mm}(isnan(MeanSpk_HB{mm})) = 0;
                    subplot(3,3,[2,3,5,6])
                    imagesc(FreqLims,FreqLims,SmoothDec(squeeze(MeanSpk_HB{mm}(sp,:,:)),1)),hold on
                    plot(FreqLims(Bound{1}(:,2)),FreqLims(Bound{1}(:,1)),'w')
                    colorbar
                    title('Firing map')
                    axis xy
                    
                    saveas(fig.Number,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllNeuronsTuning_HPCOB/AllBehaviour_Mouse' num2str(MiceNumber(mm)), '_Unit',num2str(sp),'.png'])
                end
                
                %% FreezeingOnly
                linpos=Data(Restrict(LinPos_concat,FzEp_concat));
                Freq_B=Data(Restrict(instfreq_concat_Both_B,FzEp_concat));
                Freq_H=Data(Restrict(instfreq_concat_Both_H,FzEp_concat));
                Dat_B=(log(Data(Restrict(OBSpec_concat,FzEp_concat)))');
                Dat_H=(log(Data(Restrict(HPCSpec_concat,FzEp_concat)))');
                HpcPowerDat=Data(Restrict(HpcPower,FzEp_concat));
                
                % get rid of ends
                Freq_B = Freq_B(3:end-3);
                Freq_H = Freq_H(3:end-3);
                Dat_H = Dat_H(:,3:end-3);
                linpos = linpos(3:end-3);
                  HpcPowerDat = HpcPowerDat(3:end-3);
                  
                  
                dt = median(diff(Range(instfreq_concat_Both_H,'s')));
                % HPC and OB link spikes
                MeanSpk_HB{mm}=[];
                Occup_HB{mm}=[];
                for sp=1:length(S_concat)
                    [Y,X]=hist(Range(S_concat{sp}),Range(instfreq_concat_Both_H));
                    spike_count=tsd(X,Y');
                    dat=Data(Restrict(spike_count,FzEp_concat));
                    dat = dat(3:end-3);
                    for k=1:length(FreqLims)-1
                        for l = 1:length(FreqLims)-1
                            Bins=find(Freq_H>FreqLims(k) & Freq_H<FreqLims(k+1) & Freq_B>FreqLims(l) & Freq_B<FreqLims(l+1));
                            MeanSpk_HB{mm}(sp,k,l)=nansum(dat(Bins))./(length(Bins)*dt);
                            Occup_HB{mm}(k,l)=length(Bins);
                        end
                    end
                    A = imdilate(Occup_HB{mm}>3,se);
                    Bound = bwboundaries(A);
                    B = squeeze(MeanSpk_HB{mm}(sp,:,:));
                    B(~A) = NaN;
                    MeanSpk_HB{mm}(sp,:,:) = B;
                    clf
                    subplot(3,3,[1,4])
                    plot(squeeze(nanmean(MeanSpk_HB{mm}(sp,:,:),3)),FreqLims(1:end-1))
                    axis xy
                    ylim([FreqLims(1),FreqLims(end)])
                    ylabel('HPCFrequency')
                    subplot(3,3,[8,9])
                    plot(FreqLims(1:end-1),squeeze(nanmean(MeanSpk_HB{mm}(sp,:,:),2)))
                    xlim([FreqLims(1),FreqLims(end)])
                    ylabel('OBFrequency')
                    MeanSpk_HB{mm}(isnan(MeanSpk_HB{mm})) = 0;
                    colorbar
                    subplot(3,3,[2,3,5,6])
                    imagesc(FreqLims,FreqLims,SmoothDec(squeeze(MeanSpk_HB{mm}(sp,:,:)),1)),hold on
                    plot(FreqLims(Bound{1}(:,2)),FreqLims(Bound{1}(:,1)),'w')
                    colorbar
                    title('Firing map')
                    axis xy
                    saveas(fig.Number,['/media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllNeuronsTuning_HPCOB/FzBehaviour_Mouse' num2str(MiceNumber(mm)), '_Unit',num2str(sp),'.png'])

                end
                
                
            end
        end
    end
end

% cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing
% save('PFCUnitFiringOnOBFrequency.mat','OBData','linData','PSpk','RSpk','PSpk_btstrp','RSpk_btstrp','MeanSpk','Occup')




%                 % OB link spikes
%                 MeanSpk_B{mm}=[];
%                 Occup_B{mm}=[];
%                 for sp=1:length(S_concat)
%                     [Y,X]=hist(Range(S_concat{sp}),Range(instfreq_concat_Both_B));
%                     spike_count=tsd(X,Y');
%                     dat=Data(Restrict(spike_count,FzEp_concat));
%                     dat = dat(3:end-3);
%                     for k=1:length(FreqLims)-1
%                         Bins=find(Freq_B>FreqLims(k) & Freq_B<FreqLims(k+1));
%                         MeanSpk_B{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
%                         Occup_B{mm}(k)=length(Bins);
%                     end
%                     [R,P]=corrcoef(Freq_B,dat);
%                     RSpk_B{mm}(sp)=R(1,2);
%                     PSpk_B{mm}(sp)=P(1,2);
% %                     for btstrp = 1:1000
% %                         num=ceil(rand*length(ToPlot));
% %                         ToPlot_rand = fliplr([ToPlot(num+1:end);ToPlot(1:num)]);
% %                         [R,P]=corrcoef(ToPlot_rand,dat);
% %                         RSpk_btstrp{mm}(sp,btstrp) = R(1,2);
% %                         PSpk_btstrp{mm}(sp,btstrp) = P(1,2);
% %                     end
%                 end
%                 
%                 % HPC link spikes
%                 MeanSpk_H{mm}=[];
%                 Occup_H{mm}=[];
%                 for sp=1:length(S_concat)
%                     [Y,X]=hist(Range(S_concat{sp}),Range(instfreq_concat_Both_H));
%                     spike_count=tsd(X,Y');
%                     dat=Data(Restrict(spike_count,FzEp_concat));
%                     dat = dat(3:end-3);
%                     for k=1:length(FreqLims)-1
%                         Bins=find(Freq_H>FreqLims(k) & Freq_H<FreqLims(k+1));
%                         MeanSpk_H{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
%                         Occup_H{mm}(k)=length(Bins);
%                     end
%                     [R,P]=corrcoef(Freq_H,dat);
%                     RSpk_H{mm}(sp)=R(1,2);
%                     PSpk_H{mm}(sp)=P(1,2);
% %                     for btstrp = 1:1000
% %                         num=ceil(rand*length(ToPlot));
% %                         ToPlot_rand = fliplr([ToPlot(num+1:end);ToPlot(1:num)]);
% %                         [R,P]=corrcoef(ToPlot_rand,dat);
% %                         RSpk_btstrp{mm}(sp,btstrp) = R(1,2);
% %                         PSpk_btstrp{mm}(sp,btstrp) = P(1,2);
% %                     end
%                 end
% 
% 
%                 OBData{mm}=[];
%                 linData{mm}=[];
%                 for k=1:length(FreqLims)-1
%                     Bins=find(ToPlot>FreqLims(k) & ToPlot<FreqLims(k+1));
%                     OBData{mm}(k,:)=nanmean(Dat(:,Bins)');
%                     [Y,X]=hist(linpos(Bins)',[0.1:0.1:1]);
%                     linData{mm}(k,:)=Y/sum(Y);
%                 end
%                 