% CodeBulbAnalyRespiML

%% Inputs
NameEpochs={'ThetaMovEpoch','MovEpoch','SWSEpoch','REMEpoch'};
%NameEpochs={'SWSEpoch','REMEpoch',};
%NameEpochs={'MovEpoch'};

% nameSpectre={'Bulb','PFCx','PaCx','dHPC'};
% nameSp={'BO','PFC','PA','HPC'};
nameSpectre={'Bulb'};
nameSp={'BO'};

if exist('AnalyRespi.mat','file')==2 
    save AnalyRespi NameEpochs -append
else
    save AnalyRespi NameEpochs
end

erasePreviousAnalysis=input('Do you want to erase previous analysis (y/n)? ','s');
if erasePreviousAnalysis=='y', erasePreviousAnalysis=1; else, erasePreviousAnalysis=0; end

ploSpectrEpoch=0;
ploPETH_RespiTrigLFP=0;
res=pwd;
SaveFig=0;


scrsz = get(0,'ScreenSize');

% ------ parameters spectro ------
params.Fs=1000; params.trialave=0;
params.err=[1 0.0500]; params.pad=2;
params.fpass=[0.1 20];
movingwin=[3 0.2]; params.tapers=[3 5];


%% path data to analyse

disp(' ')
load('AnalyRespi.mat','Dir','numDir')
try, Dir.path{1};Dir.group{1};Dir.manipe{1}; numDir; catch, erasePreviousAnalysis=1; end

if erasePreviousAnalysis==0
    disp('... Dir already defined in AnalyRespi.mat, skipping this step')
else
    disp('... Saving directories in AnalyRespi.mat')
    Dir=PathForExperimentsML('PLETHYSMO');

    numDir=1:length(Dir.path);
    save AnalyRespi Dir numDir -append
end
Uname=unique(Dir.name);

%% Determine respi 

disp(' ')
figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]), FallRespiFreq=gcf;
colori={'k','b','r','m'};

try
    load('AnalyRespi.mat','AllRespiAmp','AllRespiFreq','AllRespiSp')
    AllRespiAmp;AllRespiFreq;AllRespiSp;
    if isequal(size(AllRespiAmp),[length(NameEpochs),2]) || isequal(size(AllRespiFreq),[length(NameEpochs),2]) && erasePreviousAnalysis==0
        disp('... Amplitude and Frequency for all experiments in Dir are already defined');
    end
catch
    erasePreviousAnalysis=1;
end
    
if erasePreviousAnalysis
    disp('... Calculating AllRespiAmp and AllRespiFreq in AnalyRespi.mat')
    for nn=1:length(NameEpochs)
        AllRespiAmp{nn,1}=[]; AllRespiAmp{nn,2}=[];
        AllRespiFreq{nn,1}=[]; AllRespiFreq{nn,2}=[];
        AllRespiSp{nn,1}=[]; AllRespiSp{nn,2}=[];
    end
end
f_respi=[0.01:0.02:20];
for man=numDir
    
    disp(['           * * * ',Dir.path{man}(strfind(Dir.path{man},'Mouse'):strfind(Dir.path{man},'Mouse')+7),' * * *'])
    
    % load respi values
    clear RespiTSD Frequency TidalVolume
    load([Dir.path{man},'/LFPData.mat'],'RespiTSD','Frequency','TidalVolume')
    
    
    % load epochs
    clear SWSEpoch REMepoch MovEpoch ThetaMovEpoch ThetaEpoch
    for nn=1:length(NameEpochs)
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

    end
    
    % pool all spectro
    for nn=1:length(NameEpochs)
        
        clear fEpoch SpEpoch
        eval(['epoch=',NameEpochs{nn},';'])
        
        
        % -- Analyse frequency --
        tempData=Data(Restrict(Frequency,epoch));
        [SpEpoch,fEpoch]=hist(tempData(tempData<20),f_respi);
        tot=sum(SpEpoch);
        SpEpoch=SpEpoch*100/tot;
        
        % display
        figure(FallRespiFreq), subplot(ceil(length(numDir)/5),5,find(numDir==man)),
        hold on, plot(fEpoch,SmoothDec(SpEpoch,10),'color',colori{nn},'linewidth',2)
        title([Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:end)])

        if man==numDir(end), legend(NameEpochs);end
        title([Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:strfind(Dir.path{man},'Mouse')+7)])
        xlabel('Frequencies (Hz)'); ylabel('Distribution of Respiration')
        
        if erasePreviousAnalysis
            % -- tidal volume --
            Amp=Data(Restrict(TidalVolume,epoch));
            if isempty(Start(epoch))==0 && erasePreviousAnalysis
                % -- save --
                if strcmp(Dir.group{man}(1:2),'WT')
                    AllRespiFreq{nn,1}=[AllRespiFreq{nn,1},fEpoch(SmoothDec(SpEpoch,10)==max(SmoothDec(SpEpoch,10)))];
                    AllRespiAmp{nn,1}=[AllRespiAmp{nn,1},mean(Amp)];
                    AllRespiSp{nn,1}=[AllRespiSp{nn,1},SmoothDec(SpEpoch,10)];
                elseif strcmp(Dir.group{man}(1:3),'dKO')
                    AllRespiFreq{nn,2}=[AllRespiFreq{nn,2},fEpoch(SmoothDec(SpEpoch,10)==max(SmoothDec(SpEpoch,10)))];
                    AllRespiAmp{nn,2}=[AllRespiAmp{nn,2},mean(Amp)];
                    AllRespiSp{nn,2}=[AllRespiSp{nn,2},SmoothDec(SpEpoch,10)];
                end
            end
        end
        
    end
end
if erasePreviousAnalysis, save AnalyRespi AllRespiAmp AllRespiFreq AllRespiSp -append; end


%% Display respi frequency and volume for different brain states
if length(NameEpochs)==3
    disp(' ')
    disp('Display respi frequency and volume for different brain states...')
    
    SeriesAmp=[]; stdAmp=[];pAmp=[];
    SeriesFreq=[]; stdFreq=[];pFreq=[];
    TitleAdd=[];
    
    for nn=1:length(NameEpochs)
        SeriesAmp=[SeriesAmp;[mean(AllRespiAmp{nn,1}),mean(AllRespiAmp{nn,2})]];
        stdAmp=[stdAmp;[stdError(AllRespiAmp{nn,1}) stdError(AllRespiAmp{nn,2})]];
        [H,p]=ttest2(AllRespiAmp{nn,1},AllRespiAmp{nn,2}); pAmp=[pAmp;{['p = ',num2str(p)]}];
        
        
        SeriesFreq=[SeriesFreq;[mean(AllRespiFreq{nn,1}),mean(AllRespiFreq{nn,2})]];
        stdFreq=[stdFreq;[stdError(AllRespiFreq{nn,1}) stdError(AllRespiFreq{nn,2})]];
        [H,p]=ttest2(AllRespiFreq{nn,1},AllRespiFreq{nn,2}); pFreq=[pFreq;{['p = ',num2str(p)]}];
        
        TitleAdd=[TitleAdd,'      ',num2str(nn),'-',NameEpochs{nn}(1:end-5),' (n=',num2str(length(AllRespiAmp{nn,1})),' WT, n=',num2str(length(AllRespiAmp{nn,2})),' dKO)'];
        
    end
    
    
    figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FSeries=gcf;
    subplot(2,1,1)
    
    locOnFig=[0.85 1.15; 1.85 2.15; 2.85 3.15];
    hold on, errorbar(locOnFig,SeriesAmp,stdAmp,'+','color','k')
    bar(SeriesAmp),
    legend('stdWT','stddKO','WT','dKO','location','EastOutside')
    title('TidalVolume of Respiration (mL)')
    xlabel(TitleAdd)
    for i=1:length(pAmp),text(mean(locOnFig(i,:),2),1.1*max(SeriesAmp(i,:)),pAmp(i));end
    
    subplot(2,1,2)
    
    hold on, errorbar(locOnFig,SeriesFreq,stdFreq,'+','color','k')
    bar(SeriesFreq);
    legend('stdWT','stddKO','WT','dKO','location','EastOutside')
    title('Frequency of Respiration (Hz)')
    xlabel(TitleAdd)
    for i=1:length(pFreq),text(mean(locOnFig(i,:),2),1.1*max(SeriesFreq(i,:)),pFreq(i));end
end


%% display mean respi pooled for dKO vs WT

figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FpoolRespiSp=gcf;
for nn=1:length(NameEpochs)

    subplot(1,length(NameEpochs),nn)
    hold on, plot(f_respi,mean(AllRespiSp{nn,1},2),'linewidth',2,'color','k')
    hold on, plot(f_respi,mean(AllRespiSp{nn,2},2),'linewidth',2,'color','r')
    legend('WT','dKO')
    
    hold on, plot(f_respi,mean(AllRespiSp{nn,1},2)+stdError(AllRespiSp{nn,1}')','color','k')
    hold on, plot(f_respi,mean(AllRespiSp{nn,1},2)-stdError(AllRespiSp{nn,1}')','color','k')
    hold on, plot(f_respi,mean(AllRespiSp{nn,2},2)+stdError(AllRespiSp{nn,2}')','color','r')
    hold on, plot(f_respi,mean(AllRespiSp{nn,2},2)-stdError(AllRespiSp{nn,2}')','color','r')
    
    ylabel('Respiration power frequency')
    title([NameEpochs{nn}(1:end-5),' (n=',num2str(size(AllRespiSp{nn,1},2)),' WT, n=',num2str(size(AllRespiSp{nn,2},2)),'dKO)'])
end



%% Spectre in BO - PFC - PA - HPC

disp(' ')
disp('... Calculating Spectrum for all experiments in Dir')

colori={'b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};

figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FallLFPFreq=gcf;
for nn=1:length(NameEpochs)
    for ll=1:length(nameSpectre)
        AllLFPSp{nn,ll}=[];  AllLFPSpgroup{nn,ll}=[];
        if nn==1; figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]); FSpecAll{ll}=gcf;end
    end
end


for man=numDir
    disp(' ')
    disp(['           * * * ',Dir.path{man}(strfind(Dir.path{man},'Mouse'):end),' * * *'])
    
    clear listLFP LFP SpBO SpPFC SpPA SpHPC
    load([Dir.path{man},'/LFPData.mat'],'listLFP','LFP')
    try, listLFP; catch, load([Dir.path{man},'/listLFP.mat'],'listLFP'); save([Dir.path{man},'/LFPData.mat'],'listLFP','-append');end
    
    for ll=1:length(nameSpectre)
        clear Spi ti fi SWSEpoch REMEpoch MovEpoch channel
        if sum(strcmp(listLFP.name,nameSpectre{ll}))~=0
            
            % ----------------------------------------
            % ----------------------------------------
            % calculate Sp for a chosen BO LFP
           [Spi,ti,fi]=ComputeSpectrogramML(LFP,movingwin,params,[Dir.path{man},'/AnalyseFreq.mat'],[nameSpectre(ll),nameSp(ll)],listLFP);
            % ----------------------------------------
            % ----------------------------------------
            
            
            % Spectro for each epoch

            load([Dir.path{man},'/StateEpoch.mat'],'SWSEpoch','REMEpoch','MovEpoch')

            for nn=1:length(NameEpochs)
                clear epoch tEpoch SpEpoch epoch tempAllLFPSp
                eval(['epoch=',NameEpochs{nn},';'])
                
                
                % -- Analyse frequency --
                [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,fi,epoch);
                
                if ploSpectrEpoch,
                    figure(FSpecAll{ll}), subplot(length(NameEpochs),length(numDir),(nn-1)*length(numDir)+find(numDir==man)),
                    hold on, imagesc(tEpoch,f,10*log10(SpEpoch)'); axis xy;
                    title([nameSpectre{ll},' - ',NameEpochs{nn}(1:end-5),' - ',Dir.path{man}(strfind(Dir.path{man},'Mouse'):strfind(Dir.path{man},'Mouse')+7),' - ',Dir.group{man}])
                end
                figure(FallLFPFreq), subplot(length(nameSpectre),length(numDir),(ll-1)*length(numDir)+find(numDir==man)),
                hold on, plot(fi,mean(SpEpoch,1),'color',colori{nn},'linewidth',2)
                title([Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:strfind(Dir.path{man},'Mouse')+7)])
                xlabel('frequency (Hz)')
                ylabel(nameSpectre{ll})
                ylim([0 1/1E7]);
                if isempty(Start(epoch))==0
                    tempAllLFPSp=AllLFPSp{nn,ll};
                    AllLFPSp{nn,ll}=[tempAllLFPSp;mean(SpEpoch,1)];
                    tempAllLFPSp=AllLFPSpgroup{nn,ll};
                    AllLFPSpgroup{nn,ll}=[tempAllLFPSp;{Dir.group{man}}];
                end
                
            end
            
        else
            disp(['no LFP ',nameSpectre{ll},', skipping this step'])
        end
    end
    
end
legend(NameEpochs)


%% display mean Spectro pooled for dKO vs WT
figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FpoolLFPSp=gcf;

for ll=1:length(nameSpectre)
    Y1=[];
    
    for nn=1:length(NameEpochs)
        SpWTf=mean(AllLFPSp{nn,ll}(strcmp(AllLFPSpgroup{nn,ll},'WT'),:),1);
        SpWTfstd=stdError(AllLFPSp{nn,ll}(strcmp(AllLFPSpgroup{nn,ll},'WT')));
        SpKOf=mean(AllLFPSp{nn,ll}(strcmp(AllLFPSpgroup{nn,ll},'dKO'),:),1);
        SpKOfstd=stdError(AllLFPSp{nn,ll}(strcmp(AllLFPSpgroup{nn,ll},'dKO')));
        
        subplot(length(NameEpochs),length(nameSpectre),(nn-1)*length(nameSpectre)+ll)
        hold on, plot(fi,SpWTf,'linewidth',2,'color','k')
        hold on, plot(fi,SpKOf,'linewidth',2,'color','r')
        legend(['WT (n=',num2str(length(AllLFPSp{nn,ll}(strcmp(AllLFPSpgroup{nn,ll},'WT'),1))),')'],['dKO (n=',num2str(length(AllLFPSp{nn,ll}(strcmp(AllLFPSpgroup{nn,ll},'dKO'),1))),')'])
        
        hold on, plot(fi,SpWTf+SpWTfstd,'color','k')
        hold on, plot(fi,SpWTf-SpWTfstd,'color','k')
        hold on, plot(fi,SpKOf+SpKOfstd,'color','r')
        hold on, plot(fi,SpKOf-SpKOfstd,'color','r')
        
        ylabel(['LFP ',nameSpectre{ll},' power frequency'])
        title(NameEpochs{nn}(1:end-5))
        y=ylim; Y1=[Y1 y];
    end
    for nn=1:length(NameEpochs), subplot(length(NameEpochs),length(nameSpectre),(nn-1)*length(nameSpectre)+ll), ylim([0 max(Y1)]);end
end
    

%% Correlation LFP vs Respi

numPoints=860; RespiInt=0:0.003:0.03;
colorGroup={'r','k'};
    
for ll=1:length(nameSpectre)
    
    disp(' ')
    disp(['...  Calculating correlation LFP ',nameSpectre{ll},' vs Respi'])
    Uname=unique(Dir.name);
    
    % figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FcorRespiLFPFil=gcf
    for nn=1:length(NameEpochs), figure('color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2]), FcorRespiLFP(nn,ll)=gcf;end
    figure('color',[1 1 1],'Position',[2 scrsz(4)/2 2*scrsz(3)/3 scrsz(4)/2]),FcorPooled(ll)=gcf;
    
    
    MatrixAmp=[];
    for i=1:length(RespiInt), 
        for nn=1:length(NameEpochs), 
            MatrixAmpWT{nn,i}=[];MatrixAmpKO{nn,i}=[];
        end
    end
    
    
    for uu=1:length(Uname)
        numDirU=find(strcmp(Uname{uu},Dir.name));
        
        MatrixAmpTemp=[];
        for man=numDirU
            
            disp(' ')
            disp(['           * * * ',Dir.path{man}(strfind(Dir.path{man},'Mouse'):end),' * * *'])
            clear listLFP RespiTSD LFP Frequency TidalVolume lfp_temp UniqueChannel
            clear SWSEpoch REMEpoch MovEpoch ThetaMovEpoch
            
            load([Dir.path{man},'/LFPData.mat'],'listLFP')
            
            if sum(strcmp(listLFP.name,nameSpectre{ll}))
                UnameGroup(man)={[Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:strfind(Dir.path{man},'Mouse')+7)]};
                
                load([Dir.path{man},'/LFPData.mat'],'Frequency','TidalVolume','LFP','RespiTSD')
                load([Dir.path{man},'/StateEpoch.mat'],'SWSEpoch','REMEpoch','MovEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch','ThetaEpoch')
                load([Dir.path{man},'/AnalyseFreq.mat'],['UniqueChannel',nameSp{ll}]);
                eval(['UniqueChannel=UniqueChannel',nameSp{ll},';'])
                lfp_temp=LFP{UniqueChannel};
                
                for nn=1:length(NameEpochs)
                    
                    clear AmpRespi AmpBO Temp epoch temp DataZC DataAmp
                    if sum(strcmp(NameEpochs{nn},'ThetaMovEpoch')), ThetaMovEpoch=and(MovEpoch,ThetaEpoch);end
                    eval(['epoch=',NameEpochs{nn},'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
                    
                    if sum(Stop(epoch)-Start(epoch))~=0
                        
                        % -------------------------------------------------
                        % -------------------------------------------------
                        % ---------- correlationRespi_LFPML ----------
                        if ploPETH_RespiTrigLFP
                            savename=[Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:strfind(Dir.path{man},'Mouse')+7),'lfp_',nameSp{ll},num2str(UniqueChannel)];
                            [AmpRespi,AmpBO]=correlationRespi_LFPML(lfp_temp,TidalVolume,RespiInt,numPoints,epoch,1,savename);
                        else
                            [AmpRespi,AmpBO]=correlationRespi_LFPML(lfp_temp,TidalVolume,RespiInt,numPoints,epoch);
                        end
                        % -------------------------------------------------
                        % -------------------------------------------------
                        
                        figure(FcorRespiLFP(nn,ll)), subplot(ceil(length(Uname)/4),4,uu)
                        plot(AmpRespi,AmpBO,['.',colorGroup{strcmp(Dir.group{man},{'dKO','WT'})}]);
                        xlabel(['Respi ',NameEpochs{nn}(1:strfind(NameEpochs{nn},'Epoch')-1)]);
                        ylabel([nameSpectre{ll},' lfp',num2str(UniqueChannel)]); title([Dir.group{man},'-',Dir.path{man}(strfind(Dir.path{man},'Mouse')+6:strfind(Dir.path{man},'Mouse')+7)])
                        xlim([min(RespiInt) max(RespiInt)]); ylim([0 3/1E3]);
                        
                        figure(FcorPooled(ll)), subplot(length(NameEpochs),2,2*nn), hold on,
                        plot(AmpRespi,AmpBO,['.',colorGroup{strcmp(Dir.group{man},{'dKO','WT'})}])
                        
                        
                        % All points for dKO and WT groups
                        for i=1:length(RespiInt)-1
                            index=find(AmpRespi<RespiInt(i+1) & AmpRespi>=RespiInt(i));
                            
                            if length(index)>floor(numPoints/100)
                                if strcmp(Dir.group{man},'dKO')
                                    temp=MatrixAmpKO{nn,i};
                                    if isempty(temp)
                                        MatrixAmpKO{nn,i}=AmpBO(index);
                                    else
                                        MatrixAmpKO{nn,i}=[temp(:,1:min(size(temp,2),length(index)));AmpBO(index(1:min(size(temp,2),length(index))))];
                                    end
                                else
                                    temp=MatrixAmpWT{nn,i};
                                    if isempty(temp)
                                        MatrixAmpWT{nn,i}=AmpBO(index);
                                    else
                                        MatrixAmpWT{nn,i}=[temp(:,1:min(size(temp,2),length(index)));AmpBO(index(1:min(size(temp,2),length(index))))]; 
                                    end
                                end
                            end
                            clear index temp
                            MatrixAmpWT{nn,i}=MatrixAmpWT{nn,i}(find(MatrixAmpWT{nn,i}>0));
                            MatrixAmpKO{nn,i}=MatrixAmpKO{nn,i}(find(MatrixAmpKO{nn,i}>0));
                        end
                        
                        
                        % all mean lfp Amp
                        Temp=NaN(1,length(RespiInt));                        
                        for i=1:length(RespiInt)-1
                            if sum(AmpRespi<RespiInt(i+1) & AmpRespi>=RespiInt(i))>=floor(numPoints/100)
                                Temp(i)=mean(AmpBO(find(AmpRespi<RespiInt(i+1) & AmpRespi>=RespiInt(i))));
                            end
                        end
                        MatrixAmpTemp=[MatrixAmpTemp ; [Temp,strcmp(Dir.group{man},'dKO'),find(strcmp(Uname,Dir.name{man})),nn]];
                        
                        
                    end
                end
                
            else
                disp(['    (no LFP ',nameSpectre{ll}])
            end
        end
        
        
        % all mean lfp Amp for each epoch
        if sum(strcmp(listLFP.name,nameSpectre{ll})) && isempty(MatrixAmpTemp)==0
            Temp=[];
            for nn=1:length(NameEpochs)
                temp=MatrixAmpTemp(find(MatrixAmpTemp(:,length(RespiInt)+3)==nn),:);
                if isempty(temp)==0,
                    Temp=[Temp;[nanmean(temp,1)]];
                    figure(FcorPooled(ll)), subplot(length(NameEpochs),2,2*nn-1), hold on,
                    plot(RespiInt,nanmean(temp(:,1:length(RespiInt)),1),['.',colorGroup{strcmp(Dir.group{man},{'dKO','WT'})}]);
                end
            end
            
            if length(unique(MatrixAmpTemp(:,length(RespiInt)+1)))>1 || length(unique(MatrixAmpTemp(:,length(RespiInt)+2)))>1, keyboard;end
            MatrixAmp=[MatrixAmp ; Temp];
        end
        
    end
    
%     for i=RespiInt
%         
%         figure('color',[1 1 1],'Position',[2 scrsz(4)/2 2*scrsz(3)/3 scrsz(4)/2]),
%         plot(([1:size(ManualTempdKO,2)]-size(ManualTempdKO,2)/2)/size(ManualTempdKO,2)*1E3,mean(ManualTempdKO,1),'Linewidth',2,'Color','r')
%         hold on, plot(([1:size(ManualTempdKO,2)]-size(ManualTempdKO,2)/2)/size(ManualTempdKO,2)*1E3,mean(ManualTempWT,1),'Linewidth',2,'Color','k')
%         legend({'dKO','WT'}); ylabel('Extracellular voltage (mV)'); xlabel('time (ms)');
%         hold on, plot(([1:size(ManualTempdKO,2)]-size(ManualTempdKO,2)/2)/size(ManualTempdKO,2)*1E3,mean(ManualTempdKO,1)+stdError(ManualTempdKO),'Color','r')
%         hold on, plot(([1:size(ManualTempdKO,2)]-size(ManualTempdKO,2)/2)/size(ManualTempdKO,2)*1E3,mean(ManualTempdKO,1)-stdError(ManualTempdKO),'Color','r')
%         hold on, plot(([1:size(ManualTempdKO,2)]-size(ManualTempdKO,2)/2)/size(ManualTempdKO,2)*1E3,mean(ManualTempWT,1)-stdError(ManualTempWT),'Color','k')
%         hold on, plot(([1:size(ManualTempdKO,2)]-size(ManualTempdKO,2)/2)/size(ManualTempdKO,2)*1E3,mean(ManualTempWT,1)+stdError(ManualTempWT),'Color','k')
%         
%         title([nameSpectre{ll},' LFP trigged by respiration. Amp respi in [',num2str(RespiInt(i-2)),';',num2str(RespiInt(i)),']mL (dKO n=',num2str(size(ManualTempdKO,1)/maxPoints),'; WT n=',num2str(size(ManualTempWT,1)/maxPoints),')'])
%         yy=ylim; hold on, line([0 0],[min(yy) max(yy)],'Linewidth',2,'Color',[0.5 0.5 0.5]); ylim(yy)
%     end

    
    pval=0.005;
    figure(FcorPooled(ll)),hold on,
    for nn=1:length(NameEpochs)
        subplot(length(NameEpochs),2,nn*2-1), hold on,
        for i=1:length(RespiInt)
            
            Temp1=MatrixAmp(find(MatrixAmp(:,length(RespiInt)+1)==1 & MatrixAmp(:,length(RespiInt)+3)==nn),i);
            if sum(isnan(Temp1)==0)>1, plot(RespiInt(i),mean(Temp1(isnan(Temp1)==0)),'sr','MarkerSize',8,'MarkerFaceColor',[1 0 0]);end
            
            Temp2=MatrixAmp(find(MatrixAmp(:,length(RespiInt)+1)==0 & MatrixAmp(:,length(RespiInt)+3)==nn),i);
            if sum(isnan(Temp2)==0)>1, plot(RespiInt(i),mean(Temp2(isnan(Temp2)==0)),'sk','MarkerSize',8,'MarkerFaceColor',[0 0 0]);end
            
            [H,p]=ttest2(MatrixAmpWT{nn,i},MatrixAmpKO{nn,i});
            if p<pval, plot(RespiInt(i),0,'g.'); end
            
            clear Temp1 Temp2
        end
        xlim([min(RespiInt) max(RespiInt)]); ylim([0 3/1E3]);
        title(['individual (dot) and pooled (square) means -', NameEpochs{nn}(1:strfind(NameEpochs{nn},'Epoch')-1)])
        xlabel('Respiration TidalVolume (mL)'); ylabel(['lfp ',nameSpectre{ll},' Amplitude (mV)']);
        text(min(RespiInt)+0.1,3/1E4,['pvalue<',num2str(pval)],'Color',[0 1 0])
        
        subplot(length(NameEpochs),2,2*nn), hold on,
        xlim([min(RespiInt) max(RespiInt)]); ylim([0 3/1E3]);
        title(['All (',num2str(numPoints),' dots per mouse) -',NameEpochs{nn}(1:strfind(NameEpochs{nn},'Epoch')-1)])
        xlabel('Respiration TidalVolume (mL)'); ylabel(['lfp ',nameSpectre{ll},' Amplitude (mV)']);
    end

end

%% Save Figures 
disp(' ')
if SaveFig
    try 
        nameFolderSave;
    catch
        nameFolderSave=input('Enter Folder where to save figures: ','s');
    end
    disp(['... Saving figures in ',nameFolderSave,'.'])
    if exist([res,'/',nameFolderSave],'dir')==0
        mkdir(res,nameFolderSave)
    end
    
    if exist('FSeries','var'), saveFigure(FSeries,'Respi_Bilan',[res,'/',nameFolderSave]);end
    saveFigure(FallRespiFreq,'Respi_AllFreq',[res,'/',nameFolderSave])
    saveFigure(FpoolRespiSp,'Respi_PooledSpectrum',[res,'/',nameFolderSave])
    
    saveFigure(FpoolLFPSp,'Lfp_PooledSpectrum',[res,'/',nameFolderSave])
    saveFigure(FallLFPFreq,'Lfp_AllFreq',[res,'/',nameFolderSave])
    
    for ll=1:length(nameSpectre)
        saveFigure(FcorPooled(ll),'CorrAmp_Lfp',nameSp{ll},'vsRespi_Bilan',[res,'/',nameFolderSave])
        for nn=1:length(NameEpochs), saveFigure(FcorRespiLFP(nn,ll),['CorrAmp_LFP',nameSp{ll},'vsRespi_All_',NameEpochs{nn}],[res,'/',nameFolderSave]); end  
    end
    
end
