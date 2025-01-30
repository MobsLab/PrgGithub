%ParcoursDeltaDownLink_KJ


% clear

prefix = '/home/karim/Documents/'; 
%prefix = '/Volumes/';

%% Path
a=0;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244']; % Mouse 244 - Day 1
Dir.mouse{a}=244;

% a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243']; % Mouse 243 - Day 2
% Dir.mouse{a}=243;
% a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244']; % Mouse 244 - Day 2
% Dir.mouse{a}=244;
% 
% a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243']; % Mouse 243 - Day 3
% Dir.mouse{a}=243;
% a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244']; % Mouse 244 - Day 3    
% Dir.mouse{a}=244;
% 
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243']; % Mouse 243 - Day 4
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244']; % Mouse 244 - Day 4
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243']; % Mouse 243 - Day 5
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244']; % Mouse 244 - Day 5
Dir.mouse{a}=244;

nb_records = a;

% Selected Mice
selected_mice = [243 244];

% params
binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 2000;
mergeGap = 10; % merge
predown_size = 30;
tbefore = 500; %time before down init, in E-4s
tafter = 500; %time after down end
%Delta
minDeltaDuration = 50;
freqDelta=[1 5];

% data all records
all_down_durations = [];
all_amplitude_diff = [];
all_amplitude_deep = [];
all_amplitude_sup = [];

ncol = ceil(a / 2);
figure, hold on
% Loop over all experiments
for manip=1:length(Dir.path)
    %current folder with experiment data
    if ~ismember(Dir.mouse{manip}, selected_mice)
       continue 
    end
    disp('  ')
    disp(Dir.path{manip})
    disp(' ')
    cd(Dir.path{manip})
    tit = Dir.path{manip};
   
    %Load data
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP
    load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    LFPsup=LFP;
    clear LFP
    clear channel
    load StateEpochSB SWSEpoch
    load SpikeData
    eval('load SpikesToAnalyse/PFCx_Neurons')
    NumNeurons=number;
    clear number
    
    %% LFP
    % find factor to increase EEGsup signal compared to EEGdeep
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
        k=k+1;
    end
    Factor=find(distance==min(distance))*0.1;

    %Diff
    EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
    Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
    Filt_diff = Restrict(Filt_diff,SWSEpoch);
    Filt_diff = tsd(Range(Filt_diff),max(Data(Filt_diff),0));
    pos = Data(Filt_diff);
    std_diff = std(pos(pos>0));

    %Deep
    EEGsleepDeep=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep)),100); 
    Filt_deep = FilterLFP(EEGsleepDeep, freqDelta, 1024);
    Filt_deep = Restrict(Filt_deep,SWSEpoch);
    Filt_deep = tsd(Range(Filt_deep),max(Data(Filt_deep),0));
    pos = Data(Filt_deep);
    std_deep = std(pos(pos>0));

    %Sup
    EEGsleepSup=ResampleTSD(tsd(Range(LFPsup),Data(LFPsup)),100); 
    Filt_sup = FilterLFP(EEGsleepSup, freqDelta, 1024);
    Filt_sup = Restrict(Filt_sup,SWSEpoch);
    Filt_sup = tsd(Range(Filt_sup),max(-Data(Filt_sup),0));
    pos = Data(Filt_sup);
    std_sup = std(pos(pos>0));

    clear pos
    
    
    %% Find downstates
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
    Q = Restrict(Q, SWSEpoch);
    %Down
    Down = FindDown2_KJ(Q, thresh0, thresh1, minDownDur,maxDownDur, mergeGap, predown_size);
    down_durations = End(Down,'ms') - Start(Down,'ms');
    largeDown = intervalSet(Start(Down)-tbefore,End(Down)+tafter);
    
    %% Extract data
    nbDown = length(down_durations);
    
    clear signal_diff signal_deep signal_sup
    for i=1:nbDown
        if mod(i,5000)==0
            disp(num2str(i))
        end
        subDown = subset(largeDown,i);
        signal_diff{i} = Restrict(Filt_diff,subDown);
        signal_deep{i} = Restrict(Filt_deep,subDown);
        signal_sup{i} = Restrict(Filt_sup,subDown);
    end
    

    amplitude_diff = cellfun(@(v)maxThresholdOfDuration(v,minDeltaDuration),signal_diff);
    amplitude_deep = cellfun(@(v)maxThresholdOfDuration(v,minDeltaDuration),signal_deep);
    amplitude_sup = cellfun(@(v)maxThresholdOfDuration(v,minDeltaDuration),signal_sup);

    amplitude_diff = amplitude_diff / std_diff;
    amplitude_deep = amplitude_deep / std_deep;
    amplitude_sup = amplitude_sup / std_sup;
    
    %gather data
    all_down_durations = [all_down_durations down_durations'];
    all_amplitude_diff = [all_amplitude_diff amplitude_diff];
    all_amplitude_deep = [all_amplitude_deep amplitude_deep];
    all_amplitude_sup = [all_amplitude_sup amplitude_sup];
    
    disp(['nb down ' num2str(length(down_durations))])
    disp(['nb diff ' num2str(length(amplitude_diff))])
    disp(['nb deep ' num2str(length(amplitude_deep))])
    disp(['nb sup ' num2str(length(amplitude_sup))])
    
end


%% Correlation
[r_diff, p_diff] = corrcoef(all_down_durations, all_amplitude_diff);
r_diff = r_diff(1,2);
p_diff = p_diff(1,2);
[r_deep, p_deep] = corrcoef(all_down_durations, all_amplitude_deep);
r_deep = r_deep(1,2);
p_deep = p_deep(1,2);
[r_sup, p_sup] = corrcoef(all_down_durations, all_amplitude_sup);
r_sup = r_sup(1,2);
p_sup = p_sup(1,2);
%fit
poly_diff = polyfit(all_down_durations, all_amplitude_diff,1);
y_diff = polyval(poly_diff,all_down_durations);
poly_deep = polyfit(all_down_durations, all_amplitude_diff,1);
y_deep = polyval(poly_deep,all_down_durations);
poly_sup = polyfit(all_down_durations, all_amplitude_diff,1);
y_sup = polyval(poly_sup,all_down_durations);


%% plot
%scatter plot
figure, hold on
subplot(2,3,1),hold on
scatter(all_down_durations, all_amplitude_diff, '*')
hold on,plot(all_down_durations, y_diff)
text(500,6,['R=' num2str(r_diff)])
xlabel('Down duration'),ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Diff')

subplot(2,3,2),hold on
scatter(all_down_durations, all_amplitude_deep, '*')
hold on,plot(all_down_durations, y_deep)
text(500,6,['R=' num2str(r_deep)])
xlabel('Down duration'),ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Deep')

subplot(2,3,3),hold on
scatter(all_down_durations, all_amplitude_sup, '*')
hold on,plot(all_down_durations, y_sup)
text(500,6,['R=' num2str(r_sup)])
xlabel('Down duration'),ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Sup')
hold on,

%density plot
subplot(2,3,4),hold on
[values, center] = hist3([all_amplitude_diff' all_down_durations'], {0:0.5:8 0:50:1000});
imagesc(center{2}, center{1}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Diff')

subplot(2,3,5),hold on
[values, center] = hist3([all_amplitude_deep' all_down_durations'], {0:0.5:8 0:50:1000});
imagesc(center{2}, center{1}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Deep')

subplot(2,3,6),hold on
[values, center] = hist3([all_amplitude_sup' all_down_durations'], {0:0.5:8 0:50:1000});
imagesc(center{2}, center{1}, log(values))
set(gca,'YDir','normal'), colorbar
xlabel('Down duration'), ylabel('Delta max Std crossing')
xlim([0 700]), ylim([0 8])
title('Sup')

