function CalcGamma(Epoch,chB,mindur,filename)


load(strcat(filename,'BlbSpectrum.mat'))
fB=SpectroB{3};
tB=SpectroB{2};
SpB=SpectroB{1};


% find gamma epochs

sptsd=tsd(tB*10000,SpB);
sptsd=Restrict(sptsd,Epoch);
startg=find(fB<50,1,'last');
stopg=find(fB>70,1,'first');
startg2=find(fB<25,1,'last');
stopg2=find(fB>45,1,'first');

spdat=Data(sptsd);

tot_ghi=tsd(Range(Restrict(sptsd,Epoch)),sum(spdat(:,startg:stopg)')');
tot_ghi=Restrict(tot_ghi,Epoch);
smooth_ghi=tsd(Range(tot_ghi),smooth(Data(tot_ghi),500));


save(strcat(filename,'StateEpochSB'),'mindur','smooth_ghi','-v7.3','-append');

    


end

