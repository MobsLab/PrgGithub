function [FSp_pooled,MatrixSpStrain,MatrixSpMice]=LFPspectrum_StrainsML(NameDir,StructureName,NameEpoch,NameInjectionEpoch)

% function LFPspectrum_StrainsML
%
% inputs:
% - NameDir = path with PLETHYSMOGRAPH data (see PathForExperimentsML.m)
% - StructureName = name of the structure to analyse e.g. {'Bulb','BO'}
% - NameEpoch = name of intervalSet in StateEpoch.mat (see sleepscoringML.m)
% - NameInjectionEpoch = name of intervalSet in behavResources
% 
% outputs:
% - FSp_pooled = number of the figure showing strain effect
% - MatrixSpMice = for all mice, mean spectro (see MatrixDataNames var)
% - MatrixSpStrain = for all mice, strain.
%
% !!! Papier Lisa !!!
% numF=LFPspectrum_StrainsML('BASAL',{'Bulb' 'BO'},'MovEpoch')


%% Verifications of inputs

if exist('NameDir','var')==0 || exist('StructureName','var')==0 || exist('NameEpoch','var')==0
    error('Not enough input arguments')
end

if length(StructureName)>1
    StructName=StructureName{1};
    StructNickName=StructureName{2};
else
    StructName=StructureName;
    StructNickName=StructureName;
end

if exist('NameInjectionEpoch','var')==0
    NameInjectionEpoch='PreEpoch';
end

% ------------------------------
% --- manual inputs ------
CorrectionAmplifier=1;
pval=0.05;
% ------------------------------

%% initialisation variables

res=pwd;

% load paths of experiments
Dir=PathForExperimentsML(NameDir);
ANALYNAME=['Strains_LFPspectr_',NameDir,'_',NameEpoch,NameInjectionEpoch];
strains=unique(Dir.group);
MiceNames=unique(Dir.name);

% where to find spectra
if strcmp(NameDir,'PLETHYSMO')
    SpectrumLocation='[Dir.path{man},''/AnalyseFreq.mat'']';
else
    SpectrumLocation='[res,''/'',nameMan,''.mat'']';
end

% initiate display
colori={'b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};
typo={ '-','-','-','-','-','-','--','--','--','--','--','--','-.','-.','-.','-.','-.','-.'};
scrsz = get(0,'ScreenSize');


%% does this analazis exist already? 
disp(' ')
try
    load([res,'/',ANALYNAME,'.mat']);  
    eval(['MatrixSp=MatrixSp_',StructNickName,';'])
    eval(['MatrixSpGroup=MatrixSpGroup_',StructNickName,';']);
    %eval(['MatrixSpInf_',StructNickName,'; MatrixSpSup_',StructNickName,';']);
    
    disp(['/',ANALYNAME,'.mat already exists...'])
    ErasePreviousAnalysis=input('Do you want to erase previous analysis (y/n)? ','s');
    if ErasePreviousAnalysis=='y'
        ErasePreviousAnalysis=1; 
    else
        ErasePreviousAnalysis=0;
    end
    
catch
    ErasePreviousAnalysis=1; 
    disp(['Saving analysis in /',ANALYNAME,'.mat'])
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
params.fpass=[0.01 20];
movingwin=[3 0.2]; params.tapers=[3 5];


if ErasePreviousAnalysis
    save([res,'/',ANALYNAME,'.mat'],'NameDir','StructureName','NameEpoch')
    
    disp('... Loading or calculating Spectrum for all experiments in Dir')
    MatrixSp=[];
    MatrixSpGroup=nan(length(Dir.path),2);

    for man=1:length(Dir.path)
        nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21);
        if isempty(nameMan), nameMan=Dir.path{man}(strfind(Dir.path{man},'Mouse'):end);end
        disp(' ')
        disp(['           * * * ',nameMan,' * * *'])
        
        % --------------------
        % ------ EPOCHS ------
        clear epoch REMEpoch SWSEpoch MovEpoc NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch 
        load([Dir.path{man},'/StateEpoch.mat'],NameEpoch,'NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        
        clear PreEpoch VEHEpoch DPCPXEpoch LPSEpoch CPEpoch
        try
            load([Dir.path{man},'/behavResources.mat'],NameInjectionEpoch)
        catch
            disp(['Warning: No ',NameInjectionEpoch,' defined in behavResources.mat'])
            eval([NameInjectionEpoch,'=',NameEpoch,';'])
        end
        
        try 
            eval(['epoch=and(',NameEpoch,'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch,',NameInjectionEpoch,');'])
        catch
            eval(['epoch=and(',NameEpoch,',',NameInjectionEpoch,');'])
            disp('Warning: Noisy periods have not been removed!')
        end
        
        % --------------------
        % ----- spectrum -----
        clear listLFP
        load([Dir.path{man},'/listLFP.mat'],'listLFP')
        
        if sum(strcmp(listLFP.name,StructName))~=0 && isempty(Start(epoch))==0
            
            % ------------------------------------------------------
            % -------------- ComputeSpectrogramML ------------------
            % calculate Sp for all LFP
            clear Spi ti fi info LFP
            try
                load([Dir.path{man},'/LFP',StructName,'.mat'],'LFP','info')
                LFP; info;
            catch
                load([Dir.path{man},'/LFPData.mat'],'LFP')
                info.name=StructName;
                info.channels=listLFP.channels{strcmp(listLFP.name,StructName)};
                info.depth=listLFP.depth{strcmp(listLFP.name,StructName)};
                LFP;
            end
            eval(['FileToSave=',SpectrumLocation,';']);
            [Spi,ti,fi]=ComputeSpectrogramML(LFP,movingwin,params,FileToSave,{StructName,StructNickName},info);
            % ------------------------------------------------------
            
            if CorrectionAmplifier
                Spi=Dir.CorrecAmpli(man)*Spi;
            end
            
            
            % ------------------------------------------------------
            % ------------------ SpectroEpochML --------------------
            % calculate Spectro restricted to epoch
            clear tEpoch SpEpoch
            [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,fi,epoch);
            % ------------------------------------------------------

            
            MatrixSp(man,:)=mean(SpEpoch,1);
            MatrixSpGroup(man,:)=[find(strcmp(Dir.group{man},strains)),find(strcmp(Dir.name{man},MiceNames))];

            
        else
            disp(['no LFP ',StructName,', skipping this step'])
        end
    end
    
    % saving in analyname
    eval(['MatrixSp_',StructNickName,'=MatrixSp;'])
    eval(['MatrixSpGroup_',StructNickName,'=MatrixSpGroup;']);
    save([res,'/',ANALYNAME,'.mat'],'fi',['MatrixSp_',StructNickName],['MatrixSpGroup_',StructNickName],'-append');

end

%% display individual mean spectro

figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), 
FSp_Individual=gcf;

Y=[];
for man=1:length(Dir.path)
    nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21);
    if isempty(nameMan), nameMan=Dir.path{man}(strfind(Dir.path{man},'Mouse'):end);end
    
    subplot(3,ceil(length(Dir.path)/3),man)
    if sum(MatrixSp(man,:))>0
        hold on, plot(fi,MatrixSp(man,:),'k','linewidth',2);
         Y=[Y,ylim];
    end
    ylabel(NameEpoch), xlabel(StructName);
    title([Dir.group{man},'-',nameMan(strfind(nameMan,'Mouse')+6:end)])

end

for man=1:length(Dir.path)
     subplot(3,ceil(length(Dir.path)/3),man)
     ylim([0 max(Y)])
end


%% pool data from same mice

MatrixSpMice=nan(length(MiceNames),size(MatrixSp,2));
MatrixSpStrain=nan(length(MiceNames),1);

for uu=1:length(MiceNames)
    index=find(MatrixSpGroup(:,2)==uu);
    if isempty(index)==0
        MatrixSpMice(uu,:)=mean(MatrixSp(index,:),1);
        MatrixSpStrain(uu)=unique(MatrixSpGroup(index,1));
    end
    clear index
end




%% display mean Spectro pooled for dKO vs WT

figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), 
FSp_pooled=gcf;

legendSt=[];
for ss=1:length(strains), 
    
    clear Manss Spfstd Spf
    Manss=find(MatrixSpStrain==ss);
    Sp_temp{ss}=MatrixSpMice(Manss,:);

    hold on, plot(fi,mean(MatrixSpMice(Manss,:),1),'linewidth',2,'color',colori{ss}); 
    legendSt=[legendSt,{[strains{ss},' (n=',num2str(length(Manss)),')']}];   
    if length(Manss)>1,
        hold on, plot(fi,mean(MatrixSpMice(Manss,:),1)+stdError(MatrixSpMice(Manss,:)),'color',colori{ss});
        hold on, plot(fi,mean(MatrixSpMice(Manss,:),1)-stdError(MatrixSpMice(Manss,:)),'color',colori{ss});
        legendSt=[legendSt,'+std','-std'];
    end
end

% statistics
if size(Sp_temp{1},1)>1 && size(Sp_temp{2},1)>1
    %[H,p]=ttest2(Sp_temp{1},Sp_temp{2});
    for i=1:size(Sp_temp{1},2)
        [p_temp,H]=ranksum(Sp_temp{1}(:,i),Sp_temp{2}(:,i));
        p(i)=p_temp;
    end
    hold on, plot(fi(p<pval),ones(length(p(p<pval))),'g.');
    legendSt=[legendSt,{['pvalue (ranksum) < ',num2str(pval)]}]; 
end
legend(legendSt)
ylabel('Frequency Power'); xlabel('Frequency (Hz)')
title([' LFP ',StructName,' - and(',NameEpoch,',',NameInjectionEpoch,')'])
      

%% save figures
disp('Keyboard; Press return for automatic figure save, ctl C otherwise')
keyboard
FigureFolder=['Figures_',date];
if exist([res,'/',FigureFolder],'dir')==0, mkdir(res,FigureFolder);end

disp(['Saving figures in ',FigureFolder,'...'])
saveFigure(FSp_pooled,['LFPspectrum_StrainEffect_',NameEpoch,NameInjectionEpoch],[res,'/',FigureFolder]);
saveFigure(FSp_Individual,['LFPspectrum_Individual_',NameEpoch,NameInjectionEpoch],[res,'/',FigureFolder]);


