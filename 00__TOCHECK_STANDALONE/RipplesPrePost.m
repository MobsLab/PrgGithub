% -------------------------------------------
%  LOAD, GET RIPPLES & BASELINE STATS
% -------------------------------------------

% Load and band-pass filter LFP (pre)
lfp_pre = GetLFP([0 Inf],'channels',14);
DBInsertVariable(lfp_pre,'SPWR-Sleep-008-20070425-01','LFP_pre','Hippocampal LFP during sleep prior to stimulations','channel 14',{'GetLFP'});
figure;PlotXY(lfp_pre);xlim([0 max(lfp_pre(:,1))]);
DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','LFP_pre','Hippocampal LFP during sleep prior to stimulations','channel 14',{'GetLFP'},'onlypng','on');
filtered_pre = FilterLFP(lfp_pre,'passband',[80 250]);
% Compute and plot ripple stats (pre)
[ripples_pre,sd] = FindRipples(filtered_pre);
DBInsertVariable(ripples_pre,'SPWR-Sleep-008-20070425-01','ripples_pre','Ripples during sleep prior to stimulations','channel 14',{'FilterLFP','FindRipples'});
SaveRippleEvents('ripples.rpl.evt',ripples_pre,14);
[maps_pre,data_pre,stats_pre] = RippleStats(filtered_pre,ripples_pre);
PlotRippleStats(ripples_pre,maps_pre,data_pre,stats_pre);
DBInsertFigure(2,'SPWR-Sleep-008-20070425-01','ripple_pre_stats1','Ripple descriptive stats (1) prior to stimulations','channel 14',{'RippleStats','PlotRippleStats'});
DBInsertFigure(3,'SPWR-Sleep-008-20070425-01','ripple_pre_stats2','Ripple descriptive stats (2) prior to stimulations','channel 14',{'RippleStats','PlotRippleStats'});

% Load and band-pass filter LFP (post)
lfp_post = GetLFP([0 Inf],'channels',14);
figure;PlotXY(lfp_post);xlim([0 max(lfp_post(:,1))]);
DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','LFP_post','Hippocampal LFP during sleep following stimulations','channel 14',{'GetLFP'},'onlypng','on');
filtered_post = FilterLFP(lfp_post,'passband',[80 250]);
% Compute and plot ripple stats (post)
ripples_post = FindRipples(filtered_post,'stdev',sd);
DBInsertVariable(ripples_post,'SPWR-Sleep-008-20070425-01','ripples_post','Ripples during sleep following stimulations','channel 14',{'FilterLFP','FindRipples'});
SaveRippleEvents('ripples.rpl.evt',ripples_post,14);
[maps_post,data_post,stats_post] = RippleStats(filtered_post,ripples_post);
PlotRippleStats(ripples_post,maps_post,data_post,stats_post);
DBInsertFigure(2,'SPWR-Sleep-008-20070425-01','ripple_post_stats1','Ripple descriptive stats (1) following stimulations','channel 14',{'RippleStats','PlotRippleStats'});
DBInsertFigure(3,'SPWR-Sleep-008-20070425-01','ripple_post_stats2','Ripple descriptive stats (2) following stimulations','channel 14',{'RippleStats','PlotRippleStats'});

%  % Load and band-pass filter LFP (pre2)
%  lfp_pre2 = GetLFP([0 Inf],'channels',14);
%  figure;PlotXY(lfp_pre2);
%  filtered_pre2 = FilterLFP(lfp_pre2,'passband',[80 250]);
%  % Compute and plot ripple stats (pre2)
%  ripples_pre2 = FindRipples(filtered_pre2);
%  SaveRippleEvents('~/ripples.rpl.evt',ripples_pre2,14);
%  [maps_pre2,data_pre2,stats_pre2] = RippleStats(filtered_pre2,ripples_pre2);
%  PlotRippleStats(ripples_pre2,maps_pre2,data_pre2,stats_pre2);

% Load and band-pass filter LFP (post2)
lfp_post2 = GetLFP([0 Inf],'channels',14);
figure;PlotXY(lfp_post2);
filtered_post2 = FilterLFP(lfp_post2,'passband',[80 250]);
% Compute and plot ripple stats (post2)
ripples_post2 = FindRipples(filtered_post2,'stdev',sd);
SaveRippleEvents('ripples.rpl.evt',ripples_post2,14);
[maps_post2,data_post2,stats_post2] = RippleStats(filtered_post2,ripples_post2);
PlotRippleStats(ripples_post2,maps_post2,data_post2,stats_post2);

% -------------------------------------------
%  FREQUENCY, AMPLITUDE & DURATION
% -------------------------------------------

% Pre-post comparison
figure;PlotDistribution2({data_pre.peakAmplitude data_post.peakAmplitude},{data_pre.peakFrequency data_post.peakFrequency});
legend('pre','post');xlabel('Amplitude');ylabel('Frequency');
DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-amplitude_pre-post','Ripple frequency and amplitude, before and after stimulations','channel 14',{'PlotDistribution2'});
figure;PlotDistribution2({data_pre.duration data_post.duration},{data_pre.peakFrequency data_post.peakFrequency});
legend('pre','post');xlabel('Duration');ylabel('Frequency');
DBInsertFigure(gcf,'SPWR-Sleep-008-20070425-01','frequency-duration_pre-post','Ripple frequency and duration, before and after stimulations','channel 14',{'PlotDistribution2'});

figure;PlotDistribution2({data_pre.peakAmplitude data_post.peakAmplitude data_post2.peakAmplitude},{data_pre.peakFrequency data_post.peakFrequency data_post2.peakFrequency});
legend('pre','post','post2');xlabel('Amplitude');ylabel('Frequency');
figure;PlotDistribution2({data_pre.duration data_post.duration data_post2.duration},{data_pre.peakFrequency data_post.peakFrequency data_post2.peakFrequency});
legend('pre','post','post2');xlabel('Duration');ylabel('Frequency');

% -------------------------------------------
%  SPECTROGRAMS & THETA/DELTA RATIOS
% -------------------------------------------

% Compute spectrogram and theta/delta ratio (pre)
[spectrogram_pre,t_pre,f_pre] = MTSpectrogram(lfp_pre);
figure;PlotColorMap(log(spectrogram_pre)',1,'x',t_pre,'y',f_pre,'cutoffs',[0 13]);ylim([0 200]);
bands_pre = SpectrogramBands(spectrogram_pre);
hold on;plot(t_pre,bands_pre.ratio*30+50,'k');
%  plot(t_pre,bands_pre.delta/400000*30+50,'b');
xlabel('pre');

% Compute spectrogram and theta/delta ratio (post)
[spectrogram_post,t_post,f_post] = MTSpectrogram(lfp_post);
figure;PlotColorMap(log(spectrogram_post)',1,'x',t_post,'y',f_post,'cutoffs',[0 13]);ylim([0 200]);
bands_post = SpectrogramBands(spectrogram_post);
hold on;plot(t_post,bands_post.ratio*30+50,'k');
%  plot(t_post,bands_post.delta/400000*30+50,'b');
xlabel('post');

%  % Compute spectrogram and theta/delta ratio (pre2)
%  [spectrogram_pre2,t_pre2,f_pre2] = MTSpectrogram(lfp_pre2);
%  figure;PlotColorMap(log(spectrogram_pre2)',1,'x',t_pre2,'y',f_pre2,'cutoffs',[0 13]);ylim([0 200]);
%  bands_pre2 = SpectrogramBands(spectrogram_pre2);
%  hold on;plot(t_pre2,bands_pre2.ratio*30+50,'k');
%  plot(t_pre2,bands_pre2.delta/400000*30+50,'b');
%  xlabel('pre2');

% Compute spectrogram and theta/delta ratio (post2)
[spectrogram_post2,t_post2,f_post2] = MTSpectrogram(lfp_post2);
figure;PlotColorMap(log(spectrogram_post2)',1,'x',t_post2,'y',f_post2,'cutoffs',[0 13]);ylim([0 200]);
bands_post2 = SpectrogramBands(spectrogram_post2);
hold on;plot(t_post2,bands_post2.ratio*30+50,'k');
%  plot(t_post2,bands_post2.delta/400000*30+50,'b');
xlabel('post2');

% -------------------------------------------
%  SEPARATE SWS, REM & MVT
% -------------------------------------------

% Correct for mouvement and REM sleep
mvt_pre=logical(zeros(size(t_pre)));
mvt_pre(t_pre>9519/25&t_pre<11208/25)=1;
mvt_post=logical(zeros(size(t_post)));
mvt_post(t_post>19574/25&t_post<21026/25)=1;
mvt_post2=logical(zeros(size(t_post2)));
mvt_post2(t_post2>27984/25&t_post2<21026/25)=1;
dlmwrite('.mvt',mvt_pre,'\t');

mvt_pre = logical(dlmread('.mvt'));

threshold = 2;
sws_pre = ~mvt_pre&(bands_pre.ratio<threshold);
rem_pre = ~mvt_pre&(bands_pre.ratio>threshold);
sws_post = ~mvt_post&(bands_post.ratio<threshold);
rem_post = ~mvt_post&(bands_post.ratio>threshold);
sws_post2 = ~mvt_post2&(bands_post2.ratio<threshold);
rem_post2 = ~mvt_post2&(bands_post2.ratio>threshold);

% -------------------------------------------
%  RIPPLE CUMULATIVE INCIDENCE
% -------------------------------------------

% Cumulative Ripple Incidence (all ripples)
tmax_pre = max(lfp_pre(:,1));
n_pre = length(bands_pre.ratio);
t_pre = (1:n_pre)/n_pre*tmax_pre;
r_pre = Accumulate(Bin(ripples_pre(:,1),[0 tmax_pre],n_pre),1,n_pre);

tmax_post = max(lfp_post(:,1));
n_post = length(bands_post.ratio);
t_post = (1:n_post)/n_post*tmax_post;
r_post = Accumulate(Bin(ripples_post(:,1),[0 tmax_post],n_post),1,n_post);

%  tmax_pre2 = max(lfp_pre2(:,1));
%  n_pre2 = length(bands_pre2.ratio);
%  t_pre2 = (1:n_pre2)/n_pre2*tmax_pre2;
%  r_pre2 = Accumulate(Bin(ripples_pre2(:,1),[0 tmax_pre2],n_pre2),1,n_pre2);

tmax_post2 = max(lfp_post2(:,1));
n_post2 = length(bands_post2.ratio);
t_post2 = (1:n_post2)/n_post2*tmax_post2;
r_post2 = Accumulate(Bin(ripples_post2(:,1),[0 tmax_post2],n_post2),1,n_post2);

p_sws_pre = round(sum(sws_pre)/length(t_pre)*100)/100;
p_rem_pre = round(sum(rem_pre)/length(t_pre)*100)/100;
p_mvt_pre = round(sum(mvt_pre)/length(t_pre)*100)/100;
%  p_sws_pre2 = round(sum(sws_pre2)/length(t_pre2)*100)/100;
%  p_rem_pre2 = round(sum(rem_pre2)/length(t_pre2)*100)/100;
%  p_mvt_pre2 = round(sum(mvt_pre2)/length(t_pre2)*100)/100;
p_sws_post = round(sum(sws_post)/length(t_post)*100)/100;
p_rem_post = round(sum(rem_post)/length(t_post)*100)/100;
p_mvt_post = round(sum(mvt_post)/length(t_post)*100)/100;
p_sws_post2 = round(sum(sws_post2)/length(t_post2)*100)/100;
p_rem_post2 = round(sum(rem_post2)/length(t_post2)*100)/100;
p_mvt_post2 = round(sum(mvt_post2)/length(t_post2)*100)/100;

% -------------------------------------------

% Plot data for all ripples
figure;plot(t_pre,cumsum(r_pre),'b');hold on;
%  plot(t_pre2,cumsum(r_pre2),'g');
plot(t_post,cumsum(r_post),'r');
plot(t_post2,cumsum(r_post2),'k');

plot(t_pre,mvt_pre*100,'b')
plot(t_pre,bands_pre.ratio*30+50,'b');
%  plot(t_pre2,mvt_pre2*100,'g')
%  plot(t_pre2,bands_pre2.ratio*30+50,'g');
plot(t_post,mvt_post*120,'r')
plot(t_post,bands_post.ratio*30+50,'r');
plot(t_post2,mvt_post2*140,'k')
plot(t_post2,bands_post2.ratio*30+50,'k');

legend(['pre SWS ' num2str(p_sws_pre) ' REM ' num2str(p_rem_pre) ' MVT ' num2str(p_mvt_pre)],['post SWS ' num2str(p_sws_post) ' REM ' num2str(p_rem_post) ' MVT ' num2str(p_mvt_post)],['post2 SWS ' num2str(p_sws_post2) ' REM ' num2str(p_rem_post2) ' MVT ' num2str(p_mvt_post2)]); % adapt

% -------------------------------------------

% Plot data for SWS
incidence_sws_pre = sum(r_pre(sws_pre))/(sum(sws_pre)*(t_pre(2)-t_pre(1)));
%  incidence_sws_pre2 = sum(r_pre2(sws_pre2))/(sum(sws_pre2)*(t_pre2(2)-t_pre2(1)));
incidence_sws_post = sum(r_post(sws_post))/(sum(sws_post)*(t_post(2)-t_post(1)));
incidence_sws_post2 = sum(r_post2(sws_post2))/(sum(sws_post2)*(t_post2(2)-t_post2(1)));
figure;plot(cumsum(r_pre(sws_pre)),'b');hold on;
plot(cumsum(r_post(sws_post)),'r');
%  plot(cumsum(r_pre2(sws_pre2)),'g');
plot(cumsum(r_post2(sws_post2)),'k');
legend(['pre ' num2str(incidence_sws_pre)],['post ' num2str(incidence_sws_post)],['post2 ' num2str(incidence_sws_post2)]); % adapt
xlabel('SWS');

% -------------------------------------------

% Plot data for REM
incidence_rem_pre = sum(r_pre(rem_pre))/(sum(rem_pre)*(t_pre(2)-t_pre(1)));
%  incidence_rem_pre2 = sum(r_pre2(rem_pre2))/(sum(rem_pre2)*(t_pre2(2)-t_pre2(1)));
incidence_rem_post = sum(r_post(rem_post))/(sum(rem_post)*(t_post(2)-t_post(1)));
incidence_rem_post2 = sum(r_post2(rem_post2))/(sum(rem_post2)*(t_post2(2)-t_post2(1)));
figure;plot(cumsum(r_pre(rem_pre)),'b');hold on;
plot(cumsum(r_post(rem_post)),'r');
%  plot(cumsum(r_pre2(rem_pre2)),'g');
plot(cumsum(r_post2(rem_post2)),'k');
legend(['pre ' num2str(incidence_rem_pre)],['post ' num2str(incidence_rem_post)],['post2 ' num2str(incidence_rem_post2)]); % adapt
xlabel('REM');

% -------------------------------------------

% Plot data for MVT
incidence_mvt_pre = sum(r_pre(mvt_pre))/(sum(mvt_pre)*(t_pre(2)-t_pre(1)));
%  incidence_mvt_pre2 = sum(r_pre2(mvt_pre2))/(sum(mvt_pre2)*(t_pre2(2)-t_pre2(1)));
incidence_mvt_post = sum(r_post(mvt_post))/(sum(mvt_post)*(t_post(2)-t_post(1)));
incidence_mvt_post2 = sum(r_post2(mvt_post2))/(sum(mvt_post2)*(t_post2(2)-t_post2(1)));
figure;plot(cumsum(r_pre(mvt_pre)),'b');hold on;
plot(cumsum(r_post(mvt_post)),'r');
%  plot(cumsum(r_pre2(mvt_pre2)),'g');
plot(cumsum(r_post2(mvt_post2)),'k');
legend(['pre ' num2str(incidence_mvt_pre)],['post ' num2str(incidence_mvt_post)],['post2 ' num2str(incidence_mvt_post2)]); % adapt
xlabel('MVT');

% -------------------------------------------
%  OLD STUFF
% -------------------------------------------

%  % Compute ripple incidence = f(threshold) using theta/spindles ratio
%  ts_ratio_pre = Smooth(bands_pre.theta./bands_pre.spindles,100);
%  ts_ratio_post = Smooth(bands_post.theta./bands_post.spindles,100);
%  ts_ratio_post2 = Smooth(bands_post2.theta./bands_post2.spindles,100);
%  baseline = median([ts_ratio_pre;ts_ratio_post;ts_ratio_post2]); % adapt
%  clear time_pre incidence_pre time_post incidence_post time_pre2 incidence_pre2 time_post2 incidence_post2;
%  j = 1;
%  x = 0:.01:2;
%  figure;
%  for i = x,
%  	threshold = baseline*i;
%  	time_pre(j) = sum(ts_ratio_pre<threshold)*tmax_pre/n_pre;
%  	incidence_pre(j) = sum(r_pre(ts_ratio_pre<threshold))/time_pre(j);
%  	time_post(j) = sum(ts_ratio_post<threshold)*tmax_post/n_post;
%  	incidence_post(j) = sum(r_post(ts_ratio_post<threshold))/time_post(j);
%  %  	time_pre2(j) = sum(ts_ratio_pre2<threshold)*tmax_pre2/n_pre2;
%  %  	incidence_pre2(j) = sum(r_pre2(ts_ratio_pre2<threshold))/time_pre2(j);
%  	time_post2(j) = sum(ts_ratio_post2<threshold)*tmax_post2/n_post2;
%  	incidence_post2(j) = sum(r_post2(ts_ratio_post2<threshold))/time_post2(j);
%  	j = j+1;
%  	subplot(2,2,1);plot(x,cumsum(r_pre).*(ts_ratio)
%  end
%  figure;
%  plot(x,incidence_pre,'b');
%  hold on;
%  plot(x,time_pre/2000,'b+');
%  plot(x,incidence_post,'r');
%  plot(x,time_post/2000,'r+');
%  %  plot(x,incidence_pre2,'g');
%  %  plot(x,time_pre2/2000,'g+');
%  plot(x,incidence_post2,'k');
%  plot(x,time_post2/2000,'k+');
%  legend('incidence pre','temps pre','incidence post','temps post'); % adapt
%  m = mean(incidence_post./incidence_pre);
%  y = ylim;y = y(2)*.9;
%  text(x(3),y,['Rapport moyen = ' num2str(m)]);
%  xlabel('Seuil');
%  ylabel('Incidence des ripples (Hz)');
%  
%  % Compute ripple incidence = f(threshold) using theta/delta ratio
%  baseline = median([bands_pre.ratio;bands_post.ratio]); % adapt
%  clear time_pre incidence_pre time_post incidence_post time_pre2 incidence_pre2 time_post2 incidence_post2;
%  j = 1;
%  x = 1:.1:10;
%  for i = x,
%  	threshold = baseline*i;
%  	time_pre(j) = sum(bands_pre.ratio<threshold)*tmax_pre/n_pre;
%  	incidence_pre(j) = sum(r_pre(bands_pre.ratio<threshold))/time_pre(j);
%  	time_post(j) = sum(bands_post.ratio<threshold)*tmax_post/n_post;
%  	incidence_post(j) = sum(r_post(bands_post.ratio<threshold))/time_post(j);
%  %  	time_pre2(j) = sum(bands_pre2.ratio<threshold)*tmax_pre2/n_pre2;
%  %  	incidence_pre2(j) = sum(r_pre2(bands_pre2.ratio<threshold))/time_pre2(j);
%  	time_post2(j) = sum(bands_post2.ratio<threshold)*tmax_post2/n_post2;
%  	incidence_post2(j) = sum(r_post2(bands_post2.ratio<threshold))/time_post2(j);
%  	j = j+1;
%  end
%  figure;
%  plot(x,incidence_pre,'b');
%  hold on;
%  plot(x,time_pre/2000,'b+');
%  plot(x,incidence_post,'r');
%  plot(x,time_post/2000,'r+');
%  %  plot(x,incidence_pre2,'g');
%  %  plot(x,time_pre2/2000,'g+');
%  plot(x,incidence_post2,'k');
%  plot(x,time_post2/2000,'k+');
%  legend('incidence pre','temps pre','incidence post','temps post'); % adapt
%  m = mean(incidence_post./incidence_pre);
%  y = ylim;y = y(2)*.9;
%  text(x(3),y,['Rapport moyen = ' num2str(m)]);
%  xlabel('Seuil');
%  ylabel('Incidence des ripples (Hz)');
%  
%  % Compute ripple incidence = f(threshold) using theta/delta ratio
%  baseline = median([bands_pre.delta;bands_post.delta]); % adapt
%  clear time_pre incidence_pre time_post incidence_post time_pre2 incidence_pre2 time_post2 incidence_post2;
%  j = 1;
%  x = 0:.01:2;
%  for i = x,
%  	threshold = baseline*i;
%  	time_pre(j) = sum(bands_pre.delta>threshold)*tmax_pre/n_pre;
%  	incidence_pre(j) = sum(r_pre(bands_pre.delta>threshold))/time_pre(j);
%  	time_post(j) = sum(bands_post.delta>threshold)*tmax_post/n_post;
%  	incidence_post(j) = sum(r_post(bands_post.delta>threshold))/time_post(j);
%  %  	time_pre2(j) = sum(bands_pre2.delta>threshold)*tmax_pre2/n_pre2;
%  %  	incidence_pre2(j) = sum(r_pre2(bands_pre2.delta>threshold))/time_pre2(j);
%  %  	time_post2(j) = sum(bands_post2.delta>threshold)*tmax_post2/n_post2;
%  %  	incidence_post2(j) = sum(r_post2(bands_post2.delta>threshold))/time_post2(j);
%  	j = j+1;
%  end
%  figure;
%  plot(x,incidence_pre,'b');
%  hold on;
%  plot(x,time_pre/2000,'b+');
%  plot(x,incidence_post,'r');
%  plot(x,time_post/2000,'r+');
%  plot(x,incidence_pre2,'g');
%  plot(x,time_pre2/2000,'g+');
%  plot(x,incidence_post2,'k');
%  plot(x,time_post2/2000,'k+');
%  legend('incidence pre','temps pre','incidence post','temps post'); % adapt
%  m = mean(incidence_post./incidence_pre);
%  y = ylim;y = y(2)*.9;
%  text(x(3),y,['Rapport moyen = ' num2str(m)]);
%  xlabel('Seuil');
%  ylabel('Incidence des ripples (Hz)');
