function  EEGf=FilterRythm(EEG,rythm,fi)


% Filtering
% EEG LFP a filtrer
% rythm 'theta', 'delta' 'gamma' 'beta'


Fn=1/(median(diff(Range(EEG,'s'))));

try
    fi;
catch
fi=96;
end


if rythm(1)=='t'
b = fir1(fi,[5 10]*2/Fn);
else if rythm(1)=='d'
b = fir1(fi,[1 4]*2/Fn);
else if rythm(1)=='b'
b = fir1(fi,[20 40]*2/Fn);
else if rythm(1)=='g'
b = fir1(fi,[60 80]*2/Fn);
    else if rythm(1)=='s'
b = fir1(fi,[1E-20 1E-19]*2/Fn);
        disp('ok')
        end
    end
end
end
end


dEeg = filtfilt(b,1,Data(EEG));
rg = Range(EEG);

if length(rg) ~= length(dEeg)
	keyboard;
end

EEGf = tsd(rg,dEeg);