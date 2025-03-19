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
FreqLims_HR=[8:0.2:13];
FreqLims_OB=[2.5:0.15:6];


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
                % Speed
                Speed=ConcatenateDataFromFolders_SB(FolderList,'speed');
                y=interp1(Range(Speed),Data(Speed),Range(OBSpec_concat));
                y = naninterp(log(y));
                y(isinf(y)) = NaN;
                y(1:100) = nanmean(y);
                y(end-100:end) = nanmean(y);
                Speed = tsd(Range(OBSpec_concat),(y));
                
                step = (prctile((Data(Speed)),97)-prctile((Data(Speed)),3))/20;
                FreqLims_Sp = [prctile((Data(Speed)),3):step:prctile((Data(Speed)),97)];
                
                % InstFreq - HR
                heartrate=ConcatenateDataFromFolders_SB(FolderList,'heartrate');
                y=interp1(Range(heartrate),Data(heartrate),Range(OBSpec_concat));
                heartrate = tsd(Range(OBSpec_concat),y);
                
                % InstFreq - OB
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
                
                % Position
                linpos=Data((LinPos_concat));
                ToPlot_HR=Data((heartrate));
                ToPlot_OB=Data((instfreq_concat_Both));
                ToPlot_Sp=(Data((Speed)));
                
                Dat=zscore(log(Data((OBSpec_concat)))');
                
                
                % get rid of ends
                ToPlot_HR = ToPlot_HR(3:end-3);
                ToPlot_OB = ToPlot_OB(3:end-3);
                ToPlot_Sp = ToPlot_Sp(3:end-3);

                Dat = Dat(:,3:end-3);
                linpos = linpos(3:end-3);
                
                %%
                keyboard
                subplot(312)
                y = Data(heartrate);
                x = (Data(Speed));
                x = x(:);
                y = y(:);
                badguys = isnan(x) | isnan(y) | isinf(x) |isinf(y);
                x(badguys) = [];
                y(badguys) = [];
                dscatter(x,y,'MSIZE',5)
                xlabel('Speed')
                ylabel('HR')
                axis square
                makepretty
                
                
                subplot(311)
                y = Data(heartrate);
                x = (Data(instfreq_concat_Both));
                x = x(:);
                y = y(:);
                badguys = isnan(x) | isnan(y) | isinf(x) |isinf(y);
                x(badguys) = [];
                y(badguys) = [];
                dscatter(x,y,'MSIZE',5)
                xlabel('RR')
                ylabel('HR')
                axis square
                makepretty
                
                subplot(313)
                y = Data(instfreq_concat_Both);
                x = (Data(Speed));
                x = x(:);
                y = y(:);
                badguys = isnan(x) | isnan(y) | isinf(x) |isinf(y);
                x(badguys) = [];
                y(badguys) = [];
                dscatter(x,y,'MSIZE',5)
                xlabel('Speed')
                ylabel('RR')
                axis square
                makepretty
                saveas(fig.Number,[SaveFolder filesep 'Cotuning' filesep 'CorrParams' num2str(mm) '.png'])
                saveas(fig.Number,[SaveFolder filesep 'Cotuning' filesep 'CorrParams' num2str(mm) '.fig'])
                clf
            end
        end
    end
end
                MeanSpk{mm}=[];
                Occup_HR{mm}=[];
                Occup_OB{mm}=[];
                
                for sp=1:length(S_concat)
                    [Y,X]=hist(Range(S_concat{sp}),Range(OBSpec_concat));
                    spike_count=tsd(X,Y');
                    %                     dat=Data(Restrict(spike_count,FzEp_concat));
                    dat=Data((spike_count));
                    dat = dat(3:end-3);
                    AllSpkAnova_HR=[];
                    AllIdAnova_HR = [];
                    
                    % HR
                    for k=1:length(FreqLims_HR)-1
                        
                        Bins=find(ToPlot_HR>FreqLims_HR(k) & ToPlot_HR<FreqLims_HR(k+1));
                        MeanSpk{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
                        Occup_HR{mm}(k)=length(Bins);
                        occup = length(Bins)/length(ToPlot_HR);
                        % do the anova on one half o data, get tuning curve
                        % on other
                        MeanSpk_Half_HR{mm}(sp,k)=nansum(dat(Bins(1:2:end)))./(length(Bins)/2);
                        MeanSpk_HalfAn_HR{mm}(sp,k)=nansum(dat(Bins(2:2:end)))./(length(Bins)/2);
                        AllSpkAnova_HR=[AllSpkAnova_HR;dat(Bins(2:2:end))];
                        AllIdAnova_HR = [AllIdAnova_HR;dat(Bins(2:2:end))*0+k];
                    end
                    [pvalanova,tbl,stats] = anova1(AllSpkAnova_HR,AllIdAnova_HR,'off');
                    PvalAnovaInfo_HR{mm}(sp) = pvalanova;
                    
                    % Get error bars on tuning curve
                    MinBins =  floor(min(Occup_HR{mm}(Occup_HR{mm}>20))/5);
                    if MinBins==0
                        disp('err')
                        keyboard
                    else
                        for k=1:length(FreqLims_HR)-1
                            Bins=find(ToPlot_HR>FreqLims_HR(k) & ToPlot_HR<FreqLims_HR(k+1));
                            RandTrials = randperm(Occup_HR{mm}(k));
                            if isempty(Bins) | length(Bins)<20
                                for perm = 1:5
                                    MeanSpk_Err_HR{mm}(sp,k,perm) = 0;
                                end
                            else
                                for perm = 1:5
                                    MeanSpk_Err_HR{mm}(sp,k,perm) = nansum(dat(Bins(RandTrials((perm-1)*MinBins+1:(perm)*MinBins))))./MinBins;
                                end
                            end
                        end
                    end
                    
                    % OB
                    AllSpkAnova_OB=[];
                    AllIdAnova_OB = [];
                    
                    for k=1:length(FreqLims_OB)-1
                        Bins=find(ToPlot_OB>FreqLims_OB(k) & ToPlot_OB<FreqLims_OB(k+1));
                        MeanSpk_OB{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
                        Occup_OB{mm}(k)=length(Bins);
                        occup = length(Bins)/length(ToPlot_OB);
                        % do the anova on one half o data, get tuning curve
                        % on other
                        MeanSpk_Half_OB{mm}(sp,k)=nansum(dat(Bins(1:2:end)))./(length(Bins)/2);
                        MeanSpk_HalfAn_OB{mm}(sp,k)=nansum(dat(Bins(2:2:end)))./(length(Bins)/2);
                        AllSpkAnova_OB=[AllSpkAnova_OB;dat(Bins)];
                        AllIdAnova_OB = [AllIdAnova_OB;dat(Bins)*0+k];
                    end
                    
                    
                    [pvalanova,tbl,stats] = anova1(AllSpkAnova_OB,AllIdAnova_OB,'off');
                    PvalAnovaInfo_OB{mm}(sp) = pvalanova;
                    
                    % Get error bars on tuning curve
                    MinBins =  floor(min(Occup_OB{mm}(Occup_OB{mm}>20))/5);
                    if MinBins==0
                        disp('err')
                        keyboard
                    else
                        for k=1:length(FreqLims_OB)-1
                            Bins=find(ToPlot_OB>FreqLims_OB(k) & ToPlot_OB<FreqLims_OB(k+1));
                            RandTrials = randperm(Occup_OB{mm}(k));
                            if isempty(Bins) | length(Bins)<20
                                for perm = 1:5
                                    MeanSpk_Err_OB{mm}(sp,k,perm) = 0;
                                end
                            else
                                for perm = 1:5
                                    MeanSpk_Err_OB{mm}(sp,k,perm) = nansum(dat(Bins(RandTrials((perm-1)*MinBins+1:(perm)*MinBins))))./MinBins;
                                end
                            end
                        end
                    end
                    
                    % Speed
                    AllSpkAnova_Sp=[];
                    AllIdAnova_Sp = [];
                    
                    for k=1:length(FreqLims_Sp)-1
                        Bins=find(ToPlot_Sp>FreqLims_Sp(k) & ToPlot_Sp<FreqLims_Sp(k+1));
                        MeanSpk_Sp{mm}(sp,k)=nansum(dat(Bins))./length(Bins);
                        Occup_Sp{mm}(k)=length(Bins);
                        occup = length(Bins)/length(ToPlot_Sp);
                        % do the anova on one half o data, get tuning curve
                        % on other
                        MeanSpk_Half_Sp{mm}(sp,k)=nansum(dat(Bins(1:2:end)))./(length(Bins)/2);
                        MeanSpk_HalfAn_Sp{mm}(sp,k)=nansum(dat(Bins(2:2:end)))./(length(Bins)/2);
                        AllSpkAnova_Sp=[AllSpkAnova_Sp;dat(Bins)];
                        AllIdAnova_Sp = [AllIdAnova_Sp;dat(Bins)*0+k];
                    end
                    
                    [pvalanova,tbl,stats] = anova1(AllSpkAnova_Sp,AllIdAnova_Sp,'off');
                    PvalAnovaInfo_Sp{mm}(sp) = pvalanova;
                    
                    
                    % Get error bars on tuning curve
                    MinBins =  floor(min(Occup_Sp{mm}(Occup_Sp{mm}>20))/5);
                    if MinBins==0
                        disp('err')
                        keyboard
                    else
                        for k=1:length(FreqLims_Sp)-1
                            Bins=find(ToPlot_Sp>FreqLims_Sp(k) & ToPlot_Sp<FreqLims_Sp(k+1));
                            RandTrials = randperm(Occup_Sp{mm}(k));
                            if isempty(Bins) | length(Bins)<20
                                for perm = 1:5
                                    MeanSpk_Err_Sp{mm}(sp,k,perm) = 0;
                                end
                            else
                                for perm = 1:5
                                    MeanSpk_Err_Sp{mm}(sp,k,perm) = nansum(dat(Bins(RandTrials((perm-1)*MinBins+1:(perm)*MinBins))))./MinBins;
                                end
                            end
                        end
                    end
                    
                    subplot(311)
                    errorbar(FreqLims_HR(1:end-1),nanmean(squeeze(MeanSpk_Err_HR{mm}(sp,:,:))'),stdError(squeeze(MeanSpk_Err_HR{mm}(sp,:,:))'))
                    makepretty
                    title('HR')
                    subplot(312)
                    errorbar(FreqLims_OB(1:end-1),nanmean(squeeze(MeanSpk_Err_OB{mm}(sp,:,:))'),stdError(squeeze(MeanSpk_Err_OB{mm}(sp,:,:))'))
                    makepretty
                    title('OB')
                    subplot(313)
                    errorbar(FreqLims_Sp(1:end-1),nanmean(squeeze(MeanSpk_Err_Sp{mm}(sp,:,:))'),stdError(squeeze(MeanSpk_Err_Sp{mm}(sp,:,:))'))
                    makepretty
                    title('Speed')
                    saveas(fig.Number,[SaveFolder filesep 'Cotuning' filesep 'tuning_HROBSp' num2str(mm) '_' num2str(sp),'.png'])
                    saveas(fig.Number,[SaveFolder filesep 'Cotuning' filesep 'tuning_HROBSp' num2str(mm) '_' num2str(sp),'.fig'])
                    clf
                    
                    
                end
                
            end
        end
    end
end

