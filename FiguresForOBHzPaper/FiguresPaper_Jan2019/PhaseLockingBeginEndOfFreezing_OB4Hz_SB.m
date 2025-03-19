% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data

% close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
Dir = PathForExperimentFEAR('Fear-electrophy');

EpLength = [6,14,22,40];

numNeurons=[];
num=1;
FieldNames={'OB1','PFCx'};
MiceDone = {};
nbin=30;
mousenum = 0;
for mm=1:length(Dir.path)
    if exist(Dir.path{mm})>0 && strcmp(Dir.group{mm},'CTRL') %&& sum(strcmp(MiceDone,Dir.name{mm}))==0
        cd(Dir.path{mm})
        
        if exist('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')>0
            disp(Dir.path{mm})
            mousenum = mousenum+1;
            MiceDone{mousenum} = Dir.name{mm};
            
            for eplg = 1:length(EpLength)-1
                clear PhasetsdSub
                clear PhasesSpikes mu
                load('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
                clear FreezeEpoch MovAcctsd
                load('behavResources.mat')
                FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
                FreezeEpoch = dropShortIntervals(FreezeEpoch,EpLength(eplg)*1e4);
                FreezeEpoch = dropLongIntervals(FreezeEpoch,EpLength(eplg+1)*1e4);
                
                for sp = 1:length(PhasesSpikes.Nontransf)
                    try
                        [mutemp, ~, pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch)));
                    catch
                        mutemp = NaN;
                        pval = NaN;
                    end
                    
                    Dat = (Data(PhasesSpikes.Nontransf{sp})-mutemp);
                    Dat(Dat<-pi) = 2*pi+Dat(Dat<-pi);
                    Dat(Dat>pi) = Dat(Dat>pi)-2*pi;
                    
                    PhasetsdSub{sp} = tsd(Range(PhasesSpikes.Nontransf{sp}),abs(Dat));
                    pvalAll{mousenum,eplg}(sp) = pval;
                    
                    %                 subplot(211)
                    %                 hist(Data(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch)),60)
                    %                 line([1 1]*mutemp,ylim,'color','r')
                    %                 title(num2str( pvalAll{mousenum}(sp) ))
                    %                 subplot(212)
                    %                 hist(Data(Restrict(PhasetsdSub{sp} ,FreezeEpoch)),60)
                    %                 line([1 1]*-pi,ylim,'color','r')
                    %                 line([1 1]*pi,ylim,'color','r')
                    %                 pause(0.1)
                    %                 clf
                    
                end
                

                
                if length(Start(FreezeEpoch))==0
                    for sp = 1:length(PhasesSpikes.Nontransf)
                        PhaseDist{mousenum,eplg}(sp,1,1:4) = nan(1,4);
                        KappaLocal{mousenum,eplg}(sp,1,1:4) = nan(1,4);
                        FRLocal{mousenum,eplg}(sp,1,1:4) = nan(1,4);
                        

                    end
                    DurEp{mousenum,eplg}(fz) = 0;
                else
                    
                    
                    for fz = 1:length(Start(FreezeEpoch))
                        
                        LittleEpoch = intervalSet(Start(subset(FreezeEpoch,fz))-3*1e4,Start(subset(FreezeEpoch,fz)));
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            PhaseDist{mousenum,eplg}(sp,fz,1) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            FRLocal{mousenum,eplg}(sp,fz,1) = length(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            if not(isempty(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch))))
                                [mutemp, Kappatemp pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch)));
                                KappaLocal{mousenum,eplg}(sp,fz,1) = Kappatemp;
                            else
                                KappaLocal{mousenum,eplg}(sp,fz,1) = NaN;
                            end
                        end
                        
                        LittleEpoch = intervalSet(Start(subset(FreezeEpoch,fz)),Start(subset(FreezeEpoch,fz))+3*1e4);
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            PhaseDist{mousenum,eplg}(sp,fz,2) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            FRLocal{mousenum,eplg}(sp,fz,2) = length(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            if not(isempty(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch))))
                                [mutemp, Kappatemp pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch)));
                                KappaLocal{mousenum,eplg}(sp,fz,2) = Kappatemp;
                            else
                                KappaLocal{mousenum,eplg}(sp,fz,2) =NaN;
                            end
                        end
                        
                        LittleEpoch = intervalSet(Stop(subset(FreezeEpoch,fz))-3*1e4,Stop(subset(FreezeEpoch,fz)));
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            PhaseDist{mousenum,eplg}(sp,fz,3) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            FRLocal{mousenum,eplg}(sp,fz,3) = length(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            if not(isempty(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch))))
                                [mutemp, Kappatemp pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch)));
                                KappaLocal{mousenum,eplg}(sp,fz,3) = Kappatemp;
                            else
                                KappaLocal{mousenum,eplg}(sp,fz,3) = NaN;
                            end
                        end
                        
                        LittleEpoch = intervalSet(Stop(subset(FreezeEpoch,fz)),Stop(subset(FreezeEpoch,fz))+3*1e4);
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            PhaseDist{mousenum,eplg}(sp,fz,4) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            FRLocal{mousenum,eplg}(sp,fz,4) = length(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            if not(isempty(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch))))
                                [mutemp, Kappatemp pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch)));
                                KappaLocal{mousenum,eplg}(sp,fz,4) = Kappatemp;
                            else
                                KappaLocal{mousenum,eplg}(sp,fz,4) = NaN;
                            end
                        end
                        
                        DurEp{mousenum,eplg}(fz) = Stop(subset(FreezeEpoch,fz),'s') - Start(subset(FreezeEpoch,fz),'s');
                    end
                end
            end
            
        end
    end
end


% Nice figure - Kappa local zscored
figure(2)
Allalpha = [0.5,0.01,0.001];
for aa = 1:3
    alpha = Allalpha(aa);
    for eplg = 1:length(EpLength)-1
        AllData = [];
        AllPval = [];
        for mm = 1:mousenum
            A=KappaLocal{mm,eplg};
            A(find(FRLocal{mm,eplg}<10))=NaN;
            for sp = 1:size(A,1)
                temp = A(sp,:,:);
                temp = temp(:);
                for ep = 1:4
                    A(sp,:,ep) = ((A(sp,:,ep))-nanmean(temp))./nanstd(temp); 
                end
            end
            AllData = [AllData;squeeze(nanmean(A,2))];
            AllPval = [AllPval,pvalAll{mm,eplg}];
        end
        AllData = (AllData')';
        subplot(3,3,eplg+3*(aa-1))
        hold off
        for k = 1:4
            X = (AllData(AllPval<alpha,k)')';
            a=iosr.statistics.boxPlot(k,X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
            a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
            a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
            a.handles.medianLines.LineWidth = 5;
            handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',k,'spreadWidth',0.4); hold on;
            set(handlesplot{1},'MarkerSize',25)
            handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6],'xValues',k,'spreadWidth',0.4);
            set(handlesplot{1},'MarkerSize',15)
            xlim([0 5])
            ylim([-2.5 2.5])
            set(gca,'XTick',[1:4],'XTickLabel',{'Pre','Beg','End','Post'})
            title(['Min Fz ep :', num2str(EpLength(eplg)) ' s' ])
            ylabel('Dist to best phase - zscore')
        end
            [p,h] = ranksum(AllData(AllPval<alpha,3),AllData(AllPval<alpha,2))
            if p<0.001
                text(2.5,2.2,'***','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            elseif p<0.01
                text(2.5,2.2,'**','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            elseif p<0.05
                text(2.5,2.2,'*','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            end
        
    end
    
end


% Nice figure - Phase Dist zscored
figure(1)
Allalpha = [0.5,0.01,0.001];
for aa = 1:3
    alpha = Allalpha(aa);
    for eplg = 1:length(EpLength)-1
        AllData = [];
        AllPval = [];
        for mm = 1:mousenum
            A=PhaseDist{mm,eplg};
            A(find(FRLocal{mm,eplg}<10))=NaN;
            for sp = 1:size(A,1)
                temp = A(sp,:,:);
                temp = temp(:);
                for ep = 1:4
                    A(sp,:,ep) = ((A(sp,:,ep))-nanmean(temp))./nanstd(temp); 
                end
            end
            AllData = [AllData;squeeze(nanmean(A,2))];
            AllPval = [AllPval,pvalAll{mm,eplg}];
        end
        AllData = (AllData')';
        subplot(3,3,eplg+3*(aa-1))
        hold off
        for k = 1:4
            X = (AllData(AllPval<alpha,k)')';
            a=iosr.statistics.boxPlot(k,X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
            a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
            a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
            a.handles.medianLines.LineWidth = 5;
            handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',k,'spreadWidth',0.4); hold on;
            set(handlesplot{1},'MarkerSize',25)
            handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6],'xValues',k,'spreadWidth',0.4);
            set(handlesplot{1},'MarkerSize',15)
            xlim([0 5])
            ylim([-2.5 2.5])
            set(gca,'XTick',[1:4],'XTickLabel',{'Pre','Beg','End','Post'})
            title(['Min Fz ep :', num2str(EpLength(eplg)) ' s' ])
            ylabel('Dist to best phase - zscore')
        end
            [p,h] = ranksum(AllData(AllPval<alpha,3),AllData(AllPval<alpha,2))
            if p<0.001
                text(2.5,2.2,'***','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            elseif p<0.01
                text(2.5,2.2,'**','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            elseif p<0.05
                text(2.5,2.2,'*','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            end
        
    end
    
end


% Nice figure - Phase Dist
figure(3)
Allalpha = [0.5,0.01,0.001];
for aa = 1:3
    alpha = Allalpha(aa);
    for eplg = 1:length(EpLength)-1
        AllData = [];
        AllPval = [];
        for mm = 1:mousenum
            A=PhaseDist{mm,eplg};
            A(find(FRLocal{mm,eplg}<10))=NaN;
            AllData = [AllData;squeeze(nanmean(A,2))];
            AllPval = [AllPval,pvalAll{mm,eplg}];
        end
        AllData = (AllData')';
        subplot(3,3,eplg+3*(aa-1))
        hold off
        for k = 1:4
            X = (AllData(AllPval<alpha,k)')';
            a=iosr.statistics.boxPlot(k,X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
            a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
            a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
            a.handles.medianLines.LineWidth = 5;
            handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',k,'spreadWidth',0.4); hold on;
            set(handlesplot{1},'MarkerSize',25)
            handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6],'xValues',k,'spreadWidth',0.4);
            set(handlesplot{1},'MarkerSize',15)
            xlim([0 5])
            ylim([0.5 2])
            line(xlim,[1 1]*pi/2)
            set(gca,'XTick',[1:4],'XTickLabel',{'Pre','Beg','End','Post'})
            title(['Min Fz ep :', num2str(EpLength(eplg)) ' s' ])
            ylabel('Dist to best phase - zscore')
        end
            [p,h] = ranksum(AllData(AllPval<alpha,3),AllData(AllPval<alpha,2))
            if p<0.001
                text(2.5,2.2,'***','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            elseif p<0.01
                text(2.5,2.2,'**','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            elseif p<0.05
                text(2.5,2.2,'*','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            end
        
    end
    
end

% Nice figure - Kappa
figure(4)
Allalpha = [0.5,0.01,0.001];
for aa = 1:3
    alpha = Allalpha(aa);
    for eplg = 1:length(EpLength)-1
        AllData = [];
        AllPval = [];
        for mm = 1:mousenum
            A=KappaLocal{mm,eplg};
            A(find(FRLocal{mm,eplg}<10))=NaN;
            AllData = [AllData;squeeze(nanmean(A,2))];
            AllPval = [AllPval,pvalAll{mm,eplg}];
        end
        AllData = (AllData')';
        subplot(3,3,eplg+3*(aa-1))
        hold off
        for k = 1:4
            X = (AllData(AllPval<alpha,k)')';
            a=iosr.statistics.boxPlot(k,X,'boxColor',[0.9 0.9 0.9],'lineColor',[0.9 0.9 0.9],'medianColor','k','boxWidth',0.5,'showOutliers',false);
            a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
            a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
            a.handles.medianLines.LineWidth = 5;
            handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6]*0.2,'xValues',k,'spreadWidth',0.4); hold on;
            set(handlesplot{1},'MarkerSize',25)
            handlesplot=plotSpread(X,'distributionColors',[0.6,0.6,0.6],'xValues',k,'spreadWidth',0.4);
            set(handlesplot{1},'MarkerSize',15)
            xlim([0 5])
            ylim([0 1])
            set(gca,'XTick',[1:4],'XTickLabel',{'Pre','Beg','End','Post'})
            title(['Min Fz ep :', num2str(EpLength(eplg)) ' s' ])
            ylabel('Dist to best phase - zscore')
        end
            [p,h] = ranksum(AllData(AllPval<alpha,3),AllData(AllPval<alpha,2))
            if p<0.001
                text(2.5,2.2,'***','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            elseif p<0.01
                text(2.5,2.2,'**','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            elseif p<0.05
                text(2.5,2.2,'*','FontSize',15)
                line([2 3],[2 2],'color','k','linewidth',2)
            end
        
    end
    
end

