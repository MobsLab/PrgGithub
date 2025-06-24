%Redo analyse DPCPX with new doses
% CodeBulbInjectionKBbis

%% Inputs
DPCPX=0;
LPS=0;
BASAL=1;

SaveFig=1;

RemoveNoisyEpochs=1;% to remove noiseEpochs
CorrectionAmplifier=1;
ploFreqSpec=1;
ploSleep=0;
    QremTpsTotal=1; % 0 for % REM on total sleep, 1 % REM on total recordings
ploStrainEffect=1;
ploSingleSpectr=0;
ploSpectrEpoch=1;
ploRecoverStatSpectr=0;

% ----- Epochs and LFP to analyse -----
NameEpochs={'SWSEpoch','REMEpoch','MovEpoch'};
%NameEpochs={'SWSEpoch','REMEpoch','ThetaMovEpoch'};
%NameEpochs={'MovEpoch'};


if DPCPX, 
    ANALYNAME='AnalyDPCPXfromSCRATCHkb';
    InjName={'Pre' 'VEH' 'DPCPX'};
    nameSpectre={'Bulb','PFCx','PaCx','dHPC'};
    nameSp={'BO','PFC','PA','HPC'}
    restrictInj={'VEH','DPCPX'};
    StrainTOpool='dKO'; %'WT'
    
elseif LPS, 
    ANALYNAME='AnalyLPSMLkb';
    InjName={'PreVEH' 'VEH' 'PreLPS' 'LPS' 'H24' 'H48'};
    nameSpectre={'PFCx','PaCx','dHPC','AuCx'}; %nameSpectre={'PFCx','PaCx','dHPC','AuCx','AuTh'};
    nameSp={'PFC','PA','HPC','ACx'};%nameSp={'PFC','PA','HPC','ACx','ATh'};
    restrictInj={'VEH','LPS','H24','H48'};%restrictInj={'PreVEH','PreLPS','LPS'};
    StrainTOpool='C57';
    
elseif BASAL, 
    ANALYNAME='AnalyseBOkb';
    InjName={'Pre'}; restrictInj={'Pre'};
    nameSpectre={'Bulb'}; nameSp={'BO'};
    StrainTOpool='dKO'; 
end


try
   save([ANALYNAME,'.mat'],'NameEpochs','InjName','nameSpectre','nameSp','-append');
catch
    save([ANALYNAME,'.mat'],'NameEpochs','InjName','nameSpectre','nameSp');
end


res=pwd;
scrsz = get(0,'ScreenSize');
colori={'b','r','m','k','g','g','b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};

% ------ parameters spectro ------
params.Fs=1250; params.trialave=0;
params.err=[1 0.0500]; params.pad=2;
params.fpass=[0.01 20];
movingwin=[3 0.2]; params.tapers=[3 5];


% --------- Creating ArrousalStates.txt -----------
disp('... Creating MeanSp-ArrousalStates.txt')
file=fopen('MeanSp-ArrousalStates.txt','w'); Date=date;
fprintf(file,'%s\n',['* * * * * * Analyse of ',Date,' * * * * * * ']);fprintf(file,'%s\n','  ');
if RemoveNoisyEpochs,  fprintf(file,'%s\n','Noisy epochs are removed');fprintf(file,'%s\n','  ');end


%% path data to analyse

disp(' ')
try
    load([ANALYNAME,'.mat'],'Dir','numDir')
    Dir.path{1};Dir.group{1};Dir.manipe{1}; numDir;
    disp(['... Dir already defined in ',ANALYNAME,'.mat, skipping this step'])
    
catch
     disp(['... Saving directories in ',ANALYNAME,'.mat'])
     
     if DPCPX
         Dir=PathForExperimentsKB('DPCPX');
     elseif LPS,
         Dir=PathForExperimentsKB('LPS');   
     elseif BASAL
         Dir=PathForExperimentsKB('BASAL');
     end
    
    % manipe to include
    numDir=1:length(Dir.path);
    
    save([ANALYNAME,'.mat'],'Dir','numDir','-append')
end



%% Spectre in BO - PFC - PA - HPC

disp(' ')
disp('... Calculating Spectrum for all experiments in Dir')

IntPlot=intervalSet(0,30*1E4);


try
    load([res,'\',ANALYNAME,'.mat']);  
    
    for ll=1:length(nameSpectre)
        eval(['AllSpectro',nameSp{ll},'{1,1}(1); AllGroup',nameSp{ll},'{1,1}(1); AllSpectroNorm',nameSp{ll},'{1,1}(1);']);
    end
    
catch
    
    % initiation of figures and temp variables for all experiments
    for ll=1:length(nameSpectre)
        if ploSpectrEpoch, 
            figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]); FSpecAll{ll}=gcf;
        end
        
        figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FfreqLFP{ll}=gcf;
        for nn=1:length(NameEpochs), for inj=1:length(InjName), Temp{nn,inj}=[];end;end
        TempSp{ll}=Temp; TempGp{ll}=Temp; TempSpNorm{ll}=Temp;
    end
    
    
    % adding spectro for each experiment
    for man=numDir
        
        clear listLFP LFP SpBO SpPFC SpPA SpHPC SpACx SpATh nameMan
        clear SWSEpoch REMEpoch MovEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch SuperThetaEpoch ThetaEpoch
        clear PreEpoch VEHEpoch DPCPXEpoch LPSEpoch H24Epoch H48Epoch PreVEHEpoch PreLPSEpoch
        
        nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21);
        disp(' ')
        disp(['           * * * ',nameMan,' * * *'])
        fprintf(file,'%s\n','  ');fprintf(file,'%s\n',['* * * * *  Manipe ',Dir.manipe{man},', ',nameMan,'  * * * * *']);
        
        
        % EPOCHS
        % -------------
        load([Dir.path{man},'\StateEpoch.mat'],'SWSEpoch','REMEpoch','MovEpoch','SuperThetaEpoch','ThetaEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
        %try Start(SuperThetaEpoch); catch, run('/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/AnalyseBOold/SuperTheta.m'); end
        
        fprintf(file,'%s\n','  '); fprintf(file,'%s\n',[' SWS=',num2str(floor(sum(Stop(SWSEpoch)-Start(SWSEpoch))/1E4)),'s, REM=',num2str(floor(sum(Stop(REMEpoch)-Start(REMEpoch))/1E4)),'s, Wake=',num2str(floor(sum(Stop(MovEpoch)-Start(MovEpoch))/1E4)),'s']);
        if DPCPX
            load([Dir.path{man},'\behavResources.mat'],'PreEpoch','VEHEpoch','DPCPXEpoch');
        elseif LPS
            load([Dir.path{man},'\behavResources.mat'],'PreEpoch','VEHEpoch','LPSEpoch','H24Epoch','H48Epoch');
            if exist('PreEpoch','var') && exist('VEHEpoch','var'), PreVEHEpoch=PreEpoch;
            elseif exist('PreEpoch','var') && exist('LPSEpoch','var'), PreLPSEpoch=PreEpoch;
            end
        elseif BASAL 
            load([Dir.path{man},'\behavResources.mat'],'PreEpoch');
        end
        for inj=1:length(InjName)
            if exist([InjName{inj},'Epoch'],'var')==0, eval([InjName{inj},'Epoch=intervalSet([],[]);']);end
        end
        if exist('WeirdNoiseEpoch','var')==0, WeirdNoiseEpoch=intervalSet([],[]);end
        % -------------
        
        
        load([Dir.path{man},'\listLFP.mat'],'listLFP')
        
        for ll=1:length(nameSpectre)
            disp(['         - LFP',nameSpectre{ll}])
            
            clear Spi ti fi channel LFP info SaveSp SaveSpgroup SaveSpNorm
            SaveSp=TempSp{ll}; SaveSpgroup=TempGp{ll}; SaveSpNorm=TempSpNorm{ll};
            
            
            
            if sum(strcmp(listLFP.name,nameSpectre{ll}))~=0
                
                % ------------------------------------------------------
                % -------------- ComputeSpectrogramML ------------------
                % calculate Sp for all LFP
                load([Dir.path{man},'\LFP',nameSpectre{ll},'.mat'],'LFP','info')
                [Spi,ti,fi,channelToAnalyse]=ComputeSpectrogramML(LFP,movingwin,params,[res,'\',nameMan,'.mat'],[nameSpectre(ll),nameSp(ll)],info);
                % ------------------------------------------------------
                % ------------------------------------------------------ 
                
                if CorrectionAmplifier
                    Spi=Dir.CorrecAmpli(man)*Spi;
                end
                
                % ----------------------------
                % Spectro for each epoch
                
                for nn=1:length(NameEpochs)
                    if sum(strcmp(NameEpochs{nn},'SuperThetaMovEpoch')), ThetaMovEpoch=and(MovEpoch,SuperThetaEpoch);end
                    if sum(strcmp(NameEpochs{nn},'ThetaMovEpoch')), ThetaMovEpoch=and(MovEpoch,ThetaEpoch);end
                    
                    if ll==1, fprintf(file,'%s\n','  ');fprintf(file,'%s\n',['         -',NameEpochs{nn},' ']);end
                    
                    for inj=1:length(InjName)
                        clear epoch tEpoch SpEpoch epoch tempSave
                        
                        % -- epochs injection and states --
                        if RemoveNoisyEpochs, eval(['epoch=and(',NameEpochs{nn},',',InjName{inj},'Epoch)-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;']);
                        else eval(['epoch=and(',NameEpochs{nn},',',InjName{inj},'Epoch);']);
                        end
                        
                        if ll==1, SaveEpochs{nn,inj}=epoch; end
                        
                        eval(['aa=isempty(Start(',InjName{inj},'Epoch));'])
                        if ll==1 && aa==0, fprintf(file,'%s\n',['          ',InjName{inj},': ',num2str(floor(sum(Stop(epoch,'s')-Start(epoch,'s')))),'s']);end
                       
                        % ------------------------------------------------
                        % ------------------------------------------------
                        % ---------------- SpectroEpochML ----------------
                       % keyboard
                        [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,fi,epoch);
                        % ------------------------------------------------
                        % ------------------------------------------------
                        
                        if ploSpectrEpoch,
                            figure(FSpecAll{ll}), subplot(length(NameEpochs),length(numDir),(nn-1)*length(numDir)+find(numDir==man)),
                            hold on, imagesc(tEpoch,fi,10*log10(SpEpoch)'); axis xy;
                            title(nameSpectre{ll})
                            ylabel(NameEpochs{nn}(1:strfind(NameEpochs{nn},'Epoch')-1))
                            xlabel([Dir.group{man},'.',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:strfind(Dir.path{man},'Mouse')+7)])
                        end
                        
                        figure(FfreqLFP{ll}), subplot(length(NameEpochs),length(numDir),(nn-1)*length(numDir)+find(numDir==man)),
                        hold on, plot(fi,mean(SpEpoch,1),'color',colori{inj},'linewidth',2)
                        if man==numDir(1), ylabel([nameSpectre{ll},' - ',NameEpochs{nn}]);end
                        xlabel([Dir.group{man},'.',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:strfind(Dir.path{man},'Mouse')+7)])
                        
                        if isempty(Start(epoch))==0
                            tempSave=SaveSp{nn,inj};
                            SaveSp{nn,inj}=[tempSave;mean(SpEpoch,1)];
                            tempSave=SaveSpNorm{nn,inj};
                            SaveSpNorm{nn,inj}=[tempSave;mean(SpEpoch,1).*fi];
                            
                            tempSave=SaveSpgroup{nn,inj};
                            SaveSpgroup{nn,inj}=[tempSave;{Dir.group{man} Dir.name{man}}];
                            
                            TempSp{ll}=SaveSp; TempGp{ll}=SaveSpgroup; TempSpNorm{ll}=SaveSpNorm;
                        end
                    end
                end
                
            else
                disp(['no LFP ',nameSpectre{ll},', skipping this step'])
            end
        end
        
        AllEpochs{man}=SaveEpochs;
    end
    
    for ll=1:length(nameSpectre)
        % display
        figure(FfreqLFP{ll}); legend(InjName)
        for i=1:length(NameEpochs)*length(numDir), subplot(length(NameEpochs),length(numDir),i), ylim([0 6E5]); end
        
        % saving all spectro for each structure
        eval(['AllSpectro',nameSp{ll},'=TempSp{ll};']);
        eval(['AllSpectroNorm',nameSp{ll},'=TempSpNorm{ll};']);
        eval(['AllGroup',nameSp{ll},'=TempGp{ll};']);
        save([res,'\',ANALYNAME,'.mat'],['AllSpectro',nameSp{ll}],['AllSpectroNorm',nameSp{ll}],['AllGroup',nameSp{ll}],'AllEpochs','fi','-append');
    end
    
    
end


%% display mean Spectro pooled for dKO vs WT

Ugroup=unique(Dir.group);
Uname=unique(Dir.name(numDir));
pval=0.01;

if LPS, 
    figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), 
    FfVehLpsC57pool=gcf;
end


if ploFreqSpec
    
    for ll=1:length(nameSpectre)
        clear SaveSpgroup SaveSp SaveSpNorm
        eval(['SaveSpgroup=AllGroup',nameSp{ll},'; SaveSp=AllSpectro',nameSp{ll},'; SaveSpNorm=AllSpectroNorm',nameSp{ll},';']);
        
        % Creating figures
        if ploStrainEffect
            figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), Ffpoolst(ll)=gcf;
            figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FfNormpoolst(ll)=gcf;
            figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), Ffpoolstratio{ll}=gcf;
            if BASAL, 
                for gg=1:length(Ugroup), figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FfSinglepoolst{gg,ll}=gcf;end;
            end
        end
        
        if ploSingleSpectr, 
            for gg=1:length(Uname),
                figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), 
                Ffsingle{gg,ll}=gcf;
            end
        end
        
        figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), Ffpool{ll}=gcf;
        if LPS
            figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FfVehLpsC57{ll}=gcf
            figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FfVehLpsdKO{ll}=gcf;
        end
        
        for nn=1:length(NameEpochs)
            
            legPool=[]; for gg=1:length(Uname), leg{gg}=[]; end
            
            
            % normalized spectrum VEH vs LPS
            if LPS
                nameVsVEH={'VEH','LPS','H24','H48'};
                a=1;b=1;for i=1:3, tempPoolC57{i}=[];end
                Llegend1=[];
                for gg=1:length(Uname)
                    Llegend=[]; LlegenddKO=[];
                    clear SpfNormVEH SpfNormLPS SpfNormH24
                    for i=1:length(nameVsVEH), SpfNorm{i}=SaveSpNorm{nn,strcmp(InjName,nameVsVEH{i})}(strcmp(SaveSpgroup{nn,strcmp(InjName,nameVsVEH{i})}(:,2),Uname{gg}),:);end
                    
                    if strcmp(SaveSpgroup{nn,strcmp(InjName,'VEH')}(strcmp(SaveSpgroup{nn,strcmp(InjName,'VEH')}(:,2),Uname{gg}),1),'C57')
                        figure(FfVehLpsC57{ll}),subplot(3,length(NameEpochs),(a-1)*length(NameEpochs)+nn)
                        for i=1:length(nameVsVEH)-1
                            try hold on, plot(fi,log10(SpfNorm{i+1}./SpfNorm{1}),'linewidth',2,'color',colori{i});
                                Llegend=[Llegend, nameVsVEH(i+1)]; tempPoolC57{i}=[tempPoolC57{i};log10(SpfNorm{i+1}./SpfNorm{1})];
                            end
                        end
                        title(['C57 ',Uname{gg}(end-2:end),' (normalized by VEH)']);a=a+1;
                        line([0 20],[0 0],'color',[0.7 0.7 0.7]);legend(Llegend);
                    else
                        figure(FfVehLpsdKO{ll}),subplot(3,length(NameEpochs),(b-1)*length(NameEpochs)+nn)
                        for i=1:length(nameVsVEH)-1
                            try hold on, plot(fi,log10(SpfNorm{i+1}./SpfNorm{1}),'linewidth',2,'color',colori{i}); 
                                LlegenddKO=[LlegenddKO, nameVsVEH(i+1)];
                            end
                        end
                        title([SaveSpgroup{nn,strcmp(InjName,'VEH')}{strcmp(SaveSpgroup{nn,strcmp(InjName,'VEH')}(:,2),Uname{gg}),1},Uname{gg}(end-2:end),' (normalized by VEH)']);b=b+1;
                        line([0 20],[0 0],'color',[0.7 0.7 0.7]); legend(LlegenddKO);
                    end
                    ylabel([nameSpectre{ll},' -',NameEpochs{nn}])
                    
                end
                figure(FfVehLpsC57pool), subplot(length(NameEpochs),length(nameSpectre),(nn-1)*length(nameSpectre)+ll),
                for i=1:3
                    [l,L]=size(tempPoolC57{i});
                    hold on, plot(fi,mean(tempPoolC57{i},1),'linewidth',2,'color',colori{i}); Llegend1=[Llegend1,{[nameVsVEH{i+1},' (n=',num2str(l),')']}];
                    if l>2
                        hold on, plot(fi,mean(tempPoolC57{i},1)+stdError(tempPoolC57{i}),'color',colori{i});Llegend1=[Llegend1,'+std'];
                        hold on, plot(fi,mean(tempPoolC57{i},1)-stdError(tempPoolC57{i}),'color',colori{i});Llegend1=[Llegend1,'-std'];
                    end
                end
                line([0 20],[0 0],'color',[0.7 0.7 0.7]); legend(Llegend1)
                title([nameSpectre{ll},' (normalized by VEH)']), ylabel(NameEpochs{nn})
            end
            
            
            for inj=1:length(InjName)
                
                legst=[];
                clear Spf SpfNorm Spgroup
                
                for uu=1:length(Uname)
                    clear Manuu Spfstd SpfNormstd
                    Manuu=strcmp(SaveSpgroup{nn,inj}(:,2),Uname{uu});
                    
                    Spf(uu,:)=mean(SaveSp{nn,inj}(Manuu,:),1);
                    Spfstd=stdError(SaveSp{nn,inj}(Manuu,:));
                    
                    SpfNorm(uu,:)=mean(SaveSpNorm{nn,inj}(Manuu,:),1);
                    SpfNormstd=stdError(SaveSpNorm{nn,inj}(Manuu,:));
                    
                    Spgroup(uu,1)=unique(SaveSpgroup{nn,inj}(Manuu,1));
                    
                    if ploSingleSpectr && ((LPS && sum(strcmp(InjName{inj},restrictInj))) || (DPCPX && sum(strcmp(InjName{inj},restrictInj))) || (DPCPX && sum(strcmp(InjName{inj},{'VEH','DPCPX'}))))
                        
                        figure(Ffsingle{uu,ll});
                        % not normalized spectrum
                        subplot(2,length(NameEpochs),nn)
                        hold on, plot(fi,Spf(uu,:),'linewidth',2,'color',colori{inj});
                        leg{uu}=[leg{uu},{[InjName{inj},' (n=',num2str(sum(Manuu)),')']}];
                        ylabel([nameSpectre{ll},' -',NameEpochs{nn}]),
                        title(Uname{uu})
                        
                        % normalized spectrum
                        subplot(2,length(NameEpochs),length(NameEpochs)+nn)
                        hold on, plot(fi,SpfNorm(uu,:),'linewidth',2,'color',colori{inj});
                        ylabel([nameSpectre{ll},' -',NameEpochs{nn}])
                        title([Uname{uu},' (normalized)']);
                    end
                end
                
                for gg=1:length(Ugroup)
                    clear Mangg 
                    Mangg=strcmp(Spgroup,Ugroup{gg});
                    SpfTemp{gg}=Spf(Mangg,:);
                    if ploStrainEffect
                        % plot spectrum of the different strains
                        figure(Ffpoolst(ll)), subplot(length(InjName),length(NameEpochs),(inj-1)*length(NameEpochs)+nn)
                        hold on, plot(fi,mean(Spf(Mangg,:),1),'linewidth',2,'color',colori{gg}); 
                        legst=[legst,{[Ugroup{gg},' (n=',num2str(size(Spf(Mangg,:),1)),')']}];
                        if size(Spf(Mangg,:),1)>1,
                            hold on, plot(fi,mean(Spf(Mangg,:),1)+stdError(Spf(Mangg,:)),'color',colori{gg});
                            hold on, plot(fi,mean(Spf(Mangg,:),1)-stdError(Spf(Mangg,:)),'color',colori{gg});
                            legst=[legst,'+std','-std'];
                        end
                        
                        % plot normalized spectrum of the different strains
                        figure(FfNormpoolst(ll)), subplot(length(InjName),length(NameEpochs),(inj-1)*length(NameEpochs)+nn)
                        hold on, plot(fi,mean(SpfNorm(Mangg,:),1),'linewidth',2,'color',colori{gg});
                        if size(Spf(Mangg,:),1)>1,
                            hold on, plot(fi,mean(SpfNorm(Mangg,:),1)+stdError(SpfNorm(Mangg,:)),'color',colori{gg});
                            hold on, plot(fi,mean(SpfNorm(Mangg,:),1)-stdError(SpfNorm(Mangg,:)),'color',colori{gg});
                        end
                        

                    end
                    
                    % plot spectrum of different injection epochs

                    
                    if ploRecoverStatSpectr
                        
                        XlimSpec=[0,2;2,5;6,9;10,15];
                        if inj==1 && strcmp(Ugroup{gg},StrainTOpool)
                            
                            
                            for iiinj=1:length(InjName)
                                SpStat{iiinj}=SaveSp{nn,iiinj}(strcmp(SaveSpgroup{nn,iiinj}(:,1),Ugroup{gg}),:);
                                SpNormStat{iiinj}=SaveSpNorm{nn,iiinj}(strcmp(SaveSpgroup{nn,iiinj}(:,1),Ugroup{gg}),:);
                            end
                            for xx=1:size(XlimSpec,1)
                                SpStatXx{xx}=[];
                                for iiinj=1:length(InjName)
                                    SpStatXx{xx}=[SpStatXx{xx} {mean(SpStat{iiinj}(:,fi>XlimSpec(xx,1) & fi<XlimSpec(xx,2)),2)}];
                                end
                            end
                            
                            
                            % ---------------------------------------
                            % -------- not normalized spectrum ------
                            figure(Ffpool{ll}), subplot(2,length(NameEpochs),nn)
                            SpVEH=SpStat{strcmp(InjName,'VEH')};
                            SpLPS=SpStat{strcmp(InjName,'LPS')};
                            SpRECOVER=[SpStat{strcmp(InjName,'H24')};SpStat{strcmp(InjName,'H48')}];
                            
                            hold on, plot(fi,mean(SpVEH,1),'linewidth',2,'color','r');
                            hold on, plot(fi,mean(SpLPS,1),'linewidth',2,'color','k');
                            hold on, plot(fi,mean(SpRECOVER,1),'linewidth',2,'color','g');
                            
                            lVEH=size(SpVEH); lLPS=size(SpLPS); lRECOVER=size(SpRECOVER);
                            legend(['VEH (n=',num2str(lVEH(1)),')'],['LPS (n=',num2str(lLPS(1)),')'],['RECOVER (n=',num2str(lRECOVER(1)),')'])
                            
                            if lVEH(1)>1, hold on, plot(fi,mean(SpVEH,1)+stdError(SpVEH),'color','r'); plot(fi,mean(SpVEH,1)-stdError(SpVEH),'color','r'); end
                            if lLPS(1)>1, hold on, plot(fi,mean(SpLPS,1)+stdError(SpLPS),'color','k'); plot(fi,mean(SpLPS,1)-stdError(SpLPS),'color','k'); end
                            if lRECOVER(1)>1, hold on, plot(fi,mean(SpRECOVER,1)+stdError(SpRECOVER),'color','g'); plot(fi,mean(SpRECOVER,1)-stdError(SpRECOVER),'color','g'); end
                            
                            if lVEH(1)>1 && lLPS(1)>1, [H,p]=ttest2(SpVEH,SpLPS); plot(fi(p<pval),zeros(length(p(p<pval))),'r.');end
                            if lLPS(1)>1 && lRECOVER(1)>1, [H,p]=ttest2(SpLPS,SpRECOVER); plot(fi(p<pval),zeros(length(p(p<pval)))+4E4,'g.');end
                            
                            ylabel(NameEpochs{nn})
                            title([Ugroup{gg},' -',nameSpectre{ll}])
                            
                            % -------- ANOVA sur XlimSpec ------
                            if SaveFig, try, nameFolderSave; catch, nameFolderSave=input('     * Enter Folder where figures should be saved: ','s');end;end
                            disp(NameEpochs{nn})
                            fprintf(file,'%s\n',' ');fprintf(file,'%s\n',' ');
                            fprintf(file,'%s\n',['* * * ',NameEpochs{nn},' - Stats LFP ',nameSpectre{ll},' * * *']);
                            for xx=1:size(XlimSpec,1)
                                [p,t,st,Pt,group]=CalculANOVAmultipleOneway(SpStatXx{xx}); FfpoolStatTemp(xx)=gcf;
                                figure(FfpoolStatTemp(xx)), title([NameEpochs{nn},'   * LFP ',nameSpectre{ll},' *   ',num2str(XlimSpec(xx,1)),'-',num2str(XlimSpec(xx,2)),'Hz']);
                                ylabel(['Power of frequency band ',num2str(XlimSpec(xx,1)),'-',num2str(XlimSpec(xx,2)),'Hz']); set(gca,'xtick',1:length(InjName));set(gca,'xticklabel',InjName);
                                saveFigure(FfpoolStatTemp(xx),['C57Pool_',nameSpectre{ll},'Amp_',num2str(XlimSpec(xx,1)),'-',num2str(XlimSpec(xx,2)),'Hz_',NameEpochs{nn}(1:end-5)],[res,'\',nameFolderSave]); close
                                
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
                            
                            % ---------------------------------------
                            % --------- normalized spectrum ---------
                            figure(Ffpool{ll}), subplot(2,length(NameEpochs),length(NameEpochs)+nn)
                            SpNormVEH=SpNormStat{strcmp(InjName,'VEH')};
                            SpNormLPS=SpNormStat{strcmp(InjName,'LPS')};
                            SpNormRECOVER=[SpNormStat{strcmp(InjName,'H24')};SpStat{strcmp(InjName,'H48')}];
                            
                            hold on, plot(fi,mean(SpNormVEH,1),'linewidth',2,'color','r');
                            hold on, plot(fi,mean(SpNormLPS,1),'linewidth',2,'color','k');
                            hold on, plot(fi,mean(SpNormRECOVER,1),'linewidth',2,'color','g');
                            
                            lVEH=size(SpNormVEH); lLPS=size(SpNormLPS); lRECOVER=size(SpNormRECOVER);
                            legend(['VEH (n=',num2str(lVEH(1)),')'],['LPS (n=',num2str(lLPS(1)),')'],['RECOVER (n=',num2str(lRECOVER(1)),')'])
                            
                            if lVEH(1)>1, hold on, plot(fi,mean(SpNormVEH,1)+stdError(SpNormVEH),'color','r'); plot(fi,mean(SpNormVEH,1)-stdError(SpNormVEH),'color','r'); end
                            if lLPS(1)>1, hold on, plot(fi,mean(SpNormLPS,1)+stdError(SpNormLPS),'color','k'); plot(fi,mean(SpNormLPS,1)-stdError(SpNormLPS),'color','k'); end
                            if lRECOVER(1)>1, hold on, plot(fi,mean(SpNormRECOVER,1)+stdError(SpNormRECOVER),'color','g'); plot(fi,mean(SpNormRECOVER,1)-stdError(SpNormRECOVER),'color','g'); end
                            %
                            if lVEH(1)>1 && lLPS(1)>1, [H,p]=ttest2(SpNormVEH,SpNormLPS); plot(fi(p<pval),zeros(length(p(p<pval))),'r.');end
                            if lLPS(1)>1 && lRECOVER(1)>1, [H,p]=ttest2(SpNormRECOVER,SpNormLPS); plot(fi(p<pval),zeros(length(p(p<pval)))+4E4,'g.');end
                            
                            try disp(['length(p(p<',num2str(pval),'))=',num2str(length(p(p<pval)))]);end
                            ylabel(NameEpochs{nn})
                            title([Ugroup{gg},' -(norm 1/f)',nameSpectre{ll}])
                            
                        end
                    else
                        
                        if sum(strcmp(InjName{inj},restrictInj)) && strcmp(Ugroup{gg},StrainTOpool)
                            figure(Ffpool{ll}),
                            % not normalized spectrum
                            subplot(2,length(NameEpochs),nn)
                            hold on, plot(fi,mean(Spf(Mangg,:),1),'linewidth',2,'color',colori{inj});
                            legPool=[legPool,{[InjName{inj},' (n=',num2str(sum(Mangg)),')']}];
                            if sum(Mangg)>1,
                                hold on, plot(fi,mean(Spf(Mangg,:),1)+Spfstd,'color',colori{inj});
                                hold on, plot(fi,mean(Spf(Mangg,:),1)-Spfstd,'color',colori{inj});
                                legPool=[legPool,'+std','-std'];
                            end
                            ylabel(NameEpochs{nn})
                            title([Ugroup{gg},' -',nameSpectre{ll}])
                            
                            % normalized spectrum
                            subplot(2,length(NameEpochs),length(NameEpochs)+nn)
                            hold on, plot(fi,mean(SpfNorm(Mangg,:),1),'linewidth',2,'color',colori{inj});
                            if sum(Mangg)>1,
                                hold on, plot(fi,mean(SpfNorm(Mangg,:),1)+SpfNormstd,'color',colori{inj});
                                hold on, plot(fi,mean(SpfNorm(Mangg,:),1)-SpfNormstd,'color',colori{inj});
                            end
                            ylabel(NameEpochs{nn})
                            title([Ugroup{gg},' -',nameSpectre{ll},' (normalized)'])
                        end
                    end
                    
                end
                if ploStrainEffect
                    figure(Ffpoolst(ll)),
                    ylabel(nameSpectre{ll});
                    title([NameEpochs{nn},' -',InjName{inj}])
                    
                    if size(SpfTemp{1},1)>1 && size(SpfTemp{2},1)>1
                        [H,p]=ttest2(SpfTemp{1},SpfTemp{2});
                        hold on, plot(fi(p<pval),ones(length(p(p<pval))),'g.');
                    end
                    legend([legst,{['pvalue < ',num2str(pval)]}]); 
                    
                    figure(FfNormpoolst(ll)),
                    legend(legst), ylabel([nameSpectre{ll},' (Normalized by 1/f)'])
                    title([NameEpochs{nn},' -',InjName{inj}]);
                   
%                     figure(Ffpoolstratio{ll}), subplot(length(InjName),length(NameEpochs),(inj-1)*length(NameEpochs)+nn), 
%                     plot(fi,mean(Spf{1},1)./mean(Spf{2},1),'linewidth',2); ylim([0 10]);
%                     if size(SpfNorm{1},1)>1 && size(SpfNorm{2},1)>1, 
%                         [H,p]=ttest2(SpfNorm{1},SpfNorm{2}); 
%                         hold on, plot(fi(p<pval),ones(length(p(p<pval))),'g.');
%                     end
%                     ylabel(nameSpectre{ll}); title([NameEpochs{nn},' -',InjName{inj}]);

                end
                    
            end
            if ploSingleSpectr, for gg=1:length(Uname), figure(Ffsingle{gg,ll}), legend(leg{gg});end;end
            if ploRecoverStatSpectr==0, figure(Ffpool{ll}), legend(legPool);end
        end
    end
end




%% ratio sleep

if ploSleep
    
    figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), Fepochs=gcf;
    figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), Fepochspool=gcf;
    Injindex=[]; for i=1:length(restrictInj), Injindex=[Injindex,find(strcmp(InjName,restrictInj(i)))];end
    
    for man=1:length(Dir.path), 
        for inj=1:length(InjName), 
            RatioRemSws(man,inj)=NaN; 
            Qrem(man,inj)=NaN; 
            Qsws(man,inj)=NaN; 
            Qsleep(man,inj)=NaN; 
        end
    end
    
    
    for man=numDir
        
        
        SaveEpochs=AllEpochs{man};
        
        for i=1:length(InjName)
            clear Irem Isws Iwake
            Irem=SaveEpochs{strcmp(NameEpochs,'REMEpoch'),i};
            Isws=SaveEpochs{strcmp(NameEpochs,'SWSEpoch'),i};
            Iwake=SaveEpochs{strcmp(NameEpochs,'MovEpoch'),i};
            
            if sum(Stop(Irem,'s')-Start(Irem,'s'))+sum(Stop(Isws,'s')-Start(Isws,'s'))+sum(Stop(Iwake,'s')-Start(Iwake,'s')) ~=0
                RatioRemSws(man,i)=sum(Stop(Irem,'s')-Start(Irem,'s'))/sum(Stop(Isws,'s')-Start(Isws,'s'));
                Qsleep(man,i)=(sum(Stop(Irem,'s')-Start(Irem,'s'))+sum(Stop(Isws,'s')-Start(Isws,'s')))/(sum(Stop(Irem,'s')-Start(Irem,'s'))+sum(Stop(Isws,'s')-Start(Isws,'s'))+sum(Stop(Iwake,'s')-Start(Iwake,'s')))*100;
                
                if QremTpsTotal
                    Qrem(man,i)=sum(Stop(Irem,'s')-Start(Irem,'s'))/(sum(Stop(Irem,'s')-Start(Irem,'s'))+sum(Stop(Isws,'s')-Start(Isws,'s'))+sum(Stop(Iwake,'s')-Start(Iwake,'s')))*100;
                    Qsws(man,i)=sum(Stop(Isws,'s')-Start(Isws,'s'))/(sum(Stop(Irem,'s')-Start(Irem,'s'))+sum(Stop(Isws,'s')-Start(Isws,'s'))+sum(Stop(Iwake,'s')-Start(Iwake,'s')))*100;
                else
                    Qrem(man,i)=sum(Stop(Irem,'s')-Start(Irem,'s'))/(sum(Stop(Irem,'s')-Start(Irem,'s'))+sum(Stop(Isws,'s')-Start(Isws,'s')))*100;
                    Qsws(man,i)=sum(Stop(Isws,'s')-Start(Isws,'s'))/(sum(Stop(Irem,'s')-Start(Irem,'s'))+sum(Stop(Isws,'s')-Start(Isws,'s')))*100;
                end
            end
        end
    end
    
    [I,J]=find(isnan(Qsleep)==0); A=Qsleep(isnan(Qsleep)==0); A(:,2)=J;
    for i=1:length(A(:,2)), A(i,3)=find(strcmp(Dir.group(I(i)),Ugroup)); A(i,4)=find(strcmp(Dir.name(I(i)),Uname));end
    All{1}=A; % value / injection / strain / Mouse
    [I,J]=find(isnan(Qrem)==0); A=Qrem(isnan(Qrem)==0); A(:,2)=J;
    for i=1:length(A(:,2)), A(i,3)=find(strcmp(Dir.group(I(i)),Ugroup));A(i,4)=find(strcmp(Dir.name(I(i)),Uname)); end
    All{2}=A;
    [I,J]=find(isnan(Qsws)==0); A=Qsws(isnan(Qsws)==0); A(:,2)=J;
    for i=1:length(A(:,2)), A(i,3)=find(strcmp(Dir.group(I(i)),Ugroup));A(i,4)=find(strcmp(Dir.name(I(i)),Uname));end
    All{3}=A;
    [I,J]=find(isnan(RatioRemSws)==0); A=RatioRemSws(isnan(RatioRemSws)==0); A(:,2)=J;
    for i=1:length(A(:,2)), A(i,3)=find(strcmp(Dir.group(I(i)),Ugroup));A(i,4)=find(strcmp(Dir.name(I(i)),Uname));end
    All{4}=A;
    
    if QremTpsTotal
        Ttitle={'% Sleep on total recording','% REM on total recording','% SWS on total recording','REM / SWS'};
        Ttitleshort={'PercentageSleep','PercentageREMonSleep','PercentageSWSonSleep','rationREMvsSWS'};
    else
        Ttitle={'% Sleep on total recording','% REM on total sleep','% SWS on total sleep','REM / SWS'};
        Ttitleshort={'PercentageSleep','PercentageREMonSleep','PercentageSWSonSleep','rationREMvsSWS'};
    end
    
    yyy=[100 30 120 0.4];
    for gg=1:length(Uname)
        for i=1:4
            clear A
            figure(Fepochs), subplot(4,length(Uname),(i-1)*length(Uname)+gg)
            A=find(All{i}(:,4)==gg & ismember(All{i}(:,2),Injindex));
            bar(All{i}(A,1));l=length(All{i}(A,1));
            set(gca,'xtick',1:l); xlim([0 l+1])
            ylabel(Ttitle{i}); title(Uname{gg}); a=ylim;
            set(gca,'xticklabel',InjName(All{i}(A,2)))
        end
    end
    
    
    for inj=Injindex
        for i=1:4
            Bartemp(i,Injindex==inj)=mean(All{i}(All{i}(:,2)==inj,1));
            BartempStd(i,Injindex==inj)=stdError(All{i}(All{i}(:,2)==inj,1));
            Nn(i,Injindex==inj)=length(All{i}(All{i}(:,2)==inj,1));
        end
    end
    
    disp('... Creating Stats.txt')
    file=fopen('Stats','w'); Date=date;
    fprintf(file,'%s\n',['* * * * * * Analyse of ',Date,' * * * * * * ']);fprintf(file,'%s\n','  ');
    
    clear ANOV
    for i=1:4
        figure(Fepochspool); subplot(4,1,i),bar(Bartemp(i,:))
        hold on, errorbar(1:length(Bartemp(i,:)),Bartemp(i,:),BartempStd(i,:),'+','color','k')
        set(gca,'xtick',[1:length(Bartemp(i,:))]); ylabel(Ttitle{i})
        set(gca,'xticklabel',InjName(Injindex)); title(['(n=',num2str(Nn(i,:)),')'])
        compt=0;
        for gg=1:length(Ugroup), %factor 2 = strain
            a=1; clear A
            for inj=Injindex, %factor 1 = injection day
                if length(All{i}(All{i}(:,2)==inj & All{i}(:,3)==gg ,1))<2, a=0; end
                A{Injindex==inj}=All{i}(All{i}(:,2)==inj & All{i}(:,3)==gg ,1);
            end
            if a, compt=compt+1; ANOV{compt}=A; ANOVgroup{compt}=Ugroup{gg}; end
        end
        
        if length(ANOV)>1,
            [p,t,st,Pt1,Pt2,Pt3,group]=CalculANOVAmultipleTwoway(ANOV{:});
            title(Ttitle{i}); set(gca,'xtick',1:length(Injindex));set(gca,'xticklabel',InjName(Injindex));
            disp(Ttitle{i});
            disp('Factor injection day:');disp(Pt1);
            disp('Factor strain:');disp(Pt2);
            disp('Factor injection day x Factor strain:');disp(Pt3);
        else
            [p,t,st,Pt,group]=CalculANOVAmultipleOneway(ANOV{1});
            title(['Strain ',ANOVgroup{1}]); ylabel(Ttitle{i});set(gca,'xtick',1:length(Injindex));set(gca,'xticklabel',InjName(Injindex));
            FepochspoolStat{i}=gcf;
            
            disp(Ttitle{i});disp(Pt);
            fprintf(file,'%s\n',['Strain ',ANOVgroup{1}]);
            fprintf(file,'%s\n','  ');fprintf(file,'%s\n',Ttitle{i});
            for j=1:length(Injindex), fprintf(file,'%s\n',' '); for ii=1:length(Injindex)-1, fprintf(file,'%6.3f',Pt{ii,j});end;end
            fprintf(file,'%s\n','  ');
            for ii=1:length(Injindex)-1,
                for j=1:length(Injindex),
                    if Pt{ii,j}<0.05,
                        disp([InjName{Injindex(ii)},' vs ',InjName{Injindex(j)},': p=',num2str(Pt{ii,j})]);
                        fprintf(file,'%s\n',[InjName{Injindex(ii)},' vs ',InjName{Injindex(j)},': p=',num2str(Pt{ii,j})]);
                    end
                end
            end
            
        end
    end
end


%% Save figures
if ploFreqSpec
    for ll=1:length(nameSpectre)
        if ploSingleSpectr
            % Ffsingle
            Y1=[]; Y2=[];
            for gg=1:length(Uname),
                figure(Ffsingle{gg,ll})
                for i=1:3, subplot(2,3,i), y=ylim; Y1=[Y1 y(2)];end
                for i=4:6, subplot(2,3,i), y=ylim; Y2=[Y2 y(2)];end
            end
            for i=1:3, Ylim{ll,i}=max(Y1);end
            for i=4:6, Ylim{ll,i}=max(Y2);end
        end
        
        % Ffpool
        
        figure(Ffpool{ll}),
        Y1=[]; for i=1:3, subplot(2,3,i), y=ylim; Y1=[Y1 y(2)];end
        Y2=[]; for i=4:6, subplot(2,3,i), y=ylim; Y2=[Y2 y(2)];end
        for i=1:3, subplot(2,3,i), ylim([0 max(Y1)]);end
        for i=4:6, subplot(2,3,i), ylim([0 max(Y2)]);end

        % Ffpool
        if LPS
            Y1=[];
            figure(FfVehLpsC57{ll}), for i=1:9, subplot(3,3,i), y=ylim; Y1=[Y1 y];end
            figure(FfVehLpsdKO{ll}), for i=1:6, subplot(3,3,i), y=ylim; Y1=[Y1 y];end
            
            figure(FfVehLpsC57{ll}), for i=1:9, subplot(3,3,i), ylim([min(Y1) max(Y1)]);end
            figure(FfVehLpsdKO{ll}), for i=1:6, subplot(3,3,i), ylim([min(Y1) max(Y1)]);end
            
        end
    end
end



if SaveFig
    nameFolderSave=input('     * Enter Folder where figures should be saved: ','s');
    if exist([res,'\',nameFolderSave],'dir')==0, mkdir(res,nameFolderSave);end
    
    if LPS 
        Y2=[]; for i=1:12, subplot(3,4,i),  y=ylim; Y2=[Y2 y]; end
        for i=1:12, subplot(3,4,i), ylim([min(Y2) max(Y2)]); end
        saveFigure(FfVehLpsC57pool,'C57SpectroNormPOOL',[res,'\',nameFolderSave]);
    end
        
    for ll=1:length(nameSpectre)
        if ploFreqSpec
            if LPS
                saveFigure(FfVehLpsC57{ll},'C57SpectroNorm',[res,'\',nameFolderSave]);
                saveFigure(FfVehLpsdKO{ll},'dKOvsWTSpectroNorm',[res,'\',nameFolderSave]);
            end
            if exist('FfreqLFP','var'), saveFigure(FfreqLFP{ll},['Allspectro',nameSpectre{ll}],[res,'\',nameFolderSave]);end
            if ploStrainEffect
                figure(Ffpoolst(ll)),Y=[]; 
                for i=1:length(InjName)*length(NameEpochs), subplot(length(InjName),length(NameEpochs),i), y=ylim; Y=[Y y(2)];end
                for i=1:length(InjName)*length(NameEpochs), subplot(length(InjName),length(NameEpochs),i), ylim([0 max(Y)]);end
                saveFigure(Ffpoolst(ll),['spectroPoolStrain',nameSpectre{ll}],[res,'\',nameFolderSave]);
                
                figure(FfNormpoolst(ll)),Y=[]; 
                for i=1:length(InjName)*length(NameEpochs), subplot(length(InjName),length(NameEpochs),i), y=ylim; Y=[Y y(2)];end
                for i=1:length(InjName)*length(NameEpochs), subplot(length(InjName),length(NameEpochs),i), ylim([0 max(Y)]);end
                saveFigure(FfNormpoolst(ll),['spectroNormPoolStrain',nameSpectre{ll}],[res,'\',nameFolderSave]);
            end
            
            for gg=1:length(Uname),
                if ploSingleSpectr
                    figure(Ffsingle{gg,ll})
                    for i=1:6, subplot(2,3,i), ylim([0 Ylim{ll,i}]);end
                    saveFigure(Ffsingle{gg,ll},[Uname{gg},'Spectro',nameSpectre{ll}],[res,'\',nameFolderSave]);
                end
            end
            
            for gg=1:length(Ugroup),  
                if BASAL
                    figure(FfSinglepoolst{gg,ll}); Y=[];
                    Uname2=unique(SaveSpgroup{nn,inj}(strcmp(SaveSpgroup{nn,inj}(:,1),Ugroup{gg}),2));
                    for i=1:length(Uname2)*length(NameEpochs), subplot(length(NameEpochs),length(Uname2),i), y=ylim;Y=[Y,y(2)];end
                    for i=1:length(Uname2)*length(NameEpochs), subplot(length(NameEpochs),length(Uname2),i), ylim([0 mean(Y)]);end
                end
            end
        
            saveFigure(Ffpool{ll},['Pool',StrainTOpool,'Spectro',nameSpectre{ll}],[res,'\',nameFolderSave]);
        end
    end
    
    
    
    if ploSleep
        if isequal(restrictInj,InjName)==0
            saveFigure(Fepochs,'SleepAll',[res,'\',nameFolderSave]);
            saveFigure(Fepochspool,'Sleeppool',[res,'\',nameFolderSave]);
            for i=1:4, saveFigure(FepochspoolStat{i},['Sleep',ANOVgroup{1},Ttitleshort{i}],[res,'\',nameFolderSave]);end
        else saveFigure(Fepochs,'SleepAllnoPRE',[res,'\',nameFolderSave]);
            saveFigure(Fepochspool,'SleeppoolnoPRE',[res,'\',nameFolderSave]);
            for i=1:4, saveFigure(FepochspoolStat{i},['Sleep',ANOVgroup{1},Ttitleshort{i},'noPRE'],[res,'\',nameFolderSave]);end
        end
    end
    
end
