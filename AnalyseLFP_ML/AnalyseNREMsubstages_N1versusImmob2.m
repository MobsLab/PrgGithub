% AnalyseNREMsubstages_N1versusImmob2.m

% list of related scripts in NREMstages_scripts.m 
% CodePourMarieCrossCorrDeltaSpindlesRipples.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/N1versusImmob';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalyseNREMsubstagesNew';
analyname='AnalySubstagesN1versusImmob2';

Dir1=PathForExperimentsMLnew('BASALlongSleep');
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

mergeSleep=3; %s
MATNameEpoch={'N1','N2','N3','REM','WAKE','StillN1','StillWake','WakeMov','N13s','Immob'};
MATNameTrans={'WKoN1','WKoN13s','N2oN1','N3oN1','REMoN1','SWSoWK','MVoN1','MVoN13s','MVoIMwk'};
        
[params]=SpectrumParametersML('newlow');
Fsamp=0.5:0.05:20;
Fs=1250;

colori=[ 0.5 0.2 1 ; 1 0.2 0.8 ;1 0 0; 0 0 0;0.5 0.5 0.5; 0 0 1; 0.1 0.7 0.6  ;0 0.8 0;  0 0 0;1 0 0.5;0.5 0.5 0.5; 0 0 1];
saveFig=1;

%% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    load([res,'/',analyname]);
    disp([analyname,'.mat already exists.. loaded.'])
catch
    MATEpoch={};
    MATtsdZT={}; 
    MATemg=nan(length(Dir.path),length(MATNameEpoch));
    MATmov=MATemg;
    MATransPF={}; MATransHP={}; MATransEmg={}; MATransMov={};
    MATPF=nan(length(Dir.path),length(MATNameEpoch),length(Fsamp));
    MATHP=MATPF;
    
    for man=1:length(Dir.path)
        disp(' ');disp(Dir.path{man})
        cd(Dir.path{man})
        
        clear WAKE REM N1 N2 N3 SleepStages
        clear NewtsdZT Immob StillWake StillN1 SstillS WstillW SstillS5s WstillW5s
        try
            disp('Loading Substages...')
            [WAKE,REM,N1,N2,N3,NamesStages,SleepS]=RunSubstages;close;
            
            load NREMepochsML.mat opNew op NamesOp Dpfc Epoch noise
            NewtsdZT=GetZT_ML(Dir.path{man});
            
            % --------------------------------------
            % ---- Immobility ----
            clear Movtsd MovAcctsd MovThresh Immob
            clear GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch
            
            load('StateEpochSubStages.mat','Immob','WholeEpoch')
            Immob;
            
            if 1%~exist('Immob','var') % recalculating Immob
                load('behavResources.mat','Movtsd','MovAcctsd')
                if ~exist('Movtsd','var'), Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));end
                rg=Range(Movtsd);
                val=SmoothDec(Data(Movtsd),5);
                Mmov=tsd(rg(1:10:end),val(1:10:end));
                zMmov=tsd(rg(1:10:end),zscore(val(1:10:end)));
                WholeEpoch=intervalSet(min(rg),max(rg));
                
                try
                    load StateEpoch.mat MovThresh GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch
                catch
%                     okThresh='n';
%                     while okThresh~='y'
                        %figure, plot(Range(Mmov,'s'),Data(Mmov)); numfthr=gcf;
                        MovThresh=GetGammaThresh(Data(Mmov));close
                        MovThresh=exp(MovThresh);
%                         tempImmob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
%                         figure(numfthr), hold on, plot(Range(Restrict(Mmov,tempImmob),'s'),Data(Restrict(Mmov,tempImmob)),'r')
%                         okThresh=input('Are you ok with threshold for movement (y/n): ','s');close(numfthr)
%                     end
                end
                try
                    noise=or(GndNoiseEpoch,NoiseEpoch);
                    try noise=or(noise,WeirdNoiseEpoch);end
                    noise=CleanUpEpoch(noise);
                    noise=mergeCloseIntervals(noise,1);
                catch
                    load('StateEpochSubStages.mat','noise');
                end
                
                % sleep
                Immob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
                Immob=Immob-noise;
                sleep=mergeCloseIntervals(Immob,mergeSleep*1E4);
                sleep=dropShortIntervals(sleep,mergeSleep*1E4);
                Immob=mergeCloseIntervals(Immob,1E3);% merge 100ms
                Immob=dropShortIntervals(Immob,1E3); % minimum 100ms
            end
            
            Immob=CleanUpEpoch(Immob);
            WholeEpoch=CleanUpEpoch(WholeEpoch);
            
            Still=Immob-REM;Still=mergeCloseIntervals(Still,1);
            Still=Immob-N2;Still=mergeCloseIntervals(Still,1);
            Still=Immob-N3;Still=mergeCloseIntervals(Still,1);
            WakeMov=WholeEpoch-Immob;WakeMov=mergeCloseIntervals(WakeMov,1);
            WakeMov=WakeMov-noise-REM-N2-N3;
            WakeMov=mergeCloseIntervals(WakeMov,1);
            WakeMov=dropShortIntervals(WakeMov,1);
            
            StillN1=and(Still,N1); StillN1=mergeCloseIntervals(StillN1,1);
            StillWake=and(Still,WAKE); StillWake=mergeCloseIntervals(StillWake,1);
            id_3s=find(Stop(N1,'s')-Start(N1,'s')<=3);N13s=subset(N1,id_3s);
            
            % ---------------------------------
            % ---- transition between stages----
            disp('Calculating SleepStages...')
            %MATNameTrans={'WKoN1','WKoN13s','N2oN1','N3oN1','REMoN1','SWSoWK','MVoN1','MVoN13s','MVoIMwk','IMwkoSleep'};
            
            NamStag={'WAKE','N1','N2','N3','REM','Noise'};
            Noise=intervalSet(0,max(Range(SleepS)));
            Noise=Noise-WAKE-N1-N2-N3-REM;
            Noise=mergeCloseIntervals(Noise,1);
            Noise=dropShortIntervals(Noise,1);
            SleepStages=[]; 
            for n=1:length(NamStag)
                eval(['epoch=',NamStag{n},';'])
                SleepStages=[SleepStages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
            end
            SleepStages=sortrows(SleepStages,1);
            M=SleepStages; M(:,4:5)=[SleepStages(2:end,[2,3]);[0,0]]; % stage after
            M(diff(M(:,1:2)')'<1 | diff(M(:,[2,4])')'<1,:)=[]; % consider only stage if >1s
            
            id_wkn1 = find(M(:,3)==1 & M(:,5)==2); % wake-N1
            id_wkn1_3s = find(M(:,3)==1 & M(:,5)==2 & diff(M(:,[2,4])')'<=3); % wake-N13s
            id_n2n1 = find(M(:,3)==3 & M(:,5)==2); % N2-N1
            id_n3n1 = find(M(:,3)==4 & M(:,5)==2); % N3-N1
            id_REMn1 = find(M(:,3)==5 & M(:,5)==2); % REM-N1
            id_swswk = find((M(:,3)==3 | M(:,3)==4) & M(:,5)==1); % SWS-WAKE
            
            WKoN1=intervalSet((M(id_wkn1,2)-3)*1E4,(M(id_wkn1,2)+3)*1E4);% 3s avant - 3s après
            WKoN13s=intervalSet((M(id_wkn1_3s,2)-3)*1E4,(M(id_wkn1_3s,2)+3)*1E4);
            N2oN1=intervalSet((M(id_n2n1,2)-3)*1E4,(M(id_n2n1,2)+3)*1E4);
            N3oN1=intervalSet((M(id_n3n1,2)-3)*1E4,(M(id_n3n1,2)+3)*1E4);
            REMoN1=intervalSet((M(id_REMn1,2)-3)*1E4,(M(id_REMn1,2)+3)*1E4);
            SWSoWK=intervalSet((M(id_swswk,2)-3)*1E4,(M(id_swswk,2)+3)*1E4);
            
            
            % ---------------------------------
            NamStag={'WakeMov','StillN1','StillWake','N2','N3','REM','Noise'};
            Noise=intervalSet(0,max(Range(SleepS)));
            Noise=Noise-WakeMov-StillN1-StillWake-N2-N3-REM;
            Noise=mergeCloseIntervals(Noise,1);
            Noise=dropShortIntervals(Noise,1);
            
            SleepStages=[];
            disp('Calculating SleepStages...')
            for n=1:length(NamStag)
                eval(['epoch=',NamStag{n},';'])
                SleepStages=[SleepStages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
            end
            SleepStages=sortrows(SleepStages,1);
            M=SleepStages; M(:,4:5)=[SleepStages(2:end,[2,3]);[0,0]]; % stage after
            M(diff(M(:,1:2)')'<1 | diff(M(:,[2,4])')'<1,:)=[]; % consider only stage if >1s
            
            id_MvImN1 = find(M(:,3)==1 & M(:,5)==2); % wakeMov-StillN1
            id_MvImN1_3s = find(M(:,3)==1 & M(:,5)==2 & diff(M(:,[2,4])')'<=3); % wakeMov-StillN1 <3s
            id_MvImW = find(M(:,3)==1 & M(:,5)==2 & diff(M(:,1:2)')'<=3); % wakeMov-StillWake
            id_ImWs = find(M(:,3)==3 & (M(:,5)==4 | M(:,5)==5 | M(:,5)==6)); % StillWake-sleep (N2-N3-REM)
            
            MVoN1=intervalSet((M(id_MvImN1,2)-3)*1E4,(M(id_MvImN1,2)+3)*1E4); % 3s avant - 3s après
            MVoN13s=intervalSet((M(id_MvImN1_3s,2)-3)*1E4,(M(id_MvImN1_3s,2)+3)*1E4);
            MVoIMwk=intervalSet((M(id_MvImW,2)-3)*1E4,(M(id_MvImW,2)+3)*1E4);
            IMwkoSleep=intervalSet((M(id_ImWs,2)-3)*1E4,(M(id_ImWs,2)+3)*1E4);
            
            % -----------------------------
            % ----------- EPOCHS ------------
            MATNames = [MATNameEpoch,MATNameTrans];
            for n=1:length(MATNames)
                eval(['MATEpoch{man,n}=',MATNames{n},';']);
            end
            MATtsdZT{man}=NewtsdZT;
            
            
            % -----------------------------
            % ------ load EMG ------------
            clear InfoLFP emg tsdEMG LFP
            load('LFPData/InfoLFP.mat');
            emg=InfoLFP.channel(min([find(strcmp(InfoLFP.structure,'EMG')),find(strcmp(InfoLFP.structure,'emg'))]));
            % remove noise
            if strcmp(Dir.name{man},'Mouse160'), emg=[];end
            if strcmp(Dir.path{man},'/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906'), emg=[];end
            
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
            % movements and EMG
            A=nan(length(MATNameEpoch),length(SleepStages)); B=A;
            for n=1:length(MATNameEpoch)
                clear epoch
                eval(['epoch=',MATNameEpoch{n},';'])
                MATmov(man,n)=nanmean(Data(Restrict(zMmov,epoch)));
                MATemg(man,n)=nanmean(Data(Restrict(tsdEMG,epoch)));
                for i=1:length(Start(epoch))
                    A(n,i)=nanmean(Data(Restrict(zMmov,subset(epoch,i))));
                    B(n,i)=nanmean(Data(Restrict(tsdEMG,subset(epoch,i))));
                end
            end
            
            % plot movement and Emg
            figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numM=gcf;
            subplot(2,1,1), plot([1:length(MATNameEpoch)]'*ones(1,size(A,2)),A,'.k')
            set(gca,'Xtick',1:length(MATNameEpoch)); set(gca,'XtickLabel',MATNameEpoch)
            title(Dir.path{man}(min(strfind(Dir.path{man},'Mouse')):end))
            ylabel('Movement'); xlim([0.5 length(MATNameEpoch)+0.5])
            subplot(2,1,2), plot([1:length(MATNameEpoch)]'*ones(1,size(B,2)),B,'.k')
            set(gca,'Xtick',1:length(MATNameEpoch)); set(gca,'XtickLabel',MATNameEpoch)
            ylabel('EMG');  xlim([0.5 length(MATNameEpoch)+0.5])
            if saveFig, saveFigure(numM.Number,['N1versusImmob_EmgMov',num2str(man)],FolderToSave); end
            close(numM.Number);
            
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
            
            % spectrum on stages
            for n=1:length(MATNameEpoch)
                clear epoch
                eval(['epoch=',MATNameEpoch{n},';'])
                tempPF=nanmean(Data(Restrict(SpPFCx,epoch)),1);
                tempH=nanmean(Data(Restrict(SpHP,epoch)),1);
                MATHP(man,n,:)=tempH;
                MATPF(man,n,:)=tempPF;
            end
            
            %  -----------------------
            % spectrum at transitions
            % figure, imagesc(t,f,10*log10(Sp')); axis xy; caxis([15 55])
            figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numG=gcf;
            figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numGH=gcf;
            for n=1:length(MATNameTrans)
                clear epoch
                eval(['epoch=',MATNameTrans{n},';'])
                MeanF=zeros(60,length(Fsamp)); MeanH=MeanF;
                MeanM=zeros(60,1); MeanE=MeanM;
                for ep=1:length(Start(epoch))
                    %PFCx
                    tempF=Data(Restrict(SpPFCx,subset(epoch,ep)));
                    MeanF=MeanF+interp1(1:59/(size(tempF,1)-1):60,tempF,1:60);
                    try %HPC
                        tempH=Data(Restrict(SpHP,subset(epoch,ep)));
                        MeanH=MeanH+interp1(1:59/(size(tempH,1)-1):60,tempH,1:60);
                    end
                    try %Mov 
                    tempM=Data(Restrict(zMmov,subset(epoch,ep)));
                    MeanM=MeanM+interp1(1:59/(size(tempM,1)-1):60,tempM',1:60)';
                    end
                    try % EMG
                    tempE=Data(Restrict(tsdEMG,subset(epoch,ep)));
                    MeanE=MeanE+interp1(1:size(tempE,1),tempE',1:(size(tempE,1)-1)/59:size(tempE,1))';
                    end
                end
                
                MeanF=MeanF/length(Start(epoch));
                MeanH=MeanH/length(Start(epoch));
                MeanM=MeanM/length(Start(epoch));
                MeanE=MeanE/length(Start(epoch));
                MATransPF{man,n}=MeanF; 
                MATransHP{man,n}=MeanH; 
                MATransMov{man,n}=MeanM; 
                MATransEmg{man,n}=MeanE;  
    
                figure(numG),subplot(3,3,n), hold on,
                imagesc([-3:1/(size(MeanF,1)-1):3],Fsamp,10*log10(MeanF')); 
                if sum(MeanM)~=0, plot([-3:6/(size(MeanM,1)-1):3],5*MeanM+10,'k','Linewidth',2);end
                if sum(MeanE)~=0,plot([-3:6/(size(MeanE,1)-1):3],2*MeanE+15,'Color',[0.5 0.5 0.5],'Linewidth',2);end
                line([0 0],ylim,'Color',[0.5 0.5 0.5]); xlim([-3 3]); ylim([0 20])
                axis xy; caxis([20 55]); xlabel('Time (s)'); colormap('jet')
                tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
                title(sprintf([tt,' (n=%d)'],length(Start(epoch))))
                
                figure(numGH),subplot(3,3,n), hold on,
                imagesc([-3:1/(size(MeanH,1)-1):3],Fsamp,10*log10(MeanH')); 
                if sum(MeanM)~=0, plot([-3:6/(size(MeanM,1)-1):3],5*MeanM+10,'k','Linewidth',2);end
                if sum(MeanE)~=0,plot([-3:6/(size(MeanE,1)-1):3],2*MeanE+15,'Color',[0.5 0.5 0.5],'Linewidth',2);end
                line([0 0],ylim,'Color',[0.5 0.5 0.5]); xlim([-3 3]); ylim([0 20])
                axis xy; caxis([25 50]); xlabel('Time (s)'); colormap('jet')
                tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
                title(sprintf([tt,' (n=%d)'],length(Start(epoch))))
            end
            if saveFig
                saveFigure(numG.Number,['N1versusImmob_SpectrumPF',num2str(man)],FolderToSave); 
                saveFigure(numGH.Number,['N1versusImmob_SpectrumHP',num2str(man)],FolderToSave); 
            end
            close(numG.Number);close(numGH.Number);
        catch
            disp('Problem'); %keyboard
        end
    end
    save([res,'/',analyname],'-v7.3','MATEpoch','Dir','mergeSleep',...
        'MATtsdZT','MATNameEpoch','MATNameTrans','params','Fsamp','Fs','MATHP','MATPF',...
        'MATmov','MATemg','MATransPF','MATransHP','MATransEmg','MATransMov')
end

%% plot


A=MATmov;
figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.5 0.4]); numF=gcf;
ido=find(isnan(nanmean(A,2))==0);
subplot(2,2,1), plotSpread(A,'distributionColors','k');hold on, 
for n=1:10, line(n+[0.8 1.2],nanmean(A(:,n))+[0 0],'Color','k','Linewidth',2); end

figure('Color',[1 1 1],'unit','Normalized','Position', [0.05 0.05 0.5 0.4]); numF=gcf;
MAT=MATemg;
if 1 % plot % number episode stillWW
ido=find(isnan(nanmean(MAT,2))==0);
A=100*MAT(ido,1)./(MAT(ido,1)+MAT(ido,3));
subplot(2,2,1), plotSpread(A,'distributionColors','k');
hold on, line([0.8 1.2],nanmean(A)+[0 0],'Color','k','Linewidth',2); ylim([0 100])
ylabel('% number episode stillWW')
title('Wake-still-Wake vs sleep(REM N2 N3)-still-sleep')
A=MAT(ido,1);
subplot(2,2,2), plotSpread(A,'distributionColors','k');
hold on, line([0.8 1.2],nanmean(A)+[0 0],'Color','k','Linewidth',2); 
ylabel('number episode stillWW')

A=100*MAT(ido,2)./(MAT(ido,2)+MAT(ido,4));
subplot(2,2,3), plotSpread(A,'distributionColors','k');
hold on, line([0.8 1.2],nanmean(A)+[0 0],'Color','k','Linewidth',2); ylim([0 100])
ylabel('% total duration stillWW')
A=MAT(ido,2)/60;
subplot(2,2,4), plotSpread(A,'distributionColors','k');
hold on, line([0.8 1.2],nanmean(A)+[0 0],'Color','k','Linewidth',2); 
ylabel('total duration stillWW (min)')
end

%% distribution duration immob episode
DurImmob=[];
MATimmob=MATEpoch(:,strcmp(MATNameEpoch,'Immob'));
for man=1:length(Dir.path)
    Immob=MATimmob{man,1};
    try DurImmob=[DurImmob;Stop(Immob,'s')-Start(Immob,'s')];end
end
figure, hist(log10(DurImmob),1000)


%% distribution duration immob episode

try 
    load([res,'AnalySubstagesN1versusImmob_GoodSpectrum.mat'],'do') 
    do(1);
catch
    for man=1:length(Dir.path)
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.5 0.6]); F=gcf;
        disp(' ');disp(Dir.path{man})
        yl1=[]; yl2=[];
        for n=1:10
            tempH=squeeze(MATHP(man,n,:));
            tempF=squeeze(MATPF(man,n,:));
            
            subplot(2,2,floor(n/6)+1),hold on,
            try, plot(Fsamp,tempH,'Color',colori(n,:),'Linewidth',2); end
            title('definition Still = Immob -N2 -N3 -REM'); ylabel('HPC'); legend(MATNameEpoch);
            if n>5,legend(MATNameEpoch(6:end));else,title(Dir.name{man});end
            yl1=[yl1,ylim];
            
            subplot(2,2,2+floor(n/6)+1), hold on,
            plot(Fsamp,tempF,'Color',colori(n,:),'Linewidth',2), hold on,
            legend(MATNameEpoch); ylabel('PFC')
            if n>5,legend(MATNameEpoch(6:end));else,title(['                         ',Dir.path{man}]);end
            yl2=[yl2,ylim];
        end
        disp('0=discard all, 111=save all, 011=discard HP, 101=discard wake, 001=discard HP & wake, 100=save only HP')
        do(man)=input('choose : ');
        close(F)
    end
    
    DoHP=(do~=0 & do ~=11 & do ~=1 );
    DoPFwake=(do==111 | do ==11);
    DoPF=(do~=0 & do ~=100);
    
    save AnalySubstagesN1versusImmob_GoodSpectrum.mat do Dir DoHP DoPFwake DoPF
end

%%
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.5 0.6]); numF=gcf;
tit1=[];tit2=[];yl1=[]; yl2=[];
for n=1:10
    if ~isempty([strfind(MATNameEpoch,'WAKE'),strfind(MATNameEpoch,'Wake')])
        HP=squeeze(MATHP(find(floor((DoPFwake+DoHP)/2)),n,:));
        PF=squeeze(MATPF(DoPFwake,n,:));
    else
        HP=squeeze(MATHP(DoHP,n,:));
        PF=squeeze(MATPF(DoPF,n,:));
    end
    
    tempH=nanmean(HP,1);
    stdH=stdError(HP);
    tempF=nanmean(PF,1);
    stdF=stdError(PF);
    
    subplot(2,2,floor(n/6)+1),hold on,
    plot(Fsamp,tempH,'Color',colori(n,:),'Linewidth',2); 
    plot(Fsamp,tempH+stdH,'Color',colori(n,:));
    plot(Fsamp,tempH-stdH,'Color',colori(n,:)); 
    title('definition Still = Immob -N2 -N3 -REM'); ylabel('HPC'); 
    if n>5
        tit2=[tit2,{MATNameEpoch{n},'std',' '}];
    else
        tit1=[tit1,{MATNameEpoch{n},'std',' '}];
    end
    yl1=[yl1,ylim];
    
    subplot(2,2,2+floor(n/6)+1), hold on,
    plot(Fsamp,tempF,'Color',colori(n,:),'Linewidth',2), 
    plot(Fsamp,tempF+stdF,'Color',colori(n,:)); 
    plot(Fsamp,tempF-stdF,'Color',colori(n,:)); 
    yl2=[yl2,ylim];
end
subplot(2,2,1),legend(tit1);ylim([0 max(yl1)]); subplot(2,2,2),legend(tit2); ylim([0 max(yl1)]);
subplot(2,2,3),legend(tit1);ylim([0 max(yl2)]); subplot(2,2,4),legend(tit2);ylim([0 max(yl2)]);

if saveFig, saveFigure(numF.Number,'N1versusImmob_AllSpectrumPFandHP',FolderToSave); end
           
%% EMG
tempMov=squeeze(MATmov(:,1:10,1)); %tempMov(tempMov>10E9)=nan; tempMov(tempMov<10)=nan;
abberant=find(tempMov(:,5)<tempMov(:,4));tempMov(abberant,:)=nan;
tempEmg=squeeze(MATemg(:,1:10,1));
abberant=find(tempEmg(:,5)<tempEmg(:,4));tempEmg(abberant,:)=nan;
Nmov=sum(~isnan(nanmean(tempMov,2)));
Nemg=sum(~isnan(nanmean(tempEmg,2)));

% A=nan(10000,10);B=nan(10000,10);
% for n=1:10
%     tempMovAll=squeeze(MATmov(:,n,2:end));
%     tempMovAll=tempMovAll(tempMovAll~=0);
%     A(1:length(tempMovAll),n)=tempMovAll;
%     tempEmgAll=squeeze(MATemg(:,n,2:end));
%     tempEmgAll=tempEmgAll(:);
%     B(1:length(tempEmgAll),n)=tempEmgAll;
% end
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.7 0.7]); numF=gcf;
subplot(2,3,1), plotSpread(tempMov,'distributionColors','k');hold on, 
for n=1:10, line(n+[-0.2 0.2],nanmean(tempMov(:,n),1)+[0 0],'Color',colori(n,:),'Linewidth',2);end
set(gca,'Xtick',1:10); set(gca,'XtickLabel',MATNameEpoch(1:10),'XTickLabelRotation',45)
title(sprintf('Movements (n=%d session)',Nmov))

subplot(2,3,4), plotSpread(tempEmg,'distributionColors','k');hold on, 
for n=1:10, line(n+[-0.2 0.2],nanmean(tempEmg(:,n),1)+[0 0],'Color',colori(n,:),'Linewidth',2);end
set(gca,'Xtick',1:10); set(gca,'XtickLabel',MATNameEpoch(1:10),'XTickLabelRotation',45)
title(sprintf('EMG (n=%d session)',Nemg))

mice=unique(Dir.name);
MiMov=nan(length(mice),10); MiEmg=MiMov;
for mi=1:length(mice)
    MiMov(mi,:)=nanmean(tempMov(strcmp(Dir.name,mice{mi}),:),1);
    MiEmg(mi,:)=nanmean(tempEmg(strcmp(Dir.name,mice{mi}),:),1);
    disp([sprintf('%1.0f   ',tempMov(strcmp(Dir.name,mice{mi}),2)),'  mean = ',num2str(floor(10*MiEmg(mi,2))/10)])
end
miNmov=sum(~isnan(nanmean(MiMov,2)));
miNemg=sum(~isnan(nanmean(MiEmg,2)));

subplot(2,3,2), plotSpread(MiMov,'distributionColors','k');hold on, 
for n=1:10, line(n+[-0.2 0.2],nanmean(MiMov(:,n),1)+[0 0],'Color',colori(n,:),'Linewidth',2);end
set(gca,'Xtick',1:10); set(gca,'XtickLabel',MATNameEpoch(1:10),'XTickLabelRotation',45)
title(sprintf('Movements (N=%d mice)',miNmov))

subplot(2,3,5), plotSpread(MiEmg,'distributionColors','k');hold on, 
for n=1:10, line(n+[-0.2 0.2],nanmean(MiEmg(:,n),1)+[0 0],'Color',colori(n,:),'Linewidth',2);end
set(gca,'Xtick',1:10); set(gca,'XtickLabel',MATNameEpoch(1:10),'XTickLabelRotation',45)
title(sprintf('EMG (N=%d mice)',miNemg))

% subplot(2,3,3), PlotErrorBarN_KJ(MiMov(:,1:8),'newfig',0);
% title(sprintf('Movements (N=%d mice)',miNmov))
subplot(2,3,3), PlotErrorBarN_KJ(tempMov(:,1:8),'newfig',0,'ShowSigstar','none');
title(sprintf('Movements (n=%d session)',Nmov))
set(gca,'Xtick',1:8); set(gca,'XtickLabel',MATNameEpoch(1:8),'XTickLabelRotation',45)

subplot(2,3,6), PlotErrorBarN_KJ(tempEmg(:,1:8),'newfig',0,'ShowSigstar','none');
title(sprintf('EMG (n=%d session)',Nemg))
set(gca,'Xtick',1:8); set(gca,'XtickLabel',MATNameEpoch(1:8),'XTickLabelRotation',45)

if saveFig, saveFigure(numF.Number,'N1versusImmob_AllEmgMov',FolderToSave); end

%'/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906'                         
%'/media/DataMOBsRAIDN/ProjetAstro/Mouse148/20140828/BULB-Mouse-148-28082014'
%'/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141219/BULB-Mouse-160-19122014'
%'/media/DataMOBsRAIDN/ProjetAstro/Mouse160/20141222/BULB-Mouse-160-22122014'


%% figure spectrum

% spectrum at transitions
% figure, imagesc(t,f,10*log10(Sp')); axis xy; caxis([15 55])
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numG=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numGH=gcf;

for n=1:length(MATNameTrans)
    
    MeanF=zeros(60,length(Fsamp)); MeanH=MeanF;
    MeanM=zeros(60,1); MeanE=MeanM; a=[0 0 0 0];
    for man=1:length(Dir.path)
        tempF=MATransPF{man,n}; if ~isempty(tempF) && ~isnan(nanmean(nanmean(tempF))),MeanF=MeanF+tempF; a(1)=a(1)+1;end
        tempH=MATransHP{man,n}; if ~isempty(tempH) && ~isnan(nanmean(nanmean(tempH))),MeanH=MeanH+tempH; a(2)=a(2)+1;end
        tempM=MATransMov{man,n}; if ~isempty(tempM) && ~isnan(nanmean(nanmean(tempM))),MeanM=MeanM+tempM; a(3)=a(3)+1;end
        tempE=MATransEmg{man,n}; if ~isempty(tempE) && ~isnan(nanmean(nanmean(tempE))),MeanE=MeanE+tempE; a(4)=a(4)+1;end
    end
    MeanF=MeanF/a(1);
    MeanH=MeanH/a(2);
    MeanM=MeanM/a(3);
    MeanE=MeanE/a(4);
    
    figure(numG),subplot(3,3,n), hold on,
    imagesc([-3:1/(size(MeanF,1)-1):3],Fsamp,10*log10(MeanF'));
    if sum(MeanM)~=0, plot([-3:6/(size(MeanM,1)-1):3],5*MeanM+5,'k','Linewidth',2);end
    if sum(MeanE)~=0,plot([-3:6/(size(MeanE,1)-1):3],20*MeanE+10,'Color',[0.5 0.5 0.5],'Linewidth',2);end
    line([0 0],ylim,'Color',[0.5 0.5 0.5]); xlim([-3 3]); ylim([0 20])
    axis xy; caxis([25 50]); xlabel('Time (s)'); colormap('jet')
    tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
    title(sprintf(['PFC ',tt,' (n=%d)'],a(1))); colorbar('Location','eastoutside')
    
    figure(numGH),subplot(3,3,n), hold on,
    imagesc([-3:1/(size(MeanH,1)-1):3],Fsamp,10*log10(MeanH'));
    if sum(MeanM)~=0 && ~isnan(sum(MeanM)), plot([-3:6/(size(MeanM,1)-1):3],5*MeanM+5,'k','Linewidth',2);end
    if sum(MeanE)~=0 && ~isnan(sum(MeanE)),plot([-3:6/(size(MeanE,1)-1):3],20*MeanE+10,'Color',[0.5 0.5 0.5],'Linewidth',2);end
    line([0 0],ylim,'Color',[0.5 0.5 0.5]); xlim([-3 3]); ylim([0 20])
    axis xy; caxis([25 50]); xlabel('Time (s)'); colormap('jet')
    tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
    title(sprintf(['HPC ',tt,' (n=%d)'],a(1))); colorbar('Location','eastoutside')
end
legend({'Mov','EMG'}); 
figure(numG),legend({'Mov','EMG'});

if saveFig
    saveFigure(numG.Number,'N1versusImmob_SpectrumPFC',FolderToSave); 
    saveFigure(numGH.Number,'N1versusImmob_SpectrumHPC',FolderToSave); 
end

%% figure pooled per mouse spectrum
mice = unique(Dir.name);

% spectrum at transitions
% figure, imagesc(t,f,10*log10(Sp')); axis xy; caxis([15 55])
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numG=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numGH=gcf;

for n=1:length(MATNameTrans)
    
    MeanF=zeros(60,length(Fsamp)); MeanH=MeanF;
    MeanM=zeros(60,1); MeanE=MeanM; a=[0 0 0 0];
    for mi=1:length(mice)
        id=find(strcmp(Dir.name,mice{mi}));
        % pool session from same mice
        MiF=zeros(60,length(Fsamp)); MiH=MiF;
        MiM=zeros(60,1); MiE=MiM; ami=[0 0 0 0];
        for man=1:length(id)
            tempF=MATransPF{id(man),n}; if ~isempty(tempF) && ~isnan(nanmean(nanmean(tempF))),MiF=MiF+tempF; ami(1)=ami(1)+1;end
            tempH=MATransHP{id(man),n}; if ~isempty(tempH) && ~isnan(nanmean(nanmean(tempH))),MiH=MiH+tempH; ami(2)=ami(2)+1;end
            tempM=MATransMov{id(man),n}; if ~isempty(tempM) && ~isnan(nanmean(tempM)) && nanmean(tempM)~=0,MiM=MiM+tempM; ami(3)=ami(3)+1;end
            tempE=MATransEmg{id(man),n}; if ~isempty(tempE) && ~isnan(nanmean(tempE)) && nanmean(tempM)~=0,MiE=MiE+tempE; ami(4)=ami(4)+1;end
        end
        MiF=MiF/ami(1);
        MiH=MiH/ami(2);
        MiM=MiM/ami(3);
        MiE=MiE/ami(4);
        % average all mice
        if ~isempty(MiF) && ~isnan(nanmean(nanmean(MiF))),MeanF=MeanF+MiF; a(1)=a(1)+1;end
        if ~isempty(MiH) && ~isnan(nanmean(nanmean(MiH))),MeanH=MeanH+MiH; a(2)=a(2)+1;end
        if ~isempty(MiM) && ~isnan(nanmean(nanmean(MiM))),MeanM=MeanM+MiM; a(3)=a(3)+1;end
        if ~isempty(MiE) && ~isnan(nanmean(nanmean(MiE))),MeanE=MeanE+MiE; a(4)=a(4)+1;end
    end
    MeanF=MeanF/a(1);
    MeanH=MeanH/a(2);
    MeanM=MeanM/a(3);
    MeanE=MeanE/a(4);
    
    figure(numG),subplot(3,3,n), hold on,
    imagesc([-3:1/(size(MeanF,1)-1):3],Fsamp,10*log10(MeanF'));
    if sum(MeanM)~=0, plot([-3:6/(size(MeanM,1)-1):3],5*MeanM+5,'k','Linewidth',2);end
    if sum(MeanE)~=0,plot([-3:6/(size(MeanE,1)-1):3],20*MeanE+10,'Color',[0.5 0.5 0.5],'Linewidth',2);end
    line([0 0],ylim,'Color',[0.5 0.5 0.5]); xlim([-3 3]); ylim([0 20])
    axis xy; caxis([25 50]); xlabel('Time (s)'); colormap('jet')
    tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
    title(sprintf(['PFC ',tt,' (N=%d)'],a(1))); colorbar('Location','eastoutside')
    
    figure(numGH),subplot(3,3,n), hold on,
    imagesc([-3:1/(size(MeanH,1)-1):3],Fsamp,10*log10(MeanH'));
    if sum(MeanM)~=0 && ~isnan(sum(MeanM)), plot([-3:6/(size(MeanM,1)-1):3],5*MeanM+5,'k','Linewidth',2);end
    if sum(MeanE)~=0 && ~isnan(sum(MeanE)),plot([-3:6/(size(MeanE,1)-1):3],20*MeanE+10,'Color',[0.5 0.5 0.5],'Linewidth',2);end
    line([0 0],ylim,'Color',[0.5 0.5 0.5]); xlim([-3 3]); ylim([0 20])
    axis xy; caxis([25 50]); xlabel('Time (s)'); colormap('jet')
    tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
    title(sprintf(['HPC ',tt,' (N=%d)'],a(1))); colorbar('Location','eastoutside')
end
legend({'Mov','EMG'}); 
figure(numG),legend({'Mov','EMG'});

if saveFig
    saveFigure(numG.Number,'N1versusImmob_SpectrumPFC_PoolSession',FolderToSave); 
    saveFigure(numGH.Number,'N1versusImmob_SpectrumHPC_PoolSession',FolderToSave); 
end


%% figure spectrum, only mice with both EMG and Movement

% spectrum at transitions
% figure, imagesc(t,f,10*log10(Sp')); axis xy; caxis([15 55])
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numG=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numGH=gcf;

for n=1:length(MATNameTrans)
    
    MeanF=zeros(60,length(Fsamp)); MeanH=MeanF;
    MeanM=zeros(60,1); MeanE=MeanM; a=[0 0 0 0];
    for man=1:length(Dir.path)
        tempM=MATransMov{man,n};
        tempE=MATransEmg{man,n};
        tempF=MATransPF{man,n}; 
        tempH=MATransHP{man,n}; 
        if ~isempty(tempE) && nanmean(tempE)~=0 &&  ~isnan(nanmean(tempE)) && ~isempty(tempM) && nanmean(tempM)~=0 &&  ~isnan(nanmean(tempM))
            if ~isempty(tempF) && ~isnan(nanmean(nanmean(tempF))),MeanF=MeanF+tempF; a(1)=a(1)+1;end
            if ~isempty(tempH) && ~isnan(nanmean(nanmean(tempH))),MeanH=MeanH+tempH; a(2)=a(2)+1;end
            if ~isempty(tempM) && ~isnan(nanmean(nanmean(tempM))),MeanM=MeanM+tempM; a(3)=a(3)+1;end
            if ~isempty(tempE) && ~isnan(nanmean(nanmean(tempE))),MeanE=MeanE+tempE; a(4)=a(4)+1;end
        end
    end
    MeanF=MeanF/a(1);
    MeanH=MeanH/a(2);
    MeanM=MeanM/a(3);
    MeanE=MeanE/a(4);
    
    figure(numG),subplot(3,3,n), hold on,
    imagesc([-3:1/(size(MeanF,1)-1):3],Fsamp,10*log10(MeanF'));
    if sum(MeanM)~=0, plot([-3:6/(size(MeanM,1)-1):3],5*MeanM+5,'k','Linewidth',2);end
    if sum(MeanE)~=0,plot([-3:6/(size(MeanE,1)-1):3],20*MeanE+10,'Color',[0.5 0.5 0.5],'Linewidth',2);end
    line([0 0],ylim,'Color',[0.5 0.5 0.5]); xlim([-3 3]); ylim([0 20])
    axis xy; caxis([25 50]); xlabel('Time (s)'); colormap('jet')
    tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
    title(sprintf(['PFC ',tt,' (n=%d)'],a(1))); colorbar('Location','eastoutside')
    
    figure(numGH),subplot(3,3,n), hold on,
    imagesc([-3:1/(size(MeanH,1)-1):3],Fsamp,10*log10(MeanH'));
    if sum(MeanM)~=0 && ~isnan(sum(MeanM)), plot([-3:6/(size(MeanM,1)-1):3],5*MeanM+5,'k','Linewidth',2);end
    if sum(MeanE)~=0 && ~isnan(sum(MeanE)),plot([-3:6/(size(MeanE,1)-1):3],20*MeanE+10,'Color',[0.5 0.5 0.5],'Linewidth',2);end
    line([0 0],ylim,'Color',[0.5 0.5 0.5]); xlim([-3 3]); ylim([0 20])
    axis xy; caxis([25 50]); xlabel('Time (s)'); colormap('jet')
    tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
    title(sprintf(['HPC ',tt,' (n=%d)'],a(1))); colorbar('Location','eastoutside')
end
legend({'Mov','EMG'}); 
figure(numG),legend({'Mov','EMG'});

if saveFig
    saveFigure(numG.Number,'N1versusImmob_SpectrumPFC_EmgMov',FolderToSave); 
    saveFigure(numGH.Number,'N1versusImmob_SpectrumHPC_EmgMov',FolderToSave); 
end

%% ctrl EMG
ID=[59,30,56,57,58];
for i=1%:length(ID)
    cd(Dir.path{ID(i)})
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
    end
    clear LFP channel;  
    load('ChannelsToAnalyse/PFCx_deep.mat','channel');
    load(['LFPData/LFP',num2str(channel),'.mat'],'LFP');
    figure, subplot(211),plot(Range(tsdEMG,'s'),Data(tsdEMG))
    title(Dir.path(ID(i)))
    subplot(212), plot(Range(LFP,'s'),Data(LFP))
end