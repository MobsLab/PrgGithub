data=cell(1,9);
time_per=[0 33 405 ; 0 34 500 ; 10 0 662 ; 10 1 812 ; 10 5 658 ; 10 7 39 ; 10 7 844 ; 10 8 844 ; 10 28 120 ; 10 29 250 ; 11 27 36 ; 11 28 150 ; 11 49 214 ; 11 50 822 ; 12 38 305 ; 12 39 526 ; 239 5 784 ; 239 7 722];
for i= 1:9
tps1 = (time_per(i*2-1,1)*60000+time_per(i*2-1,2)*1000+time_per(i*2-1,3))*10;
tps2 = (time_per(i*2,1)*60000+time_per(i*2,2)*1000+time_per(i*2,3))*10;
Epoch=intervalSet(tps1,tps2);
%     Epoch=Epoch-NoiseEpoch;
% Epoch=Epoch-GndNoiseEpoch;
data{i}=Data(Restrict(LFPtest,Epoch));
times{i}=Range(Restrict(LFPtest,Epoch));
figure(3)
subplot(5,2,i)
plot(times{i},data{i})
% [tpeaks,tDeltaP2,tDeltaT2,t,brst]=FindExtremPeaks(LFP,2,Epoch);
end

clear pow2
for k=0:10
Fs=1/median(diff(Range(LFPtest,'s')));
Epoch=intervalSet(12000E4+1000e4*k,12000E4+1000e4*(k+1));
Epoch=Epoch-NoiseEpoch;
Epoch=Epoch-GndNoiseEpoch;
y=Data(Restrict(LFPtest,Epoch));
NFFT=1024*4;
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2);
pow=abs(Y(1:NFFT/2)*2);
pow2(k+1,:)=abs(Y(1:NFFT/2)*2);
end
figure(50)
imagesc(f, [0 10], pow2)
xlim([0 20])
Epoch=intervalSet(15778E4,15796E4);

%%%%%
voie=cell(1,7);
voie{1}='21';
voie{2}='23';
voie{3}='20';
voie{4}='22';
voie{5}='31';
voie{6}='29';
voie{7}='24';

for v=1:7
    v
load (strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/LFPData/LFP',voie{v},'.mat'))
LFPtest=ResampleTSD(LFP,250);

  
  %% initial method
  disp('init method')
std1=1.5; %peak frequencies
smoothfact=10;
std2=1;% times domain
std2_high=2; %times domain  - at least one peak
std3=1; %freq domain
peak_no_single_freq=3;
peak_no_multi_freq=3;
inter_freq_interval=0.3;
min_spindle_length=0.4;
min_num_peaks=2;
min_num_peaks_high=0;
min_inter_spindle=0.3;

%Peak fct
Epoch=SWSEpoch-GndNoiseEpoch-NoiseEpoch;
globalvar_sq=std(Data(Restrict(LFPtest, Epoch)).^2);
globalmean_sq=mean(Data(Restrict(LFPtest, Epoch)).^2);
[tpeaks,tDeltaP2,tDeltaT2,t,brst]=FindExtremPeaks(LFPtest,std1,Epoch);
% plot(Range(LFP), Data(LFP))
% hold on
% scatter(Range(tDeltaP2),Data(tDeltaP2)*100+3000, 50,(Data(tDeltaP2)))
% scatter(Range(tDeltaT2),Data(tDeltaT2)*100+3000, 50,(Data(tDeltaT2)))


% find 3 consecutive peaks
alltimes=[Range(tDeltaT2,'s') ;Range(tDeltaP2,'s')];
allfreq=[Data(tDeltaT2) ;Data(tDeltaP2)];

time_freq_bef=[alltimes allfreq];
time_freq_after=[];
for j=1:10
    time_freq_int=time_freq_bef(time_freq_bef(:,2)==2*j+1,:);
    time_freq_int_sorted=sort(time_freq_int,1);
    brst = burstinfo_2(time_freq_int_sorted(:,1), 1/(2*j+1),inf,peak_no_single_freq);
    Epoch=intervalSet(brst.t_start, brst.t_end);
    time_freq_rest=tsd(time_freq_int_sorted(:,1),time_freq_int_sorted(:,2));
    time_freq_rest=Restrict(time_freq_rest, Epoch);
    time_freq_after=[time_freq_after ; [Range(time_freq_rest) Data(time_freq_rest)]];
end
% merge across freq
time_freq_all=sortrows(time_freq_after,1);
brst_all_freq = burstinfo_2(time_freq_all(:,1), inter_freq_interval,inf,peak_no_multi_freq);


    %get rid of shorties
brst_all_freq.t_start=brst_all_freq.t_start(brst_all_freq.dur>min_spindle_length);
brst_all_freq.t_end=brst_all_freq.t_end(brst_all_freq.dur>min_spindle_length);
brst_all_freq.n=brst_all_freq.n(brst_all_freq.dur>min_spindle_length);
brst_all_freq.dur=brst_all_freq.dur(brst_all_freq.dur>min_spindle_length);

    Epoch=intervalSet(brst_all_freq.t_start, brst_all_freq.t_end);
    time_freq_final_rest=tsd(time_freq_all(:,1),time_freq_all(:,2));
    time_freq_final_rest=Restrict(time_freq_final_rest, Epoch);
    time_freq_final=[Range(time_freq_final_rest) Data(time_freq_final_rest)];
 
%     plot(Range(LFP), Data(LFP))
%  hold on
%  scatter(time_freq_bef(:,1)*10000,time_freq_bef(:,2)*100+3000,'r')
%  scatter(time_freq_after(:,1)*10000,time_freq_after(:,2)*100+5000,'k')
%  scatter(time_freq_final(:,1)*10000,time_freq_final(:,2)*100+7000,'g')
%  a=0;
%  
%  a=a+1; xlim([a*0.5e6 0.5e6*(a+1)])


    target=4; %seconds
    nopeak=[];
%get rid of 1/f sections and too small amplitudes
for k=2:length(brst_all_freq.t_start)-1
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
time=Range(Restrict(LFPtest,Epoch));
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
timesq=Range(Restrict(LFPtest,Epochsq));
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

% is there a change in entropy?



if size(Peaks)~=0 & size(Peaks_time,2)>min_num_peaks & size(Peaks_time_high,2)>min_num_peaks_high
nopeak=[nopeak k];
end

figure(1)
clf(1)
subplot(1,2,1)
plot(time,y)
hold on
scatter(time_freq_final(:,1)*10000,zeros(1,length(time_freq_final(:,1))), 50,'c')
scatter(PeaksTime_time,sqrt(Peaks_time),'g')
xlim([time(1) time(end)])
hold on
plot(brst_all_freq.t_start(k)*10000,0,'.','color','r','linewidth',5)
plot(brst_all_freq.t_end(k)*10000,0,'.','color','r','linewidth',5)
subplot(1,2,2)
pow=pow(1:300);
f=f(1:300);
plot(f,pow)
xlim([0 50])
hold on
plot(f,smoothpow,'r','linewidth',3)
plot(f,ones(length(f))*1*var,'k')
plot(f,ones(length(f))*2*var,'c')
scatter(PeaksTime_freq,Peaks_freq)
pause
end

% get rid of 1/fs


brst_all_freq_nonoise.t_start=brst_all_freq.t_start(nopeak);
brst_all_freq_nonoise.t_end=brst_all_freq.t_end(nopeak);
brst_all_freq_nonoise.n=brst_all_freq.n(nopeak);
brst_all_freq_nonoise.dur=brst_all_freq.dur(nopeak);

 
 Epoch=intervalSet(brst_all_freq_nonoise.t_start, brst_all_freq_nonoise.t_end);
    time_freq_final_rest=tsd(time_freq_final(:,1),time_freq_final(:,2));
    time_freq_final_rest=Restrict(time_freq_final_rest, Epoch);
    time_freq_final=[Range(time_freq_final_rest) Data(time_freq_final_rest)];
        
        
clear event1
event1.time=[ brst_all_freq_nonoise.t_start  brst_all_freq_nonoise.t_end ]';
event1.time=event1.time(:);

for i=1:length(brst_all_freq_nonoise.t_start)
    
   event1.description{i}='spinstart';
      event1.description{i+length(brst_all_freq_nonoise.t_start)}='spinstop';

end
SaveEvents(strcat('Sophie_spindles.evt.s', voie{v}),event1)



end

%looking at spindles
for k=2:length(brst_all_freq_nonoise.t_end)-1
interval=brst_all_freq_nonoise.t_end(k)-brst_all_freq_nonoise.t_start(k);
if interval<target
updown=(target-interval)/2;
Epoch=intervalSet((brst_all_freq_nonoise.t_start(k)-updown)*10000,(brst_all_freq_nonoise.t_end(k)+updown)*10000);
if (brst_all_freq_nonoise.t_end(k)+updown)>brst_all_freq_nonoise.t_start(k+1)
    updown=(brst_all_freq_nonoise.t_start(k+1)-brst_all_freq_nonoise.t_end(k))/2;
end
if (brst_all_freq_nonoise.t_start(k)-updown)<brst_all_freq_nonoise.t_end(k-1)
    updown=min(updown,(brst_all_freq_nonoise.t_start(k)-brst_all_freq_nonoise.t_end(k-1))/2);
end
else
Epoch=intervalSet(brst_all_freq_nonoise.t_start(k)*10000,brst_all_freq_nonoise.t_end(k)*10000);
end
time=Range(Restrict(LFPtest,Epoch));
y=Data(Restrict(LFPtest,Epoch));

clf
subplot(1,2,1)
plot(time,y)
hold on
plot(brst_all_freq_nonoise.t_start(k)*10000,0,'.','color','r','linewidth',5)
plot(brst_all_freq_nonoise.t_end(k)*10000,0,'.','color','r','linewidth',5)
 scatter(time_freq_final(:,1)*10000,time_freq_final(:,2)*100+2000,'g')
 xlim([time(1) time(end)])
y=y.^2;
subplot(1,2,2)
plot(time,y)
hold on
plot(brst_all_freq_nonoise.t_start(k)*10000,0,'.','color','r','linewidth',5)
plot(brst_all_freq_nonoise.t_end(k)*10000,0,'.','color','r','linewidth',5)
plot(time,(globalmean+globalvar)*ones(1,length(time)));
pause
end



