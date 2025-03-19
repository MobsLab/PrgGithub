%AnalyseNREMsubstages_N1versusImmob4.m

%cd /media/DataMOBsRAID/ProjetNREM/Mouse393/20160704
%cd /media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913

chooseNum=[17 18 19 20 31 39 42];
chooseNumEMG=[39 42];

%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/N1versusImmob';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalyseNREMsubstagesNew';
analyname='AnalySubstagesN1versusImmob3';

Dir1=PathForExperimentsMLnew('BASALlongSleep');
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

mergeSleep=3; %s        
[params]=SpectrumParametersML('newlow');
Fsamp=0.5:0.05:20;
Fs=1250;

colori=[ 0.5 0.2 1 ; 1 0.2 0.8 ;1 0 0; 0 0 0;0.5 0.5 0.5; 0 0 1; 0.1 0.7 0.6  ;0 0.8 0;  0 0 0;1 0 0.5;0.5 0.5 0.5; 0 0 1];
saveFig=1;

%% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

for man=chooseNumEMG%1:length(Dir.path)
    disp(' ');disp(Dir.path{man})
    cd(Dir.path{man}) 
    try
    % -----------------------------
    % ------ Substages ------
    clear WAKE REM N1 N2 N3 SleepStages SWS Sleep
    [WAKE,REM,N1,N2,N3,NamesStages,SleepS,noise]=RunSubstages;close;
    SWS=or(N2,N3); SWS=mergeCloseIntervals(SWS,1);
    Sleep=or(or(SWS,REM),N1); Sleep=mergeCloseIntervals(Sleep,1);
    
    % -----------------------------
    % ------ load mvt ------------
    clear Movtsd MovAcctsd
    load('behavResources.mat','Movtsd','MovAcctsd')
    if ~exist('Movtsd','var'), Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));end
    rg=Range(Movtsd);
    val=SmoothDec(Data(Movtsd),5);
    Mmov=tsd(rg(1:10:end),val(1:10:end));
    zMmov=tsd(rg(1:10:end),zscore(val(1:10:end)));
    WholeEpoch=intervalSet(min(rg),max(rg));
    
    % -----------------------------
    % ------ load EMG ------------
    clear InfoLFP emg tsdEMG LFP
    load('LFPData/InfoLFP.mat');
    emg=InfoLFP.channel(min([find(strcmp(InfoLFP.structure,'EMG')),find(strcmp(InfoLFP.structure,'emg'))]));
    
    if ~isempty(emg)
        disp('Loading and filtering EMG channel... WAIT...')
        load(['LFPData/LFP',num2str(emg),'.mat'],'LFP');
        tsdEMG=FilterLFP(LFP,[50 300], 1024);
        Dt=abs(Data(tsdEMG));rg=Range(tsdEMG,'s');
        dt=SmoothDec(interp1(rg,Dt,rg(1):0.05:rg(end)),10);
        tsdEMG=tsd(1E4*(rg(1):0.05:rg(end))',zscore(dt)); %sample at 25Hz
    else
        disp('no EMG...')
        tsdEMG=tsd([],[]);
    end
    
    % -----------------------------
    % --- spectrums on stages--------
    clear SpHP SpPFCx
    % PFCx_deep
    [Sp,t,f]=LoadSpectrumML('PFCx_deep');
    SpPFCx=tsd(t*1E4,interp1(f,Sp',Fsamp)'); fPF=f;
    
    %dHPC
    disp('- ChannelsToAnalyse/dHPC_rip')
    try
        temp=load('AllRipplesdHPC25.mat','chHPC');
        [Sp,t,f]=LoadSpectrumML(temp.chHPC);
        SpHP=tsd(t*1E4,interp1(f,Sp',Fsamp)'); fHP=f;
    end
    
    % -----------------------------
    % ------ Compute ------
    NamStages={'WAKE','REM','SWS','Sleep'};
    limdur=[15 15 15 15];
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.4]); numF=gcf;
    disp('Computing averaged spectrogram and mvt/emg...')
    for n=1:length(NamStages)
        disp(NamStages{n});
        eval(['epoch=',NamStages{n},';'])
        durEp=Stop(epoch,'s')-Start(epoch,'s');
        ind=find(durEp>limdur(n) & Start(epoch,'s')>15 & Start(epoch,'s')+15<Stop(WholeEpoch,'s'));
        I=intervalSet(Start(subset(epoch,ind(1)))-15E4,Start(subset(epoch,ind(1)))+15E4);
        
        MeanF=Data(Restrict(SpPFCx,I));
        if exist('SpHP','var'), MeanH=Data(Restrict(SpHP,I));end
        MeanEmg=Data(Restrict(tsdEMG,I));
        MeanMvt=Data(Restrict(zMmov,I));
        a=1;
        for ep=1:length(ind)-1
            try
                I=intervalSet(Start(subset(epoch,ind(1+ep)))-15E4,Start(subset(epoch,ind(1+ep)))+15E4);
                if ~isempty(Data(Restrict(zMmov,and(I,noise)))), disp('removing noisy episod');error;end
                tempF=Data(Restrict(SpPFCx,I)); MeanF=MeanF+tempF;
                if exist('SpHP','var'), tempH=Data(Restrict(SpHP,I)); MeanH=MeanH+tempH;end
                MeanEmg=MeanEmg+Data(Restrict(tsdEMG,I));
                MeanMvt=MeanMvt+Data(Restrict(zMmov,I));
                a= a+1;
            end
        end
        
        MeanF=MeanF/a;
        MeanH=MeanH/a;
        MeanEmg=MeanEmg/a;
        MeanMvt=MeanMvt/a;
        % plot figure
        
        subplot(2,length(NamStages),n), imagesc([-15:1/(size(MeanF,1)-1):15],Fsamp,10*log10(MeanF'));
        axis xy; caxis([30 55]); xlabel('Time (s)'); colormap('jet');
        if n==2, title({pwd,[NamStages{n},' start - PFCx']}),else,title([NamStages{n},' start - PFCx']) ; end
        hold on, if ~isempty(MeanMvt), plot([-15:30/(size(MeanMvt,1)-1):15],5*MeanMvt+10,'k','Linewidth',2);end
       if ~isempty(MeanEmg), plot([-15:30/(size(MeanEmg,1)-1):15],5*MeanEmg+11,'Color',[0.5 0.5 0.5],'Linewidth',2);end
       
        line([0 0],ylim,'Color',[0.5 0.5 0.5])
        subplot(2,length(NamStages),length(NamStages)+n),imagesc([-15:1/(size(MeanH,1)-1):15],Fsamp,10*log10(MeanH'));
        axis xy; caxis([30 45]); xlabel('Time (s)'); title([NamStages{n},' start (n=',num2str(length(ind)),')- HPC'])
        leg={};hold on, 
       if ~isempty(MeanMvt), plot([-15:30/(size(MeanMvt,1)-1):15],5*MeanMvt+10,'k','Linewidth',2);leg=[leg,'Mvt'];end
       if ~isempty(MeanEmg), plot([-15:30/(size(MeanEmg,1)-1):15],5*MeanEmg+11,'Color',[0.5 0.5 0.5],'Linewidth',2);leg=[leg,'Emg'];end
       line([0 0],ylim,'Color',[0.5 0.5 0.5]);
    end
    legend(leg)
    saveFigure(numF.Number,['N1versusImmob_SpectreTransitionsSelect',num2str(man)],FolderToSave);
    %saveFigure(numF.Number,['N1versusImmob_SpectreTransitions',num2str(man)],FolderToSave); close;
    catch
        disp('Problem'); if exist('Movtsd','var'), keyboard;end
    end
end
%%
figure, subplot(211), imagesc(Range(SpHP,'s')/3600,Fsamp,10*log10(Data(SpHP)')); 
axis xy; caxis([20 55]); title({pwd,'HPC'})
subplot(212), imagesc(Range(SpPFCx,'s')/3600,Fsamp,10*log10(Data(SpPFCx)')); 
axis xy; caxis([20 55]); title('PFCx')

