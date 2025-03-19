function fUS_SS_processing
% you can find sessions to process in '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/processed_session_readme' 

datapath = '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/';
session = '/media/nas7/React_Passive_AG/OBG/Edel/head-fixed/20220520_n';

cd(session)

load('fUS_data_V_2.mat')
sess = 2; % put 1 if _m and 2 if _n
 
%% Load triggers

filenames = [datapath '/TrigFiles/*REA_' params.slice{sess} '_' params.pair{sess} '_' params.session{sess} '*.csv'];
listings = dir(filenames);

if isempty(listings)
    filenames = [datapath '/TrigFiles/*REA_' params.slice{sess} '_p' params.pair{sess} '_' params.session{sess} '*.csv'];
    listings = dir(filenames);
end

trig_file = listings(1).name;
file = readtable([datapath 'TrigFiles/' trig_file]);

% Extract trigs and cut to trials. f_trigs = time of fUS triggers in ms, b_trigs = times of stimuli triggers in ms
% fUS trigs
trig_info = table2cell(file(:,2));
f_trigs = trig_info(cellfun(@(x) isequal(x,1),strfind(trig_info,'F-')));
f_trigs = cell2mat(cellfun(@(x) str2double(x(3:end)),f_trigs,'UniformOutput',false));

% baphy trigs
b_trigs = trig_info(cellfun(@(x) isequal(x,1),strfind(trig_info,'B-')));
b_trigs = cell2mat(cellfun(@(x) str2double(x(3:end)),b_trigs,'UniformOutput',false));

% fix issue when first fUS frame had a non-0 timing (not supposed to happen but is there sometimes)
b_trigs = b_trigs - f_trigs(1);
f_trigs = f_trigs - f_trigs(1);


%% Cut in trials
data_cat = raw_data;
plt = 1;
[rawdatacut, trial_timings] = cut_into_trials_AB(data_cat, sess, f_trigs, b_trigs, plt, exp_info);

% x, y, trials, time, session (_m or _n)
data_cut_in_trials(:, :, :, :, sess) = rawdatacut;
n_trials = size(rawdatacut, 3);



% Activation_maps.n
Activation_maps

% cut_into_trials_AB

% fUS_tsd_conversion


%% 
Data(fUS_ACx_tsd{2})

a = Range(fUS_ACx_tsd{2}, 's'); a(1)






























end