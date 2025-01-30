% AnalyseNREMsubstages_N1versusImmob.m

% list of related scripts in NREMstages_scripts.m 
% CodePourMarieCrossCorrDeltaSpindlesRipples.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/N1versusImmob';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalyseNREMsubstagesNew';
analyname='AnalySubstagesN1versusImmob';

Dir1=PathForExperimentsMLnew('BASALlongSleep');
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

mergeSleep=3; %s
MATNameEpoch={'N1','N2','N3','REM','WAKE','StillN1','StillWake','WakeMov','WstillW','SstillS','WstillW5s','SstillS5s','Immob'};
[params]=SpectrumParametersML('newlow');
Fsamp=0.5:0.05:20;
Fs=1250;

colori=[ 0.5 0.2 1 ; 1 0.2 0.8 ;1 0 0; 0 0 0;0.5 0.5 0.5; 0 0 1; 0.1 0.7 0.6  ;0 0.8 0;  0 0 0;1 0 0.5;0.5 0.5 0.5; 0 0 1];
plotindiv=1; 
saveFig=0;

%% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    load([res,'/',analyname]);
catch
    MAT=nan(length(Dir.path),4);
    MATEpoch={};
    MATtsdZT={}; 
    MATPF=nan(length(Dir.path),length(MATNameEpoch),length(Fsamp));
    MATHP=MATPF;
    MATemg=nan(length(Dir.path),length(MATNameEpoch),1000);
    MATmov=MATemg;
    for man=1:length(Dir.path)
        disp(' ');disp(Dir.path{man})
        cd(Dir.path{man})
        
        clear WAKE REM N1 N2 N3 SleepStages
        clear NewtsdZT Immob StillWake StillN1 SstillS WstillW SstillS5s WstillW5s
        try
            disp('Loading Substages...')
            [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close;
            
            load NREMepochsML.mat opNew op NamesOp Dpfc Epoch noise
            NewtsdZT=GetZT_ML(Dir.path{man});
            
            % --------------------------------------
            % ---- Immobility ----
            clear Movtsd MovAcctsd MovThresh Immob
            clear GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch
            
            load('StateEpochSubStages.mat','Immob','WholeEpoch')
            Immob;
            
            if 1%~exist('Immob','var') % recalculating Immob
                load('behavResources.mat','Movtsd','MovAcctsd')
                if ~exist('Movtsd','var'), Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));end
                rg=Range(Movtsd);
                val=SmoothDec(Data(Movtsd),5);
                Mmov=tsd(rg(1:10:end),val(1:10:end));
                WholeEpoch=intervalSet(min(rg),max(rg));
                
                try
                    load StateEpoch.mat MovThresh GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch
                catch
                    okThresh='n';
                    while okThresh~='y'
                        figure, plot(Range(Mmov,'s'),Data(Mmov)); numfthr=gcf;
                        MovThresh=GetGammaThresh(Data(Mmov));close
                        MovThresh=exp(MovThresh);
                        tempImmob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
                        figure(numfthr), hold on, plot(Range(Restrict(Mmov,tempImmob),'s'),Data(Restrict(Mmov,tempImmob)),'r')
                        okThresh=input('Are you ok with threshold for movement (y/n): ','s');close(numfthr)
                    end
                end
                try
                    noise=or(GndNoiseEpoch,NoiseEpoch);
                    try noise=or(noise,WeirdNoiseEpoch);end
                    noise=CleanUpEpoch(noise);
                    noise=mergeCloseIntervals(noise,1);
                catch
                    load('StateEpochSubStages.mat','noise');
                end
                
                % sleep
                Immob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
                Immob=Immob-noise;
                sleep=mergeCloseIntervals(Immob,mergeSleep*1E4);
                sleep=dropShortIntervals(sleep,mergeSleep*1E4);
                Immob=mergeCloseIntervals(Immob,1E3);% merge 100ms
                Immob=dropShortIntervals(Immob,1E3); % minimum 100ms
            end
            
            Immob=CleanUpEpoch(Immob);
            WholeEpoch=CleanUpEpoch(WholeEpoch);
            
            Still=Immob-REM;Still=mergeCloseIntervals(Still,1);
            Still=Immob-N2;Still=mergeCloseIntervals(Still,1);
            Still=Immob-N3;Still=mergeCloseIntervals(Still,1);
            WakeMov=WholeEpoch-Immob;WakeMov=mergeCloseIntervals(WakeMov,1);
            WakeMov=WakeMov-noise;WakeMov=mergeCloseIntervals(WakeMov,1);
            
            StillN1=and(Still,N1); StillN1=mergeCloseIntervals(StillN1,1);
            StillWake=and(Still,WAKE); StillWake=mergeCloseIntervals(StillWake,1);
      

            
            % ---------------------------------
            % ---- transition between stages----
            
            NamStag={'WakeMov','Still','N2','N3','REM'};
            idWake=find(strcmp('WakeMov',NamStag));
            idStill=find(strcmp('Still',NamStag));
            idRest=3:5;
            
            SleepStages=[];
            disp('Calculating SleepStages...')
            for n=1:length(NamStag)
                eval(['epoch=',NamStag{n},';'])
                SleepStages=[SleepStages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
            end
            SleepStages=sortrows(SleepStages,1);
            
            
            M=SleepStages;
            M(:,4:5)=[[0,0];SleepStages(1:end-1,[1,3])]; % stage before
            M(:,6:7)=[SleepStages(2:end,[2,3]);[0,0]]; % stage after
            
            % find Immob surrounded by wake
            idww=find(M(:,3)==idStill & M(:,5)==idWake & M(:,7)==idWake);
            
            % find Immob surrounded by sleep (N2 N3 or REM)
            idss=find(M(:,3)==idStill & ismember(M(:,5),idRest) & ismember(M(:,7),idRest));
            
            WstillW=intervalSet(M(idww,1)*1E4,M(idww,2)*1E4);
            SstillS=intervalSet(M(idss,1)*1E4,M(idss,2)*1E4);
            WstillW5s=intervalSet((M(idww,1)-5)*1E4,M(idww,2)*1E4);WstillW5s=mergeCloseIntervals(WstillW5s,1);
            SstillS5s=intervalSet((M(idss,1)-5)*1E4,M(idss,2)*1E4);SstillS5s=mergeCloseIntervals(SstillS5s,1);
            
            fprintf('\n Mvt/still/Mvt : n=%d episodes; TotalDuration = %dmin.\n',length(idww),floor(sum(diff(M(idww,1:2)')/60)))
            fprintf('(N2,N3,REM)/still/(N2,N3,REM) : n=%d episodes; TotalDuration = %dmin.\n',length(idss),floor(sum(diff(M(idss,1:2)')/60)))
            
            MAT(man,1:4)=[length(idww),sum(diff(M(idww,1:2)')),length(idss),sum(diff(M(idss,1:2)'))];
            
            % -----------------------------
            % ----------- EPOCHS ------------
            MATEpoch(man,1:13)={N1,N2,N3,REM,WAKE,StillN1,StillWake,WakeMov,WstillW,SstillS,WstillW5s,SstillS5s,Immob};
            MATtsdZT{man}=NewtsdZT;
            
            
            % -----------------------------
            % ------ load EMG ------------
            clear InfoLFP emg tsdEMG LFP
            load('LFPData/InfoLFP.mat');
            emg=InfoLFP.channel(min([find(strcmp(InfoLFP.structure,'EMG')),find(strcmp(InfoLFP.structure,'emg'))]));
            if ~isempty(emg)
                disp('Loading and filtering EMG channel... WAIT...')
                load(['LFPData/LFP',num2str(emg),'.mat'],'LFP');
                tsdEMG=FilterLFP(LFP,[50 300], 1024);
                Dt=abs(Data(tsdEMG));rg=Range(tsdEMG,'s');
                dt=SmoothDec(interp1(rg,Dt,rg(1):0.05:rg(end)),10);
                tsdEMG=tsd(1E4*(rg(1):0.05:rg(end))',zscore(dt)); %sample at 25Hz
            else
                disp('no EMG...')
                tsdEMG=tsd([],[]);
            end
        
            % -----------------------------
            % movements and EMG
            for n=1:length(MATNameEpoch)
                clear epoch
                eval(['epoch=',MATNameEpoch{n},';'])
                MATmov(man,n,1)=nanmean(Data(Restrict(zscore(Mmov),epoch)));
                MATemg(man,n,1)=nanmean(Data(Restrict(tsdEMG,epoch)));
                for i=1:length(Start(epoch))
                    MATmov(man,n,1+i)=nanmean(Data(Restrict(zscore(Mmov),subset(epoch,i))));
                    MATemg(man,n,1+i)=nanmean(Data(Restrict(tsdEMG,subset(epoch,i))));
                end
            end
            
            % -----------------------------
            % --- spectrums on stages--------
            clear SpHP SpPFCx
            % PFCx_deep
            [Sp,t,f]=LoadSpectrumML('PFCx_deep');
            SpPFCx=tsd(t*1E4,Sp); fPF=f;
            
            %dHPC
            disp('- ChannelsToAnalyse/dHPC_rip')
            try
                temp=load('AllRipplesdHPC25.mat','chHPC');
                [Sp,t,f]=LoadSpectrumML(temp.chHPC);
                SpHP=tsd(t*1E4,Sp); fHP=f;
            end
            
            % spectrum for each stages
            figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.5 0.6]); numF=gcf;
            yl1=[];yl2=[];
            for n=1:length(MATNameEpoch)
                clear epoch
                eval(['epoch=',MATNameEpoch{n},';'])
               
                %PFCx
                tempF=nanmean(Data(Restrict(SpPFCx,epoch)));
                MATPF(man,n,:)=interp1(fPF,tempF,Fsamp);
                
                try%dHPC
                    tempH=nanmean(Data(Restrict(SpHP,epoch)));
                    MATHP(man,n,:)=interp1(fHP,tempH,Fsamp);
                end
                
                if plotindiv && n<11
                    figure(numF.Number), subplot(2,2,floor(n/6)+1), hold on, 
                    try, plot(fHP,tempH,'Color',colori(n,:),'Linewidth',2); end
                    title('definition Still = Immob -N2 -N3 -REM'); ylabel('HPC'); legend(MATNameEpoch); 
                    if n>5,legend(MATNameEpoch(6:end));else,title(Dir.name{man});end
                    yl1=[yl1,ylim];
                    
                    subplot(2,2,2+floor(n/6)+1), hold on, 
                    plot(fPF,tempF,'Color',colori(n,:),'Linewidth',2)
                    legend(MATNameEpoch); ylabel('PFC')
                    if n>5,legend(MATNameEpoch(6:end));else,title(['                         ',Dir.path{man}]);end
                    yl2=[yl2,ylim];
                end
            end
            if plotindiv  
                for yy=1:2, subplot(2,2,yy),ylim([0 yl1]);subplot(2,2,2+yy),ylim([0 yl2]);end
                if saveFig, saveFigure(numF.Number,['N1versusImmob_',num2str(man)],FolderToSave);close; end
            end
        catch
            disp('Problem'); %keyboard
        end
    end
    save([res,'/',analyname],'MAT','MATimmob','Dir','mergeSleep',...
        'MATEpoch','MATtsdZT','MATNameEpoch','params','Fsamp','Fs','MATPF','MATHP','MATmov','MATemg')
end

%% plot

figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.5 0.4]); numF=gcf;
ido=find(isnan(nanmean(MAT,2))==0);
A=100*MAT(ido,1)./(MAT(ido,1)+MAT(ido,3));
subplot(2,2,1), plotSpread(A,'distributionColors','k');
hold on, line([0.8 1.2],nanmean(A)+[0 0],'Color','k','Linewidth',2); ylim([0 100])
ylabel('% number episode stillWW')
title('Wake-still-Wake vs sleep(REM N2 N3)-still-sleep')
A=MAT(ido,1);
subplot(2,2,2), plotSpread(A,'distributionColors','k');
hold on, line([0.8 1.2],nanmean(A)+[0 0],'Color','k','Linewidth',2); 
ylabel('number episode stillWW')

A=100*MAT(ido,2)./(MAT(ido,2)+MAT(ido,4));
subplot(2,2,3), plotSpread(A,'distributionColors','k');
hold on, line([0.8 1.2],nanmean(A)+[0 0],'Color','k','Linewidth',2); ylim([0 100])
ylabel('% total duration stillWW')
A=MAT(ido,2)/60;
subplot(2,2,4), plotSpread(A,'distributionColors','k');
hold on, line([0.8 1.2],nanmean(A)+[0 0],'Color','k','Linewidth',2); 
ylabel('total duration stillWW (min)')


%% distribution duration immob episode
DurImmob=[];
MATimmob=MATEpoch(:,strcmp(MATNameEpoch,'Immob'));
for man=1:length(Dir.path)
    Immob=MATimmob{man,1};
    try DurImmob=[DurImmob;Stop(Immob,'s')-Start(Immob,'s')];end
end
figure, hist(log10(DurImmob),1000)


%% distribution duration immob episode

try 
    do(1);
catch
    for man=1:length(Dir.path)
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.5 0.6]); F=gcf;
        disp(' ');disp(Dir.path{man})
        yl1=[]; yl2=[];
        for n=1:10
            tempH=squeeze(MATHP(man,n,:));
            tempF=squeeze(MATPF(man,n,:));
            
            subplot(2,2,floor(n/6)+1),hold on,
            try, plot(Fsamp,tempH,'Color',colori(n,:),'Linewidth',2); end
            title('definition Still = Immob -N2 -N3 -REM'); ylabel('HPC'); legend(MATNameEpoch);
            if n>5,legend(MATNameEpoch(6:end));else,title(Dir.name{man});end
            yl1=[yl1,ylim];
            
            subplot(2,2,2+floor(n/6)+1), hold on,
            plot(Fsamp,tempF,'Color',colori(n,:),'Linewidth',2), hold on,
            legend(MATNameEpoch); ylabel('PFC')
            if n>5,legend(MATNameEpoch(6:end));else,title(['                         ',Dir.path{man}]);end
            yl2=[yl2,ylim];
        end
        disp('0=discard all, 111=save all, 011=discard HP, 101=discard wake, 001=discard HP & wake, 100=save only HP')
        do(man)=input('choose : ');
        close(F)
    end
end
DoHP=(do~=0 & do ~=11 & do ~=1 );
DoPFwake=(do==111 | do ==11);
DoPF=(do~=0 & do ~=100);

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.5 0.6]); numF=gcf;
tit1=[];tit2=[];yl1=[]; yl2=[];
for n=1:10
    if ~isempty([strfind(MATNameEpoch,'WAKE'),strfind(MATNameEpoch,'Wake')])
        HP=squeeze(MATHP(find(floor((DoPFwake+DoHP)/2)),n,:));
        PF=squeeze(MATPF(DoPFwake,n,:));
    else
        HP=squeeze(MATHP(DoHP,n,:));
        PF=squeeze(MATPF(DoPF,n,:));
    end
    
    tempH=nanmean(HP,1);
    stdH=stdError(HP);
    tempF=nanmean(PF,1);
    stdF=stdError(PF);
    
    subplot(2,2,floor(n/6)+1),hold on,
    plot(Fsamp,tempH,'Color',colori(n,:),'Linewidth',2); 
    plot(Fsamp,tempH+stdH,'Color',colori(n,:));
    plot(Fsamp,tempH-stdH,'Color',colori(n,:)); 
    title('definition Still = Immob -N2 -N3 -REM'); ylabel('HPC'); 
    if n>5
        tit2=[tit2,{MATNameEpoch{n},'std',' '}];
    else
        tit1=[tit1,{MATNameEpoch{n},'std',' '}];
    end
    yl1=[yl1,ylim];
    
    subplot(2,2,2+floor(n/6)+1), hold on,
    plot(Fsamp,tempF,'Color',colori(n,:),'Linewidth',2), 
    plot(Fsamp,tempF+stdF,'Color',colori(n,:)); 
    plot(Fsamp,tempF-stdF,'Color',colori(n,:)); 
    yl2=[yl2,ylim];
end
subplot(2,2,1),legend(tit1);ylim([0 max(yl1)]); subplot(2,2,2),legend(tit2); ylim([0 max(yl1)]);
subplot(2,2,3),legend(tit1);ylim([0 max(yl2)]); subplot(2,2,4),legend(tit2);ylim([0 max(yl2)]);

if saveFig, saveFigure(numF.Number,'N1versusImmob_AllSpectrumPFandHP',FolderToSave); end
           
%% EMG
tempMov=squeeze(MATmov(:,1:10,1)); tempMov(tempMov>10E9)=nan; tempMov(tempMov<10)=nan;
tempEmg=squeeze(MATemg(:,1:10,1));
Nmov=sum(~isnan(nanmean(tempMov,2)));
Nemg=sum(~isnan(nanmean(tempEmg,2)));

% A=nan(10000,10);B=nan(10000,10);
% for n=1:10
%     tempMovAll=squeeze(MATmov(:,n,2:end));
%     tempMovAll=tempMovAll(tempMovAll~=0);
%     A(1:length(tempMovAll),n)=tempMovAll;
%     tempEmgAll=squeeze(MATemg(:,n,2:end));
%     tempEmgAll=tempEmgAll(:);
%     B(1:length(tempEmgAll),n)=tempEmgAll;
% end
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.7 0.7]); numF=gcf;
subplot(2,3,1), plotSpread(tempMov,'distributionColors','k');hold on, 
for n=1:10, line(n+[-0.2 0.2],nanmean(tempMov(:,n),1)+[0 0],'Color',colori(n,:),'Linewidth',2);end
set(gca,'Xtick',1:10); set(gca,'XtickLabel',MATNameEpoch(1:10),'XTickLabelRotation',45)
title(sprintf('Movements (n=%d session)',Nmov))

subplot(2,3,4), plotSpread(tempEmg,'distributionColors','k');hold on, 
for n=1:10, line(n+[-0.2 0.2],nanmean(tempEmg(:,n),1)+[0 0],'Color',colori(n,:),'Linewidth',2);end
set(gca,'Xtick',1:10); set(gca,'XtickLabel',MATNameEpoch(1:10),'XTickLabelRotation',45)
title(sprintf('EMG (n=%d session)',Nemg))

mice=unique(Dir.name);
MiMov=nan(length(mice),10); MiEmg=MiMov;
for mi=1:length(mice)
    MiMov(mi,:)=nanmean(tempMov(strcmp(Dir.name,mice{mi}),:),1);
    MiEmg(mi,:)=nanmean(tempEmg(strcmp(Dir.name,mice{mi}),:),1);
    disp([sprintf('%1.0f   ',tempMov(strcmp(Dir.name,mice{mi}),2)),'  mean = ',num2str(floor(10*MiEmg(mi,2))/10)])
end
miNmov=sum(~isnan(nanmean(MiMov,2)));
miNemg=sum(~isnan(nanmean(MiEmg,2)));

subplot(2,3,2), plotSpread(MiMov,'distributionColors','k');hold on, 
for n=1:10, line(n+[-0.2 0.2],nanmean(MiMov(:,n),1)+[0 0],'Color',colori(n,:),'Linewidth',2);end
set(gca,'Xtick',1:10); set(gca,'XtickLabel',MATNameEpoch(1:10),'XTickLabelRotation',45)
title(sprintf('Movements (N=%d mice)',miNmov))

subplot(2,3,5), plotSpread(MiEmg,'distributionColors','k');hold on, 
for n=1:10, line(n+[-0.2 0.2],nanmean(MiEmg(:,n),1)+[0 0],'Color',colori(n,:),'Linewidth',2);end
set(gca,'Xtick',1:10); set(gca,'XtickLabel',MATNameEpoch(1:10),'XTickLabelRotation',45)
title(sprintf('EMG (N=%d mice)',miNemg))

% subplot(2,3,3), PlotErrorBarN_KJ(MiMov(:,1:8),'newfig',0);
% title(sprintf('Movements (N=%d mice)',miNmov))
subplot(2,3,3), PlotErrorBarN_KJ(tempMov(:,1:8),'newfig',0,'ShowSigstar','none');
title(sprintf('Movements (n=%d session)',Nmov))
set(gca,'Xtick',1:8); set(gca,'XtickLabel',MATNameEpoch(1:8),'XTickLabelRotation',45)

subplot(2,3,6), PlotErrorBarN_KJ(tempEmg(:,1:8),'newfig',0,'ShowSigstar','none');
title(sprintf('EMG (n=%d session)',Nemg))
set(gca,'Xtick',1:8); set(gca,'XtickLabel',MATNameEpoch(1:8),'XTickLabelRotation',45)

if saveFig, saveFigure(numF.Number,'N1versusImmob_AllEmgMov',FolderToSave); end
