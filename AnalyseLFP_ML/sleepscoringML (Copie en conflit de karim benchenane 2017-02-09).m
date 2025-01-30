% sleepscoringML

%   Output:
% StateEpoch.mat containing
%           Spectro
%           ThetaEpoch ThetaRatioTSD ThetaI ThetaThresh
%           Mmov
%           MovEpoch ImmobEpoch MovI ImmobI MovThresh
%           SWSEpoch REMEpoch

%warning off

%% initialisation
res=pwd;
% -----------------------------
% --- load LFP ----------------

disp(' ');

disp('Choose LFP channel to analyse (best: HPC)')
try
    load('StateEpoch.mat');
    try 
        Channel_SleepScor;
    catch
        try Channel_SleepScor=Channels;catch,Channel_SleepScor=channels;end
        save('StateEpoch.mat','Channel_SleepScor','-append')
    end
catch
    InfoLFP=listLFP_to_InfoLFP_ML(res);
    disp(['list channel dHPC in neuroscope: ',num2str(InfoLFP.channel(strcmp(InfoLFP.structure,'dHPC')))])
    disp(['                     profondeur: ',num2str(InfoLFP.depth(strcmp(InfoLFP.structure,'dHPC')))])
    Channel_SleepScor= [];
    while isempty(Channel_SleepScor)==1 || isnumeric(Channel_SleepScor)==0
        Channel_SleepScor=input('-> Enter num in neuroscope: ');
    end
    try
        save StateEpoch Channel_SleepScor -append
    catch
        save StateEpoch Channel_SleepScor
    end
end


try
    clear LFP InfoLFP
    InfoLFP=listLFP_to_InfoLFP_ML(res);
    disp(['... Using Channel ',num2str(Channel_SleepScor),', Loading LFP',num2str(Channel_SleepScor),'.mat'])
    load([res,'/LFPData/LFP',num2str(Channel_SleepScor),'.mat']);
    Range(LFP);
catch
    try
        load LFPData; disp(['... Using Channel ',num2str(Channel_SleepScor),', Loading LFPData'])
        LFP=LFP{Channel_SleepScor};
        clear LFPData;
    catch, error(['cannot load LFPData.mat nor LFP',num2str(Channel_SleepScor),'.mat']); end
end



% -----------------------------
% --- load BehavResources -----

try
    load('behavResources.mat');
    if exist('useMovAcctsd','var') && useMovAcctsd==1
        Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
        disp('using MovAcctsd from INTAN for movement instead of Movtsd')
    end
    Movtsd=tsd(double(Range(Movtsd)),double(Data(Movtsd)));
    try TrackingEpoch; catch, TrackingEpoch=intervalSet(min(Range(Movtsd)),max(Range(Movtsd)));end
catch,  disp('missing behavResources.mat');keyboard;end

% -----------------------------
% --- parameters for analysis -
FreqPos=30; %aquisition video
pasPos=15; %Down sampling position tsd
pasTheta=100; %Down sampling for theta band

scrsz = get(0,'ScreenSize');



%% Spectrogramm Analysis

params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2];
params.tapers=[3 5];

disp(' ');
try
    Sp=Spectro{1};
    t=Spectro{2};
    f=Spectro{3};
    disp('... Using already existing parameters for spectrogramm.');
catch
     
    disp('... Calculating parameters for spectrogramm.');
    [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
    Spectro={Sp,t,f};
    save('StateEpoch','Spectro', '-append');
end



%% Display Data

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

    FilTheta=FilterLFP(LFP,[5 10],1024);
    FilDelta=FilterLFP(LFP,[2 5],1024); % default [3 6]
    
    HilTheta=hilbert(Data(FilTheta));
    HilDelta=hilbert(Data(FilDelta));
    
    H=abs(HilDelta);
    %H(H<100)=100;
    
    ThetaRatio=abs(HilTheta)./H;
    rgThetaRatio=Range(FilTheta,'s');
    
    %ThetaRatio=SmoothDec(ThetaRatio,50);
    %ThetaRatio=ThetaRatio(1:pasTheta:end);
    
    ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
    rgThetaRatio=rgThetaRatio(1:pasTheta:end);
    
    ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
    
    try 
        ThetaI;ThetaThresh;
    catch
        ThetaI=[10 15];
        RequiredStdFactor=1.5;
        ThetaThresh=mean(Data(ThetaRatioTSD))+RequiredStdFactor*std(Data(ThetaRatioTSD));
    end
    Ok='n';
    while Ok~='y'
        ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above');
        ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
        ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);
        figure(Gf), 
        hold off, subplot(3,1,2), plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
        hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]);
        hold on, line([Start(TrackingEpoch,'s') Start(TrackingEpoch,'s')]',[0 max(Data(ThetaRatioTSD))],'color','k','linewidth',2);
        title('Theta/Delta ratio (black), chosen thetaEpoch (red)  and  Movement (blue)');
        if ThetaThresh==mean(Data(ThetaRatioTSD))+RequiredStdFactor*std(Data(ThetaRatioTSD)), title(['Theta/Delta ratio (black) AUTOMATIC thetaEpoch (red, mean+',num2str(RequiredStdFactor),'std)  and  Movement (blue)']); end
        
        Ok=input('--- Are you satisfied with ThetaEpoch (y/n) ? ','s');
        if Ok~='y'
            ThetaThresh=input(['Give new theta threshold (AUTOMATIC=',num2str(mean(Data(ThetaRatioTSD))+RequiredStdFactor*std(Data(ThetaRatioTSD))),') :']);
            %ThetaI=input('Give new [mergeCloseIntervals dropShortIntervals] for theta (Default=[10 15]) :');
        end
    end
    
    save('StateEpoch','ThetaEpoch', 'ThetaRatioTSD','ThetaI','ThetaThresh','-append');
end



%% DownSample Position XY

try
    Mmov; 
catch
    
    Mmov=Data(Movtsd);
    rgM=Range(Movtsd);
    Mmov=Mmov(1:pasPos:end);
    rgM=rgM(1:pasPos:end);
    Mmov=tsd(rgM,Mmov);
    save('StateEpoch', 'Mmov','-append');
end


%% Display Data
ratio_display_mov=(max(Data(ThetaRatioTSD))-min(Data(ThetaRatioTSD)))/(max(Data(Mmov))-min(Data(Mmov)));
figure(Gf),
hold on, subplot(3,1,2), plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]); 
hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b'); 
try hold on, line([Start(TrackingEpoch,'s') Start(TrackingEpoch,'s')]',[0 20],'color','k','linewidth',2);end
title('Theta/Delta ratio (black) and Movement (blue)');


%% Define immobility period

disp(' ');
try
    ImmobEpoch;
    MovEpoch;

    disp('... Immobility and Wake Epochs already exist, skipping this step.');

catch
    disp('... Creating Immobility and Wake Epochs.');
    
    try
        MovThresh;MovI;ImmobI;
    catch
    MovThresh=nanmean(Data(Mmov))+2*nanstd(Data(Mmov));
    MovI=[3 15];% DropShortIntervals & mergeCloseIntervals
    ImmobI=[10 3];%DropShortIntervals & mergeCloseIntervals
    end
    
    Ok='n';
    ManualScoring={'no'};
    while Ok~='y'
        
        MovEpoch=thresholdIntervals(Mmov,MovThresh,'Direction','Above');
        MovEpoch=mergeCloseIntervals(MovEpoch,MovI(2)*1E4);
        MovEpoch=dropShortIntervals(MovEpoch,MovI(1)*1E4);
        
        ImmobEpoch=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
        ImmobEpoch=dropShortIntervals(ImmobEpoch,ImmobI(1)*1E4); 
        ImmobEpoch=mergeCloseIntervals(ImmobEpoch,ImmobI(2)*1E4);        
        ImmobEpoch= ImmobEpoch-and(MovEpoch,ImmobEpoch);
        ImmobEpoch=dropShortIntervals(ImmobEpoch,ImmobI(1)*1E4);
        
        
        % --------------------
        % --- verification --- 
        
        %figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]),
        subplot(3,1,3),
        plot(Range(Mmov,'s'),Data(Mmov)); ylim([0  max(Data(Mmov))])
        hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),Data(Restrict(Mmov,MovEpoch)),'c')
        hold on, plot(Range(Restrict(Mmov,ImmobEpoch),'s'),Data(Restrict(Mmov,ImmobEpoch)),'r'); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
        try line([Start(TrackingEpoch,'s') Start(TrackingEpoch,'s')],[0 5],'color','k','linewidth',2);end
        title('Wake period (blue) and immobility period (Red). Starts Tracking period (black)')
        
        Ok=input('--- Are you satisfied with the Immobility Epoch (y/n or m for manual) ? ','s');
        while ismember(Ok,['y' 'n' 'm'])==0
            Ok=input('--- Are you satisfied with the Immobility Epoch (y/n or m for manual) ? ','s');
        end
        
        if Ok=='n'
            MovThresh=input(['   threshold for movement (Default= ',sprintf('%1.1E',nanmean(Data(Mmov))+2*nanstd(Data(Mmov))),') : ']);
%             MovI=input('   [DropShortIntervals mergeCloseIntervals] for Wake Period (Default= [5 15]) : ');
%             ImmobI=input('   [DropShortIntervals mergeCloseIntervals] for Immobility Period (Default= [10 5]) : ');

        elseif Ok=='m'
            %figure(Gf)
            disp('Define Immobility period on figure by hand.');
            ImmobEpoch=ginput;
            ManualScoring={'yes'};
            Ok=input('--- Are you satisfied with the Immobility Epoch you just gave (y/n or m)? ','s');
            if length(ImmobEpoch)/2~=floor(length(ImmobEpoch)/2)
                Disp('Problem: not same number of starts and ends! ')
                Ok='n';
            end
            
            ImmobEpoch=ImmobEpoch*1E4;
            ImmobEpoch(ImmobEpoch(:,1)>max(Range(Mmov)),1)=max(Range(Mmov));
            ImmobEpoch(ImmobEpoch(:,1)<0,1)=0;            
            ImmobEpoch=intervalSet(ImmobEpoch(1:2:end,1),ImmobEpoch(2:2:end,1)); 
        end
        subplot(3,1,3), hold off
    end
    save('StateEpoch','MovEpoch', 'ImmobEpoch','MovI','ImmobI','MovThresh','ManualScoring','-append');
end


%% Noisy Epoch in LFP
disp(' ');
try
    NoiseEpoch;
    GndNoiseEpoch;
    WeirdNoiseEpoch;
    disp('... Noisy Epochs in LFP already exist, skipping this step.');
catch
    disp('... Finding Noisy Epochs in LFP.');
    NoiseThresh=3E5;
    GndNoiseThresh=1E6;
    WeirdNoiseThresh=3;
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
                subplot(3,1,3), hold off,
                imagesc(t,f(f<=2),10*log10(LowSp)'), axis xy,caxis([20 65]);
                
                GndNoiseTSD=tsd(t*1E4,mean(LowSp,2));
                GndNoiseEpoch=thresholdIntervals(GndNoiseTSD,GndNoiseThresh,'Direction','Above');
                
                hold on, plot(Range(GndNoiseTSD,'s'),Data(GndNoiseTSD)/max(Data(GndNoiseTSD))+1,'b')
                hold on, plot(Range(Restrict(GndNoiseTSD,GndNoiseEpoch),'s'),Data(Restrict(GndNoiseTSD,GndNoiseEpoch))/max(Data(GndNoiseTSD))+1,'*w')
                title(['0-2Hz Spectrogramm, determined Ground Noise Epochs are in white (total=',num2str(floor(10*sum(Stop(GndNoiseEpoch,'s')-Start(GndNoiseEpoch,'s')))/10),'s)']);
                Okk=input('--- Are you satisfied with Ground Noise Epochs (y/n)? ','s');
                if Okk~='y', GndNoiseThresh=input('Give a new Ground Noise Threshold (Default=1E6) : '); end
            end

            AddOk=input('Do you want to add a WeirdNoiseEpoch (y/n)? ','s');
            if AddOk=='y', 
                Okk='n';
                while Okk~='y'
                    weirdSp=Sp(:,f>10);% unexplained noise
                    subplot(3,1,3), hold off,
                    imagesc(t,f(f>10),10*log10(weirdSp)'), axis xy,caxis([20 65]);
                    
                    weirdNoiseTSD=tsd(t*1E4,smooth(mean(weirdSp,2),5));
                    WeirdNoiseEpoch=thresholdIntervals(weirdNoiseTSD,WeirdNoiseThresh,'Direction','Below');
                    WeirdNoiseEpoch=mergeCloseIntervals(WeirdNoiseEpoch,10E4);
                    WeirdNoiseEpoch=dropShortIntervals(WeirdNoiseEpoch,1E4);
                    
                    hold on, plot(Range(weirdNoiseTSD,'s'),10*Data(weirdNoiseTSD)/max(Data(weirdNoiseTSD))+15,'b')
                    hold on, plot(Range(Restrict(weirdNoiseTSD,WeirdNoiseEpoch),'s'),Data(Restrict(weirdNoiseTSD,WeirdNoiseEpoch))/max(Data(weirdNoiseTSD))+15,'+w')
                    title(['0-2Hz Spectrogramm, determined Weird Noise Epochs are in white (total=',num2str(floor(10*sum(Stop(WeirdNoiseEpoch,'s')-Start(WeirdNoiseEpoch,'s')))/10),'s)']);
                    
                    Okk=input('--- Are you satisfied with Weird Noise Epochs (y/n, m for manual)? ','s');
                    
                    if Okk~='y' && Okk~='m'
                        WeirdNoiseThresh=input('Give a new Weird Noise Threshold (Default=3) : ');
                    elseif Okk=='m'
                        disp('Enter start and stop time (s) of WeirdNoise (keyboard first for ginput)');
                        keyboard
                        disp('(e.g. [1,200, 400,500] to put 1-200s and 400-500s periods into noise)')
                        okWN=0;
                        while okWN==0
                            WeirdNoise=input(': ');
                            try
                                WeirdNoiseEpoch=intervalSet(WeirdNoise(1:2:end)*1E4,WeirdNoise(2:2:end)*1E4);
                                okWN=1;Okk='y';
                            catch
                                disp('Problem, enter start and stop time (increasing values):')
                            end
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
            
        if isempty(Start(NoiseEpoch))==0, hold on, line([Start(NoiseEpoch,'s') Start(NoiseEpoch,'s')]',[0 20],'color','k');end
        if isempty(Start(GndNoiseEpoch))==0,hold on, line([Start(GndNoiseEpoch,'s') Start(GndNoiseEpoch,'s')]',[0 20],'color','b');end
        if isempty(Start(WeirdNoiseEpoch))==0,hold on, line([Start(WeirdNoiseEpoch,'s') Start(WeirdNoiseEpoch,'s')]',[0 20],'color','c');end
        disp(['total noise time = ',num2str(sum(Stop(or(or(NoiseEpoch,GndNoiseEpoch),WeirdNoiseEpoch),'s')-Start(or(or(NoiseEpoch,GndNoiseEpoch),WeirdNoiseEpoch),'s'))),'s.'])
        Ok=input('--- Are you satisfied with all Noise Epochs (y/n)? ','s');
        %close(hf)
        %close(Nf)
    end
end
try 
    TotalNoiseEpoch;
catch
    TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
    TotalNoiseEpoch=CleanUpEpoch(TotalNoiseEpoch);
    save('StateEpoch', '-append','NoiseEpoch','GndNoiseEpoch','NoiseThresh', 'GndNoiseThresh','WeirdNoiseEpoch','TotalNoiseEpoch');
end
%% Determine state Epochs

disp(' ')
try
    SWSEpoch;
    REMEpoch;
    disp('... SWSEpoch and REMEpoch exist, skipping this step.')
    
catch
    disp('... Creating SWSEpoch and REMEpoch.')
    Ok='n';
    SWSI=[8 5];% DropShortIntervals & mergeCloseIntervals
    REMI=[5 5];% DropShortIntervals & mergeCloseIntervals
    DropREM2save=[];
    
    while Ok~='y'
        
        % ---------------------------
        % - Automatic Sleep scoring -
        
        if Ok=='n'
            SWSEpoch=ImmobEpoch-ThetaEpoch;
            SWSEpoch=dropShortIntervals(SWSEpoch,SWSI(1)*1E4);
            SWSEpoch=mergeCloseIntervals(SWSEpoch,SWSI(2)*1E4);
            
            REMEpoch=and(ImmobEpoch,ThetaEpoch);
            REMEpoch=mergeCloseIntervals(REMEpoch,REMI(2)*1E4);
            REMEpoch=dropShortIntervals(REMEpoch,REMI(1)*1E4);
        end
        
        % ---------------------------
        % --------- Display ---------
        
        figure(Gf), subplot(3,1,2), hold off, plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
        hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);
        
        hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b'); 
        hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,MovEpoch))+5,'c');
        
        if ~isempty(Start(SWSEpoch))
            subplot(3,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 10],'color','r','linewidth',1)
            hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,SWSEpoch))+5,'r');
        end
        
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
        Ok=input('--- Are you satisfied with the sleep scoring (y/n, m for manual) ? ','s');
        
        % Change parameters
        if Ok=='n'
            SWSI=input('Give [mergeCloseIntervals DropShortIntervals] for SWS (Default= [8 5]) : ');
            REMI=input('Give [mergeCloseIntervals DropShortIntervals] for REM (Default= [5 5]) : ');        
        
        % Manual determination of sleep scores by clicks on figure
        elseif Ok=='m'
           
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
    save('StateEpoch','SWSEpoch','REMEpoch', 'DropREM2save','-append');
    disp('Done')
end

% -----------------------
%% ---- Final display ----

figure(Gf), subplot(3,1,2), hold off, plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch)),'r.');
hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2); xlim([0,max(Range(ThetaRatioTSD,'s'))]);

subplot(3,1,3), hold off, plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov)+5,'b'); 
hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,MovEpoch))+5,'c');

if ~isempty(Start(SWSEpoch))
    subplot(3,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 10],'color','r','linewidth',1)
    subplot(3,1,3),hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,SWSEpoch))+5,'r');
end

if isempty(Start(REMEpoch))==0
    subplot(3,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 10],'color','g','linewidth',1)
    subplot(3,1,3),hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,REMEpoch))+5,'g');
end
title('Wake=cyan, SWS=red, REM=green');

% -----------------------
%% ---- Final display ----
disp('And now, RunSubstages !')
%RunSubstages