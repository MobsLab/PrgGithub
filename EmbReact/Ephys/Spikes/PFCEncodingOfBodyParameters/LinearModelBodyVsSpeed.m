function AllOutput = LinearModelBodyVsSpeed(Period)

%% Inputs
% Parameter : which paramater to study
%   - HR : heart rate
%   - BR : breathing rate
%   - HRV : heart rate variability
%
% Period : which period in time
%   - Freezing : all freezing from the umaze conditionning
%   - Sleep : all sleep periods
%   - Wake : all wake periods that do not involve freezing
%   - Wake_Explo : all wake outside homecage
%   - All
%

%%

% Basic parameters
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_BodyTuningCurves/';
SpBins = [-3:0.3:3];
MiceNumber=[507,508,509,510];

for mm = 1:length(MiceNumber)
    
    % Right periods
    switch Period
        case 'Freezing'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'UMazeCond');
            ToKeep = find(not(cellfun(@isempty,x1)));
            FolderList = FolderList(ToKeep);
            JustFreez = 1; % will just keep freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'Sleep'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Sleep');
            ToKeep = find(not(cellfun(@isempty,x1)));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 1; % will just keep sleep from sleep sessions
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'Wake'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Cond');
            ToKeep = find(cellfun(@isempty,x1));
            FolderList = FolderList(ToKeep);
            x2 = strfind(FolderList,'SoundTest');
            ToKeep = find(cellfun(@isempty,x2));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 1;
            RemoveFreez = 0;
            
        case 'Wake_Explo'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            x1 = strfind(FolderList,'Cond');
            ToKeep = find(cellfun(@isempty,x1));
            FolderList = FolderList(ToKeep);
            x2 = strfind(FolderList,'SoundTest');
            ToKeep = find(cellfun(@isempty,x2));
            FolderList = FolderList(ToKeep);
            x2 = strfind(FolderList,'Sleep');
            ToKeep = find(cellfun(@isempty,x2));
            FolderList = FolderList(ToKeep);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;
            
        case 'All'
            FolderList = GetAllMouseTaskSessions(MiceNumber(mm),0);
            JustFreez = 0; % will ignore freezing
            JustSleep = 0; % will get rid of sleep
            RemoveSleep = 0;
            RemoveFreez = 0;
    end
    
    % Get concatenated variables
    % Spikes
    S_concat=ConcatenateDataFromFolders_SB(FolderList,'spikes');
    % OB Spectrum - everything is realigned to this
    OBSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','B_Low');
    % NoiseEpoch
    NoiseEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','noiseepoch');
    TotalEpoch = intervalSet(0,max(Range(OBSpec_concat)));
    TotalEpoch = TotalEpoch - NoiseEp_concat;
    
    if JustFreez
        % Freezing epoch
        FzEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
        TotalEpoch = and(TotalEpoch,FzEp_concat);
    elseif RemoveFreez
        % Freezing epoch
        FzEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
        TotalEpoch = TotalEpoch - FzEp_concat;
    end
    
    if JustSleep
        % Sleep epoch
        Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
        TotalEpoch = TotalEpoch - Sleepstate{1}; % remove wake
    else RemoveSleep
        % Sleep epoch
        Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
        TotalEpoch = and(TotalEpoch,Sleepstate{1}); % just the wake
    end
    
    
    Speed=ConcatenateDataFromFolders_SB(FolderList,'accelero');
    y=interp1(Range(Speed),Data(Speed),Range(OBSpec_concat));
    Nanepoch_temp = tsd(Range(OBSpec_concat),isnan(y));
    NanEpochToRem_temp = dropShortIntervals(thresholdIntervals(Nanepoch_temp,0.5,'Direction','Above'),1*1e4);
    TotalEpoch = TotalEpoch - NanEpochToRem_temp;
    y=naninterp(y);
    Speed = tsd(Range(OBSpec_concat),y);
    
    %% Main body parameters
    
    % breathing
    instfreq_concat_PT=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
    y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),Range(OBSpec_concat));
    instfreq_concat_PT = tsd(Range(OBSpec_concat),y);
    instfreq_concat_WV=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
    instfreq_concat_WV=Restrict(instfreq_concat_WV,ts(Range(OBSpec_concat)));
    y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),Range(OBSpec_concat));
    y(y>15)=NaN;
    Nanepoch_temp = tsd(Range(OBSpec_concat),isnan(y));
    NanEpochToRem_temp = dropShortIntervals(thresholdIntervals(Nanepoch_temp,0.5,'Direction','Above'),1*1e4);
    TotalEpoch = TotalEpoch - NanEpochToRem_temp;
    
    y=naninterp(y);
    instfreq_concat_WV = tsd(Range(OBSpec_concat),y);
    instfreq_concat_Both = tsd(Range(OBSpec_concat),nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
    
    % InstFreq - heartrate and heart rate variability
    heartrate = ConcatenateDataFromFolders_SB(FolderList,'heartrate');
    heartrate_variability =  tsd(Range(heartrate),log(runmean(movstd(Data(heartrate),3),3)));
    
    y=interp1(Range(heartrate),Data(heartrate),Range(OBSpec_concat));
    Nanepoch_temp = tsd(Range(OBSpec_concat),isnan(y));
    NanEpochToRem_temp = dropShortIntervals(thresholdIntervals(Nanepoch_temp,0.5,'Direction','Above'),1*1e4);
    TotalEpoch = TotalEpoch - NanEpochToRem_temp;
    
    y = naninterp(y);
    heartrate = tsd(Range(OBSpec_concat),y);
    
    y=interp1(Range(heartrate_variability),Data(heartrate_variability),Range(OBSpec_concat));
    y(y<-10) = NaN;
    Nanepoch_temp = tsd(Range(OBSpec_concat),isnan(y));
    NanEpochToRem_temp = dropShortIntervals(thresholdIntervals(Nanepoch_temp,0.5,'Direction','Above'),1*1e4);
    TotalEpoch = TotalEpoch - NanEpochToRem_temp;
    
    y = naninterp(y);
    
    heartrate_variability = tsd(Range(OBSpec_concat),y);
    
    % restrict to same epoch
    InputVar.Speed = Data(Restrict(Speed,TotalEpoch));
    InputVar.HR = Data(Restrict(heartrate,TotalEpoch));
    InputVar.HRV = Data(Restrict(heartrate_variability,TotalEpoch));
    InputVar.Breath = Data(Restrict(instfreq_concat_Both,TotalEpoch));
    VarNames = fieldnames(InputVar);
    
    BadGuys = isnan(InputVar.Speed) | InputVar.Speed ==0 | isnan(InputVar.HR)  | isnan(InputVar.HRV)  | isnan(InputVar.Breath) ;
    Dat =         [nanzscore(InputVar.Speed),nanzscore(InputVar.HR),nanzscore(InputVar.HRV),nanzscore(InputVar.Breath)];
    Dat(BadGuys,:) = [];
    
    %% for analysis by frequency band
    freq_fft = (1/median(diff(Range(OBSpec_concat,'s'))))*(0:(length(InputVar.HR)/2))/length(InputVar.HR);
    sampling_f = logspace(log10(1/60),log10(1/0.4),10);
    
    % calculate all ffts
    for var_num = 1:length(VarNames)
        fft_var = fft(nanzscore(InputVar.(VarNames{var_num})));
        fft_var = fft_var(1:ceil(length(fft_var)/2));
        fft_var = [real(fft_var),imag(fft_var)]';
        InputVarFFT.(VarNames{var_num}) = fft_var;
    end
    
    % filter by freq band
    clear Dat_fil
    
    for f_sa = 1:length(sampling_f)-1
        % set the value soutside the range of interest to 0
        freq_id = find(freq_fft<sampling_f(f_sa),1,'last') : find(freq_fft<sampling_f(f_sa+1),1,'last');
        for var_num = 1:length(VarNames)
            F = InputVarFFT.(VarNames{var_num});
            F(:,1:freq_id(1)-1) = 0;
            F(:,freq_id(end)+1:end) = 0;
            FullFFT = [F(1,:) + i*F(2,:),fliplr(F(1,2:end) - i*F(2,2:end))];
            Recons = abs(hilbert(ifft(FullFFT)));
            Dat_fil{f_sa}(var_num,:) = Recons;
        end
    end
    
    %% Loop over neurons
    for sp=1:length(S_concat)
        [Y,X] = hist(Range(S_concat{sp}),Range(OBSpec_concat));
        spike_count = tsd(X,Y');
        spike_dat = (Data(Restrict(spike_count,TotalEpoch)));
        spike_dat(BadGuys) = [];
        
        fft_var = fft(nanzscore(spike_dat));
        fft_var = fft_var(1:ceil(length(fft_var)/2));
        fft_var = [real(fft_var),imag(fft_var)]';
        spike_fft = fft_var;
        
        [B,FitInfo] = lasso(Dat,spike_dat,'CV',10,'alpha',0.5);
        AllOutput.LinModelQual(mm,sp) =  FitInfo.MSE(FitInfo.Index1SE);
        
        mdl = fitlm(Dat,spike_dat);
        AllOutput.LinModelPValue(mm,sp,:) = mdl.Coefficients.pValue;
        
        %         lassoPlot(B,FitInfo,'PlotType','CV')
        %         yhat = Dat*B(:,FitInfo.Index1SE) + FitInfo.Intercept(FitInfo.Index1SE);
        AllOutput.LinModelWeights(mm,sp,:) =  B(:,FitInfo.Index1SE);
        
        for var = 1:4
            Dat_temp = Dat;
            Dat_temp(:,var) = [];
            [B_temp,FitInfo_temp] = lasso(Dat_temp,spike_dat,'CV',10,'alpha',0.5);
            AllOutput.LinModelQual_RemovingParams(mm,sp,var) =  FitInfo_temp.MSE(FitInfo_temp.Index1SE);
            
        end
        
        
        for f_sa = 1:length(sampling_f)-1
            % set the value soutside the range of interest to 0
            freq_id = find(freq_fft<sampling_f(f_sa),1,'last') : find(freq_fft<sampling_f(f_sa+1),1,'last');
            
            % get spikes filtered
            F = spike_fft;
            F(:,1:freq_id(1)-1) = 0;
            F(:,freq_id(end)+1:end) = 0;
            FullFFT = [F(1,:) + i*F(2,:),fliplr(F(1,2:end) - i*F(2,2:end))];
            Spike_Recons = abs(hilbert(ifft(FullFFT)));
            
            [B,FitInfo] = lasso(Dat_fil{f_sa}',Spike_Recons,'CV',10,'alpha',0.5);
            AllOutput.LinModel_FFT_Qua(mm,sp,f_sa) = FitInfo.MSE(FitInfo.Index1SE);
            mdl = fitlm(Dat,spike_dat);
            AllOutput.LinModel_FFT_PValue(mm,sp,:) = mdl.Coefficients.pValue;
            
            %             lassoPlot(B,FitInfo,'PlotType','CV')
            %             yhat = Dat_fil{f_sa}'*B(:,FitInfo.Index1SE) + FitInfo.Intercept(FitInfo.Index1SE);
            AllOutput.LinModelWeights_FFT(mm,sp,:) =  B(:,FitInfo.Index1SE);
            
            for var = 1:4
                Dat_temp = Dat_fil{f_sa}';
                Dat_temp(:,var) = [];
                [B_temp,FitInfo_temp] = lasso(Dat_temp,Spike_Recons,'CV',10,'alpha',0.5);
                AllOutput.LinModel_FFT_Qual_RemovingParams(mm,sp,f_sa,var) = FitInfo_temp.MSE(FitInfo_temp.Index1SE);
                
            end
            
        end
        
        
        
        
    end
    
    save([SaveFolder filesep 'LinearModesl_PFC_Body',Period,'.mat'],'AllOutput')
    
end


%
%
% clf
%
% corf = (abs(fft(nanzscore(heartrate))));
% plot(f,movmean(corf(1:end/2+1),50))
% hold on
% corf = (abs(fft(nanzscore(heartrate_variability))));
% plot(f,movmean(corf(1:end/2+1),50))
% corf = (abs(fft(nanzscore(breathingrate))));
% plot(f,movmean(corf(1:end/2+1),50))
% corf = (abs(fft(nanzscore(spike_dat))));
% plot(f,movmean(corf(1:end/2+1),50))
%
% set(gca,'XScale','log')
% set(gca,'YScale','log')
%
% legend('HR','HRV','Breath','PFC')