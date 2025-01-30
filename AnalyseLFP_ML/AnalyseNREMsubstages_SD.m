% AnalyseNREMsubstages_SD.m
%
% list of related scripts in NREMstages_scripts.m

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
%analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/OLD';
analyname='AnalyNREMsubstagesSD';
%t_step=30*60; % in second
t_step=60*60; % in second
%t_step=120*60; % in second
nam={'',''};
if floor(t_step/3600)~=0, nam{1}=sprintf('%dh',floor(t_step/3600));else,nam{2}='min';end 
if rem(t_step,3600)~=0,nam{2}=[sprintf('%d',floor(rem(t_step,3600)/60)),nam{2}];end
analyname=[analyname,'_',nam{1},nam{2},'Step'];

colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 0.5];
saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/SleepDeprivation';
savFigure=0;
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% ------------ BASELINES ----------------
a=0;
    % 294
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160621'; % manque début rec
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160627';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160628';%ok
    % 330
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160621';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160627';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160628';% refait->Run
    % 393
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160704';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160711';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160718'; % pas de signaux début rec
    % 394
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160711';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160718';%ok
    % 395
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160718';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160725';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160726';% refait->Run
    % 400
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
%a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160725';
a=a+1; Dir{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160726';%ok
    % 402
a=a+1; Dir{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160830';
    % 403
a=a+1; Dir{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160830';

% ------------ SD BEHAVIOR EXPERIMENT ----------------
a=0;
% SD
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160629';% refait->Run
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160629';% ->Run
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160719';% refait->Run
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160719';% refait->Run
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160727';% refait
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160727';% refait
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160831';
a=a+1; DirE{a}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160831';

% ------------ SD+24h BEHAVIOR EXPERIMENT ----------------
a=0;
% SD+24h
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160630';%ok
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160630';%ok
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160720';% refait->Run
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160720';% refait->Run
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160728';%ok
a=a+1; DirP{a}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160728';%ok
a=a+1; DirP{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160901';
a=a+1; DirP{a}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160901';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< LOAD DATA IF EXIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
DoAnalysis=0;
try
    clear Epochs;
    temp=load([analyFolder,'/',analyname,'.mat'],'Epochs','DirE','Dir');
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
            % End time of Object Recognition (OR) or sleep deprivation (SD)
            clear evt tpsfin tpsdeb
            load('behavResources.mat','evt','tpsfin','tpsdeb');
            disp(evt);
            indSD=[];
            for e=1:length(evt)/2
                if ~isempty(strfind(evt{e},'SD')) && isempty(strfind(evt{e},'Post'))
                    indSD=[indSD,e];
                end
            end
            
            % -------------------------------------------------------------
            % Sleep Deprivation (SD)
            t_deb=0;
            if ~isempty(indSD)
                t_deb_POST(a)=tpsfin{indSD(end)};
            end
            if strcmp(DirE{a}(end-7:end),'20160719')
                t_deb_POST(a)=20516;
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
    
    % <<<<<<<<<<<<<<<<<<<<<<< Get SD+24h experiments <<<<<<<<<<<<<<<<<<<<
    h_debPSD=nan(length(Dir),1); t_finPSD=h_debPSD;
    for b=1:length(DirP)
        try
            disp(DirP{b});cd(DirP{b});
            nameMousePSD{b}=DirP{b}(max(strfind(DirP{b},'Mouse'))+[0:7]);
            % -----------------------------------------------------------------
            % get substages
            clear WAKE REM N1 N2 N3 NREM Total
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise]=RunSubstages(DirP{b}); close;
            %WAKE=or(WAKE,noise); % optional !!
            NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,1);
            Total=or(or(NREM,REM),WAKE); mergeCloseIntervals(Total,1);
            EpochsPSD{b,1}=WAKE;
            EpochsPSD{b,2}=REM;
            EpochsPSD{b,3}=N1;
            EpochsPSD{b,4}=N2;
            EpochsPSD{b,5}=N3;
            EpochsPSD{b,6}=NREM;
            EpochsPSD{b,7}=Total;
            EpochsPSD{b,8}=intervalSet([],[]);
            
            % get time of the day
            NewtsdZT=GetZT_ML(DirP{b});
            h_debPSD(b)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
            load('behavResources.mat','tpsfin')
            t_finPSD(b)=tpsfin{end};
        catch
            disp('PROBLEM ! skip')
        end
    end
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<< SAVE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    disp(['saving in ',analyname,'.mat'])
    save([analyFolder,'/',analyname,'.mat'],'Dir','DirE','DirP','t_step','Stages',...
        'nameMouse','Epochs','h_deb','t_deb_POST','h_deb_POST','t_fin',...
        'nameMouseBSL','EpochsBSL','h_debBSL','t_finBSL',...
        'nameMousePSD','EpochsPSD','h_debPSD','t_finPSD');
    
else
    
    disp(['Loading existing ',analyname,'.mat'])
    load([analyFolder,'/',analyname,'.mat']);
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% combine
Ep=[Epochs;EpochsBSL;EpochsPSD];
name=[nameMouse,nameMouseBSL,nameMousePSD];
deb=[h_deb;h_debBSL;h_debPSD];
fin=[t_fin;t_finBSL;t_finPSD];
Di=[DirE,Dir,DirP];

if ~exist('durEp_LO','var')|| ~exist('durEp_SD','var')
    
    MatDur=nan(length(Di),7); SD_dur=MatDur; LO_dur=MatDur;
    SD1h_dur=nan(length(Di),7); LO1h_dur=SD1h_dur;
    durEp_LO=nan(length(Di),7,12/(t_step/3600));
    durEp_SD=nan(length(Di),7,12/(t_step/3600));
    for i=1:length(Di)
        disp(Di{i})
        indMouse=find(strcmp(name{i},nameMouse));
        
        % ---------------------------------------------------------------------
        % postSD period
        delay_SDend=h_deb_POST(indMouse)-deb(i);
        durPost=fin(i)-delay_SDend;
        numPost=ceil(durPost/ t_step);
        SD_sta=[delay_SDend,delay_SDend+[1:numPost-1]*t_step];
        SD_sto=SD_sta+t_step;
        
        for e=1:min(length(SD_sta),12)
            s_SD=intervalSet(SD_sta(e)*1E4,SD_sto(e)*1E4);
            for n=1:7
                s_Ep=and(Ep{i,n},s_SD);
                durEp_SD(i,n,e)=sum(Stop(s_Ep,'s')-Start(s_Ep,'s'));
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
        
        s_SD=intervalSet(SD_sta(1)*1E4,SD_sto(end)*1E4);
        s_LO=intervalSet(LO_sta(1)*1E4,LO_sto(end)*1E4);
        for n=1:7
            epoch=Ep{i,n};
            MatDur(i,n)=sum(Stop(epoch,'s')-Start(epoch,'s'));
            SD_dur(i,n)=sum(Stop(and(s_SD,epoch),'s')-Start(and(s_SD,epoch),'s'));
            LO_dur(i,n)=sum(Stop(and(s_LO,epoch),'s')-Start(and(s_LO,epoch),'s'));
        end
            disp(sprintf([Stages{n},': SD=%1.1fh, SD_dur=%1.1fh'],sum(Stop(epoch,'s')-Start(epoch,'s'))/3600,SD_dur(i,n)/3600))
        %keyboard
        
        
        % ---------------------------------------------------------------------
        % first 1hr sleep at SD end time
        sleep_SD=and(s_SD,or(Ep{i,6},Ep{i,2}));mergeCloseIntervals(sleep_SD,1);
        cs=cumsum(Stop(sleep_SD,'s')-Start(sleep_SD,'s'));
        ind_sleep=min(find(cs>3600));
        s_1hSD=intervalSet(Start(subset(sleep_SD,1)),Stop(subset(sleep_SD,ind_sleep)));
        disp(sprintf('it took %1.2fh to get 1hr cumulated sleep begining after SDend',...
            (max(Stop(s_1hSD,'s'))-min(Start(s_1hSD,'s')))/3600));
        
        % first 1hr sleep at SD end time versus 9a.m.
        if i>length(DirE)
            sleep_LO=and(s_LO,or(Ep{i,6},Ep{i,2}));mergeCloseIntervals(sleep_LO,1);
            cs=cumsum(Stop(sleep_LO,'s')-Start(sleep_LO,'s'));
            ind_sleep=min(find(cs>3600));
            s_1hLO=intervalSet(Start(subset(sleep_LO,1)),Stop(subset(sleep_LO,ind_sleep)));
            disp(sprintf('it took %1.2fh to get 1hr cumulated sleep begining at 9a.m.',...
            (max(Stop(s_1hLO,'s'))-min(Start(s_1hLO,'s')))/3600));
        else
            s_1hLO=intervalSet([],[]);
        end
        
        
        for n=1:7
            epoch=Ep{i,n};
            SD1h_dur(i,n)=sum(Stop(and(s_1hSD,epoch),'s')-Start(and(s_1hSD,epoch),'s'));
            LO1h_dur(i,n)=sum(Stop(and(s_1hLO,epoch),'s')-Start(and(s_1hLO,epoch),'s'));
        end
        
        % ---------------------------------------------------------------------
        
    end
    % saving 
    save([analyFolder,'/',analyname,'.mat'],'-append','durEp_LO','durEp_SD','MatDur','SD_dur',...
        'LO_dur','SD1h_dur','LO1h_dur')
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
% align on SD end
MatA3=nan(length(Di),6,12/(t_step/3600)); MatA4=MatA3;
 for i=1:length(Di)
     temp=squeeze(durEp_SD(i,:,:));
     for n=1:6
        MatA3(i,n,:)=100*temp(n,:)./temp(7,:); % dur on rec tot
     end
     durSleep=sum(temp([2,6],:),1);
     for n=2:6
        MatA4(i,n,:)=100*temp(n,:)./durSleep;
     end
 end


typ=[ones(1,length(nameMouse)),zeros(1,length(nameMouseBSL)),2+zeros(1,length(nameMousePSD))];
mice=unique(name);
mice(strcmp(mice,'Mouse395'))=[]; % problem detection delta
mice(strcmp(mice,'Mouse393'))=[]; % problem detection delta

MatBSL1=nan(length(mice),6,12/(t_step/3600)); MatBSL2=MatBSL1; MatBSL3=MatBSL1; MatBSL4=MatBSL1;
MatSD1=nan(length(mice),6,12/(t_step/3600)); MatSD2=MatSD1; MatSD3=MatSD1; MatSD4=MatSD1; 
MatPsd1=nan(length(mice),6,12/(t_step/3600)); MatPsd2=MatPsd1; MatPsd3=MatPsd1; MatPsd4=MatPsd1; 
durEp_SDnorm=nan(length(mice),7,12/(t_step/3600));durEp_Psdnorm=durEp_SDnorm;

for mi=1:length(mice)
    indBSL=find(strcmp(name,mice{mi}) & typ==0);
    indSD=find(strcmp(name,mice{mi}) & typ==1);
    indPsd=find(strcmp(name,mice{mi}) & typ==2);
        
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7])
    for n=1:6
        MatBSL1(mi,n,:)=nanmean(MatA(indBSL,n,:),1);
        MatSD1(mi,n,:)=nanmean(MatA(indSD,n,:),1);
        try MatPsd1(mi,n,:)=nanmean(MatA(indPsd,n,:),1);end
        subplot(2,3,n), hold on,
        plot([1:12/(t_step/3600)],squeeze(MatBSL1(mi,n,:)),'Linewidth',2,'Color','k');
        plot([1:12/(t_step/3600)],squeeze(MatSD1(mi,n,:)),'Linewidth',2,'Color',colori(n,:));
        try plot([1:12/(t_step/3600)],squeeze(MatPsd1(mi,n,:)),'Linewidth',2,'Color',[0.5 0.5 0.5]);end
        title(Stages{n}); xlabel('Time (h)'); ylabel('%rec time')
        if n==5, legend(Di{indBSL},Di{indSD},Di{indPsd});end
        
        MatBSL2(mi,n,:)=nanmean(MatA2(indBSL,n,:),1);
        MatSD2(mi,n,:)=nanmean(MatA2(indSD,n,:),1);
        try MatPsd2(mi,n,:)=nanmean(MatA2(indPsd,n,:),1);end
        
        MatBSL3(mi,n,:)=nanmean(MatA3(indBSL,n,:),1);
        MatSD3(mi,n,:)=nanmean(MatA3(indSD,n,:),1);
        try MatPsd3(mi,n,:)=nanmean(MatA3(indPsd,n,:),1);end
        
        MatBSL4(mi,n,:)=nanmean(MatA4(indBSL,n,:),1);
        MatSD4(mi,n,:)=nanmean(MatA4(indSD,n,:),1);
        try MatPsd4(mi,n,:)=nanmean(MatA4(indPsd,n,:),1);end
        
    end
    
    tempBSL=squeeze(durEp_SD(indBSL(1),:,:));
    tempSD=squeeze(durEp_SD(indSD(1),:,:));
    tempPsd=squeeze(durEp_SD(indPsd(1),:,:));
    durEp_SDnorm(mi,:,:)=log10(tempSD./tempBSL);
    durEp_Psdnorm(mi,:,:)=log10(tempPsd./tempBSL);
    
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7]),
    for j=1:6
        subplot(2,3,j), hold on,
        M1=squeeze(durEp_SDnorm(:,j,:));
        M2=squeeze(durEp_Psdnorm(:,j,:));
        errorbar([1:12/(t_step/3600)]*t_step/3600,nanmean(M1,1),stdError(M1),'Linewidth',2,'Color',colori(j,:));
        errorbar([1:12/(t_step/3600)]*t_step/3600,nanmean(M2,1),stdError(M2),'Linewidth',2,'Color','k');
    end
    %%
for f=2%1:4
    if f==1
        MiBSL=MatBSL1; MiSD=MatSD1; MiPsd=MatPsd1;
        tit='(% of total recording time)';  tit2='LightOn';
    elseif f==2
        MiBSL=MatBSL2; MiSD=MatSD2; MiPsd=MatPsd2;
        tit='(% of total sleep)'; tit2='LightOn';
    elseif f==3
        MiBSL=MatBSL3; MiSD=MatSD3; MiPsd=MatPsd3;
        tit='(% of total recording time)';  tit2='h finSD';
    elseif f==4
        MiBSL=MatBSL4; MiSD=MatSD4; MiPsd=MatPsd4;
        tit='(% of total sleep)'; tit2='h finSD';
    end
    
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7]),
    %figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.65 0.7]),
    for j=1:6
        subplot(2,3,j), hold on,
        MatDo=squeeze(MiBSL(:,j,:));
        MatDo2=squeeze(MiSD(:,j,:)); if f==2, MatDo2(:,1:6/(t_step/3600))=nan(size(MatDo2,1),6/(t_step/3600));end
        MatDo3=squeeze(MiPsd(:,j,:));
        
        errorbar([1:12/(t_step/3600)],nanmean(MatDo,1),stdError(MatDo),'Linewidth',2,'Color','k');
        errorbar([1:12/(t_step/3600)],nanmean(MatDo2,1),stdError(MatDo2),'Linewidth',2,'Color',colori(j,:));
        %errorbar([1:12/(t_step/3600)],nanmean(MatDo3,1),stdError(MatDo3),'Linewidth',2,'Color',[0.5 0.5 0.5]);
        xlim([0 12/(1+floor(f/3))+0.5]);ylim([0 100]);xlabel('Time (h)')%, devided in 30min blocks')
       
        hold on, plot(0.25*[1 1],[0 100],'--','Color','k')
        title([Stages{j},sprintf(' (n=%d)',sum(~isnan(nanmean(MatDo2,2))))],'Color',colori(j,:));
        %legend({'BSL','SD','SD+24h'});
        legend({'BSL','SD'});
        xl1=0; xl2=100; if ismember(j,[2,3,5]); xl2=40;  elseif j==4;xl1=38; xl2=78;end
        ylim([xl1 xl2]);
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
                if p1<0.05, pval1(k)=40;end
                if p2<0.05, pval2(k)=35;end
                if p3<0.05, pval3(k)=30;end
                
                %pval(k)=100*p;
            end
        end
        
        plot([1:12/(t_step/3600)],pval1,'*r')
        %plot([1:12/(t_step/3600)],pval2,'*','Color',[1 0.2 0.8])
        %plot([1:12/(t_step/3600)],pval3,'*r','Color',[1 0.5 0.2])
        if j==1
            ylabel({'Stage duration',tit});
            %legend({'BSL','SD','SD+24h',tit2,[namtest,':BSL vs SD'],'BSL vs SD+24h','SD vs SD+24h'}); 
            legend({'BSL','SD',tit2,[namtest,':BSL vs SD']}); 
        end
    end
    % save Figure
    if savFigure, keyboard;saveFigure(gcf,sprintf(['BilanEvolSD-%d-',namtest],f),saveFolder);end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< BILAN GLOBAL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

 % global duration
if 1
    Dur1=100*SD_dur(:,1:6)./(SD_dur(:,7)*ones(1,6));
    Dur2=100*SD_dur(:,1:6)./(sum(SD_dur(:,[2,6]),2)*ones(1,6));
    Dur3=100*SD1h_dur(:,1:6)./(sum(SD1h_dur(:,[2,6]),2)*ones(1,6));
    Dur4=100*LO1h_dur(:,1:6)./(sum(LO1h_dur(:,[2,6]),2)*ones(1,6));
else
    Dur1=100*MatDur(:,1:6)./(MatDur(:,7)*ones(1,6));
    Dur2=100*MatDur(:,1:6)./(sum(MatDur(:,[2,6]),2)*ones(1,6));
end

MiDurBSL1=nan(length(mice),6); MiDurSD1=MiDurBSL1; MiDurPsd1=MiDurBSL1;
MiDurBSL2=nan(length(mice),6); MiDurSD2=MiDurBSL2; MiDurPsd2=MiDurBSL2;
MiDurAll1=nan(length(mice),6,8);MiDurAll2=MiDurAll1;
MiDur1h=nan(length(mice),6,7);
for mi=1:length(mice)
    indBSL=find(strcmp(name,mice{mi}) & typ==0);
    indSD=find(strcmp(name,mice{mi}) & typ==1);
    indPsd=find(strcmp(name,mice{mi}) & typ==2);

    for n=1:6
        MiDurBSL1(mi,n)=nanmean(Dur1(indBSL,n),1);
        if n>1, MiDurBSL2(mi,n)=nanmean(Dur2(indBSL,n),1);end
        MiDurSD1(mi,n)=nanmean(Dur1(indSD,n),1);
        if n>1, MiDurSD2(mi,n)=nanmean(Dur2(indSD,n),1);end
        MiDurPsd1(mi,n)=nanmean(Dur1(indPsd,n),1);
        if n>1, MiDurPsd2(mi,n)=nanmean(Dur2(indPsd,n),1);end
        
        MiDur1h(mi,n,1)=nanmean(Dur3(indBSL,n),1);
        MiDur1h(mi,n,2)=nanmean(Dur3(indSD,n),1);
        MiDur1h(mi,n,3)=nanmean(Dur3(indPsd,n),1);
        MiDur1h(mi,n,4)=nan;
        MiDur1h(mi,n,5)=nanmean(Dur4(indBSL,n),1);
        MiDur1h(mi,n,6)=nanmean(Dur3(indSD,n),1);
        MiDur1h(mi,n,7)=nanmean(Dur4(indPsd,n),1);
        
        
        for i=1:length(indBSL)
            MiDurAll1(mi,n,4-i)=Dur1(indBSL(i),n);
            MiDurAll2(mi,n,4-i)=Dur2(indBSL(i),n);
        end
        for i=1:length(indSD)
            MiDurAll1(mi,n,4+i)=Dur1(indSD(i),n);
            MiDurAll2(mi,n,4+i)=Dur2(indSD(i),n);
        end
        for i=1:length(indPsd)
            MiDurAll1(mi,n,6+i)=Dur1(indPsd(i),n);
            MiDurAll2(mi,n,6+i)=Dur2(indPsd(i),n);
        end
    end
end

% plot
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.4])
for mi=1:length(mice)
    A=squeeze(MiDurAll1(mi,1:5,:));
    subplot(2,length(mice),mi), bar(A','stacked'), ylim([0 105]); xlim([0 8])
    set(gca,'Xtick',[2 5 7]); set(gca,'XtickLabel',{'BSL','SD','+24h'});
    title(mice{mi}); if mi==1, ylabel('stage duration (%tot rec)');end
    A=squeeze(MiDurAll2(mi,1:5,:));A(1,:)=nan(1,size(A,2));
    subplot(2,length(mice),length(mice)+mi), bar(A','stacked'), ylim([0 105]); xlim([0 8])
    set(gca,'Xtick',[2 5 7]); set(gca,'XtickLabel',{'BSL','SD','+24h'});
    title(mice{mi}); if mi==1, ylabel('stage duration (% sleep)');end
end
%legend(Stages(1:5),'Location','BestOutside');
colormap(colori(1:5,:))
% save Figure
if savFigure, saveFigure(gcf,'BilanGlobalSDIndiv',saveFolder);end

%%
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7])
for f=1:4
    subplot(2,2,f), hold on,
    if f<3
        A=MiDurBSL1;
        B=MiDurSD1;
        C=MiDurPsd1;
        ylabel('stage duration (%tot rec)');
    else
        A=MiDurBSL2;
        B=MiDurSD2;
        C=MiDurPsd2;
        ylabel('stage duration (% sleep)');
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
    legend({'BSL','SD','+24h'},'Location','NorthWest')
    for i=1:6,
        try
            if f==1 || f==3
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
    title({['after SD (15h-21h) ',namtest,':'],sprintf('BSL vs SD (n=%d)',sum(~isnan(nanmean(A,2)))),...
        sprintf('BSL vs +24h (n=%d)',sum(~isnan(nanmean(B,2)))),...
        sprintf('SD vs +24h (n=%d)',sum(~isnan(nanmean(C,2))))})
end

% save Figure
if savFigure, saveFigure(gcf,['BilanGlobalSD-',namtest],saveFolder);end

%%
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7])
MiDur=nan(6,7); StdDur=MiDur; p=nan(6,6);
for n=1:6,
    temp=squeeze(MiDur1h(:,n,:));
    MiDur(n,:)=nanmean(temp,1);
    StdDur(n,:)=stdError(temp);
    try
        namtest='signrank';
        p(n,1)=signrank(temp(:,1),temp(:,2)); % BSL vs SD
        p(n,2)=signrank(temp(:,1),temp(:,3)); % BSL vs +24
        p(n,3)=signrank(temp(:,2),temp(:,3)); % SD vs +24
        
        p(n,4)=signrank(temp(:,5),temp(:,6)); % BSL vs SD -LO
        p(n,5)=signrank(temp(:,5),temp(:,7)); % BSL vs +24 -LO
        p(n,6)=signrank(temp(:,6),temp(:,7)); % SD vs +24 -LO
    end
end
bar(MiDur); ylim([0 100]); hold on,
legend('BSL tSD','SD tSD','+24h tSD',' ','BSL tLO','SD tSD','+24h tLO','Location','NorthWest')
for i=1:7
    errorbar([1:6]-0.46+0.115*i,MiDur(:,i),StdDur(:,i),'+k');
end
set(gca,'Xtick',1:6), set(gca,'XtickLabel',[Stages,'NREM'])
colormap([0 0 0;0.4 0 0.3;0.5 0.5 0.5;1 1 1;0 0 0;0.4 0 0.3 ;0.5 0.5 0.5]);
for n=1:6,
    for pp=1:6
        if p(n,pp)<0.05, col='r'; else, col='k';end
        if pp>3 
            text(n+0.1,20+max(MiDur(n,:))-(pp-3)*4,sprintf('p=%1.3f',p(n,pp)),'Color',col);
        else
            text(n-0.4,20+max(MiDur(n,:))-pp*4,sprintf('p=%1.3f',p(n,pp)),'Color',col);
        end
    end
end
title({'1hr cumulated sleep tSD = from 15h (end SD), tLO= from 9h (Light ON)',...
    sprintf([namtest,': BSL vs SD (n=%d)'],sum(~isnan(nanmean(temp(:,1:2),2)))),...
    sprintf('BSL vs +24h (n=%d)',sum(~isnan(nanmean(temp(:,[1,3]),2)))),...
    sprintf('SD vs +24h (n=%d)',sum(~isnan(nanmean(temp(:,2:3),2))))})

% save Figure
if savFigure, saveFigure(gcf,['BilanGlobalSD1hr'],saveFolder);end

%%
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.4])
subplot(2,3,1), bar(MiDurBSL1(:,1:5),'stacked'), ylim([0 102])
legend(Stages(1:5),'Location','BestOutside');title('Baseline')
ylabel('stage duration (%tot rec)'); colormap(colori(1:5,:))
subplot(2,3,2), bar(MiDurSD1(:,1:5),'stacked'), ylim([0 102])
legend(Stages(1:5),'Location','BestOutside');title('Sleep Deprivation')
subplot(2,3,3), bar(MiDurPsd1(:,1:5),'stacked'), ylim([0 102])
legend(Stages(1:5),'Location','BestOutside');title('SD + 24h')

subplot(2,3,4), bar(MiDurBSL2(:,1:5),'stacked'), ylim([0 102]);title('Baseline')
legend(Stages(1:5),'Location','BestOutside')
subplot(2,3,5), bar(MiDurSD2(:,1:5),'stacked'), ylim([0 102]);title('Sleep Deprivation')
legend(Stages(1:5),'Location','BestOutside'); xlabel('# Mouse')
subplot(2,3,6), bar(MiDurPsd2(:,1:5),'stacked'), ylim([0 102])
legend(Stages(1:5),'Location','BestOutside');title('SD + 24h')
ylabel('stage duration (% sleep)');