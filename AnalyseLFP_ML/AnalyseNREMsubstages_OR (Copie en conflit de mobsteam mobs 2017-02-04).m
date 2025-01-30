% AnalyseNREMsubstages_OR.m
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

analyFolder='/media/DataMOBsRAID/ProjetNREM/AnalysisNREM';
t_step=60*60; % in second
colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 0.5];

saveFolder='/media/DataMOBsRAID/ProjetNREM/Figures/ObjectRecognition';
savFigure=0;
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% ------------ BASELINES ----------------
a=0;
    % 294
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160621'; % manque début rec
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160627';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160628';
    % 330
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160621';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160627';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160628';
    % 393
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160704';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160711';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160718'; % pas de signaux début rec
    % 394
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160711';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160718';
    % 395
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160718';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160725';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160726';
    % 400
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160725';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160726';
    % 402
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160822';
    % 403
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160822';
% ------------ ORhab BEHAVIOR EXPERIMENT ---------------- 
a=0;
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160622';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160622';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160705';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160705';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160719'; 
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160719';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160823';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160823';

% ------------ ORtest BEHAVIOR EXPERIMENT ----------------
a=0;
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160623';
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160623';
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160706';
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160706';
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160720';
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160720';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160824';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160824';



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< LOAD DATA IF EXIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
DoAnalysis=0;
try
    clear Epochs;
    temp=load([analyFolder,'/AnalyNREMsubstagesOR.mat'],'Epochs','DirE','Dir');
    temp.Epochs;
    chang=0;
    for a=1:length(DirE)
        if strcmp(DirE{a},temp.DirE{a})~=1
            disp(['new DirE #',num2str(a),': ',temp.DirE{a}])
            chang=chang+1;
        end
    end
    for a=1:length(Dir)
        if strcmp(Dir{a},temp.Dir{a})~=1
            disp(['new Dir #',num2str(a),': ',temp.Dir{a}])
            chang=chang+1;
        end
    end
    
    if chang~=0
        DoAnalysis=input('Redo analysis ? 1/0 :');
    end
catch 
    DoAnalysis=1;
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< GET EXPERIMENTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

if DoAnalysis
    
    % <<<<<<<<<<<<<<<<<<<<< Get Behavioral experiments <<<<<<<<<<<<<<<<<<<<
    Epochs={}; nameMouse={};
    h_deb=nan(length(DirE),1); t_deb_POST=h_deb; 
    h_deb_POST=h_deb; t_fin=h_deb;
    for a=1:length(DirE)
        try
            disp(DirE{a});cd(DirE{a});
            nameMouse{a}=DirE{a}(max(strfind(DirE{a},'Mouse'))+[0:7]);
            
            % -------------------------------------------------------------
            % get substages
            clear WAKE REM N1 N2 N3 NREM Total
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise]=RunSubstages(DirE{a}); close;
            %WAKE=or(WAKE,noise); % optional !!
            NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,1);
            Total=or(or(NREM,REM),WAKE); mergeCloseIntervals(Total,1);
            Epochs{a,1}=WAKE;
            Epochs{a,2}=REM;
            Epochs{a,3}=N1;
            Epochs{a,4}=N2;
            Epochs{a,5}=N3;
            Epochs{a,6}=NREM;
            Epochs{a,7}=Total;
            Stages={'WAKE','REM','N1','N2','N3','NREM','Total'};
            
            % get time of the day
            NewtsdZT=GetZT_ML(DirE{a});
            h_deb(a)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
            
            % -------------------------------------------------------------
            % End time of Object Recognition (OR)
            clear evt tpsfin tpsdeb
            load('behavResources.mat','evt','tpsfin','tpsdeb');
            disp(evt);
            indOR=[];
            for e=1:length(evt)/2
                if ~isempty(strfind(evt{e},'OR')) && isempty(strfind(evt{e},'Post'))
                    indOR=[indOR,e];
                end
            end
            % -------------------------------------------------------------
            t_deb=0;
            if ~isempty(indOR)
                t_deb_POST(a)=tpsfin{indOR(end)};
            end
            if strcmp(DirE{a}(end-7:end),'20160719')
                t_deb_POST(a)=1.5650e+03;
            end
            t_fin(a)=tpsfin{end};
            Post_Epoch=intervalSet(t_deb_POST(a)*1E4,tpsfin{end}*1E4); % time in 10E-4 second
            h_deb_POST(a)=mod(min(Data(Restrict(NewtsdZT,Post_Epoch))/1E4)/3600,24)*3600;
            Epochs{a,8}=Post_Epoch;
            disp(h_deb_POST(a))
        catch
            disp('PROBLEM ! skip'); keyboard
        end
    end

    % <<<<<<<<<<<<<<<<<<<<<<< Get Baseline experiments <<<<<<<<<<<<<<<<<<<<
    h_debBSL=nan(length(Dir),1); t_finBSL=h_debBSL;
    for b=1:length(Dir)
        try
            disp(Dir{b});cd(Dir{b});
            nameMouseBSL{b}=Dir{b}(max(strfind(Dir{b},'Mouse'))+[0:7]);
            % -----------------------------------------------------------------
            % get substages
            clear WAKE REM N1 N2 N3 NREM Total
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise]=RunSubstages(Dir{b}); close;
            %WAKE=or(WAKE,noise); % optional !!
            NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,1);
            Total=or(or(NREM,REM),WAKE); mergeCloseIntervals(Total,1);
            EpochsBSL{b,1}=WAKE;
            EpochsBSL{b,2}=REM;
            EpochsBSL{b,3}=N1;
            EpochsBSL{b,4}=N2;
            EpochsBSL{b,5}=N3;
            EpochsBSL{b,6}=NREM;
            EpochsBSL{b,7}=Total;
            EpochsBSL{b,8}=intervalSet([],[]);
            
            % get time of the day
            NewtsdZT=GetZT_ML(Dir{b});
            h_debBSL(b)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
            load('behavResources.mat','tpsfin')
            t_finBSL(b)=tpsfin{end};
        catch
            disp('PROBLEM ! skip')
        end
    end
    
    % <<<<<<<<<<<<<<<<<<<<<<< Get ORtest experiments <<<<<<<<<<<<<<<<<<<<
    h_debORt=nan(length(DirP),1); t_finORt=h_debORt;
    for b=1:length(DirP)
        try
            disp(DirP{b});cd(DirP{b});
            nameMouseORt{b}=DirP{b}(max(strfind(DirP{b},'Mouse'))+[0:7]);
            % -----------------------------------------------------------------
            % get substages
            clear WAKE REM N1 N2 N3 NREM Total
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise]=RunSubstages(DirP{b}); close;
            %WAKE=or(WAKE,noise); % optional !!
            NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,1);
            Total=or(or(NREM,REM),WAKE); mergeCloseIntervals(Total,1);
            EpochsORt{b,1}=WAKE;
            EpochsORt{b,2}=REM;
            EpochsORt{b,3}=N1;
            EpochsORt{b,4}=N2;
            EpochsORt{b,5}=N3;
            EpochsORt{b,6}=NREM;
            EpochsORt{b,7}=Total;
            EpochsORt{b,8}=intervalSet([],[]);
            
            % get time of the day
            NewtsdZT=GetZT_ML(DirP{b});
            h_debORt(b)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
            load('behavResources.mat','tpsfin')
            t_finORt(b)=tpsfin{end};
        catch
            disp('PROBLEM ! skip')
        end
    end
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<< SAVE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    disp('saving in AnalyNREMsubstagesOR.mat')
    save([analyFolder,'/AnalyNREMsubstagesOR.mat'],'Dir','DirE','DirP','Stages',...
        'nameMouse','Epochs','h_deb','t_deb_POST','h_deb_POST','t_fin',...
        'nameMouseBSL','EpochsBSL','h_debBSL','t_finBSL',...
        'nameMouseORt','EpochsORt','h_debORt','t_finORt');
    
else
    
    disp('Loading existing AnalyNREMsubstagesOR.mat')
    load([analyFolder,'/AnalyNREMsubstagesOR.mat']);
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% combine
Ep=[Epochs;EpochsBSL;EpochsORt];
name=[nameMouse,nameMouseBSL,nameMouseORt];
deb=[h_deb;h_debBSL;h_debORt];
fin=[t_fin;t_finBSL;t_finORt];
Di=[DirE,Dir,DirP];

if ~exist('durEp_LO','var')|| ~exist('durEp_OR','var')

    MatDur=nan(length(Di),7); OR_dur=MatDur; LO_dur=MatDur;
    durEp_LO=nan(length(Di),7,12/(t_step/3600));
    durEp_OR=nan(length(Di),7,12/(t_step/3600));
    for i=1:length(Di)
        disp(Di{i})
        indMouse=find(strcmp(name{i},nameMouse));
        disp(nameMouse{indMouse})
        % ---------------------------------------------------------------------
        % postOR period
        delay_ORend=h_deb_POST(indMouse)-deb(i);
        durPost=fin(i)-delay_ORend;
        numPost=ceil(durPost/ t_step);
        OR_sta=[delay_ORend,delay_ORend+[1:numPost-1]*t_step];
        OR_sto=OR_sta+t_step;
        
        for e=1:min(length(OR_sta),12/(t_step/3600))
            s_OR=intervalSet(OR_sta(e)*1E4,OR_sto(e)*1E4);
            for n=1:7
                s_Ep=and(Ep{i,n},s_OR);
                durEp_OR(i,n,e)=sum(Stop(s_Ep,'s')-Start(s_Ep,'s'));
            end
        end
        
        % ---------------------------------------------------------------------
        % LightON period (9h-21h)
        delay_rec=(deb(i)/3600-9)*3600;
        n_nan=round(delay_rec/t_step);
        LO_sta=zeros(1,n_nan);LO_sto=zeros(1,n_nan); % empty blocks
        LO_sta=[LO_sta,max(0,n_nan*t_step-delay_rec)]; % first block start
        LO_sto=[LO_sto,min(t_step,t_step+n_nan*t_step-delay_rec)]; %first block end
        
        num_step=ceil((fin(i)-LO_sto(end))/ t_step);
        LO_sta=[LO_sta,LO_sto(end)+[0:1:num_step-1]*t_step];
        LO_sto=[LO_sto,LO_sto(end)+[1:num_step]*t_step];
        
        for e=1:min(length(LO_sta),12/(t_step/3600))
            s_LO=intervalSet(LO_sta(e)*1E4,LO_sto(e)*1E4);
            for n=1:7
                s_Ep=and(Ep{i,n},s_LO);
                durEp_LO(i,n,e)=sum(Stop(s_Ep,'s')-Start(s_Ep,'s'));
            end
        end
        
        % ---------------------------------------------------------------------
        % global duration
        
        s_OR=intervalSet(OR_sta(1)*1E4,OR_sto(end)*1E4);
        s_LO=intervalSet(LO_sta(1)*1E4,LO_sto(end)*1E4);
        for n=1:7
            epoch=Ep{i,n};
            MatDur(i,n)=sum(Stop(epoch,'s')-Start(epoch,'s'));
            OR_dur(i,n)=sum(Stop(and(s_OR,epoch),'s')-Start(and(s_OR,epoch),'s'));
            LO_dur(i,n)=sum(Stop(and(s_LO,epoch),'s')-Start(and(s_LO,epoch),'s'));
        end
            disp(sprintf([Stages{n},': OR=%1.1fh, OR_dur=%1.1fh'],sum(Stop(epoch,'s')-Start(epoch,'s'))/3600,OR_dur(i,n)/3600))
        %keyboard
    end
    % saving 
    save([analyFolder,'/AnalyNREMsubstagesOR.mat'],'-append','durEp_LO','durEp_OR','MatDur','OR_dur')
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< POOL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% align on light onset
MatA=nan(length(Di),6,12/(t_step/3600)); MatA2=MatA; 
 for i=1:length(Di)
     temp=squeeze(durEp_LO(i,:,:));
     for n=1:6
        MatA(i,n,:)=100*temp(n,:)./temp(7,:); % dur on rec tot
     end
     durSleep=sum(temp([2,6],:),1);
     for n=2:6
        MatA2(i,n,:)=100*temp(n,:)./durSleep;
     end
 end
% align on OR end
MatA3=nan(length(Di),6,12/(t_step/3600)); MatA4=MatA3;
 for i=1:length(Di)
     temp=squeeze(durEp_OR(i,:,:));
     for n=1:6
        MatA3(i,n,:)=100*temp(n,:)./temp(7,:); % dur on rec tot
     end
     durSleep=sum(temp([2,6],:),1);
     for n=2:6
        MatA4(i,n,:)=100*temp(n,:)./durSleep;
     end
 end


typ=[ones(1,length(nameMouse)),zeros(1,length(nameMouseBSL)),2+zeros(1,length(nameMouseORt))];
mice=unique(name);
mice(strcmp(mice,'Mouse395'))=[]; % problem detection delta
%mice(strcmp(mice,'Mouse393'))=[]; % problem detection delta
MatBSL1=nan(length(mice),6,12/(t_step/3600)); MatBSL2=MatBSL1; MatBSL3=MatBSL1; MatBSL4=MatBSL1;
MatORh1=nan(length(mice),6,12/(t_step/3600)); MatORh2=MatORh1; MatORh3=MatORh1; MatORh4=MatORh1; 
MatORt1=nan(length(mice),6,12/(t_step/3600)); MatORt2=MatORt1; MatORt3=MatORt1; MatORt4=MatORt1; 

for mi=1:length(mice)
    indBSL=find(strcmp(name,mice{mi}) & typ==0);
    indORh=find(strcmp(name,mice{mi}) & typ==1);
    indORt=find(strcmp(name,mice{mi}) & typ==2);
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7])
    for n=1:6
        MatBSL1(mi,n,:)=nanmean(MatA(indBSL,n,:),1);
        MatORh1(mi,n,:)=nanmean(MatA(indORh,n,:),1);
        try MatORt1(mi,n,:)=nanmean(MatA(indORt,n,:),1);end
        subplot(2,3,n), hold on,
        plot([1:12/(t_step/3600)],squeeze(MatBSL1(mi,n,:)),'Linewidth',2,'Color','k');
        plot([1:12/(t_step/3600)],squeeze(MatORh1(mi,n,:)),'Linewidth',2,'Color',colori(n,:));
        try plot([1:12/(t_step/3600)],squeeze(MatORt1(mi,n,:)),'Linewidth',2,'Color',[0.5 0.5 0.5]);end
        title(Stages{n}); xlabel('Time (h)'); ylabel('%rec time')
        if n==5, legend(Di{indBSL},Di{indORh},Di{indORt});end
        
        MatBSL2(mi,n,:)=nanmean(MatA2(indBSL,n,:),1);
        MatORh2(mi,n,:)=nanmean(MatA2(indORh,n,:),1);
        try MatORt2(mi,n,:)=nanmean(MatA2(indORt,n,:),1);end
        
        MatBSL3(mi,n,:)=nanmean(MatA3(indBSL,n,:),1);
        MatORh3(mi,n,:)=nanmean(MatA3(indORh,n,:),1);
        try MatORt3(mi,n,:)=nanmean(MatA3(indORt,n,:),1);end
        
        MatBSL4(mi,n,:)=nanmean(MatA4(indBSL,n,:),1);
        MatORh4(mi,n,:)=nanmean(MatA4(indORh,n,:),1);
        try MatORt4(mi,n,:)=nanmean(MatA4(indORt,n,:),1);end
        
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
for f=1:4
    if f==1
        MiBSL=MatBSL1; MiORh=MatORh1; MiORt=MatORt1;
        tit='(% of total recording time)';  tit2='LightOn';
    elseif f==2
        MiBSL=MatBSL2; MiORh=MatORh2; MiORt=MatORt2;
        tit='(% of total sleep)'; tit2='LightOn';
    elseif f==3
        MiBSL=MatBSL3; MiORh=MatORh3; MiORt=MatORt3;
        tit='(% of total recording time)';  tit2='h finORh';
    elseif f==4
        MiBSL=MatBSL4; MiORh=MatORh4; MiORt=MatORt4;
        tit='(% of total sleep)'; tit2='h finORh';
    end
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7]),
    for j=1:6
        subplot(2,3,j), hold on,
        MatDo=squeeze(MiBSL(:,j,:));
        MatDo2=squeeze(MiORh(:,j,:));
        MatDo3=squeeze(MiORt(:,j,:));
        
        errorbar([1:12/(t_step/3600)]*t_step/3600,nanmean(MatDo,1),stdError(MatDo),'Linewidth',2,'Color','k');
        errorbar([1:12/(t_step/3600)]*t_step/3600,nanmean(MatDo2,1),stdError(MatDo2),'Linewidth',2,'Color',colori(j,:));
        errorbar([1:12/(t_step/3600)]*t_step/3600,nanmean(MatDo3,1),stdError(MatDo3),'Linewidth',2,'Color',[0.5 0.5 0.5]);
        xlim([0 12]); ylim([0 100]);xlabel('Time (h), devided in 30min blocks')
        
        hold on, plot(0.25*[1 1],[0 100],'--','Color','k')
        title([Stages{j},sprintf(' (n=%d)',sum(~isnan(nanmean(MatDo2,2))))],'Color',colori(j,:));
        legend({'BSL','ORhab','ORtest'});
        
        % statistics
        pval1=nan(1,12/(t_step/3600)); pval2=pval1; pval3=pval1; 
        for k=1:12/(t_step/3600)
            try
                if 1
                    namtest='signrank';
                    p1=signrank(MatDo(:,k),MatDo2(:,k));
                    p2=signrank(MatDo(:,k),MatDo3(:,k));
                    p3=signrank(MatDo2(:,k),MatDo3(:,k));
                else
                    namtest='ttest';
                    [h,p1]=ttest2(MatDo(:,k),MatDo2(:,k));
                    [h,p2]=ttest2(MatDo(:,k),MatDo3(:,k));
                    [h,p3]=ttest2(MatDo2(:,k),MatDo3(:,k));
                end
                if p1<0.05, pval1(k)=60;end
                if p2<0.05, pval2(k)=55;end
                if p3<0.05, pval3(k)=50;end
                
                %pval(k)=100*p;
            end
        end
        
        plot([1:12/(t_step/3600)]*t_step/3600,pval1,'*r')
        plot([1:12/(t_step/3600)]*t_step/3600,pval2,'*','Color',[1 0.2 0.8])
        plot([1:12/(t_step/3600)]*t_step/3600,pval3,'*','Color',[1 0.5 0.2])
        if j==1
            ylabel({'Stage duration',tit});
            legend({'BSL','ORhab','ORtest',tit2,[namtest,':BSL vs ORhab'],'BSL vs ORtest','ORhab vs ORtest'}); 
        end
    end
    % save Figure
    if savFigure, keyboard;saveFigure(gcf,sprintf(['BilanEvolOR-%d-',namtest],f),saveFolder);end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< BILAN GLOBAL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

 % global duration
if 1
    Dur1=100*OR_dur(:,1:6)./(OR_dur(:,7)*ones(1,6));
    Dur2=100*OR_dur(:,1:6)./(sum(OR_dur(:,[2,6]),2)*ones(1,6));
else
    Dur1=100*MatDur(:,1:6)./(MatDur(:,7)*ones(1,6));
    Dur2=100*MatDur(:,1:6)./(sum(MatDur(:,[2,6]),2)*ones(1,6));
end

MiDurBSL1=nan(length(mice),6); MiDurORh1=MiDurBSL1; MiDurORt1=MiDurBSL1;
MiDurBSL2=nan(length(mice),6); MiDurORh2=MiDurBSL2; MiDurORt2=MiDurBSL2;
MiDurAll1=nan(length(mice),6,8);MiDurAll2=MiDurAll1;
for mi=1:length(mice)
    indBSL=find(strcmp(name,mice{mi}) & typ==0);
    indOR=find(strcmp(name,mice{mi}) & typ==1);
    indORt=find(strcmp(name,mice{mi}) & typ==2);

    for n=1:6
        MiDurBSL1(mi,n)=nanmean(Dur1(indBSL,n),1);
        if n>1, MiDurBSL2(mi,n)=nanmean(Dur2(indBSL,n),1);end
        MiDurORh1(mi,n)=nanmean(Dur1(indOR,n),1);
        if n>1, MiDurORh2(mi,n)=nanmean(Dur2(indOR,n),1);end
        MiDurORt1(mi,n)=nanmean(Dur1(indORt,n),1);
        if n>1, MiDurORt2(mi,n)=nanmean(Dur2(indORt,n),1);end
        
        for i=1:length(indBSL)
            MiDurAll1(mi,n,4-i)=Dur1(indBSL(i),n);
            MiDurAll2(mi,n,4-i)=Dur2(indBSL(i),n);
        end
        for i=1:length(indOR)
            MiDurAll1(mi,n,4+i)=Dur1(indOR(i),n);
            MiDurAll2(mi,n,4+i)=Dur2(indOR(i),n);
        end
        for i=1:length(indORt)
            MiDurAll1(mi,n,6+i)=Dur1(indORt(i),n);
            MiDurAll2(mi,n,6+i)=Dur2(indORt(i),n);
        end
    end
end

% plot
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.4])
for mi=1:length(mice)
    A=squeeze(MiDurAll1(mi,1:5,:));
    subplot(2,length(mice),mi), bar(A','stacked'), ylim([0 105]); xlim([0 8])
    set(gca,'Xtick',[2 5 7]); set(gca,'XtickLabel',{'BSL','ORh','ORt'});
    title(mice{mi}); if mi==1, ylabel('stage duration (%tot rec)');end
    A=squeeze(MiDurAll2(mi,1:5,:));A(1,:)=nan(1,size(A,2));
    subplot(2,length(mice),length(mice)+mi), bar(A','stacked'), ylim([0 105]); xlim([0 8])
    set(gca,'Xtick',[2 5 7]); set(gca,'XtickLabel',{'BSL','ORh','ORt'});
    title(mice{mi}); if mi==1, ylabel('stage duration (% sleep)');end
end
%legend(Stages(1:5),'Location','BestOutside');
colormap(colori(1:5,:))
% save Figure
if savFigure, saveFigure(gcf,'BilanGlobalORIndiv',saveFolder);end

%%
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7])
for f=1:4
    subplot(2,2,f), hold on,
    
    if f==1 || f==3
        A=MiDurBSL1;
        B=MiDurORh1;
        C=MiDurORt1;
        ylabel({'Time in substages','% total recording time'})
    else
        A=MiDurBSL2;
        B=MiDurORh2;
        C=MiDurORt2;
        ylabel({'Time in substages','% sleep'})
    end
    MiDur=nanmean(A,1);
    MiDur(2,:)=nanmean(B,1);
    MiDur(3,:)=nanmean(C,1);
    
    bar(MiDur'); ylim([0 100])
    errorbar([1:6]-0.22,nanmean(A),stdError(A),'+k');
    errorbar([1:6],nanmean(B),stdError(B),'+k');
    errorbar([1:6]+0.22,nanmean(C),stdError(C),'+k');
    set(gca,'Xtick',1:6), set(gca,'XtickLabel',[Stages,'NREM'])
    colormap([0 0 0; 0.4 0 0.3;0.5 0.5 0.5]); 
    legend({'BSL','ORh','ORt'},'Location','NorthWest')
    for i=1:6,
        try
            if f<3
                p1=signrank(A(:,i),B(:,i)); namtest='signrank';
                p2=signrank(A(:,i),C(:,i));
                p3=signrank(B(:,i),C(:,i));
            else
                [h,p1]=ttest2(A(:,i),B(:,i)); namtest='ttest';
                [h,p2]=ttest2(A(:,i),C(:,i));
                [h,p3]=ttest2(B(:,i),C(:,i));
            end
            if p1<0.05, col1='r'; else, col1='k';end
            if p2<0.05, col2='r'; else, col2='k';end
            if p3<0.05, col3='r'; else, col3='k';end
            text(i-0.2,16+max(nanmean([A(:,i),B(:,i),C(:,i)],1)),sprintf('p=%1.3f',p1),'Color',col1);
            text(i-0.2,12+max(nanmean([A(:,i),B(:,i),C(:,i)],1)),sprintf('p=%1.3f',p2),'Color',col2);
            text(i-0.2,8+max(nanmean([A(:,i),B(:,i),C(:,i)],1)),sprintf('p=%1.3f',p3),'Color',col3);
        end
    end
    title({sprintf([namtest,': BSL vs ORh (n=%d)'],sum(~isnan(nanmean(A,2)))),...
        sprintf('BSL vs ORt (n=%d)',sum(~isnan(nanmean(B,2)))),...
        sprintf('ORh vs ORt (n=%d)',sum(~isnan(nanmean(C,2))))})

end

% save Figure
if savFigure, saveFigure(gcf,['BilanGlobalOR'],saveFolder);end

%%
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.4])
subplot(2,3,1), bar(MiDurBSL1(:,1:5),'stacked'), ylim([0 102])
legend(Stages(1:5),'Location','BestOutside');title('Baseline')
ylabel('stage duration (%tot rec)'); colormap(colori(1:5,:))
subplot(2,3,2), bar(MiDurORh1(:,1:5),'stacked'), ylim([0 102])
legend(Stages(1:5),'Location','BestOutside');title('sleep post OR hab')
subplot(2,3,3), bar(MiDurORt1(:,1:5),'stacked'), ylim([0 102])
legend(Stages(1:5),'Location','BestOutside');title('sleep post OR test')

subplot(2,3,4), bar(MiDurBSL2(:,1:5),'stacked'), ylim([0 102]);title('Baseline')
legend(Stages(1:5),'Location','BestOutside')
subplot(2,3,5), bar(MiDurORh2(:,1:5),'stacked'), ylim([0 102]);title('sleep post OR hab')
legend(Stages(1:5),'Location','BestOutside'); xlabel('# Mouse')
subplot(2,3,6), bar(MiDurORt2(:,1:5),'stacked'), ylim([0 102])
legend(Stages(1:5),'Location','BestOutside');title('sleep post OR test')
ylabel('stage duration (% sleep)');





