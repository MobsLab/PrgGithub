
%Parameters
Fs = 2083;

eegLow = Data(filtEEGBand(Restrict(EEGpfc,sleep2Epoch), Fs, 1, 5));

downStInterval = findDownSt(eegLow,Fs);

startDown = Start(downStInterval);
nbEvents = length(startDown)

for t=1:nbEvents

	plot(Range(Restrict(EEGpfc,intervalSet(startDown,startDown+10000))),Data(Restrict(EEGpfc,intervalSet(startDown,startDown+10000))))

end;