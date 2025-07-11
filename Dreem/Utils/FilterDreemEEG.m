function  EEGf=FilterDreemEEG(EEG,freq,fi)


% Filtering EEG for dreem headband

% INPUTS:
% EEG: EEG signals to be filtered
% freq: Bandpass use to filter the data (must be: [L H], with L and H frequencies used by the filter)
% fi: optional, designs an fi'th order lowpass, see "help fir1" for details, defauft
% value 96
% 
% OUTPUTS:
% EEGf: filtered LFP
% 


Fn=1/(median(diff(Range(EEG,'s'))));

try
    fi;
catch
    fi=96;
end



b = fir1(fi,freq*2/Fn);

dEeg = filtfilt(b,1,Data(EEG));
rg = Range(EEG);

if length(rg) ~= length(dEeg)
	disp('Attention!!!')
end

EEGf = tsd(rg,dEeg);

