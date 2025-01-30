% AnalyseOBsubstages_NREMsubstagesPlethysmo.m
%
% see also
% 1. AnalyseOBsubstages_Bilan.m
% 2. AnalyseOBsubstages_BilanRespi.m
% 3. AnalyseOBsubstages_NREMsubstages.m
% 4. AnalyseOBsubstages_NREMsubstagesPlethysmo.m
% 5. AnalyseOBsubstages_Rhythms.m
% 6. AnalyseOBsubstages_SleepCycle.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< Create substages on data plethysmo <<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';
FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureOBstages';
savFig=1;


try
    load([res,'/AnalySubStagesPlethysmo.mat']);
    Dir;
    disp('AnalySubStagesPlethysmo.mat already exists... loading...')
    
catch
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
    Dir=PathForExperimentsML('PLETHYSMO');
    Dir=RestrictPathForExperiment(Dir,'Group',{'WT'});
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    MATepochs={};MATOSCI={};
    OptionSpiLow=1; % 1 to take into account both Low (9-12Hz) and High (12-15Hz) spindles, 0 for High only, (default=1)
    
    for man=1:length(Dir.path)
        disp(Dir.path{man}); cd(Dir.path{man})

        %sleepscoringML; keyboard;
        % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        clear op NamesOp Dpfc Epoch noise wholeEpoch
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
            % <<<<<<<<<<<< load Spindles PFCx Sup <<<<<<<<<<<<<<<<<<
            spiHf=[]; spiLf=[];
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup',wholeEpoch,op{6});
            if ~isempty(SpiHigh)
                spiHf=[spiHf;SpiHigh(:,2)];
            end
            if ~isempty(SpiLow)
                spiLf=[spiLf;SpiLow(:,2)];
            end
            % <<<<<<<<<<<<<<< load Spindles PFCx Deep <<<<<<<<<<<<<<<<<<<<<<<<<
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep',wholeEpoch,op{6});
            if ~isempty(SpiHigh)
                spiHf=[spiHf;SpiHigh(:,2)];
            end
            if ~isempty(SpiLow)
                spiLf=[spiLf;SpiLow(:,2)];
            end
            
            % <<<<<<<<<<<<< check rhythms <<<<<<<<<<<<<<<<<<<<<<<<<<<<
            %PETHSpindlesRipplesMLv2;
            
            % <<<<<<<<<<<<< Sort Spindles <<<<<<<<<<<<<<<<<<<<<<<<<<<<
            clear Spfc
            Spfc=[spiHf;spiLf];
            Spfc=sort(Spfc);
            Spfc(find(diff(Spfc)<0.5)+1)=[];%meme spindles
            Spfc=ts(Spfc*1E4);
           
            % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % op = SupOsci DeepOsci N3 REM WAKE SWS PFswa OBswa
            MATepochs(man,1:length(op))=op;
            MATepochs{man,length(op)+1}=noise;
            MATOSCI(man,1:3)={Dpfc,rip,Spfc};
            
            % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            % load time of debRec
%             disp('... loading rec time with GetZT_ML.m')
%             NewtsdZT=GetZT_ML(Dir.path{man});
%             MATZT(man,1:2)=[min(Data(NewtsdZT)),max(Data(NewtsdZT))]/1E4; % en second
        else
                keyboard
        end
    end
    
    % <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    % <<<<<<<<<<<<<<<<<<<<<<< TERMINATION AND SAVING <<<<<<<<<<<<<<<<<<<<<<
    disp('Saving in AnalySubStagesPlethysmo.mat')
    %MATOSCI=tsdArray(MATOSCI);
    save([res,'/AnalySubStagesPlethysmo.mat'],'Dir','MATepochs','MATOSCI')%,'MATZT'
end


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<< cross corr inspiration and delta waves <<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% dir
Dir=PathForExperimentsML('PLETHYSMO');
Dir=RestrictPathForExperiment(Dir,'Group',{'WT'});

nameEp={'N1','N2','N3'};
colori=[0.6 0.2 1 ;1 0.5 1 ;0.8 0 0.7 ];
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/FigureDeltaOnRespi';

% compute
for n=1:length(nameEp), MATCorr1{n}=nan(length(Dir.path),101);end
MATCorr2=MATCorr1;
nbDelta=nan(length(Dir.path),length(nameEp));
nbInspi=nan(length(Dir.path),length(nameEp));

for man=1:length(Dir.path)
    disp(Dir.path{man})
    cd(Dir.path{man})
    
    % get substages
    clear WAKE REM N1 N2 N3
    disp('- RunSubstages.m')
    try [WAKE,REM,N1,N2,N3]=RunSubstages;close; end
    
    % get Delta waves
    clear Dpfc tDelta
    tDelta=GetDeltaML;
    if exist('WAKE','var') && ~isempty(tDelta)
        Dpfc=ts(tDelta);
        % load respi values
        clear RespiTSD Frequency TidalVolume
        load([Dir.path{man},'/LFPData.mat'],'RespiTSD','Frequency','TidalVolume')
        % plot cross corr
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.3 0.4])
        for n=1:length(nameEp)
            eval(['epoch=',nameEp{n},';'])
            try
                %respiration at time of Delta
                [C1,B]=CrossCorrKB(Range(Restrict(Dpfc,epoch)),Range(Restrict(Frequency,epoch)),20,100);
                subplot(2,length(nameEp),n), hold on,
                plot(B/1E3,C1,'k','Linewidth',2)
                title([nameEp{n},'  Inspiration at t-Delta']);
                if n==2, title({pwd,' ',[nameEp{n},'  Inspiration at t-Delta']});end
                xlabel(sprintf('t-Delta (s), n=%d',length(Range(Restrict(Dpfc,epoch)))),'Color',colori(n,:))
                ylabel(sprintf('Inspi, n=%d',length(Range(Restrict(Frequency,epoch)))),'Color',colori(n,:))
                line([0 0],ylim,'Color',[0.5 0.5 0.5])
                
                % Delta wave at time of Inspiration
                [C2,B]=CrossCorrKB(Range(Restrict(Frequency,epoch)),Range(Restrict(Dpfc,epoch)),20,100);
                subplot(2,length(nameEp),length(nameEp)+n), hold on,
                plot(B/1E3,C2,'k','Linewidth',2)
                title([nameEp{n},'  Delta at t-Inspiration'])
                xlabel(sprintf('t-Inspi (s), n=%d',length(Range(Restrict(Frequency,epoch)))),'Color',colori(n,:))
                ylabel(sprintf('Delta, n=%d',length(Range(Restrict(Dpfc,epoch)))),'Color',colori(n,:))
                line([0 0],ylim,'Color',[0.5 0.5 0.5])
                
                % save
                temp=MATCorr1{n};
                temp(man,:)=C1';
                MATCorr1{n}=temp;
                
                temp=MATCorr2{n};
                temp(man,:)=C2';
                MATCorr2{n}=temp;
                
                nbDelta(man,n)=length(Range(Restrict(Dpfc,epoch)));
                nbInspi(man,n)=length(Range(Restrict(Frequency,epoch)));
            end
            
        end
        % complete and save caracterization
        if 0
            saveFigure(gcf,sprintf('OBSubStagesNREMInspiTrigDelta%d',man),FolderToSave)
            PETHSpindlesRipplesMLv2;
            saveFigure(gcf,sprintf('OBSubStagesBilanRhythms%d',man),FolderToSave);close
        end
        close; 
    end
end

% display
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.3 0.4])
for n=1:length(nameEp) 
    N=sum(~isnan(nanmean(nbDelta(:,n),2)));
    subplot(2,length(nameEp),n), hold on,
    temp=MATCorr1{n};
    plot(B/1E3,nanmean(temp,1),'Color','k','Linewidth',2)
    plot(B/1E3,nanmean(temp,1)+stdError(temp),'Color','k')
    plot(B/1E3,nanmean(temp,1)-stdError(temp),'Color','k')
    title([nameEp{n},'  Inspiration at t-Delta']);
    xlabel(sprintf('t-Delta (s), N=%d, n~=%1.0f',N,nanmean(nbDelta(:,n))),'Color',colori(n,:))
    ylabel(sprintf('Inspi, n~=%1.0f',nanmean(nbInspi(:,n))),'Color',colori(n,:))
    line([0 0],ylim,'Color',[0.5 0.5 0.5])
    
    subplot(2,length(nameEp),length(nameEp)+n), hold on,
    temp=MATCorr2{n};
    plot(B/1E3,nanmean(temp,1),'Color','k','Linewidth',2)
    plot(B/1E3,nanmean(temp,1)+stdError(temp),'Color','k')
    plot(B/1E3,nanmean(temp,1)-stdError(temp),'Color','k')
    title([nameEp{n},'  Delta at t-Inspiration'])
    xlabel(sprintf('t-Inspi (s), N=%d, n~=%1.0f',N,nanmean(nbInspi(:,n))),'Color',colori(n,:))
    ylabel(sprintf('Delta, n~=%1.0f',nanmean(nbDelta(:,n))),'Color',colori(n,:))
    line([0 0],ylim,'Color',[0.5 0.5 0.5])
    
    saveFigure(gcf,'OBSubStagesNREMInspiTrigDelta','/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureOBstages')
end
% ModulationPFCneuronsByBulb_GL2.m


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<< look at respi parameters on substages <<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% dir
Dir=PathForExperimentsML('PLETHYSMO');
Dir=RestrictPathForExperiment(Dir,'Group',{'WT'});
nameEp={'N1','N2','N3','REM','bWAKE','SniffW'};

res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/FigureRespiNREMSubstages';
savFig=1;

try
    load([res,'/AnalyRespiNREMsubstages.mat']);
    Dir;
    disp('AnalyRespiNREMsubstages.mat already exists... loading...')
    
catch
    % initiate
    Mat1=nan(length(Dir.path),length(nameEp));
    Mat2=Mat1;
    
    for man=1:length(Dir.path)
        disp(Dir.path{man})
        cd(Dir.path{man})
        
        % get substages
        clear WAKE REM N1 N2 N3
        disp('- RunSubstages.m')
        try [WAKE,REM,N1,N2,N3]=RunSubstages;close; end
        % other states
        clear REMEpoch SWSEpoch SniffEpoch MovEpoch BasalBreathEpoch
        load StateEpoch REMEpoch SniffEpoch MovEpoch BasalBreathEpoch SWSEpoch 
        N1=and(N1,SWSEpoch);
        N2=and(N2,SWSEpoch);
        N3=and(N3,SWSEpoch);
        REM=REMEpoch;
        SniffW=SniffEpoch;
        bWAKE=and(MovEpoch,BasalBreathEpoch);
        
        % Load Respi
        clear RespiTSD Frequency TidalVolume
        load LFPData RespiTSD Frequency TidalVolume
        
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.3 0.4])
        for i=1:2
            clear matbar matbars x
            if i==1, temp=Frequency; else, temp=TidalVolume;end
            % restrict breathing parameters on epoch
            leg={'ttest2 : '};
            for n=1:length(nameEp)
                eval(['epoch=',nameEp{n},';'])
                matbar(n)=mean(Data(Restrict(temp,epoch)));
                matbars(n)=stdError(Data(Restrict(temp,epoch)));
                x{n}=Data(Restrict(temp,epoch));
                for n2=1:n-1
                    [H,p]=ttest2(x{n2},x{n});
                    leg=[leg,sprintf([nameEp{n},' vs ',nameEp{n2},': p=%1.4f'],p)];
                end
            end
            % plot
            subplot(1,2,i), hold on,
            bar(matbar); errorbar(1:length(nameEp),matbar,matbars,'+k')
            set(gca,'Xtick',1:length(nameEp)); set(gca,'XtickLabel',nameEp);
            if i==1, ylabel('Breathing Frequency (Hz)'); else, ylabel('Tidal Volume (mL)'); end
            title(leg)
            
            % sav all
            eval(['Mat',num2str(i),'(man,:)=matbar;'])%
        end
        xlabel([pwd,'             '])
        
        % save figure
        if savFig, saveFigure(gcf,['AnalyseOB-RespiNREMsubstages-',Dir.name{man}([1,6:end])],FolderToSave); end
        disp('Done.')
    end
    
    %save
    disp('Saving in AnalyRespiNREMsubstages.mat')
    save([res,'/AnalyRespiNREMsubstages.mat'],'Dir','nameEp','Mat1','Mat2')
end

% plot all mice
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.3 0.5])
for i=1:2
    eval(['AA=Mat',num2str(i),';'])
    leg={'ranksum: '};
    for n=1:length(nameEp)
        for n2=n+1:length(nameEp)
            [p,H]=ranksum(AA(:,n),AA(:,n2));
            N=sum(~isnan(mean([AA(:,n),AA(:,n2)],2)));
            leg=[leg,sprintf([nameEp{n},' vs ',nameEp{n2},': p=%1.3f, n=%d'],p,N)];
        end
    end
    subplot(2,3,3*(i-1)+1),PlotErrorBarN(AA,0,1);
    set(gca,'Xtick',1:length(nameEp)); set(gca,'XtickLabel',nameEp);
    if i==1, ylabel('Breathing Frequency (Hz)'); else, ylabel('Tidal Volume (mL)');end
    subplot(2,3,3*(i-1)+2), hold on, bar(nanmean(AA)); errorbar(1:length(nameEp),nanmean(AA),stdError(AA),'+k')
    set(gca,'Xtick',1:length(nameEp)); set(gca,'XtickLabel',nameEp);
    if i==1, ylabel('Breathing Frequency (Hz)'); else, ylabel('Tidal Volume (mL)');end
    subplot(2,3,3*(i-1)+3), text(0.1,0.5,leg); axis off
end
% save figure
if savFig, saveFigure(gcf,'AnalyseOB-RespiNREMsubstagesAll','/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureOBstages'); end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%% Coherence BULB - PFCx %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ParcoursCohPlethy_ML.m

% inputs
struct1='Bulb';
struct2='PFCx';
prof='deep';
NameEpochs={'bWAKE','SNIFF','REM','NREM','N1','N2','N3'};%,'N1wd','N2wd','N3wd'};
Dir=PathForExperimentsML('PLETHYSMO');% 'BASAL'
Dir=RestrictPathForExperiment(Dir,'Group','WT');
savFig=1;
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages';
res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';
Analyname=['AnalyseOBsubstages-Coherence',struct1,struct2,'Respi.mat'];

params.Fs=250;
params.tapers=[3 9];
params.pad=1;
params.fpass=[1 20];
params.err=[1 0.05];
freq=[params.fpass(1):0.1:params.fpass(2)];
movingwin=[3 0.1];

DeltaFreq=[2,4];
% compute
try
    load([res,'/',Analyname]);MatS1;MatS3co;
    disp([Analyname,' already exists. Loaded.'])
catch
    % initiate variables
    MatC=nan(3,length(Dir.path),length(NameEpochs),length(freq));
    MatCCo=MatC;
    MatPh=MatC;
    MatPhCo=MatC;
    MatS1co=MatC;
    MatS2co=MatC;
    MatS3co=MatC;
    MatS1=nan(length(Dir.path),length(NameEpochs),length(freq));
    MatS2=MatS1;
    MatS3=MatS1;
    CdeltaDur=nan(3,length(Dir.path),length(NameEpochs));
    CdeltaAvg=CdeltaDur;
    CdeltaPh=CdeltaDur;
    Gdelta1to2=CdeltaDur;
    Gdelta2to1=CdeltaDur;
    MatconfC=nan(length(Dir.path),3);
    
     for man=1:length(Dir.path)
        cd(Dir.path{man})
        disp(['   * * * ',Dir.name{man},' * * * '])
        
        % deal with noise
        clear GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch
        load StateEpoch GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch
        noise=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
        noise=mergeCloseIntervals(noise,1E3);
        
        % sleep stages
        clear REM NREM Sniff bWAKE
        clear REMEpoch SWSEpoch MovEpoch SniffEpoch BasalBreathEpoch
        load StateEpoch REMEpoch SWSEpoch MovEpoch SniffEpoch BasalBreathEpoch
        REM=REMEpoch-noise; REM=mergeCloseIntervals(REM,10);
        NREM=SWSEpoch-noise; NREM=mergeCloseIntervals(NREM,10);
        SNIFF=SniffEpoch-noise; SNIFF=mergeCloseIntervals(SNIFF,10);
        bWAKE=and(MovEpoch,BasalBreathEpoch)-noise; bWAKE=mergeCloseIntervals(bWAKE,10);
    
        % get substages
        clear N1 N2 N3
        try [WAKE,nREM,N1,N2,N3]=RunSubstages;close; end
        N1=and(N1,NREM);
        N2=and(N2,NREM);
        N3=and(N3,NREM);
        
%         % get periods without delta
%         clear DeltaEpoch N1wd N2wd N3wd
%         [tDelta,DeltaEpoch]=GetDeltaML;
%         N1wd=N1-DeltaEpoch; N1wd=mergeCloseIntervals(N1wd,1);
%         N2wd=N2-DeltaEpoch; N2wd=mergeCloseIntervals(N2wd,1);
%         N3wd=N3-DeltaEpoch; N3wd=mergeCloseIntervals(N3wd,1);
        
        % load LFP struct1
        clear LFP LFP1 channel
        try
            eval(['load ChannelsToAnalyse/',struct1,'_',prof])
            eval(['load LFPData/LFP',num2str(channel)])
            LFP1=LFP;
        end
        
        % load LFP struct2
        clear LFP LFP2 channel 
        try
            eval(['load ChannelsToAnalyse/',struct2,'_',prof])
            eval(['load LFPData/LFP',num2str(channel)])
            LFP2=LFP;
        end
        
        % Load Respi
        clear RespiTSD
        load LFPData RespiTSD
        LFPr=RespiTSD;
        
        % coherence
        clear Ctsd S1tsd S2tsd C phi S12c S1 S2 t f confC phistd
        try
            % ----------------------- CohPlethy.m -------------------------
            LFP1c=ResampleTSD(LFP1,250);
            LFP2c=ResampleTSD(LFP2,250);
            LFP3c=ResampleTSD(LFPr,250);
            disp('CohPlethy... WAIT !')
            disp([struct1,'-',struct2])
            [C12,phi12,S12c,S1,S2,t,f,confC12,phistd]=cohgramc(Data(LFP1c),Data(Restrict(LFP2c,ts(Range(LFP1c)))),movingwin,params);
%           C (magnitude of coherency), phi (phase of coherency), S12 (cross spectrum), S1 (spectrum 1), S2 (spectrum 2), 
%           t (time), f (frequencies), confC (confidence level for C at 1-p %), phistd (theoretical/jackknife
            disp([struct1,'-Respi'])
            [C13,phi13,S12c,S1,S3,t,f,confC13,phistd]=cohgramc(Data(LFP1c),Data(Restrict(LFP3c,ts(Range(LFP1c)))),movingwin,params);
            disp([struct2,'-Respi'])
            [C23,phi23,S12c,S2,S3,t,f,confC23,phistd]=cohgramc(Data(LFP2c),Data(Restrict(LFP3c,ts(Range(LFP2c)))),movingwin,params);
            
            %
            S1tsd=tsd(t*1E4,S1);
            S2tsd=tsd(t*1E4,S2);
            S3tsd=tsd(t*1E4,S3);
            %
            MatconfC(man,:)=[confC12,confC13,confC23];
            nameCo={'12','13','23'};
            for i=1:3
                eval(['C=C',nameCo{i},'; Ph=phi',nameCo{i},';']);
                Ctsd=tsd(t*1E4,C);
                Phtsd=tsd(t*1E4,Ph);
                Cdelta=tsd(t*1E4,nanmean(C(:,f>=DeltaFreq(1) & f<DeltaFreq(2)),2));
                Phdelta=tsd(t*1E4,circ_mean(Ph(:,f>=DeltaFreq(1) & f<DeltaFreq(2))')');
                COepoch=thresholdIntervals(Cdelta,MatconfC(man,i),'Direction','Above');
                    
                for nn=1:length(NameEpochs)
                    eval(['epoch=',NameEpochs{nn},';']);
                    durEp=sum(Stop(epoch,'s')-Start(epoch,'s'));
                    durCoEp=sum(Stop(and(epoch,COepoch),'s')-Start(and(epoch,COepoch),'s'));
                    CdeltaDur(i,man,nn)=durCoEp/durEp;
                    CdeltaAvg(i,man,nn)=nanmean(Data(Restrict(Cdelta,epoch)));
                    CdeltaPh(i,man,nn)=circ_mean(Data(Restrict(Phdelta,epoch)));
                    if i==1
                        MatS1(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S1tsd,epoch)))'),freq));
                        MatS2(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S2tsd,epoch)))'),freq));
                        MatS3(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S3tsd,epoch)))'),freq));
                    end
                    MatS1co(i,man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S1tsd,and(epoch,COepoch))))'),freq));
                    MatS2co(i,man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S2tsd,and(epoch,COepoch))))'),freq));
                    MatS3co(i,man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S3tsd,and(epoch,COepoch))))'),freq));
                    
                    MatC(i,man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(Ctsd,epoch)))'),freq));
                    MatCCo(i,man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(Ctsd,and(epoch,COepoch))))'),freq));
                    MatPh(i,man,nn,:)=Data(Restrict(tsd(f,circ_mean(Data(Restrict(Phtsd,epoch)))'),freq));
                    MatPhCo(i,man,nn,:)=Data(Restrict(tsd(f,circ_mean(Data(Restrict(Phtsd,and(epoch,COepoch))))'),freq));
                end
            end
            disp('Done.')
        catch
            disp('Failed at CohPlethy'); 
            %keyboard
        end
        
        % Granger
        try 
             LFP1; LFP2; LFPr;
             disp('GrangerMarie... WAIT !')
             for nn=1:length(NameEpochs)
                clear granger2 granger_F granger_pvalue Fx2y Fy2x
                eval(['epoch=',NameEpochs{nn},';']);
                
                for i=1:3
                    if i==1
                        do1=LFP1; do2=LFP2; disp([NameEpochs{nn},'- LFP1=',struct1,', LFP2=',struct2]);
                    elseif i==2
                        do1=LFP1; do2=LFPr; disp([NameEpochs{nn},'- LFP1=',struct1,', LFP2=Respi']);
                    elseif i==3
                        do1=LFP2; do2=LFPr; disp([NameEpochs{nn},'- LFP1=',struct2,', LFP2=Respi']);
                    end
                        
                    [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin]= GrangerMarie(do1,do2,epoch,16,params,movingwin,0,freq);
                    GpS12t{i,man,nn}=[granger2, granger_F, granger_pvalue];
                    G1to2(i,man,nn,:)=Fx2y';
                    G2to1(i,man,nn,:)=Fy2x';
                    Gdelta1to2(i,man,nn)=nanmean(Fx2y(freq>=DeltaFreq(1) & freq<DeltaFreq(2)));
                    Gdelta2to1(i,man,nn)=nanmean(Fy2x(freq>=DeltaFreq(1) & freq<DeltaFreq(2)));
                end
                
             end
             disp('Done.')
         catch
             disp('Failed at GrangerMarie')
         end
        
     end
     
     % save
     save([res,'/',Analyname],'Dir','params','movingwin','NameEpochs','MatC','MatconfC','MatPh','MatPhCo',...
         'freq','freqBin','GpS12t','G1to2','G2to1','MatS1','MatS2','MatS3','MatS1co','MatS2co','MatS3co',...
         'CdeltaDur','CdeltaAvg','CdeltaPh','Gdelta1to2','Gdelta2to1'); 
end

%% display
colori={'b','r','k'};
fac=[1,6,1/1E3];
NameEpochs=NameEpochs(1:7);
%mice=unique(Dir.name);
mice={'All'};
for mi=1:length(mice)
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.45 0.8])
    disp(mice{mi})
    if strcmp(mice,'All')
        id=1:length(Dir.path);
    else
        id=find(strcmp(mice{mi},Dir.name));
        if length(id)==1, id=[id id];end
    end
    
    for i=1:3
        for nn=1:length(NameEpochs)
            tempC=squeeze(MatC(i,id,nn,:));
            tempPh=squeeze(MatPh(i,id,nn,:));
            tempG1=squeeze(G1to2(i,id,nn,:));
            tempG2=squeeze(G2to1(i,id,nn,:));
            tempConfC=squeeze(MatconfC(id,i,1));
            
            % spectrum
            eval(['tempS=squeeze(MatS',num2str(i),'(id,nn,:));']);
            subplot(5,length(NameEpochs),nn), hold on,
            plot(freq,fac(i)*(nanmean(tempS,1)),'Color',colori{i},'Linewidth',2);
            plot(freq,fac(i)*(nanmean(tempS,1)+stdError(tempS)),'Color',colori{i});
            plot(freq,fac(i)*(nanmean(tempS,1)-stdError(tempS)),'Color',colori{i});
            title([NameEpochs{nn},' Spectrum']);xlim([1 15]); ylim([0 1.7/1E8])
            
            % spectrum on coherence periods
            eval(['tempSco=squeeze(MatS',num2str(i),'co(i,id,nn,:));']);
            subplot(5,length(NameEpochs),length(NameEpochs)+nn), hold on,
            plot(freq,fac(i)*(nanmean(tempSco,1)),'Color',colori{i},'Linewidth',2);
            plot(freq,fac(i)*(nanmean(tempSco,1)+stdError(tempSco)),'Color',colori{i});
            plot(freq,fac(i)*(nanmean(tempSco,1)-stdError(tempSco)),'Color',colori{i});
            title('Spectrum at coherent time');xlim([1 15]); ylim([0 1.7/1E8])
            
            % coherence
            subplot(5,length(NameEpochs),2*length(NameEpochs)+nn), hold on,
            plot(freq,nanmean(tempC,1),'Color',colori{i},'Linewidth',2);
            plot(freq,nanmean(tempC,1)+stdError(tempC),'Color',colori{i});
            plot(freq,nanmean(tempC,1)-stdError(tempC),'Color',colori{i});
            line(xlim,[0 0]+nanmean(tempConfC),'LineStyle',':','Color',colori{i})
            title([NameEpochs{nn},' Coherence']); xlim([1 15]); ylim([0.3 1])
            
            % granger 1->2
            subplot(5,length(NameEpochs),3*length(NameEpochs)+nn), hold on,
            plot(freqBin,nanmean(tempG1,1),'Color',colori{i},'Linewidth',2);
            plot(freqBin,nanmean(tempG1,1)+stdError(tempG1),'Color',colori{i});
            plot(freqBin,nanmean(tempG1,1)-stdError(tempG1),'Color',colori{i});
            title([NameEpochs{nn},' Granger']);xlim([1 15]); ylim([0 0.3])
            % granger 2->1
            subplot(5,length(NameEpochs),4*length(NameEpochs)+nn), hold on,
            plot(freqBin,nanmean(tempG2,1),'Color',colori{i},'Linewidth',2);
            plot(freqBin,nanmean(tempG2,1)+stdError(tempG2),'Color',colori{i});
            plot(freqBin,nanmean(tempG2,1)-stdError(tempG2),'Color',colori{i});
            title([NameEpochs{nn},' Granger ']);xlim([1 15]); ylim([0 1])
        end
    end
    subplot(5,length(NameEpochs),nn), hold on,
    legend({struct1,'std','',struct2,'std','','Respi'});
    subplot(5,length(NameEpochs),length(NameEpochs)+nn), hold on,
    legend({[struct1,'-',struct2],'std','','Confidence',[struct1,'-Respi'],'std','','Confidence',[struct2,'-Respi']});
    subplot(5,length(NameEpochs),2*length(NameEpochs)+nn), hold on,
    legend({[struct1,'-',struct2],'std','','Confidence',[struct1,'-Respi'],'std','','Confidence',[struct2,'-Respi']});
    subplot(5,length(NameEpochs),3*length(NameEpochs)+nn), hold on,
    legend([struct1,'->',struct2],'std','',[struct1,'->Respi'],'std','',[struct2,'->Respi']);
    subplot(5,length(NameEpochs),4*length(NameEpochs)+nn), hold on,
    legend([struct2,'->',struct1],'std','',['Respi->',struct1],'std','',['Respi->',struct2]);
    %if savFig, saveFigure(gcf,sprintf(['AnalyseOB-CohGranger',struct1,'-',struct2,'-Respi']),FolderToSave);end
    %keyboard% return
end

%% BULB-Respi only
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.1 0.45 0.7]),

colori=[0.7 0.2 0.1 ;0.5 0.5 0.5; 0 0.5 0.1;1 0 1];
i=2; L=4;
for nn=1:L
    tempC=squeeze(MatC(i,id,nn,:));
    tempConfC=squeeze(MatconfC(id,i,1));
    tempS1=squeeze(MatS1(:,nn,:))*1E3;
    tempS3=squeeze(MatS3(:,nn,:));
    
    % spectrum
    subplot(2,3,nn), hold on,
    plot(freq,(nanmean(tempS1,1)),'b','Linewidth',2);
    plot(freq,(nanmean(tempS3,1)),'k','Linewidth',2);
    if nn==L, legend({'Bulb','Resp'});end
    plot(freq,(nanmean(tempS1,1)+stdError(tempS1)),'b');
    plot(freq,(nanmean(tempS1,1)-stdError(tempS1)),'b');
    plot(freq,(nanmean(tempS3,1)+stdError(tempS3)),'k');
    plot(freq,(nanmean(tempS3,1)-stdError(tempS3)),'k');
    title([NameEpochs{nn},' Spectrum']);xlim([1 15]); ylim([0 1.7/1E5])
    
    % Respi spectrum
    subplot(2,3,5), hold on,
    plot(freq,nanmean(tempS3,1),'Color',colori(nn,:),'Linewidth',2);
    
    % coherence
    subplot(2,3,6), hold on,
    plot(freq,nanmean(tempC,1),'Color',colori(nn,:),'Linewidth',2);
end
legend(NameEpochs(1:L)),
for nn=1:L
    tempC=squeeze(MatC(i,id,nn,:));
    tempS3=squeeze(MatS3(:,nn,:));
    
    subplot(2,3,5),
    plot(freq,nanmean(tempS3,1)+stdError(tempS3),'Color',colori(nn,:));
    plot(freq,nanmean(tempS3,1)-stdError(tempS3),'Color',colori(nn,:));
    
    subplot(2,3,6),
    plot(freq,nanmean(tempC,1)+stdError(tempC),'Color',colori(nn,:));
    plot(freq,nanmean(tempC,1)-stdError(tempC),'Color',colori(nn,:));
end
line(xlim,[0 0]+nanmean(tempConfC),'LineStyle',':','Color',colori(nn,:))
title(' Coherence'); xlim([1 15]); ylim([0.3 1])
subplot(2,3,5),xlim([1 15]);ylim([0 1.7/1E5]); title('Respi Spectrum')


%% quantif
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.1 0.55 0.8]), 
for i=1:3
    if i==1
        leg={'Bulb-PFCx'}; legG={'Bulb -> PFCx','PFCx -> Bulb'};
    elseif i==2,
        leg={'Bulb-Resp'};legG={'Bulb -> Resp','Resp -> Bulb'};
    elseif i==3,
        leg={'PFCx-Resp'};legG={'PFCx -> Resp','Resp -> PFCx'};
    end
    dDur=squeeze(CdeltaDur(i,:,1:7));
    dMeanC=squeeze(CdeltaAvg(i,:,1:7));
    dPhC=squeeze(CdeltaPh(i,:,1:7));
    idPh=find(~isnan(mean(dPhC,2)));
    dG1to2=squeeze(Gdelta1to2(i,:,1:7));
    dG2to1=squeeze(Gdelta2to1(i,:,1:7));
    
    subplot(3,5,(i-1)*5+1), bar(100*nanmean(dDur,1)); %PlotErrorBarN(100*dDur,0,1);
    hold on, errorbar(1:length(NameEpochs),100*nanmean(dDur,1),100*stdError(dDur),'+k')
    set(gca,'Xtick',1:length(NameEpochs)); set(gca,'XtickLabel',NameEpochs);
    title({'% period with Significant Coherence',[leg{:},' at 2-4Hz']}); ylim([0 100])
    
    subplot(3,5,(i-1)*5+2), bar(nanmean(dMeanC,1));%PlotErrorBarN(dMeanC,0,1);
    hold on, errorbar(1:length(NameEpochs),nanmean(dMeanC,1),stdError(dMeanC),'+k')
    set(gca,'Xtick',1:length(NameEpochs)); set(gca,'XtickLabel',NameEpochs);
    title(['averaged 2-4Hz Coherence ',leg]); ylim([0 0.9])
    
    subplot(3,5,(i-1)*5+3), bar(circ_mean(dPhC(idPh,:)));%PlotErrorBarN(dPhC,0,1);
    hold on, errorbar(1:length(NameEpochs),circ_mean(dPhC(idPh,:)),stdError(dPhC(idPh,:)),'+k')
    set(gca,'Xtick',1:length(NameEpochs)); set(gca,'XtickLabel',NameEpochs);
    title({'averaged Phase of coherence',[leg{:},' at 2-4Hz']}); ylim([-pi, pi])
    
    subplot(3,5,(i-1)*5+4), bar(nanmean(dG1to2,1));%PlotErrorBarN(dG1to2,0,1);
    hold on, errorbar(1:length(NameEpochs),nanmean(dG1to2,1),stdError(dG1to2),'+k')
    set(gca,'Xtick',1:length(NameEpochs)); set(gca,'XtickLabel',NameEpochs);
    title(['averaged 2-4Hz Granger ',legG(1)]); ylim([0 0.4])
    
    subplot(3,5,i*5), bar(nanmean(dG2to1,1));%PlotErrorBarN(dG2to1,0,1);
    hold on, errorbar(1:length(NameEpochs),nanmean(dG2to1,1),stdError(dG2to1),'+k')
    set(gca,'Xtick',1:length(NameEpochs)); set(gca,'XtickLabel',NameEpochs);
    title(['averaged 2-4Hz Granger ',legG(2)]);ylim([0 0.4]) 
end
%saveFigure(gcf,sprintf('AnalyseOB-QuantifCoherenceOB-PFCx-Respi'),FolderToSave);