% AnalyseNREMsubstages_OR.m
% voir AnalyseNREMsubstages_ORold.m
% list of related scripts in NREMstages_scripts.m 

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%t_step=60*60; % in second
t_step=2*60*60; % in second
colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 1; 0.5 0.5 0.5; 0 0 0];
f_swa=[2 5]; %Hz
donoise=1; % to include noise within WAKE periods
Stages={'WAKE','REM','N1','N2','N3','NREM','Total','SLEEP'};

analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/ObjectRecognition';
savFigure=0;

analyname='AnalyNREMsubstagesOR';
nam={'',''};
if floor(t_step/3600)~=0, nam{1}=sprintf('%dh',floor(t_step/3600));else,nam{2}='min';end 
if rem(t_step,3600)~=0,nam{2}=[sprintf('%d',floor(rem(t_step,3600)/60)),nam{2}];end
analyname=[analyname,'_',nam{1},nam{2},'Step'];

if donoise, analyname=[analyname,'_Wnz'];end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
[Dir,nameSessions]=NREMstages_path('OR');


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< LOAD DATA IF EXIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
DoAnalysis=0;
try
    clear Epochs;
    load([analyFolder,'/',analyname,'.mat']);Epochs;
    disp([analyname,'.mat already exists. Loaded.'])
catch 
    DoAnalysis=1;
    disp(['Computing then saving in ',analyname,'.mat'])
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if DoAnalysis
    Epochs={}; nameMouse={};
    Delt={}; Rips={}; Spin={};
    SWApf={}; SWAob={};
    h_deb=nan(size(Dir,1),3);
    h_deb_POST=nan(size(Dir,1),3);
    t_deb_POST=nan(size(Dir,1),3);
    
    for a=1:size(Dir,1)
        for man=1:6
            try
                % %%%%%%%%%%%%%%%%%% GET EXPERIMENTS %%%%%%%%%%%%%%%%%%%%%%
                disp(' ');disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ')
                disp(Dir{a,man});cd(Dir{a,man});
                nameMouse{a,man}=Dir{a,man}(max(strfind(Dir{a,man},'Mouse'))+[0:7]);
                indMAT=[a,man,str2num(nameMouse{a,man}(6:8))];
                
                % %%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%
                clear WAKE REM N1 N2 N3 NamesStages SleepStages
                % Substages
                disp('- RunSubstages.m')
                [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages;close;
                NREM=or(or(N1,N2),N3);
                NREM=mergeCloseIntervals(NREM,10);
                SLEEP=or(NREM,REM);
                SLEEP=mergeCloseIntervals(SLEEP,10);
                if donoise, WAKE=WAKEnoise;end   % optional !!
                
                Total=or(SLEEP,WAKE);
                Total=mergeCloseIntervals(Total,10);
                Total=CleanUpEpoch(Total);
                Epoch=CleanUpEpoch(Total-noise);
                
                % %%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%%
                NewtsdZT=GetZT_ML;
                rgZT=Range(NewtsdZT);
                
                % %%%%%%%%%%%%%%%%%%%%% GET DELTA %%%%%%%%%%%%%%%%%%%%%%%
                clear tDelta Dpfc dHPCrip dRip Spfc
                Dpfc=GetDeltaML;
                
                % %%%%%%%%%%%%%%%%%%%%% GET RIPPLES %%%%%%%%%%%%%%%%%%%%%%%
                disp('getting AllRipplesdHPC25.mat');
                [dHPCrip,EpochRip]=GetRipplesML(Epoch,NREM);
                try dRip=dHPCrip(:,2);catch, dRip=[];end
                
                % %%%%%%%%%%%%%%%%%%%%% GET Spindles %%%%%%%%%%%%%%%%%%%%%%%
                % <<<<<<<<<<<< load Spindles PFCx Sup <<<<<<<<<<<<<<<<<<
                spiHf=[]; spiLf=[];clear Spfc
                [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup',Epoch,NREM);
                try spiHf=[spiHf;SpiHigh(:,2)]; end
                try spiLf=[spiLf;SpiLow(:,2)];end
                % <<<<<<<<<<<<<<< load Spindles PFCx Deep <<<<<<<<<<<<<<<<<<<<<<<<<
                [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep',Epoch,NREM);
                try spiHf=[spiHf;SpiHigh(:,2)];end
                try spiLf=[spiLf;SpiLow(:,2)];end
                % <<<<<<<<<<<<< Sort Spindles <<<<<<<<<<<<<<<<<<<<<<<<<<<<
                Spfc=[spiHf;spiLf]; Spfc=sort(Spfc);
                Spfc(find(diff(Spfc)<0.5)+1)=[];%meme spindles
                Spfc=Spfc*1E4;
                
                %%%%%%%%%%%%%%%%%%% LOAD Spectrum PFC %%%%%%%%%%%%%%%%%%%%%
                try
                    [Sp,t,f]=LoadSpectrumML('PFCx_deep',Dir{a,man},'low');
                    SptsdPFC=tsd(t*1E4, mean(Sp(:,find(f>f_swa(1) & f<f_swa(2))),2) );
                catch
                    SptsdPFC=tsd([],[]);
                    disp('Problem PFC_deep spectrum')
                end
                
                %%%%%%%%%%%%%%%%%%% LOAD Spectrum OB %%%%%%%%%%%%%%%%%%%%%%
                try
                    [Sp,t,f]=LoadSpectrumML('Bulb_deep',Dir{a,man},'low');
                    SptsdOB=tsd(t*1E4, mean(Sp(:,find(f>f_swa(1) & f<f_swa(2))),2) );
                catch
                    SptsdOB=tsd([],[]);
                    disp('Problem OB_deep spectrum')
                end
                
                % %%%%%%%%%%%%%% CONCATENATE DAY AND NIGHT %%%%%%%%%%%%%%%%
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
                    
                    SWApf{a,man/2}=tsd([Range(tempSWApf);Range(SptsdPFC)+delay],[Data(tempSWApf);Data(SptsdPFC)]);
                    SWAob{a,man/2}=tsd([Range(tempSWAob);Range(SptsdOB)+delay],[Data(tempSWAob);Data(SptsdOB)]);
                    
                    disp(sprintf('Total duration pooled rec : %1.1fh',sum(Stop(Ep{7},'s')-Start(Ep{7},'s'))/3600))
                    if sum(Stop(Ep{7},'s')-Start(Ep{7},'s'))>3600*25; disp('PROBLEM: Too long');keyboard;end
                    PlotPolysomnoML(Ep{3},Ep{4},Ep{5},Ep{6},Ep{2},Ep{1});
                    title([nameMouse{a},' ',nameSessions{man-1},' and ',nameSessions{man}])
                    %keyboard
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
                    
                    tempSWApf=SptsdPFC;
                    tempSWAob=SptsdOB;
                    
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
                    if ~isempty(indOR),t_deb_POST(a,man)=tpsfin{indOR(end)};else, t_deb_POST(a,man)=0;end
                    if sum(strcmp(Dir{a,man}(end-7:end),{'20160719','20160720'}))>0; t_deb_POST(a,man)=0; end
                    
                    Post_Epoch=intervalSet(t_deb_POST(a,man)*1E4,tpsfin{end}*1E4); % time in 10E-4 second
                    h_deb_POST(a,man)=mod(min(Data(Restrict(NewtsdZT,Post_Epoch))/1E4)/3600,24)*3600;
                    if h_deb_POST(a,man)/3600<9
                        t_deb_POST(a,man)=9*3600 - h_deb_POST(a,man);
                        Post_Epoch=intervalSet(t_deb_POST(a,man)*1E4,tpsfin{end}*1E4); % time in 10E-4 second
                        h_deb_POST(a,man)=mod(min(Data(Restrict(NewtsdZT,Post_Epoch))/1E4)/3600,24)*3600;
                    end
                    disp(sprintf('Time of PostRec begining = %1.1fh',h_deb_POST(a,man)/3600))
                end
                disp('Done')
                
            catch
                disp('PROBLEM ! skip'); try cd(Dir{a,man}); keyboard;end
            end
        end
    end
    
    % saving
    save([analyFolder,'/',analyname,'.mat'],'Dir','t_step','Stages','f_swa','Epochs','nameMouse',...
        'Delt','Rips','Spin','SWApf','SWAob','h_deb','h_deb_POST','t_deb_POST')
    
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< ANALYZE STAGES AND SWA ON ZT <<<<<<<<<<<<<<<<<<<<<<<< 
nameStru={'Delta','Rippl','Spindl','swaPFC','swaOB','swaPFCz','swaOBz'};
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
            sp{2}=Rips{a,man};
            sp{3}=Spin{a,man};
            if man==1
                [~,muPF,sigPF] = zscore(Data(Restrict(SWApf{a,man},and(Ep{8},intervalSet(0,10*3600*1E4))))); % zscore on day sleep
                [~,muOB,sigOB] = zscore(Data(Restrict(SWAob{a,man},and(Ep{8},intervalSet(0,10*3600*1E4)))));% zscore on day sleep
            end
            sp{4}=SWApf{a,man};
            sp{5}=SWAob{a,man};
            %zscore
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




























% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< Coordination Spi Delt Rip <<<<<<<<<<<<<<<<<<<<<<<
NameCrossCorr={'Rip at Spin','Rip at Delt','Spin at Delt','Delt at Rip','Spin at Rip','Delt at SPin'};
NameCC={'Delt','Rips','Spin'};
IndCC=[2,3;2,1;3,1;1,2;3,2;1,3];
try
    CrossC;
catch
    CrossC=[];
    for a=1:size(Dir,1)
        for man=1:3
            for n=1:length(Stages)
                tempCC=[ones(length(NameCrossCorr),1)*[a,man,n],[1:length(NameCrossCorr)]'];
                s_Ep=Epochs{a,man};
                [Ct,Bt]=CrossSpiRipDeltaML(Spin{a,man},Rips{a,man},Delt{a,man},s_Ep{n},20);
                if ~isempty(Bt{1}), bt=Bt{1};end
                for cc=1:length(IndCC)
                    eval(['Ev1=',NameCC{IndCC(cc,1)},'{a,man};'])
                    eval(['Ev2=',NameCC{IndCC(cc,2)},'{a,man};'])
                    tempCC(cc,6)=length(Range(Restrict(Ev1,s_Ep{n})));
                    tempCC(cc,7)=length(Range(Restrict(Ev2,s_Ep{n})));
                    if tempCC(cc,6)>50 && tempCC(cc,7)>50
                        tempCC(cc,8:58)=Ct{cc}';
                    else
                        tempCC(cc,6:58)=nan(1,53);
                    end
                end
                CrossC=[CrossC; tempCC];
            end
        end
    end
    % save
    save([analyFolder,'/',analyname,'.mat'],'-append','CrossC','bt','NameCrossCorr')
end

% display
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.5 0.4]),numF=gcf;
for cc=1:length(IndCC)
    subplot(2,3,cc),hold on, leg=[];
    for man=1:2
        for n=4:5
            %tempCC=CrossC(find(CrossC(:,1)==a & CrossC(:,2)==man & CrossC(:,4)==n & CrossC(:,5)==cc),6:end);
            tempCC=CrossC(find(CrossC(:,2)==man & CrossC(:,3)==n & CrossC(:,4)==cc),6:end);
            nb(man,n,1:2)=nanmean(tempCC(:,1:2),1);
            plot(bt,nanmean(tempCC(:,3:end),1),'Color',colori(n,:),'Linewidth',man)
            leg=[leg,{[Stages{n},' ',nameSessions{man}]}];
        end
    end 
    title(sprintf([NameCrossCorr{cc},' n=%d'],size(tempCC,1))); legend(leg)
    lab1=sprintf([NameCC{IndCC(cc,1)},'- ',nameSessions{1},': N2#%1.0f, N3#%1.0f'],nb(1,4,1),nb(1,5,1));
    lab2=sprintf(['- ',nameSessions{2},': N2#%1.0f, N3#%1.0f'],nb(2,4,1),nb(2,5,1));
    xlabel({lab1,lab2});
    lab1=sprintf([NameCC{IndCC(cc,2)},'- ',nameSessions{1},': N2#%1.0f, N3#%1.0f'],nb(1,4,2),nb(1,5,2));
    lab2=sprintf(['- ',nameSessions{2},': N2#%1.0f, N3#%1.0f'],nb(2,4,2),nb(2,5,2));
    ylabel({lab1,lab2});
end
   
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< EPOCH DURATION ACROSS ZT <<<<<<<<<<<<<<<<<<<<<<<         

try
    Dur;SWApfc;
catch
    Dur=[];
    SWApfc=[];SWAob=[];
    SWAzpfc=[];SWAzob=[];
    for a=1:size(Dir,1)
        for man=1:3
            % <<<<<<<<<<<<<<<<<< Prepare ZT timesteps <<<<<<<<<<<<<<<<<<<<<
            delay_rec=h_deb_POST(a,man)-9*3600; % starts at 9am
            n_nan=floor(delay_rec/t_step);
            sta=zeros(1,n_nan);sto=zeros(1,n_nan); % empty blocks
            sta=[sta,max(0,n_nan*t_step-delay_rec)]; % first block start
            sto=[sto,min(t_step,t_step+n_nan*t_step-delay_rec)]; %first block end
            num_step=ceil((max(Stop(Total,'s'))-sto(end))/ t_step);
            sta=[sta,sto(end)+[0:1:num_step-1]*t_step];
            sto=[sto,sto(end)+[1:num_step]*t_step];
            sta=sta+t_deb_POST(a,man); sto=sto+t_deb_POST(a,man);
            
            %%%%%%%%%%%%%%% Stages & SWA on ZT timestep %%%%%%%%%%%%%%%%%%
            L=min(length(sta),12/(t_step/3600)); 
            N=length(Stages);
            tempDur=[ones(N,1)*[a,man],[1:N]',nan(N,12/(t_step/3600))];
            tempSWApfc=tempDur; tempSWAob=tempDur;
            tempSWAzpfc=tempDur; tempSWAzob=tempDur;
            
            for e=1:L % 12h max
                I=intervalSet(sta(e)*1E4,sto(e)*1E4);
                for n=1:N
                    eval(['s_Ep=and(',Stages{n},',I);']);
                    tempDur(n,3+e)=sum(Stop(s_Ep,'s')-Start(s_Ep,'s'));
                    tempSWApfc(n,3+e)=nanmean(Data(Restrict(SWApf{a,man},s_Ep)));
                    tempSWAob(n,3+e)=nanmean(Data(Restrict(SWAob{a,man},s_Ep)));
                    tempSWAzpfc(n,3+e)=nanmean(Data(Restrict(SptsdPFCz,s_Ep)));
                    tempSWAzob(n,3+e)=nanmean(Data(Restrict(SptsdOBz,s_Ep)));
                    if n==7 && tempDur(n,3+e)<15*60 % total rec (without noise)>15min
                        tempDur(:,3+e)=nan(N,1);
                        tempSWApfc(:,3+e)=nan(N,1);
                        tempSWAob(:,3+e)=nan(N,1);
                        tempSWAzpfc(:,3+e)=nan(N,1);
                        tempSWAzob(:,3+e)=nan(N,1);
                    end % noise ! include only recording epochs larger than 20min
                end
            end
            Dur=[Dur;tempDur];
            SWApfc=[SWApfc;tempSWApfc];
            SWAob=[SWAob;tempSWAob];
            SWAzpfc=[SWAzpfc;tempSWAzpfc];
            SWAzob=[SWAzob;tempSWAzob];
        end
    end
end

%%%%%%%%%%%%%%% Save in matrix %%%%%%%%%%%%%%%%%%
CrossC=[CrossC;tempCrossC];
save([analyFolder,'/',analyname,'.mat'],'-append','h_deb_POST','t_deb_POST','Dur',...
    'SWApfc','SWAob','SWAzpfc','SWAzob','nameMouse','Mepochs','Mevents','CrossC','Zsc')
if ~isempty(Bt{1}), bt=Bt{1}; save([analyFolder,'/',analyname,'.mat'],'-append','bt','NameCrossCorr');end

%%%%%%%%%%%%%%% Figure Indiv %%%%%%%%%%%%%%%%%%
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.5 0.7]); numF=gcf;
for n=1:N
    subplot(2,2,1), hold on,
    percRec=100*tempDur(n,5:end)./tempDur(7,5:end);
    plot([1:12/(t_step/3600)]*t_step/3600,percRec,'.-','Color',colori(n,:),'Linewidth',2); xlim([0.5 12.5])
    ylabel('% TOTAL REC'); xlabel('Time (h)'); title([nameMouse{a,man},', ',nameSessions{man}])
    
    subplot(2,2,2), hold on,
    percSleep=100*tempDur(n,5:end)./tempDur(8,5:end);
    if n<7, plot([1:12/(t_step/3600)]*t_step/3600,percSleep,'.-','Color',colori(n,:),'Linewidth',2);end
    ylabel('% SLEEP'); xlabel('Time (h)'); title('Substages'); xlim([0.5 12.5])
    
    subplot(2,2,3), hold on,
    plot([1:12/(t_step/3600)]*t_step/3600,tempSWApfc(n,5:end),'.-','Color',colori(n,:),'Linewidth',2)
    title('SWA PFCx');xlabel('Time (h)'); xlim([0.5 12.5])
    
    subplot(2,2,4), hold on,
    plot([1:12/(t_step/3600)]*t_step/3600,tempSWAob(n,5:end),'.-','Color',colori(n,:),'Linewidth',2)
    title('SWA OB');xlabel('Time (h)'); xlim([0.5 12.5])
end
legend(Stages)
saveFigure(numF.Number,['AnalyseNREM_OR_',nameMouse{a,man},'_',nameSessions{man}],[saveFolder,'/FigureIndiv']); close
           
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< POOL <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%'h_deb','Dur','SWApfc','SWAob','nameMouse','Mepochs','Mevents','CrossC'
% indMAT=[a,man,str2num(nameMouse{a,man}(6:8))];
% Stages={'WAKE','REM','N1','N2','N3','NREM','Total','SLEEP'};
for f=1:4
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.5 0.4]),numF(f)=gcf;
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.5 0.4]),numG(f)=gcf;
    for n=1:6
        for man=1:3
            if f==1
                ind=find(Dur(:,2)==man & Dur(:,4)==n);
                indTot=find(Dur(:,2)==man & Dur(:,4)==7);
                MAT=100*Dur(ind,5:end)./Dur(indTot,5:end); ytit='Duration (%tot rec)';
            elseif f==2
                ind=find(Dur(:,2)==man & Dur(:,4)==n);
                indSleep=find(Dur(:,2)==man & Dur(:,4)==8);
                MAT=100*Dur(ind,5:end)./Dur(indSleep,5:end); ytit='Duration (%sleep)';
            elseif f==3
                %MAT=SWApfc(find(SWApfc(:,2)==man & SWApfc(:,4)==n),5:end); ytit='SWApfc';
                MAT=SWAzpfc(find(SWAzpfc(:,2)==man & SWAzpfc(:,4)==n),5:end); ytit='SWApfc (zscore)';
            elseif f==4
                %MAT=SWAob(find(SWAob(:,2)==man & SWAob(:,4)==n),5:end); ytit='SWAob';
                MAT=SWAzob(find(SWAzob(:,2)==man & SWAzob(:,4)==n),5:end); ytit='SWAob (zscore)';
            end
            % display
            figure(numF(f)),subplot(2,3,n), hold on
            if man==1, colo=[0 0 0]; elseif man==2, colo=colori(n,:); else, colo=[0.5 0.5 0.5];end
            errorbar([1:12/(t_step/3600)]*t_step/3600,nanmean(MAT,1),stdError(MAT),'Color',colo,'Linewidth',2)
            xlabel('Time (h)'); ylabel(ytit)
            figure(numG(f)),subplot(2,3,n), hold on
            plot([1:12/(t_step/3600)]*t_step/3600,MAT,'Color',colo,'Linewidth',2)
            xlabel('Time (h)'); ylabel(ytit)
        end
        title(Stages{n},'Color',colori(n,:)); if f<3, ylim([0 100]);end
        figure(numF(f));title(Stages{n},'Color',colori(n,:)); if f<3, ylim([0 100]);end
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


%% temporary code
figure
for a=1:size(Dir,1)
    for man=1:3
        disp(' ');disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ')
        disp(Dir{a,man});cd(Dir{a,man});
        clear WAKE REM N1 N2 N3 NamesStages SleepStages
        % Substages
        disp('- RunSubstages.m')
        [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages;close;
        NREM=or(or(N1,N2),N3);
        NREM=mergeCloseIntervals(NREM,10);
        SLEEP=or(NREM,REM);
        SLEEP=mergeCloseIntervals(SLEEP,10);
        Total=or(SLEEP,WAKE);
        Total=mergeCloseIntervals(Total,10);
        Total=CleanUpEpoch(Total);
        
        NewtsdZT=GetZT_ML;
        rgZT=Range(NewtsdZT);
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
        if ~isempty(indOR),t_deb_POST(a,man)=tpsfin{indOR(end)};else, t_deb_POST(a,man)=0;end
        Post_Epoch=intervalSet(t_deb_POST(a,man)*1E4,tpsfin{end}*1E4); % time in 10E-4 second
        h_deb_POST(a,man)=mod(min(Data(Restrict(NewtsdZT,Post_Epoch))/1E4)/3600,24)*3600;
        if h_deb_POST(a,man)/3600<9
            t_deb_POST(a,man)=9*3600 - h_deb_POST(a,man);
            Post_Epoch=intervalSet(t_deb_POST(a,man)*1E4,tpsfin{end}*1E4); % time in 10E-4 second
            h_deb_POST(a,man)=mod(min(Data(Restrict(NewtsdZT,Post_Epoch))/1E4)/3600,24)*3600;
        end
        disp(h_deb_POST(a,man)/3600)
        delay_rec=h_deb_POST(a,man)-9*3600; % starts at 9am
        n_nan=floor(delay_rec/t_step);
        sta=zeros(1,n_nan);sto=zeros(1,n_nan); % empty blocks
        sta=[sta,max(0,n_nan*t_step-delay_rec)]; % first block start
        sto=[sto,min(t_step,t_step+n_nan*t_step-delay_rec)]; %first block end
        num_step=ceil((max(Stop(Total,'s'))-sto(end))/ t_step);
        sta=[sta,sto(end)+[0:1:num_step-1]*t_step];
        sto=[sto,sto(end)+[1:num_step]*t_step];
        sta=sta+t_deb_POST(a,man); sto=sto+t_deb_POST(a,man);
        
        hold on, plot((min(Data(NewtsdZT))/1E4+sta)/3600, (4*(a-1)+man)*ones(length(sta),1),'o-')
        hold on, plot((min(Data(NewtsdZT))/1E4+sto)/3600, (4*(a-1)+man)*ones(length(sto),1),'.k')
    end
end

