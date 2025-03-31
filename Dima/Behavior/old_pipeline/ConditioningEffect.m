%ConditioningEffect - Plot some measurements that help assess the effects of PAG stimulation
%
% First plot is map of stimulations
% Second plot is freezing epochs
% Third plot is heart rate 10sec before and after first stumulations or all stimulations separated by more than a minute
% Fourth plot is ripples around stimulations
% 
% 
%  OUTPUT
%
%    Figure
%
%       See
%   
%       calib_cond_figure
% 
%       2018 by Dmitri Bryzgalov


%% Parameters

% Numbers of mice to run analysis on
Mice_to_analyze = 742;
% Get directories
Dir = PathForExperimentsERC_Dima('Cond');
Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
% Output
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out = 'ConditioningEffect';

% % 0 - show heart rate before and after stimulations of more than HBTresh seconds apart; 1 - show all
% HBAll = 0;
% % Distance between stimulations to show the heart rate (in seconds)
% HBTresh = 60;

%% Get Data

% Heart Rate data
HR = cell(1,length(Dir.path)); % Allocate memory
for i = 1:length(Dir.path{1})
    HR{i} = load([Dir.path{1}{i} '/HeartBeatInfo.mat']);
end

for i=1:length(Dir.path{1})
    LFPTime{i} = Range(HR{i}.EKG.LFP);
    LFPduration(i) = LFPTime{i}(end)-LFPTime{i}(1);
    LFPoffset(i) = LFPTime{i}(1);
end

% Concatenate HBRate (type single tsd)
for i=1:length(Dir.path{1})
    HBRateTimeTemp{i} = Range(HR{i}.EKG.HBRate);
    HBRateDataTemp{i} = Data(HR{i}.EKG.HBRate);
end
for i = 1:(length(Dir.path{1})-1)
    HBRateTimeTemp{i+1} = HBRateTimeTemp{i+1}+sum(LFPduration(1:i)+LFPoffset(i+1));
end
HBRateTime = HBRateTimeTemp{1};
for i = 2:length(Dir.path{1})
    HBRateTime = [HBRateTime; HBRateTimeTemp{i}];
end

HBRateData = HBRateDataTemp{1};
for i = 2:length(Dir.path{1})
    HBRateData = [HBRateData; HBRateDataTemp{i}];
end
HBRate = tsd(HBRateTime, HBRateData);


% Behavioral data
behavR = cell(1,length(Dir.path)); % Allocate memory
for i = 1:length(Dir.path{1})
    behavR{i} = load([Dir.path{1}{i} '/behavResources.mat']);
end

% Calculate duration, find the first timestamp ('offset') and number of indices for each test
% find also last timestaps for each session ('lasttime')
for i = 1:length(Dir.path{1})
    TimeTemp{i} = Range(behavR{i}.Ytsd);
    duration(i) = TimeTemp{i}(end) - TimeTemp{i}(1);
    offset(i) = TimeTemp{i}(1);
    lind(i) = length(TimeTemp{i});
    lasttime(i) = TimeTemp{i}(end);
end


% Stimulation plot
% Get what you need
mask = behavR{1}.mask;
ShockZone = behavR{1}.Zone{1};
Ratio_IMAonREAL = behavR{1}.Ratio_IMAonREAL;

% Concatenate PosMat (type - array) 
for i=1:length(Dir.path{1})
    PosMatTemp{i} = behavR{i}.PosMat; 
end
for i=1:(length(Dir.path{1})-1)
    PosMatTemp{i+1}(:,1) = PosMatTemp{i+1}(:,1) + (sum(duration(1:i)))/1E4 + PosMatTemp{i+1}(1,1);
end
PosMat = PosMatTemp{1};
for i = 2:length(Dir.path{1})
    PosMat = [PosMat; PosMatTemp{i}];
end

% Freezing plot
for i = 1:length(Dir.path{1})
    StartStimTemp{i} = Start(behavR{i}.TTLInfo.StimEpoch);
    EndStimTemp{i} = End(behavR{i}.TTLInfo.StimEpoch);
end

for i = 1:(length(Dir.path{1})-1)
    StartStimTemp{i+1} = StartStimTemp{i+1} + sum(LFPduration(1:i)) + LFPoffset(i+1);
    EndStimTemp{i+1} = EndStimTemp{i+1} + sum(LFPduration(1:i)) + LFPoffset(i+1);
end
StartStim = StartStimTemp{1};
EndStim = EndStimTemp{1};
for i = 2:length(Dir.path{1})
    StartStim = [StartStim; StartStimTemp{i}];
    EndStim = [EndStim; EndStimTemp{i}];
end

StimEpoch = intervalSet(StartStim, EndStim);


% Concatenate Imdifftsd (type single tsd)
for i=1:length(Dir.path{1})
    ImdifftsdTimeTemp{i} = Range(behavR{i}.Imdifftsd);
    ImdifftsdDataTemp{i} = Data(behavR{i}.Imdifftsd);
end
for i = 1:(length(Dir.path{1})-1)
    ImdifftsdTimeTemp{i+1} = ImdifftsdTimeTemp{i+1}+sum(duration(1:i)+offset(i+1));
end
ImdifftsdTime = ImdifftsdTimeTemp{1};
for i = 2:length(Dir.path{1})
    ImdifftsdTime = [ImdifftsdTime; ImdifftsdTimeTemp{i}];
end
ch = find(diff(ImdifftsdTime) < 0);
ImdifftsdData = ImdifftsdDataTemp{1};
for i = 2:length(Dir.path{1})
    ImdifftsdData = [ImdifftsdData; ImdifftsdDataTemp{i}];
end
Imdifftsd = tsd(ImdifftsdTime, ImdifftsdData);

% Concatenate FreezeAccepoch (type single tsa)
for i=1:length(Dir.path{1})
    FreezeAccEpochTempStart{i} = Start(behavR{i}.FreezeAccEpoch);
    FreezeAccEpochTempEnd{i} = End(behavR{i}.FreezeAccEpoch);
end
for i = 1:(length(Dir.path{1})-1)
    FreezeAccEpochTempStart{i+1} = FreezeAccEpochTempStart{i+1} + sum(duration(1:i)) + offset(i+1);
    FreezeAccEpochTempEnd{i+1} = FreezeAccEpochTempEnd{i+1} + sum(duration(1:i)) + offset(i+1);
end
FreezeAccEpochStart = FreezeAccEpochTempStart{1};
FreezeAccEpochEnd = FreezeAccEpochTempEnd{1};
for i = 2:length(Dir.path{1})
    FreezeAccEpochStart = [FreezeAccEpochStart; FreezeAccEpochTempStart{i}];
end
for i = 2:length(Dir.path{1})
    FreezeAccEpochEnd = [FreezeAccEpochEnd; FreezeAccEpochTempEnd{i}];
end
FreezeAccEpoch = intervalSet(FreezeAccEpochStart, FreezeAccEpochEnd);

% Concatenate ZoneEpoch (type tsa * 7 - number of Zones)
for i = 1:1:length(Dir.path{1})
    for k = 1:7
        ZoneEpochTempStart{i}{k} = Start(behavR{i}.ZoneEpoch{k});
        ZoneEpochTempEnd{i}{k} = End(behavR{i}.ZoneEpoch{k});
    end
end
for i = 1:(length(Dir.path{1})-1)
    for k=1:7
        ZoneEpochTempStart{i+1}{k} = ZoneEpochTempStart{i+1}{k} + sum(duration(1:i)) + offset(i+1);
        ZoneEpochTempEnd{i+1}{k} = ZoneEpochTempEnd{i+1}{k} + sum(duration(1:i)) + offset(i+1);
    end
end
for k=1:7
    ZoneEpochStart{k} = [ZoneEpochTempStart{1}{k}; ZoneEpochTempStart{2}{k}; ZoneEpochTempStart{3}{k}; ZoneEpochTempStart{4}{k}];
    ZoneEpochEnd{k} = [ZoneEpochTempEnd{1}{k}; ZoneEpochTempEnd{2}{k}; ZoneEpochTempEnd{3}{k}; ZoneEpochTempEnd{4}{k}];
end
for k=1:7
    ZoneEpoch{k} = intervalSet(ZoneEpochStart{k}, ZoneEpochEnd{k});
end

% Get Ripples
if exist([Dir.path{1}{1} '/Ripples.mat'])==2
    Rip = cell(1,length(Dir.path)); % Allocate memory
    for i = 1:length(Dir.path{1})
        Rip{i} = load([Dir.path{1}{i} '/Ripples.mat']);
    end

    for i=1:(length(Dir.path{1})-1)
        Rip{i+1}.ripples(:,1) = Rip{i+1}.ripples(:,1) + (sum(LFPduration(1:i)))/1E4 + LFPoffset(i+1);
        Rip{i+1}.ripples(:,2) = Rip{i+1}.ripples(:,2) + (sum(LFPduration(1:i)))/1E4 + LFPoffset(i+1);
        Rip{i+1}.ripples(:,3) = Rip{i+1}.ripples(:,3) + (sum(LFPduration(1:i)))/1E4 + LFPoffset(i+1);
    end
    ripples = Rip{1}.ripples;
    for i = 2:length(Dir.path{1})
        ripples = [ripples; Rip{i}.ripples];
    end
else
    ripples = [];
end

%% Clear

clear behavR ch duration EndStim EndStimTemp FreezeEpochEnd FreezeEpochStart FreezeEpochTempEnd FreezeEpochTempStart ImdifftsdData...
    ImdifftsdDataTemp ImdifftsdTime ImdifftsdTimeTemp StartStimTemp TimeTemp ZoneEpochEnd ZoneEpochStart ZoneEpochTempEnd...
    ZoneEpochTempStart PosMatTemp HR HBRateTimeTemp HBRateDataTemp HBRateTime HBRateData Rip

%% Housekeeping
res=pwd;
fh = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

%% Number and place of stimulations

StimT_beh = find(PosMat(:,4)==1);

subplot(221)
imagesc(mask)
colormap gray
hold on
imagesc(ShockZone, 'AlphaData', 0.3);
hold on
for i = 1:length(StimT_beh)
    plot(PosMat(StimT_beh(i),2)*Ratio_IMAonREAL, PosMat(StimT_beh(i),3)*Ratio_IMAonREAL, 'k*')
end
set(gca,'XTickLabel', [], 'YTickLabel', []);
title([num2str(length(StimT_beh)) ' stimulations'])

%% Stimulation-induced freezing
if isempty(Start(StimEpoch))
    subplot(222)
    text(0.4, 0.4, 'No stimulations','FontWeight', 'bold','FontSize',14);
else
    subplot(222)
    plot(Range(Imdifftsd,'s'), zeros(length(Imdifftsd), 1));
    ylim([0 1]); 
    hold on
    for k=1:length(Start(FreezeAccEpoch))
        h1 = plot(Range(Restrict(Imdifftsd,subset(FreezeAccEpoch,k)),'s'),Data(Restrict(Imdifftsd,subset(FreezeAccEpoch,k)))...
        *0+max(ylim)*0.5,'c','linewidth',2);
    end
    h2 = plot(PosMat(PosMat(:,4)==1,1),PosMat(PosMat(:,4)==1,1)*0+max(ylim)*0.6,'k*');
    if exist('ZoneEpoch')
        for k=1:length(Start(ZoneEpoch{1}))
            h3 = plot(Range(Restrict(Imdifftsd,subset(ZoneEpoch{1},k)),'s'),Data(Restrict(Imdifftsd,subset(ZoneEpoch{1},k)))...
            *0+max(ylim)*0.65,'r','linewidth',2);
        end
        for k=1:length(Start(ZoneEpoch{2}))
            h4 = plot(Range(Restrict(Imdifftsd,subset(ZoneEpoch{2},k)),'s'),Data(Restrict(Imdifftsd,subset(ZoneEpoch{2},k)))...
            *0+max(ylim)*0.65,'g','linewidth',2);
        end
    end
    legend([h1 h2 h3 h4], 'Freezing', 'Stims', 'Shock', 'NoShock', 'Location', 'NorthEast');
    xlabel('Time (s)');
    set(gca, 'YTickLabel', []);
    title('Stimulation-induced freezing');
end

%% Calculate and plot mean heart rate 10 sec before the first and the last stimulation
%  Commented - HR around the stimulations separated by a minute (or only
%  the first one, if you don't have any) OR ALL

Stims = Start(StimEpoch);
if isempty(Stims)
    subplot(223)
    text(0.4, 0.4, 'No stimulations','FontWeight', 'bold','FontSize',14);
else
    EpochBefore = intervalSet(Stims(1)-10E4, Stims(1));
    EpochAfter = intervalSet(Stims(end)-10E4, Stims(end));
    
%     if HBAll
%         EpochBefore = intervalSet(Stims-10E4, Stims);
%         EpochAfter = intervalSet(Stims, Stims+10.2E4);
%     else
%         ch = diff(Stims);
%         idx = find(ch>HBTresh*1E4);
%         if isempty(idx)
%             EpochBefore = intervalSet(Stims(1)-10E4, Stims(1));
%             EpochAfter = intervalSet(Stims(1), Stims(1)+10.2E4);
%         else
%             EpochBefore = intervalSet(Stims(idx)-10E4, Stims(idx));
%             EpochAfter = intervalSet(Stims(idx), Stims(idx)+10.2E4);
%         end
%     end
   
    RateBefore = Restrict(HBRate, EpochBefore);
    RateAfter = Restrict(HBRate, EpochAfter);
   
    avRateBefore = mean(Data(RateBefore));
    stdRateBefore = std(Data(RateBefore));
    avRateAfter = mean(Data(RateAfter));
    stdRateAfter = std(Data(RateAfter));

    subplot(223)
    bar([avRateBefore avRateAfter], 'FaceColor', 'k')
    hold on
    errorbar([avRateBefore avRateAfter], [stdRateBefore stdRateAfter],'.', 'Color', 'r');
    hold on
    set(gca,'Xtick',[1,2],'XtickLabel',{'First Shock', 'Last Shock'})
    ylabel('Heart Rate (Hz)')
    xlim([0.5 2.5]);
    ylim([5 15]);
    title ('Heart Rate 10 sec before shock');
end

%% PETH Stim-Ripples
if isempty(Stims)
    subplot(224)
    text(0.4, 0.4, 'No stimulations','FontWeight', 'bold','FontSize',14);
elseif isempty(ripples)
    subplot(224)
    text(0.4, 0.4, 'No ripples','FontWeight', 'bold','FontSize',14);
else
    
    S = ts(ripples(:,2)*1E4);
    center = ts(Start(StimEpoch));
    TStart = -3E4;
    TEnd = 3E4;

    is = intervalSet(Range(center)+TStart, Range(center)+TEnd);
    sweeps = intervalSplit(S, is, 'OffsetStart', TStart);

    rasterAx = subplot(224);
    set(gca, 'FontName', 'Arial');
    set(gca, 'FontWeight', 'bold');
    set(gca, 'FontSize', 10);
    RasterPlot(sweeps,'AxHandle', rasterAx,'FigureHandle', fh, 'TStart', TStart, 'TEnd', TEnd, 'LineWidth', 2);
    xlim([-3000 3000]);
    xlabel('Time (ms)')

    title('Peri-stimulation ripples')
end

%% Supertitleedit
mtit(fh, ['Mouse ' num2str(Mice_to_analyze) '- Conditioning sessions'], 'fontsize',16);

%% Save figure
saveas(fh, [dir_out fig_out '.fig']);
saveFigure(fh,fig_out,dir_out);

%% Clear
clear