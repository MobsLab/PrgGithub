% TestEffectToneLFP
% 03.10.2017 KJ
%
% for one record, show the mean curves on tones
%
% see
%   TestTimingTone2 TestTimingToneLFP TestTimingToneLFP2


clear

%params
list_channel = [8 5 7 11 1 2 24 28  21 12 13 14 15 16 17 19 18 32];
name_channel = {'Bulb deep', 'PFCx deep (r)', 'PFCx deep (r)', 'PFCx Ecog (r)', 'PFCx deep (l)', 'PFCx deep (l)', 'PaCx deep (l)', 'PaCx ECog (r)',...
                'HPC','AuCx deep', 'AuCx deep', 'AuCx sup', 'AuCx deep', 'AuCx sup', 'AuTh', 'AuTh', 'AuTh','Accelero'};
% list_channel = [16 15 17 9 13 14 10 11 18 3 7 31 26 27 64 65 66];
% name_channel = {'Bulb deep', 'Bulb sup', 'dHPC rip', 'dHPC sup', 'MoCx deep', 'MoCx sup', 'NRT deep', 'NRT sup', 'PaCx deep', 'PaCx sup'...
%                 'PFCx 1','PFCx 2','PFCx 3','PFCx deep','PFCx sup'};


%% load data

%Tones
load('DeltaSleepEvent.mat', 'TONEtime1')
load('DeltaSleepEvent.mat', 'TONEtime2')

if exist('TONEtime2','var')
    real_time = 1;
else
    real_time=0;
end

%session
load IntervalSession
sessions{1} = Session2;  sessions{2} = Session3; 


%% mean curves
for ch=1:length(list_channel)
    channel = list_channel(ch);
    %LFP
    if channel==32 %Accelero
        load 'LFPData/LFP32'
        LFPx = LFP;
        load 'LFPData/LFP33'
        LFPy = LFP;
        load 'LFPData/LFP34'
        LFPz = LFP;
        
        LFP = tsd(Range(LFPx),Data(LFPx).*Data(LFPx) + Data(LFPy).*Data(LFPy) + Data(LFPz).*Data(LFPz));
    else
        eval(['load LFPData/LFP',num2str(channel)])
    end
    for i=1:length(sessions)
        tones_tmp = Range(Restrict(ts(TONEtime1),sessions{i}));

        %nb_detect{ch,i} = length(tones_tmp);
        Md_detect{ch,i} = PlotRipRaw(LFP,tones_tmp/1E4, 1000, 0, 0);
    end
end


%% plot
figure, hold on
for ch=1:length(list_channel)
    subplot(4,5,ch), hold on
    plot(Md_detect{ch,1}(:,1), Md_detect{ch,1}(:,2));
    line([0 0],get(gca,'YLim')), hold on
    title(name_channel{ch})
end

%% plot
figure, hold on
for ch=1:length(list_channel)
    subplot(4,5,ch), hold on
    plot(Md_detect{ch,2}(:,1), Md_detect{ch,2}(:,2));
    line([0 0],get(gca,'YLim')), hold on
    line([0.5 0.5],get(gca,'YLim')), hold on
    title(name_channel{ch})
end






