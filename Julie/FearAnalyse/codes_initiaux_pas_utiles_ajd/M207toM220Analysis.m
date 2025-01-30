%M207toM220Analysis
clear
close all

% define the filenames for each step and each mouse
for m=207:213
    %FileInfo{1,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-09122014-HABenvB'];
    FileInfo{1,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-10122014-HABenvA'];
    FileInfo{2,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-10122014-COND'];
    FileInfo{3,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-11122014-EXTpleth'];
    FileInfo{4,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-12122014-EXTenvB'];   
end
for m=214:220
    %FileInfo{1,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-16122014-HABenvB'];
    FileInfo{1,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-17122014-HABenvA'];
    FileInfo{2,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-17122014-COND'];
    FileInfo{3,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-18122014-EXTpleth'];
    FileInfo{4,m}=['C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\M' ,num2str(m),'\FEAR-Mouse-' ,num2str(m), '-19122014-EXTenvB'];   
end

NbOfMice=7;
% colours for plotting 
StimCols(1,:)=[0 1 0]; % CS- in green
StimCols(2,:)=[1 0.5 0]; % CS+ in orange
StimCols(3,:)=[1 0 0]; % shock in red

% For the extinction session define the periods containting 
NosoundPer=IntervalSet(0,121*1e4); % the first 2 min wihtout sound
CsminPer=IntervalSet(122*1e4,408*1e4); % the block of four CS-
CspluPer1=IntervalSet(408*1e4,789*1e4); % 1st block of four CS+
CspluPer2=IntervalSet(789*1e4,1117*1e4); % 2nd block of four CS+
CspluPer3=IntervalSet(1117*1e4,1400*1e4); % 3rd block of four CS+
StepName{1}='Hab envA';StepName{2}='Cond';StepName{3}='Pleth';StepName{4}='EnvB';

close all
freezeTh=1.5;


%mousenb=1;
% bulb={'207';'208';'209';'210';'214';'215';'216'};
% sham={'211';'212';'213';'217';'218';'219';'220'};
bulb=[207;208;209;210;214;215;216];
sham=[211;212;213;217;218;219;220];
expgroup={bulb, sham};
groupname={'bulb', 'sham'};
for  g=1:2
    group=expgroup{g};
    bilanFig=figure;
    groupFig=figure;
    set(bilanFig,'color',[1 1 1],'Position',[1 1 600 1000])
    clear bilan
    for mousenb=1:length(group)
        m=group(mousenb);
        m
        mouseindifg=figure
        set(mouseindifg,'color',[1 1 1],'Position',[1 1 1600 1600])
        for step=1:4
        %for step=3:3
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
                %if step~=1 
                    for l=1:length(StimInfo)-1
                        if StimInfo(l,2)==6
                            plot(StimInfo(l,1),0,'.','color',StimCols(3,:),'MarkerSize',20)
                        elseif StimInfo(l,2)==7
                            plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(2,:),'linewidth',3)
                        elseif StimInfo(l,2)==5
                            plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(1,:),'linewidth',3)
                        end
                    end
                %end
                %plot quantity of movement
                
                if step==1
                    htitle=title([groupname{g} '   M' num2str(m)]);
                    set(htitle,'FontSize', 20)
                    text(-50,35, ['th ' num2str(freezeTh)], 'FontSize', 15);
                end
                xlim([0 max(Range(Movtsd,'s'))])
                %ylim([-0.3 max(get(gca,'Ylim'))])
                ylim([-0.3 30])
                if step==3 % Pleth
                    ylim([0 20])
                end
                
                yLabel(StepName{step})

                % plot histogram of movements over the whole session
                subplot(4,4,3+(step-1)*4)
                [Y,X]=hist(Data(Movtsd),80); 
                plot(X,Y/sum(Y),'k','linewidth',1.5), hold on
                plot([freezeTh freezeTh],[0 0.4], 'Color', [0.7 0.7 0.7]) 
                ylim([0 0.3])
                xlim([0 20])
                if step==3 % Pleth
                    xlim([0 10])
                end
                title('Hist of Mvmt')

                % plot % of freezing
                subplot(4,8,7+(step-1)*8)
                bar([length(Data(Restrict(Movtsd,And(Ep,CSplInt))))/length(Data(Restrict(Movtsd,CSplInt))),length(Data(Restrict(Movtsd,And(Ep,CSmiInt))))/length(Data(Restrict(Movtsd,CSmiInt)))])
                set(gca,'XTickLabel',{'CS+','CS-'})
                ylim([0 1])
                xlim([0 3])
                title('% freezing')

                % plot histogram of freezing epochs
                subplot(4,8,8+(step-1)*8)
                [Y,X]=hist((abs(Start(Ep)-Stop(Ep)))/1e4, [0:5:50]);
                bar(X,Y/sum(Y))
                ylim([0 1])
                xlim([-2 50])
                set(gca, 'XTick', [0 10 20 30 40 50])
                title('hist of freezing dura')

                % percentage of freeing during the different periods (four CS- and each block of four CS+)
                bilan{step}(mousenb,:)=[length(Data(Restrict(Movtsd,And(Ep,NosoundPer))))/length(Data(Restrict(Movtsd,NosoundPer))),...
                    length(Data(Restrict(Movtsd,And(Ep,CsminPer))))/length(Data(Restrict(Movtsd,CsminPer))),...
                    length(Data(Restrict(Movtsd,And(Ep,CspluPer1))))/length(Data(Restrict(Movtsd,CspluPer1))),...
                    length(Data(Restrict(Movtsd,And(Ep,CspluPer2))))/length(Data(Restrict(Movtsd,CspluPer2))),...
                    length(Data(Restrict(Movtsd,And(Ep,CspluPer3))))/length(Data(Restrict(Movtsd,CspluPer3)))];



            end
        end
        cd ..
        set(gcf, 'PaperPosition', [1 1 28 21])
        saveas(mouseindifg,['M',num2str(m),'FigBilan_' num2str(freezeTh) '.fig'])
        saveas(mouseindifg,['M',num2str(m),'FigBilan_' num2str(freezeTh) '.png'])
        %saveFigure(mouseindifg,['M',num2str(m),'FigBilan'],FileInfo{step,m}(1:40))

        % % global figure all mice
        % suplot the results for one individual mouse
        figure(bilanFig)
        % Plethysmo 
        subplot(NbOfMice+1,2,(mousenb-1)*2+1)
        
        try
        bar(bilan{3}(mousenb,:))
        end
        xlim([0 6])
        ylim([0 1])
        yLabel(['M',num2str(m)])
        if mousenb==1
            text(-0.5,1.5, groupname{g}, 'FontSize', 20);
            title('Plethysmo')
        end
        % EnvB
        subplot(NbOfMice+1,2,(mousenb)*2)
        try
        bar(bilan{4}(mousenb,:))
        end
        xlim([0 6])
        ylim([0 1])
        if mousenb==1
            text(4.5,1.5, ['th ' num2str(freezeTh)], 'FontSize', 15);
            title('Env B')
        end
    end
    
% plot the average bars    
cd .. % back to 'ManipBulbectomie folder
subplot(NbOfMice+1,2,(NbOfMice+1)*2-1)
PlotErrorBarN((bilan{3}),0,1)
title('Plethysmo')
ylim([0 1])
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'CS-','CS+1','CS+2','CS+3'})
subplot(NbOfMice+1,2,(NbOfMice+1)*2)
PlotErrorBarN((bilan{4}),0,1)
title('Env B')
ylim([0 1])
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'CS-','CS+1','CS+2','CS+3'})
set(gcf, 'PaperPosition', [1 1 13 22])
saveas(bilanFig,[groupname{g} 'AllMiceAverage_' num2str(freezeTh) '.fig'])
saveas(bilanFig,[groupname{g} 'AllMiceAverage_' num2str(freezeTh) '.png'])
set(gcf, 'PaperPosition', [1 1 13 42])
saveas(bilanFig,[groupname{g} 'AllMiceAverageL_' num2str(freezeTh) '.fig'])
saveas(bilanFig,[groupname{g} 'AllMiceAverageL_' num2str(freezeTh) '.png'])

% same but only average
figure(groupFig)
set(groupFig,'color',[1 1 1],'Position',[81 324 560 420])

% EXT pleth
subplot(1,2,1)
PlotErrorBarN((bilan{3}),0,1) % test : paired ranksum relative to column 1
title('Plethysmo')
ylim([0 1])
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'CS-','CS+1','CS+2','CS+3'})
text(-1.5,1.05, groupname{g}, 'FontSize', 15);
% EXT envB
subplot(1,2,2)
PlotErrorBarN((bilan{4}),0,1)
title('Env B')
ylim([0 1])
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'CS-','CS+1','CS+2','CS+3'})
text(4.5,1.05, ['th ' num2str(freezeTh)], 'FontSize', 15);
set(groupFig, 'PaperPosition', [1 1 13 9])
saveas(groupFig,[groupname{g} 'Average_' num2str(freezeTh) '.fig'])
saveas(groupFig,[groupname{g} 'Average_' num2str(freezeTh) '.png'])

% save the data
save([groupname{g} 'AllMiceBilan_' num2str(freezeTh) '.mat'],  'bilan')
end

%saveFigure(bilanFig,'AllMiceAverage',FileInfo{step,m}(1:33))

% 
% %% Breathing
% for m=6:10
%             cd([FileInfo{3,m} 'SyncedData'])
%             load('SyncedData/Respi.mat');
% %             load('CStimes.mat')
%             LowSpectrumSB(FileInfo{3,m},1,'Respi');            
% %             cd(FileInfo{3,m})
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%% FIGURE FOR RESPI DATA
% 
% for m=6:10
%     specFig=figure
%     set(gcf, 'Position',[ 67 384  1594 420]);
%      ha = tight_subplot(3, 1, 0.01, 0.11, 0.1);
%     cd(FileInfo{3,m}) % respi data from plethymso
%     load('Respi_Low_Spectrum.mat')
%     load('CStimes.mat')
%     cd(FileInfo{3,m})
%     load('Behavior.mat')
%     CStime2=StimInfo(5:end-1,1); % times of CS+
%     if m==1
%        CStime2=CStime2(3:end);
%     end
% subplot(ha(1))
%     Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
%     Ep=mergeCloseIntervals(Ep,0.3*1E4);
%     Ep=dropShortIntervals(Ep,2*1E4);
%     CSplInt=intervalSet(StimInfo((StimInfo(:,2)==7),1)*1e4,(StimInfo((StimInfo(:,2)==7),1)+29)*1e4);
%     CSmiInt=intervalSet(StimInfo((StimInfo(:,2)==5),1)*1e4,(StimInfo((StimInfo(:,2)==5),1)+29)*1e4);
%     
%     % plot quantity of movement (freezing periods in blue)
%     plot(Range(Movtsd,'s'),Data(Movtsd),'k'), hold on
%     if ~isempty(Start(Ep))
%         for k=1:(length(Start(Ep)))
%             plot(Range(Restrict(Movtsd,subset(Ep,k)),'s'),Data(Restrict(Movtsd,subset(Ep,k))),'c'), hold on
%         end
%     end
%     % plot the sound periods and shock events
%     for l=1:length(StimInfo)-1
%         if StimInfo(l,2)==6
%             plot(StimInfo(l,1),0,'.','color',StimCols(3,:),'MarkerSize',20)
%         elseif StimInfo(l,2)==7
%             plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(2,:),'linewidth',3)
%         elseif StimInfo(l,2)==5
%             plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(1,:),'linewidth',3)
%         end
%     end
%     ylim([-0.3 max(get(gca,'Ylim'))])
%     xlim([0 1400])
%     set(gca,'XTick',[])
%     title(num2str(m))
%     
% % plot the tim frequency  spectrum on the temporal window [0 1400]
% % Spectro {1}: time frequency spectrum, {2}: time, {3} frequency range
% subplot(ha(2))
% sptsd=tsd(Spectro{2}*1e4+(CStime2(1)-CStime(1)/1e3)*1e4,Spectro{1});
% TotEpoch=intervalSet(0,1400*1e4);
% imagesc(Range(Restrict(sptsd,TotEpoch),'s'),Spectro{3},log(Data(Restrict(sptsd,TotEpoch))')), axis xy
% xlim([0 1400])
% 
% % plot the frequency histogram
% subplot(ha(3))
% plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,TotEpoch-Ep))),'k','linewidth',2),hold on % non freezing period
% plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,Ep))),'color','c','linewidth',2) % freezing period
% legend('No Freeze','Freeze')
% saveas(specFig,['M',num2str(m),'SpecFig.fig'])
% saveFigure(specFig,['M',num2str(m),'SpecFig'],FileInfo{step,m}(1:40))
% 
% end
% 
% % FIGURE Respi : frequency histogram per sound
% cols=jet(12);
% SpecFigAv=figure
% set(gcf, 'Position', [1685 266 1913 420]);
% for m=6:10
%     subplot(1,5,m-5)
%     cd(FileInfo{3,m})
%     load('Respi_Low_Spectrum.mat')
%     load('CStimes.mat')
%     cd(FileInfo{3,m})
%     load('Behavior.mat')
%     CStime2=StimInfo(5:end-1,1);
%     if m==1
%        CStime2=CStime2(3:end);
%     end
%     Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
%     Ep=mergeCloseIntervals(Ep,0.3*1E4);
%     Ep=dropShortIntervals(Ep,2*1E4);
%     CSplInt=intervalSet(StimInfo((StimInfo(:,2)==7),1)*1e4,(StimInfo((StimInfo(:,2)==7),1)+29)*1e4); % intervals for CS+
%     CSmiInt=intervalSet(StimInfo((StimInfo(:,2)==5),1)*1e4,(StimInfo((StimInfo(:,2)==5),1)+29)*1e4); % intervals for CS-
%     sptsd=tsd(Spectro{2}*1e4+(CStime2(1)-CStime(1)/1e3)*1e4,Spectro{1});
%     % plot the frequency histogram for each CS+
%     if ~isempty(Start(CSplInt))
%         for k=1:(length(Start(CSplInt)))
%         plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,subset(CSplInt,k)))),'color',cols(k,:),'linewidth',2),hold on
%         [val,ind]=max(Spectro{3}.*mean(Data(Restrict(sptsd,subset(CSplInt,k)))));
%         peak(m,k)=Spectro{3}(ind);
%         end
%     end
%     xlim([0 10])
%     title(['M',num2str(m)])
%     
% end
% saveas(SpecFigAv,'AllMiceAverageSpecs.fig')
% saveFigure(SpecFigAv,'AllMiceAverageSpecs',FileInfo{step,m}(1:33))
