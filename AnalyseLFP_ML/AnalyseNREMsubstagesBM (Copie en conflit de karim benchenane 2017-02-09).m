% AnalyseNREMsubstagesBM.m
%
% see also
% 1. AnalyseNREMsubstagesML.m
% 2. AnalyseNREMsubstages_transitionML.m
% 3. AnalyseNREMsubstages_transitionprobML.m
% 4. AnalyseNREMsubstages_EvolRescaleML.m
% 5. AnalyseNREMsubstages_OBslowOscML.m
% 6. AnalyseNREMsubstages_EvolSlowML.m
% 7. AnalyseNREMsubstages_mergeDropML.m
% 8. AnalyseNREMsubstages_SpikesML.m
% 9. AnalyseNREMsubstages_MultiParamMatrix.m
% 10. AnalyseNREMsubstages_SpikesAndRhythms.m
% 11. AnalyseNREMsubstages_SpectrumML.m
% 12. AnalyseNREMsubstages_Rhythms.m
% 13. AnalyseNREMsubstages_N1evalML.m
% 14. AnalyseNREMsubstages_TrioTransitionML.m
% 15. AnalyseNREMsubstages_TrioTransRescaleML.m
% 16. AnalyseNREMsubstages_OBX.m
% 17. AnalyseNREMsubstages_SpikesInterPyrML.m
% 18. AnalyseNREMsubstagesdKOML.m
% 19. AnalyseNREMsubstages_SD.m
% 20. AnalyseNREMsubstages_SWA.m
% 21. AnalyseNREMsubstages_OR.m
% 22. AnalyseNREMsubstages_SD24h.m
% 23. AnalyseNREMsubstages_ORspikes.m
% 24. AnalyseNREMsubstagesBM.m
% CaracteristicsSubstagesML.m



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
t_step=30*60; % in second
colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.7 0.2 1 ;1 0.5 1 ; 0.8 0.1 0.8; 0 0 0];
nameStages={'WAKE','REM','N1','N2','N3','NREM'};
saveFolder='/media/DataMOBsRAID/ProjetNREM/Figures';


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< AnalyseNREMsubstages_SD <<<<<<<<<<<<<<<<<<<<<<<<  
AnalyseNREMsubstages_SD;

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< AnalyseNREMsubstages_OR <<<<<<<<<<<<<<<<<<<<<<<<  
AnalyseNREMsubstages_OR;

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< AnalyseNREMsubstages_SWA <<<<<<<<<<<<<<<<<<<<<<<<  
AnalyseNREMsubstages_SWA;

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< OR BEHAVIOR <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  
if 0
    load('/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/ProjetNREM/MB/DonneesTempsObjets.mat')
    Dt=DonneesTempsObjets; Contrainte=nan;
else
    load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/DataBehaviorOR.mat')
    Contrainte=2; % minimal time at objects in sec.
    mice=unique(MatOR(:,1));
    Dt=nan(length(mice),3);Dt2=nan(length(mice),6);
    for mi=1:length(mice)
        ind1=find(MatOR(:,1)==mice(mi) & MatOR(:,2)==1);
        ind0=find(MatOR(:,1)==mice(mi) & MatOR(:,2)==0);
        Dt(mi,:)=MatOR(ind1,3:5)./(MatOR(ind1,3:5)+MatOR(ind0,3:5));
        ind=find(MatOR(ind1,3:5)+MatOR(ind0,3:5)<=Contrainte);
        Dt(mi,ind)=NaN;
        
        Dt2(mi,:)=[MatOR(ind1,3:5),MatOR(ind0,3:5)];
        Dt2(mi,[ind,ind+3])=NaN;
    end
    
    % raw values
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.15 0.35])
    A=nan(length(mice),8);
    A(:,[1 2 4 5 7 8])=Dt2(:,[4,1,5,2,6,3]);
    PlotErrorBarN(A,0); ylabel('Time at object (s)')
    set(gca,'Xtick',[0.5,1,2,3.5,4,5,6.5,7,8]); 
    set(gca,'XtickLabel',{'hab:','A1','A2','test:','A3','A2','test2:','A1','A2'})
    [h,p1]=ttest2(Dt2(:,1),Dt2(:,4));
    [h,p2]=ttest2(Dt2(:,2),Dt2(:,5));
    [h,p3]=ttest2(Dt2(:,3),Dt2(:,6));
    m=max(max(A)); title({sprintf('Ttest, N=%d, NfullyIncluded=%d',sum(~isnan(nanmean(Dt,2))),sum(~isnan(mean(Dt,2)))),...
        sprintf('minimal time at objects to include mouse = %ds',Contrainte)})
    text(1.3,0.9*m,sprintf('%0.4f',p1),'Color','b'); line([1,2],[0 0]+0.8*m,'Color','b')
    text(4.3,0.9*m,sprintf('%0.4f',p2),'Color','b');line([4,5],[0 0]+0.8*m,'Color','b')
    text(7.3,0.9*m,sprintf('%0.4f',p3),'Color','b');line([7,8],[0 0]+0.8*m,'Color','b')
    try saveFigure(gcf,sprintf('BilanOR_min%ds_raw',Contrainte),saveFolder);end
end

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.3 0.4])
for i=1:2
    subplot(1,2,i),
    PlotErrorBarN(Dt,0);
    set(gca,'Xtick',[1:3]);
    set(gca,'XtickLabel',{'hab','test','test2'})
    M1=mean(Dt);
    hold on, line([0 4],[0.5 0.5])
    ylabel('Time spent at displaced object/ total time at objects')
    if i==1
        namtest='signrank';
        p1=signrank(Dt(:,1),Dt(:,2));
        p2=signrank(Dt(:,1),Dt(:,3));
        p3=signrank(Dt(:,2),Dt(:,3));
    else
        namtest='ttest';
        [h,p1]=ttest2(Dt(:,1),Dt(:,2));
        [h,p2]=ttest2(Dt(:,1),Dt(:,3));
        [h,p3]=ttest2(Dt(:,2),Dt(:,3));
    end
    text(1.3,1.4*max(M1),sprintf('%0.4f',p1),'Color','b'); line([1,2],[0 0]+1.35*max(M1),'Color','b')
    text(2.3,1.6*max(M1),sprintf('%0.4f',p2),'Color','b');line([2,3],[0 0]+1.55*max(M1),'Color','b')
    text(1.8,1.8*max(M1),sprintf('%0.4f',p3),'Color','b');line([1,3],[0 0]+1.75*max(M1),'Color','b')
    title({sprintf([namtest,', N=%d, NfullyIncluded=%d'],sum(~isnan(nanmean(Dt,2))),sum(~isnan(mean(Dt,2)))),...
        sprintf('minimal time at objects to include mouse = %ds',Contrainte)})
end
if 0, saveFigure(gcf,sprintf('BilanOR_min%ds',Contrainte),saveFolder);end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< SD BEHAVIOR <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
if 0
    load('/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/ProjetNREM/MB/DonneesInterventions.mat')
    Obj=DonneesInterventions{1};
    Int=DonneesInterventions{2};
else
    load('/media/DataMOBsRAID/ProjetNREM/AnalysisNREM/DataBehaviorSD.mat')
    Obj=Obj(:,2:end)';
    Int=Int(:,2:end)';
end

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.3 0.3])
subplot(1,2,1)
pval=PlotErrorBarN(Obj',0,0);
set(gca,'Xtick',1:12); set(gca,'XtickLabel',0.5:0.5:6)
ylabel('# added Objects during 6h SD'); xlabel('Time (h), 30min blocks')
try saveFigure(gcf,'BilanSD-objets',saveFolder);end
title(sprintf('signrank, N=%d',size(Obj,1)))

subplot(1,2,2)
pval=PlotErrorBarN(Int',0);
set(gca,'Xtick',1:12); set(gca,'XtickLabel',0.5:0.5:6)
ylabel('# interventions during 6h SD');xlabel('Time (h), 30min blocks')
try saveFigure(gcf,'BilanSD-interventions',saveFolder);end
title(sprintf('signrank, N=%d',size(Int,1)))

if 0, saveFigure(gcf,'BilanSD',saveFolder);end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< figure sleepscoringMl <<<<<<<<<<<<<<<<<<<<<<<<<<<

cd /media/DataMOBsRAID/ProjetNREM/Mouse400/20160726

figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),Gf=gcf;
subplot(2,1,1),imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
caxis([20 55]); title(['Power Spectrogramm ( color=10*Log(power) ), ',pwd]); 
xlabel('Time (s)'); ylabel('Frequency (Hz)');
colorbar('Location','EastOutside')
subplot(2,1,2), hold on, 
plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+12,'b'); 
plot(Range(Restrict(Mmov,MovEpoch),'s'),2*ratio_display_mov*Data(Restrict(Mmov,MovEpoch))+12,'c');

if ~isempty(Start(SWSEpoch))
    subplot(2,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 10],'color','r','linewidth',1)
    hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),2*ratio_display_mov*Data(Restrict(Mmov,SWSEpoch))+12,'r');
end
if isempty(Start(REMEpoch))==0
    subplot(2,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 10],'color','g','linewidth',1)
    hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),2*ratio_display_mov*Data(Restrict(Mmov,REMEpoch))+12,'g');
end
ylim([0 25]); xlabel('Time (s)'); ylabel('Arbitrary unit')
title('Theta/Delta ratio= black, Wake=cyan, SWS=red, REM=green');
saveFigure(gcf,'FigureBM-SleepScoring',saveFolder)





% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< OLD COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try 
    error
MatDur=nan(length(Dir),7);
for a=1:length(Dir)
    try
        disp(Dir{a});cd(Dir{a}); 
        nameMouse{a}=Dir{a}(max(strfind(Dir{a},'Mouse'))+[0:7]);
        % ---------------------------------------------------------------------
        % get N1 N2 N3
        clear WAKE REM N1 N2 N3 NREM Total
        [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise]=RunSubstages(Dir{a}); %close;
        %WAKE=or(WAKE,noise); % optional !!
        NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,1);
        Total=or(or(NREM,REM),WAKE); mergeCloseIntervals(Total,1);
        
        % ---------------------------------------------------------------------
        % End time of Object Recognition (OR) or sleep deprivation (SD)
        clear evt tpsfin tpsdeb
        load('behavResources.mat','evt','tpsfin','tpsdeb');
        disp(evt);
        indSD=[];indOR=[];
        for e=1:length(evt)/2
            if ~isempty(strfind(evt{e},'SD')) && isempty(strfind(evt{e},'Post'))
                indSD=[indSD,e];
            elseif ~isempty(strfind(evt{e},'OR')) && isempty(strfind(evt{e},'PostOR'))
                indOR=[indOR,e];
            end
        end
        
        % ---------------------------------------------------------------------
        % Baseline (BSL), Object Recognition (OR) or Sleep Deprivation (SD)
        expetyp{a}='BSL';
        t_deb=0;
        if ~isempty(indSD)
            expetyp{a}='SD';
            t_deb_POST=tpsfin{indSD(end)};
        elseif ~isempty(indOR)
            expetyp{a}='OR';
            t_deb_POST=tpsfin{indOR(end)};
        else
            t_deb_POST=0;
        end
        
        % get time of the day
        %NewtsdZT=GetZT_ML(Dir{a});
        %h_deb=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
        
        % ---------------------------------------------------------------------
        % Post-SD or Post-OR period
        if strcmp(Dir{a}(end-7:end),'20160719')
            if strcmp(choices,'Object Recognition')
                t_deb_POST=tpsfin{2};expetyp{a}='OR';
            elseif strcmp(choices,'Sleep Deprivation')
               t_deb_POST=20516;expetyp{a}='SD';
            end
        end
        Post_Epoch=intervalSet(t_deb_POST*1E4,tpsfin{end}*1E4); % time in 10E-4 second
        %h_deb_POST=mod(min(Data(Restrict(NewtsdZT,Post_Epoch))/1E4)/3600,24)*3600;
        
         
        if 1
             WAKE=and(WAKE,Post_Epoch);
             REM= and(REM,Post_Epoch);
             N1= and(N1,Post_Epoch);
             N2= and(N2,Post_Epoch);
             N3= and(N3,Post_Epoch);
             NREM=and(NREM,Post_Epoch);
        end
        % sleep stages Total duration
        MatDur(a,1)=sum(Stop(WAKE,'s')-Start(WAKE,'s'));
        MatDur(a,2)=sum(Stop(REM,'s')-Start(REM,'s'));
        MatDur(a,3)=sum(Stop(N1,'s')-Start(N1,'s'));
        MatDur(a,4)=sum(Stop(N2,'s')-Start(N2,'s'));
        MatDur(a,5)=sum(Stop(N3,'s')-Start(N3,'s'));
        MatDur(a,6)=sum(Stop(NREM,'s')-Start(NREM,'s'));
        MatDur(a,7)=sum(Stop(Total,'s')-Start(Total,'s'));
        
        
        
        
        % ---------------------------------------------------------------------
        %Entire period
        durPost=tpsfin{end}-t_deb_POST;
        num_stepPost=ceil(durPost/ t_step);
        sto_stepPost=t_deb_POST+[1:num_stepPost]*t_step;
        
        durPre=t_deb_POST-t_deb;
        num_stepPre=ceil(durPre/ t_step);
        sto_stepPre=t_deb_POST-[0:1:num_stepPre-1]*t_step;
        sto_step=sort([sto_stepPost,sto_stepPre]);
        
        sta_step=sto_step-t_step;
        sta_step(sta_step<0)=0;
        sto_step(sto_step>tpsfin{end})=tpsfin{end};
        

        MatA=nan(6,length(sta_step));MatA2=MatA;
        for i=1:length(sta_step)

            s_Epoch=intervalSet(sta_step(i)*1E4,sto_step(i)*1E4);
            s_Epoch=and(s_Epoch,Total);
            s_Epoch_dur=sum(Stop(s_Epoch,'s')-Start(s_Epoch,'s'));
            
            % restrict sleep stages on epoch
            s_WAKE=and(WAKE,s_Epoch);
            s_REM=and(REM,s_Epoch);
            s_N1=and(N1,s_Epoch);
            s_N2=and(N2,s_Epoch);
            s_N3=and(N3,s_Epoch);
            s_NREM=and(NREM,s_Epoch);
            
            % sleep stages duration
            s_WAKE_dur=sum(Stop(s_WAKE,'s')-Start(s_WAKE,'s'));
            s_REM_dur=sum(Stop(s_REM,'s')-Start(s_REM,'s'));
            s_N1_dur=sum(Stop(s_N1,'s')-Start(s_N1,'s'));
            s_N2_dur=sum(Stop(s_N2,'s')-Start(s_N2,'s'));
            s_N3_dur=sum(Stop(s_N3,'s')-Start(s_N3,'s'));
            s_NREM_dur=sum(Stop(s_NREM,'s')-Start(s_NREM,'s'));
            
            % fill matrix with % sleep stages
            MatA(1,i)=100*s_WAKE_dur/s_Epoch_dur;
            MatA(2,i)=100*s_REM_dur/s_Epoch_dur;
            MatA(3,i)=100*s_N1_dur/s_Epoch_dur;
            MatA(4,i)=100*s_N2_dur/s_Epoch_dur;
            MatA(5,i)=100*s_N3_dur/s_Epoch_dur;
            MatA(6,i)=100*(s_N1_dur+s_N2_dur+s_N3_dur)/s_Epoch_dur;
            
            % fill matrix with % sleep stages on total sleepTime
            Sleep_dur=s_REM_dur+s_N1_dur+s_N2_dur+s_N3_dur;
            MatA2(1,i)=NaN;
            MatA2(2,i)=100*s_REM_dur/Sleep_dur;
            MatA2(3,i)=100*s_N1_dur/Sleep_dur;
            MatA2(4,i)=100*s_N2_dur/Sleep_dur;
            MatA2(5,i)=100*s_N3_dur/Sleep_dur;
            MatA2(6,i)=100*(s_N2_dur+s_N1_dur+s_N3_dur)/Sleep_dur;
        end
      
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.2 0.4]),
        for j=1:6
            subplot(1,2,1), hold on, plot([1:length(sta_step)]*t_step/3600,MatA(j,:),'o-','Linewidth',2,'Color',colori(j,:));
            subplot(1,2,2), hold on, plot([1:length(sta_step)]*t_step/3600,MatA2(j,:),'o-','Linewidth',2,'Color',colori(j,:));
        end
        line([0 t_deb_POST/3600],[0 0],'Linewidth',3,'Color','r')
        ylabel({'Stage duration ','(% of total sleep)'}); xlim([0 12]); ylim([0 100]);
        title(Dir{a});legend([nameStages,expetyp{a}]);xlim([0 12]); ylim([0 100])
        subplot(1,2,1),ylabel({'Stage duration ','(% of total recording time)'})
        line([0 t_deb_POST/3600],[0 0],'Linewidth',3,'Color','r')
        title([nameMouse{a},' ',expetyp{a}]); xlim([0 12]); ylim([0 100])
        xlabel('Time (h), devided in 30min blocks')
        % saveFigure
        %saveFigure(gcf,[nameMouse{a},'-',expetyp],saveFolder)
        
        % save Mat for comparison
        if length(sto_stepPre)<12 && strcmp(expetyp{a},'SD')
            MatA=[nan(6,12-length(sto_stepPre)),MatA];
            MatA2=[nan(6,12-length(sto_stepPre)),MatA2];
        end
        MAT{a,1}=MatA;
        MAT{a,2}=MatA2;
    catch
        disp('Problem, skip'); keyboard
    end
end

%% BILAN RESULTS evolution BSL vs SD

%mmm=1;tit='(% of total recording time)';
mmm=2;tit='(% of total sleep)';
mice=unique(nameMouse);
MiBSL=nan(length(mice),6,30); MiSD=MiBSL;
for mi=1:length(mice)
    indBSL=find(strcmp(nameMouse,mice{mi}) & strcmp(expetyp,'BSL'));
    indSD=find(strcmp(nameMouse,mice{mi}) & strcmp(expetyp,'SD'));
    
    % average on same mouse
    MatBSL=nan(6,30);
    try
        MatBSL(:,1:size(MAT{indBSL(1),mmm},2))=MAT{indBSL(1),mmm};
        for i=2:length(indBSL)
            temp=nan(6,30); temp(:,1:size(MAT{indBSL(i),mmm},2))=MAT{indBSL(i),mmm};
            for j=1:6
                for k=1:30
                    MatBSL(j,k)=nansum([MatBSL(j,k),temp(j,k)]);
                end
            end
        end
        MiBSL(mi,:,:)=MatBSL/length(indBSL);
    end
    
    MatSD=nan(6,30);
    try
        MatSD(:,1:size(MAT{indSD(1),mmm},2))=MAT{indSD(1),mmm};
        for i=2:length(indSD)
            temp=nan(6,30); temp(:,1:size(MAT{indSD(i),mmm},2))=MAT{indSD(i),mmm};
            for j=1:6
                for k=1:30
                    MatSD(j,k)=nansum([MatSD(j,k),temp(j,k)]);
                end
            end
        end
        MiSD(mi,:,:)=MatSD/length(indSD);
    end
end

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7]),
for j=1:6
    subplot(2,3,j), hold on,
    MatDo=squeeze(MiBSL(:,j,:));
    errorbar([1:30]*t_step/3600,nanmean(MatDo,1),stdError(MatDo),'Linewidth',2,'Color',[0.5 0.5 0.5]);
    
    MatDo2=squeeze(MiSD(:,j,:));
    errorbar([1:30]*t_step/3600,nanmean(MatDo2,1),stdError(MatDo2),'Linewidth',2,'Color',colori(j,:));
    xlim([0 12]); ylim([0 100]);xlabel('Time (h), devided in 30min blocks')
    
    hold on, plot(6.25*[1 1],[0 100],'--','Color','k')
    title([nameStages{j},sprintf(' (n=%d)',sum(~isnan(nanmean(MatDo2,2))))],'Color',colori(j,:));
    legend({'BSL','SD'});
    pval=nan(1,30);
    for k=1:30
        try
            p=signrank(MatDo(:,k),MatDo2(:,k));namtest='signrank';
            %[h,p]=ttest2(MatDo(:,k),MatDo2(:,k));namtest='ttest';
            if p<0.05, pval(k)=50;end
            %pval(k)=100*p;
        end
        
    end
    plot([1:30]*t_step/3600,pval,'*r')
    if mod(j,3)==1,ylabel({'Stage duration',tit});legend({'BSL','SD','finSD',[namtest,': p<0.05']}); end
end

% saveFigure
saveFigure(gcf,['BilanEvolSD-',num2str(mmm),'-',namtest],saveFolder)


%% BILAN Results global duration BSL vs SD
mice=unique(nameMouse);

PercRec=100*MatDur(:,1:6)./(MatDur(:,7)*ones(1,6));
PercSleep=100*MatDur(:,1:6)./((MatDur(:,2)+MatDur(:,6))*ones(1,6));

MiRecSD=nan(length(mice),6); MiRecBSL=MiRecSD; DiffRec=MiRecSD;
MiSlpSD=nan(length(mice),6); MiSlpBSL=MiRecSD; DiffSlp=MiRecSD;
for mi=1:length(mice)
    indBSL=find(strcmp(nameMouse,mice{mi}) & strcmp(expetyp,'BSL'));
    indSD=find(strcmp(nameMouse,mice{mi}) & strcmp(expetyp,'SD'));
    
    MiRecBSL(mi,:)=nanmean(PercRec(indBSL,:),1);
    MiRecSD(mi,:)=nanmean(PercRec(indSD,:),1);
    DiffRec(mi,:)=MiRecSD(mi,:)-MiRecBSL(mi,:);
    
    MiSlpBSL(mi,:)=nanmean(PercSleep(indBSL,:),1);
    MiSlpSD(mi,:)=nanmean(PercSleep(indSD,:),1);
    DiffSlp(mi,:)=MiSlpSD(mi,:)-MiSlpBSL(mi,:);
end
MiSlpBSL(:,1)=nan(length(mice),1);
MiSlpSD(:,1)=nan(length(mice),1);

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.35])
subplot(2,3,1), bar(MiRecBSL); title('BSL'),
ylabel({'Time in substages','% total recording time'}) 
subplot(2,3,2), bar(MiRecSD); title('SD')
subplot(2,3,3), bar(DiffRec); title('SD - BSL')
subplot(2,3,4), bar(MiSlpBSL); title('BSL')
ylabel({'Time in substages','% Sleep time'})
subplot(2,3,5), bar(MiSlpSD); title('SD'); xlabel('# mouse')
subplot(2,3,6), bar(DiffSlp); title('SD - BSL'); legend([nameStages,'NREM'])

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.35])
subplot(1,2,1), hold on,
MiDur=nanmean(MiRecBSL,1); 
MiDur(2,:)=nanmean(MiRecSD,1);
bar(MiDur'); ylim([0 100])
errorbar([1:6]-0.15,nanmean(MiRecBSL),stdError(MiRecBSL),'+k');
errorbar([1:6]+0.15,nanmean(MiRecSD),stdError(MiRecSD),'+k');
ylabel({'Time in substages','% total recording time'})
set(gca,'Xtick',1:6), set(gca,'XtickLabel',[nameStages,'NREM'])
title(sprintf('BSL vs SD (n=%d)',sum(~isnan(nanmean(MiRecSD,2)))))
for i=1:6,
    p=signrank(MiRecBSL(:,i),MiRecSD(:,i));
    if p<0.05, col='r'; else, col='k';end 
    text(i-0.2,8+max(nanmean([MiRecBSL(:,i),MiRecSD(:,i)],1)),sprintf('p=%1.3f',p),'Color',col);
end

subplot(1,2,2), hold on,
MiDur=nanmean(MiSlpBSL,1);
MiDur(2,:)=nanmean(MiSlpSD,1);
MiDur(:,1)=[NaN,NaN];
bar(MiDur'); ylim([0 100])
errorbar([1:6]-0.15,nanmean(MiSlpBSL),stdError(MiSlpBSL),'+k');
errorbar([1:6]+0.15,nanmean(MiSlpSD),stdError(MiSlpSD),'+k');
ylabel({'Time in substages','% Sleep time'}); legend({'BSL','SD'})
set(gca,'Xtick',1:6), set(gca,'XtickLabel',[nameStages,'NREM'])
title(sprintf('BSL vs SD (n=%d)',sum(~isnan(nanmean(MiSlpSD,2)))))
for i=1:6,
    try p=signrank(MiSlpBSL(:,i),MiSlpSD(:,i)); catch p=NaN;end
    if p<0.05, col='r'; else, col='k';end 
    text(i-0.2,8+max(nanmean([MiSlpBSL(:,i),MiSlpSD(:,i)],1)),sprintf('p=%1.3f',p),'Color',col);
end

%%
MATdif=nan(size(MAT,1)/2,6,24);
MATdif2=MATdif;
for i=1:size(MAT)/2
    A=MAT{i+size(MAT,1)/2,1}; B=MAT{i,1}; n=min(size(A,2),size(B,2));
    mat=A(:,1:n)-B(:,1:n);
    A=MAT{i+size(MAT,1)/2,2}; B=MAT{i,2}; n=min(size(A,2),size(B,2));
    mat2=A(:,1:n)-B(:,1:n);
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.25 0.25]),
    for j=1:6
        subplot(1,2,1), hold on, plot([1:n]*t_step/3600,mat(j,:),'o-','Linewidth',2,'Color',colori(j,:));
        subplot(1,2,2), hold on, plot([1:n]*t_step/3600,mat2(j,:),'o-','Linewidth',2,'Color',colori(j,:));
    end
    xlabel('Time (h), devided in 30min blocks')
    ylabel('Stage duration (% of total sleep)')
    title([nameMouse{i},' SD - BSL']); xlim([0 6]); ylim([0 100])
    
    subplot(1,2,1),xlabel('Time (h), devided in 30min blocks')
    ylabel('Stage duration (% of total recording time)')
    title({Dir{i},Dir{i+size(MAT,1)/2}});legend(nameStages); xlim([0 6]); ylim([0 100])
    
    % saveFigure
    saveFigure(gcf,[nameMouse{a},'-diffSDvsBSL'],saveFolder)
    
    % save Mat for comparison
    MATdif(i,:,1:n)=mat;
    MATdif2(i,:,1:n)=mat2;
    
end

%%

MATdif=nan(size(MAT,1)/2,6,24);
MATdif2=MATdif;
for i=1:size(MAT)/2
    A=MAT{i+size(MAT,1)/2,1}; B=MAT{i,1}; n=min(size(A,2),size(B,2));
    mat=log10(A(:,1:n)./B(:,1:n));
    A=MAT{i+size(MAT,1)/2,2}; B=MAT{i,2}; n=min(size(A,2),size(B,2));
    mat2=log10(A(:,1:n)./B(:,1:n));
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.25 0.25]),
    for j=1:6
        subplot(1,2,1), hold on, plot([1:n]*t_step/3600,mat(j,:),'o-','Linewidth',2,'Color',colori(j,:));
        subplot(1,2,2), hold on, plot([1:n]*t_step/3600,mat2(j,:),'o-','Linewidth',2,'Color',colori(j,:));
    end
    xlabel('Time (h), devided in 30min blocks')
    ylabel('Stage duration (% of total sleep)')
    title([nameMouse{i},' log (SD /BSL)']); xlim([0 6]); ylim([-3 3])
    
    subplot(1,2,1),xlabel('Time (h), devided in 30min blocks')
    ylabel('Stage duration (% of total recording time)')
    title({Dir{i},Dir{i+size(MAT,1)/2}});legend(nameStages); xlim([0 6]); ylim([-3 3])
    
    % saveFigure
    saveFigure(gcf,[nameMouse{a},'-logSDvsBSL'],saveFolder)
    
    % save Mat for comparison
    MATdif(i,:,1:n)=mat;
    MATdif2(i,:,1:n)=mat2;
    
end
end
