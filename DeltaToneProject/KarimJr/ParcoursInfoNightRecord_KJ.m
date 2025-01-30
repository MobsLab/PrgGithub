%ParcoursInfoNightRecord_KJ

clear

%prefix = '/home/karim/Documents/';
prefix = '/Volumes/';

%% Path
a=0;
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

nb_records = a;

%Selected Mice
selected_mice = [243 244];

binsize = 100; %E-4s

figure, hold on
ncol = ceil(nb_records/2);
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
    
    pathi = Dir.path{manip};
    ResInfo.path{manip} = pathi(end-16:end);

    %Load data
    load SpikeData
    eval(['load SpikesToAnalyse/PFCx_Neurons'])
    NumNeurons=number;
    binSize=10;
    
    %Extract Spikes info
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q=MakeQfromS(ST,binsize);

    ResInfo.meanFirng{manip} = mean(full(Data(Q))); % mean
    ResInfo.maxFirng{manip} = max(full(Data(Q))); % max
    ResInfo.medianFirng{manip} = median(full(Data(Q))); %median
    
    subplot(2, ncol, manip), hold on
    y = full(Data(Q));
    y = smooth(y,20);
    x = (1:length(y)) * (binsize * 1E-4);
    plot(x, y)
    title(ResInfo.path{manip})
        
end
