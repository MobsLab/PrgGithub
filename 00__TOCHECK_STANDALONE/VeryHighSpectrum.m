function VeryHighSpectrum(filename,ch,struc)

load(strcat(filename, 'LFPData/LFP',num2str(ch),'.mat'));
params.Fs=1/median(diff(Range(LFP,'s')));
params.err=[1 0.0500];
params.pad=2;
params.trialave=0;
params.fpass=[20 250];
params.tapers=[1 2];
movingwin=[0.1 0.005];
disp('... Calculating spectrogramm.');

[Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
Spectro={Sp,t,f};
save(strcat(filename,struc,'_VHigh_Spectrum.mat'),'Spectro','ch','-v7.3')

end