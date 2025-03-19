
% varargin :
% -1) we don't care, put 'result_epoch' if you want
% -2,...) ResultEpoch you want for result


function Breathing_From_Accelerometer(LFP_X , LFP_Y , LFP_Z , OB_Sp_tsd , BreathingFrequency , varargin)

% how many result epochs ?
for i=2:length(varargin)
    ResultEpoch{i-1} = varargin{i};
end
n = length(ResultEpoch);

Cols1={[0 0 1],[1 0 0],[0 1 0]};
Cols2={'b','r','g'};


LFP_X_run = tsd(Range(LFP_X) , runmean(Data(LFP_X) , 50)); % act as a first filter
LFP_X_run2 = tsd(Range(LFP_X) , runmean(Data(LFP_X) , 1e3)); % correct global lfp tendancies
LFP_X_run3 = tsd(Range(LFP_X) , movstd(Data(LFP_X) , 1e3)); % will be used for "zscoring-like" just after
LFP_X_run4 = tsd(Range(LFP_X) , (Data(LFP_X_run)-Data(LFP_X_run2))./Data(LFP_X_run3));  % zscoreing-like
LFP_X_run5 = FilterLFP(LFP_X_run4,BreathingFrequency,1024); % filter for breathing frequencies

LFP_Y_run = tsd(Range(LFP_Y) , runmean(Data(LFP_Y) , 50));
LFP_Y_run2 = tsd(Range(LFP_Y) , runmean(Data(LFP_Y) , 1e3));
LFP_Y_run3 = tsd(Range(LFP_Y) , movstd(Data(LFP_Y) , 1e3));
LFP_Y_run4 = tsd(Range(LFP_Y) , (Data(LFP_Y_run)-Data(LFP_Y_run2))./Data(LFP_Y_run3));
LFP_Y_run5 = FilterLFP(LFP_Y_run4,BreathingFrequency,1024);

LFP_Z_run = tsd(Range(LFP_Z) , runmean(Data(LFP_Z) , 50));
LFP_Z_run2 = tsd(Range(LFP_Z) , runmean(Data(LFP_Z) , 1e3));
LFP_Z_run3 = tsd(Range(LFP_Z) , movstd(Data(LFP_Z) , 1e3));
LFP_Z_run4 = tsd(Range(LFP_Z) , (Data(LFP_Z_run)-Data(LFP_Z_run2))./Data(LFP_Z_run3));
LFP_Z_run5 = FilterLFP(LFP_Z_run4,BreathingFrequency,1024);

% check if we can see respi from accelerometer lfp
figure
plot(Data(LFP_X_run5))
hold on
plot(Data(LFP_Y_run5))
plot(Data(LFP_Z_run5))
% try; xlim([10 20]); end
makepretty
xlabel('time (s)')
ylabel('amplitude (a.u.)')
title('Accelerometer LFP filtered')

% technique to choose the best lfp that captures breathing
Var32 = tsd(Range(LFP_X) , movstd(Data(LFP_X_run5) , ceil(10/median(diff(Range(LFP_X,'s')))))); 
Var33 = tsd(Range(LFP_X) , movstd(Data(LFP_Y_run5) , ceil(10/median(diff(Range(LFP_X,'s'))))));
Var34 = tsd(Range(LFP_X) , movstd(Data(LFP_Z_run5) , ceil(10/median(diff(Range(LFP_X,'s'))))));
Var = [Data(Var32) Data(Var33) Data(Var34)];
LFP_dt = [Data(LFP_X_run5) Data(LFP_Y_run5) Data(LFP_Z_run5)];
[u,v] = max(Var');

LFP_dt_1 = LFP_dt(:,1);
LFP_dt_1(v~=1) = 0;
LFP_dt_2 = LFP_dt(:,2);
LFP_dt_2(v~=2) = 0;
LFP_dt_3 = LFP_dt(:,3);
LFP_dt_3(v~=3) = 0;

LFP_mixed = sum([LFP_dt_1 LFP_dt_2 LFP_dt_3]'); % will be the sum of LFP chosen
LFP_mixed_tsd = tsd(Range(LFP_X) , zscore(LFP_mixed)');


if max(BreathingFrequency)<2.5
    [params,movingwin,~]=SpectrumParametersBM('ultralow_bm'); % low or high
else
    [params,movingwin,~]=SpectrumParametersBM('low'); % low or high
end

% define epoch without noise
figure
plot(Range(LFP_mixed_tsd,'s'),Data(LFP_mixed_tsd))

% Spectrogram from accelero channels with max variance
[Sp,t,f]=mtspecgramc(LFP_mixed,movingwin,params);
Acc_Sp_tsd = tsd(t*1e4 , Sp);


if user_confirmation
    Do_Thresh=input('Do you want to add a ThresholdedNoiseEpoch (y/n)? ','s');
else
    Do_Thresh='n';
    disp('no ThresholdedNoiseEpoch step')
end
    
% if user wants to put the threshold manually
if strcmpi(Do_Thresh,'y')
    Ok_Thresh='n';
    while strcmpi(Ok_Thresh,'n')
        
        % plot data
        subplot(4,1,4), hold off,
        plot(Range(LFP,'s'),Data(LFP))
        title(['Please place upper bound for threshold'])
        
        % User inputs superior bound
        [~,ThresholdedNoiseEpochThresh] = ginput(1);
        
        % calculate noise from ThresholdedNoiseEpochThresh
        ThresholdedNoiseEpoch = thresholdIntervals(LFP,ThresholdedNoiseEpochThresh,'Direction','Above');
        ThresholdedNoiseEpoch = mergeCloseIntervals(ThresholdedNoiseEpoch,5E4);
        hold on, plot(Range(Restrict(LFP,ThresholdedNoiseEpoch),'s'),Data(Restrict(LFP,ThresholdedNoiseEpoch)),'r')
        
        if user_confirmation
            % check if user is satisfied or wants to redefine
            Ok_Thresh=input('--- Are you satisfied with Thresholded Noise Epochs (y/n -- k for keyboard)? ','s');
            if Ok_Thresh=='k'
                disp('Type "dbcont" to continue...')
                keyboard
            end
        else
            Ok_Thresh='y';
        end
    end
    
else
    % defined as empty if user doesn't define epochs
    ThresholdedNoiseEpoch = intervalSet([],[]);
    ThresholdedNoiseEpochThresh = NaN;
end




BAR=[]; BAR2=[];
for i=1:n
    Acc_Sp_tsd_ResultEpoch{i} = Restrict(Acc_Sp_tsd , ResultEpoch{i});
    BAR = [BAR max(nanmean(Data(Acc_Sp_tsd_ResultEpoch{i})))];
    BAR2 = [BAR2 ; Cols1{i}];
end

figure
imagesc(t/60 , f , Sp'), axis xy
caxis([0 .5])
colormap jet
xlabel('time (min)')
ylabel('Frequency (Hz)')

t=Range(LFP_X);
begin=t(1)/60e4;
endin=t(end)/60e4;

if max(BreathingFrequency)<2.5
    PlotValue = .95;
else
    PlotValue = 19;
end

line([begin endin],[PlotValue PlotValue],'linewidth',10,'color','w')
for i=1:n
    sleepstart=Start(ResultEpoch{i});
    sleepstop=Stop(ResultEpoch{i});
    for k=1:length(sleepstart)
        line([sleepstart(k)/60e4 sleepstop(k)/60e4],[PlotValue PlotValue],'color',Cols1{i},'linewidth',5);
    end
end


figure
subplot(121)
for i=1:n
    plot(f , nanmean(Data(Acc_Sp_tsd_ResultEpoch{i}))/max(nanmean(Data(Acc_Sp_tsd_ResultEpoch{i}))),Cols2{i})
    hold on
end
ylim([0 1.1])
makepretty
ylabel('Power (a.u.)')
xlabel('Frequency (Hz)')
title('Breathing mean spectrum, normalized')

subplot(122)
b=bar(BAR);
b.FaceColor = 'flat';
b.CData = BAR2;
makepretty
% xticklabels({'Wake','NREM','REM'})
ylabel('Power (a.u.)')
title('Normalizing value')

a=suptitle('Breathing mean spectrum from the accelerometer'); a.FontSize=20;


for i=1:n
    OB_Sptsd_ResultEpoch{i} = Restrict(OB_Sp_tsd,ResultEpoch{i});
    [P_ResultEpoch{i},f,VBinnedPhase] = PrefPhaseSpectrum(Restrict(LFP_mixed_tsd,ResultEpoch{i}) , Data(OB_Sptsd_ResultEpoch{i}) , Range(OB_Sptsd_ResultEpoch{i},'s') , linspace(.1,20,261) , BreathingFrequency , 100); close
end

figure
for i=1:n
    subplot(1,n,i)
    imagesc([VBinnedPhase VBinnedPhase+354] , f , (10*log10(runmean([P_ResultEpoch{i} ; P_ResultEpoch{i}],5)'))); axis xy;
    % caxis([45 50])
    ylabel('Frequency (Hz)'); xlabel('Phase (degrees)')
    % title('Wake')
end

colormap jet
a=suptitle('OB Low phase preference on "breathing" from the accelerometer'); a.FontSize=20;


















