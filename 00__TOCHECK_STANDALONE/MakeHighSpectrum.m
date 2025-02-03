function MakeHighSpectrum(ch,Epoch)
for channel=ch
% channel=input('Bulb channel for high freq spectrum');
load(strcat('LFPData/LFP',num2str(channel),'.mat'))
display('calculating spectrum...')
params.Fs=1/median(diff(Range(LFP,'s')));
            params.err=[1 0.0500];
            params.pad=2;
            params.trialave=0;
            params.fpass=[20 200];
            params.tapers=[3 5];
            movingwin=[0.1 0.005];
            [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
            
% save('StateEpochbis.mat','Sp','t','f','channel','-append')
sptsd=tsd(t*10000,Sp);
Spectr=Restrict(sptsd,Epoch);
startg=find(f<50,1,'last');
stopg=find(f>70,1,'first');
a=Data(Spectr);
tot_ghi=tsd(Range(Restrict(Spectr,Epoch)),sum(a(:,startg:stopg)')');
tot_ghi=Restrict(tot_ghi,Epoch);
smooth_ghi=tsd(Range(tot_ghi),smooth(Data(tot_ghi),500));
save(strcat('gamma_ch_',num2str(channel),'.mat'),'smooth_ghi','Spectr','-v7.3');
end
end