function AnalysisManipBulbectomy(datalocation,manipname,freezeTh,varargin)

% INPUTS
% datalocation : 'server' ou 'manip'
% manipname : 'ManipDec14Bulbectomie' or 'ManipFeb15Bulbectomie'
% freezeTh : threshold for freezing. usually =1 -> savedata as BulbAllMiceBilan_1.mat and ShamAllMiceBilan_1.mat (1: freezeTh)%
% indivfig, groupfig : switch to produce or not individual and groupfigures
% columntest : specifies the period to wiwh data are compared in ranksum test (1: no sound period, 2: CS- period) default =2
% displayed hab phase : 'envA', 'envB', 'pleth' or 'envC' for individual figures
% period : can be  'fullperiod' or 'soundonly'  for the freezing quantification

% OUTPUTS
% data : BulbAllMiceBilan_1.mat and ShamAllMiceBilan_1.mat
% individual figure : M207FigBilan_1.5.fig
% group figure :
% - with individual histogram (at 24h and 48h) : BulbAllMiceAverageL_1.5.png/ ShamAllMiceAverageL_1.5.png
% - only the average (at 24h and 48h)  : BulbAverage_1.5.png/ShamAverage_1.5.png        

% default values
ColTest=2; 
hab='envB';

 for i = 1:2:length(varargin),

      switch(lower(varargin{i})),

        case 'indivfig',
          indifg= varargin{i+1};
          if ~isa(indifg,'numeric'),
            error('Incorrect value for property ''figure'' ');
          end   

        case 'groupfig',
            gpfg= varargin{i+1};
            if ~isa(gpfg,'numeric'),
            error('Incorrect value for property ''figure'' ');
            end

        case 'save',
          sav = varargin{i+1};
          
        case 'columntest',
              ColTest= varargin{i+1}; % 1: compare no No sound period / 2 compare to CS- period
              
        case 'dorespi',
              dorespi= varargin{i+1};
        case 'displayed hab phase', % should be 'envA', 'envB', 'pleth' or 'envC'
          hab= varargin{i+1};
        case 'period', % should be fullperiod or soundonly
          period= varargin{i+1};
      end
 end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define the filenames for each step and each mouse
[FileInfo, FolderPath]=DefinePath(manipname, datalocation,'fear');

IntervalNameIfExtinction={'noSoundPer', 'CS-', 'CS+1', 'CS+2', 'CS+3'};

StepName{1}=['HAB ' hab];
StepName{2}='COND';
if strcmp(manipname,'ManipDec14Bulbectomie')
    StepName{3}='EXT pleth';
elseif strcmp(manipname,'ManipFeb15Bulbectomie')
    StepName{3}='EXT envC';
end
StepName{4}='EXT envB';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


if strcmp(manipname,'ManipDec14Bulbectomie')
    shammice=[211;212;213;217;218;219;220];
    bulbmice=[207;208;209;210;214;215;216];
elseif strcmp(manipname,'ManipFeb15Bulbectomie')
    shammice=[223;224;225;227;229;233;235;237;239];
    bulbmice=[222;226;228;232;234;236;238;240];
%         shammice=[231];
%     bulbmice=[230];
end

NbOfMicePerGp=[size(shammice,1) size(bulbmice,1)];

expgroup={shammice,bulbmice};
groupname={'sham','bulb'};
for  g=1:2
    group=expgroup{g};
    if gpfg
        bilanFig=figure;
        groupFig=figure;
        set(bilanFig,'color',[1 1 1],'Position',[1 1 600 1000])
    end
    clear bilan
    for mousenb=1:length(group)
        m=group(mousenb);
        if indifg
            mouseindifg=figure;
            set(mouseindifg,'color',[1 1 1],'Position',[1 1 1000 1000])
        end
        for step=1:4
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
                if step==1 % HAB env A=> 4 CS + and CS-   HAB env Bpas de sons !
                    sounds1=subset(CSmiInt,[1:2]);
                    sounds2=subset(CSplInt,[1:2]);
                    sounds3=subset(CSmiInt,[3:4]);
                    sounds4=subset(CSplInt,[3:4]);
                elseif step==2 % COND
                    sounds1=subset(CSmiInt,[1:3]);
                    sounds2=subset(CSplInt,[1:3]);
                    sounds3=subset(CSmiInt,[4:5]);
                    sounds4=subset(CSplInt,[4:5]);
                elseif step==3||step==4 % EXT env C/Plth  et EXTenvB
                    sounds1=CSmiInt;
                    sounds2=subset(CSplInt,[1:4]);
                    sounds3=subset(CSplInt,[5:8]);
                    sounds4=subset(CSplInt,[9:12]);
                end
                
                if indifg % plot individual figure
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
                end
                
                if strcmp(period,'fullperiod')

                % percentage of freeing during the different periods (four CS- and each block of four CS+)
                bilan{step}(mousenb,:)=[length(Data(Restrict(Movtsd,And(Ep,NosoundPer))))/length(Data(Restrict(Movtsd,NosoundPer))),...
                    length(Data(Restrict(Movtsd,And(Ep,CsminPer))))/length(Data(Restrict(Movtsd,CsminPer))),...
                    length(Data(Restrict(Movtsd,And(Ep,CspluPer1))))/length(Data(Restrict(Movtsd,CspluPer1))),...
                    length(Data(Restrict(Movtsd,And(Ep,CspluPer2))))/length(Data(Restrict(Movtsd,CspluPer2))),...
                    length(Data(Restrict(Movtsd,And(Ep,CspluPer3))))/length(Data(Restrict(Movtsd,CspluPer3)))];
                elseif strcmp(period,'soundonly')
                % percentage of freeing during the different the sounds only (be carefull groupinf different for HAB/COND and EXT)
                bilan{step}(mousenb,:)=[length(Data(Restrict(Movtsd,And(Ep,NosoundPer))))/length(Data(Restrict(Movtsd,NosoundPer))),...
                    length(Data(Restrict(Movtsd,And(Ep,sounds1))))/length(Data(Restrict(Movtsd,sounds1))),...
                    length(Data(Restrict(Movtsd,And(Ep,sounds2))))/length(Data(Restrict(Movtsd,sounds2))),...
                    length(Data(Restrict(Movtsd,And(Ep,sounds3))))/length(Data(Restrict(Movtsd,sounds3))),...
                    length(Data(Restrict(Movtsd,And(Ep,sounds4))))/length(Data(Restrict(Movtsd,sounds4)))];
                end

                catch
                    disp(FileInfo{step,m})
            end % of try catch
        end
        cd ..
        
        cd([FolderPath manipname])

            
        if indifg && sav
            set(gcf, 'PaperPosition', [1 1 28 21])
            %set(gcf, 'PaperPosition', [1 1 14 10])
            saveas(mouseindifg,['M',num2str(m),'FigBilan_' num2str(freezeTh) '_' hab '.fig'])
            saveas(mouseindifg,['M',num2str(m),'FigBilan_' num2str(freezeTh) '_' hab '.png'])
            currFold=pwd;
            saveFigure(mouseindifg, ['M',num2str(m),'FigBilan_' num2str(freezeTh) '_' hab], currFold)
        end

        % % global figure all mice
        % suplot the results for one individual mouse
        if gpfg % make a group figure
            figure(bilanFig) 
            % Plethysmo 
            subplot(NbOfMicePerGp(g)+1,2,(mousenb-1)*2+1)

            try
            bar(bilan{3}(mousenb,:))
            end
            xlim([0 6])
            ylim([0 1])
            yLabel(['M',num2str(m)])
            if mousenb==1
                text(-0.5,1.5, groupname{g}, 'FontSize', 20);
                title(StepName{3})
            end
            % EnvB
            subplot(NbOfMicePerGp(g)+1,2,(mousenb)*2)
            try
            bar(bilan{4}(mousenb,:))
            end
            xlim([0 6])
            ylim([0 1])
            if mousenb==1
                text(4.5,1.5, ['th ' num2str(freezeTh)], 'FontSize', 15);
                title(StepName {4})
            end
        end
    end
    
    % plot the average bars    
    %cd .. % back to 'ManipBulbectomie folder
    if gpfg
        subplot(NbOfMicePerGp(g)+1,2,(NbOfMicePerGp(g)+1)*2-1)
        %PlotErrorBarNJL((bilan{3}),0,1,'ColumnTest', ColTest)
        PlotErrorBarNJL((bilan{3}),'newfig',0,'paired',1,'optiontest','ranksum','ColumnTest', ColTest)
        title(StepName{3})
        ylim([0 1])
        ylabel(['col test = ' num2str(ColTest)])
        set(gca,'XTick',[1 2 3 4],'XTickLabel',{'noS','CS-','CS+1','CS+2','CS+3'})
        subplot(NbOfMicePerGp(g)+1,2,(NbOfMicePerGp(g)+1)*2)
        PlotErrorBarNJL((bilan{4}),'newfig',0,'paired',1,'optiontest','ranksum','ColumnTest', ColTest)
        title(StepName{4})
        ylim([0 1])
         ylabel(['col test = ' num2str(ColTest)])
        set(gca,'XTick',[1 2 3 4],'XTickLabel',{'noS','CS-','CS+1','CS+2','CS+3'})
        set(gcf, 'PaperPosition', [1 1 13 22])
        %set(gcf, 'PaperPosition', [1 1 6.5 11])
        saveas(bilanFig,[groupname{g} 'AllMiceAverage_' num2str(freezeTh) '.fig'])
        saveas(bilanFig,[groupname{g} 'AllMiceAverage_' num2str(freezeTh) '.png'])
        currFold=pwd;
        saveFigure(bilanFig, [groupname{g} 'AllMiceAverage_' num2str(freezeTh)], currFold)
        set(gcf, 'PaperPosition', [1 1 13 42])
        %set(gcf, 'PaperPosition', [1 1 6.5 21])
        if sav
            saveas(bilanFig,[groupname{g} 'AllMiceAverageL_' num2str(freezeTh) '.fig'])
            saveas(bilanFig,[groupname{g} 'AllMiceAverageL_' num2str(freezeTh) '.png'])
            currFold=pwd;
            saveFigure(bilanFig, [groupname{g} 'AllMiceAverageL_' num2str(freezeTh)], currFold)
        end
    end

    % same but only average
    if gpfg
        figure(groupFig)
        set(groupFig,'color',[1 1 1],'Position',[81 324 560 420])

        % EXT pleth
        subplot(1,2,1)
        PlotErrorBarNJL((bilan{3}),'newfig',0,'paired',1,'optiontest','ranksum','ColumnTest', ColTest) % test : paired ranksum relative to column 1
        title(StepName{3})
        ylim([0 1])
        ylabel(['col test = ' num2str(ColTest)])
        set(gca,'XTick',[1 2 3 4],'XTickLabel',{'noS','CS-','CS+1','CS+2','CS+3'})
        text(-1.5,1.05, groupname{g}, 'FontSize', 15);
        % EXT envB
        subplot(1,2,2)
        PlotErrorBarNJL((bilan{4}),'newfig',0,'paired',1,'optiontest','ranksum','ColumnTest', ColTest)
        title(StepName{4})
        ylim([0 1])
        ylabel(['col test = ' num2str(ColTest)])
        set(gca,'XTick',[1 2 3 4],'XTickLabel',{'noS','CS-','CS+1','CS+2','CS+3'})
        text(4.5,1.05, ['th ' num2str(freezeTh)], 'FontSize', 15);
        set(groupFig, 'PaperPosition', [1 1 15 9])
        %set(groupFig, 'PaperPosition', [1 1 7.5 4.5)
        cd([FolderPath manipname])
        if sav
            saveas(groupFig,[groupname{g} 'Average_' num2str(freezeTh) '.fig'])
            saveas(groupFig,[groupname{g} 'Average_' num2str(freezeTh) '.png'])
            currFold=pwd;
            saveFigure(groupFig, [groupname{g} 'Average_' num2str(freezeTh) ], currFold)
            % save the data
            save([groupname{g} 'AllMiceBilan_' num2str(freezeTh) '_' hab '.mat'],  'bilan', 'freezeTh', 'StepName', 'groupname', 'hab','ColTest','period', 'IntervalNameIfExtinction', 'shammice', 'bulbmice')
        end
    end
end

if sav && gpfg
    saveFigure(bilanFig,'AllMiceAverage',FileInfo{step,m}(1:33))
end

% %% Breathing
% for m=207:220
%     cd([FileInfo{1,m} 'SyncedData'])
%     load('SyncedData/Respi.mat');
%     load('SyncedData/LFP1.mat');
%             load('CStimes.mat')
%     LowSpectrumJL(FileInfo{1,m},1,'Respi');            
%             cd(FileInfo{3,m})
% end
% 
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % %%%%%%%%%%%%% FIGURE FOR RESPI DATA
% % 
% for step=3:2:3 
%     for g=1:2
%     group=expgroup{g};
% 
%     RgpFig=figure;
%     set(RgpFig, 'Color', [1 1 1],'Position', [10 10 2200 300]);
%         for mousenb=1:length(group)
%             m=group(mousenb);
%             
%             specFig=figure;
%             set(specFig, 'Position',[ 67 384  1594 420]);
%             ha = tight_subplot(3, 1, 0.01, 0.11, 0.1);
% 
%             cd(FileInfo{step,m})
%             subplot(ha(1))
%             if exist ('Behavior.mat')
%                 load('Behavior.mat')
%                 Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
%                 Ep=mergeCloseIntervals(Ep,0.3*1E4);
%                 Ep=dropShortIntervals(Ep,2*1E4);
% 
%                 % plot quantity of movement (freezing periods in blue)
%                 plot(Range(Movtsd,'s'),Data(Movtsd),'k'), hold on
%                 if ~isempty(Start(Ep))
%                     for k=1:(length(Start(Ep)))
%                         plot(Range(Restrict(Movtsd,subset(Ep,k)),'s'),Data(Restrict(Movtsd,subset(Ep,k))),'c'), hold on
%                     end
%                 end
% 
%                 % plot the sound periods and shock events
%                 % StimInfo : temps de matlab
%                 for l=1:length(StimInfo)-1
%                     if StimInfo(l,2)==6
%                         plot(StimInfo(l,1),0,'.','color',StimCols(3,:),'MarkerSize',20)
%                     elseif StimInfo(l,2)==7
%                         plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(2,:),'linewidth',3)
%                     elseif StimInfo(l,2)==5
%                         plot(StimInfo(l,1):StimInfo(l,1)+30,zeros(1,31),'color',StimCols(1,:),'linewidth',3)
%                     end
%                 end
%                 ylim([-0.3 max(get(gca,'Ylim'))])
%                 xlim([0 1400])
%                 set(gca,'XTick',[])
%                 ylabel(['Freeze th ' num2str(freezeTh)])
%             else 
%                 disp(['no Behavior file to load for ' StepName{step} ' M' num2str(m)])
%             end
%             title([StepName{step} ' M ' num2str(m) ])
% 
%             cd(FileInfo{step,m}) % respi data from plethymso
%             load('Respi_Low_Spectrum.mat')
% 
%             % plot the tim frequency  spectrum on the temporal window [0 1400]
%             % Spectro {1}: time frequency spectrum, {2}: time, {3} frequency range
%             subplot(ha(2))
%             TotEpoch=intervalSet(0,1400*1e4);
%             %sptsd=tsd(Spectro{2}*1e4+(CStime2(1)-CStime(1)/1e3)*1e4,Spectro{1}); %pourquoi???
%             sptsd=tsd(Spectro{2}*1e4,Spectro{1});
%             imagesc(Range(Restrict(sptsd,TotEpoch),'s'),Spectro{3},log(Data(Restrict(sptsd,TotEpoch))')), axis xy
% 
%             if step==1
%                 xlim([0 1200])
%             elseif step==3
%                 xlim([0 1400])
%             end
% 
%             if exist ('Behavior.mat') 
%                 % add the freezing period directly onto the spectrogram
%                 hold on 
%                 a=start(Ep);
%                 b=stop(Ep);
%                 for n=1:length(a)
%                     plot([a(n)*1e-4 b(n)*1e-4],[0.5 0.5 ] ,'-k', 'Linewidth', 5)
%                 end
%                 %%%%%%%%%%%%
% 
%                 % plot the frequency histogram
%                 subplot(ha(3))
%                 % averaged spectro NO normalization
% %                 plot(Spectro{3},mean(Data(Restrict(sptsd,TotEpoch-Ep))),'k','linewidth',2),hold on % non freezing period
% %                 plot(Spectro{3},mean(Data(Restrict(sptsd,Ep))),'color','c','linewidth',2) % freezing period
% %                 
%                 shadedErrorBar(Spectro{3},mean(Data(Restrict(sptsd,TotEpoch-Ep))),stdError(Data(Restrict(sptsd,TotEpoch-Ep))), {'Color', 'k', 'LineWidth', 2},1); hold on;
%                 shadedErrorBar(Spectro{3},mean(Data(Restrict(sptsd,Ep))),stdError(Data(Restrict(sptsd,Ep))), {'Color', 'c', 'LineWidth', 2},1);
%                 
%                 % normalization x f :
% %                 plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,TotEpoch-Ep))),'k','linewidth',2),hold on % non freezing period
% %                 plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,Ep))),'color','c','linewidth',2) % freezing period
%                 legend('No Freeze','Freeze')
% 
%                 figure(RgpFig)
%                 subplot(1, NbOfMicePerGp(g),mousenb)
%                  % averaged spectro NO normalization
% %                 plot(Spectro{3},mean(Data(Restrict(sptsd,TotEpoch-Ep))),'k','linewidth',2),hold on % non freezing period
% %                 plot(Spectro{3},mean(Data(Restrict(sptsd,Ep))),'color','c','linewidth',2) % freezing period
%                 shadedErrorBar(Spectro{3},mean(Data(Restrict(sptsd,TotEpoch-Ep))),stdError(Data(Restrict(sptsd,TotEpoch-Ep))), {'Color', 'k', 'LineWidth', 2},1);hold on,
%                 shadedErrorBar(Spectro{3},mean(Data(Restrict(sptsd,Ep))),stdError(Data(Restrict(sptsd,Ep))), {'Color', 'c', 'LineWidth', 2},1);
%                 
% 
%                 % normalization x f :
% %                 plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,TotEpoch-Ep))),'k','linewidth',2),hold on % non freezing period
% %                 plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,Ep))),'color','c','linewidth',2) % freezing period
%                 title(['M ' num2str(m) ])
%                 ylabel(StepName{step})
%                 ylim([0 4000])
% %                 if mousenb==1
% %                     legend('No Freeze','Freeze')
% %                 end
%             end
%            if sav
%                cd(FolderPath)
%               saveas(specFig,['Respi_' StepName{step} '_M' num2str(m) '.fig'])
%               %saveFigure(specFig,['M',num2str(m),'SpecFig'],FileInfo{step,m}(1:40))
%               StepName2{step}=StepName{step};
%               StepName2{step}(strfind(StepName2{step}, ' '))='_';
%               saveFigure(specFig,['Respi_' StepName2{step} '_M' num2str(m)],FolderPath)
%            end 
%         end % mouse loop
%         if sav
%               saveas(RgpFig,['Respi_MeanSpec_' StepName2{step} '_' groupname{g} '.fig'])
%               saveFigure(RgpFig,['Respi_MeanSpec_' StepName2{step} '_' groupname{g}],FolderPath)
%         end
%     end % group loop
% end

% % % % FIGURE Respi : frequency histogram per sound
% % 
% for step=1:2:3 % 2:hab pleth, 3 : ext pleth
%     % set the colors
%     if step==1
%         cols=jet(5);
%     elseif step==3
%         cols=jet(12);
%     end
%     for g=1:2
%         group=expgroup{g};
%         SpecPerCSFig=figure;
%         set(gcf, 'Color', [1 1 1],'Position', [1685 266 1913 420]);
%         for mousenb=1:length(group)
%             m=group(mousenb);
% 
% 
%             subplot(1,NbOfMicePerGp(g),mousenb)
% 
%             cd(FileInfo{step,m})
%             load('Respi_Low_Spectrum.mat')
% 
% 
%             cd(FileInfo{step,m})
%             if exist ('Behavior.mat')
%                 load('Behavior.mat')
%             
% 
%                 Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
%                 Ep=mergeCloseIntervals(Ep,0.3*1E4);
%                 Ep=dropShortIntervals(Ep,2*1E4);
%                 CSplInt=intervalSet(StimInfo((StimInfo(:,2)==7),1)*1e4,(StimInfo((StimInfo(:,2)==7),1)+29)*1e4); % intervals for CS+
%                 CSmiInt=intervalSet(StimInfo((StimInfo(:,2)==5),1)*1e4,(StimInfo((StimInfo(:,2)==5),1)+29)*1e4); % intervals for CS-
% 
% 
%                 sptsd=tsd(Spectro{2}*1e4,Spectro{1});
%                 % plot the frequency histogram for each CS+
%                 if ~isempty(Start(CSmiInt))
%                     for k=1:(length(Start(CSmiInt)))
%                     plot(Spectro{3},mean(Data(Restrict(sptsd,subset(CSmiInt,k)))),'color',cols(k,:),'linewidth',2),hold on
%                     [val,ind]=max(mean(Data(Restrict(sptsd,subset(CSmiInt,k)))));
% %                 if ~isempty(Start(CSplInt))
% %                     for k=1:(length(Start(CSplInt)))
% %                         % NO normalization 
% %                         plot(Spectro{3},mean(Data(Restrict(sptsd,subset(CSplInt,k)))),'color',cols(k,:),'linewidth',2),hold on
% %                         [val,ind]=max(mean(Data(Restrict(sptsd,subset(CSplInt,k)))));
%                         % normalization xF
% %                       plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,subset(CSplInt,k)))),'color',cols(k,:),'linewidth',2),hold on
% %                       [val,ind]=max(Spectro{3}.*mean(Data(Restrict(sptsd,subset(CSplInt,k)))));
% 
%                     peak(m,k)=Spectro{3}(ind);
%                     end
%                 end
%                 xlim([0 10])
%                 title(['M',num2str(m)])
%             elseif step==1 
%                % pour la respi on fait quand même le plot à partir des
%                % temps des sons 
%                 % limite : on affiche pour l'instant que les CS + (les CS
%                 % seraient aussi à ploter
%                % 
%                 load('/media/DataMOBsRAID/Projet Aversion/ManipDec14Bulbectomie/M211/20141209/FEAR-Mouse-211-09122014-HABenvB/Behavior.mat')
%                 CSplInt=intervalSet(StimInfo((StimInfo(:,2)==7),1)*1e4,(StimInfo((StimInfo(:,2)==7),1)+29)*1e4); % intervals for CS+
%                 CSmiInt=intervalSet(StimInfo((StimInfo(:,2)==5),1)*1e4,(StimInfo((StimInfo(:,2)==5),1)+29)*1e4); % intervals for CS-
%                 
%                 sptsd=tsd(Spectro{2}*1e4,Spectro{1});
%                 %plot the frequency histogram for each CS+
%                 if ~isempty(Start(CSmiInt))
%                     for k=1:(length(Start(CSmiInt)))
%                         plot(Spectro{3},mean(Data(Restrict(sptsd,subset(CSmiInt,k)))),'color',cols(k,:),'linewidth',2),hold on
%                         [val,ind]=max(mean(Data(Restrict(sptsd,subset(CSmiInt,k)))));
% %               if ~isempty(Start(CSplInt))
% %                     for k=1:(length(Start(CSplInt)))
% %                         % NO normalization
% %                     plot(Spectro{3},mean(Data(Restrict(sptsd,subset(CSplInt,k)))),'color',cols(k,:),'linewidth',2),hold on
% %                     [val,ind]=max(mean(Data(Restrict(sptsd,subset(CSplInt,k)))));
%                     % normalization xF
% %                     plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,subset(CSplInt,k)))),'color',cols(k,:),'linewidth',2),hold on
% %                     [val,ind]=max(Spectro{3}.*mean(Data(Restrict(sptsd,subset(CSplInt,k)))));
% 
%                     peak(m,k)=Spectro{3}(ind);
%                     end
%                 end
%                 xlim([0 10])
%                 title(['M',num2str(m)])
%             else
%                 disp(['no Behavior file to load for M' num2str(m)])
%             end
%             if mousenb==1
%                 text(-4,0,[StepName{step} ' ' groupname{g}], 'FontSize',50)
%             end
%         end % of mouse loop
%         
%         if sav
%             saveas(SpecPerCSFig,[FolderPath  mark 'SpectroPerCSmin_' groupname{g} '_' StepName{step} '.fig'])
%             set(SpecPerCSFig, 'PaperPosition', [10 10 32 8]);
%             saveas(SpecPerCSFig,[FolderPath  mark 'SpectroPerCSmin_' groupname{g} '_' StepName{step} '.png'])
%             % saveFigure(SpecPerCSFig,['SpectroPerCS_' groupname{g} '.fig'],FolderPath)
%         end
% 
%     end % of group loop
% end % of step loop

