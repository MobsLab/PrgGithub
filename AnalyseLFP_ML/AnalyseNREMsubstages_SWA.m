% AnalyseNREMsubstages_SWA.m

% list of related scripts in NREMstages_scripts.m



%% <<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<
%analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/OLD';
analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
%nameStructure='Bulb_deep';
%nameStructure='PFCx_deep';
nameStructure='PFCx_EcoG';
%nameStructure='PFCx_sup';
f_swa=[2 4]; %Hz
t_step=60*60; % in second

expetyp='SD'; saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/SleepDeprivation';
%expetyp='OR'; saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/ObjectRecognition';

savFigure=0;

[params,movingwin,suffix]=SpectrumParametersML('low');
FileToSave=['SpectrumData',suffix];

%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES <<<<<<<<<<<<<<<<<<<< 
if strcmp(expetyp,'SD');
    % ------------ SD BEHAVIOR EXPERIMENT ----------------
    load([analyFolder,'/AnalyNREMsubstagesSD.mat'],'DirE','DirP','Dir');
elseif strcmp(expetyp,'OR');
    % ------------ OR BEHAVIOR EXPERIMENT ----------------
    load([analyFolder,'/AnalyNREMsubstagesOR.mat'],'DirE','DirP','Dir');
end

Analyname=['AnalyNREMsubstages',expetyp,'_swa',nameStructure,'.mat'];

%% <<<<<<<<<<<<<<<<<<<<< Get ZT and SD experiments <<<<<<<<<<<<<<<<<<<<
try
    clear deb fin
    load([analyFolder,'/',Analyname])
    deb; fin;
    disp([Analyname,' has been loaded...'])
    
catch
    nameMouse={};
    deb=nan(length(DirE),1); t_deb_POST=deb;
    h_deb_POST=deb; fin=deb;
    for a=1:length(DirE)
        try
            disp(DirE{a});cd(DirE{a});
            nameMouse{a}=DirE{a}(max(strfind(DirE{a},'Mouse'))+[0:7]);
            
            % get time of the day
            NewtsdZT=GetZT_ML(DirE{a});
            deb(a)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
            
            % -------------------------------------------------------------
            % End time of Object Recognition (OR) or sleep deprivation (SD)
            clear evt tpsfin tpsdeb
            load('behavResources.mat','evt','tpsfin','tpsdeb');
            disp(evt)
            indSD=[];t_deb=0;
            for e=1:length(evt)/2
                if ~isempty(strfind(evt{e},'SD')) && isempty(strfind(evt{e},'Post')) && strcmp(expetyp,'SD')
                    indSD=[indSD,e];
                    t_deb_POST(a)=tpsfin{indSD(end)};
                end
                if ~isempty(strfind(evt{e},'OR')) && isempty(strfind(evt{e},'Post')) && strcmp(expetyp,'OR')
                    indSD=[indSD,e];
                    t_deb_POST(a)=tpsfin{indSD(end)};
                end
            end
            if strcmp(DirE{a}(end-7:end),'20160719') && strcmp(expetyp,'SD');
                t_deb_POST(a)=20516;
            end
            if strcmp(DirE{a}(end-7:end),'20160719') && strcmp(expetyp,'OR');
                t_deb_POST(a)=tpsfin{2};
            end
            fin(a)=tpsfin{end};
            Post_Epoch=intervalSet(t_deb_POST(a)*1E4,tpsfin{end}*1E4); % time in 10E-4 second
            h_deb_POST(a)=mod(min(Data(Restrict(NewtsdZT,Post_Epoch))/1E4)/3600,24)*3600;
            disp(sprintf([nameMouse{a},'  ',expetyp,' : Deb time = %1.1fh, Post time = %1.1fh'],deb(a)/3600,h_deb_POST(a)/3600));
        end
    end
    for b=1:length(Dir)
        disp(Dir{b});cd(Dir{b});
        nameMouse{a+b}=Dir{b}(max(strfind(Dir{b},'Mouse'))+[0:7]);
        % get time of the day
        NewtsdZT=GetZT_ML(Dir{b});
        deb(a+b)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
        clear tpsfin; load('behavResources.mat','tpsfin')
        fin(a+b)=tpsfin{end};
        disp(sprintf([nameMouse{a+b},'  BSL : Deb time = %1.1fh, Fin time = %1.1fh'],deb(a+b)/3600,fin(a+b)/3600));
    end
    for c=1:length(DirP)
        disp(DirP{c});cd(DirP{c});
        nameMouse{a+b+c}=DirP{c}(max(strfind(DirP{c},'Mouse'))+[0:7]);
        % get time of the day
        NewtsdZT=GetZT_ML(DirP{c});
        deb(a+b+c)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
        clear tpsfin; load('behavResources.mat','tpsfin')
        fin(a+b+c)=tpsfin{end};
        disp(sprintf([nameMouse{a+b+c},'  ',expetyp,'+24h : Deb time = %1.1fh, Fin time = %1.1fh'],...
            deb(a+b+c)/3600,fin(a+b+c)/3600));
    end
    
    % save
    disp(['saving in ',Analyname,'...'])
    save([analyFolder,'/',Analyname],'Dir','DirE','DirP','nameMouse','deb','fin','h_deb_POST','t_deb_POST')
end

Di=[DirE,Dir,DirP];
typ=[ones(1,length(DirE)),zeros(1,length(Dir)),2+zeros(1,length(DirP))];
mice=unique(nameMouse);


%% <<<<<<<<<<<<<<<<<<<<< Get Spectrum and average <<<<<<<<<<<<<<<<<<<<
try
    Dur_SD;MSpec;
catch
    
    disp(' '); disp(['Loading ',nameStructure,' Spectrograms'])
    Dur_SD=nan(length(Di),24); SWA_SD=Dur_SD; Delt_SD=Dur_SD; 
    Dur_LO=Dur_SD; SWA_LO=Dur_SD; Delt_LO=Dur_SD;
    MSpec=nan(length(Di),261); MSpec_SD=MSpec; MSpec_LO=MSpec;
    MSpec_SD1h=MSpec; MSpec_LO1h=MSpec; SWA_1h=nan(length(Di),2);
    Delt=nan(length(Di),3);
    
    for man=1:length(Di)
        
        cd(Di{man}); disp(' ');disp(Di{man})
        % -------------- Get channel for nameStructure ------------------
        clear LFP channel LFP_temp Sp t f
        % load channel
        if strcmp(nameStructure,'PFCx_EcoG')
            load('LFPData/InfoLFP.mat');
            channel=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx') & InfoLFP.depth==0);
        else
            load(['ChannelsToAnalyse/',nameStructure,'.mat'])
        end
        
        % -------------- ComputeSpectrogram_newML.m ------------------
        if ~isempty(channel)
            try
                load([FileToSave,'/Spectrum',num2str(channel)],'t','f','Sp');
                fsamp=f; disp([nameStructure,' = LFP',num2str(channel),'. Spectum loaded.'])
            catch
                disp([nameStructure,' = LFP',num2str(channel),'. Computing spectrum...'])
                load(['LFPData/LFP',num2str(channel)],'LFP');
                % calculate Sp for given LFP
                LFP_temp=ResampleTSD(LFP,params.Fs);
                [Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);
                Spi=Sp; ti=t; freqfi=f;
                if ~exist(FileToSave,'dir'); mkdir(FileToSave);end
                save([FileToSave,'/Spectrum',num2str(channel)],'-v7.3','Sp','t','f','params','movingwin');
            end
            
            
            % -------------- load NREM epochs --------------
            clear SWSEpoch SWS
            load('StateEpoch.mat','REMEpoch','SWSEpoch','TotalNoiseEpoch')
            SWS=SWSEpoch-TotalNoiseEpoch; SWS=mergeCloseIntervals(SWS,10);
            sleep=or(SWSEpoch,REMEpoch); sleep=mergeCloseIntervals(sleep,10);
            
            % -------------- Load Delta ------------------
            Dpfc=GetDeltaML; Dpfc=ts(Dpfc);
            Delt(man,1)=length(Data(Restrict(Dpfc,SWS)))/sum(Stop(SWS,'s')-Start(SWS,'s'));
            
            % SWA spectrum
            Sptsd=tsd(t*1E4,mean(Sp(:,f>=f_swa(1) & f<f_swa(2)),2));
            Sptemp=tsd(t*1E4,Sp);
            MSpec(man,:)=nanmean(Data(Restrict(Sptemp,SWS)),1);
            
            
            % -------------------- postSD period ------------------------
            indMouse=find(strcmp(nameMouse{man},nameMouse(1:length(DirE))));
            delay_SDend=h_deb_POST(indMouse)-deb(man);
            durPost=fin(man)-delay_SDend;
            numPost=ceil(durPost/ t_step);
            SD_sta=[delay_SDend,delay_SDend+[1:numPost-1]*t_step];
            SD_sto=SD_sta+t_step;
            for e=1:min(length(SD_sta),12)
                s_SD=intervalSet(SD_sta(e)*1E4,SD_sto(e)*1E4);
                Ep=and(s_SD,SWS);
                try
                    Dur_SD(man,e)=100*sum(Stop(Ep,'s')-Start(Ep,'s'))/(SD_sto(e)-SD_sta(e));
                    if sum(Stop(Ep,'s')-Start(Ep,'s'))>5*60 % >5min sleep
                        SWA_SD(man,e)=nanmean(Data(Restrict(Sptsd,Ep)));
                        Delt_SD(man,e)=length(Data(Restrict(Dpfc,Ep)))/(SD_sto(e)-SD_sta(e));
                    end
                end
            end
            s_SD=intervalSet(1E4*min(SD_sta),1E4*(min(SD_sta)+2*3600));
            Ep=and(s_SD,SWS);
            MSpec_SD(man,:)=nanmean(Data(Restrict(Sptemp,Ep)),1);
            Delt(man,2)=length(Data(Restrict(Dpfc,Ep)))/sum(Stop(Ep,'s')-Start(Ep,'s'));
            
            % --------------------- LightON period (9h-21h) -----------------------
            delay_rec=(deb(man)/3600-9)*3600;
            n_nan=round(delay_rec/t_step);
            LO_sta=zeros(1,n_nan);LO_sto=zeros(1,n_nan); % empty blocks
            LO_sta=[LO_sta,max(0,n_nan*t_step-delay_rec)]; % first block start
            LO_sto=[LO_sto,min(t_step,t_step+n_nan*t_step-delay_rec)]; %first block end
            
            num_step=ceil((fin(man)-LO_sto(end))/ t_step);
            LO_sta=[LO_sta,LO_sto(end)+[0:1:num_step-1]*t_step];
            LO_sto=[LO_sto,LO_sto(end)+[1:num_step]*t_step];
            
            for e=1:min(length(LO_sta),12)
                s_LO=intervalSet(LO_sta(e)*1E4,LO_sto(e)*1E4);
                Ep=and(s_LO,SWS);
                try
                    Dur_LO(man,e)=100*sum(Stop(Ep,'s')-Start(Ep,'s'))/(LO_sto(e)-LO_sta(e));
                    if sum(Stop(Ep,'s')-Start(Ep,'s'))>5*60 % >5min sleep
                        SWA_LO(man,e)=nanmean(Data(Restrict(Sptsd,Ep)));
                        Delt_LO(man,e)=length(Data(Restrict(Dpfc,Ep)))/(LO_sto(e)-LO_sta(e));
                    end
                end
            end
            if strcmp(expetyp,'SD')
                s_LO=intervalSet(1E4*LO_sta(7),1E4*(LO_sta(7)+2*3600));
            else
                s_LO=intervalSet(1E4*LO_sta(1),1E4*(LO_sta(1)+2*3600));
            end
            Ep=and(s_LO,SWS);
            MSpec_LO(man,:)=nanmean(Data(Restrict(Sptemp,Ep)),1);
            Delt(man,3)=length(Data(Restrict(Dpfc,Ep)))/sum(Stop(Ep,'s')-Start(Ep,'s'));
            
            
            % ---------------------------------------------------------------------
            % first 1hr sleep at SD end time
            s_SD=intervalSet(1E4*min(SD_sta),1E4*(min(SD_sta)+6*3600));
            sleep_SD=and(s_SD,sleep);mergeCloseIntervals(sleep_SD,1);
            cs=cumsum(Stop(sleep_SD,'s')-Start(sleep_SD,'s'));
            ind_sleep=min(find(cs>3600));
            s_1hSD=intervalSet(Start(subset(sleep_SD,1)),Stop(subset(sleep_SD,ind_sleep)));
            disp(sprintf('it took %1.2fh to get 1hr cumulated sleep begining after SDend',...
                (max(Stop(s_1hSD,'s'))-min(Start(s_1hSD,'s')))/3600));
            
            % first 1hr sleep at SD end time versus 9a.m.
            if i>length(DirE)
                sleep_LO=and(s_LO,sleep);mergeCloseIntervals(sleep_LO,1);
                cs=cumsum(Stop(sleep_LO,'s')-Start(sleep_LO,'s'));
                ind_sleep=min(find(cs>3600));
                s_1hLO=intervalSet(Start(subset(sleep_LO,1)),Stop(subset(sleep_LO,ind_sleep)));
                disp(sprintf('it took %1.2fh to get 1hr cumulated sleep begining at 9a.m.',...
                    (max(Stop(s_1hLO,'s'))-min(Start(s_1hLO,'s')))/3600));
            else
                s_1hLO=intervalSet([],[]);
            end
            
            MSpec_SD1h(man,:)=nanmean(Data(Restrict(Sptemp,s_1hSD)),1);
            MSpec_LO1h(man,:)=nanmean(Data(Restrict(Sptemp,s_1hLO)),1);
            SWA_1h(man,1)=nanmean(Data(Restrict(Sptsd,s_1hSD)));
            SWA_1h(man,2)=nanmean(Data(Restrict(Sptsd,s_1hLO)));
        else
            disp(['No existing ',nameStructure])
        end
    end
    
    % ------------------------ save ------------------------
    save([analyFolder,'/',Analyname],'-append','Dur_SD','SWA_SD',...
        'Dur_LO','SWA_LO','MSpec','MSpec_SD','MSpec_LO','fsamp','Delt','Delt_SD','Delt_LO',...
        'MSpec_SD1h','MSpec_LO1h','SWA_1h');
    
end
%% Averaged Spectrum
f=fsamp;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7])
MiSpec=nan(6,length(mice),length(f));
for mi=1:length(mice)
    indBSL=find(strcmp(nameMouse,mice{mi}) & typ==0);
    indSD=find(strcmp(nameMouse,mice{mi}) & typ==1);
    indPsd=find(strcmp(nameMouse,mice{mi}) & typ==2);
    
    subplot(3,length(mice),mi),hold on; title(mice{mi})
    plot(f,10*log10(MSpec(indBSL,:)),'Linewidth',2,'Color',[0 0 0]) 
    plot(f,10*log10(MSpec(indSD,:)),'Linewidth',2,'Color',[0.9 0 0.5]) 
    try plot(f,10*log10(MSpec(indPsd,:)),'Linewidth',2,'Color',[0.5 0.5 0.5]) ;end
    ylabel([nameStructure,'NREM Power (10*log10)']); xlabel('Frequency (Hz)'); xlim([1.5 10])
    leg={'','','','','',''}; leg{1}='BSL'; leg{length(indBSL)+1}='SD'; leg{length(indBSL)+length(indSD)+1}='+24h';
    if mi==length(mice), legend(leg);end
    for m=1:2
        subplot(3,length(mice),m*length(mice)+mi),hold on, 
        if m==1,
            %A=MSpec_SD; title([expetyp,'end-(+2h30), ',mice{mi}])
            A=MSpec_SD1h; title([expetyp,'end-(+1h), ',mice{mi}])
        else
            A=MSpec_LO; if strcmp(expetyp,'SD'), title(['15h30-18h, ',mice{mi}]); else, title(['9h30-12h, ',mice{mi}]);end
            %A=MSpec_LO1h; if strcmp(expetyp,'SD'), title(['15h30-18h, ',mice{mi}]); else, title(['9h30-12h, ',mice{mi}]);end
        end
        plot(f,10*log10(A(indBSL,:)),'Linewidth',2,'Color',[0 0 0])
        plot(f,10*log10(A(indSD,:)),'Linewidth',2,'Color',[0.9 0 0.5])
        try plot(f,10*log10(A(indPsd,:)),'Linewidth',2,'Color',[0.5 0.5 0.5]);end
        ylabel([nameStructure,'NREM Power (10*log10)']); xlabel('Frequency (Hz)'); xlim([1.5 10])
        MiSpec(3*(m-1)+1,mi,:)=nanmean(A(indBSL,:),1);
        MiSpec(3*(m-1)+2,mi,:)=nanmean(A(indSD,:),1);
        try MiSpec(3*(m-1)+3,mi,:)=nanmean(A(indPsd,:),1);end
    end
end
% save Figure
if savFigure, saveFigure(gcf,['SWA',nameStructure,'_IndivSpectrum'],saveFolder);end
%%

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.3 0.35])
for m=1:2
    subplot(1,2,m), hold on,
    if m==1
        A=squeeze(MiSpec(1,:,:)); B=squeeze(MiSpec(2,:,:)); C=squeeze(MiSpec(3,:,:));
        title([expetyp,'end-(+1h)']);
    else
        A=squeeze(MiSpec(4,:,:)); B=squeeze(MiSpec(5,:,:)); C=squeeze(MiSpec(6,:,:));
        if strcmp(expetyp,'SD'), title('15h30-18h'); else, title('9h30-12h');end
    end
    %plot(f,10*log10( nanmean(A,1)),'Linewidth',2,'Color',[0 0 0])
    plot(f,10*log10( nanmean(A,1)),'Linewidth',3,'Color',[0 0 0])
    plot(f,10*log10( nanmean(B,1)),'Linewidth',3,'Color',[0.9 0 0.5])
    plot(f,10*log10( nanmean(C,1)),'Linewidth',3,'Color',[0.5 0.5 0.5])
    legend({'BSL',expetyp,'+24h'})
    ylabel([nameStructure,'NREM Power (normed 1/f)']); xlabel('Frequency (Hz)'); xlim([1.5 10])
    
    plot(f,10*log10(nanmean(A,1)+stdError(A)),'Color',[0 0 0]); 
    plot(f,10*log10(nanmean(A,1)-stdError(A)),'Color',[0 0 0]);
    plot(f,10*log10( nanmean(B,1)+stdError(B)),'Color',[0.9 0 0.5]); 
    plot(f,10*log10( nanmean(B,1)-stdError(B)),'Color',[0.9 0 0.5]);
    plot(f,10*log10( nanmean(C,1)+stdError(C)),'Color',[0.5 0.5 0.5]); 
    plot(f,10*log10( nanmean(C,1)-stdError(C)),'Color',[0.5 0.5 0.5]);
end
% save Figure
if savFigure, saveFigure(gcf,['SWA',nameStructure,'_averageSpectrum'],saveFolder);end
    
    
%% quantify SWA
ploIndiv=0;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.25 0.5]); numF=gcf;
for f=1:4
    
    if f<3
        tit2='LightON'; swaBSL=nan(length(mice),size(SWA_LO,2));
        if f==1, A=SWA_LO; tit='SWA (2-4Hz)'; else, A=Delt_LO; tit='Delta occ (Hz)'; end
    else
        tit2=['h fin',expetyp]; swaBSL=nan(length(mice),size(SWA_SD,2));
        if f==3, A=SWA_SD; tit='SWA (2-4Hz)'; else, A=Delt_SD; tit='Delta occ (Hz)'; end
    end
    swaSD=swaBSL; swaPsd=swaBSL;
    
    if ploIndiv, figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.4 0.7]);end
    for mi=1:length(mice)
        indBSL=find(strcmp(nameMouse,mice{mi}) & typ==0);
        indSD=find(strcmp(nameMouse,mice{mi}) & typ==1);
        indPsd=find(strcmp(nameMouse,mice{mi}) & typ==2);
        swaBSL(mi,:)=nanmean(A(indBSL,:),1);
        swaSD(mi,:)=nanmean(A(indSD,:),1);
        swaPsd(mi,:)=nanmean(A(indPsd,:),1);
        
        if ploIndiv
            subplot(2,3,mi), hold on, title(mice{mi})
            plot([1:24]*t_step/3600,A(indBSL,:),'Linewidth',2,'Color',[0 0 0])
            plot([1:24]*t_step/3600,A(indSD,:),'Linewidth',2,'Color',[0.9 0 0.5])
            plot([1:24]*t_step/3600,A(indPsd,:),'Linewidth',2,'Color',[0.5 0.5 0.5])
            hold on, plot(0.25*[1 1],[0 100],'--','Color','k')
        end
    end
    if ploIndiv,legend([{'BSL',expetyp,'+24h'},tit2]);end
    
    figure(numF), subplot(2,2,f),hold on,
    errorbar(6*floor(f/3)+[1:24]*t_step/3600,nanmean(swaBSL,1),stdError(swaBSL),'Linewidth',2,'Color','k');
    errorbar(6*floor(f/3)+[1:24]*t_step/3600,nanmean(swaSD,1),stdError(swaSD),'Linewidth',2,'Color',[0.9 0 0.5]);
    errorbar(6*floor(f/3)+[1:24]*t_step/3600,nanmean(swaPsd,1),stdError(swaPsd),'Linewidth',2,'Color',[0.5 0.5 0.5]);
    xlim([-0.5 12]); %ylim([1E4 8E4]); 
    hold on, plot(0.25*[1 1],ylim,'--','Color','k'); 
    legend([{'BSL',expetyp,'+24h'},tit2]); 
    ylabel([nameStructure,' ',tit]);xlabel('Time (h), devided in 30min blocks')
    yl=max(ylim);
    %stats
    pval1=nan(1,24); pval2=pval1; pval3=pval1;
    for k=1:24
        if 0
            namtest='signrank';
            try p1=signrank(swaBSL(:,k),swaSD(:,k));end
            try p2=signrank(swaBSL(:,k),swaPsd(:,k));end
            try p3=signrank(swaSD(:,k),swaPsd(:,k));end
        else
            namtest='ttest';
            try [h,p1]=ttest2(swaBSL(:,k),swaSD(:,k));end
            try [h,p2]=ttest2(swaBSL(:,k),swaPsd(:,k));end
            try [h,p3]=ttest2(swaSD(:,k),swaPsd(:,k));end
        end
        try if p1<0.05, pval1(k)=yl*1.1;end;end
        try if p2<0.05, pval2(k)=yl;end;end
        try if p3<0.05, pval3(k)=yl*0.9;end;end
    end
    
    plot([1:24]*t_step/3600,pval1,'*r')
    plot([1:24]*t_step/3600,pval2,'*','Color',[1 0.2 0.8])
    plot([1:24]*t_step/3600,pval3,'*','Color',[1 0.5 0.2])
    if f==3, legend({'BSL',expetyp,'+24h',tit2,['BSL vs ',expetyp],'BSL vs +24h',[expetyp,' vs +24h']});end
    title(sprintf(['(n=%d), ',namtest],sum(~isnan(nanmean(swaSD,2)))),'Color',[0.9 0 0.5]);
end
 % save Figure
if savFigure, keyboard; saveFigure(numF,['SWA',nameStructure,'_BilanEvol_',namtest],saveFolder);end
     
    

%% spectrum only
if 1
    [params,movingwin,suffix]=SpectrumParametersML('low');
    nameStructure={'PFCx_EcoG'};%{'PFCx_deep','PFCx_sup','Bulb_deep'};
    FileToSave=['SpectrumData',suffix];
    for man=1:length(Di)
        
        cd(Di{man}); disp(' ');disp(Di{man})
        % -------------- ComputeSpectrogram_newML.m ------------------
        for s=1:length(nameStructure)
            clear LFP channel LFP_temp Sp t f
            % load channel
            try load([Di{man},'/ChannelsToAnalyse/',nameStructure{s},'.mat']);end
            if strcmp(nameStructure{s},'PFCx_EcoG'), 
                load([Di{man},'/LFPData/InfoLFP.mat']);
                channel=InfoLFP.channel(InfoLFP.depth==0 & strcmp(InfoLFP.structure,'PFCx')); 
                if isempty(channel), disp('No EcoG defined'); end
            end
            
            try
                load([FileToSave,'/Spectrum',num2str(channel)],'t','f');
                t; disp([nameStructure{s},' = LFP',num2str(channel),'. Spectum exists.'])
            catch
                try
                    disp([nameStructure{s},' = LFP',num2str(channel),'. Computing spectrum...'])
                    load(['LFPData/LFP',num2str(channel)],'LFP');
                    % calculate Sp for given LFP
                    LFP_temp=ResampleTSD(LFP,params.Fs);
                    [Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);
                    Spi=Sp; ti=t; freqfi=f;
                    if ~exist(FileToSave,'dir'); mkdir(FileToSave);end
                    save([FileToSave,'/Spectrum',num2str(channel)],'-v7.3','Sp','t','f','params','movingwin');
                catch
                    disp([nameStructure{s},': FAILED !'])
                end
            end
        end
    end
end


%% Define EcoG
if 0
iD=find(strcmp(nameMouse,'Mouse394'));
for man=1:length(iD)
    cd(Di{iD(man)}); disp(Di{iD(man)});
    clear InfoLFP
    load('LFPData/InfoLFP.mat');
    channel=16;
    if strcmp(InfoLFP.structure(channel),'PFCx')
        InfoLFP.depth(InfoLFP.channel==channel)=0;
    else
        disp('Problem')
    end
    save('LFPData/InfoLFP.mat','InfoLFP');
end
end