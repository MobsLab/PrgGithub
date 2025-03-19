
function Respi = BreathingFrequency_From_Accelerometer_BM(LFP_X , LFP_Y , LFP_Z , BreathingFrequency)

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

[params,movingwin,~]=SpectrumParametersBM('low');
[Sp,t,f]=mtspecgramc(LFP_mixed,movingwin,params);
[~,ind] = max(Sp');

Respi = f(ind);


