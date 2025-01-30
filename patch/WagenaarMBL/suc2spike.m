function spk = suc2spike(dat,tms,fac,t0)
% SUC2SPIKE - Extract spike times from suction electrode traces
%    spk = SUC2SPIKE(dat,tms) detects spikes in a raw electrode trace 
%    and returns spike times and amplitudes in a structure:
%
%       SPK.TMS: spike times
%       SPK.AMP: spike amplitudes
%
%    This function will return many "spikes" that are actually just noise.
%    Use SELECTSPIKES to sort this out.
%
%    spk = SUC2SPIKE(dat,tms,thr,tbin) overrides the normal factor THR=4 
%    over RMS noise and the normal bin size of TBIN=20 ms.

if nargin<3
  fac=4;
end
if nargin<4
  t0=20;
end

fs = 1/mean(diff(tms)); % Get sampling frequency


[b1,a1]=butterhigh1(50/fs);
datf = filtfilt(b1,a1,dat);

if fs>4e3
  [b2,a2]=butterlow1(2e3/fs);
  datf = filtfilt(b2,a2,datf);
end

K=ceil(t0*.001*fs); % Number of samples in 20 ms.
spki = dwgetspike(datf,[fac K 40 10*fs/1e3]);

spk.tms = tms(spki);
spk.amp = dat(spki);

