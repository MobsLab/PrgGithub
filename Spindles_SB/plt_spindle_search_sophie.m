    target=4; %seconds
    nopeak=[];
%get rid of 1/f sections and too small amplitudes
for k=1000:length(brst_all_freq.t_start)-1
    k
Fs=1/median(diff(Range(LFPtest,'s')));
interval=brst_all_freq.t_end(k)-brst_all_freq.t_start(k);
if interval<target
updown=(target-interval)/2;
Epoch=intervalSet((brst_all_freq.t_start(k)-updown)*10000,(brst_all_freq.t_end(k)+updown)*10000);
if (brst_all_freq.t_end(k)+updown)>brst_all_freq.t_start(k+1)
    updown=(brst_all_freq.t_start(k+1)-brst_all_freq.t_end(k))/2;
end
if (brst_all_freq.t_start(k)-updown)<brst_all_freq.t_end(k-1)
    updown=min(updown,(brst_all_freq.t_start(k)-brst_all_freq.t_end(k-1))/2);
end
else
Epoch=intervalSet(brst_all_freq.t_start(k)*10000,brst_all_freq.t_end(k)*10000);
end
y=Data(Restrict(LFPtest,Epoch));
time=Range(Restrict(LFPtest,Epoch),'s');
y=y-mean(y);
L=length(y);
NFFT=2^nextpow2(L);
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2);
pow=f'.*abs(Y(1:NFFT/2)*2);
ind1=find(f>22, 1, 'first');
ind2=find(f>60, 1, 'first');
pow=pow(1:ind2);
smoothpow=smooth(pow,smoothfact);
f=f(1:ind2);
var=mean(smoothpow)+std3*std(smoothpow);

%finding peaks in frequency domain
deriv_freq=diff(smoothpow(1:ind1))';
deriv1_freq = [deriv_freq 0];
deriv2_freq = [0 deriv_freq];
PeaksIdx_freq = find(deriv1_freq < 0 & deriv2_freq > 0);
Peaks_freq = smoothpow(PeaksIdx_freq);
PeaksTime_freq=f(PeaksIdx_freq);
PeaksTime_freq=PeaksTime_freq(Peaks_freq>var);
Peaks_freq=Peaks_freq(Peaks_freq>var);

%finding peaks in time domain
Epochsq=intervalSet(brst_all_freq.t_start(k)*10000,brst_all_freq.t_end(k)*10000);
ysq=Data(Restrict(LFPtest,Epochsq));
timesq=Range(Restrict(LFPtest,Epochsq),'s');
ysq=ysq'.^2;
deriv_time=diff(ysq);
deriv1_time = [deriv_time 0];
deriv2_time = [0 deriv_time];
PeaksIdx_time = find(deriv1_time < 0 & deriv2_time > 0);
Peaks_time = ysq(PeaksIdx_time);
PeaksTime_time=timesq(PeaksIdx_time);

PeaksTime_time=PeaksTime_time(Peaks_time>(globalvar_sq*std2+globalmean_sq));
Peaks_time=Peaks_time(Peaks_time>(globalvar_sq*std2+globalmean_sq));
Peaks_time_high=Peaks_time(Peaks_time>(globalvar_sq*std2_high+globalmean_sq));


% is there a significant change in entropy?
pe=Data(Restrict(entropy_21_6,Epochsq));
time_pe=Range(Restrict(entropy_21_6,Epochsq),'s');
deriv_pe=diff(pe');
deriv1_pe = [deriv_pe 0];
deriv2_pe = [0 deriv_pe];
PeaksIdx_pe = find(deriv1_pe > 0 & deriv2_pe < 0);
Peaks_val_pe=pe(PeaksIdx_pe);
PeaksIdx_high_pe=PeaksIdx_pe(Peaks_val_pe<(mean_entropy_21_6-2*std_entropy_21_6));




if size(Peaks_freq)~=0 & size(Peaks_time,2)>min_num_peaks & size(Peaks_time_high,2)>min_num_peaks_high & size(PeaksIdx_high_pe,2)>1
nopeak=[nopeak k];
end

figure(1)
clf(1)
subplot(1,3,1)
plot(time,y)
hold on
scatter(time_freq_final(:,1),zeros(1,length(time_freq_final(:,1))), 50,'c')
scatter(PeaksTime_time,sqrt(Peaks_time),'g')
xlim([time(1) time(end)])
hold on
plot(brst_all_freq.t_start(k),0,'.','color','r','linewidth',5)
plot(brst_all_freq.t_end(k),0,'.','color','r','linewidth',5)
subplot(1,3,2)
% pow=pow(1:300);
% f=f(1:300);
plot(f,pow)
xlim([0 50])
hold on
plot(f,smoothpow,'r','linewidth',3)
plot(f,ones(length(f))*1*var,'k')
plot(f,ones(length(f))*2*var,'c')
scatter(PeaksTime_freq,Peaks_freq)
subplot(1,3,3)
plot(Range(Restrict(entropy_21_6,Epoch),'s'),Data(Restrict(entropy_21_6,Epoch)))
hold on
plot(Range(entropy_21_6,'s'),ones(length(Range(entropy_21_6,'s')),1)*(mean_entropy_21_6-std_entropy_21_6),'c')
plot(Range(entropy_21_6,'s'),ones(length(Range(entropy_21_6,'s')),1)*(mean_entropy_21_6-2*std_entropy_21_6),'g')
plot(Range(entropy_21_6,'s'),ones(length(Range(entropy_21_6,'s')),1)*(mean_entropy_21_6-3*std_entropy_21_6),'y')
plot(brst_all_freq.t_start(k),mean_entropy_21_6,'.','color','r','linewidth',5)
plot(brst_all_freq.t_end(k),mean_entropy_21_6,'.','color','r','linewidth',5)
scatter(time_pe(PeaksIdx_high_pe),pe(PeaksIdx_high_pe),10,'k')
xlim([time(1) time(end)])
pause
end


for k=1:length(brst_all_freq_nonoise.dur)
if (brst_all_freq_nonoise.dur(k))>3
plot(Range(Restrict(LFPtest,intervalSet(brst_all_freq_nonoise.t_start(k)*10000, brst_all_freq_nonoise.t_end(k)*10000)),'s'),Data(Restrict(LFPtest,intervalSet(brst_all_freq_nonoise.t_start(k)*10000, brst_all_freq_nonoise.t_end(k)*10000))))
pause
clf
end
end