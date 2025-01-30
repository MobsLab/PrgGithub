% FindChannelDeltaDetection
% 19.12.2017 KJ
%
% - helper to find couple of channels for the detection of down states 
%
% SEE
%  PlotIDSleepData
%


clear

%params
windowsize=1000;
% mouse='403';
channels = GetDifferentLocationStructure('PFCx'); %add hemisphere eventually
load('ChannelsToAnalyse/PFCx_deep_right.mat')

suffixe = '';
%name
for ch=1:length(channels)
    name_channels{ch} = ['channel ' num2str(channels(ch))];
end

%% Load data
%LFP
for i=1:length(channels)
    ch = channels(i);
    eval(['load LFPData/LFP',num2str(ch)])
    PFC{i} = LFP;
    Signals{i} = ResampleTSD(LFP,200);
    
    clear LFP
end

%Stages
load('SleepScoring_OBGamma.mat', 'SWSEpoch')

%Down states
load('DownState.mat', ['down_PFCx' suffixe])
eval(['Down = and(down_PFCx' suffixe ',SWSEpoch);'])
down_durations = End(Down) - Start(Down);
start_down = Start(Down);
end_down = End(Down);
center_down = (Start(Down) + End(Down))/2;


%% durations
label_down{1} = '100ms';
idx_down{1} = down_durations==0.1E4;
label_down{2} = '120ms';
idx_down{2} = down_durations==0.12E4;
label_down{3} = '130-170ms';
idx_down{3} = down_durations>0.13E4 & down_durations<0.17E4;
label_down{4} = '190-230ms';
idx_down{4} = down_durations>0.19E4 & down_durations<0.23E4;
label_down{5} = '250-290ms';
idx_down{5} = down_durations>0.25E4 & down_durations<0.29E4;
label_down{6} = '>300ms';
idx_down{6} = down_durations>0.3E4;

for i=1:length(idx_down)
    stdown{i} = start_down(idx_down{i});
    enddown{i} = end_down(idx_down{i});
    centdown{i} = end_down(idx_down{i});
end

 
%% PETH on down states
for i=1:length(stdown)
    for ch=1:length(channels)
        pfc.down{ch,i} = PlotRipRaw(PFC{ch},stdown{i}/1E4, windowsize,0,0);
    end
end

for i=1:length(stdown)
    for ch=1:length(channels)
        peak_value(ch,i) = max(pfc.down{ch,i}(:,2));
    end
end


%% Look at correlation outside down states
SWSnoDown = SWSEpoch - Down;

corrVal = nan(length(channels));
meanVal = nan(length(channels));
stdVal = nan(length(channels));

for ch1=1:length(channels)-1
    for ch2=ch1+1:length(channels)
        lfp_a = Restrict(Signals{ch1}, SWSnoDown);
        lfp_b = Restrict(Signals{ch2}, SWSnoDown);
        
        %normalize
        clear distance
        k=1;
        for i=0.1:0.1:4
            distance(k)=std(Data(lfp_a)-i*Data(lfp_b));
            k=k+1;
        end
        Factor = find(distance==min(distance))*0.1;
        %resample & filter & positive value
        EEGsleepDiff = Data(lfp_a) - Factor*Data(lfp_b);
        
        %mean and std of the difference, and correlation
        meanVal(ch1,ch2) = mean(EEGsleepDiff);
        stdVal(ch1,ch2) = std(EEGsleepDiff);
        corrVal(ch1,ch2) = corr(Data(lfp_a), Data(lfp_b));
    end
end

% a=corrVal;
% a(isnan(a))=-20;
% figure, imagesc(a)

figure, 
subplot(2,2,1), imagesc(abs(meanVal)), title('mean')
subplot(2,2,2), imagesc(abs(stdVal)), title('std')
subplot(2,2,3), imagesc(corrVal), title('correlation')

idx_r = channels>31;
idx_l = channels<32;

channels_r = channels(idx_r);
corrVal_r = corrVal(idx_r,idx_r);
stdVal_r = stdVal(idx_r,idx_r);

channels_l = channels(idx_l);
corrVal_l = corrVal(idx_l,idx_l);
stdVal_l = stdVal(idx_l,idx_l);


%% Plot
for i=1:length(label_down)
    figure, hold on
    
    %mean curves around down states
    subplot(2,3,[1 2 4 5]), hold on
    for ch=1:length(channels)
        plot(pfc.down{ch,i}(:,1), pfc.down{ch,i}(:,2)), hold on
    end
    legend(name_channels)
    
    %correlation
    subplot(2,3,3)
    imagesc(corrVal), title('correlation')
    set(gca,'xtick',1:length(channels),'XTickLabel',channels,'ytick',1:length(channels),'YTickLabel',channels)
    
    %std of difference
    subplot(2,3,6)
    imagesc(abs(stdVal)), title('std')
    set(gca,'xtick',1:length(channels),'XTickLabel',channels,'ytick',1:length(channels),'YTickLabel',channels)
    
    %title
    suplabel([label_down{i} ' (' num2str(length(stdown{i})) ' down)'], 't');
end










