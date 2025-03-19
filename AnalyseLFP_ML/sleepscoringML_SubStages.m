% sleepscoringML_SubStages

%   Output:
% StateEpochSubStages.mat containing
%           - ThetaEpoch ThetaEp
%           - Mmov
%           - MovEpoch MovEp ImmobEpoch ImmobEp MovThresh
%           - SWSEpoch SWSEp REMEpoch REMEp
%           - SLEEPuMvtEpoch
%           - NoiseEpoch 


%% initialisation
res=pwd;

% -----------------------------
% --- parameters for analysis -
FreqPos=30; %aquisition video
pasPos=6; %Down sampling position tsd
pasTheta=100; %Down sampling for theta band

scrsz = get(0,'ScreenSize');

% params spectrum
params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2];
params.tapers=[3 5];


% -----------------------------
%% --- load data and do spectrum ----------------
disp(' ');

try 
    load StateEpochSubStages 
    lookInStateEpoch;
catch
    lookInStateEpoch=NaN;
    save StateEpochSubStages lookInStateEpoch
end

if  ~isnan(lookInStateEpoch) && lookInStateEpoch==1
    load('StateEpoch.mat','Spectro');
    disp('... Using spectrogramm from StateEpoch.mat');
    
elseif isnan(lookInStateEpoch)
    
    if exist('StateEpoch.mat','file')
        try 
            load('StateEpoch.mat','Spectro');Spectro;
            disp('... Using spectrogramm from StateEpoch.mat');
            lookInStateEpoch=1;
        catch
            
            lookInStateEpoch=0;
            disp('Choose LFP channel to analyse (best: HPC)')
            InfoLFP=listLFP_to_InfoLFP_ML(res);
            disp(['list channel dHPC in neuroscope: ',num2str(InfoLFP.channel(strcmp(InfoLFP.structure,'dHPC')))])
            disp(['                     profondeur: ',num2str(InfoLFP.depth(strcmp(InfoLFP.structure,'dHPC')))])
            Channel_SleepScor=input('-> Enter num in neuroscope: ');
            
            disp(['... Loading LFPData/LFP',num2str(Channel_SleepScor),'.mat'])
            load([res,'/LFPData/LFP',num2str(Channel_SleepScor),'.mat']);
            
            disp('... Calculating parameters for spectrogramm.');
            [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
            Spectro={Sp,t,f};
            save StateEpochSubStages -append Channel_SleepScor Spectro
        end
    end
    save StateEpochSubStages -append lookInStateEpoch
    
end



%% Display Data
%
Sp=Spectro{1};
t=Spectro{2};
f=Spectro{3};
figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),Gf=gcf;
subplot(3,1,1),imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
title('Spectrogramm');


%% find theta epochs

disp(' ');
try
    ThetaRatioTSD;
    ThetaEpoch;
    disp('... Theta Epochs already exists, skipping this step.');
catch
    disp('... Creating Theta Epochs ');
    
    %filter
    FilTheta=FilterLFP(LFP,[5 10],1024);
    FilDelta=FilterLFP(LFP,[2 5],1024); % default [3 6]
    
    % hilbert transform
    HilTheta=hilbert(Data(FilTheta));
    HilDelta=hilbert(Data(FilDelta));
    H=abs(HilDelta);
    H(H<100)=100;
    
    % ratio theta/delta
    ThetaRatio=abs(HilTheta)./H;
    rgThetaRatio=Range(FilTheta,'s');
    ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
    rgThetaRatio=rgThetaRatio(1:pasTheta:end);
    ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
    
    ThetaThresh=GetGammaThresh(ThetaRatio);
    ThetaThresh=exp(ThetaThresh);
    ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above');
    
    ok='n';
    while ok~='y'
        figure(Gf),
        hold off, subplot(3,1,2), plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
        hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]);
        hold on, line([Start(TrackingEpoch,'s') Start(TrackingEpoch,'s')]',[0 max(Data(ThetaRatioTSD))],'color','k','linewidth',2);
        ok=input('--- Are you satisfied with ThetaEpoch (y/n)? ','s');
        if ok=='n',
            disp('click threshold on figure'); a=ginput(1);
            ThetaThresh=a(2);ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above');
        end
    end
    save('StateEpochSubStages','ThetaEpoch', 'ThetaRatioTSD','ThetaThresh','-append');
end

%% --- Mmov -----

try
    Mmov; MovThresh;
catch
    warning off; 
    load('behavResources.mat','Movtsd','TrackingEpoch','useMovAcctsd','MovAcctsd');
    warning on
    if exist('useMovAcctsd','var') && useMovAcctsd==1
        Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
        disp('using MovAcctsd from INTAN for movement instead of Movtsd')
    end
    Movtsd=tsd(double(Range(Movtsd)),double(Data(Movtsd)));
    try TrackingEpoch; catch, TrackingEpoch=intervalSet(min(Range(Movtsd)),max(Range(Movtsd)));end
    
    % Sophie code to fit gaussian (Bimodpapier.m)
    rg=Range(Movtsd);
    val=SmoothDec(Data(Movtsd),5);
    Mmov=tsd(rg(1:10:end),val(1:10:end));
    MovThresh=GetGammaThresh(Data(Mmov));close
    MovThresh=exp(MovThresh);
    save('StateEpochSubStages','TrackingEpoch', 'Mmov','MovThresh','-append');
    
end
%% Display Mmov
ratio_display_mov=(max(Data(ThetaRatioTSD))-min(Data(ThetaRatioTSD)))/(max(Data(Mmov))-min(Data(Mmov)));
figure(Gf),
hold on, subplot(3,1,2), plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]); 
hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b'); 
try hold on, line([Start(TrackingEpoch,'s') Start(TrackingEpoch,'s')]',[0 20],'color','k','linewidth',2);end
title('Theta/Delta ratio (black) and Movement (blue)');ylim([0 10])


%% Define immobility period

disp(' ');
try
    ImmobEpoch;
    MovEpoch;
    disp('... Immobility and Wake Epochs already exist, skipping this step.');

catch
    disp('... Creating Immobility and Wake Epochs.');
  
    MovEpoch=thresholdIntervals(Mmov,MovThresh,'Direction','Above');
    ImmobEpoch=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
    figure(Gf),subplot(3,1,3),hold off
    plot(Range(Mmov,'s'),Data(Mmov)); ylim([0  max(Data(Mmov))])
    hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),Data(Restrict(Mmov,MovEpoch)),'c')
    hold on, plot(Range(Restrict(Mmov,ImmobEpoch),'s'),Data(Restrict(Mmov,ImmobEpoch)),'r'); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
    try line([Start(TrackingEpoch,'s') Start(TrackingEpoch,'s')],[0 5],'color','k','linewidth',2);end
    title('Wake period (blue) and immobility period (Red). Starts Tracking period (black)')
    save('StateEpochSubStages','MovEpoch', 'ImmobEpoch','MovThresh','-append');
end


%% Noisy Epoch in LFP
disp(' ');
try
    NoiseEpoch;
    GndNoiseEpoch;
    WeirdNoiseEpoch;
    TotalNoiseEpoch;
    disp('... Noisy Epochs in LFP already exist, skipping this step.');
catch
    disp('... Finding Noisy Epochs in LFP.');
    NoiseThresh=3E5;
    GndNoiseThresh=1E6;
    Ok='n';
    while Ok~='y'
        %figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]), Nf=gcf;
        subplot(3,1,3), hold off
        imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
        hold on, plot(Range(Mmov,'s'),10+Data(Mmov)/10,'k');
        title('Spectrogramm : determine noise periods');        
        
        if Ok~='m'
            Okk='n'; % high frequency noise
            %figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]),hf=gcf;
            while Okk~='y'
                
                HighSp=Sp(:,f<=20 & f>=18);
                subplot(3,1,3), hold off,
                imagesc(t,f(f<=20 & f>=18),10*log10(HighSp)'), axis xy,caxis([20 65]);
                
                NoiseTSD=tsd(t*1E4,mean(HighSp,2));
                NoiseEpoch=thresholdIntervals(NoiseTSD,NoiseThresh,'Direction','Above');
                
                hold on, plot(Range(NoiseTSD,'s'),Data(NoiseTSD)/max(Data(NoiseTSD))+19,'b')
                hold on, plot(Range(Restrict(NoiseTSD,NoiseEpoch),'s'),Data(Restrict(NoiseTSD,NoiseEpoch))/max(Data(NoiseTSD))+19,'*w')
                title(['18-20Hz Spectrogramm, determined High Noise Epochs are in white (total=',num2str(floor(10*sum(Stop(NoiseEpoch,'s')-Start(NoiseEpoch,'s')))/10),'s)']);
                Okk=input('--- Are you satisfied with High Noise Epochs (y/n)? ','s');
                if Okk~='y', NoiseThresh=input('Give a new High Noise Threshold (Default=3E5) : '); end
            end
            
            Okk='n'; % low frequency noise (grounding issue)
            while Okk~='y'
                LowSp=Sp(:,f<=2);
                GndNoiseTSD=tsd(t*1E4,mean(LowSp,2));
                GndNoiseEpoch=thresholdIntervals(GndNoiseTSD,GndNoiseThresh,'Direction','Above');
                
                subplot(3,1,3), hold off,
                imagesc(t,f(f<=2),10*log10(LowSp)'), axis xy,caxis([20 65]);
                hold on, plot(Range(GndNoiseTSD,'s'),Data(GndNoiseTSD)/max(Data(GndNoiseTSD))+1,'b')
                hold on, plot(Range(Restrict(GndNoiseTSD,GndNoiseEpoch),'s'),Data(Restrict(GndNoiseTSD,GndNoiseEpoch))/max(Data(GndNoiseTSD))+1,'*w')
                title(['0-2Hz Spectrogramm, determined Ground Noise Epochs are in white (total=',num2str(floor(10*sum(Stop(GndNoiseEpoch,'s')-Start(GndNoiseEpoch,'s')))/10),'s)']);
                
                Okk=input('--- Are you satisfied with Ground Noise Epochs (y/n)? ','s');
                if Okk~='y', GndNoiseThresh=input('Give a new Ground Noise Threshold (Default=1E6) : '); end
            end

            AddOk=input('Do you want to add a WeirdNoiseEpoch (y/n)? ','s');
            if AddOk=='y',
                Okk='n';
                weirdThresh=min(mean(LowSp,2))+std(mean(LowSp,2))/100;
                while Okk~='y'
                    WeirdNoiseEpoch=thresholdIntervals(GndNoiseTSD,weirdThresh,'Direction','Below');
                    Sta=Start(WeirdNoiseEpoch);Sto=Stop(WeirdNoiseEpoch);
                    WeirdNoiseEpoch=intervalSet(Sta-1E4,Sto+1E4);
                    WeirdNoiseEpoch=mergeCloseIntervals(WeirdNoiseEpoch,1*1E4);
                    
                    subplot(3,1,3), hold off,
                    imagesc(t,f(f<=2),10*log10(LowSp)'), axis xy,caxis([20 65]);
                    hold on, plot(Range(GndNoiseTSD,'s'),Data(GndNoiseTSD)/max(Data(GndNoiseTSD))+1,'b')
                    hold on, plot(Range(Restrict(GndNoiseTSD,WeirdNoiseEpoch),'s'),Data(Restrict(GndNoiseTSD,WeirdNoiseEpoch))/max(Data(GndNoiseTSD))+1,'*w')
                    title(sprintf('0-2Hz Spectrogramm, WeirdNoiseEpochs (w, total=%1.1fs), THRESHOLD=%1.1f',sum(Stop(GndNoiseEpoch,'s')-Start(GndNoiseEpoch,'s')),weirdThresh));
                    disp('keyboard to check. use ginput to find additional WeirdNoise start and stop time')
                    
                    Okk=input('--- Are you satisfied with Weirdoise Epochs (y, t to change threshold, m to add periods)? ','s');
                    if Okk=='t'
                        disp(sprintf('Noise Periods are data smaller than THRESHOLD=%1.1f',weirdThresh))
                        weirdThresh=input('Enter new threshold for WeirdNoiseEpoch : ');
                    elseif Okk=='m'
                        disp('(e.g. [1,200, 400,500] to put 1-200s and 400-500s periods into noise)')
                        WeirdNoise=ginput;
                        if ~isempty(WeirdNoise),
                            try WeirdNoiseEpoch=intervalSet(WeirdNoise(1:2:end)*1E4,WeirdNoise(2:2:end)*1E4);
                            catch, keyboard; end;
                        end
                    end
                end
            else
                WeirdNoiseEpoch=intervalSet([],[]);
            end
        else
            % high frequency noise
            NoiseEpoch=input('Enter start and stop time of high noise periods : ');
            keyboard
            if length(NoiseEpoch)/2~=floor(length(NoiseEpoch))/2, disp('Problem: not same number of starts and ends! '); Ok='n';end
            NoiseEpoch=NoiseEpoch*1E4;
            NoiseEpoch(NoiseEpoch>max(Range(Mmov)))=max(Range(Mmov));
            NoiseEpoch(NoiseEpoch<0)=0;
            NoiseEpoch=intervalSet(NoiseEpoch(1:2:end),NoiseEpoch(2:2:end));
            
            % low frequency noise (grounding issue)
            GndNoiseEpoch=input('Enter start and stop time of ground noise periods (very low frequencies) : ');
            keyboard
            if length(GndNoiseEpoch)/2~=floor(length(GndNoiseEpoch))/2, disp('Problem: not same number of starts and ends! '); Ok='n';end
            GndNoiseEpoch=GndNoiseEpoch*1E4;
            GndNoiseEpoch(GndNoiseEpoch>max(Range(Mmov)))=max(Range(Mmov));
            GndNoiseEpoch(GndNoiseEpoch<0)=0;
            GndNoiseEpoch=intervalSet(GndNoiseEpoch(1:2:end),GndNoiseEpoch(2:2:end));
        end
        
        
        subplot(3,1,3), hold off,
        imagesc(t,f,10*log10(Sp)'), axis xy,caxis([20 65]);
        hold on, plot(Range(GndNoiseTSD,'s'),5*Data(GndNoiseTSD)/max(Data(GndNoiseTSD))+5,'b')
        Ep=or(WeirdNoiseEpoch,GndNoiseEpoch);
        hold on, plot(Range(Restrict(GndNoiseTSD,Ep),'s'),5*Data(Restrict(GndNoiseTSD,Ep))/max(Data(GndNoiseTSD))+5,'w','Linewidth',2)
        
        hold on, plot(Range(NoiseTSD,'s'),5*Data(NoiseTSD)/max(Data(NoiseTSD))+15,'b')
        hold on, plot(Range(Restrict(NoiseTSD,NoiseEpoch),'s'),5*Data(Restrict(NoiseTSD,NoiseEpoch))/max(Data(NoiseTSD))+15,'w','Linewidth',2)
        
        disp(['total noise time = ',num2str(sum(Stop(or(or(NoiseEpoch,GndNoiseEpoch),WeirdNoiseEpoch),'s')-Start(or(or(NoiseEpoch,GndNoiseEpoch),WeirdNoiseEpoch),'s'))),'s.'])
        Ok=input('--- Are you satisfied with all Noise Epochs (y/n)? ','s');
        %close(hf)
        %close(Nf)
    end
    TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
    TotalNoiseEpoch=mergeCloseIntervals(TotalNoiseEpoch,1*1E4);
    save('StateEpochSubStages', '-append','NoiseEpoch','GndNoiseEpoch','NoiseThresh', 'GndNoiseThresh','WeirdNoiseEpoch','TotalNoiseEpoch');
end

%% manipulate epochs
disp(' ');
try
    ThetaEp;
    ImmobEp;
    MovEp;
    disp('... Epochs have been manipulated in terms of drop and merge');
catch
    disp('...Manipulating epochs in terms of drop and merge');
    % theta
    ThetaEp=mergeCloseIntervals(ThetaEpoch,1*1E4);
    ThetaEp=dropShortIntervals(ThetaEp,1*1E4);
    
    % movement
    ImmobEp=dropShortIntervals(ImmobEpoch,2*1E4);
    ImmobEp=mergeCloseIntervals(ImmobEp,1*1E4);
    MovEp=mergeCloseIntervals(MovEpoch,2*1E4);
    ImmobEp=ImmobEp-MovEp;
    ImmobEp=dropShortIntervals(ImmobEp,2*1E4);
    
    % SWS 
    SWSEp=ImmobEp-ThetaEpoch;
    SWSEp=mergeCloseIntervals(SWSEp,2*1E4);
    SWSEp=dropShortIntervals(SWSEp,2*1E4);
    % REM
    REMEp=and(ImmobEp,ThetaEpoch);
    REMEp=mergeCloseIntervals(REMEp,2*1E4);
    REMEp=dropShortIntervals(REMEp,2*1E4);
    
    save('StateEpochSubStages', '-append','ThetaEp','ImmobEp','MovEp','REMEp','SWSEp');
    
end

%% Determine state Epochs
disp(' ')
try
    SWSEpoch;
    REMEpoch;
    disp('... SWSEpoch and REMEpoch exist, skipping this step.')
    
catch
    disp('... Creating SWSEpoch and REMEpoch.')
    Ok='r';
    DropREM2save=[];
    
    while Ok~='y'
        
        % ---------------------------
        % - Automatic Sleep scoring -
        
        if Ok=='r'
            SWSEpoch=mergeCloseIntervals(SWSEp,5*1E4); 
            SWSEpoch=dropShortIntervals(SWSEpoch,8*1E4);   
            REMEpoch=mergeCloseIntervals(REMEp,5*1E4);
            REMEpoch=dropShortIntervals(REMEpoch,5*1E4);   
        end
        
        % --------- prepare Display Noise ---------
        MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(TotalNoiseEpoch)));
        MatT=MatD;
        for s=1:length(Start(TotalNoiseEpoch))
            temp=Restrict(Mmov,subset(TotalNoiseEpoch,s));
            MatD(1:length(Range(temp)),s)=Data(temp);
            MatT(1:length(Range(temp)),s)=Range(temp,'s');
        end
        NoiseMat=[MatT(:),MatD(:)];
        
        % --------- prepare Display SWS ---------
        MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(SWSEpoch)));
        MatT=MatD;
        for s=1:length(Start(SWSEpoch))
            temp=Restrict(Mmov,subset(SWSEpoch,s));
            MatD(1:length(Range(temp)),s)=Data(temp);
            MatT(1:length(Range(temp)),s)=Range(temp,'s');
        end
        SwsMat=[MatT(:),MatD(:)];
        
        % --------- prepare Display REM ---------
        MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(REMEpoch)));
        MatT=MatD;
        for s=1:length(Start(REMEpoch))
            temp=Restrict(Mmov,subset(REMEpoch,s));
            MatD(1:length(Range(temp)),s)=Data(temp);
            MatT(1:length(Range(temp)),s)=Range(temp,'s');
        end
        RemMat=[MatT(:),MatD(:)];
        
        
        
        % ---------------------------
        % --------- Display ---------
        figure(Gf), subplot(3,1,2), hold off, plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
        hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
        
        hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b'); 
        hold on, plot(NoiseMat(:,1),ratio_display_mov*NoiseMat(:,2)+5,'w')
        hold on, plot(SwsMat(:,1),ratio_display_mov*SwsMat(:,2)+5,'r')
        hold on, plot(RemMat(:,1),ratio_display_mov*RemMat(:,2)+5,'g')
        
        if isempty(Start(REMEpoch))==0
            subplot(3,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 10],'color','g','linewidth',1)
            hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,REMEpoch))+5,'g');
            RgREMEpoch=Start(REMEpoch,'s');
            for i=1:length(Start(REMEpoch))
                hold on, text(RgREMEpoch(i),9,num2str(i),'Color','g')
            end
        end
        title('Wake=cyan, SWS=red, REM=green');       
        
        
        % --------------------
        % --- verification --- 
        
        disp(['There are ',num2str(length(Start(SWSEpoch))),' SWS and ',num2str(length(Start(REMEpoch))),' REM epochs.']);
        Ok=input('--- Are you satisfied with the sleep scoring (y/n, r to restart automatic scoring ) ? ','s');
        
        % Change parameters
        if Ok=='n'
            % --------------------- SWS ---------------------
            Okk=input('--- Are you satisfied with the SWS (y/n) ? ','s');
            while Okk~='y'
                clear SWSEpoch
                disp('Click Start (odd) and End (even) time for Slow-wave Sleep on figure.');
                figure(Gf), title('Click Start and End of SWS. (indicative Wake=cyan, SWS=red, REM=green)');
                SWSEpoch=ginput;
                SWSEpoch=IntervalSet(SWSEpoch(1:2:end,1)*1E4,SWSEpoch(2:2:end,1)*1E4);
                Okk=input('--- Are you satisfied with the just chosen SWS (y/n) ? ','s');
            end
            
            % --------------------- REM ---------------------
            Okk=input('--- Are you satisfied with the REM sleep (y/n or m to drop some intervals) ? ','s');
            if Okk=='m'
                DropREM=input(['Give list of intervals to drop from REM (TotalNumber=',num2str(length(Start(REMEpoch))),'): ']);
                DropREM2save=[DropREM2save DropREM];
                REMEpoch=[Start(REMEpoch),End(REMEpoch)];
                REMEpoch(DropREM,:)=[];
                REMEpoch=intervalSet(REMEpoch(:,1),REMEpoch(:,2));
            elseif Okk=='n'
                while Okk~='y'
                    clear REMEpoch
                    disp('Click Start (odd) and End (even) time for REM Sleep on figure.');
                    figure(Gf), title('Click Start and End of SWS. (indicative Wake=cyan, SWS=red, REM=green)');
                    REMEpoch=ginput;
                    REMEpoch=IntervalSet(R(floor(REMEpoch(1:2:end,1)*1250)),R(floor(REMEpoch(2:2:end,1)*1250)));
                    Okk=input('--- Are you satisfied with the just chosen REM sleep (y/n) ? ','s');
                end
            end
        end
    end
    SLEEPuMvtEpoch=and(or(SWSEpoch,REMEpoch),MovEp);  
    SLEEPuMvtEpoch=mergeCloseIntervals(SLEEPuMvtEpoch,1E3);
    save('StateEpochSubStages','-append','SWSEpoch','REMEpoch', 'DropREM2save','SLEEPuMvtEpoch');
    disp('Done')
end

%% NREMSubStages
try
    WAKE;
    REM;
    N1;
    N2;
    N3;
    disp('... N1 N2 N3 already exist, skipping this step.')
    
catch
    disp('... Creating NREMsubstages')
    [op,NamesOp,Dpfc,E,noise]=FindNREMepochsML;
    %NamesOp={'PFsupOsci','PFdeepOsci','BurstDelta','REM','WAKE','SWS','PFswa','OBswa'}
    [Epochs,nameEpochs]=DefineSubStages(op,noise);
    %nameEpochs={'N1','N2','N3','REM','WAKE','SWS','swaPF','swaOB','TOTSleep'}
    N1=Epochs{1}; N2=Epochs{2}; N3=Epochs{3}; REM=Epochs{4}; WAKE=Epochs{5}; SWS=Epochs{6}; 
    [SleepStages,FinalEpochs,nameFinal]=PlotPolysomnoML(N1,N2,N3,SWS,REM,WAKE);
    %nameFinal={'WAKE','REM','N1','N2','N3'};
    % WAKE=4, REM=3, N1=2, N2=1.5, N3=1, undetermined/noise=0
    
    save('StateEpochSubStages','-append','N1','N2','N3','REM','WAKE','SWS');
    disp('Done')
end

% transition WAKE -> REM
Sta=[];
for ep=1:5
    if ~isempty(FinalEpochs{ep})
        Sta=[Sta ; [Start(FinalEpochs{ep},'s'),zeros(length(Start(FinalEpochs{ep})),1)+ep] ];
    end
end
if ~isempty(Sta)
    Sta=sortrows(Sta,1);
    ind=find(diff(Sta(:,2))==0);
    Sta(ind+1,:)=[];
    
    % check WAKE -> REM transition
    a=find([Sta(:,2);0]==2 & [0;Sta(:,2)]==1 );
    ep='';if ~isempty(a),ep=[ep,' Warning! t=[',sprintf(' %g',floor(Sta(a-1,1))),' ]s'];end
    disp([sprintf('%d transitions WAKE -> REM ',length(a)),ep]);
end

% -----------------------
figure(Gf),close
%% ---- Final display ----

% --------- prepare Display Noise ---------
if 0
    MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(TotalNoiseEpoch)));
    MatT=MatD;
    for s=1:length(Start(TotalNoiseEpoch))
        temp=Restrict(Mmov,subset(TotalNoiseEpoch,s));
        MatD(1:length(Range(temp)),s)=Data(temp);
        MatT(1:length(Range(temp)),s)=Range(temp,'s');
    end
    NoiseMat=[MatT(:),MatD(:)];
end

% --------- prepare Display SWS ---------
MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(SWS)));
MatT=MatD;
for s=1:length(Start(SWS))
    temp=Restrict(Mmov,subset(SWS,s));
    MatD(1:length(Range(temp)),s)=Data(temp);
    MatT(1:length(Range(temp)),s)=Range(temp,'s');
end
SwsMat=[MatT(:),MatD(:)];

% --------- prepare Display REM ---------
MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(REM)));
MatT=MatD;
for s=1:length(Start(REM))
    temp=Restrict(Mmov,subset(REM,s));
    MatD(1:length(Range(temp)),s)=Data(temp);
    MatT(1:length(Range(temp)),s)=Range(temp,'s');
end
RemMat=[MatT(:),MatD(:)];


% --------- prepare Display Noise ---------
if 0
    MatD=nan(ceil(1E4/mean(diff(Range(Mmov,'s')))),length(Start(SLEEPuMvtEpoch)));
    MatT=MatD;
    for s=1:length(Start(SLEEPuMvtEpoch))
        temp=Restrict(Mmov,subset(SLEEPuMvtEpoch,s));
        MatD(1:length(Range(temp)),s)=Data(temp);
        MatT(1:length(Range(temp)),s)=Range(temp,'s');
    end
    uMvtMat=[MatT(:),MatD(:)];
end

% --------- display --------- 
figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),
subplot(2,1,1),imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]);
title('Spectrogramm');

subplot(2,1,2), hold off, plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b');
try hold on, plot(NoiseMat(:,1),ratio_display_mov*NoiseMat(:,2)+5,'w');end
hold on, plot(SwsMat(:,1),ratio_display_mov*SwsMat(:,2)+5,'r')
hold on, plot(RemMat(:,1),ratio_display_mov*RemMat(:,2)+5,'g')
try hold on, plot(uMvtMat(:,1),ratio_display_mov*uMvtMat(:,2)+5,'c');end
title('SleepMicroMovement=cyan, SWS=red, REM=green');
