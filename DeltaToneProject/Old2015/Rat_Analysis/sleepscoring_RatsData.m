% sleepscoring_RatsDats

% Output:
% StateEpoch.mat containing
%           Spectro
%           ThetaEpoch ThetaRatioTSD ThetaI ThetaThresh
%           Mmov
%           MovEpoch ImmobEpoch MovI ImmobI MovThresh
%           SWSEpoch REMEpoch

% Designed from SleepscoringML to analyse Rats Data from College de France
% obtained by Karim Benchenane and Adrien Peyrache

%% initialisation
res=pwd;
% -----------------------------
% --- load LFP ----------------

disp(' ');
disp('Loading dHPC LFP')
disp(' ');

Nlfp=5;
eval(['!gunzip ',res(end-5:end),'eeg',num2str(Nlfp),'.mat.gz'])
load(['/media/2E3B0B762A23E6AB/DataExt3/Data/Rat19/',res(end-5:end),'/',res(end-5:end),'eeg',num2str(Nlfp),'.mat'])
LFP=EEG5;
eval(['!gzip ',res(end-5:end),'eeg',num2str(Nlfp),'.mat'])


%% Spectrogramm Analysis

params.Fs=2000;
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
    save StateEpoch Spectro
end



%% Display Data

figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.6 0.7]),Gf=gcf;
subplot(3,1,1),imagesc(t,f,10*log10(Sp)'), axis xy, caxis([-50 1]);
title('Spectrogramm');


%%  load Velocity Info ------

load behavResources XS YS Vs

% Creation of acceleration vector
disp('... Creating movement Vector')
Acc=Data(Vs{1,1});
Rg=Range(Vs{1,1});

disp('... No Acceleration DownSampling');
MovAcctsd=tsd(Rg(1:end),double(abs([0;diff(Acc(1:end))])));
Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
TrackingEpoch=intervalSet(min(Range(Movtsd)),max(Range(Movtsd)));

save StateEpoch -append Movtsd TrackingEpoch

%% find theta epochs

disp(' ');
pasTheta=100; %Down sampling for theta band

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
    H(H<100)=100;
    
    ThetaRatio=abs(HilTheta)./H;
    rgThetaRatio=Range(FilTheta,'s');
    
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
        end
    end
    
    save('StateEpoch','ThetaEpoch', 'ThetaRatioTSD','ThetaI','ThetaThresh','-append');
end



%% DownSample Position XY
pasPos=15; %Down sampling position tsd

Mmov=Data(Movtsd);
rgM=Range(Movtsd);
Mmov=Mmov(1:pasPos:end);
rgM=rgM(1:pasPos:end);
Mmov=tsd(rgM,Mmov);
save('StateEpoch', 'Mmov','-append');



%% Display Data
ratio_display_mov=(max(Data(ThetaRatioTSD))-min(Data(ThetaRatioTSD)))/(max(Data(Mmov))-min(Data(Mmov)));
figure(Gf),
hold on, subplot(3,1,2), plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD),'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]); 
hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov),'b'); 
%try hold on, line([Start(TrackingEpoch,'s') Start(TrackingEpoch,'s')]',[0 20],'color','k','linewidth',2);end
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
    MovThresh=mean(Data(Mmov))+2*std(Data(Mmov));
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
            MovThresh=input(['   threshold for movement (Default= ',sprintf('%1.1E',mean(Data(Mmov))+2*std(Data(Mmov))),') : ']);
            MovI=input('   [DropShortIntervals mergeCloseIntervals] for Wake Period (Default= [5 15]) : ');
            ImmobI=input('   [DropShortIntervals mergeCloseIntervals] for Immobility Period (Default= [10 5]) : ');

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
            if AddOk=='y', disp('Enter start and stop time (s) of WeirdNoise (keyboard first for ginput)')
                keyboard
                disp('(e.g. [1,200, 400,500] to put 1-200s and 400-500s periods into noise)')
                WeirdNoise=input(': ');
                try WeirdNoiseEpoch=intervalSet(WeirdNoise(1:2:end)*1E4,WeirdNoise(2:2:end)*1E4);
                catch, keyboard; end
            else WeirdNoiseEpoch=intervalSet([],[]); 
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
    TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
    TotalNoiseEpoch=CleanUpEpoch(TotalNoiseEpoch);
save('StateEpoch', '-append','NoiseEpoch','GndNoiseEpoch','NoiseThresh', 'GndNoiseThresh','WeirdNoiseEpoch','TotalNoiseEpoch');

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
        
        hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov),'b'); 
        hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,MovEpoch)),'c');
        
        if ~isempty(Start(SWSEpoch))
            subplot(3,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 0.01],'color','r','linewidth',1)
            hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,SWSEpoch)),'r');
        end
        
        if isempty(Start(REMEpoch))==0
            subplot(3,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 0.01],'color','g','linewidth',1)
            hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,REMEpoch)),'g');
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

hold on, subplot(3,1,2), plot(Range(Mmov,'s'),ratio_display_mov*Data(Mmov),'b'); 
hold on, plot(Range(Restrict(Mmov,MovEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,MovEpoch)),'c');

if ~isempty(Start(SWSEpoch))
    subplot(3,1,2), line([Start(SWSEpoch,'s') Start(SWSEpoch,'s')],[0 0.01],'color','r','linewidth',1)
    hold on, plot(Range(Restrict(Mmov,SWSEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,SWSEpoch)),'r');
end

if isempty(Start(REMEpoch))==0
    subplot(3,1,2), line([Start(REMEpoch,'s') Start(REMEpoch,'s')],[0 0.01],'color','g','linewidth',1)
    hold on, plot(Range(Restrict(Mmov,REMEpoch),'s'),ratio_display_mov*Data(Restrict(Mmov,REMEpoch)),'g');
end
title('Wake=cyan, SWS=red, REM=green');
