function [sp, ac, env, taxis, effend]=mousefeat(sig,fs,tlen,tinc)
% This function computes features from the autocorrelation (AC), the power
% spectrum (PS), and envelope in windows of length LEN slid over samples in
% vector SIG.  For each window features are extracted relevant to the differences
% between the sleep and wake states which generate the signal.  The classificaiton
% is designed specifically for data from the piezo films for monitoring
% mouse motion.
%
%    [sp, ac, env, taxis, effend] = mousefeat(sig,fs,tlen,inc,lowlim,highlim,kbeta)
%
% Inputs:
% SIG - Signal for analysis (row or column vector)
% FS -  Sampling frequency
% TLEN - Analysis window length in seconds over which the Spectrum, AC, and envelope
%        are computed
% INC - Time increment to move window in seconds for new feature computations
% LOWLIM, HIGHLIM = lower and higher limit frequencies of interest (i.e. bandlimits of signal in Hz)
%                    example for speech lowlim = 50 highlim=4000 and fs=441 00
% Output variables:
% TAXIS = time axis for columns for  (Corresponding to window midpoint)
% CA =   data structure of extracted parameters from the CA
%        corresponding to TAXIS
%        ca.lfp - Low frequency lag area under the CA from .4 to 1.8 Hz
%        ca.bfp - Mid frequency lag area under the CA from 1.8 to 4 Hz
% SP =   data structure of extracted parameters from the PS
%        corresponding to TAXIS
%        sp.sp  - Position of max SP peak in the sleep range (0.9-4 Hz)
%        sp.sm  - Magnitude of max SP peak in the sleep range
%        sp.spt - Position of max SP peak in the global range of interest
%        (0.9-10 Hz)
%        sp.smt - Magnitude of max SP peak in the global range of interest
% AC =   data structure of extracted parameters from the AC
%        corresponding to TAXIS
%        ac.sp  - Position of max AC peak in the sleep range
%        ac.sm  - Magnitude of max AC peak in the sleep range
%        ac.spt - Position of max AC peak in the global range of interest 
%        ac.smt - Magnitude of max AC peak in the global range of interest
% ENV =  data structure of extracted parameters from the envelope
%        env.var - standard deviation divided by the mean of trimmed
%        envlope values (1 second off begining and end)
%        env.meanamplitude
%
%      Dependencies: comprs(), peakfind(), pspecvals()
%
%  Written by Kevin D. Donohue, December 2010 (kevin.donohue@sigsoln.com)

len = round(tlen*fs);  %  Get analysis window in samples
sampinc = tinc*fs;     %  Get increment in samples (does not have to be integer)
kbeta = 3; % Kiaser window parameter for tapering segment
%  Convert to column vector
[siglen,b]=size(sig);
if b~=1
    sig=sig';
    siglen=length(sig);
end
xclag = 1;  %  Set maximum autocorrelation lag in seconds
mxlag = round(xclag*fs)+1;  %  Convert max lag to samples

%  Get nfft length, zero pad to double length
nfft =  2;
while nfft < 2*len
    nfft = 2*nfft;
end

% Tapering window for FFT analysis of window
tapwin = kaiser(len,kbeta);
% Sleep Peak range for sleep signature peaks in SP
ufreqs = 4;   % 4 Hz upper frequency limit
lfreqs = .9;   % 0.9 Hz lower frequency limit
%  Corresponding Sleep peak range for AC
ulags = 1/lfreqs;  %  Smaller Period
llags = 1/ufreqs;  %  Larger Period

% Global range for all peaks of interest (wake and sleep)
lfreqws = .9;    %   low frequency for full range of interest
ufreqws = 10;    %   high frequency for full range of interest
%  Corresponding global peak range for AC
ulagws = 1/lfreqws;  %  Smaller Period
llagws = 1/ufreqws;  %  Larger Period

%  Envelope extraction parameters
fc = 1;  %  Lowpass filter cutoff to smooth envelope
chop = ceil(fs/fc);  %  Cutout variation due to edge effects
[eb,ea] = butter(4,2*fc/fs);
 %  Normalize frequency limits for spectral analysis
%flim = 2*[lowlim, highlim]/fs; 
flim = 2*[lfreqws, ufreqws]/fs;   % Matlab normalize frequency limits

%  Frequency Axis
fsg = fs*(0:nfft-1)/(nfft);
% Extract Axis point for full spectral range for interest
%lnlim = find(fsg<=highlim & fsg>=lowlim);
dbx = (fsg(fsg<=ufreqws & fsg>=lfreqws))';  %  Frequency axis for range of global peaks
%  Within full spectral analysis range find global peak range
%nall = find(dbx < ufreqws & dbx > lfreqws);
  
%  Compute number of Features that can be computed over input signal
num=floor((siglen-len)/(sampinc))+1;
if num < 0
    error('Data length must be longer than analysis window')
else
    mdpt = (len-1)/(2*fs); % Midpoint of analysis window (start time axis)
    taxis= []; % time axis initalize
    cnt=0;  %  Initalize index for computed features
    %  Loop through entire signal and compute features from each segment
    stwin = 1;  % Analysis window starting index
    endwin = stwin+len-1;  % Analysis window ending index  
    taxis = zeros(1,floor((siglen-len)/sampinc)); % Initalize time axis vector
    while endwin <= siglen
        cnt=cnt+1;    %  Loop counter of array index
        %  Compress signal amplitude, to limit impact of transient spikes
        [outsig] = comprs(sig(stwin:endwin), .3);
        %outsig = sig(stwin:endwin);
        lastusedendpoint = endwin;  % Indicates remainder of segment not used
        %  Update for next segment limits
        stwin = round(cnt*sampinc)+1;
        endwin = stwin + len -1;
        taxis(cnt) = mdpt + tinc*(cnt-1);
        tsig=outsig;   % extract current segment for processing
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%% Envelope parameters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Low-Pass Filter envelope to remove breathing variations
        %   (i.e. greater than 1 Hz)
        dse = filter(eb,ea,abs(hilbert(outsig)));
        %  Cut-off intial sample distorted by effective zeros a begining
        mb = mean(dse(chop:end));
        env.meanamplitude(cnt) = mb; % max(dse(chop:end));           
        env.var(cnt) = std(dse(chop:end))/(mb+eps);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%% Autocorrelation parameters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [acsig, lg] = xcorr(tsig,mxlag, 'coeff');
        %  Find Peak of AC
        [pos, mag] = peakfind(acsig(mxlag+1:end), lg(mxlag+1:end)/fs);
        %  Find AC peaks in sleep range
        lnp = find(pos < ulags & llags < pos);
        %  If none found set to 0
        if isempty(lnp)
            ac.sp(cnt) = 0;
            ac.sm(cnt) = 0;
        else  %  If found, find the max peak in the range
            [mx, ix] = max(mag(lnp));
            ac.sp(cnt) = pos(lnp(ix(1)));
            ac.sm(cnt) = mx(1);
        end
        % Find peaks over full interest range
         lnp = find(pos < ulagws & llagws < pos);
        %  If none found set ot 0
        if isempty(lnp)
            ac.spt(cnt) = 0;
            ac.smt(cnt) = 0;
        else  %  If found, find the max peak in the range
            [mx, ix] = max(mag(lnp));
            ac.spt(cnt) = pos(lnp(ix(1)));
            ac.smt(cnt) = mx(1);
        end
       
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% Spectral parameters %%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        tsig = tsig.*tapwin;  %  Taper time window for spectral analysis
        %  PS and CA
        ftsig = pspecvals(tsig,nfft,flim);
        %sp.enrg(cnt) = engr;  %  Save energy feature
        dbs = 10*log10(ftsig); %  Convert spectrum to dB
        %  Find peaks over global range of interest
       % [pos, mag] = peakfind(dbs(nall),dbx(nall));
        [pos, mag] = peakfind(dbs,dbx);
       %  Find subset of peaks in sleep range
        lnpf = find(pos < ufreqs & lfreqs < pos);
        %  If none found set ot 0
        if isempty(lnpf)
            sp.sp(cnt) = 0;
            sp.sm(cnt) = 0;
        else  %  If found, find the max peak in the range
            [mx, ix] = max(mag(lnpf));
            sp.sp(cnt) = (pos(lnpf(ix(1))));
            sp.sm(cnt) = mx(1);
        end

        %  Find Peaks in global range
        lnp = find(pos < ufreqws & lfreqws < pos);
        %  If none found set ot 0
        if isempty(lnp)
            sp.spt(cnt) = 0;
            sp.smt(cnt) = 0;
        else  %  If found, find the max peak in the range
            [mx, ix] = max(mag(lnp));
            sp.spt(cnt) = pos(lnp(ix(1)));
            sp.smt(cnt) = mx(1);
        end
    end
     % find offset (points not used) so next block is aligned
   effend = lastusedendpoint-siglen; 
end