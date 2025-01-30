function LowSpectrumSB(filename,ch,struc)

%load(strcat('LFPData/LFP',num2str(ch),'.mat'));
load(strcat('SyncedData/LFP',num2str(ch),'.mat'));
params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2];
params.tapers=[3 5];
disp('... Calculating spectrogramm.');

if ~isempty(strcmp(filename, 'ProjetAversion'))
    Breath=LFP;
end

[Sp,t,f]=mtspecgramc(Data(Breath),movingwin,params);

Spectro={Sp,t,f};
save(strcat(filename,struc,'_Low_Spectrum.mat'),'Spectro','ch','-v7.3')

end