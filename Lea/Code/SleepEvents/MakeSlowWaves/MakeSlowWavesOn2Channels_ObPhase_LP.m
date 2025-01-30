%% MakeSlowWavesOn2Channels_Obphase_LP()
%
% 09/06/2020  LP
%
% Function to create a 'SlowWaves2Channels_ObPhase_LP.mat' file
% with slow waves (8 combinations) detected on TWO channels.
% SEE : MakeSlowWavesOn2Channels_LP()
%
% But the 8 slow wave types are additionally sorted in slow waves which are in phase with 
% deep Olfactory Bulb (deep OB) vs. out of phase.
% -> in phase = 2pi ± pi/2.
% -> out of phase = pi ± pi/2.
%
% -> 'SlowWaves2Channels_LP.mat' must have been created first. 

%
% ----------------- INPUTS ----------------- :
%
% - LFPob  :  LFP channel of the olfactory bulb
%                           
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
%   - 'foldername' :       folder path for the detection of slow waves
%                                   (default = pwd)
%
%   - 'filename' :         name of .mat file with the events
%                                   (default = 'SlowWaves2Channels_ObPhase_LP') 
%
%   - 'OBfilterfreq' :       frequency range to filter the OB LFP signal
%                                   (default = [3 5])
%
%   - 'recompute' :        recompute even if file and variables already
%                                   exist
%                                   (default = 0)
%
%
% Example : MakeSlowWavesOn2Channels_ObPhase_LP(LFPOBdeep,'OBfilterfreq', [3 5]);


function MakeSlowWavesOn2Channels_ObPhase_LP(LFPob, varargin)

    %% CHECK INPUTS

    if nargin < 1 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    % Parse parameter list :

    for i = 1:2:length(varargin)
        if ~ischar(varargin{i})
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end

        switch(varargin{i})
            case 'foldername'
                foldername = varargin{i+1};
            case 'filename'
                filename = varargin{i+1}; 
            case 'OBfilterfreq'
                OBfilterfreq = varargin{i+1}; 
            case 'recompute'
                recompute = varargin{i+1};
                if recompute~=0 && recompute ~=1
                    error('Incorrect value for property ''recompute''.');
                end    
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    %check if optional parameters exist and assign default value if not :

    if ~exist('foldername','var')
        foldername=pwd;
    end
    if ~exist('filename','var')
        filename = 'SlowWaves2Channels_ObPhase_LP' ;
    end
    if ~exist('OBfilterfreq','var')
        OBfilterfreq = [3 5];
    end
    
    %recompute?
    if ~exist('recompute','var')
        recompute=0;
    end
    
    
    %check if already exist : return if already exists and recompute = 0
    if ~recompute
        if exist('SlowWaves2Channels_ObPhase_LP.mat','file')==2
            disp(['Slow Waves already generated.'])
            return
        end
    end
    
    

    %% LOAD 2-channel slow waves : 
    
    try load('SlowWaves2Channels_LP.mat')
    catch error('"SlowWaves2Channels_LP.mat" could not be found. Use MakeSlowWavesOn2Channels_LP function to generate it before using this function') 
    end 
    
    all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
    
    clearvars slowwave_type1 slowwave_type2 slowwave_type3 slowwave_type4 slowwave_type5 slowwave_type6 slowwave_type7 slowwave_type8 
    
    
    %% EXTRACT and STORE in phase and out of phase EVENTS : 
    
    for type = 1:length(all_slowwaves)
        disp(['Computing ' num2str(type) '/'  num2str(length(all_slowwaves)) '...' ]) 
        sw_ts = all_slowwaves{type} ; 
        
        % Events in phase : 
        Fil=FilterLFP(LFPob,OBfilterfreq,1024);
        [Ph,phasesandtimes,powerTsd]=CalCulPrefPhase(sw_ts,Fil,'H');
        ph=Data(Ph{1});
        idx = findPhasesClose2mu(ph,2*pi,pi/2);
        
        sw_t = Range(sw_ts);
        sw_inphase = ts(sw_t(idx));
        
        % Events out of phase :
        id = repmat(1,1,length(ph)) ; id(idx) = 0 ; 
        sw_outphase = ts(sw_t(logical(id))) ; 
        
        % Store events in a structure :
        eval(['slowwave_type' num2str(type) '.allpeaktimes = sw_ts ; ']) 
        eval(['slowwave_type' num2str(type) '.inphasepeaktimes = sw_inphase ; ']) 
        eval(['slowwave_type' num2str(type) '.inphaseidx = idx ; '])
        eval(['slowwave_type' num2str(type) '.outphasepeaktimes = sw_outphase ; ']) 
        eval(['slowwave_type' num2str(type) '.outphaseidx = find(logical(id)) ; '])
           
    end
    
    
    %% SAVE OUTPUT 
    
    save(fullfile(foldername,[filename '.mat']), 'slowwave_type1', 'slowwave_type2', 'slowwave_type3', 'slowwave_type4', 'slowwave_type5', 'slowwave_type6', 'slowwave_type7', 'slowwave_type8', 'OBfilterfreq')
    disp('Done') 
    
    
end
