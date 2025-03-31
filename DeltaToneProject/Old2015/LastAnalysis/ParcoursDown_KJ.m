%ParcoursDown_KJ

clear

prefix = '/home/karim/Documents/';
%prefix = '/Volumes/';

%% Path
a=0;
%a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243']; % Mouse 243 - Day 1
%Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244']; % Mouse 244 - Day 1
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243']; % Mouse 243 - Day 2
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244']; % Mouse 244 - Day 2
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243']; % Mouse 243 - Day 3
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244']; % Mouse 244 - Day 3    
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243']; % Mouse 243 - Day 4
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244']; % Mouse 244 - Day 4
Dir.mouse{a}=244;

a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243']; % Mouse 243 - Day 5
Dir.mouse{a}=243;
a=a+1; Dir.path{a}=[prefix 'DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244']; % Mouse 244 - Day 5
Dir.mouse{a}=244;


% list of spiking thresholds to detect downstate
thresholds = 0.01:0.01:0.9;
% Bins of minimum duration for downstates
minDurBins = 1:5:600;
% Args
toplot = 0; % No plot in the loop
ch = 0; % detect downstate if MUA/nb_neurons < 0.01
%Selected Mice
selected_mice = [243 244];


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

    %Load data
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPd=LFP;
    clear LFP
    load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    LFPs=LFP;
    clear LFP
    load StateEpochSB SWSEpoch REMEpoch Wake
    load SpikeData
    eval(['load SpikesToAnalyse/PFCx_Neurons'])
    NumNeurons=number;
    binSize=10;
    
    % Find down
    [nbSWS, nbWake, DurSWS, DurWake] = FindDownThreshDuration(S,NumNeurons,SWSEpoch,Wake,binSize,thresholds,minDurBins, ch,toplot);
    if exist('nbDownSWS', 'var')
        nbDownSWS = nbDownSWS + nbSWS;
        nbDownWake = nbDownWake + nbWake;
        DurDownSWS = DurDownSWS + DurSWS;
        DurDownWake = DurDownWake + DurWake;
    else
        nbDownSWS = nbSWS;
        nbDownWake = nbWake;
        DurDownSWS = DurSWS;
        DurDownWake = DurWake;
    end
    
end

cd /Volumes/DataMOBsRAID/ProjetBreathDeltaFeedback/KJ_analysis/ParcoursDown_KJ
load DurDownSWS
load DurDownWake
load nbDownSWS
load nbDownWake
load thresholds
load minDurBins


%subplot
figure, hold on
for i=1:length(thresholds)
    hold on, subplot(8,9,i)
    hold on, plot(minDurBins, nbDownSWS(i,:), 'r','linewidth',2)
    hold on, plot(minDurBins, nbDownWake(i,:), 'k','linewidth',2)
    hold on, set(gca,'yscale','log')
    hold on, set(gca,'xscale','log')
    hold on, set(gca,'xtick',[10 50 100 500 1500])
    hold on, title(['Threshold=',num2str(thresholds(i))]) 
end
hold off


%ColorMap
results = nbDownSWS ./ (nbDownSWS + nbDownWake);
results_norm = (nbDownSWS/DurDownSWS) ./ (nbDownSWS/DurDownSWS + nbDownWake/DurDownWake);

figure, hold on

subplot(2,2,1)
imagesc(minDurBins, thresholds, results_norm)
hold on, title('Rate of SWS silence')
colorbar

subplot(2,2,2)
imagesc(minDurBins, thresholds, results)
hold on, title('Rate of SWS silence normalized')
colorbar

subplot(2,2,3)
imagesc(minDurBins, thresholds, log(nbDownSWS))
hold on, title('Number of SWS silence')
colorbar

subplot(2,2,4)
imagesc(minDurBins, thresholds, log(nbDownWake))
hold on, title('Number of Wake silence')
colorbar



