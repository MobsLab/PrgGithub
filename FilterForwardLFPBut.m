function  EEGf=FilterForwardLFPBut(EEG,freq,fi,a)


% Filtering Local Field Potential
%
% EEGf=FilterForwardLFP(EEG,freq,fi)
%   same as FilterLFP, but only forward filtering (FilterLFP is a zero-phase digital filter)
%
% INPUTS:
% EEG: Local field potential to be filtered
% freq: Bandpass use to filter the data (must be: [L H], with L and H frequencies used by the filter)
% fi: optional, designs an fi'th order lowpass, see "help fir1" for details, defauft
% value 96
% 
% OUTPUTS:
% EEGf: filtered LFP
% 
% copyright (c) 2009 Karim Benchenane
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

try
    a;
catch
    a=1;
end

Fn=1/(median(diff(Range(EEG,'s'))));

try
    fi;
catch
    fi=96;
end



b = butter(fi,freq*2/Fn);

dEeg = filter(b,a,Data(EEG));
rg = Range(EEG);

if length(rg) ~= length(dEeg)
	disp('Attention!!!')
end

EEGf = tsd(rg,dEeg);

end