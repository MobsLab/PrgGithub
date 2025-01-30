%issu de AnalysisM207toM220  
% line 400

% this piece  of code aimed at correcting the difference btw the time of
% matlbal and the tim eof spike 2. 

% if fact, this is NOT needed  because there is a reset of time with the
% spectrogram computation (spectropgram range from 1.5 to 1400)

% more explaination in my notebook (spirales) 26.01.2015


mark_ind=strfind(FileInfo{step,m}, mark); % define the subfolder for EventInfo.mat
subfolder=[FileInfo{step,m}(mark_ind(end-1):(mark_ind(end)-1)) '-respi'];
load([cd subfolder '/EventInfo.mat'])


BegEndtime=EventInfo.time(EventInfo.evtname==5);
TotEpoch=intervalSet(0,1400*1e4);
TotEpoch2=shift(TotEpoch, BegEndtime(1)*1e4);
Ep2=shift(Ep, BegEndtime(1)*1e4);

%followed by

% plot the frequency histogram
                subplot(ha(3))
                % averaged spectro correction 'xfrequency'  (and not log) (f: Spectro{3})
                plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,TotEpoch2-Ep2))),'k','linewidth',2),hold on % non freezing period
                plot(Spectro{3},Spectro{3}.*mean(Data(Restrict(sptsd,Ep2))),'color','c','linewidth',2) % freezing period