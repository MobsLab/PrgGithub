% %GrangerMarieDiffStructures
% order=16;
% [params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
% plo=1;
% 
% %GrangerJulie
% %cd /media/DataMOBsRAID/ProjetAstro/Mouse246/20150323/BULB-Mouse-245-246-23032015
% cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC
% res=pwd;
% Figpath=[res '/Granger' ];
 


% % load StateEpoch SWSEpoch REMEpoch
% load behavResources FreezeEpoch Movtsd
% tps=Range(Movtsd); %tps est en 10-4sec
% TotEpoch=intervalSet(tps(1),tps(end));
% NoFreezeEpoch=TotEpoch-FreezeEpoch;
% 
% structlist={'PFCx_deep','Bulb_deep'};%,'dHPC_rip','PiCx','Amyg'};
%structlist={'dHPC_rip','PFCx_deep'};%,'dHPC_rip','PiCx','Amyg'};
%structlist={'dHPC_rip','PFCx_deep'};%,'dHPC_rip','PiCx','Amyg'};
%structlist={'Bulb_deep','PiCx'};%,'dHPC_rip','PiCx','Amyg'};

% temp1=load(['ChannelsToAnalyse/',structlist{1},'.mat']);
% eval(['temp1_1=load(''LFPData/LFP',num2str(temp1.channel),'.mat'');']);
% LFP1=temp1_1.LFP;
% temp2=load(['ChannelsToAnalyse/',structlist{2},'.mat']);
% eval(['temp2_2=load(''LFPData/LFP',num2str(temp2.channel),'.mat'');']);
% LFP2=temp2_2.LFP;

% %% on subEpoch
% 
% for i=1:length(Start(NoFreezeEpoch))
% %Epoch='subset(REMEpoch,1)';
% 
%     Epoch=['subset(NoFreezeEpoch,' num2str(i) ')'];
%     if tot_length(subset(NoFreezeEpoch,i), 's')>30
%         eval(['[granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1,S2,t,f,Ctsd,confC,phistd]= GrangerMarie(LFP1,LFP2,' Epoch ',order,params,movingwin,plo);'])
%         %subplot(2,2,3), title([structlist{1} ' - ' structlist{2} ])
%         subplot(2,2,1:2),hold on
%         EpochLength=eval(['tot_length(' Epoch ', ''s'')']);
%         titleFig=[structlist{1}, ' - ', structlist{2},  ' - ' ,Epoch, '  - ', sprintf('%0.0f',EpochLength) ,' sec' ];
%         title(titleFig)
%     end
% end
% 
% %% on global Epoch
% thMinEpoch=30;
% Epochs={'FreezeEpoch', 'NoFreezeEpoch'};
% for i=1:length(Epochs)
%     Epoch=Epochs{i};
%     
%     eval(['dropShortIntervals(' Epoch ',thMinEpoch*1E4)']);
%     eval(['[granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1,S2,t,f,Ctsd,confC,phistd]= GrangerMarie(LFP1,LFP2,' Epoch ',order,params,movingwin,plo);'])
%     %subplot(2,2,3), title([structlist{1} ' - ' structlist{2} ])
%     subplot(2,2,1:2),hold on
%     EpochLength=eval(['tot_length(' Epoch ', ''s'')']);
%     titleFig=[structlist{1}, ' - ', structlist{2},  ' - ' ,Epoch, '  - ', sprintf('%0.0f',EpochLength) ,' sec' ];
%     title(titleFig)
%     saveas(gcf, [Figpath, '/' structlist{1}, ' - ', structlist{2},  ' - ' ,Epoch, '.fig']);
%     saveFigure(gcf, [structlist{1}, '-', structlist{2},  '-' ,Epoch],  Figpath);
% end

%% for all manip

order=16;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0.1 80];
params.tapers=[3 5];
params.Fs=250;

movingwin=[3 0.2];
suffix='L';

structpairs={'PFCx_deep','Bulb_deep';'PFCx_deep','dHPC_rip';'dHPC_rip','Bulb_deep'};
%structpairs={'PFCx_deep','Bulb_deep';'PFCx_deep','dHPC_rip';'dHPC_rip','Bulb_deep';'PiCx','Bulb_deep'};02.02.2016
%structpairs={'PFCx_deep','Bulb_deep';'PFCx_deep','dHPC_rip';'dHPC_rip','Bulb_deep';'PiCx','Bulb_deep'};
ssp=size(structpairs,1);
plo=0;
thtps_immob=2;
th_immob=1;
%Dir=RestrictPathForExperiment(PathForExperimentFEAR('Fear-electrophy'),'nMice',[241 248]);
Dir=RestrictPathForExperiment(PathForExperimentFEAR('Fear-electrophy'),'Group','CTRL');
Dir=RestrictPathForExperiment(Dir,'nMice',[ 244 241 253 254 258 259 299, 230 250 291 297 298]);
%Dir=RestrictPathForExperiment(PathForExperimentFEAR('Fear-electrophy'),'Group','OBX');

thMinEpoch=10;
Epochs={'FreezeEpoch', 'NoFreezeEpoch'};
nameGroups=unique(Dir.group);
nameMice=unique(Dir.name);
% initialization
Gran1to2Mat=nan(length(Dir.path),length(structpairs),1250,2); % 1250 specific for this code (=freqBin)
Gran2to1Mat=nan(length(Dir.path),length(structpairs),1250,2); 
MatInfo=nan(length(Dir.path),length(structpairs),3,2);  

for i=1:length(Epochs), allfig(i)=figure('Color',[1 1 1],'Position', [100 10 250*length(Dir.path) 200*ssp]);end %[100 10 1600 900]
try
    load('GrangerFreezing.mat');MatInfo;
    disp('Loading existing data from GrangerFreezing.mat');
catch
    for man=1:length(Dir.path)

        cd (Dir.path{man})
        disp(Dir.path{man})
        load behavResources  Movtsd
        load StateEpoch TotalNoiseEpoch
        eval(['temp2=load(''',Dir.path{man},'/behavResources.mat'',''Movtsd'');']);%, attention valable seulement pour file comportment car fichier sleep= doubletracking=pixratio pas appliqué
        FreezeEpoch=thresholdIntervals(Movtsd,th_immob,'Direction','Below');
        FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
        FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.3*1E4);
        FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1E4);

        tps=Range(Movtsd); %tps est en 10-4sec
        TotEpoch=intervalSet(tps(1),tps(end));
        NoFreezeEpoch=TotEpoch-FreezeEpoch-TotalNoiseEpoch;

        for i=1:size(structpairs,1)
            structlist=structpairs(i,:);

            %try 
                temp1=load(['ChannelsToAnalyse/',structlist{1},'.mat']);
                eval(['temp1_1=load(''LFPData/LFP',num2str(temp1.channel),'.mat'');']);
                LFP1=temp1_1.LFP;
                temp2=load(['ChannelsToAnalyse/',structlist{2},'.mat']);
                eval(['temp2_2=load(''LFPData/LFP',num2str(temp2.channel),'.mat'');']);
                LFP2=temp2_2.LFP;
                disp([structlist{1} ' loaded' structlist{2} ' loaded'])

                for e=1:length(Epochs)
                    Epoch=Epochs{e};
                    ylabelok(e,man)=1;
                    legendok(e,man,i)=1;
                    titleEpochok(e,man,i)=1;
                    disp(Epoch)
                    eval([Epoch '=dropShortIntervals(' Epoch ',thMinEpoch*1E4);']);
                    startE=eval(['Start(' Epoch ', ''s'')']);
                    if ~isempty(startE)
                        eval(['[granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1,S2,t,f,Ctsd,confC,phistd]= GrangerMarie(LFP1,LFP2,' Epoch ',order,params,movingwin,plo);'])
                        EpochLength=eval(['tot_length(' Epoch ', ''s'')']);
                        if plo
                            subplot(2,2,1:2),hold on
                            titleFig=[structlist{1}, ' - ', structlist{2},  ' - ' ,Epoch, '  - ', sprintf('%0.0f',EpochLength) ,' sec' ];
                            title(titleFig)

                            if ~exist([Dir.path{man},'/Granger'],'dir'), 
                                mkdir([Dir.path{man},'/Granger']);
                            end
                            saveas(gcf, [Dir.path{man},'/Granger/' structlist{1}, '-', structlist{2},  '-' ,Epoch, '.fig']);
                            saveFigure(gcf, [structlist{1}, '-', structlist{2},  '-' ,Epoch(1:3)],  [Dir.path{man},'/Granger/']);
                        end

                        Gran1to2Mat(man,i,1:length(freqBin),e)=Fx2y;
                        Gran2to1Mat(man,i,1:length(freqBin),e)=Fy2x;
                        eval(['T=tot_length(' Epoch ',''s'')']);
                        MatInfo(man,i,1:3,e)=[find(strcmp(Dir.group{man},nameGroups)),find(strcmp(Dir.name{man},nameMice)), T];
                        % MatInfo: nGroup, nMice, duration(Epoch) 

                        figure(allfig(e))
                        subplot(ssp,length(Dir.path), length(Dir.path)*(i-1)+man)
                        plot(freqBin, Fx2y,'k','linewidth',2), hold on
                        plot(freqBin, Fy2x,'r','linewidth',2)
                        plot(f,mean(Data(Ctsd)),'b','linewidth',2)
                        title(['M ' Dir.name{man}(end-2:end) ' - ' sprintf('%0.0f',EpochLength) ,' sec' ])
                        xlim([0 80]),ylim([0 1]), xl=xlim;yl=ylim;
                        plot(xl, [confC confC], ':', 'Color', [0.7 0.7 0.7])
                        if ylabelok(e,1)==1, 
                            %text(xl(1)-0.5*(xl(2)-xl(1)), yl(2), structlist{1})
                            %text(xl(1)-0.5*(xl(2)-xl(1)),  0.8*yl(2), structlist{2})
                            ylabel([structlist{1}, '-', structlist{2}])

                            ylabelok(e,1)=0;
                        end
                        if legendok(e,1,1)==1
                            legend('1->2', '2->1', 'coh');
                            xlabel(['thtps ' num2str(thMinEpoch) ]) 
                            legendok(e,1,1)=0;
                        end
                        if titleEpochok(e,1)==1
                            text(xl(1)-0.5*(xl(2)-xl(1)), 1.2*yl(2), Epoch)
                            titleEpochok(e,1)=0;
                        end
                    end
                end % end length epoch
%             catch
%                 disp('Pb loading LFP')
%             end % end try
        end % end ssize(structure,1)
    end % end dir.path
    
    for e=1:length(Epochs),
    saveas(allfig(e), ['/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Granger_' Epochs{e}(1:(end-5)) '_' num2str(thMinEpoch) '.fig'])
    saveFigure(allfig(e), ['Granger_' Epochs{e}(1:(end-5)) '_' num2str(thMinEpoch)], '/media/DataMOBsRAID/ProjetAversion/DATA-Fear/')
    end
end % end try load .mat


cd /media/DataMOBsRAID/ProjetAversion/DATA-Fear/Granger/
save GrangerFreezing MatInfo Gran1to2Mat Gran2to1Mat params structpairs nameMice nameGroups Dir f th_immob thtps_immob  Epochs freqBin %Rogne thtps_immob_for_rogne
    


%% superpose group spectra for conditions
hFigCoh=figure('Color',[1 1 1],'Position', [100 10 1600 900]);
colori=jet(length(nameMice));
namecolmn={'Freezing 1->2','Freezing 2->1','No Freezing 1->2','No Freezing 2->1','Freezing','No Freezing'};
% name MatInfo: nGroup nMice duration(FreezeEpoch) duration(TotEpoch-FreezeEpoch);
clear Gran1to2_F Gran2to1_F Gran1to2_NoF Gran2to1_NoF GranInfo_F GranInfo_NoF

for i=1:size(structpairs,1)

    yl=[0 1];
    Gran1to2_F=squeeze(Gran1to2Mat(:,i,:,1));
    Gran2to1_F=squeeze(Gran2to1Mat(:,i,:,1));
    Gran1to2_NoF=squeeze(Gran1to2Mat(:,i,:,2));
    Gran2to1_NoF=squeeze(Gran2to1Mat(:,i,:,2));
    GranInfo_F=squeeze(MatInfo(:,i,:,1));
    GranInfo_NoF=squeeze(MatInfo(:,i,:,2));
    legF=[];legNoF=[];
    for man=1:length(Dir.path)
        try
            %if SpInfo(man,3)>th_for_plot          
                subplot(length(structpairs),6,6*(i-1)+1),hold on,
                plot(freqBin,Gran1to2_F(man,:),'Color',colori(GranInfo_F(man,2),:), 'Linewidth',1);
                ylabel([structpairs{i,1} '-' structpairs{i,2}]); ylim(yl);xlim(params.fpass);
                ylim(yl);xlim(params.fpass);
        end
        try
                subplot(length(structpairs),6,6*(i-1)+2),hold on,
                plot(freqBin,Gran2to1_F(man,:),'Color',colori(GranInfo_F(man,2),:), 'Linewidth',1)
                ylim(yl);xlim(params.fpass);
                legF=[legF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(GranInfo_F(man,3))),'s']}];
            %end
        end
        try
            %if SpInfo(man,4)>th_for_plot  
                subplot(length(structpairs),6,6*(i-1)+3),hold on,
                %plot(f,SpNoF(man,:),'Color',colori(SpInfo(man,2),:));
                plot(freqBin,Gran1to2_NoF(man,:),'Color',colori(GranInfo_NoF(man,2),:), 'Linewidth',1);
                ylim(yl);xlim(params.fpass);
        end
        try
                subplot(length(structpairs),6,6*(i-1)+4),hold on,
                plot(freqBin,Gran2to1_NoF(man,:),'Color',colori(GranInfo_NoF(man,2),:), 'Linewidth',1)
                ylim(yl);xlim(params.fpass);
                legNoF=[legNoF,{[Dir.name{man}([1,6:8]),' ',num2str(floor(GranInfo_NoF(man,3))),'s']}];
            %end
        end
    end
    for k=1:length(namecolmn)
        subplot(length(structpairs),6,6*(i-1)+k), 
        if i==length(structpairs), 
            xlabel('Frequency (Hz)');
        end
        title(namecolmn{k})
    end
    
    subplot(length(structpairs),6,6*(i-1)+1), legend(legF);
    subplot(length(structpairs),6,6*(i-1)+3), legend(legNoF);
end

clear Gran1to2_F Gran2to1_F Gran1to2_NoF Gran2to1_NoF GranInfo_F GranInfo_NoF
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% pool mice before pooling groups %%%%%%%%%%%%%%%%%%%%
for mi=1:length(nameMice)
    for i=1:length(structpairs)
        ind=find(strcmp(Dir.name,nameMice{mi}));
        try
            temp=squeeze(Gran1to2Mat(ind,i,:,1)); if length(ind)==1,temp=temp';end % Mm=Mouse mean % 1=Freeze  2=No Freeze
            Gran1to2_F_Mm(mi,i,1:length(freqBin))=nanmean(temp,1);
            temp=squeeze(Gran1to2Mat(ind,i,:,2)); if length(ind)==1,temp=temp';end % Mm=Mouse mean
            Gran1to2_NoF_Mm(mi,i,1:length(freqBin))=nanmean(temp,1);
            
            temp=squeeze(Gran2to1Mat(ind,i,:,1)); if length(ind)==1,temp=temp';end
            Gran2to1_F_Mm(mi,i,1:length(freqBin))=nanmean(temp,1);
            temp=squeeze(Gran2to1Mat(ind,i,:,2)); if length(ind)==1,temp=temp';end
            Gran2to1_NoF_Mm(mi,i,1:length(freqBin))=nanmean(temp,1);
            infoG(mi,i)=unique(Dir.group(ind));
        end
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%% plot average 1-2 and 2->1 %%%%%%%%%%%%%%%%%%%%

colorG={'r', 'b', 'k'};
for i=1:length(structpairs)
    
    
        Gran1to2_F_avg=squeeze(Gran1to2_F_Mm(:,i,:)); if length(ind)==1,Gran1to2_F_avg=Gran1to2_F_avg';end
        Gran1to2_NoF_avg=squeeze(Gran1to2_NoF_Mm(:,i,:)); if length(ind)==1,Gran1to2_NoF_avg=Gran1to2_NoF_avg';end
        Gran2to1_F_avg=squeeze(Gran2to1_F_Mm(:,i,:)); if length(ind)==1,Gran2to1_F_avg=Gran2to1_F_avg';end
        Gran2to1_NoF_avg=squeeze(Gran2to1_NoF_Mm(:,i,:)); if length(ind)==1,Gran2to1_NoF_avg=Gran2to1_NoF_avg';end
 
        subplot(length(structpairs),6,6*(i-1)+5),hold on,
        plot(freqBin,nanmean(Gran1to2_F_avg,1),'Color','k','Linewidth',2);ylim(yl);xlim(params.fpass);
        plot(freqBin,nanmedian(Gran1to2_F_avg,1),'--','Color','k','Linewidth',1);
        plot(freqBin,nanmean(Gran2to1_F_avg,1),'Color','r','Linewidth',2);
        plot(freqBin,nanmedian(Gran2to1_F_avg,1),'--','Color','r','Linewidth',1);
        
        subplot(length(structpairs),6,6*(i-1)+6),hold on,
        plot(freqBin,nanmean(Gran1to2_NoF_avg,1),'Color','k','Linewidth',2);ylim(yl);xlim(params.fpass);
        plot(freqBin,nanmedian(Gran1to2_NoF_avg,1),'--','Color','k','Linewidth',1);
        plot(freqBin,nanmean(Gran2to1_NoF_avg,1),'Color','r','Linewidth',2);
        plot(freqBin,nanmedian(Gran2to1_NoF_avg,1),'--','Color','r','Linewidth',1);
        

    if i==length(structpairs), legend('1->2','median', '2->1', 'median');end

    subplot(length(structpairs),6,6*(i-1)+5),hold on,
    xlabel([ num2str(sum(~isnan(Gran1to2_F_avg(:,1)))) ' mice'])
    subplot(length(structpairs),6,6*(i-1)+6),hold on,
    xlabel([ num2str(sum(~isnan(Gran1to2_NoF_avg(:,1)))) ' mice'])
    
end
saveas (gcf, [pwd '/Granger_AllStt.fig'])
saveFigure(gcf,'Granger_AllStt',pwd)


% 
% subplot(2,2,4), hold on
% xlabel('Mouse246/20150323/BULB-Mouse-245-246-23032015')
% 
% %%%%%%%%%%%%%%%% essais fait avec Karim  27.05.2015
% load StateEpoch SWSEpoch REMEpoch
% % PFCx left : channel9
% load(['LFPData/LFP9.mat']);
% LFPpl=LFP;
% % PFCx right : channel28
% load(['LFPData/LFP28.mat']);
% LFPpr=LFP;
% % Bulb sup : channel27
% load(['LFPData/LFP27.mat']);
% LFPbs=LFP;
% % Bulb sup : channel26
% load(['LFPData/LFP26.mat']);
% LFPbd=LFP;
% % dHPC: channel25
% load(['LFPData/LFP25.mat']);
% LFPh=LFP;
% 
% 
% %penddant le REM
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPh,LFPpr,subset(REMEpoch,2),order,params,movingwin,plo);
% subplot(2,2,3),hold on, title('dHPC - PFCx deep right'), xlabel('subset(REMEpoch,2)')
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPh,LFPpl,subset(REMEpoch,2));
% subplot(2,2,3),hold on, title('dHPC - PFCx deep left'), xlabel('subset(REMEpoch,2)')
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPh,LFPpr,subset(SWSEpoch,2));
% subplot(2,2,3),hold on, title('dHPC - PFCx deep right'), xlabel('subset(SWSEpoch,2)')
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPh,LFPpl,subset(SWSEpoch,2));
% subplot(2,2,3),hold on, title('dHPC - PFCx deep left'), xlabel('subset(SWSEpoch,2)')
% 
% % le bulbe semble driver le PFC pendant le REM ??
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPpr,LFPbs,subset(REMEpoch,2));
% subplot(2,2,3),hold on, title('PFCx right - Bulb sup'),xlabel('subset(REMEpoch,2)')
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPpl,LFPbs,subset(REMEpoch,2));
% subplot(2,2,3),hold on, title('PFCx left - Bulb sup'),xlabel('subset(REMEpoch,2)')
% % mais l'hippocampe drive le bulbe pendant le  REM. mais trop bizarre car
% % le spectre ne montre pas de theta dans le bulbe pendant le REM...
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPh,LFPbs,subset(REMEpoch,2));
% subplot(2,2,3),hold on, title('dHPC - Bulb sup'),xlabel('subset(REMEpoch,2)')
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPh,LFPbd,subset(REMEpoch,2));
% subplot(2,2,3),hold on, title('dHPC - Bulb deep'),xlabel('subset(REMEpoch,2)')
% 
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPh,LFPbs,subset(SWSEpoch,2:6));
% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1b,S2b,tb,fb]= GrangerMarie(LFPh,LFPbd,subset(SWSEpoch,2:6));