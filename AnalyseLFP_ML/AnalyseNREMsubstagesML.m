% AnalyseNREMsubstagesML.m
%
% list of related scripts in NREMstages_scripts.m 

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAIDN/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
%FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureNREMstages';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages';
savFig=0; clear MATEP Dir

nameAnaly='AnalySubStagesML';
doKO=0;
doNew=1;
doNewLong=0;
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
if doKO
    Dir=PathForExperimentsML('BASAL');
%     Dir=RestrictPathForExperiment(Dir,'Group',{'dKO','WT'});
    Dir=RestrictPathForExperiment(Dir,'Group','dKO'); 
    nameAnaly=[nameAnaly,'_dKO'];
elseif doNewLong
    Dir=PathForExperimentsMLnew('BASALlongSleep');
    nameAnaly=[nameAnaly,'_New'];
elseif doNew
    Dir1=PathForExperimentsMLnew('BASALlongSleep');
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
    nameAnaly=[nameAnaly,'_all'];
else
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    load([res,'/',nameAnaly,'.mat']);
    Dir;
    disp([nameAnaly,'.mat already exists... loading...'])
    
catch
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    MATepochs={};MATOSCI={};
    OptionSpiLow=1; % 1 to take into account both Low (9-12Hz) and High (12-15Hz) spindles, 0 for High only, (default=1)
    
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        clear op NamesOp Dpfc Epoch noise wholeEpoch
        % !!!! Epoch has changed from SWS to wholesleep !!! 
        % !!!! use now GetDeltaML.m instead of FindDeltaWavesChanGL.m !!!
        try
            load NREMepochsML.mat op NamesOp Dpfc Epoch noise
            op; noise ;disp('... loading epochs from NREMepochsML.m')
        catch
            [op,NamesOp,Dpfc,Epoch,noise]=FindNREMepochsML;
            save NREMepochsML.mat op NamesOp Dpfc Epoch noise
            disp('saving in NREMepochsML.mat')
        end
        try 
            wholeEpoch=or(or(op{6},op{5}),op{4});
            wholeEpoch=mergeCloseIntervals(wholeEpoch,10);
            wholeEpoch=CleanUpEpoch(wholeEpoch);
        end
        % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        if ~isempty(Range(Dpfc))        
            % <<<<<<<<<<<< load ripples <<<<<<<<<<<<<<<<<<<<<<<<<<
            disp('getting AllRipplesdHPC25.mat');
            clear dHPCrip rip
            [dHPCrip,EpochRip]=GetRipplesML(wholeEpoch,op{6});
            try rip=ts(dHPCrip(:,2)*1E4);catch, rip=ts([]);;end
%             clear dHPCrip rip chHPC tempLoad
%             try
%                 try
%                     load('sleepRipplesdHPC25.mat'); dHPCrip;
%                 catch
%                     disp('Computing sleepRipplesdHPC25.mat');
%                     load('RipplesdHPC25.mat','chHPC');
%                     eval(['tempLoad=load(''LFPData/LFP',num2str(chHPC),'.mat'',''LFP'');'])
%                     eegRip=tempLoad.LFP;
%                     [dHPCrip,EpochRip]=FindRipplesKarimSB(eegRip,Epoch,[2 5]);
%                     save([res,'/sleepRipplesdHPC25.mat'],'dHPCrip','EpochRip','chHPC');
%                     disp('Done.')
%                 end
%                 if ~isempty(dHPCrip)
%                     rip=ts(dHPCrip(:,2)*1E4);
%                 end
%             catch
%                 rip=ts([]);
%             end
            
            % <<<<<<<<<<<< load Spindles PFCx Sup <<<<<<<<<<<<<<<<<<
            spiHf=[]; spiLf=[];
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup',wholeEpoch,op{6});
            if ~isempty(SpiHigh)
                spiHf=[spiHf;SpiHigh(:,2)];
            end
            if ~isempty(SpiLow)
                spiLf=[spiLf;SpiLow(:,2)];
            end
%             clear Spi1
%             try
%                 Spi1=load('SpindlesPFCxSup.mat','SpiHigh','SpiLow');
%                 if ~isempty(Spi1.SpiHigh)
%                     spiHf=[spiHf;Spi1.SpiHigh(:,2)];
%                 end
%                 if ~isempty(Spi1.SpiLow)
%                     spiLf=[spiLf;Spi1.SpiLow(:,2)];
%                 end
%                 
%             catch
%                 disp('  -> No spindles PFCxsup')
%                 tempch=load('ChannelsToAnalyse/PFCx_sup.mat','channel');
%                 if ~isempty(tempch.channel)
%                     disp('         Calculating !!')
%                     eval(['tempLoadB=load(''LFPData/LFP',num2str(tempch.channel),'.mat'',''LFP'');'])
%                     [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[2 20],Epoch,'off');
%                     [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[12 15],Epoch,'off');
%                     [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[9 12],Epoch,'off');
%                     [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[6 8],Epoch,'off');
%                     save SpindlesPFCxSup SpiTot SpiHigh SpiLow SpiULow SWATot SWAHigh SWALow SWAULow TotEpoch HiEpoch LowEpoch UlowEpoch
%                     
%                     
%                     clear SpiTot SpiHigh SpiLow SpiULow SWATot SWAHigh SWALow SWAULow TotEpoch HiEpoch LowEpoch UlowEpoch
%                 end
%             end
            
            
            % <<<<<<<<<<<<<<< load Spindles PFCx Deep <<<<<<<<<<<<<<<<<<<<<<<<<
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep',wholeEpoch,op{6});
            if ~isempty(SpiHigh)
                spiHf=[spiHf;SpiHigh(:,2)];
            end
            if ~isempty(SpiLow)
                spiLf=[spiLf;SpiLow(:,2)];
            end
%             clear Spi2 
%             try
%                 Spi2=load('SpindlesPFCxDeep.mat','SpiHigh','SpiLow');
%                 if ~isempty(Spi2.SpiHigh)
%                     spiHf=[spiHf;Spi2.SpiHigh(:,2)];
%                 end
%                 if ~isempty(Spi2.SpiLow)
%                     spiLf=[spiLf;Spi2.SpiLow(:,2)];
%                 end
%                 
%             catch
%                 disp('  -> No spindles PFCxdeep  !!!')
%                 tempch=load('ChannelsToAnalyse/PFCx_deep.mat','channel');
%                 if ~isempty(tempch.channel),
%                     disp('         Calculating !!')
%                     eval(['tempLoadB=load(''LFPData/LFP',num2str(tempch.channel),'.mat'',''LFP'');'])
%                     [SpiTot,SWATot,~,TotEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[2 20],Epoch,'off');
%                     [SpiHigh,SWAHigh,~,HiEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[12 15],Epoch,'off');
%                     [SpiLow,SWALow,~,LowEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[9 12],Epoch,'off');
%                     [SpiULow,SWAULow,~,UlowEpoch]=FindSpindlesKarimNewSB(tempLoadB.LFP,[6 8],Epoch,'off');
%                     save SpindlesPFCxDeep SpiTot SpiHigh SpiLow SpiULow SWATot SWAHigh SWALow SWAULow TotEpoch HiEpoch LowEpoch UlowEpoch
%                     
%                     spiHf=[spiHf;SpiHigh(:,2)];
%                     spiLf=[spiLf;SpiLow(:,2)];
%                     clear SpiTot SpiHigh SpiLow SpiULow SWATot SWAHigh SWALow SWAULow TotEpoch HiEpoch LowEpoch UlowEpoch
%                 end
%             end
            if 0
                PETHSpindlesRipplesMLv2;
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
            MATepochs(man,1:length(op))=op;
            MATepochs{man,length(op)+1}=noise;
            MATOSCI(man,1:3)={Dpfc,rip,Spfc};
            
            % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % load time of debRec
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(Dir.path{man});
            manDate(man)=str2num(Dir.path{man}(strfind(Dir.path{man},'/201')+[1:8]));
            if manDate(man)>20160701, hlightON=9; else, hlightON=8;end
            MATZT(man,1:3)=[mod(min(Data(NewtsdZT))/1E4/3600,24),mod(max(Data(NewtsdZT))/1E4/3600,24),hlightON]; % en second
        else
                %keyboard
        end
    end
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<<<< TERMINATION AND SAVING <<<<<<<<<<<<<<<<<<<<<<
    disp('Saving in AnalySubStagesML.mat')
    %MATOSCI=tsdArray(MATOSCI);
    save([res,'/',nameAnaly,'.mat'],'Dir','MATepochs','MATOSCI','MATZT','OptionSpiLow')
end

cd(res)


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< Define substages <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
forceReDo=0;
if ~exist('MATEP','var') || forceReDo==1
    disp('running DefineSubStages.m for all expe'); MATEP={};
    for man=1:length(Dir.path)
        disp(Dir.path{man})
        [temp,nameEpochs]=DefineSubStages(MATepochs(man,1:end-1),MATepochs{man,end},1); % 1 to remove short sleep periods
        MATEP(man,1:length(temp))=temp;
        %if isempty(temp); keyboard;end
    end
    disp(['Adding in ',nameAnaly,'.mat'])
    save([res,'/',nameAnaly,'.mat'],'-append','MATEP','nameEpochs')
    disp('Done'); 
else
    disp('DefineSubStages already computed')
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<< Count Rhythms and coordination <<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp(' '); disp('...Count and coordination of sleep Rhythms')

MATDELT=nan(length(Dir.path),length(nameEpochs)); 
MATRIP=MATDELT; 
MATSPIND=MATDELT;
n_osci=nan(length(Dir.path),length(nameEpochs),3);
for i=1:length(nameEpochs), for io=1:6, MatCoord{i,io}=nan(length(Dir.path),51);end;end
sizeWindow=0.5;%s 20s, 5s, 0.5s or 0.25s
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
                if sizeWindow==20 % nbin=1000 for 20s
                    [Ct,Bt]=CrossSpiRipDeltaML(spiHf,rip,Dpfc,op{i},1000);
                elseif sizeWindow==5 % nbin=200 for 5s
                    [Ct,Bt]=CrossSpiRipDeltaML(spiHf,rip,Dpfc,op{i},200);
                elseif sizeWindow==0.25 %nbin=10 for 0.25s
                    [Ct,Bt]=CrossSpiRipDeltaML(spiHf,rip,Dpfc,op{i},10);
                elseif sizeWindow==0.5 %nbin=10 for 0.5s
                    [Ct,Bt]=CrossSpiRipDeltaML(spiHf,rip,Dpfc,op{i},20);
                end
                
                
                for io=1:6
                    if ~isempty(Bt{io}), bt{io}=Bt{io};end
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
% <<<<<<<<<<<<<<<<<<<< plot Coordination rhythms <<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
L=5;
leg={'Ripples at t-Spindles','Ripples at t-Delta','Spindles at t-Delta',...
    'Delta at t-Ripples','Spindles at t),max(ylim)*1.1-Ripples','Delta at t-Spindles'};
figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.4 0.8]);
for io=1:6
    for i=1:L
        subplot(6,L,(io-1)*L+i), hold on
        temp= MatCoord{i,io};
        if 0
            for man=1:length(Dir.path)
                plot(bt{io}/1E3,temp(man,:),'Color',[0.5 0.5 0.5]);
            end
        end
%         plot(bt{io}/1E3,nansum(temp,1),'Color','k','Linewidth',2)
fil=tsd(bt{io}*10,nanmean(temp,1)');
fil=FilterLFP(fil,[10 16],96);
        plot(bt{io}/1E3,nanmean(temp,1),'Color','k','Linewidth',2)
        plot(bt{io}/1E3,nanmean(temp,1)+nanstd(temp)/sqrt(sum(~isnan(nanmean(temp,2)))),'Color','k')
        plot(bt{io}/1E3,nanmean(temp,1)-nanstd(temp)/sqrt(sum(~isnan(nanmean(temp,2)))),'Color','k')
        plot(bt{io}/1E3,Data(fil),'r')
        if io==1, title(nameEpochs{i});end
        if io==1
            %n=nansum(n_osci(:,i,3));
            n=nanmean(n_osci(:,i,3));N=sum(~isnan(n_osci(:,i,3)));
        else
            %n=nansum(n_osci(:,i,1));
            n=nanmean(n_osci(:,i,1));N=sum(~isnan(n_osci(:,i,1)));
        end
        %if io==3, n2=nansum(n_osci(:,i,3));else,n2=nansum(n_osci(:,i,2));end
        if io==3, n2=nanmean(n_osci(:,i,3));else,n2=nanmean(n_osci(:,i,2));end
        xlim([min(bt{io}/1E3),max(bt{io}/1E3)])
        xlabel(sprintf(['n=%1.0f, N=%d  ',leg{io}(strfind(leg{io},'t-'):end),' (s)'],n,N))
        ylabel(sprintf(['n=%1.0f  ',leg{io}(1:strfind(leg{io},'t-')-4)],n2))
    end
end
if sizeWindow>1, legwin=sprintf('%ds',floor(sizeWindow)); else, legwin=sprintf('%dms',floor(1E3*sizeWindow));end
%if savFig, saveFigure(gcf,['AnalyseNREM_CoordinRipSpinDelta_',legwin],FolderToSave);end

% superimpose Spindles and Ripples at delta
figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.4 0.3])
Col={'k','r'};
for i=1:L
    subplot(1,L,i), hold on,
    legy=[];
    for io=2:3
        temp= MatCoord{i,io};
        plot(bt{io}/1E3,nanmean(temp,1),'Color',Col{io-1},'Linewidth',2)
        plot(bt{io}/1E3,nanmean(temp,1)+nanstd(temp)/sqrt(sum(~isnan(nanmean(temp,2)))),'Color',Col{io-1})
        plot(bt{io}/1E3,nanmean(temp,1)-nanstd(temp)/sqrt(sum(~isnan(nanmean(temp,2)))),'Color',Col{io-1})
        title(nameEpochs{i});xlim([min(bt{io}/1E3),max(bt{io}/1E3)])
        xlim([min(bt{io}/1E3),max(bt{io}/1E3)])
        legy=[legy,sprintf(['  n=%1.0f, ',leg{io}(1:strfind(leg{io},'t-')-4)],n2)];
    end
    line([0 0],ylim,'Color',[0.5 0.5 0.5]); ylabel(legy)
    xlabel(sprintf(['n=%1.0f, N=%d  ',leg{io}(strfind(leg{io},'t-'):end),' (s)'],n,N))
end
legend({leg{2},'std',' ',leg{3}})
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< Restrict mice <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Nmice=[];
%Nmice=[243 244 251 252];
disp(' '); disp(['...Removing mice ',num2str(Nmice)])
indDir=1:length(Dir.path); discardind=[];
for n=1:length(Nmice)
    discardind=[discardind,find(strcmp(Dir.name,sprintf('Mouse%03d',Nmice(n))))];
end
indDir(discardind)=[];

% nameEpochs={'N1','N2','N3','REM','WAKE','SWS','SI','swaPF','swaOB','TOTSleep','WAKEnoise'};



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
%change order of plot
idchange=[1,2,3,4,6,5];
%idchange=1:size(MATDELT,2);


figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.3 0.8]); numF(1)=gcf;
figure('Color',[1 1 1],'unit','Normalized','Position', [0.3 0.05 0.3 0.8]); numF(2)=gcf;
% delta
figure(numF(1)),subplot(3,2,1), PlotErrorBarN(MATDELT(:,idchange),0,1);
n=sum(~isnan(nanmean(MATDELT(:,idchange),2))); N=sum(~isnan(nanmean(MiDELT(:,idchange),2)));
title(sprintf('Delta (n=%d, N=%d)',n,N)); ylabel('Occurance (Hz)');
figure(numF(2)),subplot(3,2,1), PlotErrorBarN(MiDELT(:,idchange),0,1); 
title(sprintf('Delta (N=%d)',N)); ylabel('Occurance (Hz)');

%Spindles
figure(numF(1)),subplot(3,2,3), PlotErrorBarN(MATSPIND(:,idchange),0,1); 
n=sum(~isnan(nanmean(MATSPIND(:,idchange),2))); N=sum(~isnan(nanmean(MiSPIND(:,idchange),2)));
title(sprintf('Spindles (n=%d, N=%d)',n,N)); 
figure(numF(2)),subplot(3,2,3), PlotErrorBarN(MiSPIND(:,idchange),0,1); 
title(sprintf('Spindles (N=%d)',N)); ylabel('Occurance (Hz)');

% Ripples
figure(numF(1)),subplot(3,2,5), PlotErrorBarN(MATRIP(:,idchange),0,1); 
n=sum(~isnan(nanmean(MATRIP(:,idchange),2))); N=sum(~isnan(nanmean(MiRIP(:,idchange),2)));
title(sprintf('Ripples (n=%d, N=%d)',n,N)); ylabel('Occurance (Hz)');
figure(numF(2)),subplot(3,2,5), PlotErrorBarN(MiRIP(:,idchange),0,1);
title(sprintf('Ripples (N=%d)',N)); ylabel('Occurance (Hz)');

% duration tot
figure(numF(1)),subplot(3,2,2), PlotErrorBarN(MATDUR(:,idchange),0,1); 
n=sum(~isnan(nanmean(MATDUR(:,idchange),2))); N=sum(~isnan(nanmean(MiEP(:,idchange),2)));
title(sprintf('Duration (perc of total recording, n=%d, N=%d)',n,N)); 
figure(numF(2)),subplot(3,2,2), PlotErrorBarN(MiEP(:,idchange),0,1); 
title(sprintf('Duration (perc of total recording, N=%d)',N)); 

% duration out of sws
figure(numF(1)),subplot(3,2,4), PlotErrorBarN(MATDURsws(:,idchange),0,1); 
n=sum(~isnan(nanmean(MATDURsws(:,idchange),2))); N=sum(~isnan(nanmean(MiEPsws(:,idchange),2)));
title(sprintf('Duration (perc of NREM, n=%d, N=%d)',n,N)); 
figure(numF(2)),subplot(3,2,4), PlotErrorBarN(MiEPsws(:,idchange),0,1); 
title(sprintf('Duration (perc of NREM, N=%d)',N)); 
% duration out of sleep
figure(numF(1)),subplot(3,2,6), PlotErrorBarN(MATDURs(:,idchange),0,1); 
n=sum(~isnan(nanmean(MATDURs(:,idchange),2))); N=sum(~isnan(nanmean(MiEPs(:,idchange),2)));
title(sprintf('Duration (perc of Sleep, n=%d, N=%d)',n,N)); 
figure(numF(2)),subplot(3,2,6), PlotErrorBarN(MiEPs(:,idchange),0,1); 
title(sprintf('Duration (perc of Sleep, N=%d)',N));

for f=1:2
    for s=1:6
        figure(numF(f)),subplot(3,2,s)
        set(gca,'Xtick',1:length(nameEpochs(idchange)));
        set(gca,'XtickLabel',nameEpochs(idchange));
    end
    if savFig, saveFigure(numF(f).Number,['NREMSubStagesQuantif',num2str(f)],FolderToSave);end
end
%% bar plot and stats for nb of rhythms
idchange=[1,2,3,6,4,5];
%idchange=1:size(MATDELT,2);

figure('Color',[1 1 1],'unit','Normalized','Position', [0.1 0.05 0.3 0.8]);numF=gcf;
% delta
for i=1:3
    if i==1, Mi=MiDELT; tit='Delta';
    elseif i==2, Mi=MiSPIND; tit='Spindles';
    elseif i==3, Mi=MiRIP; tit='Ripples';
    end
    subplot(3,3,(i-1)*3+1), bar(nanmean(Mi(:,idchange)));
    hold on, errorbar(nanmean(Mi(:,idchange)),stdError(Mi(:,idchange)),'+k')
    N=sum(~isnan(nanmean(Mi(:,idchange),2)));
    title(sprintf([tit,' (n=%d)'],N)); ylabel('Occurance (Hz)');
    
    leg={'ranksum : '};
    for n=1:length(idchange)
        legtemp=[nameEpochs{idchange(n)},' vs '];
        for n2=n+1:length(idchange)
            [p,H]=ranksum(Mi(:,idchange(n)),Mi(:,idchange(n2)));
            legtemp=[legtemp,sprintf([nameEpochs{idchange(n2)},': p=%1.3f, '],p)];
        end
        if n<length(idchange), leg=[leg,legtemp]; end
    end
    set(gca,'Xtick',1:length(idchange)); set(gca,'XtickLabel',nameEpochs(idchange));
    xlim([0,length(idchange)+1])
    subplot(3,3,(i-1)*3+(2:3)),text(0,0.5,leg); axis off 
end
if savFig,saveFigure(numF.Number,'NREMSubStagesQuantifRhythms',FolderToSave);end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< indiv repartition substages across sleep time <<<<<<<<<<
HourDay=0:0.5:12; 
colori=[0.7 0.2 0.8 ;1 0 1 ;0.8 0 0.7 ;0.1 0.7 0 ;0.5 0.2 0.1; ones(4,1)*[1 0 0];0.5 0.2 0.1];
NE=5;%length(nameEpochs);
smo=2; %default=2;
for f=1:2
    Y=nan(NE,length(HourDay)-1);
    dozscore=f-1;% 1 to do zscore
    if dozscore, legzsc='zscore';else,legzsc='';end
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.2 0.6 0.6])
    for op=1:NE
        hMat1=nan(length(Dir.path),length(HourDay)-1);
        hMat2=hMat1; hMat3=hMat1;
        for man=indDir
            timZT= [MATZT(man,1)-MATZT(man,3), MATZT(man,2)-MATZT(man,3)];
            for h=1:length(HourDay)-1
                clear I totalT temp swsT sT
                if timZT(1)< HourDay(h+1) && timZT(2)> HourDay(h)
                    I=intervalSet(max(HourDay(h)-timZT(1),0)*3600*1E4,(HourDay(h+1)-timZT(1))*3600*1E4);
                    totalT=(min(HourDay(h+1),timZT(2))-max(HourDay(h),timZT(1)))*3600;
                    if totalT>10*60 % >10min
                        % ratio on total rec
                        temp=sum(Stop(and(I,MATEP{man,op}),'s')-Start(and(I,MATEP{man,op}),'s'));
                        if temp~=0, hMat1(man,h)=100*temp/totalT;end
                        
                        try % ratio on NREMsleep
                            swsT=sum(Stop(and(I,MATEP{man,isws}),'s')-Start(and(I,MATEP{man,isws}),'s'));
                            if swsT~=0, hMat2(man,h)=100*temp/swsT;end
                        end
                        
                        try % ratio on Total sleep time
                            sT=sum(Stop(and(I,MATEP{man,is}),'s')-Start(and(I,MATEP{man,is}),'s'));
                            if sT~=0, hMat3(man,h)=100*temp/sT;end
                        end
                    end
                end
            end
        end
        % display
        A1=nan(length(mice),length(HourDay)-1); A2=A1; A3=A1;
        for mi=1:length(mice)
            ind=find(strcmp(mice(mi),Dir.name));
            %         A1(mi,:)=nanmean(hMat1(ind,:),1)/nanmean(nanmean(hMat1(ind,:),1));
            %         A2(mi,:)=nanmean(hMat2(ind,:),1)/nanmean(nanmean(hMat2(ind,:),1));
            %         A3(mi,:)=nanmean(hMat3(ind,:),1)/nanmean(nanmean(hMat3(ind,:),1));
            ind1=find(~isnan(nanmean(hMat1(ind,:),1)));
            ind2=find(~isnan(nanmean(hMat2(ind,:),1)));
            ind3=find(~isnan(nanmean(hMat3(ind,:),1)));
            if dozscore
                A1(mi,ind1)=zscore(nanmean(hMat1(ind,ind1),1));
                A2(mi,ind2)=zscore(nanmean(hMat2(ind,ind2),1));
                A3(mi,ind3)=zscore(nanmean(hMat3(ind,ind3),1));
            else
                A1(mi,ind1)=nanmean(hMat1(ind,ind1),1);
                A2(mi,ind2)=nanmean(hMat2(ind,ind2),1);
                A3(mi,ind3)=nanmean(hMat3(ind,ind3),1);
            end
            
            %         subplot(3,NE,op),hold on,
            %         plot(HourDay(1:end-1),A1(mi,:),'Color',[0.5 0.5 0.5]);xlim(HourDay([1,end]))
            %         subplot(3,NE,NE+op),hold on,
            %         plot(HourDay(1:end-1),A2(mi,:),'Color',[0.5 0.5 0.5]);xlim(HourDay([1,end]))
            %         subplot(3,NE,2*NE+op),hold on,
            %         plot(HourDay(1:end-1),A3(mi,:),'Color',[0.5 0.5 0.5]); xlim(HourDay([1,end]))
        end
        
        try
            subplot(3,NE,op), hold on,
            %             errorbar(HourDay(1:end-1),nanmean(A1),nanstd(A1)/sqrt(sum(~isnan(nanmean(A1,2)))),...
            %                 'Linewidth',3,'Color',colori(op,:));xlim([9 20]);if dozscore, ylim([-1.5 1.5]);end
            x=HourDay(1:end-1); y=nanmean(A1);
            p= polyfit(x,y,1);[r,pval]=corrcoef(x,y);
            plot(x,smooth(y,smo),'Linewidth',2,'Color',colori(op,:)); line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k')
            plot(x,smooth(y+stdError(A1),smo),'Color',colori(op,:)); plot(x,smooth(y-stdError(A1),smo),'Color',colori(op,:));
            xlim([0 12]);if dozscore, ylim([-1.5 1.5]);end; if op==1, ylabel([legzsc,' %TotRec']);end
            title(sprintf([nameEpochs{op},' r=%0.1f, p=%0.3f'],r(1,2),pval(1,2)),'Color',colori(op,:));
            
            subplot(3,NE,NE+op), hold on,
%             errorbar(HourDay(1:end-1),nanmean(A2),nanstd(A2)/sqrt(sum(~isnan(nanmean(A2,2)))),...
%                 'Linewidth',3,'Color',colori(op,:));xlim([9 20]);if dozscore, ylim([-1.5 1.5]);end
            x=HourDay(1:end-1); y=nanmean(A2);
            p= polyfit(x,y,1);[r,pval]=corrcoef(x,y);
            plot(x,smooth(y,smo),'Linewidth',2,'Color',colori(op,:)); line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k')
            plot(x,smooth(y+stdError(A2),smo),'Color',colori(op,:)); plot(x,smooth(y-stdError(A2),smo),'Color',colori(op,:));
            xlim([0 12]);if dozscore, ylim([-1.5 1.5]);end; if op==1, ylabel([legzsc,' %NREM']);end
            title(sprintf([nameEpochs{op},' r=%0.1f, p=%0.3f'],r(1,2),pval(1,2)),'Color',colori(op,:));
            
            subplot(3,NE,2*NE+op), hold on,
%             errorbar(HourDay(1:end-1),nanmean(A3),nanstd(A3)/sqrt(sum(~isnan(nanmean(A3,2)))),...
%                 'Linewidth',3,'Color',colori(op,:));xlim([9 20]);if dozscore, ylim([-1.5 1.5]);end
            x=HourDay(1:end-1); y=nanmean(A3);
            p= polyfit(x,y,1);[r,pval]=corrcoef(x,y);
            plot(x,smooth(y,smo),'Linewidth',2,'Color',colori(op,:)); line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color','k')
            plot(x,smooth(y+stdError(A3),smo),'Color',colori(op,:)); plot(x,smooth(y-stdError(A3),smo),'Color',colori(op,:));
            xlim([0 12]);if dozscore, ylim([-1.5 1.5]);end; if op==1, ylabel([legzsc,' %TotSleep']);end
            title(sprintf([nameEpochs{op},' r=%0.1f, p=%0.3f'],r(1,2),pval(1,2)),'Color',colori(op,:));
            Y(op,:)=y;
        end
    end
    if savFig, saveFigure(gcf,['NREMSubStages_DecreaseOverDay',legzsc],FolderToSave);end
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< repartition substages across sleep time <<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
disp(' ');disp('...Calculating repartition of substages across sleep time')
HourDay=0:0.5:12;

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
            timZT= [MATZT(man,1)-MATZT(man,3), MATZT(man,2)-MATZT(man,3)];
             if timZT(1)< HourDay(h+1) && timZT(2)> HourDay(h)
                I=intervalSet(max(HourDay(h)-timZT(1),0)*3600*1E4,(HourDay(h+1)-timZT(1))*3600*1E4);
                totalT=(min(HourDay(h+1),timZT(2))-max(HourDay(h),timZT(1)))*3600;
                    
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

% display barplot
disp('...Various plots')
for f=1:2
    
    figure('Color',[1 1 1],'Units','normalized','Position',[0.1 0.1 0.4 0.8])
    if f==1, M1=MATh; M2=MAThplo; else M1=Mih; M2=Mihplo;end
    
    for op=1:6%length(nameEpochs)
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
    colormap pink
%     saveFigure(gcf,['NREMSubStagesEvol',num2str(f),'_',date],FolderToSave)
%     saveFigure(gcf,['NREMSubStagesEvol',num2str(f),'_',date],res)
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

%% check for interindiv variability
grand=[25 40 10 100 200 200];
yl=[3500 6000 3500 200 1500 1500];
if 1
%     dur_mean=nan(length(indDir),6);
%     dur_med=nan(length(indDir),6);
    dur_mean=nan(length(mice),6);
    dur_med=nan(length(mice),6);
    for op=1:6,
        figure('Color',[1 1 1],'Units','normalized','Position',[0.05 0.05 0.4 0.8]);
        %for man=1:length(indDir)
        for man=1:length(mice)
            indmi=find(strcmp(mice{man},Dir.name));
            temp=allEp(find(ismember(allEp(:,1),indmi) & allEp(:,2)==op),4);
            %temp=allEp(find(allEp(:,1)==indDir(man) & allEp(:,2)==op),4);
            
            subplot(3,ceil(size(dur_mean,1)/3),man), hold on,  hist(temp,0:grand(op)/100:grand(op),'Color','k');
            %title(Dir.name{indDir(man)},'Color',colori(floor(64*find(strcmp(Dir.name{indDir(man)},mice))/length(mice)),:));
            title(Dir.name{man},'Color',colori(floor(64*man/length(mice)),:));
            
            xlabel('Duration (s)'); ylabel(['Nb of ',nameEpochs{op},' episods']);
            xlim([0 grand(op)-grand(op)/50]);  %ylim([0,yl(op)])
            
            dur_mean(man,op)=mean(temp);
            dur_med(man,op)=median(temp);
            
            line([mean(temp),mean(temp)],ylim,'Color','r','Linewidth',2)
            text(1.1*mean(temp),0.9*max(ylim),sprintf('mean=%.1fs',mean(temp)),'Color','r')
            
            line([median(temp),median(temp)],ylim,'Color','m','Linewidth',2)
            text(1.1*median(temp),0.8*max(ylim),sprintf('median=%.1fs',median(temp)),'Color','m')
        end
        saveFigure(gcf,['NREMSubStagesDuration_intervar',nameEpochs{op},date],FolderToSave)
    end
    
    figure('Color',[1 1 1],'Units','normalized','Position',[0.05 0.05 0.2 0.4]);
    subplot(2,2,1), PlotErrorBarN(dur_mean(:,[5,4,6]),0,1);ylabel('Mean duration (s)');
    title(sprintf('episod duration (N=%d)',length(~isnan(mean(dur_mean,2)))));
    set(gca,'Xtick',1:3); set(gca,'XtickLabel',nameEpochs([5,4,6]));xlim([0.5 3.5])
    subplot(2,2,2), PlotErrorBarN(dur_mean(:,1:3),0,1);ylabel('Mean duration (s)');
    title(sprintf('episod duration (N=%d)',length(~isnan(mean(dur_mean,2)))));
    set(gca,'Xtick',1:3); set(gca,'XtickLabel',nameEpochs(1:3));xlim([0.5 3.5])
    
    subplot(2,2,3), PlotErrorBarN(dur_med(:,[5,4,6]),0,1);ylabel('Median duration (s)');
    set(gca,'Xtick',1:3); set(gca,'XtickLabel',nameEpochs([5,4,6]));xlim([0.5 3.5])
    subplot(2,2,4), PlotErrorBarN(dur_med(:,1:3),0,1);ylabel('Median duration (s)');
    set(gca,'Xtick',1:3); set(gca,'XtickLabel',nameEpochs(1:3));xlim([0.5 3.5])
    saveFigure(gcf,['NREMSubStagesDuration_intervar',date],FolderToSave)

end



%% display
colori=colormap('jet');
figure('Color',[1 1 1],'Units','normalized','Position',[0.05 0.05 0.4 0.8]); 
for op=1:8,
    temp=allEp(find(allEp(:,2)==op),4);
    subplot(3,6,op), hold on,  hist(temp,0:grand(op)/100:grand(op),'Color','k');
    title(nameEpochs{op}); xlabel('Duration (s)'); ylabel('Nb of episods');
    xlim([0 grand(op)-grand(op)/50]);  ylim([0,yl(op)])
    
    line([mean(temp),mean(temp)],[0 yl(op)],'Color','r','Linewidth',2)
    text(1.1*mean(temp),0.9*yl(op),sprintf('mean=%.1fs',mean(temp)),'Color','r')
    
    line([median(temp),median(temp)],[0 yl(op)],'Color','m','Linewidth',2)
    text(1.1*median(temp),0.8*yl(op),sprintf('median=%.1fs',median(temp)),'Color','m')
    
    
    % separate per day time
    DurMean=nan(length(indDir),length(HourDay)-1);DurMed=DurMean;
    subplot(3,6,6+op),hold on,  
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
    subplot(3,6,12+op),hold on,  
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
L=6;
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
% display
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




% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<< distribution interval inter-delta <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
temp=load('/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM/AnalyNREMsubstagesSD24h_2hStep_Wnz.mat','Dir');
DoDir=temp.Dir(:,1);
DoDir=[DoDir;Dir.path'];

MAT={};name=[];ALL=[];
for man=1:length(DoDir)
    try
        clear Dpfc 
        cd(DoDir{man})
        Dpfc=GetDeltaML;
        MAT{man}=ts(Dpfc);
        ALL=[ALL,diff(Dpfc/10)];
    end
end

figure('Color',[1 1 1]), subplot(1,2,1), hold on,
xh=0:100:5000;
H=nan(length(MAT),length(xh)-1);
for man=1:length(DoDir)
    if ~isempty(MAT{man})
        h=hist(diff(Range(MAT{man},'ms')),xh);
        H(man,:)=100*h(1:end-1)/sum(h(1:end-1));
        plot(xh(1:end-1),smooth(H(man,:),2))
        name=[name;{DoDir{man}(max([strfind(DoDir{man},'Mouse'),strfind(DoDir{man},'Mouse-')+1])+[5:7])}];
    end
end
% atention: outlier /media/DataMOBsRAID/ProjetAstro/Mouse147/20140804/BULB-Mouse-147-04082014
xlabel('Time inter-delta (ms)'); ylabel('%total ISI<5s')
legend(name);

subplot(1,2,2), hold on,
mice=unique(name);
Hmi=nan(length(mice),length(xh)-1);
for mi=1:length(mice)
    id=strcmp(name,mice{mi});
    Hmi(mi,:)=nanmean(H(id,:),1);
    plot(xh(1:end-1),smooth(Hmi(mi,:),2),'Linewidth',2)
end
xlabel('Time inter-delta (ms)'); ylabel('%total ISI<5s')
legend(mice);

N3Thresh=GetGammaThresh(ALL);close
N3Thresh=exp(N3Thresh);
hold on, line(N3Thresh*[1 1],ylim,'Linewidth',3,'Color','r')
text(N3Thresh*1.1,0.9*max(ylim),{'Automatic gaussian fit',sprintf('thresh = %1.0f ms',N3Thresh)},'Color','r')

N2Thresh=2200;
hold on, line(N2Thresh*[1 1],ylim*0.8,'Linewidth',3,'Color','m')
text(N2Thresh*1.05,0.7*max(ylim),{'manual fit',sprintf('thresh = %1.0f ms',N2Thresh)},'Color','m')
