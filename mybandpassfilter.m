% Input: EEG (LFP) raw data
% Output: bandpass theta filtered signal
% Dec 2008
function f_eeg=mybandpassfilter(eeg,freq_min,freq_max,smplrate,order)
  ufreq=2.*freq_min/smplrate;       % correct for sample rate 
  ofreq=2.*freq_max/smplrate;
  [bb, ba] = butter(order, [ufreq ofreq]); % design butterworth passband filter
  f_eeg=filtfilt(bb, ba, eeg);    % filter the signal 

end


  
