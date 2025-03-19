%AnalyseNREMsubstages_RythmsEvol
%
% list of related scripts in NREMstages_scripts.m 

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
colori=[0.5 0.5 0.5;0 0 0; 0.7 0.2 0.8 ; 1 0.2 0.8 ;1 0 0; 0 0 1;0.5 0.5 0.8;0 1 0;0 0 1 ];
NamesEp={'WAKE','REM','N1','N2','N3','SLEEP','NREM','Total'}; 
savFig=1;
timeZT=[0:0.5:12];%h
res='/media/DataMOBsRAIDN/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
nameAnaly='Analyse_RythmsEvol.mat';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
doNew=1;
if doNew
    %Dir=PathForExperimentsMLnew('Spikes');
    %FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_Spikes';
    FolderToSave='/home/mobsyoda/Dropbox/NREMsubstages-Manuscrit/NewFigs';
    Dir=PathForExperimentsMLnew('BASALlongSleep');
    nameAnaly=[nameAnaly(1:18),'New',nameAnaly(19:end)];
else
    FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NeuronFiringRate';
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
    Dir=RestrictPathForExperiment(Dir,'nMice',[243 244 251]);
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

try
    load([res,'/',nameAnaly]);
    disp([nameAnaly,' has been loaded.'])
catch
    %%%%%%%%%%%%%%%%%%%%%%%%%% INITIATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    RipZT=nan(length(Dir.path),length(NamesEp),length(timeZT)-1);
    DelZT=RipZT; SpiZT=RipZT; DowZT=RipZT;
            
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        try
            
            % %%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear WAKE SLEEP REM N1 N2 N3 NamesStages SleepStages
            % Substages
            disp('- RunSubstages.m')
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages;close;
            % define SLEEP and NREM
            NREM=or(or(N1,N2),N3);
            NREM=mergeCloseIntervals(NREM,10);
            SLEEP=or(NREM,REM);
            SLEEP=mergeCloseIntervals(SLEEP,10);
            Total=or(SLEEP,WAKE);
            Total=mergeCloseIntervals(Total,10);
            
            
            % %%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%%
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(Dir.path{man});
            rgZT=Range(NewtsdZT);
            manDate(man)=str2num(Dir.path{man}(strfind(Dir.path{man},'/201')+[1:8]));
            if manDate(man)>20160701, hlightON=9; else, hlightON=8;end
            
            timeZTman=hlightON+timeZT;%h
            % %%%%%%%%%%%%%%%%%%%%%% GET DOWN %%%%%%%%%%%%%%%%%%%%%%%%%%%
            Down=intervalSet([],[]); 
            disp('Get Down states')
            if exist('DownSpk.mat','file')
                load DownSpk.mat Down
            else
                try
                    [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
                    Down=FindDown(S,nN,NREM,10,0.01,1,0,[0 85],1);
                    SWSEpoch=NREM; neu=nN;
                    save DownSpk.mat Down SWSEpoch neu
                end
            end
            Dow=ts(Start(Down));
            
            % %%%%%%%%%%%%%%%%%%%%%% GET DELTA %%%%%%%%%%%%%%%%%%%%%%%%%%%
            tDelta=GetDeltaML;
            dpfc=ts(tDelta);
            
            % %%%%%%%%%%%%%%%%%%%%%% GET RIPPLES %%%%%%%%%%%%%%%%%%%%%%%%%%
            dHPCrip=GetRipplesML;
            try rip=ts(dHPCrip(:,2)*1E4); catch, rip=ts([]);end
            
            % %%%%%%%%%%%%%%%%%%%%%% GET SPINDLES %%%%%%%%%%%%%%%%%%%%%%%%%
            Spi=[];
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup');
            if ~isempty(SpiHigh), Spi=[Spi;SpiHigh(:,2)]; end
            if ~isempty(SpiLow), Spi=[Spi;SpiLow(:,2)];  end
            
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep');
            if ~isempty(SpiHigh), Spi=[Spi;SpiHigh(:,2)]; end
            if ~isempty(SpiLow), Spi=[Spi;SpiLow(:,2)];  end
            
            Spfc=sort(Spi);
            Spfc(find(diff(Spfc)<0.5)+1)=[];%meme spindles
            Spfc=ts(Spfc*1E4);
            
            % %%%%%%%%%%%%%%%%%%%%%% Evol across ZT %%%%%%%%%%%%%%%%%%%%%%%
            
            [~,MATZT,DurEpZT]=GetEvolutionAcrossZT({rip,dpfc,Spfc,Dow},{WAKE,REM,N1,N2,N3,SLEEP,NREM,Total},NewtsdZT,0,timeZTman);
            RipZT(man,:,:)=MATZT{1};
            DelZT(man,:,:)=MATZT{2};
            SpiZT(man,:,:)=MATZT{3};
            DowZT(man,:,:)=MATZT{4};
        catch
            disp('Problem - skip')
            
        end
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%% SAVE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save([res,'/',nameAnaly],'Dir','NamesEp','RipZT','DelZT','SpiZT','DowZT','timeZT')
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.6 0.4]); numF=gcf;
%indgroup=[2:5]; %REM N1 N2 N3
indgroup=[3:5,7]; % N1 N2 N3 NREM
xZT=3:length(timeZT)-3;
for n=1:length(NamesEp)
    subplot(2,4,4*ismember(n,indgroup)+1),  hold on, 
    temp=squeeze(RipZT(:,n,xZT)); title('Ripples'),
    errorbar(timeZT(xZT),nanmean(temp,1),stdError(temp),'Color',colori(n,:),'Linewidth',2)
    xlim([timeZT(xZT(1))-0.5,timeZT(xZT(end))+0.5])
    
    subplot(2,4,4*ismember(n,indgroup)+2),  hold on,
    temp=squeeze(DelZT(:,n,xZT));title('Delta'),
    errorbar(timeZT(xZT),nanmean(temp,1),stdError(temp),'Color',colori(n,:),'Linewidth',2)
    xlim([timeZT(xZT(1))-0.5,timeZT(xZT(end))+0.5])
    
    subplot(2,4,4*ismember(n,indgroup)+3),  hold on,
    temp=squeeze(SpiZT(:,n,xZT));title('Spindles'),
    errorbar(timeZT(xZT),nanmean(temp,1),stdError(temp),'Color',colori(n,:),'Linewidth',2)
    xlim([timeZT(xZT(1))-0.5,timeZT(xZT(end))+0.5])
    
    subplot(2,4,4*ismember(n,indgroup)+4),  hold on,
    temp=squeeze(DowZT(:,n,xZT));title('Down States'),
    errorbar(timeZT(xZT),nanmean(temp,1),stdError(temp),'Color',colori(n,:))
    xlim([timeZT(xZT(1))-0.5,timeZT(xZT(end))+0.5])
end
restgp=1:length(NamesEp);restgp(indgroup)=[];
subplot(2,4,4), legend(NamesEp(restgp))
subplot(2,4,8), legend(NamesEp(indgroup))
subplot(2,4,1), title({sprintf('N=%d, n=%d',length(unique(Dir.name)),length(Dir.path)),' ','Ripples'})
% saveFigure(numF.Number,'AnalyseNREM-RythmsEvol',FolderToSave)

%% <<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.6 0.4]); numF=gcf;
idEp=[3:5,7];
for n=1:length(idEp)
    subplot(1,4,1),  hold on, 
    temp=squeeze(RipZT(:,idEp(n),:)); title('Ripples'),
    errorbar(timeZT(1:end-1),nanmean(temp,1),stdError(temp),'Color',colori(idEp(n),:),'Linewidth',2)
    xlim([timeZT(1)-0.5,timeZT(end)])
    
    subplot(1,4,2),  hold on,
    temp=squeeze(DelZT(:,idEp(n),:));title('Delta'),
    errorbar(timeZT(1:end-1),nanmean(temp,1),stdError(temp),'Color',colori(idEp(n),:),'Linewidth',2)
    xlim([timeZT(1)-0.5,timeZT(end)])
    
    subplot(1,4,3),  hold on,
    temp=squeeze(SpiZT(:,idEp(n),:));title('Spindles'),
    errorbar(timeZT(1:end-1),nanmean(temp,1),stdError(temp),'Color',colori(idEp(n),:),'Linewidth',2)
    xlim([timeZT(1)-0.5,timeZT(end)])
    
    subplot(1,4,4),  hold on,
    temp=squeeze(DowZT(:,idEp(n),:));title('Down States'),
    errorbar(timeZT(1:end-1),nanmean(temp,1),stdError(temp),'Color',colori(idEp(n),:))
    xlim([timeZT(1)-0.5,timeZT(end)])
end
legend(NamesEp(idEp))




%% Run PETHSpindlesRipplesMLSB - display events shape
% see RunFuctions_ML.m

Dir=PathForExperimentsML('BASAL');
Dir=RestrictPathForExperiment(Dir,'Group','WT');
namedFoldersave='/media/DataMOBsRAIDN/ProjetAstro/Figures/BilanRipplesSpindlesDelta';

for man=1:length(Dir.path)
    
    nameMouseDay=Dir.path{man}(max(strfind(Dir.path{man},'Mouse')):end);
    disp(nameMouseDay)
    clear SWSEpoch
    cd(Dir.path{man})
    try
        try load('StateEpoch.mat','SWSEpoch'); catch, load('StateEpochSB.mat','SWSEpoch');end
        PETHSpindlesRipplesMLSB(pwd,'NameTest',{SWSEpoch}); close
        numF=gcf; saveFigure(numF,['SpindlesRipples_',nameMouseDay],namedFoldersave);close
    catch
        disp(' -> problem');
    end
end
