%AnalyseNREMsubstages_SD24h.m
%
% list of related scripts in NREMstages_scripts.m 

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

donoise=1; % to include noise within WAKE periods
f_swa=[2 5]; %Hz

analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
analyname='AnalyNREMsubstagesSD24h';

saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/SleepDeprivation24h';
savFigure=0;
colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 0.5; 0 0 0.5; 0 0 1];

%t_step=30*60; % in second
%t_step=60*60; % in second (default 1h)
t_step=120*60;

nam={'',''};
if floor(t_step/3600)~=0, nam{1}=sprintf('%dh',floor(t_step/3600));else,nam{2}='min';end 
if rem(t_step,3600)~=0,nam{2}=[sprintf('%d',floor(rem(t_step,3600)/60)),nam{2}];end
analyname=[analyname,'_',nam{1},nam{2},'Step'];

if donoise, analyname=[analyname,'_Wnz'];end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
[Dir,nameSessions]=NREMstages_path('SD24h');

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< LOAD DATA IF EXIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
DoAnalysis=0;
try
    clear durEp Epochs
    load([analyFolder,'/',analyname,'.mat']);
    Epochs;
    disp([analyname,'.mat already exists... loaded.'])
catch
    DoAnalysis=1;
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< COMPUTE SD EFFECT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

if DoAnalysis
    
    % <<<<<<<<<<<<<<<<<<<<< Get Behavioral experiments <<<<<<<<<<<<<<<<<<<<
    Epochs={}; nameMouse={}; 
    Delt={}; Rips={}; Spin={};
    SWAeeg={}; SWApf={}; SWAob={};
    h_deb=nan(size(Dir,1),length(nameSessions)/2);
    for a=1:size(Dir,1)
        for man=1:length(nameSessions)
            disp(' '); disp('------------------------------------------')
            disp(Dir{a,man}); cd(Dir{a,man});
            nameMouse{a}=Dir{a,man}(max(strfind(Dir{a,man},'Mouse'))+[0:7]);
            
            % -------------------------------------------------------------
            % get substages
            clear WAKE REM N1 N2 N3 NREM Total savWAKE
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages;
            close
            savWAKE=WAKE;
            if donoise, WAKE=WAKEnoise;end   % optional !!
            NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,10);
            SLEEP=or(NREM,REM);mergeCloseIntervals(SLEEP,10);
            Total=or(SLEEP,WAKE); mergeCloseIntervals(Total,10);
            
            Stages={'WAKE','REM','N1','N2','N3','NREM','Total','SLEEP','savWAKE'};
            
            % get time of the day
            NewtsdZT=GetZT_ML(Dir{a,man});
            rgZT=Range(NewtsdZT);
            
            % get SWA
            % -------------- Get channel for PFCx and OB ------------------
            clear channel Sptsd1 Sptsd2 Sptsd3
            channel2=[]; channel3=[];
            % load channel
            load('LFPData/InfoLFP.mat');
            channel1=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx') & InfoLFP.depth==0);
            if isempty(channel1), try  load('ChannelsToAnalyse/PFCx_deltasup.mat'); channel1=channel;end;end
            try clear channel; load('ChannelsToAnalyse/PFCx_deltadeep.mat'); channel2=channel;end
            try clear channel; load('ChannelsToAnalyse/Bulb_deep.mat'); channel3=channel;end
            
            % -------------- ComputeSpectrogram_newML.m ------------------
            for cha=1:3
                clear channel Sp t f Sptsd
                eval(sprintf('channel=channel%d;',cha))
                if ~isempty(channel)
                    [Sp,t,f]=LoadSpectrumML(channel);
                    fsamp=f;
                    % SWA spectrum
                    Sptsd=tsd(t*1E4,mean(Sp(:,f>=f_swa(1) & f<f_swa(2)),2));
                else
                    Sptsd=tsd([],[]);
                end
                eval(sprintf('Sptsd%d=Sptsd;',cha))
            end
            
            % -------------- Load Delta & Ripples------------------
            Epoch=CleanUpEpoch(Total-noise);
            Dpfc=GetDeltaML(Epoch,NREM);
            [dHPCrip,EpochRip]=GetRipplesML(Epoch,NREM);
            try dRip=dHPCrip(:,2);catch, dRip=[];end
            
            % -------------- Load Spindles ------------------
            % load Spindles PFCx Sup 
            spiHf=[]; spiLf=[];clear Spfc
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup',Epoch,NREM);
            try spiHf=[spiHf;SpiHigh(:,2)]; end
            try spiLf=[spiLf;SpiLow(:,2)];end
            % load Spindles PFCx Deep
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep',Epoch,NREM);
            try spiHf=[spiHf;SpiHigh(:,2)];end
            try spiLf=[spiLf;SpiLow(:,2)];end
            % Sort Spindles 
            Spfc=[spiHf;spiLf]; Spfc=sort(Spfc);
            Spfc(find(diff(Spfc)<0.5)+1)=[];%meme spindles
            Spfc=Spfc*1E4;
           
            % ------- concatenate day and night epochs --------
            if floor(man/2)==man/2
                i_start=mod(min(Data(NewtsdZT))/3600/1E4,24)*3600*1E4;
                delay=mod(i_start-i_stop,24*3600*1E4)+i_L;
                Ep={};
                for n=1:length(Stages)
                    eval(['epoch=',Stages{n},'; temp=temp',Stages{n},';'])
                    newEpoch=intervalSet(Start(epoch)+delay,Stop(epoch)+delay);
                    Ep{n}=or(temp,newEpoch);
                end
                
                Epochs{a,man/2}=Ep;
                
                Delt{a,man/2}=ts([tempDelt;Dpfc+delay]);
                Rips{a,man/2}=ts([tempRips;dRip+delay]);
                Spin{a,man/2}=ts([tempSpfc;Spfc+delay]);
                
                SWAeeg{a,man/2}=tsd([Range(tempSWAeeg);Range(Sptsd1)+delay],[Data(tempSWAeeg);Data(Sptsd1)]);
                SWApf{a,man/2}=tsd([Range(tempSWApf);Range(Sptsd2)+delay],[Data(tempSWApf);Data(Sptsd2)]);
                SWAob{a,man/2}=tsd([Range(tempSWAob);Range(Sptsd3)+delay],[Data(tempSWAob);Data(Sptsd3)]);
               
%                 if sum(Stop(Ep{7},'s')-Start(Ep{7},'s'))>3600*24; disp('PROBLEM: Too long');keyboard;end
%                 PlotPolysomnoML(Ep{3},Ep{4},Ep{5},Ep{6},Ep{2},Ep{1}); 
%                 title([nameMouse{a},' ',nameSessions{man-1},' and ',nameSessions{man}])
%                 keyboard
            else
                i_stop=mod(max(Data(NewtsdZT))/3600/1E4,24)*3600*1E4;
                i_L=max(Range(NewtsdZT))-min(Range(NewtsdZT));
                for n=1:length(Stages)
                    eval(['temp',Stages{n},'=',Stages{n},';'])
                end
                h_deb(a,(man+1)/2)=mod(min(Data(NewtsdZT)/1E4)/3600,24);
                
                tempDelt=Dpfc;
                tempRips=dRip;
                tempSpfc=Spfc;
                    
                tempSWAeeg=Sptsd1;
                tempSWApf=Sptsd2;
                tempSWAob=Sptsd3;
            end
            disp('Done.')
        end
    end
    % saving
    save([analyFolder,'/',analyname,'.mat'],'Dir','t_step','Stages','Epochs','h_deb','nameMouse',...
        'Delt','Rips','Spin','SWAeeg','SWApf','SWAob','f_swa')
end
   
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< ANALYZE STAGES AND SWA ON ZT <<<<<<<<<<<<<<<<<<<<<<<< 
nameStru={'Delta','swaEEG','swaPFC','swaOB','swaEEGz','swaPFCz','swaOBz'};
try
    durEp;
catch
    durEp=[];
    SW=[];% manipe condition stage duration structure SWAonTotal SWAzt->
    for a=1:size(Dir,1)
        clear muPF sigPF muOB sigOB sigEG muEG
        for man=1:length(nameSessions)/2
            
            % <<<<<<<<<<<<<<<<<< Get & display epochs <<<<<<<<<<<<<<<<<<<<<
            Ep=Epochs{a,man};
            PlotPolysomnoML(Ep{3},Ep{4},Ep{5},Ep{6},Ep{2},Ep{1}); 
            title([nameMouse{a},' ',nameSessions{2*man-1},' and ',nameSessions{2*man}])
            %close
            
            
            % <<<<<<<<<<<<<<<<<< Prepare ZT timesteps <<<<<<<<<<<<<<<<<<<<<
            delay_rec=(h_deb(a,man)-9)*3600; % starts at 9am
            n_nan=floor(delay_rec/t_step);
            sta=zeros(1,n_nan);sto=zeros(1,n_nan); % empty blocks
            sta=[sta,max(0,n_nan*t_step-delay_rec)]; % first block start
            sto=[sto,min(t_step,t_step+n_nan*t_step-delay_rec)]; %first block end
            
            num_step=ceil((max(Stop(Ep{7},'s'))-sto(end))/ t_step);
            sta=[sta,sto(end)+[0:1:num_step-1]*t_step];
            sto=[sto,sto(end)+[1:num_step]*t_step];
            
            
            % <<<<<<<<<<<<<<<<<<<<<< Get SWA & delta <<<<<<<<<<<<<<<<<<<<<<
            sp{1}=Delt{a,man};
            if man==1
                try [Z,muEG,sigEG] = zscore(Data(Restrict(SWAeeg{a,man},and(Ep{8},intervalSet(0,10*3600*1E4)))));end % zscore on day sleep
                [Z,muPF,sigPF] = zscore(Data(Restrict(SWApf{a,man},and(Ep{8},intervalSet(0,10*3600*1E4))))); % zscore on day sleep
                [Z,muOB,sigOB] = zscore(Data(Restrict(SWAob{a,man},and(Ep{8},intervalSet(0,10*3600*1E4)))));% zscore on day sleep
            end
            sp{2}=SWAeeg{a,man};
            sp{3}=SWApf{a,man};
            sp{4}=SWAob{a,man};
            %zscore
            try sp{5}=tsd(Range(SWAeeg{a,man}),(Data(SWAeeg{a,man})-muEG)/sigEG);end
            sp{6}=tsd(Range(SWApf{a,man}),(Data(SWApf{a,man})-muPF)/sigPF);
            sp{7}=tsd(Range(SWAob{a,man}),(Data(SWAob{a,man})-muOB)/sigOB);
            
            N=length(Stages);
            Nstru=length(nameStru); temp=[1:N]'*ones(1,Nstru);
            tempSW=nan(N*Nstru,6+24/(t_step/3600));
            tempSW(:,1:3)=[ones(N*Nstru,1)*[a,man],temp(:)];
            for stru=1:Nstru
                for n=1:N
                    durn=sum(Stop(Ep{n},'s')-Start(Ep{n},'s'));
                    ind=N*(stru-1)+n;
                    tempSW(ind,4:5)=[stru,durn];
                    try 
                        if stru==1, tempSW(ind,6)=length(Data(Restrict(sp{stru},Ep{n})))/durn;
                        else, tempSW(ind,6)=nanmean(Data(Restrict(sp{stru},Ep{n})));end
                    end
                end
            end
            
            % <<<<<<<<<<<<<<< Stages & SWA on ZT timesteps <<<<<<<<<<<<<<<<
            
            tempDur=nan(N,3+24/(t_step/3600));
            tempDur(:,1:2)=ones(N,1)*[a,man];
            tempDur(:,3)=1:N;
            
            L=min(length(sta),24/(t_step/3600));
            for e=1:L % 24h max
                I=intervalSet(sta(e)*1E4,sto(e)*1E4);
                for n=1:N
                    s_Ep=and(Ep{n},I);
                    tempDur(n,3+e)=sum(Stop(s_Ep,'s')-Start(s_Ep,'s'));
                    if n==7 && tempDur(n,3+e)==0 % total rec (without noise)
                        tempDur(:,3+e)=nan(N,1);
                    end % noise ! include only recording epochs larger than 20min
                    
                    for stru=1:Nstru
                        try  
                            if stru==1, tempSW(N*(stru-1)+n,6+e)=length(Data(Restrict(sp{stru},s_Ep)))/tempDur(n,3+e);
                            else,tempSW(N*(stru-1)+n,6+e)=nanmean(Data(Restrict(sp{stru},s_Ep)));end
                        end
                    end
                end
            end
            durEp = [durEp;tempDur];
            SW = [SW;tempSW]; %keyboard
        end
    end
    % saving
    save([analyFolder,'/',analyname,'.mat'],'-append','durEp','SW','nameStru')
    
end

AnalyseNREMsubstages_DisplayORandSD;


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<< DISPLAY RESULTS FOR FIRST SLEEP HOUR <<<<<<<<<<<<<<<<<<<<
ploindiv=0;
Th=1:1.5:6; %first hours of sdefault 1, choose a maximum of 4 values
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.65 0.24*length(Th)]), numF=gcf;
MAT1h=nan(length(Th),size(Dir,1),length(nameSessions)/2,6);
for tt=1:length(Th)
    Mb=nan(size(Dir,1)*(length(nameSessions)/2+1),6);
    for a=Nmice
        for i=1:length(nameSessions)/2
            Ep=Epochs{a,i};
            
            sta=Start(Ep{8},'s'); sto=Stop(Ep{8},'s');%SLEEP
            Cst=cumsum(sto-sta);
            ind1h=min(find(Cst>3600*Th(tt)));
            exced=Cst(ind1h)-3600*Th(tt);
            I=intervalSet(min(Start(Ep{7})),(sto(ind1h)-exced)*1E4);
            for n=1:6
                ep=and(I,Ep{n});
                MAT1h(tt,a,i,n)=sum(Stop(ep,'s')-Start(ep,'s'));
            end
            % Mb
            ind=(a-1)*(length(nameSessions)/2+1)+i;
            Mb(ind,:)=squeeze(MAT1h(tt,a,i,[2:6,1]))/60;
        end
    end
    subplot(length(Th),1,tt),bar(Mb,'Stacked');ylabel('time (min)');
    set(gca,'Xtick',2:4:4*size(Dir,1)), set(gca,'XtickLabel',nameMouse)
    title(sprintf('Repartition of stage for %1.1fh cumulated sleep',Th(tt)))
    xlim([0.3 4*size(Dir,1)-0.3]); ylim([0 1.02*max(sum(Mb,2))])
end
colormap(colori([2:6,1],:)); legend(Stages([2:6,1]));
%saveFigure(numF.Number,'BilanIndivSD24h_hCumSleep',saveFolder);

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.95 0.24*length(Th)]), 
for tt=1:length(Th)
    MATbar=nan(6,length(NameSess));
    MATstd=MATbar;MATbarN=MATbar;MATstdN=MATbar;
    for i=1:length(NameSess)
        temp=squeeze(MAT1h(tt,:,i,:));
        norm=squeeze(MAT1h(tt,:,1,:));
        MATbar(1:6,i)=nanmean(temp,1)/60;
        MATstd(1:6,i)=stdError(temp)/60;
        MATbarN(1:6,i)=nanmean(log10(temp./norm),1);
        MATstdN(1:6,i)=stdError(log10(temp./norm));
        % stats 
        for i2=i+1:length(NameSess)
            eval(sprintf('clear p%d%d',i,i2));
            temp2=squeeze(MAT1h(tt,:,i2,:));
            for n=1:6, eval(sprintf('p%d%d(n)=signrank(temp(:,n),temp2(:,n));',i,i2)); end
        end
    end
    % stats
    Legpval={'   -- signrank --'};
    for n=1:6
        tempL=[Stages{n},': ']; 
        for i=1:length(NameSess)
            for i2=i+1:length(NameSess)
                eval(sprintf('pval=p%d%d(n);',i,i2));
                tempL=[tempL,sprintf([NameSess{i}(1),'/',NameSess{i2}(1),' p=%1.3f, '],pval)];
            end
        end
        Legpval=[Legpval,{tempL}];
    end
    subplot(length(Th),3,3*tt-2); bar(MATbar); hold on, colormap copper
    for i=1:3, errorbar([1:6]-0.44+i*0.22,MATbar(:,i),MATstd(:,i),'+k');end
    set(gca,'Xtick',1:6), set(gca,'XtickLabel',Stages(1:6))
    ylabel('Duration (min)'); xlim([0.5 6.5]); ylim([0 1.02*max(max(MATbar))])
    
    subplot(length(Th),3,3*tt-1); text(-0.2,0.5,Legpval); axis off
    title(sprintf('            Repartition of stage for %1.1fh cumulated sleep',Th(tt)))
    
    subplot(length(Th),3,3*tt); bar(MATbarN); hold on, colormap copper
    for i=1:3, errorbar([1:6]-0.44+i*0.22,MATbarN(:,i),MATstdN(:,i),'+k');end
    set(gca,'Xtick',1:6), set(gca,'XtickLabel',Stages(1:6))
    ylabel('% BSL'); xlim([0.5 6.5]); %ylim([0 1.02*max(max(MATbarN))])
    
end
subplot(length(Th),3,1);legend(NameSess); 
%saveFigure(numF.Number,'BilanSD24h_hCumSleep',saveFolder);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<< DISPLAY RESULTS DURATION CORRELATION <<<<<<<<<<<<<<<<<<<<
MATep=nan(size(Dir,1),length(nameSessions)/2,length(Stages));
for a=Nmice
    for i=1:length(nameSessions)/2
        Ep=Epochs{a,i};
        %epDay=and(Ep{7},intervalSet(0,11*3600*1E4)); % day
        epDay=Ep{7};
        TotDur=sum(Stop(epDay,'s')-Start(epDay,'s'));
        for n=1:6
            %Epn=and(Ep{n},intervalSet(0,11*3600*1E4));
            Epn=Ep{n};
            MATep(a,i,n)=100*sum(Stop(Epn,'s')-Start(Epn,'s'))/TotDur;
        end
        
    end
end

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.85 0.85]),
for n1=1:6
%     for n2=1:6
%         subplot(6,6,6*(n1-1)+n2), hold on,
n2=2; subplot(1,6,n1), hold on,
        try
        M1=squeeze(MATep(:,:,n1));
        M2=squeeze(MATep(:,:,n2));
        plot(M1(:,1),M2(:,1),'.','Color','k','MarkerSize',20)
        plot(M1(:,2),M2(:,2),'.','Color',colori(n1,:),'MarkerSize',20)
        plot(M1(:,3),M2(:,3),'.','Color',[0.5 0.5 0.5],'MarkerSize',20)
        ylabel(Stages{n2}); xlabel(Stages{n1})
        end
        x=M1(:);
        y=M2(:);
        y(isnan(abs(x)))=[];x(isnan(abs(x)))=[];
        x(isnan(abs(y)))=[];y(isnan(abs(y)))=[];
        p= polyfit(x,y,1);
        line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k','Linewidth',2)
        [r,p]=corrcoef(x,y);
        title(sprintf('r=%0.1f, p=%0.3f',r(1,2),p(1,2)))
        %     end
end
%numF=gcf; saveFigure(numF.Number,'CorrelationSubstagesSD24h',saveFolder);
