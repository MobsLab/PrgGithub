clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,514]; % 510,512 don't have tipples
GetUsefulDataRipplesReactivations_UMaze_SB

Binsize = 0.1*1e4;
SpeedLim = 2;

EpoName = {'Hab','Cond'};

for mm=1:length(MiceNumber)
    
    disp(num2str(MiceNumber(mm)))
    
    Ripples{mm} = ConcatenateDataFromFolders_BM(Dir{mm}.Cond,'ripples');
    
    for ep = 1:length(EpoName)
        
        Spikes{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'spikes');
        cd(Dir{mm}.(EpoName{ep}){1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes{mm}.(EpoName{ep}) = Spikes{mm}.(EpoName{ep})(numNeurons);
        
        NoiseEpoch{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','noiseepochclosestims');
        FreezeEpoch{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','freezeepoch');
        StimEpoch{mm}.(EpoName{ep})= ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'epoch','epochname','stimepoch');
        
        LinPos{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'linearposition');
        Vtsd{mm}.(EpoName{ep}) = ConcatenateDataFromFolders_BM(Dir{mm}.(EpoName{ep}),'speed');
        MovEpoch{mm}.(EpoName{ep}) = thresholdIntervals(Vtsd{mm}.(EpoName{ep}),SpeedLim,'Direction','Above');
        MovEpoch{mm}.(EpoName{ep}) = mergeCloseIntervals(MovEpoch{mm}.(EpoName{ep}),2*1e4);
        
        
        
    end
end


%% Make templates ith different time bins
timebin = [0.1,0.5,1,3]; % in s

for mm=1:length(MiceNumber)
    
    disp(num2str(MiceNumber(mm)))
    
    for tb = 1:length(timebin)
        disp(num2str(timebin(tb)))
        
        for ep = 1:length(EpoName)
            
            %% Calculate templates
            Q = MakeQfromS(Spikes{mm}.(EpoName{ep}),timebin(tb)*1e4);
            Q = tsd(Range(Q),nanzscore(Data(Q)));
            [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(Data(Q),1);
            CompInfo.StrPos{mm}{tb}.(EpoName{ep}) = eigenvalues;
            
            %% Get description of template
            
            % Position
            for ep_pos = 1:length(EpoName)
                Q = MakeQfromS(Spikes{mm}.(EpoName{ep_pos}),0.1*1e4);
                Q = tsd(Range(Q),nanzscore(Data(Q)));
                strength_temp = ReactivationStrength_SB((Data(Q)),templates);
                
                for comp = 1:size(strength_temp,2)
                    strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                    for l = 1:4
                        LitEpo = thresholdIntervals(LinPos{mm}.(EpoName{ep_pos}),(l-1)*0.25,'Direction','Above');
                        LitEpo = and(LitEpo,thresholdIntervals(LinPos{mm}.(EpoName{ep_pos}),(l)*0.25,'Direction','Below'));
                        CompInfo.StrPos{mm}{tb}.(EpoName{ep})(ep_pos,comp,l) = nanmean(Data(Restrict(strength_temp_tsd,LitEpo)));
                    end
                end
            end
            
            % Response to different events during conditionning
            ep_pos = 2;
            Q = MakeQfromS(Spikes{mm}.(EpoName{ep_pos}),0.1*1e4);
            Q = tsd(Range(Q),nanzscore(Data(Q)));
            strength_temp = ReactivationStrength_SB((Data(Q)),templates);
            
            for comp = 1:size(strength_temp,2)
                Strtsd = tsd(Range(Q),strength_temp(:,comp));
                
                % freezing
                [M,T] = PlotRipRaw(Strtsd,Start(FreezeEpoch{mm}.(EpoName{ep_pos}),'s'),5000,0,0);
                CompInfo.StrFz{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(Strtsd,Stop(FreezeEpoch{mm}.(EpoName{ep_pos}),'s'),5000,0,0);
                CompInfo.StpFz{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                FzSk = and(FreezeEpoch{mm}.(EpoName{ep_pos}),thresholdIntervals(LinPos{mm}.(EpoName{ep_pos}),0.4,'Direction','Below'));
                [M,T] = PlotRipRaw(Strtsd,Start(FzSk,'s'),5000,0,0);
                CompInfo.StrFz_Sk{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(Strtsd,Stop(FzSk,'s'),5000,0,0);
                CompInfo.StpFz_Sk{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                FzSf = and(FreezeEpoch{mm}.(EpoName{ep_pos}),thresholdIntervals(LinPos{mm}.(EpoName{ep_pos}),0.6,'Direction','Above'));
                [M,T] = PlotRipRaw(Strtsd,Start(FzSf,'s'),5000,0,0);
                CompInfo.StrFz_Sf{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(Strtsd,Stop(FzSf,'s'),5000,0,0);
                CompInfo.StpFz_Sf{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                % stimulation
                [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch{mm}.(EpoName{ep_pos}),'s'),5000,0,0);
                CompInfo.Stim{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                
            end
            
            % Response to ripples
            ep_pos = 2;
            Q = MakeQfromS(Spikes{mm}.(EpoName{ep_pos}),0.05*1e4);
            Q = tsd(Range(Q),nanzscore(Data(Q)));
            strength_temp = ReactivationStrength_SB((Data(Q)),templates);
            
            for comp = 1:size(strength_temp,2)
                Strtsd = tsd(Range(Q),strength_temp(:,comp));
                
                [M,T] = PlotRipRaw(Strtsd,Range(Ripples{mm},'s'),1000,0,0);
                CompInfo.Rip{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
            end
            
        end
    end
end
tpsrip = M(:,1);

save('/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/CondHabPCAAnlaysis_ReactStr.mat','CompInfo')

%%%%
%% Make templates ith different time bins
timebin = [0.1,0.5,1,3]; % in s

for mm=1:length(MiceNumber)
    
    disp(num2str(MiceNumber(mm)))
    
    for tb = 1:length(timebin)
        disp(num2str(timebin(tb)))
        
        for ep = 1:length(EpoName)
            
            %% Calculate templates
            Q = MakeQfromS(Spikes{mm}.(EpoName{ep}),timebin(tb)*1e4);
            Q = tsd(Range(Q),nanzscore(Data(Q)));
            
            [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(Data(Q),1);
            CompInfo.EigVals{mm}{tb}.(EpoName{ep}) = eigenvalues;
            
            %% Get description of template
            
            % Position
            for ep_pos = 1:length(EpoName)
                Q = MakeQfromS(Spikes{mm}.(EpoName{ep_pos}),0.1*1e4);
                Q = tsd(Range(Q),nanzscore(Data(Q)));
                clear strength_temp
                for e =  1: length(eigenvalues)
                    strength_temp(:,e) = Data(Q)*eigenvectors(:,e);
                end
                                
                for comp = 1:size(strength_temp,2)
                    strength_temp_tsd = tsd(Range(Q),strength_temp(:,comp));
                    for l = 1:4
                        LitEpo = thresholdIntervals(LinPos{mm}.(EpoName{ep_pos}),(l-1)*0.25,'Direction','Above');
                        LitEpo = and(LitEpo,thresholdIntervals(LinPos{mm}.(EpoName{ep_pos}),(l)*0.25,'Direction','Below'));
                        CompInfo.StrPos{mm}{tb}.(EpoName{ep})(ep_pos,comp,l) = nanmean(Data(Restrict(strength_temp_tsd,LitEpo)));
                    end
                end
            end
            
            % Response to different events during conditionning
            ep_pos = 2;
            Q = MakeQfromS(Spikes{mm}.(EpoName{ep_pos}),0.1*1e4);
            Q = tsd(Range(Q),nanzscore(Data(Q)));
            clear strength_temp
            for e =  1: length(eigenvalues)
                strength_temp(:,e) = Data(Q)*eigenvectors(:,e);
            end
            
            for comp = 1:size(strength_temp,2)
                Strtsd = tsd(Range(Q),strength_temp(:,comp));
                
                % freezing
                [M,T] = PlotRipRaw(Strtsd,Start(FreezeEpoch{mm}.(EpoName{ep_pos}),'s'),5000,0,0);
                CompInfo.StrFz{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(Strtsd,Stop(FreezeEpoch{mm}.(EpoName{ep_pos}),'s'),5000,0,0);
                CompInfo.StpFz{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                FzSk = and(FreezeEpoch{mm}.(EpoName{ep_pos}),thresholdIntervals(LinPos{mm}.(EpoName{ep_pos}),0.4,'Direction','Below'));
                [M,T] = PlotRipRaw(Strtsd,Start(FzSk,'s'),5000,0,0);
                CompInfo.StrFz_Sk{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(Strtsd,Stop(FzSk,'s'),5000,0,0);
                CompInfo.StpFz_Sk{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                FzSf = and(FreezeEpoch{mm}.(EpoName{ep_pos}),thresholdIntervals(LinPos{mm}.(EpoName{ep_pos}),0.6,'Direction','Above'));
                [M,T] = PlotRipRaw(Strtsd,Start(FzSf,'s'),5000,0,0);
                CompInfo.StrFz_Sf{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                [M,T] = PlotRipRaw(Strtsd,Stop(FzSf,'s'),5000,0,0);
                CompInfo.StpFz_Sf{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                % stimulation
                [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch{mm}.(EpoName{ep_pos}),'s'),5000,0,0);
                CompInfo.Stim{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
                
            end
            
            % Response to ripples
            ep_pos = 2;
            Q = MakeQfromS(Spikes{mm}.(EpoName{ep_pos}),0.05*1e4);
            Q = tsd(Range(Q),nanzscore(Data(Q)));
            
            clear strength_temp
            for e =  1: length(eigenvalues)
                strength_temp(:,e) = Data(Q)*eigenvectors(:,e);
            end
            
            for comp = 1:size(strength_temp,2)
                Strtsd = tsd(Range(Q),strength_temp(:,comp));
                
                [M,T] = PlotRipRaw(Strtsd,Range(Ripples{mm},'s'),1000,0,0);
                CompInfo.Rip{mm}{tb}.(EpoName{ep})(comp,:) = M(:,2);
                
            end
            
        end
    end
end
tpsrip = M(:,1);

save('/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/CondHabPCAAnlaysis_Proj.mat','CompInfo')


%%%%%%%%%%%%%%%%%%%%%

% Figure : plot 3 strongest components
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

for tb = 1:length(timebin)
    disp(num2str(timebin(tb)))
    mkdir(['Timebin' num2str(timebin(tb)*10)])
    for mm=1:length(MiceNumber)
        fig = figure;
        disp(num2str(MiceNumber(mm)))
        
        % Hab ripples
        subplot(4,2,1)
        for i=1:3
            plot(zscore((squeeze(CompInfo.Rip{mm}{tb}.(EpoName{1})(i,:)))))
            hold on
        end
        title('Habituation')
        xlim([0 40])
                makepretty

        subplot(4,2,3)
        for i=1:3
            plot(zscore((squeeze(CompInfo.StrPos{mm}{tb}.(EpoName{1})(1,i,:)))))
            hold on
        end
        makepretty
        xlim([1 4])
        set(gca,'XTick',[1,4],'XTickLabel',{'Sk','Sf'})
        
        subplot(4,2,5)
        for i=1:3
            plot(runmean(zscore((squeeze(CompInfo.StrFz{mm}{tb}.(EpoName{1})(i,:)))),5))
            hold on
        end
        makepretty
        xlim([0 100])
        
        subplot(4,2,7)
        for i=1:3
            plot(runmean(zscore((squeeze(CompInfo.Stim{mm}{tb}.(EpoName{1})(i,:)))),5))
            hold on
        end
        makepretty
        xlim([0 100])
        
        % Cond ripples
        subplot(4,2,2)
  for i=1:3
            plot(zscore((squeeze(CompInfo.Rip{mm}{tb}.(EpoName{2})(i,:)))))
            hold on
        end
        xlim([0 40])
                makepretty    
                title('Cond')
        
        subplot(4,2,4)
        for i=1:3
            plot(zscore((squeeze(CompInfo.StrPos{mm}{tb}.(EpoName{2})(2,i,:)))))
            hold on
        end
        makepretty
        xlim([1 4])
        set(gca,'XTick',[1,4],'XTickLabel',{'Sk','Sf'})
        
        
        subplot(4,2,6)
        for i=1:3
            plot(runmean(zscore((squeeze(CompInfo.StrFz{mm}{tb}.(EpoName{2})(i,:)))),5))
            hold on
        end
        makepretty
        xlim([0 100])
        
        
        subplot(4,2,8)
        for i=1:3
            plot(runmean(zscore((squeeze(CompInfo.Stim{mm}{tb}.(EpoName{2})(i,:)))),5))
            hold on
        end
        makepretty
        xlim([0 100])
        saveas(fig.Number,['Timebin' num2str(timebin(tb)*10) filesep 'BestEigVals_ProjHabCondMouse',num2str(mm),'.png'])
    end
    
end


% Figure : plot best 3 components on ripples
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

for tb = 1:length(timebin)
    disp(num2str(timebin(tb)))
    mkdir(['Timebin' num2str(timebin(tb)*10)])
    for mm=1:length(MiceNumber)
        fig = figure;
        disp(num2str(MiceNumber(mm)))
        
        
        % Hab ripples
        M = CompInfo.Rip{mm}{tb}.(EpoName{1});
        M = ZScoreWiWindowSB(M,[1:floor(size(M,2)/2)-2]);
        

        subplot(4,2,1)
        imagesc(tpsrip,1:10,M(ind(end-10:end),:))
        caxis([-3 3])
        title('Habituation')
        
        
        subplot(4,2,3)
        for i=1:3
            plot(nanmean(M(ind(end-i+1),18:22))-zscore((squeeze(CompInfo.StrPos{mm}{tb}.(EpoName{1})(1,ind(end-i+1),:)))))
            hold on
        end
        makepretty
        xlim([1 4])
        set(gca,'XTick',[1,4],'XTickLabel',{'Sk','Sf'})
        
        subplot(4,2,5)
        for i=1:3
            plot(runmean(nanmean(M(ind(end-i+1),18:22))*zscore((squeeze(CompInfo.StrFz{mm}{tb}.(EpoName{1})(ind(end-i+1),:)))),5))
            hold on
        end
        makepretty
        xlim([0 100])
        
        subplot(4,2,7)
        for i=1:3
            plot(runmean(nanmean(M(ind(end-i+1),18:22))*zscore((squeeze(CompInfo.Stim{mm}{tb}.(EpoName{1})(ind(end-i+1),:)))),5))
            hold on
        end
        makepretty
        xlim([0 100])
        
        % Cond ripples
        M = CompInfo.Rip{mm}{tb}.(EpoName{2});
        M = ZScoreWiWindowSB(M,[1:floor(size(M,2)/2)-2]);
        [MatNew,ind]=SortMat(abs(M),[18:22]);
        subplot(4,2,2)
        imagesc(tpsrip,1:10,M(ind(end-10:end),:))
        caxis([-3 3])
        title('Cond')
        
        subplot(4,2,4)
        for i=1:3
            plot(nanmean(M(ind(end-i+1),18:22))*zscore((squeeze(CompInfo.StrPos{mm}{tb}.(EpoName{2})(2,ind(end-i+1),:)))))
            hold on
        end
        makepretty
        xlim([1 4])
        set(gca,'XTick',[1,4],'XTickLabel',{'Sk','Sf'})
        
        
        subplot(4,2,6)
        for i=1:3
            plot(runmean(nanmean(M(ind(end-i+1),18:22))*zscore((squeeze(CompInfo.StrFz{mm}{tb}.(EpoName{2})(ind(end-i+1),:)))),5))
            hold on
        end
        makepretty
        xlim([0 100])
        
        
        subplot(4,2,8)
        for i=1:3
            plot(runmean(nanmean(M(ind(end-i+1),18:22))*zscore((squeeze(CompInfo.Stim{mm}{tb}.(EpoName{2})(ind(end-i+1),:)))),5))
            hold on
        end
        makepretty
        xlim([0 100])
        saveas(fig.Number,['Timebin' num2str(timebin(tb)*10) filesep 'BestRipplesHabCondMouse',num2str(mm),'.png'])
    end
    
end
