% AnalyseOBsubstages_BilanRespi.m
% 
% see also
% 1. AnalyseOBsubstages_Bilan.m
% 2. AnalyseOBsubstages_BilanRespi.m
% 3. AnalyseOBsubstages_NREMsubstages.m
% 4. AnalyseOBsubstages_NREMsubstagesPlethysmo.m
% 5. AnalyseOBsubstages_Rhythms.m
% 6. AnalyseOBsubstages_SleepCycle.m

%% Pre Process data
% CodeRespi_NewWifi_INTAN_ML
% CodeBulbRespiML.m
% Plot_RespiLFP_ML
% plotRespiLFPML.m
% PlethysmoSignalML.m
% GetRespiFromAccelerometer.m
%% other code Respi
% RespiTrigLFPML.m / RespiTrigLFP2ML.m (average LFP on time of inspiration, Grosmaitre 2009)
% DistributionRespiFrequency.m
% FindRespiAndMovEpochs.m
% CodeRespi.m
% PlotBilanRespiML.m
% ParcoursCohPlethy_ML.m
% RespiLFP_MLOneMore.m / correlationRespi_LFPML.m
% LFP_by_RespiFreqML.m / LFP_by_RespiFreqML_bis.m
% RespirationByDeltaML.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%% FiguresDataClub8juin2015.m %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% representative exemple of gamma spectrum and Respi+LFP 
% are in FiguresDataClub8juin2015.m !!


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%% DistributionRespiFrequency.m %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
savFig=1;
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages';
% ------------------ load data ------------------
res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';
Analyname='AnalyseOBsubstages-RespiWT.mat';
if ~exist('InfoDistrib','var')
    load([res,'/',Analyname]);InfoRespi;
end

% ------------------  pool data  ------------------
nameEpoch={'SWSEpoch','REMEpoch','MovEpoch'};%,'SniffEpoch','BasalBreathEpoch'};
%nameStateEpoch: {'ThetaMovEpoch','MovEpoch','SWSEpoch','REMEpoch','SniffEpoch','BasalBreathEpoch'};  
colori=[1 0 1;0.1 0.7 0;0.7 0.2 0.1;0 0 0 ;0.5 0.5 0.5];
clear InfoDistrib2 TimeDistrib2
for nn=1:length(nameEpoch)
    id=find(strcmp(nameStateEpoch,nameEpoch{nn}));
    MiceNames=unique(InfoDistrib{id}(:,2)); MiceNames=MiceNames(~isnan(MiceNames));
    MatrixDataInfo=InfoDistrib{id}; MatrixData=TimeDistrib{id};
    MatrixDataInfo_temp=[]; MatrixData_temp=[];
    for uu=1:length(MiceNames)
        index=find(MatrixDataInfo(:,2)==MiceNames(uu));
        if ~isempty(index) && (sum(isnan(nanmean(MatrixData(index,:),1)))~=size(MatrixData,2))
            MatrixData_temp=[MatrixData_temp;SmoothDec(nanmean(MatrixData(index,:),1),smofact)'];
            MatrixDataInfo_temp=[MatrixDataInfo_temp;[unique(MatrixDataInfo(index,1)) unique(MatrixDataInfo(index,2))]];
        end
    end
    InfoDistrib2{nn}=MatrixDataInfo_temp;
    TimeDistrib2{nn}=MatrixData_temp;
end

% ------------------ display ------------------
figure('Color',[1 1 1]), hold on
leg=[];
for nn=1:length(nameEpoch)
    MatData=TimeDistrib2{nn};
    MatrixDataInfo=InfoDistrib2{nn};
    % individual mice
    Mat=nan(size(MatData));
    for l=1:size(MatData,1)
        try Mat(l,:)=100*MatData(l,:)/sum(MatData(l,:)); end
    end
    % percentage of stage
    meanstr=nanmean(Mat,1);
    plot(xindex,nanmean(Mat,1),'Color',colori(nn,:),'Linewidth',2)
    plot(xindex,nanmean(Mat,1)+stdError(Mat),'Color',colori(nn,:));
    plot(xindex,nanmean(Mat,1)-stdError(Mat),'Color',colori(nn,:));
    xlim(FreqRange)
    % stats: Cramer, homogeneity distribution
    try
        temp=[];
        for dis=1:length(xindex)
            for tdis=1:round(meanstr(dis))
                temp=[temp,xindex(dis)];
            end
        end
        xx{nn}=temp;
    end
    leg=[leg,{nameEpoch{nn},'stdErr',' '}];
end
xlabel('Frequency (Hz)')
hold on, line([4 4],ylim,'Color','k'); line([4.5 4.5],ylim,'Color','k')
legend([leg,{'Basal/Sniff'}])
% ------------------ display stats cramer -------------
Leg={'Cramer : '};
ylabel('% State Duration');
for nn=1:length(nameEpoch)
    for n2=nn+1:length(nameEpoch)
        try [h,p] = kstest2(xx{nn},xx{n2}); catch, p=NaN;end
        Leg=[Leg,sprintf([nameEpoch{nn},' vs ',nameEpoch{n2},': n=%d, p=%1.4f'],sum(~isnan(nanmean(Mat,2))),p)];
    end
end
title(Leg);yl=ylim; ylim([0 yl(2)]);
% ------------------ save figure -------------
if savFig
    saveFigure(gcf,'AnalyseOB-RespiDistrib',FolderToSave)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%% Run_ZAPRespi2_ML.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NameStates={'SWSEpoch' 'REMEpoch' 'MovEpoch' };
NameTypeFreq={'Delta'};%'HighGamma' 'LowGamma'
for i=1:length(NameTypeFreq)
    for j=1:length(NameStates)
        Run_ZAPRespi2_ML(NameStates{j},NameTypeFreq{i});
        close all;
    end
colori=[0.7 0.2 0.1; 1 0 1;0.1 0.7 0];
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%% CodeBulbAnalyRespiML.m %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dir=PathForExperimentsML('PLETHYSMO');
Dir=RestrictPathForExperiment(Dir,'Group',{'WT'});
NameEpochs={'ThetaMovEpoch','MovEpoch','SWSEpoch','REMEpoch'};
f_respi=[0.01:0.02:20];

MATrespi=nan(2,length(Dir.path),length(NameEpochs));
for man=1:length(Dir.path)
    disp(['           * * * ',Dir.path{man}(strfind(Dir.path{man},'Mouse'):strfind(Dir.path{man},'Mouse')+7),' * * *'])
    
    % load respi values
    clear RespiTSD Frequency TidalVolume
    load([Dir.path{man},'/LFPData.mat'],'RespiTSD','Frequency','TidalVolume')
    
    clear SWSEpoch REMepoch MovEpoch ThetaMovEpoch ThetaEpoch
    for nn=1:length(NameEpochs)
        % -- load epochs --
        if sum(strcmp(NameEpochs{nn},'ThetaMovEpoch')),
            try
                eval(['load(''',Dir.path{man},'/StateEpoch.mat'',''MovEpoch'',''ThetaEpoch'')'])
                ThetaMovEpoch=and(MovEpoch,ThetaEpoch);Start(ThetaMovEpoch);
            catch
                ThetaMovEpoch=intervalSet([],[]);
            end
        else
            eval(['load(''',Dir.path{man},'/StateEpoch.mat'',''',NameEpochs{nn},''')'])
            eval(['Start(',NameEpochs{nn},');'])
        end
        
        clear fEpoch SpEpoch
        eval(['epoch=',NameEpochs{nn},';'])
        % -- Analyse frequency --
        tempData=Data(Restrict(Frequency,epoch));
        [SpEpoch,fEpoch]=hist(tempData(tempData<20),f_respi);
        tot=sum(SpEpoch);
        SpEpoch=SpEpoch*100/tot;
        % -- tidal volume --
        Amp=Data(Restrict(TidalVolume,epoch));
        % -- Construct Mat --
        if isempty(Start(epoch))==0
            MATrespi(1,man,nn)=fEpoch(SmoothDec(SpEpoch,10)==max(SmoothDec(SpEpoch,10)));
            MATrespi(2,man,nn)=mean(Amp);
        end
    end
end

% display
mice=unique(Dir.name);
for f=1:2
    if f==1
        % pool mice
        Mat=nan(2,length(mice),length(NameEpochs));
        for mi=1:length(mice)
            id=find(strcmp(Dir.name,mice{mi}));
            temp1=squeeze(MATrespi(1,id,:));
            Mat(1,mi,:)=nanmean(temp1,1);
            temp2=squeeze(MATrespi(2,id,:));
            Mat(2,mi,:)=nanmean(temp2,1);
        end
    else
        Mat=MATrespi;
    end
    
    nameLeg={'Respi Frequency (Hz)','Respi Amplitude (mL)','Respi Spectrum'};
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.3 0.4])
    for i=1:2
        A=squeeze(Mat(i,:,:));
        subplot(1,2,i), PlotErrorBarN(A,0,1)
        Leg={'signrank : '};
        for nn=1:length(NameEpochs)
            for n2=nn+1:length(NameEpochs)
                a=find(~isnan(A(:,nn)) & ~isnan(A(:,n2)));
                [p,h]= signrank(A(a,nn),A(a,n2));
                %[H,p]=ttest2(A(:,nn),A(:,n2));
                nexpe=sum(isnan(nanmean(A(:,[nn,n2]),2))==0);
                Leg=[Leg,sprintf([NameEpochs{nn}(1:end-5),' vs ',NameEpochs{n2}(1:end-5),': n=%d, p=%1.4f'],nexpe,p)];
            end
        end
        title(Leg);ylabel(nameLeg{i})
        set(gca,'Xtick',1:length(NameEpochs)), set(gca,'XtickLabel',NameEpochs)
    end
    if savFig
        saveFigure(gcf,sprintf('AnalyseOB-RespiAmpFreqQuantif%d',f),FolderToSave)
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%% Respi according to SpectrumOB %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir=PathForExperimentsML('PLETHYSMO');
Dir=RestrictPathForExperiment(Dir,'Group',{'WT'});
NameEpochs={'MovEpoch','SWSEpoch','REMEpoch'};
% correlation amp / sp2-4
% correlation freq / sp2-4
Mat={};
for man=1:length(Dir.path)
    disp(['           * * * ',Dir.path{man}(strfind(Dir.path{man},'Mouse'):strfind(Dir.path{man},'Mouse')+7),' * * *'])
    cd(Dir.path{man})
    % load respi values
    clear Frequency TidalVolume
    load LFPData.mat Frequency TidalVolume
    % load Sp Bulb
    clear channel Sp f t SPtsd
    load ChannelsToAnalyse/Bulb_deep.mat channel
    if ~isempty(channel)
        eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'',''Sp'',''t'',''f'');',channel))
        SPtsd=tsd(t*1E4,mean(Sp(:,find(f>=2 & f<4)),2)); % 2-4Hz
        SPztsd=tsd(t*1E4,zscore(mean(Sp(:,find(f>=2 & f<4)),2))); % 2-4Hz
        %
        clear SWSEpoch REMepoch MovEpoch
        for nn=1:length(NameEpochs)
            % -- load epochs --
            eval(['load(''',Dir.path{man},'/StateEpoch.mat'',''',NameEpochs{nn},''')'])
            eval(['epoch=',NameEpochs{nn},';'])
            
            if length(Range(Restrict(Frequency,epoch)))<=length(Range(Restrict(TidalVolume,epoch)))
                rg=ts(Range(Restrict(Frequency,epoch)));
            else
                rg=ts(Range(Restrict(TidalVolume,epoch)));
            end
            clear temp
            temp(1:length(Range(rg)),1)=Data(Restrict(Frequency,rg));
            temp(1:length(Range(rg)),2)=Data(Restrict(TidalVolume,rg));
            temp(1:length(Range(rg)),3)=Data(Restrict(SPtsd,rg));
            temp(1:length(Range(rg)),4)=Data(Restrict(SPztsd,rg));
            Mat{man,nn}=temp;
        end
        disp('done')
    else
        disp('no bulb')
    end
end
%%
colori=[0.7 0.2 0.1; 1 0 1;0.1 0.7 0];
for f=1:2
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.3 0.6]),
    if f==1, tit='Power'; else tit='zscore';end
    for nn=1:length(NameEpochs)
        MatcCor=[];mice=[];
        for man=1:length(Dir.path)
            try MatcCor=[MatcCor;Mat{man,nn}]; mice=[mice,Dir.name(man)];end
        end
        % Freq
        subplot(2,length(NameEpochs),nn),
        hold on,plot(MatcCor(:,2+f),MatcCor(:,1),'k.','MarkerSize',1)
        xlabel([tit,' Bulb spectrum 2-4Hz'])
        ylabel('Breathing Frequency (Hz)')
        py= polyfit(MatcCor(:,2+f),MatcCor(:,1),1);
        a=[min(MatcCor(:,2+f)),max(MatcCor(:,2+f))];
        line(a,py(2)+a*py(1),'Color',colori(nn,:),'Linewidth',2)
        [r,p]=corrcoef(MatcCor(:,2+f),MatcCor(:,1));
        title({sprintf([NameEpochs{nn},': r=%0.1f, p=%0.3f'],r(1,2),p(1,2)),...
            sprintf('n=%d time, N=%d animals',size(MatcCor,1),length(unique(mice)))},'Color',colori(nn,:))
        
        % Volume
        subplot(2,length(NameEpochs),length(NameEpochs)+nn),
        hold on, plot(MatcCor(:,2+f),MatcCor(:,2),'k.','MarkerSize',1)
        xlabel([tit,' Bulb spectrum 2-4Hz'])
        ylabel('Breathing Volume (mL)')
        py= polyfit(MatcCor(:,2+f),MatcCor(:,2),1);
        a=[min(MatcCor(:,2+f)),max(MatcCor(:,2+f))];
        line(a,py(2)+a*py(1),'Color',colori(nn,:),'Linewidth',2)
        [r,p]=corrcoef(MatcCor(:,2+f),MatcCor(:,2));
        title({sprintf([NameEpochs{nn},': r=%0.1f, p=%0.3f'],r(1,2),p(1,2)),...
            sprintf('n=%d time, N=%d animals',size(MatcCor,1),length(unique(mice)))},'Color',colori(nn,:))
    end
    if savFig
        saveFigure(gcf,sprintf('AnalyseOB-CorrBOspRespi%d',f),FolderToSave)
    end
end

% figure thèse quantif
figure('color',[1 1 1])
lim=0.92;
nn=1;
MatcCor=[];mice=[];
        for man=1:length(Dir.path)
            try MatcCor=[MatcCor;Mat{man,nn}]; mice=[mice,Dir.name(man)];end
        end
subplot(2,3,1),PlotErrorBar2(MatcCor(find(MatcCor(:,4)<-lim),1),MatcCor(find(MatcCor(:,4)>lim),1),0,0),title(NameEpochs{nn})
subplot(2,3,4), PlotErrorBar2(MatcCor(find(MatcCor(:,4)<-lim),2),MatcCor(find(MatcCor(:,4)>lim),2),0,0),title(NameEpochs{nn}) 

nn=3;
MatcCor=[];mice=[];
        for man=1:length(Dir.path)
            try MatcCor=[MatcCor;Mat{man,nn}]; mice=[mice,Dir.name(man)];end
        end
subplot(2,3,2),PlotErrorBar2(MatcCor(find(MatcCor(:,4)<-lim),1),MatcCor(find(MatcCor(:,4)>lim),1),0,0),title(NameEpochs{nn})
subplot(2,3,5), PlotErrorBar2(MatcCor(find(MatcCor(:,4)<-lim),2),MatcCor(find(MatcCor(:,4)>lim),2),0,0),title(NameEpochs{nn}) 

nn=2;
MatcCor=[];mice=[];
        for man=1:length(Dir.path)
            try MatcCor=[MatcCor;Mat{man,nn}]; mice=[mice,Dir.name(man)];end
        end
subplot(2,3,3),PlotErrorBar2(MatcCor(find(MatcCor(:,4)<-lim),1),MatcCor(find(MatcCor(:,4)>lim),1),0,0),title(NameEpochs{nn})
subplot(2,3,6), PlotErrorBar2(MatcCor(find(MatcCor(:,4)<-lim),2),MatcCor(find(MatcCor(:,4)>lim),2),0,0),title(NameEpochs{nn}) 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%% ParcoursCohPlethy_ML.m %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% inputs
struct1='Bulb';
%struct1='Respi';% 'PaCx' 'dHPC'
struct2='PFCx';
prof='deep';
NameEpochs={'MovEpoch','SWSEpoch','REMEpoch'};
Dir=PathForExperimentsML('PLETHYSMO');% 'BASAL'
Dir=RestrictPathForExperiment(Dir,'Group','WT');
savFig=1;
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages';
res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';
Analyname=['AnalyseOBsubstages-Coherence',struct1,struct2,'.mat'];

params.Fs=250;
params.tapers=[3 9];
params.pad=1;
params.fpass=[1 20];
params.err=[1 0.05];
freq=[params.fpass(1):0.1:params.fpass(2)];
movingwin=[3 0.1];

% compute
try
    load([res,'/',Analyname]);MatS1;
    disp([Analyname,' already exists. Loaded.'])
catch
    % initiate variables
    MatC=nan(length(Dir.path),length(NameEpochs),length(freq));
    MatS1=MatC;
    MatS2=MatC;
    MatS1co=MatC;
    MatS2co=MatC;
    MatPh=MatC;
    MatconfC=nan(1,length(Dir.path));
    
     for man=1:length(Dir.path)
        cd(Dir.path{man})
        disp(['   * * * ',Dir.name{man},' * * * '])
        % state epochs
        clear REMEpoch SWSEpoch MovEpoch
        try
            load StateEpoch REMEpoch SWSEpoch MovEpoch
            REMEpoch;SWSEpoch;MovEpoch;
        catch
            disp('Problem StateEpoch')
        end
        
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
        if strcmp(struct1,'Respi')
            load LFPData RespiTSD
            LFP1=RespiTSD;
        elseif strcmp(struct2,'Respi')
            load LFPData RespiTSD
            LFP2=RespiTSD;
        end
        if ~exist('LFP1','var') || ~exist('LFP1','var')
            disp(['Problem load ',struct1,' & ',struct2]);
        end
        
        % coherence
        clear Ctsd S1tsd S2tsd C phi S12c S1 S2 t f confC phistd
        try
            % ----------------------- CohPlethy.m -------------------------
            LFP1c=ResampleTSD(LFP1,250);
            LFP2c=ResampleTSD(LFP2,250);
            disp('CohPlethy... WAIT !')
            [C,phi,S12c,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1c),Data(Restrict(LFP2c,ts(Range(LFP1c)))),movingwin,params);
%           C (magnitude of coherency), phi (phase of coherency), S12 (cross spectrum), S1 (spectrum 1), S2 (spectrum 2), 
%           t (time), f (frequencies), confC (confidence level for C at 1-p %), phistd (theoretical/jackknife
            Ctsd=tsd(t*1E4,C);
            Phtsd=tsd(t*1E4,phi);
            S1tsd=tsd(t*1E4,S1);
            S2tsd=tsd(t*1E4,S2);
            MatconfC(man,1)=confC;
            CohEpoch=thresholdIntervals(Ctsd,confC,'Direction','Above');
            for nn=1:length(NameEpochs)
                eval(['epoch=',NameEpochs{nn},';']);
                durEp=sum(Stop(epoch,'s')-Start(epoch,'s'));
                durCoEp=sum(Stop(and(epoch,CohEpoch),'s')-Start(and(epoch,CohEpoch),'s'));
                MatconfC(man,nn+1)=durCoEp/durEp;
                
            	MatC(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(Ctsd,epoch)))'),freq));
            	MatPh(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(Phtsd,epoch)))'),freq));
            	MatS1(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S1tsd,epoch)))'),freq));
            	MatS2(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S2tsd,epoch)))'),freq));
            	MatS1co(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S1tsd,and(epoch,CohEpoch))))'),freq));
            	MatS2co(man,nn,:)=Data(Restrict(tsd(f,mean(Data(Restrict(S2tsd,and(epoch,CohEpoch))))'),freq));
            end
            disp('Done.')
        catch
            disp('Failed at CohPlethy'); 
        end
        
        % Granger
        try 
             LFP1; LFP2;
             disp('GrangerMarie... WAIT !')
             for nn=1:length(NameEpochs)
                clear granger2 granger_F granger_pvalue Fx2y Fy2x
                eval(['epoch=',NameEpochs{nn},';']);
                disp([NameEpochs{nn},'- LFP1=',struct1,', LFP2=',struct2])
                [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin]= GrangerMarie(LFP1,LFP2,epoch,16,params,movingwin,0);
                GpS12t{man,nn}=[granger2, granger_F, granger_pvalue];
                G1to2(man,nn,:)=Fx2y';
                G2to1(man,nn,:)=Fy2x';
             end
             disp('Done.')
         catch
             disp('Failed at GrangerMarie')
         end
        
     end
     % save
     save([res,'/',Analyname],'Dir','params','movingwin','NameEpochs','MatC','MatconfC','MatPh','freq','freqBin','GpS12t','G1to2','G2to1','MatS1','MatS2');
end

% display
for nn=1:length(NameEpochs)
    for i=1:3, subplot(3,length(NameEpochs),(i-1)*length(NameEpochs)+nn), ;end
end
colori=[0.7 0.2 0.1; 1 0 1;0.1 0.7 0];
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.35 0.8])
id = find(strcmp(Dir.group,'WT'));
fac1=1; fac2=1; if strcmp(struct1,'Respi'),fac1=1/3E3;elseif strcmp(struct2,'Respi'),fac2=1/3E3;end
for nn=1:length(NameEpochs)
    tempC=squeeze(MatC(id,nn,:));
    tempPh=squeeze(MatPh(id,nn,:));
    tempG1=squeeze(G1to2(id,nn,:));
    tempG2=squeeze(G2to1(id,nn,:));
    tempS1=squeeze(MatS1(id,nn,:));
    tempS2=squeeze(MatS2(id,nn,:));
    % spectrum
    subplot(3,length(NameEpochs),nn), hold on,
    plot(freq,fac1*10*log10(nanmean(tempS1,1)),'Color',colori(nn,:),'Linewidth',2); 
    plot(freq,fac2*10*log10(nanmean(tempS2,1)),'k','Linewidth',2); 
    title([NameEpochs{nn},' Spectrum'])
    plot(freq,fac1*10*log10(nanmean(tempS1,1)+stdError(tempS1)),'Color',colori(nn,:)); 
    plot(freq,fac1*10*log10(nanmean(tempS1,1)-stdError(tempS1)),'Color',colori(nn,:)); 
    plot(freq,fac2*10*log10(nanmean(tempS2,1)+stdError(tempS2)),'k'); 
    plot(freq,fac2*10*log10(nanmean(tempS2,1)-stdError(tempS2)),'k'); 
    legend({struct1,struct2}); xlim([0 15])
    % coherence
    subplot(3,length(NameEpochs),length(NameEpochs)+nn), hold on,
    plot(freq,nanmean(tempC,1),'Color',colori(nn,:),'Linewidth',2); 
    line(xlim,[0 0]+nanmean(MatconfC),'Color','r','linewidth',2)
    %plot(freq,nanmean(tempPh,1),'k','Linewidth',2); 
    legend({'Coherence','confidence'})%,'phase'
    plot(freq,nanmean(tempC,1)+stdError(tempC),'Color',colori(nn,:)); 
    plot(freq,nanmean(tempC,1)-stdError(tempC),'Color',colori(nn,:));
    line(xlim,[0 0]+(nanmean(MatconfC)+stdError(MatconfC)),'Color','r');
    line(xlim,[0 0]+(nanmean(MatconfC)-stdError(MatconfC)),'Color','r')
    title([NameEpochs{nn},'  Coherence ',struct1,'-',struct2]); xlim([0 15])
    % granger 1->2 & 2->1
    subplot(3,length(NameEpochs),2*length(NameEpochs)+nn), hold on,
    plot(freqBin,nanmean(tempG1,1),'Color',colori(nn,:),'Linewidth',2); 
    plot(freqBin,nanmean(tempG2,1),'k','Linewidth',2); 
    title([NameEpochs{nn},' Granger '])
    plot(freqBin,nanmean(tempG1,1)+stdError(tempG1),'Color',colori(nn,:)); 
    plot(freqBin,nanmean(tempG1,1)-stdError(tempG1),'Color',colori(nn,:)); 
    plot(freqBin,nanmean(tempG2,1)+stdError(tempG2),'k'); 
    plot(freqBin,nanmean(tempG2,1)-stdError(tempG2),'k'); 
    legend({[struct1,'->',struct2],[struct2,'->',struct1]});xlim([0 15])
end
if savFig
   saveFigure(gcf,sprintf(['AnalyseOB-CohGranger',struct1,'-',struct2]),FolderToSave)
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%% check respi for very low OBslow %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages';
Dir=PathForExperimentsML('PLETHYSMO');% 'BASAL'
Dir=RestrictPathForExperiment(Dir,'Group','WT');
freq=[2 4];savFig=1;
Analyname='AnalyseOBsubstages-RespiHIGHvsLOWspOB.mat';

try
    load([res,'/',Analyname]);Mat1;
    disp([Analyname,' already exists. Loaded.'])
catch
    Mat1=nan(length(Dir.path),3,2);% frequency
    Mat2=nan(length(Dir.path),3,2);% volume
    for man=1:length(Dir.path)
        disp(Dir.path{man})
        cd(Dir.path{man})
        %cd /media/DataMOBsRAID/ProjetAstro-DataPlethysmo/Mouse060/20130503
        clear REMEpoch SWSEpoch MovEpoch GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch noise
        % sleep stages
        load StateEpoch REMEpoch SWSEpoch MovEpoch GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch
        stR=[Start(REMEpoch,'s'),Stop(REMEpoch,'s')];
        stN=[Start(SWSEpoch,'s'),Stop(SWSEpoch,'s')];
        noise=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
        noise=mergeCloseIntervals(noise,1E3);
        
        % load spectrum
        clear Sp t f SpOB SpOBz channel
        load ChannelsToAnalyse/Bulb_deep
        if ~isempty(channel) && sum(Stop(REMEpoch,'s')-Start(REMEpoch,'s'))>0
            eval(['load SpectrumDataL/Spectrum',num2str(channel)])
            SpOB=tsd(t*1E4,mean(Sp(:,f>=freq(1) & f<freq(2)),2));
            SpOB=Restrict(SpOB,intervalSet(t(1)*1E4,t(end)*1E4)-noise);
            SpOBz=tsd(Range(SpOB),zscore(Data(SpOB)));
            % Load Respi
            clear RespiTSD Frequency TidalVolume
            load LFPData RespiTSD Frequency TidalVolume
            RespiTSD=Restrict(RespiTSD,intervalSet(t(1)*1E4,t(end)*1E4)-noise);
            Frequency=Restrict(Frequency,intervalSet(t(1)*1E4,t(end)*1E4)-noise);
            TidalVolume=Restrict(TidalVolume,intervalSet(t(1)*1E4,t(end)*1E4)-noise);
            
            % display
            figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.4])
            subplot(2,4,1:4), imagesc(t,f,10*log10(Sp)'); axis xy
            for i=1:size(stN,1)
                hold on, line([stN(i,1),stN(i,2)],[9.5 9.5],'Color','b','Linewidth',3)
                hold on, line(stN(i,1)+[0 0],[0 9.5],'Color','b')
                hold on, line(stN(i,2)+[0 0],[0 9.5],'Color','b')
            end
            for i=1:size(stR,1)
                hold on, line([stR(i,1),stR(i,2)],[9 9],'Color','k','Linewidth',3)
                hold on, line(stR(i,1)+[0 0],[0 9],'Color','k')
                hold on, line(stR(i,2)+[0 0],[0 9],'Color','k')
            end
            title(pwd); ylim([0 10])
            
            if 0
                load ChannelsToAnalyse/dHPC_deep
                eval(['temp=load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'');'])
                subplot(2,4,5:8), imagesc(temp.t,temp.f,10*log10(temp.Sp)'); axis xy
                for i=1:size(stN,1)
                    hold on, line([stN(i,1),stN(i,2)],[9.5 9.5],'Color','b','Linewidth',3)
                    hold on, line(stN(i,1)+[0 0],[0 9.5],'Color','b')
                    hold on, line(stN(i,2)+[0 0],[0 9.5],'Color','b')
                end
                for i=1:size(stR,1)
                    hold on, line([stR(i,1),stR(i,2)],[9 9],'Color','k','Linewidth',3)
                    hold on, line(stR(i,1)+[0 0],[0 9],'Color','k')
                    hold on, line(stR(i,2)+[0 0],[0 9],'Color','k')
                end
                title('dHPC'); ylim([0 10])
            end
            
            
            
            
            % raw spectrum
            subplot(2,4,5), hold on,
            xbin=0:5/1E8/50:5/1E8;
            y=hist(Data(Restrict(SpOB,REMEpoch)),xbin);
            plot(xbin,SmoothDec(y/sum(y),1),'Color','k','Linewidth',2)
            Y=SmoothDec(y/sum(y),1);
            y=hist(Data(Restrict(SpOB,SWSEpoch)),xbin);
            plot(xbin,SmoothDec(y/sum(y),1),'Color','b','Linewidth',2)
            y=hist(Data(Restrict(SpOB,MovEpoch)),xbin);
            plot(xbin,SmoothDec(y/sum(y),1),'Color',[0.5 0.5 0.5],'Linewidth',2)
            legend({'REM','SWS','WAKE'}); title('Distribution BO 2-4Hz')
            xlabel('SpOB 2-4Hz');ylabel('# spectrum time point')
            
            % find fit
            disp('find the threshold between the two REM modes')
            a= ginput(1);a=a(1);
            line(a+[0 0],ylim,'Color','g')
            
            % zscore spectrum
            subplot(2,4,6), hold on,
            xbin=-2:4/50:2;
            [y,x]=hist(Data(Restrict(SpOBz,REMEpoch)),xbin);
            plot(xbin,SmoothDec(y/sum(y),1),'Color','k','Linewidth',2)
            [y,x]=hist(Data(Restrict(SpOBz,SWSEpoch)),xbin);
            plot(xbin,SmoothDec(y/sum(y),1),'Color','b','Linewidth',2)
            [y,x]=hist(Data(Restrict(SpOBz,MovEpoch)),xbin);
            plot(xbin,SmoothDec(y/sum(y),1),'Color',[0.5 0.5 0.5],'Linewidth',2)
            title('Distribution zscore BO 2-4Hz'); xlabel('zscore SpOB 2-4Hz');
            
            namesEpoch={'REMEpoch','SWSEpoch','MovEpoch'};
            for i=1:2
                clear matbar matbarp matbars
                if i==1, temp=Frequency; else, temp=TidalVolume;end
                leg={};
                for n=1:length(namesEpoch)
                    eval(['epoch=',namesEpoch{n},';'])
                    % Respi params rem
                    LowOB=thresholdIntervals(Restrict(SpOB,epoch),a,'Direction','Below');
                    HiOB=thresholdIntervals(Restrict(SpOB,epoch),a,'Direction','Above');
                    %
                    matbar(n,1)=mean(Data(Restrict(temp,LowOB)));
                    matbars(n,1)=stdError(Data(Restrict(temp,LowOB)));
                    matbar(n,2)=mean(Data(Restrict(temp,HiOB)));
                    matbars(n,2)=stdError(Data(Restrict(temp,HiOB)));
                    % stats
                    x1{n}=Data(Restrict(temp,LowOB));
                    x2{n}=Data(Restrict(temp,HiOB));
                    [H,p]=ttest2(x1{n},x2{n});
                    leg=[leg,sprintf([namesEpoch{n},': p=%1.4f'],p)];
                end
                % plot
                subplot(2,4,6+i), hold on,
                bar(matbar); errorbar([0.85,1.15;1.85,2.15;2.85,3.15],matbar,matbars,'+k')
                set(gca,'Xtick',1:3); set(gca,'XtickLabel',{'REM','SWS','WAKE'}); if i==2, legend({'low','high'}); end
                if i==1, ylabel('Breathing Frequency (Hz)'); else, ylabel('Tidal Volume (mL)'); end
                title(leg)
                
                % sav all
                eval(['Mat',num2str(i),'(man,:,:)=matbar;'])%
            end
            % save figure
            if savFig, saveFigure(gcf,['AnalyseOB-RespiOBgating-',Dir.name{man}([1,6:end])],FolderToSave); end
            disp('Done.')
        else
            disp('No Bulb')
        end
    end
    save([res,'/',Analyname],'Dir','freq','Mat1','Mat2');
end
% plot all mice
figure('Color',[1 1 1])
nameEp={'REM','SWS','WAKE'};typ={'low','high'};
for i=1:2
    eval(['AA=[squeeze(Mat',num2str(i),'(:,:,1)),squeeze(Mat',num2str(i),'(:,:,2))];'])
    leg={'ranksum: '};
    for j=1:6
        for k=j+1:6
            [p,H]=ranksum(AA(:,j),AA(:,k));
            n=sum(~isnan(mean([AA(:,j),AA(:,k)],2)));
            leg=[leg,sprintf([nameEp{mod(j-1,3)+1},typ{ceil(j/3)},' vs ',...
                nameEp{mod(k-1,3)+1},typ{ceil(k/3)},': p=%1.3f, n=%d'],p,n)];
        end
    end
    temp=nanmean(AA);temp=[temp(1:3)',temp(4:6)'];
    temps=stdError(AA);temps=[temps(1:3)',temps(4:6)'];
    subplot(1,2,i), hold on, bar(temp); errorbar([0.85,1.15;1.85,2.15;2.85,3.15],temp,temps,'+k')
    set(gca,'Xtick',1:3); set(gca,'XtickLabel',nameEp);
    title(leg)
end
ylabel('Tidal Volume (mL)');legend(typ);
subplot(1,2,1),ylabel('Breathing Frequency (Hz)');

if savFig, saveFigure(gcf,'AnalyseOB-RespiOBgating-Pool',FolderToSave); end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%% RespiModulatesGamma_ML.m %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%see RespiGammaMarie.m
Dir=PathForExperimentsML('PLETHYSMO');% 'BASAL'
Dir=RestrictPathForExperiment(Dir,'Group','WT');
nameEp={'REM','NREM','Sniff','bWAKE'};

for man=1:length(Dir.path)
    disp(Dir.path{man})
    cd(Dir.path{man})

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
    Sniff=SniffEpoch-noise; Sniff=mergeCloseIntervals(Sniff,10);
    bWAKE=and(MovEpoch,BasalBreathEpoch)-noise; bWAKE=mergeCloseIntervals(bWAKE,10);
    
    
    % load LFP PFCx
    clear LFP channel Fil1 Fil2 Pow1 Pow2
    disp('Loading and filtering LFP PFCx...')
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    GoodEpoch=intervalSet(min(Range(LFP)),max(Range(LFP)))-noise;
    Fil1= FilterLFP(LFP,[30 60],256);
    Pow1=tsd(Range(Fil1),abs(hilbert(Data(Fil1))));
    Pow1=Restrict(Pow1,GoodEpoch);
    Fil2= FilterLFP(LFP,[60 90],256);
    Pow2=tsd(Range(Fil2),abs(hilbert(Data(Fil2))));
    Pow2=Restrict(Pow2,GoodEpoch);
    
    % load LFP OB to commpare
    clear LFP channel FilOB1 FilOB2 PowOB1 PowOB2
    disp('Loading and filtering LFP Bulb...')
    load ChannelsToAnalyse/Bulb_deep
    eval(['load LFPData/LFP',num2str(channel)])
    GoodEpoch=intervalSet(min(Range(LFP)),max(Range(LFP)))-noise;
    FilOB1= FilterLFP(LFP,[30 60],256);
    PowOB1=tsd(Range(FilOB1),abs(hilbert(Data(FilOB1))));
    PowOB1=Restrict(PowOB1,GoodEpoch);
    FilOB2= FilterLFP(LFP,[60 90],256);
    PowOB2=tsd(Range(FilOB2),abs(hilbert(Data(FilOB2))));
    PowOB2=Restrict(PowOB2,GoodEpoch);
    
    % Load Respi
    clear RespiTSD Frequency TidalVolume
    load LFPData RespiTSD Frequency TidalVolume
    RespiTSD=Restrict(RespiTSD,GoodEpoch);
    Frequency=Restrict(Frequency,GoodEpoch);
    TidalVolume=Restrict(TidalVolume,GoodEpoch);
    
    
    for n=1:length(nameEp)
        eval(['epoch=',nameEp{ep},';'])
        % low gamma PFCx
        M1=PlotRipRaw(Pow1,Range(Restrict(Frequency,epoch),'s'),1000);%close
        M2=PlotRipRaw(Pow2,Range(Restrict(Frequency,epoch),'s'),1000);%close
        MOB1=PlotRipRaw(PowOB1,Range(Restrict(Frequency,epoch),'s'),1000);%close
        MOB2=PlotRipRaw(PowOB2,Range(Restrict(Frequency,epoch),'s'),1000);%close
        
    end
end



