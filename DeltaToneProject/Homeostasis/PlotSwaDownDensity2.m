%%PlotSwaDownDensity2
% 18.09.2018 KJ
%
% Infos
%   plot correlation between down states density and swa, for different frequency band 
%
% see
%   PlotSwaDownDensity
%

clear

%% Down density
load('DownState.mat','down_PFCx')
load('IdFigureData2.mat', 'night_duration')
    
%params       
windowsize = 60E4; %60s
intervals_start = 0:windowsize:night_duration;
x_intervals = (intervals_start + windowsize/2)/(3600E4);
    
%density
start_down = ts(Start(down_PFCx));
density_down = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
    density_down(t) = length(Restrict(start_down,intv))/60; %per sec
end


% 
DownDens=tsd(x_intervals*3600*1E4, rescale(density_down,0,1));



%% deep

%load deep spectrum
load('ChannelsToAnalyse/PFCx_deep.mat')
load(['Spectra/Specg_ch' num2str(channel) '.mat'])
if exist('Spectro','var')
    fd = Spectro{3};
    td = Spectro{2};
    Spd = Spectro{1};
else
    fd = f;
    td = t;
    Spd = Sp;
end

idd01=find(fd>0.01&fd<1);
idd12=find(fd>1&fd<2);
idd23=find(fd>2&fd<3);
idd34=find(fd>3&fd<4);
idd45=find(fd>4&fd<5);



%% sup

%load sup spectrum
load('ChannelsToAnalyse/PFCx_sup.mat')
load(['Spectra/Specg_ch' num2str(channel) '.mat'])
if exist('Spectro','var')
    fs = Spectro{3};
    ts = Spectro{2};
    Sps = Spectro{1};
else
    fs = f;
    ts = t;
    Sps = Sp;
end

ids01=find(fs>0.01&fs<1);
ids12=find(fs>1&fs<2);
ids23=find(fs>2&fs<3);
ids34=find(fs>3&fs<4);
ids45=find(fs>4&fs<5);













