Dir=PathForExperimentsML('SUBSET');

if 0
    man=2;
    %for man=1:length(Dir.path)
    disp(Dir.path{man})
    cd(Dir.path{man})
    
    disp('... getting channels and epochs')
    % get channels
    clear InfoLFP; load('LFPData/InfoLFP.mat');
    chan0=InfoLFP.channel(InfoLFP.depth==0 & strcmp(InfoLFP.structure,'Bulb'));
    chan1=InfoLFP.channel(InfoLFP.depth==1 & strcmp(InfoLFP.structure,'Bulb'));
    chan2=InfoLFP.channel(InfoLFP.depth==2 & strcmp(InfoLFP.structure,'Bulb'));
    RefGnd= InfoLFP.channel(strcmp(InfoLFP.structure,'Ref'));
    if isempty(RefGnd), RefGnd= InfoLFP.channel(strcmp(InfoLFP.structure,'EMG'));end
    if ~isempty(RefGnd),
        Lref=load(['LFPData/LFP',num2str(RefGnd),'.mat']);
        ref=FilterLFP(Lref.LFP,[0 1],1024);
    end
    
    load('behavResources.mat','PreEpoch')
    load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch','WeirdNoiseEpoch','GndNoiseEpoch','NoiseEpoch','ThetaEpoch')
    SWS=and(PreEpoch,SWSEpoch)-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
    REM=and(PreEpoch,REMEpoch)-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
    Mov=and(PreEpoch,MovEpoch)-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
    Theta=and(PreEpoch,ThetaEpoch)-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
    
    figure('Color',[1 1 1]),
    subplot(3,1,1)
    if ~isempty(chan0)
        disp('... Loading sup LFP and Sp')
        L0=load(['LFPData/LFP',num2str(chan0),'.mat']);
        S0=load(['SpectrumDataL/Spectrum',num2str(chan0),'.mat']);
        imagesc(S0.t,S0.f,10*log10(S0.Sp)');axis xy, caxis([20 65]); hold on,
        plot(Range(Restrict(L0.LFP,SWS),'s'),10+Data(Restrict(L0.LFP,SWS))/1E3,'r','Linewidth',2);
        plot(Range(Restrict(L0.LFP,REM),'s'),10+Data(Restrict(L0.LFP,REM))/1E3,'g','Linewidth',2);
        plot(Range(Restrict(L0.LFP,Mov),'s'),10+Data(Restrict(L0.LFP,Mov))/1E3,'c','Linewidth',2);
        hold on, plot(Range(L0.LFP,'s'),10+Data(L0.LFP)/1E3,'k');
    else
        disp('... No sup LFP and Sp')
    end
    a=1; xlim([a a+30]); title(pwd); ylabel('LFP0 -sup')
    
    subplot(3,1,2)
    if ~isempty(chan1)
        disp('... Loading med LFP and Sp')
        L2=load(['LFPData/LFP',num2str(chan1),'.mat']);
        S2=load(['SpectrumDataL/Spectrum',num2str(chan1),'.mat']);
        imagesc(S2.t,S2.f,10*log10(S2.Sp)');axis xy, caxis([20 65]); hold on,
        plot(Range(Restrict(L2.LFP,SWS),'s'),10+Data(Restrict(L2.LFP,SWS))/1E3,'r','Linewidth',2);
        plot(Range(Restrict(L2.LFP,REM),'s'),10+Data(Restrict(L2.LFP,REM))/1E3,'g','Linewidth',2);
        plot(Range(Restrict(L2.LFP,Mov),'s'),10+Data(Restrict(L2.LFP,Mov))/1E3,'c','Linewidth',2);
        hold on, plot(Range(L2.LFP,'s'),10+Data(L2.LFP)/1E3,'k');
    else
        disp('... No med LFP and Sp')
    end
    xlim([a a+30]);  ylabel('LFP2 -med')
    
    subplot(3,1,3)
    if ~isempty(chan2)
        disp('... Loading deep LFP and Sp')
        L4=load(['LFPData/LFP',num2str(chan2),'.mat']);
        S4=load(['SpectrumDataL/Spectrum',num2str(chan2),'.mat']);
        imagesc(S4.t,S4.f,10*log10(S4.Sp)');axis xy, caxis([20 65]); hold on,
        plot(Range(Restrict(L4.LFP,SWS),'s'),10+Data(Restrict(L4.LFP,SWS))/1E3,'r','Linewidth',2);
        plot(Range(Restrict(L4.LFP,REM),'s'),10+Data(Restrict(L4.LFP,REM))/1E3,'g','Linewidth',2);
        plot(Range(Restrict(L4.LFP,Mov),'s'),10+Data(Restrict(L4.LFP,Mov))/1E3,'c','Linewidth',2);
        hold on, plot(Range(L4.LFP,'s'),10+Data(L4.LFP)/1E3,'k');
    else
        disp('... No deep LFP and Sp')
    end
    xlim([a a+30]); ylabel('LFP4 -deep'); a=a+30;
    
    subplot(3,1,1), xlim([a a+40]); subplot(3,1,2), xlim([a a+40]);subplot(3,1,3), xlim([a a+40]);a=a+40;
    
    %end
    
    deltaband=[1.5,3.5];
    Uslow=[0.1,1.5];
    
    
end


%% what happens in 1 SWS epoch?

if 0
    freqSlow=[1.5 5];
    
    % options
    DoHilbert=1; % 1 if Hilbert, 0 for spectra
    
    ManualSWS=ManualSWSepochs; sufx='';
    %ManualSWS=SWSbeforeREM;sufx='before REM';
    
    if DoHilbert
        if ~exist('Hilslow','var')
            slow=FilterLFP(L0.LFP,freqSlow,1024);
            Hil=hilbert(Data(slow));
            H=abs(Hil);
            H(H<100)=100;
            Hilslow=tsd(Range(slow),H);
        end
        amp=Hilslow;
        yla='Mean Hilbert Bulb';
    else
        Sptsd=tsd(1E4*S0.t',mean(S0.Sp(:,find(S0.f >= freqSlow(1) & S0.f < freqSlow(2))),2));
        amp=Sptsd;
        yla='Mean Spectrum Bulb';
    end
    clear Mat
    tempdistrib_deb=[];
    tempdistrib_fin=[];
    for st=1:length(Start(ManualSWS))
        epoch=subset(ManualSWS, st);
        % 10 percent period
        Lepperc=(Stop(epoch)-Start(epoch))*0.1;
        deb10perc=intervalSet(Start(epoch),Start(epoch)+Lep);
        fin10perc=intervalSet(Stop(epoch)-Lepperc,Stop(epoch));
        Mat(st,1)=nanmean(Data(Restrict(amp,deb10perc)));
        Mat(st,2)=nanmean(Data(Restrict(amp,fin10perc)));
        Mat(st,3)=10*Lepperc;
        % 10s
        Lep=10*1E4;
        if Mat(st,3)>2*Lep;
            deb10=intervalSet(Start(epoch),Start(epoch)+Lep);
            fin10=intervalSet(Stop(epoch)-Lep,Stop(epoch));
            Mat(st,4)=nanmean(Data(Restrict(amp,deb10)));
            Mat(st,5)=nanmean(Data(Restrict(amp,fin10)));
            tempdistrib_deb=[tempdistrib_deb;Data(Restrict(amp,deb10))];
            tempdistrib_fin=[tempdistrib_fin;Data(Restrict(amp,fin10))];
        else
            Mat(st,4:5)=nan(1,2);
        end
    end
    
    figure('Color',[1 1 1])
    subplot(3,3,1:3), hold on,
    for m=1:size(Mat,1)
        plot(1:size(Mat,1),Mat(:,1),'ok','MarkerFaceColor','k')
        plot(1:size(Mat,1),Mat(:,2),'ob','MarkerFaceColor','b')
        line([m m],[0,Mat(m,3)/1E3],'Color','g');
        line([m m],[Mat(m,1),Mat(m,2)],'Color',[0.5 0.5 0.5]);
        if m==1, legend({'10% begin SWS','10% end SWS','Length SWS'});end
    end
    ylabel(yla); title(pwd)
    
    subplot(3,3,4:6), hold on,
    for m=1:size(Mat,1)
        plot(m,Mat(m,4),'ok','MarkerFaceColor','k')
        plot(m,Mat(m,5),'ob','MarkerFaceColor','b')
        line([m m],[0,Mat(m,3)/1E3],'Color','g');
        line([m m],[Mat(m,4),Mat(m,5)],'Color',[0.5 0.5 0.5]);
        if m==1, legend({'10s begin SWS','10s end SWS','Length SWS'});end
    end
    ylabel(yla)
    xlabel(['SWS periods ',sufx])
    
    [h1,x1]=hist(tempdistrib_deb,1000);
    [h2,x2]=hist(tempdistrib_fin,1000);
    subplot(3,3,7), hold on,
    plot(x1,h1,'k')
    plot(x2,h2,'b')
    legend({'10s begin SWS','10s end SWS'})
    
    subplot(3,3,8), hold on,
    [h3,x3]=hist(Mat(:,4)-Mat(:,5),10,[-3000:600:2700]);
    bar(x3,h3)
    title('Distribution diff10s deb-end')
    
    subplot(3,3,9), hold on,
    plot3(1:size(Mat,1),Mat(:,4),Mat(:,5))
end
%% other plot
if 1
    a=1;
    clear H
    pasHil=100;
    
    cd(Dir.path{a})
    disp(Dir.path{a})
    
    freqSlow=[1.5 5];
    useSleepScoringSB=0;
    removeNoisyEpochs=1;
    
    
    disp('... Getting channels to analyze')
    clear chanBO InfoLFP SWS
    % --------------- get channels -------------
    load LFPData/InfoLFP
    chanBO=[InfoLFP.channel(strcmp(InfoLFP.structure,'Bulb'))',InfoLFP.depth(strcmp(InfoLFP.structure,'Bulb'))'];
    chanBO=sortrows(chanBO,2); chanBO=chanBO(:,1)';
    
    channel=nan;
    load ChannelsToAnalyse/Bulb_deep.mat
    eval(['LBO=load(''LFPData/LFP',num2str(channel),'.mat'');']);
    
    disp('... Recalculating ZeitgeberTime')
    % -------------------------------
    % Recording time
    clear  PreEpoch TimeEndRec tpsdeb tpsfin
    load behavResources PreEpoch TimeEndRec tpsdeb tpsfin Movtsd
    tfinR=TimeEndRec*[3600 60 1]';
    for ti=1:length(tpsdeb)
        dur(ti)=tpsfin{ti}-tpsdeb{ti};
        tdebR(ti)=tfinR(ti)-dur(ti);
        if ti>1 && tdebR(ti)<=tfinR(ti-1)
            tdebR(ti)=tfinR(ti-1)+1;
        end
    end
    % -------------------------------
    % Recalculate ZT
    clear tsdZT t ZT tim ZTstart ZTstop
    tim=[]; ZT=[]; t=Range(LBO.LFP,'s')';
    for ttt=1:length(tpsdeb)
        tim_temp=t(t>=tpsdeb{ttt} & t<tpsfin{ttt});
        if tpsdeb{ttt}~=tpsfin{ttt}
            ZT_temp= interp1([tpsdeb{ttt},tpsfin{ttt}],[tdebR(ttt) tfinR(ttt)],tim_temp);
            tim=[tim,tim_temp]; ZT=[ZT,ZT_temp];
            if ~issorted(ZT); disp('problem, TimeEndRec unsorted');keyboard;end
        end
    end
    tsdZT=tsd(1E4*tim',ZT'/3600);
    
    
    disp('... Loading sleep Epochs')
    % -------------------------------
    % sleepscoring info, classical or with bulb SB
    clear MovEpoch Wake REMEpoch SWSEpoch SWS REM
    if useSleepScoringSB
        try
            load StateEpochSB SWSEpoch Wake REMEpoch
            SWSEpoch;
        catch
            BulbSleepScriptKB
            close all
            load StateEpochSB SWSEpoch Wake REMEpoch
        end
        Wake=and(Wake,PreEpoch);
    else
        load StateEpoch SWSEpoch MovEpoch REMEpoch
        Wake=and(MovEpoch,PreEpoch);
    end
    
    SWS=and(SWSEpoch,PreEpoch);
    REM=and(REMEpoch,PreEpoch);
    
    
    
    % -------------------------------
    % remove noisy epochs
    if removeNoisyEpochs
        clear WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch
        load StateEpoch WeirdNoiseEpoch GndNoiseEpoch NoiseEpoch
        if ~exist('WeirdNoiseEpoch','var'), WeirdNoiseEpoch=intervalSet([],[]);end
        if ~exist('GndNoiseEpoch','var'), GndNoiseEpoch=intervalSet([],[]);end
        if ~exist('NoiseEpoch','var'), NoiseEpoch=intervalSet([],[]);end
        SWS=SWS-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
        REM=REM-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
        Wake=Wake-WeirdNoiseEpoch-GndNoiseEpoch-NoiseEpoch;
    end
    
    % -------------------------------
    % Calculating hilbert transform   
    if ~exist('H','var')
         disp('... Calculating hilbert transform and add to plot')
        eval(['L0=load(''LFPData/LFP',num2str(channel),'.mat'');']);
        disp(['    LFP',num2str(channel)])
        slow=FilterLFP(L0.LFP,freqSlow,1024);
        Hil=hilbert(Data(slow));
        H=abs(Hil);
        H(H<100)=100;
    end
    rg=Range(slow);
    amp=tsd(rg(1:pasHil:end),SmoothDec(H(1:pasHil:end),10));
    
    figure('Color',[1 1 1]), hold on,
    SWSzt=[];
    for ep=1:length(Start(SWS))
        ZTe=Data(Restrict(tsdZT,subset(SWS,ep)));
        SWSzt=[SWSzt,min(ZTe),max(ZTe)];
        plot(Range(Restrict(amp,subset(SWS,ep)),'s'),Data(Restrict(amp,subset(SWS,ep))),'r');
    end
    REMzt=[];
    for ep=1:length(Start(REM))
        ZTe=Data(Restrict(tsdZT,subset(REM,ep)));
        REMzt=[REMzt,min(ZTe),max(ZTe)];
        plot(Range(Restrict(amp,subset(REM,ep)),'s'),Data(Restrict(amp,subset(REM,ep))),'g');
    end
    Wakezt=[];
    for ep=1:length(Start(Wake))
        ZTe=Data(Restrict(tsdZT,subset(Wake,ep)));
        Wakezt=[Wakezt,min(ZTe),max(ZTe)];
        plot(Range(Restrict(amp,subset(Wake,ep)),'s'),Data(Restrict(amp,subset(Wake,ep))),'c');
    end
    
    hold on, plot(Range(Movtsd,'s'),1700+1E4*Data(Movtsd),'k')
    
end



