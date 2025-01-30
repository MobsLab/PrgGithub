%% Objectives of this code

% Visualise the data (OB frequency, ripples, entries in shock zone) during
% freezing safe in conditioning sessions 
% Three parts: data for a mouse than for mice in groups 1 and finally group 5 

% For each part : analyses done
% OB frequency during freezing safe interpolated along all the conditioning session
% OB frequency during freezing safe concatenated epochs
% Ripples aligned to OB frequency, cumulative curve of ripples 
% Threshold of shift in OB frequency and time passed below threshold determined for each mouse 
% Hypothesis of learning : proportional to absolute or relative time spent 
% in maze (1), freezing (2) or to number of ripples (3)
% OB mean frequency during freezing safe before and after a ripple
% Number of shock zone entries and entries aligned to fz safe (moments when
% the mouse runs back to safe zone after a shock and freezes)

%% Paths
SaveFigsTo = '/home/gruffalo/Link to Dropbox/Kteam/PrgMatlab/Ella/Analysis_Figures/';

%% Select a mice and generate its data

% Preliminary_Analysis_OBSpectrum_Freezing_BM(1189) % visualize a mouse's data
Mouse = 1189;

Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition');
end

%% Visualize the data for a mouse
% NB : below we will only treat the safe zone freezing data ({1,6} corresponds to the conditioning session safe)

% Tsd data can be studied with 
% Range to extract timepoints 
% Data to extract values

% OB frequency
ind_OB_respi = Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}); % Timepoints of the session during which freezing was observed, no information on the frequency of freezing
OB_freq = Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}); % OB frequencies during episodes of freezing, no temporal information 


%% Freezing safe along the absolute time of the experiment
% Below we will do a linear interpolation of the OB frequency during safe
% side freezing along all the conditioning session
Time_spent_maze = (min(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,1})):ceil(min(diff(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,1})))):max(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,1})));
Global_Freq_Respi.SafeFz=interp1(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}), runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30),Time_spent_maze);
Global_Freq_Respi.SafeFz(Global_Freq_Respi.SafeFz==0)=NaN;
Global_Freq_Respi.SafeFz(1:find(~isnan(Global_Freq_Respi.SafeFz), 1)) = Global_Freq_Respi.SafeFz(find(~isnan(Global_Freq_Respi.SafeFz), 1));
Global_Freq_Respi.SafeFz(find(~isnan(Global_Freq_Respi.SafeFz), 1, 'last'):end) = Global_Freq_Respi.SafeFz(find(~isnan(Global_Freq_Respi.SafeFz), 1, 'last'));

figure;
plot(Time_spent_maze,runmean_BM(Global_Freq_Respi.SafeFz,30)), hold on
% plot(Time_spent_maze,runmean_BM(Global_Freq_Respi.SafeFz,500))
ylim([0 6])
title('Linear interpolation of the OB frequency during freezing safe along all the conditioning session')

% BM's method that gives almost the same results (but the x axis is not the global time)
% clear D_runmean R D_new D_new2 ind
% D_runmean = runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30);
% R = Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,6});
% for i=1:length(R)
%     ind(i) = find(R(i) == Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,1}));
% end
% D_new(ind) = D_runmean;
% D_new(D_new==0)=NaN;
% D_new(1:min(find(~isnan(D_new)))) = D_new(min(find(~isnan(D_new)))+1);%*ones(1,length([0:min(find(~isnan(D_new)))]));
% D_new2{mouse} = naninterp(D_new);
% 
% figure
% plot(runmean_BM(D_new2{mouse},30)), hold on
% plot(runmean_BM(D_new2{mouse},500))
% ylim([0 6])
% xlim([0 30000])
% title('BM representation of the OB frequency during freezing safe along all the conditioning session')

%% Freezing safe concatenated epoch
figure; plot(ind_OB_respi,'.') 
figure; plot(OB_freq) 

figure
plot(runmean_BM(OB_freq,30)) % Mean of OB frequencies during freezing episodes across 30 data bins, no temporal information 

figure
plot(ind_OB_respi, OB_freq, '-') %OB frequencies during freezing episodes across the global time of the trial
hold on
plot(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}), Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}), '.')

% Ripples
figure; plot(Range(TSD_DATA.Cond.ripples.ts{1, 6}),'*r') % Times of the session during which ripples were observed

% OB frequency and ripples 
figure 
plot(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}), runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30))
hold on %OB frequencies and ripples during freezing episodes across the global time of the trial
plot(Range(TSD_DATA.Cond.ripples.ts{1, 6}),max(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}))+0.5,'*r') % All ripples are plotted at the position y=6

% Align all the timepoints that correspond more or less to the ripples with a frequency  
ind_OB_respi=Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,6});
ind_ripples=Range(TSD_DATA.Cond.ripples.ts{1,6});
for i=1:length(ind_ripples)
    ind_ripples_match(i) = sum(ind_ripples(i)>ind_OB_respi);
end

figure
plot(runmean_BM(OB_freq,30))
hold on % NB : works for a given mice but will need to be modified to work for more 
plot(ind_ripples_match , max(runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30))+0.5 , '*r') 
title('OB Frequency during safe side freezing and ripples')

% Cumulative curve ripples
figure
subplot(2,1,1)
plot(runmean_BM(OB_freq,30))
title('f OB during freezing in safe zone')
ylabel('f OB')
xlabel('Timepoints of freezing')
subplot(2,1,2)
cdfplot(ind_ripples_match);
xlabel('Timepoints of freezing')

%% Explain the shift of the OB frequency 
% Can learning be defined by the shift of the OB frequency from 4-6Hz to 2-4Hz ?
% But the DR of the OB frequency of an animal can be taken into account so
% the threshold of shift is determined by f_th = (maxf-minf)/2 + minf
OB_mean_freq = runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30);
%ind_learn = find(OB_mean_freq<4); % extract indices that correspond to OB_mean_freq < 4Hz (learning safe)
%ind_shift = ind_learn(1)
ind_learn_range = find(OB_mean_freq<(((max(OB_mean_freq)-min(OB_mean_freq))/2)+min(OB_mean_freq)));
ind_shift = ind_learn_range(1); % index at which the mice started learning

figure
plot(runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30)), hold on
plot(ind_learn_range, max(runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30))+1 , '.k'), hold on
line([ind_shift ind_shift],ylim,'Color','r'), hold on  % threshold of shift in OB frequency
plot(ind_ripples_match , max(runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30))+0.5 , '*r') 
ylim([0 8])
title('OB frequency on safe side freezing, ripples, threshold and time spent below threshold')

% Hyp : learning is proportional to the time spent in the maze
%time_start_experiment = 0, checked by plot(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,1}))
total_time_spent_maze = max(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,1})) %takes the last value of time at which a frequency was recorded, ok?
time_shift = ind_OB_respi(ind_shift) % time at which the mice started learning
absolute_time_to_learn = time_shift
relative_time_to_learn = (time_shift/total_time_spent_maze)*100

% Hyp : learning is proportional to the time spent freezing
delta_time = min(diff(ind_OB_respi))
absolute_tfreezing_to_learn = ind_shift*delta_time
relative_tfreezing_to_learn = ind_shift/length(OB_mean_freq)

% Hyp : learning is proportional to the number of ripples 
nabs_ripples_before_shift = sum(ind_ripples<=time_shift)
nrelative_ripples_before_shift = sum(ind_ripples<=time_shift)/length(ind_ripples)

%% Influence of ripples on OB frequency

% PlotRipRaw(TSD_DATA.Cond.respi_freq_BM.tsd{1,6} , Range(TSD_DATA.Cond.ripples.ts{1,6},'s') , 200)
% (LFP, events, durations, cleaning, PlotFigure, newfig)
% One enters a variable and timepoints, and the function aligns the
% variable along the timepoints with +/- 200ms here

%[m,s,tps]=mETAverage(e,t,v,binsize,nbBins)
% Input:
% e       : times of events
% t       : time of the values  - in 1/10000 sec (assumed to be sorted)
% v       : values
% binsize : size of the bin in ms
% nbBins  : number of bins
% 
% Output:
% m   : mean
% S   : standard error
% tps : times

Ind = isnan(OB_freq);
R = ind_OB_respi;
D = OB_freq;
R = R(~Ind);
D = D(~Ind);

binsize=20;
nbBins=100;
[m,s,tps]=mETAverage(ind_ripples,R,D,binsize,nbBins);
figure
plot(runmean_BM(m,10)), vline(nbBins/2+1,'--r')
title('Mean OB frequency during freezing safe before and after a ripple')
% aligns all the ripples at the middle of the bins and computes the mean
% frequency befora and after each ripple
% hypothesis : a decrease in mean OB frequency should be observed after a ripple

%% Number of entries in the shock zone can reflect learning

%Interval sets can be studied using 
%Start/Stop to have the beginning/end of the time periods
%DurationEpoch to have the timepoints of the different periods
DurationEpoch(Epoch.Cond{1,6});%durations of the fz episodes on the safe side
DurationEpoch(Epoch.Cond{1,5});%durations of the fz episodes on the shock side

% To have the Blocked Epochs
B.(Mouse_names{mousenum});
load('Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

% Compute number of shock/safe zone entries
Epoch.Cond{1,5}; %timepoints of the different states during conditioning sessions (5 corresponds to the Fz safe sessions)
ShockFz_notBlocked = Epoch.Cond{1,5}-BlockedEpoch.Cond.M688; %timepoints of fz in shock zone without being blocked
ShockActive_notBlocked = Epoch.Cond{1,7}-BlockedEpoch.Cond.M688; %timepoints active in shock zone without being blocked
ShockEpoch_notBlocked = or(ShockFz_notBlocked, ShockActive_notBlocked); % timepoints active or fz in shock zone not considering blocked epochs

SafeFz_notBlocked = Epoch.Cond{1,6}-BlockedEpoch.Cond.M688;
SafeActive_notBlocked = Epoch.Cond{1,8}-BlockedEpoch.Cond.M688;
SafeEpoch_notBlocked = or(SafeFz_notBlocked, SafeActive_notBlocked); 

length(Start(ShockEpoch_notBlocked)) % number of shock zone entries 
length(Start(SafeEpoch_notBlocked)) % number of safe zone entries 

% Plot f_OB  during all the conditioning with the sk zone entries
figure
plot(Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,1}), runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,1}),30))
hold on 
vline(Start(ShockEpoch_notBlocked)) 
title('f OB during all the conditioning with the sk zone entries')

% Influence of a shock on OB frequency during all the conditioning session
Indsk = isnan(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,1}));
Rsk = Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,1});
Dsk = Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,1});
Rsk = Rsk(~Indsk);
Dsk = Dsk(~Indsk);

binsizesk=20;
nbBinssk=10;
[m,s,tps]=mETAverage(Start(ShockEpoch_notBlocked),Rsk,Dsk,binsizesk,nbBinssk);
figure
plot(runmean_BM(m,1)), vline(nbBinssk/2+1,'--r')
title('Mean OB frequency during freezing safe before and after a ripple')

% Align all the timepoints that correspond more or less to the shock zone entries with OB frequency during safe freezing  
skzone_entries=Start(ShockEpoch_notBlocked);
ind_OB_respi=Range(TSD_DATA.Cond.respi_freq_BM.tsd{1,6});

for i=1:length(skzone_entries)
    ind_entrysk_match(i) = sum(skzone_entries(i)>ind_OB_respi);
end
ind_entrysk_match = unique(ind_entrysk_match);

figure
plot(runmean_BM(Data(TSD_DATA.Cond.respi_freq_BM.tsd{1,6}),30))
hold on % NB : works for a given mice but will need to be modified to work for more 
vline(ind_entrysk_match, '--r')
title('f OB during the freezing in safe zone with the timepoints of sk zone entries')

% Linear position of the mouse (not investigated)
figure
plot(runmean(Data(TSD_DATA.Cond.linearposition.tsd{1,7}),5))
plot(Data(Restrict(TSD_DATA.Cond.linearposition.tsd{1,7},BlockedEpoch.Cond.M688)))


%% Select a group of mice and generate their data

% Preliminary_Analysis_OBSpectrum_Freezing_BM(1189) % visualize a mouse's data
Mouse_gr1=[688 739 777 779 849 893]; % group1: saline mice, long protocol, SB
Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394]; % group 5: saline short BM first Maze

%% G1 data

% Preliminary_Analysis_OBSpectrum_Freezing_BM(1189) % visualize a mouse's data
Mouse_gr1=[688 739 777 779 849 893]; % group1: saline mice, long protocol, SB

% Extract data for all mice
Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [G1_TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_gr1,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition');
end

% OB frequency and ripples
for mouse=1:length(Mouse_gr1)
    G1_Mouse_names{mouse}=['M' num2str(Mouse_gr1(mouse))];
    G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse}) = Data(G1_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,6});
    if isnan(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})(1))
        G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})(1:find(~isnan(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})), 1)) = G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})(find(~isnan(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})), 1));
    end
    if isnan(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})(end))
        G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})(find(~isnan(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})), 1, 'last'):end) = G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})(find(~isnan(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse})), 1, 'last'));
    end
    G1_Ind_OB.SafeFz.(G1_Mouse_names{mouse}) = Range(G1_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,6});
    if isempty(G1_TSD_DATA.Cond.ripples.ts{mouse,6}) == 0
        G1_Ind_Ripples.SafeFz.(G1_Mouse_names{mouse}) = Range(G1_TSD_DATA.Cond.ripples.ts{mouse,6}); 
    end
end

%% Freezing safe along the absolute time of the experiment

%OB frequencies during freezing episodes across the global time of the trial
for mousenum=1:length(Mouse_gr1)
    G1_Time_spent_maze.(G1_Mouse_names{mousenum}) = min(Range(G1_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1})):ceil(min(diff(G1_Ind_OB.SafeFz.(G1_Mouse_names{mousenum})))):max(Range(G1_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}));
    G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}) = interp1(G1_Ind_OB.SafeFz.(G1_Mouse_names{mousenum}), runmean_BM(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}),30), G1_Time_spent_maze.(G1_Mouse_names{mousenum}));
    G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum})(1:find(~isnan(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum})), 1)) = G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum})(find(~isnan(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum})), 1));
    G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum})(find(~isnan(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum})), 1, 'last'):end) = G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum})(find(~isnan(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum})), 1, 'last'));
end

% Plot the OB mean frequency during freezing across absolute time of the conditioning session
fig=figure;
colors = [0 0.6 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_gr1)
    mouse=G1_Mouse_names(mousenum);
    subplot(2,3,mousenum)
    plot(G1_Time_spent_maze.(G1_Mouse_names{mousenum}), runmean_BM(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}),30),'Color',colors(mousenum,:)), hold on
    plot(G1_Ind_OB.SafeFz.(G1_Mouse_names{mousenum}), 6, '.k')
    ylim([min(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}))-0.8 max(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}))+0.8])
    title(mouse)
    ylim([2.5 6.5]) 
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='off';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Absolute time of conditioning session', 'FontSize', 25);
title(han,'G1 OB frequency during freezing safe interpolated to absolute time of conditioning', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'G1_OBfreq_fz_safe_abstime_cond'), 'png');


% for i=1:length(G1_Time_spent_maze)
%     indexes = ismember(G1_Time_spent_maze, G1_Ind_OB.SafeFz.M688);
%     if indexes(i)
%         G1_Time_freezing_Nan(i) = G1_Ind_OB.SafeFz.M688(i);
%     else
%         G1_Time_freezing_Nan(i) = NaN;
%     end
% end
% plot(G1_Time_freezing_Nan,Data(G1_TSD_DATA.Cond.respi_freq_BM.tsd{1,6}))

%% Freezing safe concatenated epoch

figure
for mouse=1:length(Mouse_gr1)
    plot(runmean_BM(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse}),30)), hold on
end
grid
xlabel('Timepoints of freezing')
ylabel('Frequency (Hz)')
legend(fields(G1_Freq_Respi.SafeFz), 'Location', 'best')

% Align all the timepoints that correspond more or less to the ripples with a frequency  
G1_names_ripples=fields(G1_Ind_Ripples.SafeFz);
for mousenum=1:length(G1_names_ripples)
    mouse=G1_names_ripples(mousenum);
    for i=1:length(G1_Ind_Ripples.SafeFz.(string(mouse))) %try can be used to skip an error (but not in a specific manner)
        G1_Ind_Match.SafeFz.(string(mouse))(i) = sum(G1_Ind_Ripples.SafeFz.(string(mouse))(i)>G1_Ind_OB.SafeFz.(string(mouse)));
    end
end

figure
colors = [0 0.6 .4; 1 0.4 0; 1 0.2 0; 0 0.3 .7];
for mousenum=1:length(G1_names_ripples)
    mouse=G1_names_ripples(mousenum);
    plot(runmean_BM(G1_Freq_Respi.SafeFz.(string(mouse)),30),'Color', colors(mousenum,:))
    hold on
    plot(G1_Ind_Match.SafeFz.(string(mouse)) , max(runmean_BM(G1_Freq_Respi.SafeFz.(string(mouse)),30))+0.5 , '*','Color', colors(mousenum,:))  
    legend(mouse, 'Location', 'best')
end
xlabel('Timepoints of freezing')
ylabel('Frequency (Hz)')

% Cumulative curve ripples
figure
colors = [0 0.6 .4; 1 0.4 0; 1 0.2 0; 0 0.3 .7];
for mousenum=1:length(G1_names_ripples)
    mouse=G1_names_ripples(mousenum);
    subplot(2,4,mousenum)
    grid
    plot(runmean_BM(G1_Freq_Respi.SafeFz.(string(mouse)),30),'Color', colors(mousenum,:))
    title('f OB during freezing in safe zone')
    ylabel('f OB')
    xlabel('Timepoints of freezing')
    subplot(2,4,mousenum+4)
    grid
    cdfplot(G1_Ind_Match.SafeFz.(string(mouse)));
    xlabel('Timepoints of freezing')
end
suptitle('G1 OB frequency and cumulative curve of ripples')

%% Explain the shift of the OB frequency for all mice

for mouse=1:length(Mouse_gr1)
    G1_OB_Mean_Freq.(G1_Mouse_names{mouse}) = runmean_BM(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mouse}),30);
    G1_Ind_learn_range.(G1_Mouse_names{mouse}) = find(G1_OB_Mean_Freq.(G1_Mouse_names{mouse})<(((max(G1_OB_Mean_Freq.(G1_Mouse_names{mouse}))-min(G1_OB_Mean_Freq.(G1_Mouse_names{mouse})))/2)+min(G1_OB_Mean_Freq.(G1_Mouse_names{mouse}))))
    % Define the threshold at the mid range frequency
    G1_Ind_shift.(G1_Mouse_names{mouse}) = G1_Ind_learn_range.(G1_Mouse_names{mouse})(1) % index at which the mice started learning
end %try to define min, max and DR for each mice (failed to do a field with a substraction)

% Represent the OB mean frequency with the shift
figure
for mouse=1:length(Mouse_gr1)
    subplot(2,4,mouse)
    plot(G1_OB_Mean_Freq.(G1_Mouse_names{mouse})), hold on
    plot(G1_Ind_learn_range.(G1_Mouse_names{mouse}), max(G1_OB_Mean_Freq.(G1_Mouse_names{mouse}))+1 , '.k')
    ylim([0 8])
    hold on
    line([G1_Ind_shift.(G1_Mouse_names{mouse}) G1_Ind_shift.(G1_Mouse_names{mouse})],ylim)
    title(G1_Mouse_names{mouse})
end

% OB mean frequency with the threshold, timepoints below it and ripples
figure;
colors='bgrmck';
names_gr1=fields(G1_OB_Mean_Freq);
G1_names_ripples=fields(G1_Ind_Ripples.SafeFz);
for mousenum=1:length(names_gr1)
    mouse=names_gr1(mousenum);
    subplot(2,3,mousenum)
    plot(G1_OB_Mean_Freq.(string(mouse)), colors(mousenum)), hold on
    plot(G1_Ind_learn_range.(string(mouse)), max(G1_OB_Mean_Freq.(string(mouse)))+1 , '.k')
    ylim([2.5 8])
    hold on
    line([G1_Ind_shift.(string(mouse)) G1_Ind_shift.(string(mouse))],ylim, 'Color', colors(mousenum))
    for i=1:length(G1_names_ripples)
        if contains(string(G1_names_ripples(i)), string(mouse)) 
            hold on
            plot(G1_Ind_Match.SafeFz.(string(mouse)) , max(runmean_BM(G1_Freq_Respi.SafeFz.(string(mouse)),30))+0.5 , '*', 'Color', colors(mousenum))
        end
    end
    xlabel('Timepoints of freezing')
    ylabel('Frequency (Hz)')
    title(mouse)
end
% saveFigure(1,'Ripples',SaveFigsTo)

% Same figure arranged
fig=figure;
colors = [0 0.6 .4; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 1 0.4 0; 1 0.2 0];
for mousenum=1:length(Mouse_gr1)
    mouse=G1_Mouse_names(mousenum);
    subplot(2,3,mousenum)
    plot(G1_OB_Mean_Freq.(G1_Mouse_names{mousenum}), 'Color', colors(mousenum,:)), hold on
    plot(G1_Ind_learn_range.(G1_Mouse_names{mousenum}), max(G1_OB_Mean_Freq.(G1_Mouse_names{mousenum}))+1 , '.k')
    ylim([2.5 8])
    hold on
    line([G1_Ind_shift.(G1_Mouse_names{mousenum}) G1_Ind_shift.(G1_Mouse_names{mousenum})],ylim, 'Color', colors(mousenum,:))
    for i=1:length(G1_names_ripples)
        if contains(string(G1_names_ripples(i)), string(mouse)) 
            hold on
            plot(G1_Ind_Match.SafeFz.(G1_Mouse_names{mousenum}) , max(runmean_BM(G1_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}),30))+0.5 , '*', 'Color', colors(mousenum,:))
        end
    end
    title(mouse)
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='off';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Timepoints of freezing', 'FontSize', 25);
xlabel(han,'G1 OB frequency, low threshold, time spent below threshold (black), and ripples (stars)', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'G1_OBfreq_fz_safe_threshold_ripples_stars'), 'png');

%% Test different hypothesis for the learning process

% Hyp : learning is proportional to the time spent in the maze
for mouse=1:length(Mouse_gr1)
    G1_Mouse_names{mouse}=['M' num2str(Mouse_gr1(mouse))];
    G1_Total_time_spent_maze.(G1_Mouse_names{mouse}) = max(Range(G1_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,1})); %takes the last value of time at which a frequency was recorded, ok?
    G1_Time_shift.(G1_Mouse_names{mouse}) = G1_Ind_OB.SafeFz.(G1_Mouse_names{mouse})(G1_Ind_shift.(G1_Mouse_names{mouse})); % time at which the mice started learning
    G1_Absolute_time_to_learn.(G1_Mouse_names{mouse}) = G1_Time_shift.(G1_Mouse_names{mouse});
    G1_Relative_time_to_learn.(G1_Mouse_names{mouse}) = (G1_Time_shift.(G1_Mouse_names{mouse})/G1_Total_time_spent_maze.(G1_Mouse_names{mouse}))*100;
end

figure
for mouse=1:length(Mouse_gr1)
    subplot(1,2,1)
    plot(mouse, G1_Absolute_time_to_learn.(G1_Mouse_names{mouse}), '*'), hold on
    subplot(1,2,2)
    plot(mouse, G1_Relative_time_to_learn.(G1_Mouse_names{mouse}), '*'), hold on
end

% Hyp : learning is proportional to the time spent freezing
for mouse=1:length(Mouse_gr1)
    G1_Mouse_names{mouse}=['M' num2str(Mouse_gr1(mouse))];
    G1_Delta_Time.(G1_Mouse_names{mouse}) = min(diff(G1_Ind_OB.SafeFz.(G1_Mouse_names{mouse})));
    G1_Absolute_tfreezing_to_learn.(G1_Mouse_names{mouse}) = G1_Ind_shift.(G1_Mouse_names{mouse})*G1_Delta_Time.(G1_Mouse_names{mouse})
    G1_Relative_tfreezing_to_learn.(G1_Mouse_names{mouse}) = G1_Ind_shift.(G1_Mouse_names{mouse})/length(G1_OB_Mean_Freq.(G1_Mouse_names{mouse}))
end

figure
for mouse=1:length(Mouse_gr1)
    subplot(1,2,1)
    plot(mouse, G1_Absolute_tfreezing_to_learn.(G1_Mouse_names{mouse}), '*'), hold on
    subplot(1,2,2)
    plot(mouse, G1_Relative_tfreezing_to_learn.(G1_Mouse_names{mouse}), '*'), hold on
end

% Hyp : learning is proportional to the number of ripples 
for mousenum=1:length(G1_names_ripples)
    mouse=G1_names_ripples(mousenum)
    G1_Nabs_ripples_before_shift.(string(mouse)) = sum(G1_Ind_Ripples.SafeFz.(string(mouse))<=G1_Time_shift.(string(mouse)))
    G1_Nrelative_ripples_before_shift.(string(mouse)) = sum(G1_Ind_Ripples.SafeFz.(string(mouse))<=G1_Time_shift.(string(mouse)))/length(G1_Ind_Ripples.SafeFz.(string(mouse)))
end

%% Influence of ripples on OB frequency

for mousenum=1:length(G1_names_ripples)
    mouse=G1_names_ripples(mousenum)
    Ind_nan.(string(mouse)) = isnan(G1_Freq_Respi.SafeFz.(string(mouse)));
    G1_Ind_OB_Nonan.(string(mouse)) = G1_Ind_OB.SafeFz.(string(mouse))(~Ind_nan.(string(mouse)));
    G1_FRespi_Nonan.(string(mouse)) = G1_Freq_Respi.SafeFz.(string(mouse))(~Ind_nan.(string(mouse)));
end 

binsize=20;
nbBins=50;
for mousenum=1:length(G1_names_ripples)
    mouse=G1_names_ripples(mousenum)
    [G1_Mean_Fr_Ripplesaligned.(string(mouse)),~,~]=mETAverage(G1_Ind_Ripples.SafeFz.(string(mouse)),G1_Ind_OB_Nonan.(string(mouse)),G1_FRespi_Nonan.(string(mouse)),binsize,nbBins);
end 

figure
colors='bgrmck'
for mousenum=1:length(G1_names_ripples)
    mouse=G1_names_ripples(mousenum)
    subplot(2,3,mousenum)
    plot(runmean_BM(G1_Mean_Fr_Ripplesaligned.(string(mouse)),5)), vline(nbBins/2+1,'--r')
    title(mouse)
end

%% Number of entries in the shock zone can reflect learning

% To have the Blocked Epochs
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

% Compute number of shock/safe zone entries
for mousenum=1:length(names_gr1)
    mouse=names_gr1(mousenum)
    G1_ShockFz_notBlocked.(G1_Mouse_names{mousenum}) = Epoch1.Cond{mousenum,5}-BlockedEpoch.Cond.(string(mouse)); %timepoints of fz in shock zone without being blocked
    G1_ShockActive_notBlocked.(G1_Mouse_names{mousenum}) = Epoch1.Cond{mousenum,7}-BlockedEpoch.Cond.(string(mouse)); %timepoints active in shock zone without being blocked
    G1_ShockEpoch_notBlocked.(G1_Mouse_names{mousenum}) = or(G1_ShockFz_notBlocked.(G1_Mouse_names{mousenum}), G1_ShockActive_notBlocked.(G1_Mouse_names{mousenum})); % timepoints active or fz in shock zone not considering blocked epochs
end

for mousenum=1:length(names_gr1)
    mouse=names_gr1(mousenum);
    G1.SafeFz_notBlocked.(G1_Mouse_names{mousenum}) = Epoch1.Cond{mousenum,6}-BlockedEpoch.Cond.(string(mouse));
    G1.SafeActive_notBlocked.(G1_Mouse_names{mousenum}) = Epoch1.Cond{mousenum,8}-BlockedEpoch.Cond.(string(mouse));
    G1.SafeEpoch_notBlocked.(G1_Mouse_names{mousenum}) = or(G1.SafeFz_notBlocked.(G1_Mouse_names{mousenum}), G1.SafeActive_notBlocked.(G1_Mouse_names{mousenum})); 
end

for mousenum=1:length(names_gr1)
    mouse=names_gr1(mousenum);
    G1_sk_entries.(G1_Mouse_names{mousenum}) = Start(G1_ShockEpoch_notBlocked.(G1_Mouse_names{mousenum})); % ind of shock zone entries 
    G1_safe_entries.(G1_Mouse_names{mousenum}) = Start(G1.SafeEpoch_notBlocked.(G1_Mouse_names{mousenum})); % ind of safe zone entries 
    G1_N_sk_entries.(G1_Mouse_names{mousenum}) = length(Start(G1_ShockEpoch_notBlocked.(G1_Mouse_names{mousenum}))); % number of shock zone entries 
    G1_N_safe_entries.(G1_Mouse_names{mousenum}) = length(Start(G1.SafeEpoch_notBlocked.(G1_Mouse_names{mousenum}))); % number of safe zone entries 
end

% Plot f_OB  during all the conditioning with the sk zone entries
figure
colors='bgrmck';
names_gr1=fields(G1_OB_Mean_Freq);
for mousenum=1:length(names_gr1)
    mouse=names_gr1(mousenum);
    subplot(2,3,mousenum)
    plot(Range(G1_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}), runmean_BM(Data(G1_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}),30))
    hold on
    plot(G1_sk_entries.(G1_Mouse_names{mousenum}),10, '.r')
    ylim([0 12])
    title(mouse)
end
title('f OB during all the conditioning with the sk zone entries')

% Plot f_OB  during freezing, interpolated to all the conditioning session with the sk zone entries
fig=figure;
colors = [0 0.6 .4; 1 0.4 0; 0.2 0.2 0.9; 0 0.6 .4; 1 0.4 0; 0.2 0.2 0.9];
for mousenum=1:length(Mouse_gr1)
    mouse=G1_Mouse_names(mousenum);
    subplot(2,3,mousenum)
    plot(G1_Time_spent_maze.(G1_Mouse_names{mousenum}), runmean_BM(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}),30),'Color',colors(mousenum,:)), hold on
    plot(G1_Ind_OB.SafeFz.(G1_Mouse_names{mousenum}), 6, '.k'), hold on
    plot(G1_sk_entries.(G1_Mouse_names{mousenum}),10, '.r')
    ylim([min(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}))-0.8 max(G1_Global_Freq_Respi.SafeFz.(G1_Mouse_names{mousenum}))+0.8])
    title(mouse)
    ylim([2.5 6.5]) 
    makepretty
end
han=axes(fig,'visible','off'); 
han.Title.Visible='off';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (Hz)', 'FontSize', 25);
xlabel(han,'Absolute time of conditioning session', 'FontSize', 25);
title(han,'G1 OB frequency during freezing safe interpolated to absolute time of conditioning', 'FontSize', 25);
% saveas(gcf, fullfile(SaveFigsTo, 'G1_OBfreq_fz_safe_abstime_cond'), 'png');

% Influence of a shock entry on OB frequency during all the conditioning session
Indsk = isnan(Data(G1_TSD_DATA.Cond.respi_freq_BM.tsd{1,1}));
Rsk = Range(G1_TSD_DATA.Cond.respi_freq_BM.tsd{1,1});
Dsk = Data(G1_TSD_DATA.Cond.respi_freq_BM.tsd{1,1});
Rsk = Rsk(~Indsk);
Dsk = Dsk(~Indsk);

clear binsizesk nbBinssk
binsizesk=20;
nbBinssk=10;
figure
for mousenum=1:length(Mouse_gr1)
    [m,s,tps]=mETAverage(Start(G1_ShockEpoch_notBlocked.(G1_Mouse_names{mousenum})),Rsk,Dsk,binsizesk,nbBinssk);
    subplot(2,3,mousenum)
    plot(runmean_BM(m,1)), vline(nbBinssk/2+1,'--r')
end
suptitle('Mean OB frequency during freezing safe before and after a shock zone entry')

% Align all the timepoints that correspond more or less to the shock zone entries with OB frequency during safe freezing  
for mousenum=1:length(names_gr1)
    mouse=names_gr1(mousenum);
    for i=1:length(G1_sk_entries.(G1_Mouse_names{mousenum}))
        G1_Ind_Entrysk_Match.(G1_Mouse_names{mousenum})(i) = sum(G1_sk_entries.(G1_Mouse_names{mousenum})(i)>G1_Ind_OB.SafeFz.(G1_Mouse_names{mousenum}));
    end
    G1_Ind_Entrysk_Match.(G1_Mouse_names{mousenum})=unique(G1_Ind_Entrysk_Match.(G1_Mouse_names{mousenum}));
end

% Plot Fz safe with threshold, ripples and shock indices 
figure
colors='bgrmckbgr';
names_gr1=fields(G1_OB_Mean_Freq);
for mousenum=1:length(names_gr1)
    mouse=names_gr1(mousenum);
    subplot(2,3,mousenum)
    plot(G1_OB_Mean_Freq.(string(mouse)), colors(mousenum)), hold on
    plot(G1_Ind_learn_range.(string(mouse)), max(G1_OB_Mean_Freq.(string(mouse)))+1 , '.k')
    ylim([0 8])
    hold on
    line([G1_Ind_shift.(string(mouse)) G1_Ind_shift.(string(mouse))],ylim, 'Color', colors(mousenum))
    hold on
    vline(G1_Ind_Entrysk_Match.(G1_Mouse_names{mousenum}), '--k')
    for i=1:length(G1_names_ripples)
        if contains(string(G1_names_ripples(i)), string(mouse)) 
            hold on
            plot(G1_Ind_Match.SafeFz.(string(mouse)) , max(runmean_BM(G1_Freq_Respi.SafeFz.(string(mouse)),30))+0.5 , '*', 'Color', colors(mousenum))
        end
    end
    xlabel('Timepoints of freezing')
    ylabel('Frequency (Hz)')
    title(mouse)
end


%% G5 data

% Preliminary_Analysis_OBSpectrum_Freezing_BM(1189) % visualize a mouse's data
Mouse_gr5=[1170 1171 9184 1189 9205 1391 1392 1393 1394]; % group 5: saline short BM first Maze

% Extract data for all mice
Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
    [G5_TSD_DATA.(Session_type{sess}) , Epoch5.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_gr5,lower(Session_type{sess}),'respi_freq_BM','ripples','linearposition');
end

% OB frequency and ripples 
for mouse=1:length(Mouse_gr5)
    G5_Mouse_names{mouse}=['M' num2str(Mouse_gr5(mouse))];
    G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse}) = Data(G5_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,6});
    if isnan(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})(1))
        G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})(1:find(~isnan(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})), 1)) = G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})(find(~isnan(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})), 1));
    end
    if isnan(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})(end))
        G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})(find(~isnan(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})), 1, 'last'):end) = G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})(find(~isnan(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse})), 1, 'last'));
    end
    G5_Ind_OB.SafeFz.(G5_Mouse_names{mouse}) = Range(G5_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,6});
    if isempty(G5_TSD_DATA.Cond.ripples.ts{mouse,6})
        G5_TSD_DATA.Cond.ripples.ts{mouse,6}=NaN;  
    else
        G5_Ind_Ripples.SafeFz.(G5_Mouse_names{mouse}) = Range(G5_TSD_DATA.Cond.ripples.ts{mouse,6}); 
    end
end

%% Freezing safe along the absolute time of the experiment

%OB frequencies during freezing episodes across the global time of the trial
for mousenum=1:length(Mouse_gr5)
    G5_Time_spent_maze.(G5_Mouse_names{mousenum}) = min(Range(G5_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1})):ceil(min(diff(G5_Ind_OB.SafeFz.(G5_Mouse_names{mousenum})))):max(Range(G5_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}));
    G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum}) = interp1(G5_Ind_OB.SafeFz.(G5_Mouse_names{mousenum}), runmean_BM(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum}),30), G5_Time_spent_maze.(G5_Mouse_names{mousenum}));
    G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum})(1:find(~isnan(G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum})), 1)) = G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum})(find(~isnan(G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum})), 1));
    G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum})(find(~isnan(G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum})), 1, 'last'):end) = G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum})(find(~isnan(G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum})), 1, 'last'));
end

% Plot the OB mean frequency during freezing across absolute time of the conditioning session
figure;
colors = [0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4];
for mousenum=1:length(Mouse_gr5)
    mouse=G5_Mouse_names(mousenum);
    subplot(3,3,mousenum)
    plot(G5_Time_spent_maze.(G5_Mouse_names{mousenum}), runmean_BM(G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum}),30),'Color',colors(mousenum,:)), hold on
    plot(G5_Ind_OB.SafeFz.(G5_Mouse_names{mousenum}), max(runmean_BM(G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum}),30))+0.5, '.k')
    ylim([min(G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum}))-0.8 max(G5_Global_Freq_Respi.SafeFz.(G5_Mouse_names{mousenum}))+0.8])
    title(mouse)
    xlabel('Absolute time freezing')
    ylabel('Frequency (Hz)')
    makepretty
end
suptitle('G5 OB frequency during absolute time freezing')

%% Freezing safe concatenated epoch

figure
for mouse=1:length(Mouse_gr5)
    plot(runmean_BM(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse}),30)), hold on
end
grid
xlabel('Timepoints of freezing')
ylabel('Frequency (Hz)')
legend(fields(G5_Freq_Respi.SafeFz), 'Location', 'best')

% Align all the timepoints that correspond more or less to the ripples with a frequency  
G5_names_ripples=fields(G5_Ind_Ripples.SafeFz);
for mousenum=1:length(G5_names_ripples)
    mouse=G5_names_ripples(mousenum);
    for i=1:length(G5_Ind_Ripples.SafeFz.(string(mouse))) 
        G5_Ind_Match.SafeFz.(string(mouse))(i) = sum(G5_Ind_Ripples.SafeFz.(string(mouse))(i)>G5_Ind_OB.SafeFz.(string(mouse)));
    end
end

figure
colors = [0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4];
for mousenum=1:length(G5_names_ripples)
    mouse=G5_names_ripples(mousenum);
    p1=plot(runmean_BM(G5_Freq_Respi.SafeFz.(string(mouse)),30),'Color', colors(mousenum,:));
    hold on
    plot(G5_Ind_Match.SafeFz.(string(mouse)) , max(runmean_BM(G5_Freq_Respi.SafeFz.(string(mouse)),30))+0.5 , '*','Color', colors(mousenum,:))  
end
xlabel('Timepoints of freezing')
ylabel('Frequency (Hz)')

% Cumulative curve ripples
figure
colors = [0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4];
for mousenum=1:length(G5_names_ripples)
    mouse=G5_names_ripples(mousenum);
    subplot(2,7,mousenum)
    grid
    plot(runmean_BM(G5_Freq_Respi.SafeFz.(string(mouse)),30),'Color', colors(mousenum,:))
    title(mouse)
    ylabel('f OB')
    xlabel('Timepoints of freezing')
    subplot(2,7,mousenum+7)
    grid
    cdfplot(G5_Ind_Match.SafeFz.(string(mouse)));
    xlabel('Timepoints of freezing')
end
suptitle('G5 OB frequency and cumulative curve of ripples')

%% Explain the shift of the OB frequency for all mice
for mouse=1:length(Mouse_gr5)
    G5_OB_Mean_Freq.(G5_Mouse_names{mouse}) = runmean_BM(G5_Freq_Respi.SafeFz.(G5_Mouse_names{mouse}),30);
    G5_Ind_learn_range.(G5_Mouse_names{mouse}) = find(G5_OB_Mean_Freq.(G5_Mouse_names{mouse})<(((max(G5_OB_Mean_Freq.(G5_Mouse_names{mouse}))-min(G5_OB_Mean_Freq.(G5_Mouse_names{mouse})))/2)+min(G5_OB_Mean_Freq.(G5_Mouse_names{mouse}))))
    G5_Ind_shift.(G5_Mouse_names{mouse}) = G5_Ind_learn_range.(G5_Mouse_names{mouse})(1) % index at which the mice started learning
end %try to define min, max and DR for each mice (failed to do a field with a substraction)

% Represent the OB mean frequency with the shift
figure
for mouse=1:length(Mouse_gr5)
    subplot(3,3,mouse)
    plot(G5_OB_Mean_Freq.(G5_Mouse_names{mouse})), hold on
    plot(G5_Ind_learn_range.(G5_Mouse_names{mouse}), max(G5_OB_Mean_Freq.(G5_Mouse_names{mouse}))+1 , '.k')
    ylim([0 8])
    hold on
    line([G5_Ind_shift.(G5_Mouse_names{mouse}) G5_Ind_shift.(G5_Mouse_names{mouse})],ylim)
end

% Add the ripples
figure
colors = [0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4];
names_gr5=fields(G5_OB_Mean_Freq);
G5_names_ripples=fields(G5_Ind_Ripples.SafeFz);
for mousenum=1:length(names_gr5)
    mouse=names_gr5(mousenum);
    subplot(3,3,mousenum)
    plot(G5_OB_Mean_Freq.(string(mouse)), 'Color', colors(mousenum,:)), hold on
    plot(G5_Ind_learn_range.(string(mouse)), max(G5_OB_Mean_Freq.(string(mouse)))+1 , '.k')
    ylim([0 8])
    hold on
    line([G5_Ind_shift.(string(mouse)) G5_Ind_shift.(string(mouse))],ylim, 'Color', colors(mousenum,:))
    for i=1:length(G5_names_ripples)
        if contains(string(G5_names_ripples(i)), string(mouse)) 
            hold on
            plot(G5_Ind_Match.SafeFz.(string(mouse)) , max(runmean_BM(G5_Freq_Respi.SafeFz.(string(mouse)),30))+0.5 , '*', 'Color', colors(mousenum,:))
        end
    end
    xlabel('Timepoints of freezing')
    ylabel('Frequency (Hz)')
    title(mouse)
end
suptitle('G5 OB frequency, low frequency threshold, time spent below the threshold (black) and ripples *')

% Hyp : learning is proportional to the time spent in the maze
for mouse=1:length(Mouse_gr5)
    G5_Mouse_names{mouse}=['M' num2str(Mouse_gr5(mouse))];
    G5_Total_time_spent_maze.(G5_Mouse_names{mouse}) = max(Range(G5_TSD_DATA.Cond.respi_freq_BM.tsd{mouse,1})) %takes the last value of time at which a frequency was recorded, ok?
    G5_Time_shift.(G5_Mouse_names{mouse}) = G5_Ind_OB.SafeFz.(G5_Mouse_names{mouse})(G5_Ind_shift.(G5_Mouse_names{mouse})) % time at which the mice started learning
    G5_Absolute_time_to_learn.(G5_Mouse_names{mouse}) = G5_Time_shift.(G5_Mouse_names{mouse})
    G5_Relative_time_to_learn.(G5_Mouse_names{mouse}) = (G5_Time_shift.(G5_Mouse_names{mouse})/G5_Total_time_spent_maze.(G5_Mouse_names{mouse}))*100
end

figure
for mouse=1:length(Mouse_gr5)
    subplot(1,2,1)
    plot(mouse, G5_Absolute_time_to_learn.(G5_Mouse_names{mouse}), '*'), hold on
    subplot(1,2,2)
    plot(mouse, G5_Relative_time_to_learn.(G5_Mouse_names{mouse}), '*'), hold on
end

% Hyp : learning is proportional to the time spent freezing
for mouse=1:length(Mouse_gr5)
    G5_Mouse_names{mouse}=['M' num2str(Mouse_gr5(mouse))];
    G5_Delta_Time.(G5_Mouse_names{mouse}) = min(diff(G5_Ind_OB.SafeFz.(G5_Mouse_names{mouse})))
    G5_Absolute_tfreezing_to_learn.(G5_Mouse_names{mouse}) = G5_Ind_shift.(G5_Mouse_names{mouse})*G5_Delta_Time.(G5_Mouse_names{mouse})
    G5_Relative_tfreezing_to_learn.(G5_Mouse_names{mouse}) = G5_Ind_shift.(G5_Mouse_names{mouse})/length(G5_OB_Mean_Freq.(G5_Mouse_names{mouse}))
end

figure
for mouse=1:length(Mouse_gr5)
    subplot(1,2,1)
    plot(mouse, G5_Absolute_tfreezing_to_learn.(G5_Mouse_names{mouse}), '*'), hold on
    subplot(1,2,2)
    plot(mouse, G5_Relative_tfreezing_to_learn.(G5_Mouse_names{mouse}), '*'), hold on
end

% Hyp : learning is proportional to the number of ripples 
for mousenum=1:length(G5_names_ripples)
    mouse=G5_names_ripples(mousenum)
    G5_Nabs_ripples_before_shift.(string(mouse)) = sum(G5_Ind_Ripples.SafeFz.(string(mouse))<=G5_Time_shift.(string(mouse)))
    G5_Nrelative_ripples_before_shift.(string(mouse)) = sum(G5_Ind_Ripples.SafeFz.(string(mouse))<=G5_Time_shift.(string(mouse)))/length(G5_Ind_Ripples.SafeFz.(string(mouse)))
end


%% Number of entries in the shock zone can reflect learning

% To have the Blocked Epochs
cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Create_Behav_Drugs_BM.mat', 'BlockedEpoch')

% Compute number of shock/safe zone entries
for mousenum=1:length(names_gr5)
    mouse=names_gr5(mousenum)
    G5_ShockFz_notBlocked.(G5_Mouse_names{mousenum}) = Epoch5.Cond{mousenum,5}-BlockedEpoch.Cond.(string(mouse)); %timepoints of fz in shock zone without being blocked
    G5_ShockActive_notBlocked.(G5_Mouse_names{mousenum}) = Epoch5.Cond{mousenum,7}-BlockedEpoch.Cond.(string(mouse)); %timepoints active in shock zone without being blocked
    G5_ShockEpoch_notBlocked.(G5_Mouse_names{mousenum}) = or(G5_ShockFz_notBlocked.(G5_Mouse_names{mousenum}), G5_ShockActive_notBlocked.(G5_Mouse_names{mousenum})); % timepoints active or fz in shock zone not considering blocked epochs
end

for mousenum=1:length(names_gr5)
    mouse=names_gr5(mousenum);
    G5.SafeFz_notBlocked.(G5_Mouse_names{mousenum}) = Epoch5.Cond{mousenum,6}-BlockedEpoch.Cond.(string(mouse));
    G5.SafeActive_notBlocked.(G5_Mouse_names{mousenum}) = Epoch5.Cond{mousenum,8}-BlockedEpoch.Cond.(string(mouse));
    G5.SafeEpoch_notBlocked.(G5_Mouse_names{mousenum}) = or(G5.SafeFz_notBlocked.(G5_Mouse_names{mousenum}), G5.SafeActive_notBlocked.(G5_Mouse_names{mousenum})); 
end

for mousenum=1:length(names_gr5)
    mouse=names_gr5(mousenum);
    G5_sk_entries.(G5_Mouse_names{mousenum}) = Start(G5_ShockEpoch_notBlocked.(G5_Mouse_names{mousenum})); % ind of shock zone entries 
    G5_safe_entries.(G5_Mouse_names{mousenum}) = Start(G5.SafeEpoch_notBlocked.(G5_Mouse_names{mousenum})); % ind of safe zone entries 
    G5_N_sk_entries.(G5_Mouse_names{mousenum}) = length(Start(G5_ShockEpoch_notBlocked.(G5_Mouse_names{mousenum}))); % number of shock zone entries 
    G5_N_safe_entries.(G5_Mouse_names{mousenum}) = length(Start(G5.SafeEpoch_notBlocked.(G5_Mouse_names{mousenum}))); % number of safe zone entries 
end

% Plot f_OB  during all the conditioning with the sk zone entries
figure
colors = [0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4];
names_gr5=fields(G5_OB_Mean_Freq)
for mousenum=1:length(names_gr5)
    mouse=names_gr5(mousenum)
    subplot(3,3,mousenum)
    plot(Range(G5_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}), runmean_BM(Data(G5_TSD_DATA.Cond.respi_freq_BM.tsd{mousenum,1}),30))
    hold on
    plot(G5_sk_entries.(G5_Mouse_names{mousenum}),10, '.r')
    ylim([0 12])
    title(mouse)
end
title('f OB during all the conditioning with the sk zone entries')

% Align all the timepoints that correspond more or less to the shock zone entries with OB frequency during safe freezing  
for mousenum=1:length(names_gr5)
    mouse=names_gr5(mousenum)
    for i=1:length(G5_sk_entries.(G5_Mouse_names{mousenum}))
        G5_Ind_Entrysk_Match.(G5_Mouse_names{mousenum})(i) = sum(G5_sk_entries.(G5_Mouse_names{mousenum})(i)>G5_Ind_OB.SafeFz.(G5_Mouse_names{mousenum}));
    end
    G5_Ind_Entrysk_Match.(G5_Mouse_names{mousenum})=unique(G5_Ind_Entrysk_Match.(G5_Mouse_names{mousenum}));
end


% Plot Fz safe with ripples and shock indices 
figure
colors = [0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4; 0 0.4 0.7; 1 0.4 0; 1 0.2 0; 0 0.6 .4];
names_gr5=fields(G5_OB_Mean_Freq);
for mousenum=1:length(names_gr5)
    mouse=names_gr5(mousenum);
    subplot(3,3,mousenum)
    plot(G5_OB_Mean_Freq.(string(mouse)), 'Color', colors(mousenum,:)), hold on
    plot(G5_Ind_learn_range.(string(mouse)), max(G5_OB_Mean_Freq.(string(mouse)))+1 , '.k')
    ylim([0 8])
    hold on
    line([G5_Ind_shift.(string(mouse)) G5_Ind_shift.(string(mouse))],ylim, 'Color', colors(mousenum,:))
    hold on
    vline(G5_Ind_Entrysk_Match.(G5_Mouse_names{mousenum}), '--k')
    for i=1:length(G5_names_ripples)
        if contains(string(G5_names_ripples(i)), string(mouse)) 
            hold on
            plot(G5_Ind_Match.SafeFz.(string(mouse)) , max(runmean_BM(G5_Freq_Respi.SafeFz.(string(mouse)),30))+0.5 , '*', 'Color', colors(mousenum,:))
        end
    end
    xlabel('Timepoints of freezing')
    ylabel('Frequency (Hz)')
    title(mouse)
end
suptitle('G5 OB frequency, low frequency threshold, time spent below the threshold (black), ripples * and shock')

%%






