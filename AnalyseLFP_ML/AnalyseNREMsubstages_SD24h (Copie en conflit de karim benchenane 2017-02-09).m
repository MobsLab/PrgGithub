%AnalyseNREMsubstages_SD24h.m
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
% CaracteristicsSubstagesML.m

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

donoise=1; % to include noise within WAKE periods
f_swa=[2 5]; %Hz

analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
analyname='AnalyNREMsubstagesSD24h';

saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/SleepDeprivation24h';
savFigure=0;
colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 0.5];

%t_step=30*60; % in second
t_step=60*60; % in second (default 1h)
%t_step=120*60;

nam={'',''};
if floor(t_step/3600)~=0, nam{1}=sprintf('%dh',floor(t_step/3600));else,nam{2}='min';end 
if rem(t_step,3600)~=0,nam{2}=[sprintf('%d',floor(rem(t_step,3600)/60)),nam{2}];end
analyname=[analyname,'_',nam{1},nam{2},'Step'];

if donoise, analyname=[analyname,'_Wnz'];end

[params,movingwin,suffix]=SpectrumParametersML('low');
FileToSave=['SpectrumData',suffix];

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
nameSessions{1}='DayBSL';
nameSessions{2}='nightBSL';
nameSessions{3}='DayPostSD';
nameSessions{4}='nightPostSD';
nameSessions{5}='DaySD+24h';
nameSessions{6}='nightSD+24h';

% ------------ 294 ------------
Dir{1,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160906';
Dir{1,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160906-night';% very short, rest is noise
Dir{1,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160908';
Dir{1,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160908-night';
Dir{1,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160909';
Dir{1,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160909-night';

% ------------ 330 ------------
Dir{2,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906';
Dir{2,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906-night';
Dir{2,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160908';
Dir{2,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160908-night';
Dir{2,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160909';
Dir{2,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160909-night';

% ------------ 394 ------------
Dir{3,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906';
Dir{3,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906-night';
Dir{3,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908';
Dir{3,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908-night';
Dir{3,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909';
Dir{3,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909-night';

% ------------ 395 ------------
Dir{4,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906';
Dir{4,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906-night';
Dir{4,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160908';
Dir{4,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160908-night';
Dir{4,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160909';
Dir{4,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160909-night';

% ------------ 400 ------------
Dir{5,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913';
Dir{5,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913-night';
Dir{5,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160915';
Dir{5,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160915-night';
Dir{5,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160916';
Dir{5,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160916-night';

% ------------ 403 ------------
Dir{6,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
Dir{6,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913-night';
Dir{6,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915';
Dir{6,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915-night';
Dir{6,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916';
Dir{6,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916-night';

% ------------ 450 ------------
Dir{7,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
Dir{7,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913-night';
Dir{7,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915';
Dir{7,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915-night';
Dir{7,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916';
Dir{7,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916-night';

% ------------ 451 ------------
Dir{8,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
Dir{8,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913-night';
Dir{8,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915';
Dir{8,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915-night';
Dir{8,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916';
Dir{8,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916-night';


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< LOAD DATA IF EXIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
DoAnalysis=0;
try
    clear durEp;
    load([analyFolder,'/',analyname,'.mat']);
    durEp;
    disp([analyname,'.mat already exists... loaded.'])
catch
    DoAnalysis=1;
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< COMPUTE SD EFFECT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

if DoAnalysis
    
    % <<<<<<<<<<<<<<<<<<<<< Get Behavioral experiments <<<<<<<<<<<<<<<<<<<<
    Epochs={}; nameMouse={}; 
    Delt={}; SWApf={}; SWAob={};
    h_deb=nan(size(Dir,1),length(nameSessions)/2);
    for a=1:size(Dir,1)
        for man=1:length(nameSessions)
            disp(' '); disp('------------------------------------------')
            disp(Dir{a,man}); cd(Dir{a,man});
            nameMouse{a}=Dir{a,man}(max(strfind(Dir{a,man},'Mouse'))+[0:7]);
            
            % -------------------------------------------------------------
            % get substages
            clear WAKE REM N1 N2 N3 NREM Total
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(Dir{a,man});
            close
            if donoise, WAKE=WAKEnoise;end   % optional !!
            NREM=or(N1,or(N3,N2))-noise; mergeCloseIntervals(NREM,10);
            SLEEP=or(NREM,REM);mergeCloseIntervals(SLEEP,10);
            Total=or(SLEEP,WAKE); mergeCloseIntervals(Total,10);
            
            Stages={'WAKE','REM','N1','N2','N3','NREM','Total','SLEEP'};
            
            % get time of the day
            NewtsdZT=GetZT_ML(Dir{a,man});
            rgZT=Range(NewtsdZT);
            
            % get SWA
            % -------------- Get channel for PFCx and OB ------------------
            clear channel1 channel2 channel Sptsd1 Sptsd2
            % load channel
            load('LFPData/InfoLFP.mat');
            channel1=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx') & InfoLFP.depth==0);
            if isempty(channel1), try  load('ChannelsToAnalyse/PFCx_sup.mat'); channel1=channel;end;end
            try clear channel; load('ChannelsToAnalyse/Bulb_deep.mat'); channel2=channel;end
            
            % -------------- ComputeSpectrogram_newML.m ------------------
            for cha=1:2
                clear LFP channel LFP_temp Sp t f Sptsd
                eval(sprintf('channel=channel%d;',cha))
                if ~isempty(channel)
                    try
                        load([FileToSave,'/Spectrum',num2str(channel)],'t','f','Sp');
                        fsamp=f; disp([' LFP',num2str(channel),'. Spectum loaded.'])
                    catch
                        disp([' LFP',num2str(channel),'. Computing spectrum...'])
                        load(['LFPData/LFP',num2str(channel)],'LFP');
                        % calculate Sp for given LFP
                        LFP_temp=ResampleTSD(LFP,params.Fs);
                        [Sp,t,f]=mtspecgramc(Data(LFP_temp),movingwin,params);
                        Spi=Sp; ti=t; freqfi=f;
                        if ~exist(FileToSave,'dir'); mkdir(FileToSave);end
                        save([FileToSave,'/Spectrum',num2str(channel)],'-v7.3','Sp','t','f','params','movingwin');
                    end
                    % SWA spectrum
                    Sptsd=tsd(t*1E4,mean(Sp(:,f>=f_swa(1) & f<f_swa(2)),2));
                else
                    Sptsd=tsd([],[]);
                end
                eval(sprintf('Sptsd%d=Sptsd;',cha))
            end
            % -------------- Load Delta ------------------
            Dpfc=GetDeltaML;
            
            % concatenate day and night epochs
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
                SWApf{a,man/2}=tsd([Range(tempSWApf);Range(Sptsd1)+delay],[Data(tempSWApf);Data(Sptsd1)]);
                SWAob{a,man/2}=tsd([Range(tempSWAob);Range(Sptsd2)+delay],[Data(tempSWAob);Data(Sptsd2)]);
               
                if sum(Stop(Ep{7},'s')-Start(Ep{7},'s'))>3600*24; disp('PROBLEM: Too long');keyboard;end
                %PlotPolysomnoML(Ep{3},Ep{4},Ep{5},Ep{6},Ep{2},Ep{1}); 
                %title([nameMouse{a},' ',nameSessions{man-1},' and ',nameSessions{man}])
                %keyboard
            else
                i_stop=mod(max(Data(NewtsdZT))/3600/1E4,24)*3600*1E4;
                i_L=max(Range(NewtsdZT))-min(Range(NewtsdZT));
                for n=1:length(Stages)
                    eval(['temp',Stages{n},'=',Stages{n},';'])
                end
                h_deb(a,(man+1)/2)=mod(min(Data(NewtsdZT)/1E4)/3600,24);
                
                tempDelt=Dpfc;
                tempSWApf=Sptsd1;
                tempSWAob=Sptsd2;
            end
            disp('Done.')
        end
    end
    % saving
    save([analyFolder,'/',analyname,'.mat'],'Dir','t_step','Stages','Epochs','h_deb','nameMouse',...
        'Delt','SWApf','SWAob','f_swa')
end
   
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< ANALYZE STAGES AND SWA ON ZT <<<<<<<<<<<<<<<<<<<<<<<< 

if DoAnalysis
    
    durEp=[];
    SW=[];% manipe condition stage duration structure SWAonTotal SWAzt->
    for a=1:size(Dir,1)
        clear muPF sigPF muOB sigOB
        for i=1:length(nameSessions)/2
            
            % <<<<<<<<<<<<<<<<<< Get & display epochs <<<<<<<<<<<<<<<<<<<<<
            Ep=Epochs{a,i};
            PlotPolysomnoML(Ep{3},Ep{4},Ep{5},Ep{6},Ep{2},Ep{1}); 
            title([nameMouse{a},' ',nameSessions{2*i-1},' and ',nameSessions{2*i}])
            %close
            
            
            % <<<<<<<<<<<<<<<<<< Prepare ZT timesteps <<<<<<<<<<<<<<<<<<<<<
            delay_rec=(h_deb(a,i)-9)*3600; % starts at 9am
            n_nan=floor(delay_rec/t_step);
            sta=zeros(1,n_nan);sto=zeros(1,n_nan); % empty blocks
            sta=[sta,max(0,n_nan*t_step-delay_rec)]; % first block start
            sto=[sto,min(t_step,t_step+n_nan*t_step-delay_rec)]; %first block end
            
            num_step=ceil((max(Stop(Ep{7},'s'))-sto(end))/ t_step);
            sta=[sta,sto(end)+[0:1:num_step-1]*t_step];
            sto=[sto,sto(end)+[1:num_step]*t_step];
            
            
            % <<<<<<<<<<<<<<<<<<<<<< Get SWA & delta <<<<<<<<<<<<<<<<<<<<<<
            sp{1}=Delt{a,i};
            if i==1
                [Z,muPF,sigPF] = zscore(Data(Restrict(SWApf{a,i},Ep{8}))); % zscore on sleep
                [Z,muOB,sigOB] = zscore(Data(Restrict(SWAob{a,i},Ep{8})));% zscore on sleep
            end
            sp{2}=tsd(Range(SWApf{a,i}),(Data(SWApf{a,i})-muPF)/sigPF);
            sp{3}=tsd(Range(SWAob{a,i}),(Data(SWAob{a,i})-muOB)/sigOB);
            
            N=length(Stages);
            tempSW=nan(N*3,6+24/(t_step/3600));
            tempSW(:,1:3)=[ones(N*3,1)*[a,i],[1:N,1:N,1:N]'];
            for stru=1:3
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
            
            tempDur=nan(length(Stages),3+24/(t_step/3600));
            tempDur(:,1:2)=ones(length(Stages),1)*[a,i];
            tempDur(:,3)=1:length(Stages);
            
            L=min(length(sta),24/(t_step/3600));
            for e=1:L % 24h max
                I=intervalSet(sta(e)*1E4,sto(e)*1E4);
                for n=1:length(Stages)
                    s_Ep=and(Ep{n},I);
                    tempDur(n,3+e)=sum(Stop(s_Ep,'s')-Start(s_Ep,'s'));
                    if n==7 && tempDur(n,3+e)==0 % total rec (without noise)
                        tempDur(:,3+e)=nan(length(Stages),1);
                    end % noise ! include only recording epochs larger than 20min
                    
                    for stru=1:3
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
    save([analyFolder,'/',analyname,'.mat'],'-append','durEp','SW')
    
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< DISPLAY ZT RESULTS INDIV <<<<<<<<<<<<<<<<<<<<<<<<<<<
NameSess={'BSL','PostSD','+24h'};
L=3; % 3 to include expe at +24h
Rainbo=[0 0 0;1 0 0; 1 0.5 0; 0.9 0.9 0; 0 0.5 0; 0 1 1; 0 0 1; 0.5 0 0.5];
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% plot indiv data
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.85 0.85]), numF1=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.85 0.85]), numF2=gcf;
for n=1:6
    Mt=[]; Ms=[];
    for i=1:L
        ind1=find(durEp(:,2)==i & durEp(:,3)==n);
        ind2=find(durEp(:,2)==i & durEp(:,3)==7);%total time
        ind3=find(durEp(:,2)==i & durEp(:,3)==8);%SLEEP
        Mt=[Mt,100*durEp(ind1,4:end)./durEp(ind2,4:end)];
        if n==1, Ms=[Ms,100*durEp(ind3,4:end)./durEp(ind2,4:end)];
        else, Ms=[Ms,100*durEp(ind1,4:end)./durEp(ind3,4:end)]; end
    end
    figure(numF1),subplot(6,1,n),PP=plot([1:size(Mt,2)]*t_step/3600,Mt','.-','Linewidth',1.2);
    for pp=1:size(Mt,1), PP(pp).Color=Rainbo(pp,:);end
    ylabel({Stages{n},'(%rec)'},'Color',colori(n,:))
    hold on, line(0.5+12*[1:5;1:5],ylim'*ones(1,5),'Color',[0.5 0.5 0.5]); xlim([0.5 72.5])
    line([24.5,24.5],ylim,'Color','k','Linewidth',1.5);
    
    figure(numF2),subplot(6,1,n),PP=plot([1:size(Ms,2)]*t_step/3600,Ms','.-','Linewidth',1.2);
    for pp=1:size(Ms,1), PP(pp).Color=Rainbo(pp,:);end
    ylabel({Stages{n},'(%sleep)'},'Color',colori(n,:))
    if n==1, ylabel({'SLEEP','(%sleep)'},'Color','b');end
    hold on, line(0.5+12*[1:5;1:5],ylim'*ones(1,5),'Color',[0.5 0.5 0.5]); xlim([0.5 72.5])
    line([24.5,24.5],ylim,'Color','k','Linewidth',1.5);
end
figure(numF1),xlabel('ZT Time (h)');subplot(6,1,1),
legend(nameMouse);text(22,1.2*max(ylim),'24hSD');text(24,1.1*max(ylim),'V');
text(5+12*[0:5],1.1*max(ylim)*ones(1,6),{'day','night','day','night','day','night'})
figure(numF2),xlabel('ZT Time (h)');subplot(6,1,1),
legend(nameMouse);text(22,1.25*max(ylim),'24hSD');text(24,1.1*max(ylim),'V');
text(5+12*[0:5],1.1*max(ylim)*ones(1,6),{'day','night','day','night','day','night'})

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< DISPLAY ZT RESULTS POOLED <<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.85 0.85]), numF1=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.85 0.85]), numF2=gcf;
for n=1:6
    clear Mt1 Mt2 Mt3 Ms1 Ms2 Ms3
    for i=1:L
        ind1=find(durEp(:,2)==i & durEp(:,3)==n);
        ind2=find(durEp(:,2)==i & durEp(:,3)==7);%total time
        ind3=find(durEp(:,2)==i & durEp(:,3)==8);%SLEEP
        Mt=100*durEp(ind1,4:end)./durEp(ind2,4:end);
        Ms=100*durEp(ind1,4:end)./durEp(ind3,4:end);
        if n==1, Ms=100*durEp(ind3,4:end)./durEp(ind2,4:end);end
        
        eval(sprintf('Mt%d=Mt; Ms%d=Ms;',i,i));
        if i==1, colo=[0 0 0]; elseif i==2, colo=colori(n,:);  else, colo=[0.5 0.5 0.5]; end
        
        figure(numF1),subplot(3,2,n), hold on,
        errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(Mt,1),stdError(Mt),'Linewidth',2,'Color',colo);
        
        figure(numF2),subplot(3,2,n), hold on,
        if i==2 && n==1, colo=[0 0 1];end   
        errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(Ms,1),stdError(Ms),'Linewidth',2,'Color',colo);
        if n==1, plot([1:24/(t_step/3600)]*t_step/3600,sum(~isnan(Ms),1),'.-','Color',colo);end% n across ZT
    end
    
    %stats
    pvalt1=nan(1,24/(t_step/3600)); pvalt2=pvalt1; pvalt3=pvalt1;
    pvals1=nan(1,24/(t_step/3600)); pvals2=pvals1; pvals3=pvals1;
    for k=1:24/(t_step/3600)
        if 0
            namtest='signrank';
            try pt1=signrank(Mt1(:,k),Mt2(:,k));end; try ps1=signrank(Ms1(:,k),Ms2(:,k));end
            try pt2=signrank(Mt1(:,k),Mt3(:,k));end; try ps2=signrank(Ms1(:,k),Ms3(:,k));end
            try pt3=signrank(Mt2(:,k),Mt3(:,k));end; try ps2=signrank(Ms2(:,k),Ms3(:,k));end
        else
            namtest='ttest';
            try [h,pt1]=ttest2(Mt1(:,k),Mt2(:,k));end; try [h,ps1]=ttest2(Ms1(:,k),Ms2(:,k));end
            try [h,pt2]=ttest2(Mt1(:,k),Mt3(:,k));end; try [h,ps2]=ttest2(Ms1(:,k),Ms3(:,k));end
            try [h,pt3]=ttest2(Mt2(:,k),Mt3(:,k));end; try [h,ps3]=ttest2(Ms2(:,k),Ms3(:,k));end
        end
        if pt1<0.05, pvalt1(k)=max(ylim);end; if ps1<0.05, pvals1(k)=max(ylim);end
        if pt2<0.05, pvalt2(k)=0.93*max(ylim);end; if ps2<0.05, pvals2(k)=0.93*max(ylim);end
        if pt3<0.05, pvalt3(k)=0.86*max(ylim);end; if ps3<0.05, pvals3(k)=0.86*max(ylim);end
    end
    
    figure(numF1),xlim([0 25]); xlabel('ZT Time (h)'); ylabel('% total rec');
    title(sprintf([Stages{n},' (n=%d)'],length(~isnan(nanmean(Mt,2)))),'Color',colori(n,:))
    plot([1:24/(t_step/3600)],pvalt1,'*r')
    %try plot([1:24/(t_step/3600)],pvalt2,'*m'); plot([1:24/(t_step/3600)],pvalt3,'*c');end
    line([12.5 12.5],ylim,'Color',[0.5 0.5 0.5])
    
    figure(numF2),xlim([0 25]); xlabel('ZT Time (h)'); ylabel('% sleep');
    title(sprintf([Stages{n},' (n=%d)'],length(~isnan(nanmean(Ms,2)))),'Color',colori(n,:))
    if n==1, title(sprintf(['SLEEP (n=%d)'],length(~isnan(nanmean(Ms,2)))),'Color','b'); ylabel('% total rec');end
    plot([1:24/(t_step/3600)],pvals1,'*r')
    %try plot([1:24/(t_step/3600)],pvals2,'*m'); plot([1:24/(t_step/3600)],pvals3,'*c');end
    line([12.5 12.5],ylim,'Color',[0.5 0.5 0.5])
    
end
legend([NameSess(1:L),namtest])
figure(numF1),legend([NameSess(1:L),namtest])
% save Figure
if savFigure, saveFigure(numF1,'BilanEvolSD24h-total',saveFolder);end
if savFigure, saveFigure(numF2,'BilanEvolSD24h-sleep',saveFolder);end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< DISPLAY INDIV RESULTS SWA <<<<<<<<<<<<<<<<<<<<<<<<<<
L=3;
namestru={'delta','SWApf','SWAob'};
for stru=1:3
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.85 0.85]),
    for n=1:6
        M=[];
        for i=1:L
            M=[M,SW(find(SW(:,2)==i & SW(:,3)==n & SW(:,4)==stru),7:end)];
        end
        %hold off;
        subplot(6,1,n), 
        PP=plot([1:size(M,2)]*t_step/3600,M','.-','Linewidth',1.2);ylabel({Stages{n},namestru{stru}},'Color',colori(n,:))
        for pp=1:size(M,1), PP(pp).Color=Rainbo(pp,:);end
        hold on, line(0.5+12*[1:5;1:5],ylim'*ones(1,5),'Color',[0.5 0.5 0.5]); xlim([0.5 72.5])
        line([24.5,24.5],ylim,'Color','k','Linewidth',1.5);
    %legend(nameMouse);keyboard
    end
    xlabel('ZT Time (h)');subplot(6,1,1),
    legend(nameMouse);text(22,1.2*max(ylim),'24hSD');text(24,1.1*max(ylim),'V');
    text(5+12*[0:5],1.1*max(ylim)*ones(1,6),{'day','night','day','night','day','night'})
    
%     close 
%     figure('Color',[1 1 1]);
%     PP=plot([1:size(M,2)]*t_step/3600,M','.-','Linewidth',1.2);ylabel({Stages{n},namestru{stru}},'Color',colori(n,:))
%     for pp=1:size(M,1), PP(pp).Color=Rainbo(pp,:);end
%     hold on, line(0.5+12*[1:5;1:5],ylim'*ones(1,5),'Color',[0.5 0.5 0.5]); xlim([0.5 72.5])
%     line([24.5,24.5],ylim,'Color','k','Linewidth',1.5); xlabel('ZT Time (h)');
%     legend(nameMouse);text(22,1.2*max(ylim),'24hSD');text(24,1.1*max(ylim),'V');
%     text(5+12*[0:5],1.1*max(ylim)*ones(1,6),{'day','night','day','night','day','night'})
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DISPLAY POOLED RESULTS SWA <<<<<<<<<<<<<<<<<<<<<<<
for stru=1:3
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.85 0.85])
    for n=1:6
        clear M1 M2 M3
        for i=1:L
            M=SW(find(SW(:,2)==i & SW(:,3)==n & SW(:,4)==stru),7:end);
            eval(sprintf('M%d=M; ',i));
            if i==1, colo=[0 0 0]; elseif i==2, colo=colori(n,:);  else, colo=[0.5 0.5 0.5]; end
            subplot(3,2,n), hold on,
            errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(M,1),stdError(M),'Linewidth',2,'Color',colo);
        end
        
        %stats
        pvalt1=nan(1,24/(t_step/3600)); pvalt2=pvalt1; pvalt3=pvalt1;
        for k=1:24/(t_step/3600)
            if 0
                namtest='signrank';
                try pt1=signrank(M1(:,k),M2(:,k));end; 
                try pt2=signrank(M1(:,k),M3(:,k));end; 
                try pt3=signrank(M2(:,k),M3(:,k));end; 
            else
                namtest='ttest';
                try [h,pt1]=ttest2(M1(:,k),M2(:,k));end;
                try [h,pt2]=ttest2(M1(:,k),M3(:,k));end; 
                try [h,pt3]=ttest2(M2(:,k),M3(:,k));end; 
            end
            if pt1<0.05, pvalt1(k)=max(ylim);end; 
            if pt2<0.05, pvalt2(k)=0.93*max(ylim);end; 
            if pt3<0.05, pvalt3(k)=0.86*max(ylim);end; 
        end
        
        xlim([0 25]); xlabel('ZT Time (h)'); ylabel(namestru{stru});
        title(sprintf([Stages{n},' (n=%d)'],length(~isnan(nanmean(M,2)))),'Color',colori(n,:))
        plot([1:24/(t_step/3600)],pvalt1,'*r')
        plot([1:24/(t_step/3600)],pvalt2,'*','Color',[1 0.2 0.8])
        plot([1:24/(t_step/3600)],pvalt3,'*r','Color',[1 0.5 0.2])
        line([12.5 12.5],ylim,'Color',[0.5 0.5 0.5])
    end
    legend([NameSess(1:L),{[namtest,' B/P']},'B/+24h','P/+24h'])
    % save Figure
    if savFigure, saveFigure(numF2,['BilanEvolSD24h-',namestru{stru}],saveFolder);end
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<< DISPLAY RESULTS FOR FIRST SLEEP HOUR <<<<<<<<<<<<<<<<<<<<
ploindiv=0;
Th=1:1.5:6; %first hours of sdefault 1, choose a maximum of 4 values
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.65 0.24*length(Th)]), numF=gcf;
MAT1h=nan(length(Th),size(Dir,1),length(nameSessions)/2,6);
for tt=1:length(Th)
    Mb=nan(size(Dir,1)*(length(nameSessions)/2+1),6);
    for a=1:size(Dir,1)
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
for a=1:size(Dir,1)
    for i=1:length(nameSessions)/2
        Ep=Epochs{a,i};
        TotDur=sum(Stop(Ep{7},'s')-Start(Ep{7},'s'));
        for n=1:6
            MATep(a,i,n)=100*sum(Stop(Ep{n},'s')-Start(Ep{n},'s'))/TotDur;
        end
        
    end
end

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.85 0.85]),
for n1=1:6
    for n2=1:6
        subplot(6,6,6*(n1-1)+n2), hold on,
        try
        M1=squeeze(MATep(:,:,n1));
        M2=squeeze(MATep(:,:,n2));
        plot(M1(:,1),M2(:,1),'.','Color','k')
        plot(M1(:,2),M2(:,2),'.','Color',colori(n2,:))
        plot(M1(:,3),M2(:,3),'.','Color',[0.5 0.5 0.5])
        ylabel(Stages{n2}); xlabel(Stages{n1})
        end
    end
end