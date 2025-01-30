
% Load piezo
load('PiezoData_SleepScoring.mat', 'Piezo_Mouse_tsd')
Piezo_Mouse_tsd = tsd(Range(Piezo_Mouse_tsd),sqrt((Data(Piezo_Mouse_tsd)-mean(Data(Piezo_Mouse_tsd))).^2));
% Load stim times
load('behavResources.mat', 'TTLInfo')
StimTime = Start(TTLInfo.StimEpoch,'s');
% Load stim ID
load('journal_stim.mat')
StimValue =  cell2mat(journal_stim(:,1));
PlotOrNot = 1;
PlotNewfig = 1;
[M,T] = PlotRipRaw(Piezo_Mouse_tsd,StimTime(StimValue==1),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);
figure
imagesc(M(:,1),1:length(StimTime(StimValue==2)),(T))


% Load accelero
load('behavResources.mat', 'MovAcctsd')
[M,T] = PlotRipRaw(MovAcctsd,StimTime(StimValue==1),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);


% Recalculate gamm no smoothing
load('ChannelsToAnalyse/Bulb_deep.mat','channel')
load([cd,'/LFPData/LFP',num2str(channel)],'LFP');
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=tsd(Range(LFP),H);

[M,T] = PlotRipRaw(tot_ghi,StimTime(StimValue==1),[-20 20]*1e3,0,PlotOrNot,PlotNewfig);

% Calculate mean activity after stim
LimsTime = [1,5];
StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
AverageGammaPostStim = mean(T(:,StartAveraging:StopAveraging),2);
LimsTime = [-5,-1];
StartAveraging = find(M(:,1)>LimsTime(1),1,'first');
StopAveraging = find(M(:,1)>LimsTime(2),1,'first');
AverageGammaPreStim = mean(T(:,StartAveraging:StopAveraging),2);




megaT = [];
megaT = [megaT ;T];
