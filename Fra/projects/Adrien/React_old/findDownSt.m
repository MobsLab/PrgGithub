function findDownSt = findDownSt(eegLow,Fs)

eegStd = std(eegLow)
eegMean = mean(eegLow)

eegDownTime = find(eegLow < eegMean - 2*eegStd)

ix = 2;

while ix < length(eegDownTime)

	if eegDownTime(ix) - eegDownTime(ix - 1) < Fs*0.1
		eegDownTime(ix) = [];
	end

end;

findDownSt = intervalSet(eegDownTime/Fs*10000-2000,eegDownTime/Fs*10000+8000);
