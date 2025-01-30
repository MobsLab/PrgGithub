% MakeHighFrequencyLFP_KJ
% 08.04.2018 KJ
%
% Processing: 
%   - generate LFP data with high sampling rate
%   - for the different PFCx locations
%   - saved in .mat files
%
%
%   see MakeData_LFP


function MakeHighFrequencyLFP_KJ(varargin)


%% CHECK INPUTS

if mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'foldername'
            foldername = varargin{i+1};
        case 'frequency'
            frequency = varargin{i+1};
            if ~isdscalar(frequency,'>0')
                error('Incorrect value for property ''frequency''. ');
            end
        case 'channels'
            channels = varargin{i+1};
            if ~isivector(channels,'>0')
                error('Incorrect value for property ''channels''. ');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('foldername','var')
    foldername = pwd;
end
if foldername(end)~=filesep
    foldername(end+1) = filesep;
end
if ~exist('frequency','var')
    frequency = 6e3;
end


%% LFP channels
if ~exist('channels','var')
    try
        load('ChannelsToAnalyse/PFCx_locations.mat','channels')

    catch
        channels = GetDifferentLocationStructure('PFCx');
        save('ChannelsToAnalyse/PFCx_locations.mat','channels')
    end
    disp(' ');
    disp(['PFCx channels : ' num2str(channels)]);
end

%% Create LFPs
mkdir('HighLFPData')
disp(' ');
disp('...Creating LFPData.mat')


try
    for i=1:length(channels)
        if ~exist(['HighLFPData/LFP' num2str(channels(i)) '.mat'],'file') %only LFP signals

            disp(['loading and saving LFP' num2str(channels(i)) ' in LFPData...']);
            % FMA toolbox function to load LFP
            LFP_temp = GetHighLFP(channels(i), 'frequency', frequency);
            %data to tsd
            LFP = tsd(LFP_temp(:,1)*1E4, LFP_temp(:,2));
            %save
            save([foldername '/HighLFPData/LFP' num2str(channels(i))], '-v7.3', 'LFP');
            clear LFP LFP_temp
        end
    end
    disp('Done')
catch
    disp('problem for lfp')
    keyboard
end
clear LFP InfoLFP


end


