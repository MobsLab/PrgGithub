function [FSp_pooled,MatrixSpStrain,MatrixSpMice]=LFPspectrum_StrainsML_new(Dir,StructureName,NameEpoch,cleanspec,optionComputeChannel,freqRestrict,NameInjectionEpoch,HighOrLowSpec)

% function LFPspectrum_StrainsML_new(Dir,cleanspec,StructureName,NameEpoch,optionComputeChannel,freqRestrict,NameInjectionEpoch)
%
% inputs:
% - Dir = path with data (see PathForExperimentsML.m or PathForExperimentsBULB.m)
% - StructureName = name of the structure to analyse e.g. {'Bulb','BO'}
% - NameEpoch = name of intervalSet in StateEpoch.mat (see sleepscoringML.m)
% - cleanspec (optional)= 1 to use CleanSpectro.m (default 0)
% - optionComputeChannel (optional) = 'Unique' 'deep' 'sup' (default 'Unique')
% - freqRestrict (optional) = only for 'PLETHYSMO', restrict on freq respi
% - NameInjectionEpoch (optional) = name of intervalSet in behavResources (default 'PreEpoch')

% outputs:
% - FSp_pooled = number of the figure showing strain effect
% - MatrixSpMice = for all mice, nanmean spectro (see MatrixDataNames var)
% - MatrixSpStrain = for all mice, strain.
%
% LFPspectrum_StrainsML_new('PLETHYSMO','Bulb','MovEpoch');

res=pwd;

%% Verifications of inputs

if ~exist('Dir','var') || ~exist('StructureName','var') || ~exist('NameEpoch','var')
    error('Not enough input arguments')
end
if ~exist('cleanspec','var')
    cleanspec=0;
end
if ~exist('NameInjectionEpoch','var')
    NameInjectionEpoch='PreEpoch';
end
if ~exist('optionComputeChannel','var')
    optionComputeChannel='deep';
end

if ~exist('HighOrLowSpec','var')
    HighOrLowSpec='L';%'L' for low, 'H' for high;
end
if strcmp(HighOrLowSpec,'H'),disp('Analysing High spectrum [20-150Hz]');else, disp('Analysing low spectrum [0-20Hz]');end

% ------------------------------
% --- manual inputs ------
Domtspectrumc=0; % ne pas utiliser sur subEpochs
CorrectionAmplifier=1;
pval=0.05;
smoFact=2; %default 10
% ------------------------------

%% initialisation variables
NameDir=Dir.manipe{1};
if strcmp(NameDir,'PLETHYSMO')
    res='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo';
else
    res='/media/DataMOBsRAID/ProjetAstro';
end
FolderTosave=[res,'/AnalyseLFPspectrum',HighOrLowSpec,'/',StructureName,optionComputeChannel];
%FolderTosave='/home/vador/Dropbox/Kteam/dKO-Spectre-OdorDetection/Spectrum';
if ~exist(FolderTosave,'dir'), mkdir(FolderTosave);end


ANALYNAME=[FolderTosave,'/StrainsLFPspectr',NameDir,NameEpoch,NameInjectionEpoch];
if Domtspectrumc, ANALYNAME=[ANALYNAME,'-mt'];end
if cleanspec, ANALYNAME=[ANALYNAME,'-clean'];end
if exist('freqRestrict','var') && strcmp(NameDir,'PLETHYSMO'), ANALYNAME=[ANALYNAME,'-RestrictRespi',num2str(freqRestrict(1)),'-',num2str(freqRestrict(2)),'Hz'];end
strains=unique(Dir.group);
MiceNames=unique(Dir.name);

% initiate display
colori={'b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};
typo={ '-','-','-','-','-','-','--','--','--','--','--','--','-.','-.','-.','-.','-.','-.'};
scrsz = get(0,'ScreenSize');


%% does this analazis exist already? 
disp(' ')
try
    load([ANALYNAME,'.mat']);  
    eval(['MatrixSp=MatrixSp',StructureName,';'])
    eval(['MatrixSpGroup=MatrixSpGroup',StructureName,';']);
    %eval(['MatrixSpInf',StructureName,'; MatrixSpSup',StructureName,';']);
    
    disp([ANALYNAME,'.mat already exists...'])
%     ErasePreviousAnalysis=input('Do you want to erase previous analysis (y/n)? ','s');
%     if ErasePreviousAnalysis=='y'
%         ErasePreviousAnalysis=1; 
%     else
%         ErasePreviousAnalysis=0;
%     end
    ErasePreviousAnalysis=0;
    
catch
    ErasePreviousAnalysis=1; 
    disp(['Saving analysis in ',ANALYNAME,'.mat'])
end


%% Calculating spectrogram

% ------ parameters spectro ------
if isempty(strfind(NameDir,'PLETHYSMO'))
    params.Fs=1250;
else
    params.Fs=1000;
end
params.trialave=0;
params.err=[1 0.0500]; params.pad=2;

if HighOrLowSpec=='H'
    movingwin=[0.1 0.005];
    params.fpass=[20 200];
    params.tapers=[1,2];
else
    params.fpass=[0.01 20];
    movingwin=[3 0.2];
    params.tapers=[3 5];
    %params.tapers=[1 2];
end

if ErasePreviousAnalysis
    save([ANALYNAME,'.mat'],'NameDir','StructureName','NameEpoch','Dir')
    
    disp('... Loading or calculating Spectrum for all experiments in Dir')
    MatrixSp=nan(length(Dir.path),200);
    MatrixSpGroup=nan(length(Dir.path),2);
    Matrixepoch=nan(length(Dir.path),1);

    for man=1:length(Dir.path)
        nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21);
        if isempty(nameMan), nameMan=Dir.path{man}(strfind(Dir.path{man},'Mouse'):end);end
        disp(' ')
        %disp(['           * * * ',nameMan,' * * *'])
        disp(Dir.path{man})
        % --------------------
        % ------ EPOCHS ------
        clear REMEpoch SWSEpoch MovEpoch ImmobEpoch SniffEpoch BasalBreathEpoch SWS1hEpoch
        clear epoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
        load([Dir.path{man},'/StateEpoch.mat'],'REMEpoch','ThetaEpoch','SWSEpoch','MovEpoch','ImmobEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        try load([Dir.path{man},'/SWS1hEpoch.mat'],'SWS1hEpoch');end
        
        clear PreEpoch VEHEpoch DPCPXEpoch LPSEpoch CPEpoch
        try
            load([Dir.path{man},'/behavResources.mat'],NameInjectionEpoch)
        catch
            disp(['Warning: No ',NameInjectionEpoch,' defined in behavResources.mat'])
            eval([NameInjectionEpoch,'=',NameEpoch,';'])
        end
        
        try WeirdNoiseEpoch; catch, WeirdNoiseEpoch=intervalSet([],[]);disp('No WeirdNoiseEpoch');end
        try NoiseEpoch; catch, NoiseEpoch=intervalSet([],[]); disp('No NoiseEpoch');end
        try GndNoiseEpoch; catch, GndNoiseEpoch=intervalSet([],[]);disp('No GndNoiseEpoch');end
        
        if ~isempty(strfind(NameEpoch,'Sniff')) || ~isempty(strfind(NameEpoch,'BasalBreath'))
            load([Dir.path{man},'/StateEpoch.mat'],'SniffEpoch','BasalBreathEpoch')
        end
        
        eval(['epoch=and(',NameEpoch,'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch,',NameInjectionEpoch,');'])
        disp(['Time in and(',NameEpoch,',',NameInjectionEpoch,') = ',num2str(sum(Stop(epoch,'s')-Start(epoch,'s'))),'s'])
        
        % ---------------------------------------------------------------------
        % ---------------------------------------------------------------------
        % load respi info and restrict on respi freq
        if exist('freqRestrict','var') && strcmp(NameDir,'PLETHYSMO')
            clear Frequency DataFrequency RangeFrequency indexRestrict RespiTSD
            load([Dir.path{man},'/LFPData.mat'],'Frequency')
            
            DataFrequency=Data(Frequency);
            RangeFrequency=Range(Frequency);
            
            indexRestrict=find(DataFrequency>freqRestrict(1) & DataFrequency<freqRestrict(2));
            if RangeFrequency(indexRestrict(end))==RangeFrequency(end), indexRestrict=indexRestrict(1:end-1);end
            RestrictEpoch=intervalSet(RangeFrequency(indexRestrict),RangeFrequency(indexRestrict+1));
             epoch=and(epoch,RestrictEpoch);
        end
        
        % --------------------
        % ----- spectrum -----
        clear InfoLFP
        InfoLFP=listLFP_to_InfoLFP_ML(Dir.path{man});
        
        
        if ~isempty(strfind(StructureName,'RespiTSD')) && ~isempty(Start(epoch))
            clear RespiTSD newRespiTSD NormRespiTSD
            load([Dir.path{man},'/LFPData.mat'],'RespiTSD','newRespiTSD','NormRespiTSD')
            try
                eval(['DataRespi=Data(',StructureName,');']);
            catch
                clear TidalVolume Frequency multCalib RespiTSD Calibration
                load([Dir.path{man},'/LFPData.mat'],'RespiTSD','Calibration')
                [TidalVolume,Frequency,Param,multCalib,NormRespiTSD,newRespiTSD]=PlethysmoSignalML(RespiTSD,Calibration,0,1);
                eval(['save(''',Dir.path{man},'/LFPData.mat'',''-append'',''TidalVolume'',''Frequency'',''multCalib'',''NormRespiTSD'',''newRespiTSD'');'])
                eval(['DataRespi=Data(',StructureName,');']);
            end
            
            if Domtspectrumc
                disp('not yet implemented')
            else
                [Spi,ti,fi]=mtspecgramc(DataRespi,movingwin,params);
                if sum(sum(isnan(Spi)))==0
                clear tEpoch SpEpoch
                [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,fi,epoch);
                MatrixSp(man,:)=resample(nanmean(SpEpoch,1),200,length(nanmean(SpEpoch,1)));
                fi=resample(fi,200,length(fi));
                end
            end
            MatrixSpGroup(man,:)=[find(strcmp(Dir.group{man},strains)),find(strcmp(Dir.name{man},MiceNames))];
            Matrixepoch(man,:)=sum(Stop(epoch,'s')-Start(epoch,'s'));
            
        elseif sum(strcmp(InfoLFP.structure,StructureName))~=0 && ~isempty(Start(epoch))
            
            % ------------------------------------------------------
            % -------------- ComputeSpectrogramML ------------------
            % calculate Sp for all LFP
            clear Spi ti fi channelToAnalyse SpecTSD tEpoch SpEpoch
            
            cd(Dir.path{man});
            disp([Dir.group{man},'-',Dir.name{man}(strfind(Dir.name{man},'Mouse')+6:end)])
            
            if Domtspectrumc==0
                
                [Spi,ti,fi,channelToAnalyse]=ComputeSpectrogram_newML(movingwin,params,InfoLFP,StructureName,optionComputeChannel,HighOrLowSpec);
                
                if cleanspec && sum(sum(isnan(Spi)))==0
                    
                    try
                        SpecTSD=tsd(ti*1E4,Spi);
                        temp=CleanSpectro(SpecTSD,fi,3);
                        Spi=Data(temp);
                        ti=Range(temp,'s');
                        disp('Spectro has been cleaned by CleanSpectro.m');
                    catch
                        keyboard
                    end
                end
                
                % ------------------------------------------------------
                
                if sum(sum(isnan(Spi)))==0
                    if CorrectionAmplifier
                        Spi=Dir.CorrecAmpli(man)*Spi;
                    end
                    
                    % ------------------------------------------------------
                    % ------------------ SpectroEpochML --------------------
                    % calculate Spectro restricted to epoch
                    clear tEpoch SpEpoch
                    [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,fi,epoch);
                    % ------------------------------------------------------
                    
                    MatrixSp(man,:)=resample(nanmean(SpEpoch,1),200,length(nanmean(SpEpoch,1)));
                    fi=resample(fi,200,length(fi));

                end
            else
                disp('mtspectrumc')
                try
                    [SpEpoch,fi]=Compute_mtSpectrumc_newML(params,InfoLFP,StructureName,epoch,optionComputeChannel,HighOrLowSpec);
                    if CorrectionAmplifier
                        SpEpoch=Dir.CorrecAmpli(man)*SpEpoch;
                    end
                    MatrixSp(man,:)=SmoothDec(SpEpoch,smoFact);
                catch
                    keyboard
                end
            end
            disp(['fi: [',num2str(min(fi)),'-',num2str(max(fi)),']'])
            cd(res)
            MatrixSpGroup(man,:)=[find(strcmp(Dir.group{man},strains)),find(strcmp(Dir.name{man},MiceNames))];
            Matrixepoch(man,:)=sum(Stop(epoch,'s')-Start(epoch,'s'));

        else
            disp(['no LFP ',StructureName,', skipping this step'])
        end
        %if strcmp(nameMan,'BULB-Mouse-160-1912201'); keyboard;end
    end
    if size(MatrixSp,1)< length(Dir.path), MatrixSp(size(MatrixSp,1)+1:length(Dir.path),:)=zeros(length(Dir.path)-size(MatrixSp,1),size(MatrixSp,2));end
    % saving in analyname
    eval(['MatrixSp',StructureName,'=MatrixSp;'])
    eval(['MatrixSpGroup',StructureName,'=MatrixSpGroup;']);
    save([ANALYNAME,'.mat'],'fi',['MatrixSp',StructureName],['MatrixSpGroup',StructureName],'Matrixepoch','-append');

end

%% display individual mean spectro

if strcmp(HighOrLowSpec,'L')
    xlim_val=[0 15];
else
    xlim_val=[20 150];
end

figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), 
FSp_Individual=gcf;

Y=[];
for man=1:size(MatrixSp,1)
    try nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21); catch, keyboard;end
    if isempty(nameMan), nameMan=Dir.path{man}(strfind(Dir.path{man},'Mouse'):end);end
    
    subplot(3,ceil(length(Dir.path)/3),man)
    try
    if sum(MatrixSp(man,:))>0
        hold on, plot(fi,MatrixSp(man,:),'k','linewidth',2);
         Y=[Y,ylim];
    end
    catch
        keyboard
    end
    ylabel([NameEpoch,' ',num2str(floor(Matrixepoch(man))),'s']), title(StructureName);
    xlabel([Dir.group{man},'-',nameMan(strfind(nameMan,'Mouse')+6:end)])

end

for man=1:length(Dir.path)
     subplot(3,ceil(length(Dir.path)/3),man)
     try ylim([0 max(Y)]);end
     try xlim(xlim_val);end
end


%% pool data from same mice

MatrixSpMice=nan(length(MiceNames),size(MatrixSp,2));
MatrixSpStrain=nan(length(MiceNames),1);
%addweird=ones(size(MatrixSpGroup,1),1); 
%if strcmp(NameEpoch,'MovEpoch'), addweird(7)=0;end
for uu=1:length(MiceNames)
    %index=find(MatrixSpGroup(:,2)==uu & addweird);
    index=find(MatrixSpGroup(:,2)==uu);
    if isempty(index)==0
    
        MatrixSpMice(uu,:)=nanmean(MatrixSp(index,:),1);
        MatrixSpStrain(uu)=unique(MatrixSpGroup(index,1));
    end
    clear index
    xlim(xlim_val);
end




%% display mean Spectro pooled for dKO vs WT
figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/7 scrsz(4)/3]),
%figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/3]), 
FSp_pooled=gcf;
if exist('Y','var')
    ylim_val=[0 max(Y)];
else
    if strcmp(StructureName,'Bulb'), ylim_val=[0 3.5/1E8];
    elseif strcmp(StructureName,'RespiTSD'), ylim_val=[0 3.5/1E8];
    else, ylim_val=[0 2.4/1E9];
    end
end
legendSt=[];
for ss=1:length(strains),
    
    clear Manss Spfstd Spf
    Manss=find(MatrixSpStrain==ss);
    Sp_temp{ss}=MatrixSpMice(Manss,:);
    
    subplot(2,3,1)
    hold on, plot(fi,10*log10(mean(MatrixSpMice(Manss,:),1)),'linewidth',2,'color',colori{ss});
    if length(Manss)>1,
        hold on, plot(fi,10*log10(mean(MatrixSpMice(Manss,:),1)+stdError(MatrixSpMice(Manss,:))),'color',colori{ss});
        hold on, plot(fi,10*log10(mean(MatrixSpMice(Manss,:),1)-stdError(MatrixSpMice(Manss,:))),'color',colori{ss});
    end
    title('10*log10(mean(raw))'); xlim(xlim_val);
    
    subplot(2,3,2)
    hold on, plot(fi,10*log10(fi.*mean(MatrixSpMice(Manss,:),1)),'linewidth',2,'color',colori{ss});
    if length(Manss)>1,
        hold on, plot(fi,10*log10(fi.*mean(MatrixSpMice(Manss,:),1)+stdError(MatrixSpMice(Manss,:))),'color',colori{ss});
        hold on, plot(fi,10*log10(fi.*mean(MatrixSpMice(Manss,:),1)-stdError(MatrixSpMice(Manss,:))),'color',colori{ss});
    end
    title('10*log10(fi*mean(raw))'); xlim(xlim_val);
    
    subplot(2,3,3)
    hold on, plot(fi,nanmean((ones(length(Manss),1)*fi).*MatrixSpMice(Manss,:),1),'linewidth',2,'color',colori{ss});
    if length(Manss)>1,
        hold on, plot(fi,nanmean((ones(length(Manss),1)*fi).*MatrixSpMice(Manss,:),1)+stdError((ones(length(Manss),1)*fi).*MatrixSpMice(Manss,:)),'color',colori{ss});
        hold on, plot(fi,nanmean((ones(length(Manss),1)*fi).*MatrixSpMice(Manss,:),1)-stdError((ones(length(Manss),1)*fi).*MatrixSpMice(Manss,:)),'color',colori{ss});
    end
    title('mean(fi*raw)'); xlim(xlim_val);
     
     % ajout le 13/11/2014
%      subplot(2,3,4)
%     hold on, plot(fi,10*log10(mean(MatrixSpMice(Manss,:),1)),'linewidth',2,'color',colori{ss});
%     if length(Manss)>1,
%         hold on, plot(fi,mean(10*log10*MatrixSpMice(Manss,:),1)+stdError(10*log10*MatrixSpMice(Manss,:)),'color',colori{ss});
%         hold on, plot(fi,mean(10*log10*MatrixSpMice(Manss,:),1)-stdError(10*log10*MatrixSpMice(Manss,:)),'color',colori{ss});
%     end
%     title('mean(10*log10(raw))'); xlim(xlim_val);
%     
    subplot(2,3,5)
    hold on, plot(fi,10*log10(fi.*mean(MatrixSpMice(Manss,:),1)),'linewidth',2,'color',colori{ss});
    if length(Manss)>1,
        hold on, plot(fi,10*log10(fi.*mean(MatrixSpMice(Manss,:),1)+stdError(MatrixSpMice(Manss,:))),'color',colori{ss});
        hold on, plot(fi,10*log10(fi.*mean(MatrixSpMice(Manss,:),1)-stdError(MatrixSpMice(Manss,:))),'color',colori{ss});
    end
    title('10*log10(mean(fi*raw))'); xlim(xlim_val);
    
    subplot(2,3,6)
    hold on, plot(fi,nanmean(MatrixSpMice(Manss,:),1),'linewidth',2,'color',colori{ss});
    legendSt=[legendSt,{[strains{ss},' (n=',num2str(length(Manss)),')']}];
    if length(Manss)>1,
        hold on, plot(fi,nanmean(MatrixSpMice(Manss,:),1)+stdError(MatrixSpMice(Manss,:)),'color',colori{ss});
        hold on, plot(fi,nanmean(MatrixSpMice(Manss,:),1)-stdError(MatrixSpMice(Manss,:)),'color',colori{ss});
        legendSt=[legendSt,'+std','-std'];
    end
     ylim(ylim_val);
     xlim(xlim_val);
end

% statistics
if 1
if size(Sp_temp{1},1)>1 && size(Sp_temp{2},1)>1
    %[H,p]=ttest2(Sp_temp{1},Sp_temp{2});
    for i=1:size(Sp_temp{1},2)
        [p_temp,H]=ranksum(Sp_temp{1}(:,i),Sp_temp{2}(:,i));
        %[H,p_temp] = ttest2(Sp_temp{1}(:,i),Sp_temp{2}(:,i));
        p(i)=p_temp;
    end
    try  hold on, plot(fi(p<pval),zeros(length(p(p<pval))),'g.');end
    
    legendSt=[legendSt,{['pvalue (ranksum) < ',num2str(pval)]}];
    %legendSt=[legendSt,{['pvalue (ttest2) < ',num2str(pval)]}];
end
end
legend(legendSt); xlim(xlim_val);
ylabel('Frequency Power'); xlabel('Frequency (Hz)')
if exist('freqRestrict','var') && strcmp(NameDir,'PLETHYSMO')
    title([' LFP ',StructureName,' ',optionComputeChannel,' - and(',NameEpoch,',',NameInjectionEpoch,') - Respi [',num2str(freqRestrict(1)),'-',num2str(freqRestrict(2)),']Hz'])
else
    title([' LFP ',StructureName,' ',optionComputeChannel,' - and(',NameEpoch,',',NameInjectionEpoch,')'])
end

%% save figures
cd(res)
if exist([FolderTosave,'/LFPspectrumStrainEffect',NameEpoch,NameInjectionEpoch],'file')
    disp('Warning!!! figures already exist ans will be overwritten')
end
disp('Keyboard; Enter return for automatic figure save, dbquit otherwise')
%keyboard

disp(['Saving figures in ',FolderTosave,'...'])
FigureName=[NameEpoch,NameInjectionEpoch];
if Domtspectrumc, FigureName=[FigureName,'mt'];end
if cleanspec, FigureName=[FigureName,'clean'];end
if exist('freqRestrict','var') && strcmp(NameDir,'PLETHYSMO'), FigureName=[FigureName,'RestrictRespi',num2str(freqRestrict(1)),'-',num2str(freqRestrict(2)),'Hz'];end
saveFigure(FSp_pooled,['LFPspectrumStrainEffect',FigureName],FolderTosave);
saveFigure(FSp_Individual,['LFPspectrumIndividual',FigureName],FolderTosave);


