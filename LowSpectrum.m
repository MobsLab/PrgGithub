function LowSpectrum(filename,ch)

pasTheta=100;
params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2];
params.tapers=[3 5];
load(strcat('LFPData/LFP',num2str(ch),'.mat'));
disp('... Calculating spectrogramm.');
[SpH,tH,fH]=mtspecgramc(Data(LFP),movingwin,params);
Spectro={SpH,tH,fH};
save(strcat(filename,num2str(ch),'_Spectrum.mat'),'Spectro','ch','-v7.3')

end