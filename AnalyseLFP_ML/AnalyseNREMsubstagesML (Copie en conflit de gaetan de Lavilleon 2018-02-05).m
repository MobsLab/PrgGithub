% AnalyseNREMsubstagesML.m
%
% see also
% AnalyseNREMsubstages_transitionML.m
% CaracteristicsSubstagesML.m

res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
FolderToSave='/home/mobsyoda/Dropbox/MOBS-ProjetAstro/FIGURES/FIguresPosterSFN2015';

try
    load([res,'/AnalySubStagesML.mat'])
    Dir;
    disp('AnalySubStagesML.mat already exists... loading...')
    
    
catch
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    MATepochs={};MATOSCI={};
    OptionSpiLow=1; % 1 to take into account both Low (9-12Hz) and High (12-15Hz) spindles, 0 for High only, (default=1)
    
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        clear op NamesOp Dpfc Epoch
        try
            error
            load NREMepochsML.mat op NamesOp Dpfc Epoch
            op; disp('... loading epochs from NREMepochsML.m')
        catch
            [op,NamesOp,Dpfc,Epoch]=FindNREMepochsML;
        	save NREMepochsML.mat op NamesOp Dpfc Epoch
            disp('saving in NREMepochsML.mat')
        end
        % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        if ~isempty(Range(Dpfc))        
            % <<<<<<<<<<<< load ripples <<<<<<<<<<<<<<<<<<<<<<<<<<
            clear dHPCrip rip 
            try
                load('RipplesdHPC25.mat');
                if ~isempty(dHPCrip)
                    rip=ts(dHPCrip(:,2)*1E4);
                end
            catch
                rip=ts([]);
            end
            
            % <<<<<<<<<<<< load Spindles PFCx Sup <<<<<<<<<<<<<<<<<<
            clear Spi1
            spiHf=[]; spiLf=[];
            try
                Spi1=load('SpindlesPFCxSup.mat','SpiHigh','SpiLow');
                if ~isempty(Spi1.SpiHigh)
                    spiHf=[spiHf;Spi1.SpiHigh(:,2)];
                end
                if ~isempty(Spi1.SpiLow)
                    spiLf=[spiLf;Spi1.SpiLow(:,2)];
                end
                
            catch
                disp('  -> No spindles PFCxsup')
                tempch=load('ChannelsToAnalyse/PFCx_sup.mat','channel');
                if ~isempty(tempch.channel)
                    disp('         Calculating !!')
                    eval(['tempLoadB=load(''LFPData/LFP',num2str(tempch.channel),'.mat'',''LFP'');'])
                    [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[2 20],Epoch,'off');
                    [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[12 15],Epoch,'off');
                    [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[9 12],Epoch,'off');
                    [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[6 8],Epoch,'off');
                    save SpindlesPFCxSup SpiTot SpiHigh SpiLow SpiULow SWATot SWAHigh SWALow SWAULow TotEpoch HiEpoch LowEpoch UlowEpoch
                    
                    spiHf=[spiHf;SpiHigh(:,2)];
                    spiLf=[spiLf;SpiLow(:,2)];
                    clear SpiTot SpiHigh SpiLow SpiULow SWATot SWAHigh SWALow SWAULow TotEpoch HiEpoch LowEpoch UlowEpoch
                end
            end
            
            % <<<<<<<<<<<<<<< load Spindles PFCx Deep <<<<<<<<<<<<<<<<<<<<<<<<<
            clear Spi2 
            try
                Spi2=load('SpindlesPFCxDeep.mat','SpiHigh','SpiLow');
                if ~isempty(Spi2.SpiHigh)
                    spiHf=[spiHf;Spi2.SpiHigh(:,2)];
                end
                if ~isempty(Spi2.SpiLow)
                    spiLf=[spiLf;Spi2.SpiLow(:,2)];
                end
                
            catch
                disp('  -> No spindles PFCxdeep  !!!')
                tempch=load('ChannelsToAnalyse/PFCx_deep.mat','channel');
                if ~isempty(tempch.channel),
                    disp('         Calculating !!')
                    eval(['tempLoadB=load(''LFPData/LFP',num2str(tempch.channel),'.mat'',''LFP'');'])
                    [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[2 20],Epoch,'off');
                    [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[12 15],Epoch,'off');
                    [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[9 12],Epoch,'off');
                    [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[6 8],Epoch,'off');
                    save SpindlesPFCxDeep SpiTot SpiHigh SpiLow SpiULow SWATot SWAHigh SWALow SWAULow TotEpoch HiEpoch LowEpoch UlowEpoch
                    
                    spiHf=[spiHf;SpiHigh(:,2)];
                    spiLf=[spiLf;SpiLow(:,2)];
                    clear SpiTot SpiHigh SpiLow SpiULow SWATot SWAHigh SWALow SWAULow TotEpoch HiEpoch LowEpoch UlowEpoch
                end
            end
            
            % <<<<<<<<<<<<< Sort Spindles <<<<<<<<<<<<<<<<<<<<<<<<<<<<
            clear Spfc
            if OptionSpiLow
                Spfc=[spiHf;spiLf];
            else
                Spfc=spiHf;
            end
            Spfc=sort(Spfc);
            Spfc(find(diff(Spfc)<0.5)+1)=[];%meme spindles
            Spfc=ts(Spfc*1E4);
        
        
            % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % op = SupOsci DeepOsci N3 REM WAKE SWS PFswa OBswa
            MATepochs(man,:)=op;
            MATOSCI(man,1:3)={Dpfc,rip,Spfc};
            
            % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % load time of debRec
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(Dir.path{man});
            MATZT(man,1:2)=[min(Data(NewtsdZT)),max(Data(NewtsdZT))]/1E4; % en second

        end
    end
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<<<< TERMINATION AND SAVING <<<<<<<<<<<<<<<<<<<<<<
    disp('Saving in AnalySubStagesML.mat')
    %MATOSCI=tsdArray(MATOSCI);
    save([res,'/AnalySubStagesML.mat'],'Dir','MATepochs','MATOSCI','MATZT','OptionSpiLow')
end

cd(res)


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< Define substages <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp('running DefineSubStages.m for all expe'); MATEP={};
for man=1:length(Dir.path)
    [temp,nameEpochs]=DefineSubStages(MATepochs(man,:));
    MATEP(man,1:length(temp))=temp;
end
disp('Done');

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<< Count Rhythms and coordination <<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp(' '); disp('...Count and coordination of sleep Rhythms')

MATDELT=nan(length(Dir.path),length(nameEpochs)); MATRIP=MATDELT; MATSPIND=MATDELT;
n_osci=nan(length(Dir.path),length(nameEpochs),3);
for i=1:length(nameEpochs), for io=1:3, MatCoord{i,io}=nan(length(Dir.path),51);end;end
clear bt
for man=1:length(Dir.path)
    disp(Dir.path{man})
    clear rip Dpfc spiHf
    try
        op=MATEP(man,:);
        
        Dpfc=MATOSCI{man,1};
        rip=MATOSCI{man,2};
        spiHf=MATOSCI{man,3};
        
        %fill results matrices
        for i=1:length(op)
            EpLength=sum(Stop(op{i},'s')-Start(op{i},'s'));
            if EpLength>3
                % delta
                if ~isempty(Range(Dpfc))
                    tdpf_op=Restrict(Dpfc,op{i});
                    MATDELT(man,i)=length(Range(tdpf_op))/EpLength;
                end
                % ripples
                if ~isempty(Range(rip))
                    trip_op=Restrict(rip,op{i});
                    MATRIP(man,i)=length(Range(trip_op))/EpLength;
                end
                % spindles
                if ~isempty(Range(spiHf))
                    tspi_op=Restrict(spiHf,op{i});
                    MATSPIND(man,i)=length(Range(tspi_op))/EpLength;
                end
                
                %keep number of events
                n_osci(man,i,1)=length(Range(tdpf_op));
                n_osci(man,i,2)=length(Range(trip_op));
                n_osci(man,i,3)=length(Range(tspi_op));
            
                % CrossCorr
                % nbin=1000 for 20s, nbin=200 for 5s, nbin=10 for 0.25s
                [Ct,Bt]=CrossSpiRipDeltaML(spiHf,rip,Dpfc,op{i},1000);
                bt=Bt;
                for io=1:3
                    temp= MatCoord{i,io};
                    try temp(man,:)=Ct{io}';end
                    MatCoord{i,io}=temp;
                     % rip vs spi ; rip vs Delta
                end
            end
        end
    catch
        disp('Problem'); %keyboard
    end
end
disp('Done');warning on

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<< plot Coordination rhythms <<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
L=5;
leg={'Ripples at t-Spindles','Ripples at t-Delta','Spindles at t-Delta'};
figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.3 0.8]);
for io=1:3
    for i=1:L
        subplot(3,L,(io-1)*L+i), hold on
        temp= MatCoord{i,io};
        if 0
            for man=1:length(Dir.path)
                plot(bt{io}/1E3,temp(man,:),'Color',[0.5 0.5 0.5]);
            end
        end
        plot(bt{io}/1E3,nanmean(temp,1),'Color','k','Linewidth',2)
        plot(bt{io}/1E3,nanmean(temp,1)+nanstd(temp)/sqrt(sum(~isnan(nanmean(temp,2)))),'Color','k')
        plot(bt{io}/1E3,nanmean(temp,1)-nanstd(temp)/sqrt(sum(~isnan(nanmean(temp,2)))),'Color','k')
        
        if io==1, title(nameEpochs{i});end
        if i==1, ylabel(leg{io});end
        if io==1
            n=nansum(n_osci(:,i,3));N=sum(~isnan(n_osci(:,i,3)));
        else
            n=nansum(n_osci(:,i,1));N=sum(~isnan(n_osci(:,i,1)));
        end
        xlim([min(bt{io}/1E3),max(bt{io}/1E3)])
        xlabel(['n=',num2str(n),', N=',num2str(N),'  ',leg{io}(strfind(leg{io},'t-'):end),' (s)'])
    end
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< Restrict mice <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%Nmice=[];
Nmice=[243 244 251 252];
disp(' '); disp(['...Removing mice ',num2str(Nmice)])
indDir=1:length(Dir.path); discardind=[];
for n=1:length(Nmice)
    discardind=[discardind,find(strcmp(Dir.name,sprintf('Mouse%03d',Nmice(n))))];
end
indDir(discardind)=[];

%nameEpochs={'N1','N2','N3','REM','WAKE','SWS','N23','swaPF','swaOB'};




% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< SUBSTAGES DURATION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp(' '); disp('...Calculating Stage duration')
% compare with sws
isws=find(strcmp('SWS',nameEpochs));
is=find(strcmp('TOTSleep',nameEpochs));
indsws=[]; 
for op=1:length(nameEpochs)
    if sum(strcmp({'N','R'},nameEpochs{op}(1))), indsws=[indsws,op];end
end

% length of substage epochs
MATDUR=nan(length(Dir.path),length(nameEpochs));
MATDURsws=MATDUR; MATDURs=MATDUR;
for man=indDir
    clear tempsws temp temptot temps
    try
        tempsws=sum(Stop(MATEP{man,isws},'s')-Start(MATEP{man,isws},'s'));
        temps=sum(Stop(MATEP{man,is},'s')-Start(MATEP{man,is},'s'));
        for op=1:length(nameEpochs)
            temp=sum(Stop(MATEP{man,op},'s')-Start(MATEP{man,op},'s'));
            
            temptot=MATZT(man,2)-MATZT(man,1);
            if temptot>0
                MATDUR(man,op)=100*temp/temptot;
                if tempsws>0, MATDURsws(man,op)=100*temp/tempsws;end
                if temps>0, MATDURs(man,op)=100*temp/temps;end
            end
        end
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< POOL SAME MICE EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
mice=unique(Dir.name(indDir));
disp('...Pool same mice')
MiDELT=nan(length(mice),length(nameEpochs));
MiSPIND=MiDELT; MiRIP=MiDELT; MiEP=MiDELT; MiEPs=MiDELT; MiEPsws=MiDELT;
for mi=1:length(mice)
    ind=find(strcmp(Dir.name,mice{mi}));
    MiDELT(mi,:)=nanmean(MATDELT(ind,:),1);
    MiSPIND(mi,:)=nanmean(MATSPIND(ind,:),1);
    MiRIP(mi,:)=nanmean(MATRIP(ind,:),1);
    MiEP(mi,:)=nanmean(MATDUR(ind,:),1);
    MiEPsws(mi,:)=nanmean(MATDURsws(ind,:),1);
    MiEPs(mi,:)=nanmean(MATDURs(ind,:),1);
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< QUANTIFIACTION OF NREMSubStages <<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp('...Plot QUANTIFIACTION OF NREMSubStages')
figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.3 0.8]); numF(1)=gcf;
figure('Color',[1 1 1],'unit','Normalized','Position', [0.3 0.05 0.3 0.8]); numF(2)=gcf;
% delta
figure(numF(1)),subplot(3,2,1), PlotErrorBarN(MATDELT,0,1);
n=sum(~isnan(nanmean(MATDELT,2))); N=sum(~isnan(nanmean(MiDELT,2)));
title(sprintf('Delta (n=%d, N=%d)',n,N)); ylabel('Occurance (Hz)');
figure(numF(2)),subplot(3,2,1), PlotErrorBarN(MiDELT,0,1); 
title(sprintf('Delta (N=%d)',N)); ylabel('Occurance (Hz)');

%Spindles
figure(numF(1)),subplot(3,2,3), PlotErrorBarN(MATSPIND,0,1); 
n=sum(~isnan(nanmean(MATSPIND,2))); N=sum(~isnan(nanmean(MiSPIND,2)));
title(sprintf('Spindles (n=%d, N=%d)',n,N)); 
figure(numF(2)),subplot(3,2,3), PlotErrorBarN(MiSPIND,0,1); 
title(sprintf('Spindles (N=%d)',N)); ylabel('Occurance (Hz)');

% Ripples
figure(numF(1)),subplot(3,2,5), PlotErrorBarN(MATRIP,0,1); 
n=sum(~isnan(nanmean(MATRIP,2))); N=sum(~isnan(nanmean(MiRIP,2)));
title(sprintf('Ripples (n=%d, N=%d)',n,N)); ylabel('Occurance (Hz)');
figure(numF(2)),subplot(3,2,5), PlotErrorBarN(MiRIP,0,1);
title(sprintf('Ripples (N=%d)',N)); ylabel('Occurance (Hz)');

% duration tot
figure(numF(1)),subplot(3,2,2), PlotErrorBarN(MATDUR,0,1); 
n=sum(~isnan(nanmean(MATDUR,2))); N=sum(~isnan(nanmean(MiEP,2)));
title(sprintf('Duration (perc of total recording, n=%d, N=%d)',n,N)); 
figure(numF(2)),subplot(3,2,2), PlotErrorBarN(MiEP,0,1); 
title(sprintf('Duration (perc of total recording, N=%d)',N)); 

% duration out of sws
figure(numF(1)),subplot(3,2,4), PlotErrorBarN(MATDURsws,0,1); 
n=sum(~isnan(nanmean(MATDURsws,2))); N=sum(~isnan(nanmean(MiEPsws,2)));
title(sprintf('Duration (perc of NREM, n=%d, N=%d)',n,N)); 
figure(numF(2)),subplot(3,2,4), PlotErrorBarN(MiEPsws,0,1); 
title(sprintf('Duration (perc of NREM, N=%d)',N)); 
% duration out of sleep
figure(numF(1)),subplot(3,2,6), PlotErrorBarN(MATDURs,0,1); 
n=sum(~isnan(nanmean(MATDURs,2))); N=sum(~isnan(nanmean(MiEPs,2)));
title(sprintf('Duration (perc of Sleep, n=%d, N=%d)',n,N)); 
figure(numF(2)),subplot(3,2,6), PlotErrorBarN(MiEPs,0,1); 
title(sprintf('Duration (perc of Sleep, N=%d)',N)); 

for f=1:2
    for s=1:6
        figure(numF(f)),subplot(3,2,s)
        set(gca,'Xtick',1:length(nameEpochs));
        set(gca,'XtickLabel',nameEpochs);
    end
%     saveFigure(gcf,['NREMSubStages',num2str(f),'_',date],FolderToSave)
%     saveFigure(gcf,['NREMSubStages',num2str(f),'_',date],res)
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< repartition substages across sleep time <<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp(' ');disp('...Calculating repartition of substages across sleep time')
HourDay=9:0.5:20;

% <<<<<<<<<<<<<<<<<<<<<<<< initiation <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% matrice per expe
MATh=nan(length(Dir.path),length(HourDay)-1,length(nameEpochs));
MAThsws=MATh; MAThs=MATh;
% matrice pooled per mouse
Mih=nan(length(mice),length(HourDay)-1,length(nameEpochs));
Mihsws=Mih;
% matrice for plots
MAThplo=nan(length(HourDay)-1,length(nameEpochs));
Mihplo=nan(length(HourDay)-1,length(nameEpochs));


for h=1:length(HourDay)-1
    for op=1:length(nameEpochs),
        for man=indDir
            clear I totalT temp swsT sT
            if MATZT(man,1)/3600< HourDay(h+1) && MATZT(man,2)/3600> HourDay(h)
                
                I=intervalSet(HourDay(h)*3600*1E4-MATZT(man,1)*1E4,HourDay(h+1)*3600*1E4-MATZT(man,1)*1E4);
                totalT=min(3600*HourDay(h+1),MATZT(man,2))-max(3600*HourDay(h),MATZT(man,1)/3600);
                
                % ratio on total rec
                temp=sum(Stop(and(I,MATEP{man,op}),'s')-Start(and(I,MATEP{man,op}),'s'));
                if temp~=0, MATh(man,h,op)=100*temp/totalT;end
                
                % ratio on NREMsleep
                try
                    swsT=sum(Stop(and(I,MATEP{man,isws}),'s')-Start(and(I,MATEP{man,isws}),'s'));
                    if swsT~=0, MAThsws(man,h,op)=100*temp/swsT;end
                end
                
                % ratio on Total sleep time
                try
                    sT=sum(Stop(and(I,MATEP{man,is}),'s')-Start(and(I,MATEP{man,is}),'s'));
                    if sT~=0, MAThs(man,h,op)=100*temp/sT;end
                end
            end
        end
        
        % <<<<<<<<<<<<<<<<<<<<<<<< 
        % pool mice
        for mi=1:length(mice)
            ind=find(strcmp(Dir.name,mice{mi}));
            
            Mih(mi,h,op)=nanmean(squeeze(MATh(ind,h,op)),1);
            Mihsws(mi,h,op)=nanmean(squeeze(MAThsws(ind,h,op)),1);
            Mihs(mi,h,op)=nanmean(squeeze(MAThs(ind,h,op)),1);
        end
        n(op)=sum(~isnan(squeeze(MATh(:,h,op))));
        N(op)=sum(~isnan(squeeze(Mih(:,h,op))));
        if ismember(op,indsws)
%             MAThplo(h,op)=nanmean(squeeze(MAThsws(:,h,op)),1);
              MAThplo(h,op)=nanmean(squeeze(MAThs(:,h,op)),1);
%             Mihplo(h,op)=nanmean(squeeze(Mihsws(:,h,op)),1);
              Mihplo(h,op)=nanmean(squeeze(Mihs(:,h,op)),1);
        else
            MAThplo(h,op)=nanmean(squeeze(MATh(:,h,op)),1);
            Mihplo(h,op)=nanmean(squeeze(Mih(:,h,op)),1);
        end
    end
end


% prepare display
for hd=1:length(HourDay)-1
    leg{hd}=sprintf('%dh',floor(HourDay(hd)));
end

%% display barplot
disp('...Various plots')
for f=1:2
    
    figure('Color',[1 1 1],'Units','normalized','Position',[0.1 0.1 0.4 0.8])
    if f==1, M1=MATh; M2=MAThplo; else M1=Mih; M2=Mihplo;end
    
    for op=1:length(nameEpochs)
        subplot(3,4,op), PlotErrorBar(squeeze(M1(:,:,op)),0);
        title([nameEpochs{op},sprintf(' (n=%d)',sum(~isnan(squeeze(nanmean(M1(:,:,op),2)))))]);
        set(gca,'Xtick',1:4:length(HourDay)-1); set(gca,'XtickLabel',leg(1:4:end))
        if ismember(op,indsws), ylabel('Duration (% sleep)');else,ylabel('Duration (% period)');end
    end
    
    subplot(3,4,9),bar(M2(:,indsws),'stacked');legend(nameEpochs(indsws));ylabel('Duration (% sleep)');
        set(gca,'Xtick',1:4:length(HourDay)-1); set(gca,'XtickLabel',leg(1:4:end))
    
        indper=find(~ismember(1:length(nameEpochs),indsws));
    subplot(3,4,10),bar(M2(:,indper),'stacked');legend(nameEpochs(indper));ylabel('Duration (% period)');
        set(gca,'Xtick',1:4:length(HourDay)-1); set(gca,'XtickLabel',leg(1:4:end))
        
    subplot(3,4,11:12),bar(M2(:,indsws));legend(nameEpochs(indsws));ylabel('Duration (%  sleep)');
        set(gca,'Xtick',1:2:length(HourDay)-1); set(gca,'XtickLabel',leg(1:2:end))
    
%     saveFigure(gcf,['NREMSubStagesEvol',num2str(f),'_',date],FolderToSave)
%     saveFigure(gcf,['NREMSubStagesEvol',num2str(f),'_',date],res)
end

%% display curves
colori=colormap('jet');
for f=1:2
    
    figure('Color',[1 1 1],'Units','normalized','Position',[0.1 0.1 0.4 0.8])
    if f==1
        M1=MATh; M2=MAThplo;
    else
        M1=Mih; M2=Mihplo;
    end
    
    for op=1:length(nameEpochs)
        temp=squeeze(M1(:,:,op));legM={}; a=0;
        subplot(2,4,op), hold on,
        n=sum(~isnan(squeeze(nanmean(M1(:,:,op),2))));
        if f==2
        for i=1:size(temp,1)
            try
                plot(HourDay(1:end-1),temp(i,:),'Color',colori(floor(64*i/size(temp,1))+1,:));
                a=a+1; if f==1, legM{a}=['#',Dir.name{i}(6:end)];else,legM{a}=['#',mice{i}(6:end)]; end
            end
        end
        end
        errorbar(HourDay(1:end-1),nanmean(temp,1),nanstd(temp)/sqrt(n),'Linewidth',2,'Color','k')
        title([nameEpochs{op},sprintf(' (n=%d)',n)]);
        ylabel('Duration (% period)'); xlabel('Start Time (h)')
    end
    legend([legM,'mean/sem'])
    %keyboard
    %saveFigure(gcf,['NREMSubStagesEvoLines',num2str(f),'_',date],FolderToSave)
    %saveFigure(gcf,['NREMSubStagesEvoLines',num2str(f),'_',date],res)
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< distribution of each episod duration <<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

mergecloseint=1;
if mergecloseint, disp('Merging close intervals (IepI<1s)');end
allEp=[];
for h=1:length(HourDay)-1
    for op=1:length(nameEpochs),
        for man=indDir
    
            if ~isempty(MATEP{man,op})
                tempEp=MATEP{man,op};
                if mergecloseint, tempEp=mergeCloseIntervals(tempEp,1E4);end
                sta=Start(MATEP{man,op},'s');
                sto=Stop(MATEP{man,op},'s');
                
                ind=find(MATZT(man,1)+sta<=3600*HourDay(h) & MATZT(man,1)+sta<3600*HourDay(h+1));
                if ~isempty(ind)
                    temp=sto(ind)-sta(ind);
                    allEp=[allEp; [ones(length(temp),1)*[man,op,h],temp]];
                end
            end
        end
        
        
    end
end

%% display
colori=colormap('jet');
figure('Color',[1 1 1],'Units','normalized','Position',[0.05 0.05 0.4 0.8]); 
grand=[25 40 10 100 200];
yl=[3500 6000 3500 200 1500];
for op=1:8,
    temp=allEp(find(allEp(:,2)==op),4);
    subplot(3,5,op), hold on,  hist(temp,0:grand(op)/100:grand(op),'Color','k');
    title(nameEpochs{op}); xlabel('Duration (s)'); ylabel('Nb of episods');
    xlim([0 grand(op)-grand(op)/50]);  ylim([0,yl(op)])
    
    line([mean(temp),mean(temp)],[0 yl(op)],'Color','r','Linewidth',2)
    text(1.1*mean(temp),0.9*yl(op),sprintf('mean=%.1fs',mean(temp)),'Color','r')
    
    line([median(temp),median(temp)],[0 yl(op)],'Color','m','Linewidth',2)
    text(1.1*median(temp),0.8*yl(op),sprintf('median=%.1fs',median(temp)),'Color','m')
    
    
    % separate per day time
    DurMean=nan(length(indDir),length(HourDay)-1);DurMed=DurMean;
    subplot(3,5,5+op),hold on,  
    for man=1:length(indDir)
        for h=1:length(HourDay)-1
            temp=allEp(find(allEp(:,1)==indDir(man) & allEp(:,2)==op & allEp(:,3)==h),4);
            if ~isempty(temp)
                DurMean(man,h)=mean(temp);
                DurMed(man,h)=median(temp);
            end
        end
        plot(HourDay(1:end-1),DurMean(man,:),'Color',colori(floor(64*find(strcmp(Dir.name{indDir(man)},mice))/length(mice)),:))
    end
    n=length(~isnan(nanmean(DurMean,2)));
    errorbar(HourDay(1:end-1),nanmean(DurMean,1),nanstd(DurMean)/sqrt(n),'Color','r','Linewidth',2)
    errorbar(HourDay(1:end-1),nanmean(DurMed,1),nanstd(DurMed)/sqrt(n),'Color','m','Linewidth',2)
    title([nameEpochs{op},' (n=',num2str(n),')']); if op==1,ylabel('Duration (s)'); end
    xlim([min(HourDay),max(HourDay)]), ylim([0 1.5*max(nanmean(DurMean,1))])
    
    % pool mice, separate per day time
    DurMean=nan(length(mice),length(HourDay)-1);DurMed=DurMean;
    subplot(3,5,10+op),hold on,  
    for mi=1:length(mice)
        ind=find(strcmp(mice(mi),Dir.name));
        for h=1:length(HourDay)-1
            temp=allEp(find(ismember(allEp(:,1),ind) & allEp(:,2)==op & allEp(:,3)==h),4);
            if ~isempty(temp)
                DurMean(mi,h)=mean(temp);
                DurMed(mi,h)=median(temp);
            end
        end
        plot(HourDay(1:end-1),DurMean(mi,:),'Color',colori(floor(64*mi/length(mice)),:))
    end
    n=length(~isnan(nanmean(DurMean,2)));
    errorbar(HourDay(1:end-1),nanmean(DurMean,1),nanstd(DurMean)/sqrt(n),'Color','r','Linewidth',2)
    errorbar(HourDay(1:end-1),nanmean(DurMed,1),nanstd(DurMed)/sqrt(n),'Color','m','Linewidth',2)
    title([nameEpochs{op},' (N=',num2str(n),')']); xlabel('Day time (h)'); if op==1,ylabel('Duration (s)'); end
    xlim([min(HourDay),max(HourDay)]), ylim([0 1.5*max(nanmean(DurMean,1))])

end
legend([mice,'mean','median'])
saveFigure(gcf,['NREMSubStagesDuration_',date],FolderToSave)
saveFigure(gcf,['NREMSubStagesDuration_',date],res)


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< Correlation across substaged duration <<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
L=5;
plotindiv=0;
mindur=20; %in sec
if plotindiv, for man=1:length(Dir.path),  figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.05 0.4 0.8]); numF(man)=gcf;end;end
for i=1:L
    for j=1:L
        temp=[];
        for man=indDir
            I=MATEP{man,i};
            J=MATEP{man,j};
            if ~isempty(I) && ~isempty(J)
                Sta=[Start(I,'s'),zeros(length(Start(I)),1),Stop(I,'s')-Start(I,'s');...
                    Start(J,'s'),ones(length(Start(J)),1),Stop(J,'s')-Start(J,'s')];
                Sta=sortrows(Sta,1);
                
                % pool duration of same stage episods following each other
                indsame=1+find(diff(Sta(:,2))==0);
                St=Sta;
                for id=length(indsame):-1:1
                    St(indsame(id)-1,:)=[Sta(indsame(id)-1,1),mean(Sta(indsame(id)-1:indsame(id),2)),Sta(indsame(id)-1,3)+Sta(indsame(id),3)];
                    St(indsame(id),:)=[];
                end
                
                % Find episod with i before j
                ind=find(diff(St(:,2))==-1);
                indok=find(St(ind,3)>mindur & St(ind+1,3)>mindur); 
                % fil matriceResults
                temp=[temp ; [St(ind(indok),3),St(ind(indok)+1,3),man+zeros(length(ind(indok)),1)] ];
                
                
                % plot mouse
                if plotindiv
                    figure(numF(man)),
                    subplot(L,L,L*(j-1)+i),
                    plot(St(ind(indok),3),St(ind(indok)+1,3),'.k')
                    title([nameEpochs{i},' before ',nameEpochs{j}])
                    if j==L, xlabel([nameEpochs{i},' duration (s)']);end
                    if i==1, ylabel([nameEpochs{j},' duration (s)']);end
                end
            end
        end
        MATCor{i,j}=temp;
    end
end
%% display
figure('Color',[1 1 1],'Units','normalized','Position',[0.05 0.05 0.4 0.8]);
for i=1:L
    for j=1:L
        temp=MATCor{i,j};
        subplot(L,L,L*(j-1)+i),
        plot(temp(:,1),temp(:,2),'.k')
        title([nameEpochs{i},' before ',nameEpochs{j}])
        if j==L, xlabel([nameEpochs{i},' duration (s)']);end
        if i==1, ylabel([nameEpochs{j},' duration (s)']);end
    end
end


