% define the filenames for each step and each mouse
for m=6:10
    %FileInfo{1,m}=['/media/DataMOBs14/ProjetAversion/Mouse',num2str(m),'/20141103/FEAR-Mouse-',num2str(m),'-03112014-HABpleth/'];
    %FileInfo{2,m}=['/media/DataMOBs14/ProjetAversion/Mouse',num2str(m),'/20141104/FEAR-Mouse-',num2str(m),'-04112014-COND/'];
    FileInfo{3,m}=['/media/DataMOBs14/ProjetAversion/Mouse',num2str(m),'/20141105/FEAR-Mouse-',num2str(m),'-05112014-EXTpleth/'];
    %FileInfo{4,m}=['/media/DataMOBs14/ProjetAversion/Mouse',num2str(m),'/20141106/FEAR-Mouse-',num2str(m),'-06112014-EXTenvB/'];
    
end

% colours for plotting 
StimCols(1,:)=[0 1 0]; % CS- in green
StimCols(2,:)=[1 0.5 0]; % CS+ in orange
StimCols(3,:)=[1 0 0]; % shock in red

% For the extinction session define the periods containting 
CsminPer=IntervalSet(0,408*1e4); % the block of four CS-
CspluPer1=IntervalSet(408*1e4,789*1e4); % 1st block of four CS+
CspluPer2=IntervalSet(789*1e4,1117*1e4); % 2nd block of four CS+
CspluPer3=IntervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+
StepName{1}='Hab';StepName{2}='Cond';StepName{3}='PLeth';StepName{4}='EnvB';


close all
freezeTh=1.5;
bilanFig=figure;
set(bilanFig,'color',[1 1 1],'Position',[1 1 600 1000])
clear bilan
for m=6:10
    m
    mouseindifg=figure
    set(mouseindifg,'color',[1 1 1],'Position',[1 1 1600 1600])
    %for step=1:4
    for step=3:3
        try
            cd(FileInfo{step,m})
            load('Behavior.mat')
            if step==3 % Pleth
                Movtsd=tsd(Range(Movtsd),Data(Movtsd));
            end
            Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
            Ep=mergeCloseIntervals(Ep,0.3*1E4);
            Ep=dropShortIntervals(Ep,2*1E4);
            CSplInt=intervalSet(StimInfo((StimInfo(:,2)==7),1)*1e4,(StimInfo((StimInfo(:,2)==7),1)+29)*1e4); % intervals for CS+
            CSmiInt=intervalSet(StimInfo((StimInfo(:,2)==5),1)*1e4,(StimInfo((StimInfo(:,2)==5),1)+29)*1e4); % intervals for CS-
            
            subplot(4,4,(1:2)+(step-1)*4)
            % plot quantity of movement (freezing periods in blue)
            plot(Range(Movtsd,'s'),Data(Movtsd),'k'), hold on
            if ~isempty(Start(Ep))
                for k=1:(length(Start(Ep)))
                    plot(Range(Restrict(Movtsd,subset(Ep,k)),'s'),Data(Restrict(Movtsd,subset(Ep,k))),'c'), hold on
                end
            end
            
            % plot the sound periods and shock events
            for l=1:length(StimInfo)-1
                if StimInfo(l,2)==6
                    plot(StimInfo(l,1),0,'.','color',StimCols(3,:),'MarkerSize',20)
                elseif StimInfo(l,2)==7
                    plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(2,:),'linewidth',3)
                elseif StimInfo(l,2)==5
                    plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(1,:),'linewidth',3)
                end
            end
            %%%%%%%%%%%%%%%%% Specify a common YLim to compare plot (likely
            %%%%%%%%%%%%%%%%% to be different across steps
            ylim([-0.3 max(get(gca,'Ylim'))])
            if step==1
            title(strcat('M',num2str(m),'RawDat'))
            end
            xlim([0 max(Range(Movtsd,'s'))])
            yLabel(StepName{step})
            
            % plot histogram of movements over the whole session
            subplot(4,4,3+(step-1)*4)
            [Y,X]=hist(Data(Movtsd),80); 
            plot(X,Y/sum(Y),'k','linewidth',3)
            ylim([0 0.4])
            title('Hist of Mvmt')
            
            % plot % of freezing
            subplot(4,8,7+(step-1)*8)
            bar([length(Data(Restrict(Movtsd,And(Ep,CSplInt))))/length(Data(Restrict(Movtsd,CSplInt))),length(Data(Restrict(Movtsd,And(Ep,CSmiInt))))/length(Data(Restrict(Movtsd,CSmiInt)))])
            set(gca,'XTickLabel',{'CS+','CS-'})
            ylim([0 1])
            title('% freezing')
            
            % plot histogram of freezing epochs
            subplot(4,8,8+(step-1)*8)
            [Y,X]=hist((abs(Start(Ep)-Stop(Ep)))/1e4);
            bar(X,Y/sum(Y))
            ylim([0 1])
            title('hist of freezing dura')

            % percentage of freeing during the different periods (four CS- and each block of four CS+)
            bilan{step}(m,:)=[length(Data(Restrict(Movtsd,And(Ep,CsminPer))))/length(Data(Restrict(Movtsd,CsminPer))),...
                length(Data(Restrict(Movtsd,And(Ep,CspluPer1))))/length(Data(Restrict(Movtsd,CspluPer1))),...
                length(Data(Restrict(Movtsd,And(Ep,CspluPer2))))/length(Data(Restrict(Movtsd,CspluPer2))),...
                length(Data(Restrict(Movtsd,And(Ep,CspluPer3))))/length(Data(Restrict(Movtsd,CspluPer3)))];
            
            
            
        end
    end
saveas(mouseindifg,['M',num2str(m),'FigBilan.fig'])
saveFigure(mouseindifg,['M',num2str(m),'FigBilan'],FileInfo{step,m}(1:40))

% % global figure M1 to M5
% figure(bilanFig)
% subplot(6,2,(m-1-5)*2+1)
% bar(bilan{3}(m,:))
% ylim([0 1])
% yLabel(['M',num2str(m)])
% subplot(6,2,(m-5)*2)
% bar(bilan{4}(m-5,:))
% ylim([0 1])

end
% subplot(6,2,11)
% PlotErrorBarN((bilan{3}),0,1)
% title('Plethysmo')
% ylim([0 1])
% set(gca,'XTick',[1 2 3 4],'XTickLabel',{'CS-','CS+1','CS+2','CS+3'})
% subplot(6,2,12)
% PlotErrorBarN((bilan{4}),0,1)
% title('Env B')
% ylim([0 1])
% set(gca,'XTick',[1 2 3 4],'XTickLabel',{'CS-','CS+1','CS+2','CS+3'})
% saveas(bilanFig,'AllMiceAverage.fig')
% saveFigure(bilanFig,'AllMiceAverage',FileInfo{step,m}(1:33))

% 
% %% Breathing
% for m=6:10
%             cd([FileInfo{3,m} 'SyncedData'])
%             load('SyncedData/Respi.mat');
% %             load('CStimes.mat')
%             LowSpectrumSB(FileInfo{3,m},1,'Respi');            
% %             cd(FileInfo{3,m})
% end


%%%%%%%%%%%%% FIGURE FOR RESPI DATA

for m=6:10
    specFig=figure
    set(gcf, 'Position',[ 67 384  1594 420]);
     ha = tight_subplot(3, 1, 0.01, 0.11, 0.1);
    cd(FileInfo{3,m}) % respi data from plethymso
    load('Respi_Low_Spectrum.mat')
    load('CStimes.mat')
    cd(FileInfo{3,m})
    load('Behavior.mat')
    CStime2=StimInfo(5:end-1,1); % times of CS+
    if m==1
       CStime2=CStime2(3:end);
    end
subplot(ha(1))
    Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
    Ep=mergeCloseIntervals(Ep,0.3*1E4);
    Ep=dropShortIntervals(Ep,2*1E4);
    CSplInt=intervalSet(StimInfo((StimInfo(:,2)==7),1)*1e4,(StimInfo((StimInfo(:,2)==7),1)+29)*1e4);
    CSmiInt=intervalSet(StimInfo((StimInfo(:,2)==5),1)*1e4,(StimInfo((StimInfo(:,2)==5),1)+29)*1e4);
    
    % plot quantity of movement (freezing periods in blue)
    plot(Range(Movtsd,'s'),Data(Movtsd),'k'), hold on
    if ~isempty(Start(Ep))
        for k=1:(length(Start(Ep)))
            plot(Range(Restrict(Movtsd,subset(Ep,k)),'s'),Data(Restrict(Movtsd,subset(Ep,k))),'c'), hold on
        end
    end
    % plot the sound periods and shock events
    for l=1:length(StimInfo)-1
        if StimInfo(l,2)==6
            plot(StimInfo(l,1),0,'.','color',StimCols(3,:),'MarkerSize',20)
        elseif StimInfo(l,2)==7
            plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(2,:),'linewidth',3)
        elseif StimInfo(l,2)==5
            plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(1,:),'linewidth',3)
        end
    end
    ylim([-0.3 max(get(gca,'Ylim'))])
    xlim([0 1400])
    set(gca,'XTick',[])
    title(num2str(m))
    
% plot the tim frequency  spectrum on the temporal window [0 1400]
% Spectro {1}: time frequency spectrum, {2}: time, {3} frequency range
subplot(ha(2))
sptsd=tsd(Spectro{2}*1e4+(CStime2(1)-CStime(1)/1e3)*1e4,Spectro{1});
TotEpoch=intervalSet(0,1400*1e4);
imagesc(Range(Restrict(sptsd,TotEpoch),'s'),Spectro{3},log(Data(Restrict(sptsd,TotEpoch))')), axis xy
xlim([0 1400])

% plot the frequency histogram
subplot(ha(3))
plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,TotEpoch-Ep))),'k','linewidth',2),hold on % non freezing period
plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,Ep))),'color','c','linewidth',2) % freezing period
legend('No Freeze','Freeze')
saveas(specFig,['M',num2str(m),'SpecFig.fig'])
saveFigure(specFig,['M',num2str(m),'SpecFig'],FileInfo{step,m}(1:40))

end

% FIGURE Respi : frequency histogram per sound
cols=jet(12);
SpecFigAv=figure
set(gcf, 'Position', [1685 266 1913 420]);
for m=6:10
    subplot(1,5,m-5)
    cd(FileInfo{3,m})
    load('Respi_Low_Spectrum.mat')
    load('CStimes.mat')
    cd(FileInfo{3,m})
    load('Behavior.mat')
    CStime2=StimInfo(5:end-1,1);
    if m==1
       CStime2=CStime2(3:end);
    end
    Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
    Ep=mergeCloseIntervals(Ep,0.3*1E4);
    Ep=dropShortIntervals(Ep,2*1E4);
    CSplInt=intervalSet(StimInfo((StimInfo(:,2)==7),1)*1e4,(StimInfo((StimInfo(:,2)==7),1)+29)*1e4); % intervals for CS+
    CSmiInt=intervalSet(StimInfo((StimInfo(:,2)==5),1)*1e4,(StimInfo((StimInfo(:,2)==5),1)+29)*1e4); % intervals for CS-
    sptsd=tsd(Spectro{2}*1e4+(CStime2(1)-CStime(1)/1e3)*1e4,Spectro{1});
    % plot the frequency histogram for each CS+
    if ~isempty(Start(CSplInt))
        for k=1:(length(Start(CSplInt)))
        plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,subset(CSplInt,k)))),'color',cols(k,:),'linewidth',2),hold on
        [val,ind]=max(Spectro{3}.*mean(Data(Restrict(sptsd,subset(CSplInt,k)))));
        peak(m,k)=Spectro{3}(ind);
        end
    end
    xlim([0 10])
    title(['M',num2str(m)])
    
end
saveas(SpecFigAv,'AllMiceAverageSpecs.fig')
saveFigure(SpecFigAv,'AllMiceAverageSpecs',FileInfo{step,m}(1:33))
