load('/media/mobsrick/DataMOBS87/Mouse-797/09112018/Hab/LFPData/LFP21.mat');
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
[Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);

 
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
[Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
mkdir('SpectrumDataL/');
save('SpectrumDataL/Spectrum21.mat', 'Sp', 't', 'f', 'params', 'movingwin', 'suffix', '-v7.3');

% Get indices
ind_610 = find(f>6&f<10);
Sp_610 = Sp(:,ind_610);
Stsd_610=tsd(t*1E4,Sp_610);

ind_36 = find(f>3&f<6);
Sp_36 = Sp(:,ind_36);
Stsd_36=tsd(t*1E4,Sp_36);

% Power
LFPpower610 = mean(Sp_610,2);
LFPpower610std = std(Sp_610,0,2);
LFPpower610tsd = tsd(t*1E4,LFPpower610);

LFPpower36 = mean(Sp_36,2);
LFPpower36std = std(Sp_36,0,2);
LFPpower36tsd = tsd(t*1E4,LFPpower36);

%% Plot
% Ratio
rat = LFPpower610./LFPpower36;
rattsd = tsd(t*1E4,rat);
figure
plot(t,runmean(rat,50));