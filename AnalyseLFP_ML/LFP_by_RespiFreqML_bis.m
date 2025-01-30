function [FSp_pooled,MatrixSpStrain,MatrixSpMice,MatrixSpInfMice,MatrixSpSupMice]=LFP_by_RespiFreqML_bis(NameDir,StructureName,NameEpoch,plotIndividual,Freq)

% function LFP_by_RespiFreqML_bis
%
% inputs:
% - NameDir = path with PLETHYSMOGRAPH data (see PathForExperimentsML.m)
% - StructureName = name of the structure to analyse e.g. {'Bulb','BO'}
% - NameEpoch = name of intervalSet in StateEpoch.mat (see sleepscoringML.m)
% - plotIndividual = plot individual data
% - Freq = frequency Basal and Sniff mode (default [1.5 5 ; 6 10])
%
% outputs:
% - FSp_pooled = number of figure with strain effect
% - MatrixSpStrain = for all mice, strain.
% - MatrixSpMice = for all mice, mean spectro 
% - MatrixSpInfMice = for all mice, mean spectro for inf frequencies
% - MatrixSpSupMice = for all mice, mean spectro for sup frequencies
%
% !!! Papier Lisa !!!
% numF=LFP_by_RespiFreqML('PLETHYSMO',{'Bulb' 'BO'},'MovEpoch');


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

if exist('Freq','var')==0 || isequal(size(Freq),[2,2])==0
    FreqInf=[1.5 5];
    FreqSup=[6 10];
    disp(['Using default frequencies: ',num2str(FreqInf),'Hz and ',num2str(FreqSup),'Hz.'])
else
    FreqInf=Freq(1,:);
    FreqSup=Freq(2,:);
end

if exist('plotIndividual','var')==0
    plotIndividual=0;
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
ANALYNAME=['Analyse_LFP_by_RespiFreq_',NameDir,'_',NameEpoch];
strains=unique(Dir.group);
MiceNames=unique(Dir.name);


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
    eval(['MatrixSpInf=MatrixSpInf_',StructNickName,';']);
    eval(['MatrixSpSup=MatrixSpSup_',StructNickName,';']);
    
    disp(['/',ANALYNAME,'.mat already exists...'])
    ErasePreviousAnalysis=input('Do you want to erase previous analysis (y/n)? ','s');
    if ErasePreviousAnalysis=='y'
        ErasePreviousAnalysis=1; 
    else
        ErasePreviousAnalysis=0;
        disp(['Using data from ',ANALYNAME,'.mat ...'])
    end
    
catch
    ErasePreviousAnalysis=1; 
    disp(['Saving analysis in /',ANALYNAME,'.mat'])
end


%% Calculating spectrogram

% ------ parameters spectro ------
params.Fs=1000; params.trialave=0;
params.err=[1 0.0500]; params.pad=2;
params.fpass=[0.01 15];
movingwin=[3 0.2]; params.tapers=[3 5];

if ErasePreviousAnalysis
    save([res,'/',ANALYNAME,'.mat'],'NameDir','StructureName','NameEpoch')
    
    disp('... Loading or calculating Spectrum for all experiments in Dir')
    
    % ------------------------------------------
    % initiate Matrix
    MatrixSp=[];
    MatrixSpGroup=nan(length(Dir.path),2);
    MatrixSpInf=[];
    MatrixSpSup=[];
end

if ErasePreviousAnalysis || plotIndividual
    
    for man=1:length(Dir.path)
        
        disp(' ')
        disp(['           * * * ',Dir.path{man}(strfind(Dir.path{man},'Mouse'):end),' * * *'])
        
        % --------------------
        % ----- spectrum -----
        clear listLFP
        load([Dir.path{man},'/listLFP.mat'],'listLFP')
        
        if sum(strcmp(listLFP.name,StructName))~=0
            
            % ------------------------------------------------------
            % -------------- ComputeSpectrogramML ------------------
            % calculate Sp for all LFP
            clear Spi ti fi info LFP
            load([Dir.path{man},'/LFPData.mat'],'LFP')
            info.name=StructName;
            info.channels=listLFP.channels{strcmp(listLFP.name,StructName)};
            info.depth=listLFP.depth{strcmp(listLFP.name,StructName)};
            [Spi,ti,fi]=ComputeSpectrogramML(LFP,movingwin,params,[Dir.path{man},'/AnalyseFreq.mat'],{StructName,StructNickName},info);
            % ------------------------------------------------------
            
            if CorrectionAmplifier
                Spi=Dir.CorrecAmpli(man)*Spi;
            end
            
            
                % --------------------
                % ------ EPOCHS ------
                clear REMEpoch SWSEpoch MovEpoc NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
                load([Dir.path{man},'/StateEpoch.mat'],NameEpoch,'NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
                eval(['epoch=',NameEpoch,'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
                
                clear  Frequency 
                load([Dir.path{man},'/LFPData.mat'],'Frequency')
                
            if ErasePreviousAnalysis
                % --------------------------------------------------------------
                % ----- load respi info ------------
                clear t_RespiFreq D_RespiFreq
                
                t_RespiFreq=Range(Frequency);
                D_RespiFreq=Data(Frequency);
                sta_inf=[]; stp_inf=[];
                sta_sup=[]; stp_sup=[];
                for i=1:length(t_RespiFreq)-1
                    if D_RespiFreq(i)>FreqInf(1) && D_RespiFreq(i)<FreqInf(2)
                        sta_inf=[sta_inf,t_RespiFreq(i)];
                        stp_inf=[stp_inf,t_RespiFreq(i+1)];
                    elseif D_RespiFreq(i)>FreqSup(1) && D_RespiFreq(i)<FreqSup(2)
                        sta_sup=[sta_sup,t_RespiFreq(i)];
                        stp_sup=[stp_sup,t_RespiFreq(i+1)];
                    end
                end
                
                % length epoch
                AllEpoch{man,1}=epoch;
                AllEpoch{man,2}=and(epoch,intervalSet(sta_inf,stp_inf));
                AllEpoch{man,3}=and(epoch,intervalSet(sta_sup,stp_sup));
            end
            
            % ------------------------------------------------------
            % ------------------ SpectroEpochML --------------------
            % calculate Spectro restricted to epoch
            clear epoch epochFreqInf epochFreqSup
            epoch=AllEpoch{man,1};
            epochFreqInf=AllEpoch{man,2};
            epochFreqSup=AllEpoch{man,3};
            
            clear tEpoch tEpoch_inf tEpoch_sup SpEpoch SpEpoch_inf SpEpoch_sup 
            [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,fi,epoch);
            [tEpoch_inf, SpEpoch_inf]=SpectroEpochML(Spi,ti,fi,epochFreqInf);
            [tEpoch_sup, SpEpoch_sup]=SpectroEpochML(Spi,ti,fi,epochFreqSup);
            
            % ------------------------------------------------------
            
            if ErasePreviousAnalysis
                try
                    MatrixSp(man,:)=mean(SpEpoch,1);
                catch  
                    keyboard
                end
                MatrixSp(man,:)=mean(SpEpoch,1);
                MatrixSpGroup(man,:)=[find(strcmp(Dir.group{man},strains)),find(strcmp(Dir.name{man},MiceNames))];
                MatrixSpInf(man,:)=mean(SpEpoch_inf,1);
                MatrixSpSup(man,:)=mean(SpEpoch_sup,1);
            end
            
             % ------------------------------------------------------
            % ------------------------------------------------------
            % --- display individual freqinf and FreqSup periods ---
            if plotIndividual
                figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/5]), FSp_Single(man)=gcf;
                
                subplot(1,4,1)
                plot(Range(Frequency,'s'),Data(Frequency),'.k')
                hold on, plot(Range(Restrict(Frequency,epochFreqInf),'s'),Data(Restrict(Frequency,epochFreqInf)),'.g');
                hold on, plot(Range(Restrict(Frequency,epochFreqSup),'s'),Data(Restrict(Frequency,epochFreqSup)),'.r');
                
                subplot(1,4,2)
                hold on, imagesc(tEpoch,fi,10*log10(SpEpoch)'); axis xy; caxis([-110 -70]);
                title(Dir.path{man}(strfind(Dir.path{man},'Mouse'):end))
                ylabel('Frequency (Hz)'), xlabel('time (s)');
                
                subplot(1,4,3)
                hold on, imagesc(tEpoch_inf,fi,10*log10(SpEpoch_inf)'); axis xy; caxis([-110 -70]);
                title(['basal mode (',num2str(FreqInf),'Hz)'])
                ylabel('Frequency (Hz)'), xlabel('time (s)');
                
                subplot(1,4,4)
                hold on, imagesc(tEpoch_sup,fi,10*log10(SpEpoch_sup)'); axis xy; caxis([-110 -70]);
                title(['sniff mode (',num2str(FreqSup),'Hz)'])
                ylabel('Frequency (Hz)'), xlabel('time (s)');
            end
            % ------------------------------------------------------
             % ------------------------------------------------------
        else
            disp(['no LFP ',StructName,', skipping this step'])
        end
    end
    
    if ErasePreviousAnalysis
        % saving in analyname
        eval(['MatrixSp_',StructNickName,'=MatrixSp;'])
        eval(['MatrixSpGroup_',StructNickName,'=MatrixSpGroup;']);
        eval(['MatrixSpInf_',StructNickName,'=MatrixSpInf;'])
        eval(['MatrixSpSup_',StructNickName,'=MatrixSpSup;'])
        
        save([res,'/',ANALYNAME,'.mat'],['MatrixSp_',StructNickName],['MatrixSpGroup_',StructNickName],'-append');
        save([res,'/',ANALYNAME,'.mat'],['MatrixSpInf_',StructNickName],['MatrixSpSup_',StructNickName],'-append');
        save([res,'/',ANALYNAME,'.mat'],'fi','AllEpoch','movingwin','params','-append');
    end
end


%% display individual mean spectro All

figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), FSp_Individual=gcf;
figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), FSpInf_Individual=gcf;
figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), FSpSup_Individual=gcf;

for man=1:length(Dir.path)
    
    % All frequency
    figure(FSp_Individual), subplot(3,ceil(length(Dir.path)/3),man)
    if sum(MatrixSp(man,:))>0
        hold on, plot(fi,MatrixSp(man,:),'k','linewidth',2);
        ylim([0 2/1E8]);
        xlabel(['epoch= ',num2str(ceil(sum(Stop(AllEpoch{man,1},'s')-Start(AllEpoch{man,1},'s')))),'s']);
    end
    ylabel([StructNickName,' LFP - ',NameEpoch]), 
    title([Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:end)])
    
    % frequency INF
    figure(FSpInf_Individual), subplot(3,ceil(length(Dir.path)/3),man)
    if sum(MatrixSpInf(man,:))>0
        hold on, plot(fi,MatrixSpInf(man,:),'k','linewidth',2);
        ylim([0 2/1E8]);
         xlabel(['epoch= ',num2str(ceil(sum(Stop(AllEpoch{man,2},'s')-Start(AllEpoch{man,2},'s')))),'s']);
    end
    ylabel([StructNickName,' LFP - ',NameEpoch]), 
    title([Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:end),' - freq [',num2str(FreqInf),']Hz'])
    
    % frequency SUP
    figure(FSpSup_Individual), subplot(3,ceil(length(Dir.path)/3),man)
    if sum(MatrixSpSup(man,:))>0
        hold on, plot(fi,MatrixSpSup(man,:),'k','linewidth',2);
        ylim([0 2/1E8]);
        xlabel(['epoch= ',num2str(ceil(sum(Stop(AllEpoch{man,3},'s')-Start(AllEpoch{man,3},'s')))),'s']);
    end
    ylabel([StructNickName,' LFP - ',NameEpoch]), 
    title([Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:end),' - freq [',num2str(FreqSup),']Hz'])
    
end

%% pool data from same mice

MatrixSpMice=nan(length(MiceNames),size(MatrixSp,2));
MatrixSpInfMice=MatrixSpMice;
MatrixSpSupMice=MatrixSpMice;
MatrixSpStrain=nan(length(MiceNames),1);

for uu=1:length(MiceNames)
    index=find(MatrixSpGroup(:,2)==uu);
    if isempty(index)==0
        MatrixSpMice(uu,:)=mean(MatrixSp(index,:),1);
        MatrixSpInfMice(uu,:)=mean(MatrixSpInf(index,:),1);
        MatrixSpSupMice(uu,:)=mean(MatrixSpSup(index,:),1);
        MatrixSpStrain(uu)=unique(MatrixSpGroup(index,1));
    end
    clear index
end




%% display mean Spectro pooled for dKO vs WT

figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), 
FSp_pooled=gcf;

legendSt=[];
for ss=1:length(strains), 
    
    % -----------------------
    % index for each strains
    clear Manss
    Manss=MatrixSpStrain==ss;
    
    Sp_temp{ss}=MatrixSpMice(Manss & isnan(MatrixSpMice(:,1))==0,:);
    SpInf_temp{ss}=MatrixSpInfMice(Manss & isnan(MatrixSpInfMice(:,1))==0,:);
    SpSup_temp{ss}=MatrixSpSupMice(Manss & isnan(MatrixSpSupMice(:,1))==0,:);
    % -----------------------
    
    
    % All frequency
    subplot(1,3,1)
    hold on, plot(fi,mean(Sp_temp{ss},1),'linewidth',2,'color',colori{ss}); 
    legendSt=[legendSt,{[strains{ss},' (n=',num2str(size(Sp_temp{ss},1)),')']}];   
    if size(Sp_temp{ss},1)>1,
        hold on, plot(fi,mean(Sp_temp{ss},1)+stdError(Sp_temp{ss}),'color',colori{ss});
        hold on, plot(fi,mean(Sp_temp{ss},1)-stdError(Sp_temp{ss}),'color',colori{ss});
        legendSt=[legendSt,'+std','-std'];
    end
    ylabel('Frequency Power'); xlabel('Frequency (Hz)')
    title([' LFP ',StructName,' - ',NameEpoch])
    
    % frequency inf
    subplot(1,3,2),
    hold on, plot(fi,mean(SpInf_temp{ss},1),'linewidth',2,'color',colori{ss});  
    if size(SpInf_temp{ss},1)>1,
        hold on, plot(fi,mean(SpInf_temp{ss},1)+stdError(SpInf_temp{ss}),'color',colori{ss});
        hold on, plot(fi,mean(SpInf_temp{ss},1)-stdError(SpInf_temp{ss}),'color',colori{ss});
    end
    ylabel('Frequency Power'); xlabel('Frequency (Hz)')
    title([' LFP ',StructName,' - ',NameEpoch,'- freq [',num2str(FreqInf),']Hz'])
    
    
    % frequency Sup
    subplot(1,3,3),
    hold on, plot(fi,mean(SpSup_temp{ss},1),'linewidth',2,'color',colori{ss});  
    if size(SpSup_temp{ss},1)>1,
        hold on, plot(fi,mean(SpSup_temp{ss},1)+stdError(SpSup_temp{ss}),'color',colori{ss});
        hold on, plot(fi,mean(SpSup_temp{ss},1)-stdError(SpSup_temp{ss}),'color',colori{ss});
    end
    ylabel('Frequency Power'); xlabel('Frequency (Hz)')
    title([' LFP ',StructName,' - ',NameEpoch,'- freq [',num2str(FreqSup),']Hz'])
    
end

% ------ statistics ------
% All frequency
if size(Sp_temp{1},1)>1 && size(Sp_temp{2},1)>1
    [H,p]=ttest2(Sp_temp{1},Sp_temp{2});
    subplot(1,3,1),
    hold on, plot(fi(p<pval),zeros(length(p(p<pval))),'g.');
    legendSt=[legendSt,{['pvalue < ',num2str(pval)]}]; 
end
legend(legendSt)

% frequency inf
if size(SpInf_temp{1},1)>1 && size(SpInf_temp{2},1)>1
    [H,pInf]=ttest2(SpInf_temp{1},SpInf_temp{2});
    subplot(1,3,2),
    hold on, plot(fi(pInf<pval),zeros(length(pInf(pInf<pval))),'g.');
end

% frequency sup
if size(SpSup_temp{1},1)>1 && size(SpSup_temp{2},1)>1
    [H,pSup]=ttest2(SpSup_temp{1},SpSup_temp{2});
    subplot(1,3,3),
    hold on, plot(fi(pSup<pval),zeros(length(pSup(pSup<pval))),'g.');
end
      

%% save figures
keyboard
FigureFolder=['Figures_',date];
if exist([res,'/',FigureFolder],'dir')==0, mkdir(res,FigureFolder);end

disp(['Saving figures in ',FigureFolder,'...'])
saveFigure(FSp_pooled,['LFP_by_RespiFreq_',NameEpoch,'_StrainEffect'],[res,'/',FigureFolder]);
saveFigure(FSp_Individual,['LFP_by_RespiFreq_',NameEpoch,'_Individial'],[res,'/',FigureFolder]);
saveFigure(FSpInf_Individual,['LFP_by_RespiFreq_',NameEpoch,'_Individial_FreqInf'],[res,'/',FigureFolder]);
saveFigure(FSpSup_Individual,['LFP_by_RespiFreq_',NameEpoch,'_Individial_FreqSup'],[res,'/',FigureFolder]);
