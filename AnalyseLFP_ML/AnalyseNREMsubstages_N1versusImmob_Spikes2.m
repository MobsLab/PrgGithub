cle% AnalyseNREMsubstages_N1versusImmob_Spikes2.m

% list of related scripts in NREMstages_scripts.m 
% CodePourMarieCrossCorrDeltaSpindlesRipples.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/N1versusImmob';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalyseNREMsubstagesNew';
analyname='AnalySubstagesN1versusImmobSpikes2';

Dir=PathForExperimentsMLnew('Spikes');

mergeSleep=3; %s
MATNameEpoch={'N1','N2','N3','REM','WAKE','StillN1','StillWake','WakeMov','N13s','Immob'};
MATNameTrans={'WKoN1','REMoN1','REMoWK','MVoIMwk','MVoN1','IMwkoSWS','SWSoWK','N3oN1','N2oN1'};
            
colori=[ 0.5 0.5 0.5;0 0 0;0.5 0.2 1 ; 1 0.2 0.8 ;1 0 0];
saveFig=0;

%% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    load([res,'/',analyname]);
    disp([analyname,'.mat already exists.. loaded.'])
catch
    MAT=nan(length(Dir.path),4);
    MATEpoch={};
    for n=1:length(MATNameTrans), MATransN{n}=[]; MATransNz{n}=[]; end
    AllN=[]; AllNz=[]; 
    for man=1:length(Dir.path)
        disp(' ');disp(Dir.path{man})
        cd(Dir.path{man})
        
        clear WAKE REM N1 N2 N3 SleepStages
        clear NewtsdZT Immob StillWake StillN1 SstillS WstillW SstillS5s WstillW5s
        try
            disp('Loading Substages...')
            [WAKE,REM,N1,N2,N3,NamesStages,SleepS]=RunSubstages;close;
            
            load NREMepochsML.mat opNew op NamesOp Dpfc Epoch noise
            
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
            %MATNameTrans={'WKoN1','REMoN1','REMoWK','MVoIMwk','MVoN1','IMwkoSWS','SWSoWK','N3oN1','N2oN1'};
            
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
            M(diff(M(:,1:2)')'<1.5 | diff(M(:,[2,4])')'<1.5,:)=[]; % consider only stage if >1.5s
            
            id_wkn1 = find(M(:,3)==1 & diff(M(:,1:2)')'>10 & M(:,5)==2); % 10s Wake-N1
            id_REMn1 = find(M(:,3)==5 & diff(M(:,1:2)')'>10 & M(:,5)==2); % 10s REM-N1
            id_REMwk = find(M(:,3)==5 & diff(M(:,1:2)')'>10 & M(:,5)==1); % 10s REM-WK
            id_swswk = find((M(:,3)==3 | M(:,3)==4) & M(:,5)==1); % SWS-WAKE
            id_n2n1 = find(M(:,3)==3 & M(:,5)==2); % N2-N1
            id_n3n1 = find(M(:,3)==4 & M(:,5)==2); % N3-N1
            
            WKoN1=intervalSet((M(id_wkn1,2)-10)*1E4,(M(id_wkn1,2)+3)*1E4);% 10s avant - 3s après
            REMoN1=intervalSet((M(id_REMn1,2)-10)*1E4,(M(id_REMn1,2)+3)*1E4);
            REMoWK=intervalSet((M(id_REMwk,2)-10)*1E4,(M(id_REMwk,2)+3)*1E4);
            SWSoWK=intervalSet((M(id_swswk,2)-3)*1E4,(M(id_swswk,2)+3)*1E4);% 3s avant - 3s après
            N2oN1=intervalSet((M(id_n2n1,2)-3)*1E4,(M(id_n2n1,2)+3)*1E4);
            N3oN1=intervalSet((M(id_n3n1,2)-3)*1E4,(M(id_n3n1,2)+3)*1E4);
            
            
            % ---------------------------------
            NamStag={'WakeMov','StillN1','StillWake','SWS','REM','Noise'};
            SWS=or(N2,N3); SWS=mergeCloseIntervals(SWS,1);
            Noise=intervalSet(0,max(Range(SleepS)));
            Noise=((((Noise-WakeMov)-StillN1)-StillWake)-SWS)-REM;
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
            M(diff(M(:,1:2)')'<1.5 | diff(M(:,[2,4])')'<1.5,:)=[]; % consider only stage if >1.5s
            
            id_MvImN1 = find(M(:,3)==1 & M(:,5)==2); % wakeMov-StillN1
            id_MvImW = find(M(:,3)==1 & M(:,5)==3 ); % wakeMov-StillWake
            id_ImWs = find(M(:,3)==3 & M(:,5)==4 ); % StillWake-sleep (N2-N3)
            
            MVoN1=intervalSet((M(id_MvImN1,2)-10)*1E4,(M(id_MvImN1,2)+3)*1E4); % 10s avant - 3s après
            MVoIMwk=intervalSet((M(id_MvImW,2)-10)*1E4,(M(id_MvImW,2)+3)*1E4);
            IMwkoSWS=intervalSet((M(id_ImWs,2)-10)*1E4,(M(id_ImWs,2)+3)*1E4);
            
            % -----------------------------
            % ----------- EPOCHS ------------
            MATNames = [MATNameEpoch,MATNameTrans];
            for n=1:length(MATNames)
                eval(['MATEpoch{man,n}=',MATNames{n},';']);
            end
            
            % --------------------------------------
            % ----------- load neurons ------------
            clear S numNeurons
            % Get PFCx Spikes
            load('SpikeData.mat','S');
            [numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
            
            % remove MUA from the analysis
            nN=numNeurons;
            for s=1:length(numNeurons)
                if TT{numNeurons(s)}(2)==1
                    nN(nN==numNeurons(s))=[];
                end
            end
            
            if ~isempty(nN)
                % %%%%%%%%%%%%%%%%%%%%%%% GET FR %%%%%%%%%%%%%%%%%%%%%%%%%%
                % calculate instataneous firing rate
                t_step=0:0.1:max(Range(SleepS,'s'));
                iFR=nan(length(nN),length(t_step)); iFRz=iFR;
                for s=1:length(nN)
                    iFR(s,:)=hist(Range(S{nN(s)},'s'),t_step);
                    iFRz(s,:)=zscore(hist(Range(S{nN(s)},'s'),t_step));
                end
                iFRz=tsd(t_step*1E4,iFRz');
                iFR=tsd(t_step*1E4,iFR');
                
                % %%%%%%%%%%%%%%% GET FR PER STAGES %%%%%%%%%%%%%%%%%%%%%%%
                disp('... Getting FR per stages')
                tempFR=nan(length(nN),length(NamesStages));
                tempFRz=tempFR;
                for n=1:length(NamesStages)
                    eval(['epoch=',NamesStages{n},';']); 
                    % firing rate indiv neurons
                    tempFRz(:,n)=mean(Data(Restrict(iFRz,epoch)));
                    tempFR(:,n)=mean(Data(Restrict(iFR,epoch)));
                end
                AllNz=[AllNz;tempFRz];
                AllN=[AllN;tempFR];
                
                figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.6 0.7]); numN=gcf;
                for n=1:length(MATNameTrans)
                    clear epoch MeanN MeanNz 
                    a=0;
                    eval(['epoch=',MATNameTrans{n},';'])
                    if n<7, L=130; else, L=60; end
                    MeanN=zeros(L,length(nN));
                    MeanNz=zeros(L,length(nN));
                    for ep=1:length(Start(epoch))
                        try MeanN=MeanN+Data(Restrict(iFR,subset(epoch,ep)));
                            MeanNz=MeanNz+Data(Restrict(iFRz,subset(epoch,ep)));a=a+1;end
                    end
                    tempN=MATransN{n}; tempNz=MATransNz{n};
                    MATransN{n}=[tempN,MeanN/max(1,a)];
                    MATransNz{n}=[tempNz,MeanNz/max(1,a)];
                    
                    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % %%%%%%% plot imagePETH %%%%%%%
                    B=MeanNz/length(Start(epoch));B1=nanmean(B(1:60,:),1);[BS,id]=sort(B1); B=B(:,id);
                    
                    figure(numN),subplot(3,3,n), hold on,
                    if n<7
                        imagesc([-10:1/(size(B,1)-1):3],1:length(nN),B');xlim([-10 3]);
                    else
                        imagesc([-3:1/(size(B,1)-1):3],1:length(nN),B');xlim([-3 3]);
                    end
                    line([0 0],ylim,'Color',[0.5 0.5 0.5]);
                    axis xy; caxis([-0.3 0.5]);xlabel('Time (s)'); colormap('jet')
                    tt=MATNameTrans{n}; it=strfind(tt,'o'); tt=[tt(1:it-1),' -> ',tt(it+1:end)];
                    title(sprintf([tt,' (n=%d)'],length(Start(epoch))))
                    
                end
            end
            if saveFig
                saveFigure(numN.Number,['N1versusImmob_SpikesPF',num2str(man)],FolderToSave); 
            end
            close(numN.Number);
        catch
            disp('Problem'); if exist('Movtsd','var'), keyboard;end
        end
    end
    save([res,'/',analyname],'MATEpoch','Dir','mergeSleep',...
        'MATNameTrans','MATransN','MATransNz','AllN','AllNz','NamesStages')
end

%% 
% neuron types
MAT=10*AllN;
[BE,idx]=max(MAT');

B=MAT; for b=1:size(B,1),B(b,idx(b))=nan;end
[BE,idx2]=max(B'); clear Didx
for b=1:size(MAT,1),Didx(b)=100*MAT(b,idx2(b))/MAT(b,idx(b));end

clear lis
legN={};
for n=1:length(NamesStages)
    lis{n}=find(idx==n);
    %lis{n}=find(idx==n & Didx<75);
    legN{n}=sprintf([NamesStages{n},' (n=%d)'],length(lis{n}));
end

 %%               
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.02 0.02 0.9 0.4]); numN=gcf;
smo=0;
goto=3;
goto=length(lis);

for n=1:length(MATNameTrans)
    subplot(2,9,n), hold on,
    temp=MATransNz{n};
    for Nn=1:goto
        idN=lis{Nn};
        if n<7
            plot([-10:13/129:3],SmoothDec(nanmean(temp(:,idN),2),smo),'Color',colori(Nn,:),'Linewidth',2);xlim([-5 3]);
        else
            plot([-3:6/59:3],SmoothDec(nanmean(temp(:,idN),2),smo),'Color',colori(Nn,:),'Linewidth',2);xlim([-3 3]);
        end
    end
    ylim([-0.2 0.6]);line([0 0],ylim,'Color',[0.5 0.5 0.5]); 
    xlabel('Time (s)'); ylabel('FR (zscore)')
    tt=MATNameTrans{n}; it=strfind(tt,'o'); 
    tt=[tt(1:it-1),' -> ',tt(it+1:end)]; title(tt)
    
end
legend(legN(1:goto))

% bar plots
yl=[-0.1,0.45];
for n=1:length(MATNameTrans)
    subplot(2,9,9+n), hold on,
    temp=MATransNz{n};
    matbar=nan(goto,2); 
    stdbar1=nan(goto,1); 
    stdbar2=stdbar1; statbar={};
    for Nn=1:goto
        idN=lis{Nn};
        if n<7, ix=[-10:13/129:3];
        else, ix=[-3:6/59:3];
        end
        val=nanmean(temp(:,idN),2);
        id1=find(ix>-2 & ix<0);
        id2=find(ix>0 & ix<2);
        matbar(Nn,1)=nanmean(val(id1));
        stdbar1(Nn)=stdError(val(id1));
        matbar(Nn,2)=nanmean(val(id2));
        stdbar2(Nn)=stdError(val(id2));
        %stats
        [h,p]= ttest2(val(id1),val(id2));
        stattxt='';
        if p<0.05
            stattxt='*';
        elseif p<0.01
            stattxt='**';
        elseif p<0.001
            stattxt='***';
        else 
            stattxt='NS';
        end
        statbar{Nn}=stattxt;
    end
    
    bar(matbar)
    hold on, errorbar([1:goto]-0.15,matbar(:,1),stdbar1,'+k');
    hold on, errorbar([1:goto]+0.15,matbar(:,2),stdbar2,'+k');
    for i=1:goto, text(i,max(yl)*0.95,statbar(i),30);end
    set(gca,'Xtick',[1:length(lis)])
    set(gca,'XtickLabel',NamesStages)
    colormap('pink'); ylim(yl);
    tt=MATNameTrans{n}; it=strfind(tt,'o'); 
    tt=[tt(1:it-1),' -> ',tt(it+1:end)]; title(tt)
end
legend({'2s PRE','2s POST'})


if saveFig
    saveFigure(numN.Number,'N1versusImmob_SpikesPFAllquantif',FolderToSave);
    
end
