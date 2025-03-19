function [data,cfg] = ft_read_oe_data_py(cfg, exp_path, rebuild)
% [data,cfg] = ft_read_oe_data(cfg)
%
% cfg structure
%   .numchans   ... [1x1] expected number of channels to load. default = 32
%   .path       ... string path to data. default = pwd
%   .experiment ... string name of the experiment (typically a folder name
%                   in cfg.path). no default
%   .recording  ... string containing the specific recording. default is
%                   determined automatically.
%   .channelmapfile ... string filename specifying a channel map matlab
%                       file. The "Map" field in this structure is used to
%                       remap the channels if it is available. default = no
%                       file specified and no remapping takes place.
% 
% Output:
%   data    ... structure with trial data
%   cfg     ... cfg input structure is reflected back with additional
%               fields expected by the Fieldtrip Toolbox.
% 
% 
% Example:
%   cfg = [];
%   cfg.path = 'C:\Your\Path\to\ECoG_Data\';
%   cfg.experiment = 'Mangrove_2021-05-06_12-54-34_TORCS'; % OpenEphys data folder
%   data = ft_read_oe_data(cfg)
% 
% DJS 2021
if nargin<2
    rebuild=0;
end
if ~isfield(cfg,'numchans')
    cfg.numchans = 32; 
end
if ~isfield(cfg,'path')
    cfg.path = '/media/nas7/React_Passive_AG/ECoG_RKC/NaturalSounds_dataset/';
end
if ~isfield(cfg,'node')
    cfg.node = '100'; 
end
if ~isfield(cfg,'channelmapfile')
    cfg.channelmapfile = '/media/nas7/React_Passive_AG/ECoG_RKC/NaturalSounds_dataset/ECoG_channel_map.mat';
end
if ~isfield(cfg,'recording')
    d = dir(fullfile(cfg.experiment,'Record Node*'));
    cfg.recording = d(1).name;
end

% fn = fullfile(cfg.experiment,[cfg.experiment '.mat']);  %data file for store the raw data extrcated from OE data
% if exist(fn,'file') && ~rebuild
%     data=load(fn);
%     if nargout>1
%         cfg=data.cfg;
%         data=data.data;
%     end
%     return;
% end
%% Get continuous files
chFlag = 1; % sometimes "CH" is prepended to the file, and sometimes not ????
ffn = fullfile(cfg.experiment,cfg.recording,'*CH*.continuous');
d = dir(ffn);
if isempty(d)
    chFlag = 0;
    ffn = fullfile(cfg.experiment,cfg.recording,'*.continuous');
    d = dir(ffn);
end

%% Get ferret name
% cfg.ferret=strtok(cfg.experiment,'_');
% name = 'Aspen|Mangrove';
% ext_name = regexp(cfg.experiment, name, 'match'); 
% if isempty(ext_name)
%     disp('unknown ferret')
% end
% cfg.ferret  = ext_name{:};

% cfg.date=d(1).date;   %date time stampes
% [OK, cfg]=match_mfile(cfg);  %find mathced mfile by type and date
% if ~OK
%     disp('not find any matched mfile!! ');
%     disp('please flush data onto server!! ');
%     data=[];
%     return;
% end

%% Get mat files (only for Exp)
if contains(cfg.experiment, exp_path)
    cfg.mfile = dir(fullfile(exp_path, '*.m'));
    cfg = get_stimat(cfg);
end

%%
for i = cfg.numchans:-1:1  %signal channel
    if chFlag
        efn = sprintf('%s_CH%d.continuous',cfg.node,i);
    else
        efn = sprintf('%s_%d.continuous',cfg.node,i);
    end
    ffn = fullfile(cfg.experiment,cfg.recording,efn);
    [data.raw(i,:),timestamps,oeInfo] = load_open_ephys_data(ffn);    
    
    data.label{i,1} = sprintf('CH%02d',i);
    
    fprintf('\bdone\n')
end
data.fs = oeInfo.header.sampleRate;
if oeInfo.header.sampleRate~=1000  %resmaple (usually downsmaple
    data.fs=1000;
    data.raw=resample(data.raw',data.fs,oeInfo.header.sampleRate)';
    timestamps = resample(timestamps', data.fs, oeInfo.header.sampleRate)';
end

[tshift,midx]=max(diff(timestamps(:)));
midx=timestamps(1)+midx/oeInfo.header.sampleRate;
tshift=tshift+1/oeInfo.header.sampleRate;
data.t0 =timestamps(1);  %reference time in second

% Only for Exp
if contains(cfg.experiment, exp_path)
    % Read OpenEphys event (TTL) data
    % eventIDs seem to be TTL input channel # - 1
    % All events are stored as on/off times synchronized with physiology data
    %  event 0 : Lick IR TTL
    %  event 1 : Shock TTL
    %  event 3 : Trial TTL
    ffn = fullfile(cfg.experiment,cfg.recording,'all_channels.events');
    [oeEvID,oeEvTime] = load_open_ephys_data(ffn);
    if midx<oeEvTime(end)
        data.t0 =timestamps(1)+tshift;  %reference time in second
    end
    oeEvTime=oeEvTime-data.t0;  %event time in second, reference to beginning of the sinal
    evt_total=size(cfg.TrialLen,1)*2;  %include on and off
    data.EvID=[oeEvID(end-evt_total+1:2:end) oeEvTime(end-evt_total+1:2:end) oeEvTime(end-evt_total+2:2:end)];
end

if isfield(cfg,'channelmapfile')
    fprintf('Remapping electrodes using "%s"\n',cfg.channelmapfile)
    map=load(cfg.channelmapfile);
    data.ChannelMAP = map.ChannelData.Map;
    data.ChannelARR=map.ChannelData.Position;
end
save([cfg.experiment '/data'],'data','cfg');


%=================================
% function [OK, cfg]=match_mfile(cfg)
% dt = datetime(cfg.date, 'InputFormat', 'dd-MMMM-yyyy HH:mm:ss', 'Locale', 'fr_FR');
% [Y0,M0,D0,h0,m0]=datevec(dt);
% % p=dir(sprintf('M:\\daq\\%s\\%s*',cfg.ferret,cfg.ferret(1)));  %find recording subfolder under animal name 
% p=dir(sprintf('M:\\daq\\%s\\%s*',cfg.ferret,cfg.ferret(1)));  %find recording subfolder under animal name 
% 
% OK=0;
% for i=1:length(p)
%     ff=dir(sprintf('M:\\daq\\%s\\%s\\*.m',cfg.ferret,p(i).name));
%     [Y1,M1,D1]=datevec(ff(1).date);
%     if all([Y0 M0 D0]==[Y1 M1 D1]);  %search the same day data
%         OK=1;
%         idx=i;
%     end
% end
% if ~OK, return; end
% 
% P0=sprintf('M:\\daq\\%s\\%s\\',cfg.ferret,p(idx).name);  %path
% ff=dir([P0 '*.m']);
% for i=1:length(ff)
%     tt(i,:)=datevec(ff(i).date);
% end
% tt=bsxfun(@minus,tt(:,4:5),[h0 m0]);  %hour and minutes 
% tt(:,1)=tt(:,1)*60;   %hour to minutes
% [~,mn]=min(abs(sum(tt,2)));  %the corespoding mifle file should be the closet in time.
% cfg.mfile=fullfile(P0,ff(mn).name);
% 

%=========================
function cfg=get_stimat(cfg)
disp('Loading mfile info ...');
run([cfg.mfile.folder '/' cfg.mfile.name]);
disp('Creating stimulus matrix ...');

[sti_mat,tor_mat,trialLEN]=get_frelist(exptevents,exptparams.runclass,exptparams);
% if strfind(cfg.experiment,exptparams.runclass)    
    cfg.TrialObject=exptparams.TrialObject;
    cfg.stimat=sti_mat;
    cfg.tormat=tor_mat;
    cfg.TrialLen=trialLEN;
    cfg.runclass=exptparams.runclass;
% else
%     disp(['experiment:' cfg.experiment]);
%     disp(['mfile:' cfg.mfile]);
%     disp('mfile didnot match the experiment, please check...');
% end

