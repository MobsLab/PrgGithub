function AnalyseInjectionML(NameDrug,NameStructure,NameEpoch,option,SaveFig,RemoveNoisyEpochs)

% function AnalyseInjectionML
%
% inputs:
% NameDrug = 'DPCPX','LPS','CB' or 'None'
% NameStructure = e.g. 'PFCx' or 'Bulb' (see makeDataBulb.m)
% NameEpoch = epochs in StateEpoch.mat (see sleepscoringML.m)
% option = 'Unique' (see /LFPData) or 'deep' 'sup' (see /ChannelsToAnalyse)
% RemoveNoisyEpochs (optional) = 1 (default) if remove noise, 0 if not

%% Verifications of inputs

if ~exist('NameDrug','var') || ~exist('NameStructure','var') || ~exist('NameEpoch','var')
    error('Not enough input arguments') 
end
if ~exist('SaveFig','var')
    SaveFig=0;
end
if ~exist('RemoveNoisyEpochs','var')|| ~ismember(RemoveNoisyEpochs,[0 1])
    RemoveNoisyEpochs=1;
end


%% other inputs
res=pwd;
scrsz = get(0,'ScreenSize');
colori={'b','r','m','k','g','b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};

pval=0.05;
CorrectionAmplifier=1;
plotSpectrumEpoch=1;
plotSpecNormalizedByVEH=1;
plotFrequencySpectrum=1;
plotSingleSpectrum=1;
plotStrainsEffect=1;

plotRatioSleep=1;
QremTpsTotal=1; % 0 for % REM on total sleep, 1 % REM on total recordings



ploRecoverStatSpectr=0;

%% Initialisation Directories
if ~exist([res,'/AnalyseInjection',NameDrug],'dir')
   mkdir(res,['/AnalyseInjection',NameDrug]);
end
ANALYNAME=['AnalyseInjection',NameDrug,'/Analyse',NameDrug,'_',NameStructure,option,'_',NameEpoch];

if exist([ANALYNAME,'.mat'],'file')
    disp([ANALYNAME,'.mat already exists.. Using existing parameters'])
    load([ANALYNAME,'.mat'],'InjName','Dir','restrictInj')
else
    
    if strcmp(NameDrug,'DPCPX')
        InjName={'Pre' 'VEH' 'DPCPX'};
        restrictInj=InjName;
        %restrictInj={'VEH','DPCPX'};
        Dir=PathForExperimentsML('DPCPX');
        
    elseif strcmp(NameDrug,'LPS')
        InjName={'PreVEH' 'VEH' 'PreLPS' 'LPS' 'H24' 'H48'};
        restrictInj={'VEH','LPS','H24','H48'};
        StrainTOpool='C57';
        Dir=PathForExperimentsML('LPS');
        
    elseif strcmp(NameDrug,'CP')
        InjName={'Pre' 'VEH' 'CP'};
        %restrictInj={'VEH','CP'};
        restrictInj={'Pre' 'VEH','CP'};
        StrainTOpool='C57';
        Dir=PathForExperimentsML('CANAB');
        
    elseif strcmp(NameDrug,'None');
        InjName={'Pre'}; restrictInj={'Pre'};
        StrainTOpool='dKO';
        Dir=PathForExperimentsML('BASAL');
    else
        error(['No drug name corresponding to ',NameDrug])
    end
    
    disp(['... Creating ',ANALYNAME,'.mat'])
    save([ANALYNAME,'.mat'],'InjName','Dir','restrictInj');
end

Strains=unique(Dir.group);
MiceNames=unique(Dir.name);


%% Spectre of NameStructure

disp(' ')
disp('... Calculating Spectrum for all experiments in Dir')

IntPlot=intervalSet(0,30*1E4);


try
    load([res,'/',ANALYNAME,'.mat'],'AllSpectro','AllGroup','freqfi','fi','AllEpochs');  
    AllSpectro{1}(1); AllGroup{1}(1); Start(AllEpochs{1,1});
    if ~exist('freqfi','var'), freqfi=fi; save([res,'/',ANALYNAME,'.mat'],'-append','freqfi');end
    
catch
    
    % define parameters for spectrograms
    [params,movingwin,suffix]=SpectrumParametersML('low');
    
    for inj=1:length(InjName)
        AllSpectro{inj}=nan(length(Dir.path),1000); AllGroup{inj}=nan(length(Dir.path),2);
    end
    
    if plotSpectrumEpoch,
        figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]); FSpecAll=gcf;
        FSpecAll_ylim=[];
    end
    
    for man=1:length(Dir.path)
        
        clear InfoLFP nameMan
        clear SWSEpoch REMEpoch MovEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch SuperThetaEpoch ThetaEpoch
        clear PreEpoch VEHEpoch DPCPXEpoch LPSEpoch H24Epoch H48Epoch PreVEHEpoch PreLPSEpoch
        
        nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21);
        disp(' ')
        disp(['           * * * ',nameMan,' * * *'])
         
        
        % ------------- EPOCHS ------------- 
        % ----------------------------------
        load([Dir.path{man},'/StateEpoch.mat'],'SWSEpoch','REMEpoch','MovEpoch','ImmobEpoch','SuperThetaEpoch','ThetaEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        %try Start(SuperThetaEpoch); catch, run('/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/AnalyseBOold/SuperTheta.m'); end
        
        if strcmp(NameDrug,'DPCPX')
            load([Dir.path{man},'/behavResources.mat'],'PreEpoch','VEHEpoch','DPCPXEpoch');
        elseif strcmp(NameDrug,'LPS')
            load([Dir.path{man},'/behavResources.mat'],'PreEpoch','VEHEpoch','LPSEpoch','H24Epoch','H48Epoch');
            if exist('PreEpoch','var') && exist('VEHEpoch','var'), PreVEHEpoch=PreEpoch;
            elseif exist('PreEpoch','var') && exist('LPSEpoch','var'), PreLPSEpoch=PreEpoch;
            end
        elseif strcmp(NameDrug,'CP')
            load([Dir.path{man},'/behavResources.mat'],'PreEpoch','VEHEpoch','CPEpoch');
        elseif strcmp(NameDrug,'None')
            load([Dir.path{man},'/behavResources.mat'],'PreEpoch');
        end
        
        for inj=1:length(InjName)
            if ~exist([InjName{inj},'Epoch'],'var'), eval([InjName{inj},'Epoch=intervalSet([],[]);']);end
        end
        if ~exist('WeirdNoiseEpoch','var'), WeirdNoiseEpoch=intervalSet([],[]);end
        % ----------------------------------
    
        
        % ------------------------------------------------------
        % -------------- ComputeSpectrogramML ------------------
        try
            load([Dir.path{man},'/LFPData.mat'],'InfoLFP')
            InfoLFP.name(1);
        catch
            InfoLFP=listLFP_to_InfoLFP_ML(Dir.path{man});
        end
        
        cd(Dir.path{man})
        [Spi,ti,freqfi,channelToAnalyse,params_out,movingwin_out]=ComputeSpectrogram_newML(movingwin,params,InfoLFP,NameStructure,option,suffix);
        if ~isequal(params_out,params),disp('WARNING: params is not as required');end
        if ~isequal(movingwin_out,movingwin),disp('WARNING: movingwin is not as required');end
        
        cd(res)
        if CorrectionAmplifier
            Spi=Dir.CorrecAmpli(man)*Spi;
        end
        % -----------------------------------------------------
        
        for inj=1:length(InjName),
            clear epoch tEpoch SpEpoch
            
            if RemoveNoisyEpochs
                eval(['epoch=and(',NameEpoch,',',InjName{inj},'Epoch)-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;']);
            else
                eval(['epoch=and(',NameEpoch,',',InjName{inj},'Epoch);']);
                disp('Noise Epochs could not be removed')
            end
            
            AllEpochs{man,inj}=epoch;
            
            if ~isempty(Start(epoch)) && length(ti)>1
                 % ----------------------
                 % SpectroEpochML
                [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,freqfi,epoch);
                
                % ----------------------
                % Display
                if plotSpectrumEpoch,
                    figure(FSpecAll)
                    subplot(length(InjName),length(Dir.path),(inj-1)*length(Dir.path)+man),
                    hold on, imagesc(tEpoch,freqfi,10*log10(SpEpoch)'); axis xy; caxis([15 60])
                    title([Dir.group{man},'-',Dir.name{man}(7:8),' ',InjName{inj}]); ylim(ceil(params.fpass));
                    ylabel('Frequency (Hz)'); xlabel('time (s)');
                    y=ylim; FSpecAll_ylim=[FSpecAll_ylim y(2)];
                end
                
                % ---------------------- 
                % save variables
                if size(AllSpectro{inj},2)~=size(SpEpoch,2)
                   try  AllSpectro{inj}=AllSpectro{inj}(:,1:size(SpEpoch,2)); catch, keyboard; end
                end
                AllSpectro{inj}(man,:)=mean(SpEpoch,1);
                AllGroup{inj}(man,:)=[find(strcmp(Dir.group{man},Strains)),find(strcmp(Dir.name{man},MiceNames))];
                
            end
        end

    end

    save([res,'/',ANALYNAME,'.mat'],'AllSpectro','AllGroup','AllEpochs','freqfi','-append');

end


%% display mean Spectro normalized by VEHEpoch for all strains
    
if plotSpecNormalizedByVEH && sum(strcmp(restrictInj,'VEH')) 
    
    % normalized spectrum vs VEH
    
    for gg=1:length(Strains), for inj=1:length(InjName), PoolStrainsSp{gg,inj}=[];end;end
    
    figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FDrugVsVEH=gcf;
    FDrugVsVEH_ylim=[];
    for uu=1:length(MiceNames)
        
        FDrugVsVEH_leg=[];
        clear Spf
        
        for inj=[find(strcmp(InjName,'VEH')),find(~strcmp(InjName,'VEH'))];
            Index_uu=find(AllGroup{inj}(:,2)==uu);
            Spf{inj}=AllSpectro{inj}(Index_uu,:);
            
            if inj~=find(strcmp(InjName,'VEH')) && sum(strcmp(InjName{inj},restrictInj)) && ~isempty(Index_uu)
                
                figure(FDrugVsVEH),
                subplot(3,ceil(length(MiceNames)/3),uu)
                try
                    hold on, plot(freqfi,log10(Spf{inj}./Spf{strcmp(InjName,'VEH')}),'linewidth',2,'color',colori{inj});
                    FDrugVsVEH_leg=[FDrugVsVEH_leg, InjName(inj)];

                    index_PoolStrainsSp=unique(AllGroup{inj}(Index_uu,1));
                    PoolStrainsSp{index_PoolStrainsSp,inj}=[PoolStrainsSp{index_PoolStrainsSp,inj};log10(Spf{inj}./Spf{strcmp(InjName,'VEH')})];
                catch
                    keyboard
                end
                y=ylim; FDrugVsVEH_ylim=[FDrugVsVEH_ylim y];
                title([Strains{unique(AllGroup{inj}(Index_uu,1))},'-',MiceNames{uu}(end-2:end),' (norm by VEH)']);
                xlabel('Frequency (Hz)');ylabel([NameStructure,option,' -',NameEpoch])
            end
        end
        line([0 20],[0 0],'color',[0.7 0.7 0.7]); xlabel('Frequency (Hz)');
    end
    legend(FDrugVsVEH_leg);
    
    
    if plotStrainsEffect
        figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FpoolStrains_VEH=gcf;
        FpoolStrains_VEH_ylim=[];a=0;
        for inj=find(~strcmp(InjName,'VEH'))
            if sum(strcmp(InjName{inj},restrictInj))
                a=a+1;
                subplot(1,length(find(~strcmp(restrictInj,'VEH'))),a),
                FpoolStrains_VEH_leg=[];
                for gg=1:length(Strains)
                    try
                        hold on, plot(freqfi,mean(PoolStrainsSp{gg,inj},1),'linewidth',2,'color',colori{gg});
                        FpoolStrains_VEH_leg=[FpoolStrains_VEH_leg,{[Strains{gg},' (n=',num2str(size(PoolStrainsSp{gg,inj},1)),')']}];
                        if size(PoolStrainsSp{gg,inj},1)>2
                            hold on, plot(freqfi,mean(PoolStrainsSp{gg,inj},1)+stdError(PoolStrainsSp{gg,inj}),'color',colori{gg});
                            hold on, plot(freqfi,mean(PoolStrainsSp{gg,inj},1)-stdError(PoolStrainsSp{gg,inj}),'color',colori{gg});
                            FpoolStrains_VEH_leg=[FpoolStrains_VEH_leg,'+std','-std'];
                        end
                    catch
                        keyboard
                    end
                end
                if size(PoolStrainsSp{1,inj},1)>1 && size(PoolStrainsSp{2,inj},1)>1
                    [H,p]=ttest2(PoolStrainsSp{1,inj},PoolStrainsSp{2,inj});
                    hold on, plot(freqfi(p<pval),zeros(length(p(p<pval))),'g.');
                    if sum(p<pval)>0, FpoolStrains_VEH_leg=[FpoolStrains_VEH_leg,{['pvalue < ',num2str(pval)]}];end
                end

                y=ylim; FpoolStrains_VEH_ylim=[FpoolStrains_VEH_ylim y];
                xlabel('Frequency (Hz)');ylabel([NameStructure,option,' -',NameEpoch])
                line([0 20],[0 0],'color',[0.7 0.7 0.7]); 
                legend(FpoolStrains_VEH_leg)
                title(['Strain effect -',InjName{inj},'- (norm by VEH)'])
            end
        end
    end
    
end

%% display mean Spectro pooled for dKO vs WT

if plotFrequencySpectrum
    
    if plotSingleSpectrum,
        figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]); Ffsingle=gcf;
        Ffsingle_leg=[]; Ffsingle_ylim=[];
    end
    if plotStrainsEffect
        figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]); FStrainsEffect=gcf;
        FStrainsEffect_ylim=[];
    end
        
    
    for inj=1:length(InjName)

        legst=[];
        clear Spf Spf_group
        
        for uu=1:length(MiceNames)
            clear Index_MiceNames Spfstd
            Index_MiceNames=find(AllGroup{inj}(:,2)==uu);
            if ~isempty(Index_MiceNames)
                Spf(uu,:)=mean(AllSpectro{inj}(Index_MiceNames,:),1);
                Spf_group(uu,1:2)=AllGroup{inj}(Index_MiceNames,1:2);
                Spfstd=stdError(AllSpectro{inj}(Index_MiceNames,:));
                
                if plotSingleSpectrum
                    
                    figure(Ffsingle);
                    subplot(3,ceil(length(MiceNames)/3),uu)
                    hold on, plot(freqfi,Spf(uu,:),'linewidth',2,'color',colori{inj});
                    title(MiceNames{uu}), xlabel('Frequency (Hz)')
                    y=ylim; Ffsingle_ylim=[Ffsingle_ylim y(2)];
                end
            end
            
        end
    
        if plotStrainsEffect        
            FStrainsEffect_leg=[]; 
            for gg=1:length(Strains)
                
                clear Index_Strains
                Index_Strains=find(Spf_group(:,1)==gg);
                try SpfTemp{gg}=Spf(Index_Strains,:); catch; keyboard;end
                
                
                % plot spectrum of the different strains
                try
                    figure(FStrainsEffect), subplot(1,length(InjName),inj)
                    hold on, plot(freqfi,nanmean(Spf(Index_Strains,:),1),'linewidth',2,'color',colori{gg});
                    FStrainsEffect_leg=[FStrainsEffect_leg,{[Strains{gg},' (n=',num2str(size(Spf(Index_Strains,:),1)),')']}];
                catch
                    keyboard
                end
                if size(Spf(Index_Strains,:),1)>1,
                    hold on, plot(freqfi,nanmean(Spf(Index_Strains,:),1)+stdError(Spf(Index_Strains,:)),'color',colori{gg});
                    hold on, plot(freqfi,nanmean(Spf(Index_Strains,:),1)-stdError(Spf(Index_Strains,:)),'color',colori{gg});
                    FStrainsEffect_leg=[FStrainsEffect_leg,'+std','-std'];
                end
                
                y=ylim; FStrainsEffect_ylim=[FStrainsEffect_ylim y(2)];
                title(['Strain Effect - ',InjName{inj}])
                xlabel('Frequency (Hz)'); ylabel([NameStructure,option,' -',NameEpoch])
            end
            
            
            if size(SpfTemp{1},1)>1 && size(SpfTemp{2},1)>1
                [H,p]=ttest2(SpfTemp{1},SpfTemp{2});
                hold on, plot(freqfi(p<pval),ones(length(p(p<pval))),'g.');
                if sum(p<pval)>0, FStrainsEffect_leg=[FStrainsEffect_leg,{['pvalue < ',num2str(pval)]}];end
            end
            legend(FStrainsEffect_leg)
        end
    end
end

%% RecoverStat
if 0
if plotFrequencySpectrum && strcmp(NameDrug,'LPS') 

    for inj=1:length(InjName)            
            
            % plot spectrum of different injection epochs
            if  ploRecoverStatSpectr
                
                XlimSpec=[0,2;2,5;6,9;10,15];
                if inj==1 && strcmp(Strains{gg},StrainTOpool)
                    
                    
                    for iiinj=1:length(InjName)
                        SpStat{iiinj}=SaveSp{nn,iiinj}(strcmp(SaveSpgroup{nn,iiinj}(:,1),Strains{gg}),:);
                        SpNormStat{iiinj}=SaveSpNorm{nn,iiinj}(strcmp(SaveSpgroup{nn,iiinj}(:,1),Strains{gg}),:);
                    end
                    for xx=1:size(XlimSpec,1)
                        SpStatXx{xx}=[];
                        for iiinj=1:length(InjName)
                            SpStatXx{xx}=[SpStatXx{xx} {mean(SpStat{iiinj}(:,freqfi>XlimSpec(xx,1) & freqfi<XlimSpec(xx,2)),2)}];
                        end
                    end
                    
                    
                    % ---------------------------------------
                    % -------- not normalized spectrum ------
                    figure(Ffpool{ll}), subplot(2,length(NameEpoch),nn)
                    SpVEH=SpStat{strcmp(InjName,'VEH')};
                    SpLPS=SpStat{strcmp(InjName,'LPS')};
                    SpRECOVER=[SpStat{strcmp(InjName,'H24')};SpStat{strcmp(InjName,'H48')}];
                    
                    hold on, plot(freqfi,mean(SpVEH,1),'linewidth',2,'color','r');
                    hold on, plot(freqfi,mean(SpLPS,1),'linewidth',2,'color','k');
                    hold on, plot(freqfi,mean(SpRECOVER,1),'linewidth',2,'color','g');
                    
                    lVEH=size(SpVEH); lLPS=size(SpLPS); lRECOVER=size(SpRECOVER);
                    legend(['VEH (n=',num2str(lVEH(1)),')'],['LPS (n=',num2str(lLPS(1)),')'],['RECOVER (n=',num2str(lRECOVER(1)),')'])
                    
                    if lVEH(1)>1, hold on, plot(freqfi,mean(SpVEH,1)+stdError(SpVEH),'color','r'); plot(freqfi,mean(SpVEH,1)-stdError(SpVEH),'color','r'); end
                    if lLPS(1)>1, hold on, plot(freqfi,mean(SpLPS,1)+stdError(SpLPS),'color','k'); plot(freqfi,mean(SpLPS,1)-stdError(SpLPS),'color','k'); end
                    if lRECOVER(1)>1, hold on, plot(freqfi,mean(SpRECOVER,1)+stdError(SpRECOVER),'color','g'); plot(freqfi,mean(SpRECOVER,1)-stdError(SpRECOVER),'color','g'); end
                    
                    if lVEH(1)>1 && lLPS(1)>1, [H,p]=ttest2(SpVEH,SpLPS); plot(freqfi(p<pval),zeros(length(p(p<pval))),'r.');end
                    if lLPS(1)>1 && lRECOVER(1)>1, [H,p]=ttest2(SpLPS,SpRECOVER); plot(freqfi(p<pval),zeros(length(p(p<pval)))+4E4,'g.');end
                    
                    ylabel(NameEpoch)
                    title([Strains{gg},' -',nameSpectre{ll}])
                    
                    % -------- ANOVA sur XlimSpec ------
                    if SaveFig, try, nameFolderSave; catch, nameFolderSave=input('     * Enter Folder where figures should be saved: ','s');end;end
                    disp(NameEpoch)
                    fprintf(file,'%s\n',' ');fprintf(file,'%s\n',' ');
                    fprintf(file,'%s\n',['* * * ',NameEpoch,' - Stats LFP ',nameSpectre{ll},' * * *']);
                    for xx=1:size(XlimSpec,1)
                        [p,t,st,Pt,group]=CalculANOVAmultipleOneway(SpStatXx{xx}); FfpoolStatTemp(xx)=gcf;
                        figure(FfpoolStatTemp(xx)), title([NameEpoch,'   * LFP ',nameSpectre{ll},' *   ',num2str(XlimSpec(xx,1)),'-',num2str(XlimSpec(xx,2)),'Hz']);
                        ylabel(['Power of frequency band ',num2str(XlimSpec(xx,1)),'-',num2str(XlimSpec(xx,2)),'Hz']); set(gca,'xtick',1:length(InjName));set(gca,'xticklabel',InjName);
                        saveFigure(FfpoolStatTemp(xx),['C57Pool_',nameSpectre{ll},'Amp_',num2str(XlimSpec(xx,1)),'-',num2str(XlimSpec(xx,2)),'Hz_',NameEpoch(1:end-5)],[res,'/',nameFolderSave]); close
                        
                        disp(['-> ',num2str(XlimSpec(xx,1)),'-',num2str(XlimSpec(xx,2)),'Hz']);disp(Pt);
                        pval=0.05;
                        fprintf(file,'%s\n',' ');fprintf(file,'%s\n',' ');
                        fprintf(file,'%s\n',['Stats LFP ',nameSpectre{ll},'   ',num2str(XlimSpec(xx,1)),'-',num2str(XlimSpec(xx,2)),'Hz']);
                        for j=1:length(InjName), fprintf(file,'%s\n',' '); for ii=1:length(InjName)-1, fprintf(file,'%6.3f',Pt{ii,j});end;end
                        fprintf(file,'%s\n','  ');
                        for ii=1:length(InjName)-1,
                            for j=1:length(InjName),
                                if Pt{ii,j}<pval,
                                    disp([InjName{ii},' vs ',InjName{j},': p=',num2str(Pt{ii,j})]);
                                    fprintf(file,'%s\n',[InjName{ii},' vs ',InjName{j},': p=',num2str(Pt{ii,j})]);
                                end
                            end
                        end
                        
                    end
                    
                    FfpoolStat{nn,ll}=FfpoolStatTemp;
                                       
                end
            else
                
                if sum(strcmp(InjName{inj},restrictInj)) && strcmp(Strains{gg},StrainTOpool)
                    figure(Ffpool{ll}),
                    % not normalized spectrum
                    subplot(2,length(NameEpoch),nn)
                    hold on, plot(freqfi,mean(Spf(Index_Strains,:),1),'linewidth',2,'color',colori{inj});
                    legPool=[legPool,{[InjName{inj},' (n=',num2str(sum(Index_Strains)),')']}];
                    if sum(Index_Strains)>1,
                        hold on, plot(freqfi,mean(Spf(Index_Strains,:),1)+Spfstd,'color',colori{inj});
                        hold on, plot(freqfi,mean(Spf(Index_Strains,:),1)-Spfstd,'color',colori{inj});
                        legPool=[legPool,'+std','-std'];
                    end
                    ylabel(NameEpoch)
                    title([Strains{gg},' -',nameSpectre{ll}])
                    
                    % normalized spectrum
                    subplot(2,length(NameEpoch),length(NameEpoch)+nn)
                    hold on, plot(freqfi,mean(SpfNorm(Index_Strains,:),1),'linewidth',2,'color',colori{inj});
                    if sum(Index_Strains)>1,
                        hold on, plot(freqfi,mean(SpfNorm(Index_Strains,:),1)+SpfNormstd,'color',colori{inj});
                        hold on, plot(freqfi,mean(SpfNorm(Index_Strains,:),1)-SpfNormstd,'color',colori{inj});
                    end
                    ylabel(NameEpoch)
                    title([Strains{gg},' -',nameSpectre{ll},' (normalized)'])
                end
            end
            


        if plotStrainsEffect
            figure(Ffpoolst(ll)),
            ylabel(nameSpectre{ll});
            title([NameEpoch,' -',InjName{inj}])
            
            if size(SpfTemp{1},1)>1 && size(SpfTemp{2},1)>1
                [H,p]=ttest2(SpfTemp{1},SpfTemp{2});
                hold on, plot(freqfi(p<pval),ones(length(p(p<pval))),'g.');
            end
            legend([legst,{['pvalue < ',num2str(pval)]}]);
        end
    end
    
    if ploRecoverStatSpectr==0, figure(Ffpool{ll}), legend(legPool);end
end
end


%% bar plot
try
    FreqBands=[0 2; 1 4; 1 7; 4 10; 7 14; 10 16];
    figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]); FbarPlots=gcf; 
    FreqBands_ylim=[];
    for i=1:size(FreqBands,1)
        subplot(ceil(size(FreqBands,1)/3),3,i)
        AnalyseInjection_BarPlotML(NameDrug,NameStructure,NameEpoch,option,FreqBands(i,:),SaveFig,FbarPlots);
        FreqBands_ylim=[FreqBands_ylim,ylim];
    end
catch
    keyboard
end

%% Rescale figures

%FSpecAll
if exist('FSpecAll','var'),
    figure(FSpecAll),
    for inj=1:length(InjName),
        for man=1:length(Dir.path),
            subplot(length(InjName),length(Dir.path),(inj-1)*length(Dir.path)+man),
            ylim([0,max(FSpecAll_ylim)]);
        end
    end
end


if plotFrequencySpectrum
    if plotSingleSpectrum
        % Ffsingle
        figure(Ffsingle), 
        for uu=1:length(MiceNames), 
            subplot(3,ceil(length(MiceNames)/3),uu)
            ylim([0,max(Ffsingle_ylim)]);
            legend(InjName); 
        end
    end
    
    % FStrainsEffect
    figure(FStrainsEffect), 
    for inj=1:length(InjName),
        subplot(1,length(InjName),inj), 
        ylim([0,max(FStrainsEffect_ylim)]);
    end
end



if plotSpecNormalizedByVEH
    
    % FDrugVsVEH
    figure(FDrugVsVEH),
    for uu=1:length(MiceNames)
        subplot(3,ceil(length(MiceNames)/3),uu),
        ylim([min(FDrugVsVEH_ylim),max(FDrugVsVEH_ylim)]);
    end
    
    % FpoolStrains_VEH
    if plotStrainsEffect
        figure(FpoolStrains_VEH); 
        for inj=1:length(find(~strcmp(restrictInj,'VEH')))
            subplot(1,length(find(~strcmp(restrictInj,'VEH'))),inj),
            ylim([min(FpoolStrains_VEH_ylim),max(FpoolStrains_VEH_ylim)]);
        end
    end
    
    % FbarPlots
    figure(FbarPlots)
    for i=1:size(FreqBands,1)
        subplot(ceil(size(FreqBands,1)/3),3,i), 
        %ylim([0, max(FreqBands_ylim)]);
        if i<size(FreqBands,1), legend off; end
    end
    
end

%% save

if SaveFig,
     
    % nameFolderSave to save figure
    nameFolderSave=['AnalyseInjection',NameDrug,'/Figures',NameStructure,option,'_',NameEpoch];
    if ~exist([res,'/',nameFolderSave],'dir')
        mkdir(res,nameFolderSave);
    else
        disp(['WARNING! ',nameFolderSave,' already exists. Figures might be erased'])
    end
    disp(['...keyboard before saving figures in ',nameFolderSave])
    keyboard
    
    if plotSpecNormalizedByVEH
        saveFigure(FDrugVsVEH,'DrugVsVEH_All',[res,'/',nameFolderSave]);
        if plotStrainsEffect, saveFigure(FpoolStrains_VEH,'DrugVsVEH_StrainEffect',[res,'/',nameFolderSave]);end
    end
    
    if plotFrequencySpectrum
        if plotSingleSpectrum, saveFigure(Ffsingle,'Spectro_All',[res,'/',nameFolderSave]);end
        saveFigure(FStrainsEffect,'Spectro_StrainEffect',[res,'/',nameFolderSave]);
    end
    
    if exist('FSpecAll','var'),
        saveFigure(FSpecAll,'Spectro_All',[res,'/',nameFolderSave]);
    end
    
    saveFigure(FbarPlots,'StrainXInjection',[res,'/',nameFolderSave]);
end

