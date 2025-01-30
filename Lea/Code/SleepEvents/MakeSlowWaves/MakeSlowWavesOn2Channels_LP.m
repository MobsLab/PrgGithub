%% MakeSlowWavesOn2Channels_LP()
% 
% 26/05/2020  LP
%
% Function to create or append a 'SlowWaves2Channels_LP.mat' file
% with slow waves (8 combinations) detected on TWO channels.
% -> combination of positive / negative / none 1-channel slow waves
%    on superficial and deep channels 
% -> deep and sup slow waves considered as co-occurring when peaks closer
% than 'cooccur_window' ms (100ms). When 2 co-occurring peaks with the same
% reference peak, keep only the co-occurring peak with highest amplitude
% value.
% -> slow waves = each type has a structure with : 
%                 - deep_peaktimes & sup_peaktimes :    ts of slow waves peak times (on deep and/or sup slow waves)
%                 - deep_peakamp & sup_peakamp :      tsd of slow waves peak amplitudes (on deep and/or sup slow waves)
%
%
% SEE : MakeSlowWavesOn2Channels_LP_old()
%
%
% Slow Wave Types (definitions) : 
%       1) deepneg-supneg
%       2) deepneg-suppos
%       3) deeppos-supneg 
%       4) deeppos-suppos
%       5) deepneg-øsup
%       6) deeppos-øsup
%       7) ødeep-supneg
%       8) ødeep-suppos
%
%
% ----------------- INPUTS ----------------- :
%
% - deep_ch  :  nº of deep LFP channel used for the detection
%
% - sup_ch  :  nº of sup LFP channel used for the detection
%                           
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
%   - 'foldername' :       folder path for the detection of slow waves
%                                   (default = pwd)
%
%   - 'epoch' :            epoch to which the detection is restricted
%                                   'all', 'sleep', 'SWS'
%                                   (default = 'all') 
%
%   - 'filterfreq' :       frequency range to filter the LFP signal
%                                   before extracting events
%                                   (default = [1 5])
%
%   - 'recompute' :        recompute event if file and variables already
%                                   exist
%                                   (default = 0)
%
%   - 'filename' :         name of .mat file with the events
%                                   (default = 'SlowWaves2Channels_LP') 
%
%   - 'cooccur_delay' :    max duration between sup and deep SW peaks to
%                           be detected as co-occurring slow waves, in ms
%                                   (default = 100)
%
%   - 'cooccur_sorting' :  method to assign slow wave type when multiple
%   slow waves of the 2nd channel cooccur. Can be 'amplitude' (keep the one 
%   with highest absolute peak amplitude) or 'delay' (keep the closest one)
%                                   (default = 'amplitude')
%
% ----------------- OUTPUTS ----------------- :
%
%                                       none
%
%
% ----------------- Example ----------------- :
%
% Ex.  MakeSlowWavesOn2Channels_LP(ChannelDeep, ChannelSup, 'epoch', 'all','filterfreq', [1 5]);


function MakeSlowWavesOn2Channels_LP(deep_ch,sup_ch, varargin)

    %% CHECK INPUTS

    if nargin < 2 || mod(length(varargin),2) ~= 0
      error('Incorrect number of parameters.');
    end

    % Parse parameter list :

    for i = 1:2:length(varargin)
        if ~ischar(varargin{i})
            error(['Parameter ' num2str(i+2) ' is not a property.']);
        end

        switch(lower(varargin{i}))
            case 'foldername'
                foldername = varargin{i+1};
            case 'filterfreq'
                filterfreq = varargin{i+1};
            case 'epoch'
                epochname = lower(varargin{i+1});
                if ~isstring_FMAToolbox(epochname, 'all' , 'sws', 'sleep')
                    error('Incorrect value for property ''epoch''.');
                end
            case 'recompute'
                recompute = varargin{i+1};
                if recompute~=0 && recompute ~=1
                    error('Incorrect value for property ''recompute''.');
                end
            case 'filename'
                filename = varargin{i+1};  
            case 'cooccur_delay'
                cooccur_delay = varargin{i+1}; 
            case 'cooccur_sorting'
                cooccur_sorting = varargin{i+1};    
            otherwise
                error(['Unknown property ''' num2str(varargin{i}) '''.']);
        end
    end

    %check if optional parameters exist and assign default value if not :

    if ~exist('foldername','var')
        foldername=pwd;
    end
    if ~exist('epochname','var')
        epochname='all';
    end
    if ~exist('filterfreq','var')
        filterfreq = [1 5];
    end
    if ~exist('filename','var')
        filename = 'SlowWaves2Channels_LP' ;
    end
    if ~exist('cooccur_delay','var')
        cooccur_delay = 100 ;
    end    
    if ~exist('cooccur_sorting','var')
        cooccur_sorting = 'amplitude' ;
    end  
    %recompute?
    if ~exist('recompute','var')
        recompute=0;
    end



    %check if already exist : return if already exists and recompute = 0
    if ~recompute
        if exist('SlowWaves2Channels_LP.mat','file')==2
            disp(['Slow Waves already generated.'])
            return
        end
    end


    %% PARAMETERS : 

    % See in MakeSlowWavesOnChannelsEvent_LP


    %% 1-CHANNEL SLOW WAVES DETECTION : 

    % Compute 1-channel slow waves if not already done :
    MakeSlowWavesOn1Channel_LP(sup_ch, 'foldername',foldername, 'epoch', 'all','filterfreq', [1 5]);
    MakeSlowWavesOn1Channel_LP(deep_ch, 'foldername',foldername, 'epoch', 'all','filterfreq', [1 5]);

    % Load 1-channel slow waves : 
    load('SlowWavesChannels_LP.mat')
    eval(['SWdeeppos = slowwave_ch_' num2str(deep_ch) '_pos ;'])
    eval(['SWdeepneg = slowwave_ch_' num2str(deep_ch) '_neg ;'])
    eval(['SWsuppos = slowwave_ch_' num2str(sup_ch) '_pos ;'])
    eval(['SWsupneg = slowwave_ch_' num2str(sup_ch) '_neg ;'])



    %% 2-CHANNEL SLOW WAVES SORTING : 

    disp('Computing 2-channel slow waves...') ;

    % All structures : 
    %   - slowwaves_type1
    %   - slowwaves_type2
    %   - slowwaves_type3
    %   - slowwaves_type4
    %   - slowwaves_type5
    %   - slowwaves_type6
    %   - slowwaves_type7
    %   - slowwaves_type8

    [SWsup,SWsup_isneg] = concat_tsd(SWsupneg.peakamp,SWsuppos.peakamp) ; % SWsup = tsd with peak amplitude (and times) of all sup slow waves. SWsupneg_ix = boolean vector, true when peak in SWsup belongs to SWsupneg
    [SWdeep,SWdeep_isneg] = concat_tsd(SWdeepneg.peakamp,SWdeeppos.peakamp) ; % SWsup = tsd with peak amplitude (and times) of all sup slow waves. SWsupneg_ix = boolean vector, true when peak in SWsup belongs to SWsupneg



    % --------------------------------- Sort by deep slow waves first --------------------------------- :


    %%%% Deep NEGATIVE SW (-> types 1/2/5) :
    disp('1/4...')

    SWdeepneg_times = Range(SWdeepneg.peaktimes) ; 
    SWsup_amp = Data(SWsup) ; 
    SWsup_t = Range(SWsup) ;
    
    % For each deep neg slow wave, get indices of co-occurring SWsup :

    for k=1:length(SWdeepneg_times) 
        peak_time = SWdeepneg_times(k) ; 
        intv = intervalSet(peak_time-cooccur_delay*10,peak_time+cooccur_delay*10) ; % interval around peak of deep SW to detect co-occurring sup SW peaks
        cooccur_supSW = belong(intv,Range(SWsup)) ; 
        SWdeepneg_cooccuridx{k} = find(cooccur_supSW) ; % store idx/indices of supSW cooccuring with this deepneg SW
    end


    % Sort by SW types depending on co-occurring SWsup : 

    cooccur_nb = cellfun('length',SWdeepneg_cooccuridx) ; % number of co-occuring SWsup

        % --- during no sup SW (type 5) --- :
        ix_type5 = find(cooccur_nb==0) ; 


        % --- during 1 sup SW --- : 
        ix_cooccur1 = find(cooccur_nb==1) ; %idx of deep SW cooccurring with 1 supSW

            % Look at whether co-occurring sup SW is negative (type 1) or positive (type 2)
            supix_cooccur1 = SWdeepneg_cooccuridx(ix_cooccur1) ; %idx of sup SW, for deep SW cooccurring with 1 supSW
            supix_cooccur1_isneg = logical(SWsup_isneg(cell2mat(supix_cooccur1))) ; 
            % Type 1 : 
            ix_type1 = ix_cooccur1(supix_cooccur1_isneg) ; 
            % Type 2 :
            ix_type2 = ix_cooccur1(~supix_cooccur1_isneg) ;


        % --- during >1 sup SW --- : 
        ix_cooccur2 = find(cooccur_nb>1) ; %idx of deep SW cooccurring with 1 supSW
        disp(['cases with multiple co-occurring slow waves detected :' num2str(length(ix_cooccur2))]) ; 
        
        all_SWtokeep_supix = [] ;
        if length(ix_cooccur2) > 0
            % Find co-occurring peak with highest absolute amplitude (or closest peak) :
            supix_cooccur2 = SWdeepneg_cooccuridx(ix_cooccur2) ; %idx of sup SW, for deep SW cooccurring with 2 supSW
            for i = 1:length(supix_cooccur2)
                tocompare_ix = supix_cooccur2{i} ; 
                
                switch cooccur_sorting
                    case 'amplitude' % if sort by peak amplitude 
                        [max_amp,max_ix] = max(abs(SWsup_amp(tocompare_ix)));
                        all_SWtokeep_supix(i) = tocompare_ix(max_ix) ; 
                    case 'delay' % if sort by peak delay
                        [min_delay,min_ix] = min(abs(SWsup_t(tocompare_ix)-peak_time));
                        all_SWtokeep_supix(i) = tocompare_ix(min_ix) ;
                end    
                
            end    

            % Look at whether co-occurring sup SW is negative (type 1) or positive (type 2)
            supix_cooccur2_isneg = logical(SWsup_isneg(all_SWtokeep_supix)) ; 
            % Type 1 : 
            ix_type1 = [ix_type1 ix_cooccur2(supix_cooccur2_isneg)] ; 
            % Type 2 :
            ix_type2 = [ix_type2 ix_cooccur2(~supix_cooccur2_isneg)] ;    
        end
        
    % Store slow wave peak amplitudes and peak times : 
    % peak amp : 
    slowwave_type5.deep_peakamp = subset(SWdeepneg.peakamp,ix_type5) ;   
    slowwave_type1.deep_peakamp = subset(SWdeepneg.peakamp,sort(ix_type1)) ;
    slowwave_type2.deep_peakamp = subset(SWdeepneg.peakamp,sort(ix_type2)) ;
    % peak times :
    slowwave_type5.deep_peaktimes = ts(Range(slowwave_type5.deep_peakamp)) ;   
    slowwave_type1.deep_peaktimes = ts(Range(slowwave_type1.deep_peakamp)) ;   
    slowwave_type2.deep_peaktimes = ts(Range(slowwave_type2.deep_peakamp)) ;   




    %%%% Deep POSITIVE SW (-> types 3/4/6) :
    disp('2/4...')

    SWdeeppos_times = Range(SWdeeppos.peaktimes) ; 
    SWsup_amp = Data(SWsup) ; 
    SWsup_t = Range(SWsup) ;

    % For each deep neg slow wave, get indices of co-occurring SWsup :

    for k=1:length(SWdeeppos_times) 
        peak_time = SWdeeppos_times(k) ; 
        intv = intervalSet(peak_time-cooccur_delay*10,peak_time+cooccur_delay*10) ; % interval around peak of deep SW to detect co-occurring sup SW peaks
        cooccur_supSW = belong(intv,Range(SWsup)) ; 
        SWdeeppos_cooccuridx{k} = find(cooccur_supSW) ; % store idx/indices of supSW cooccuring with this deepneg SW
    end


    % Sort by SW types depending on co-occurring SWsup : 

    cooccur_nb = cellfun('length',SWdeeppos_cooccuridx) ; % number of co-occuring SWsup

        % --- during no sup SW (type 6) --- :
        ix_type6 = find(cooccur_nb==0) ; 


        % --- during 1 sup SW --- : 
        ix_cooccur1 = find(cooccur_nb==1) ; %idx of deep SW cooccurring with 1 supSW

            % Look at whether co-occurring sup SW is negative (type 1) or positive (type 2)
            supix_cooccur1 = SWdeeppos_cooccuridx(ix_cooccur1) ; %idx of sup SW, for deep SW cooccurring with 1 supSW
            supix_cooccur1_isneg = logical(SWsup_isneg(cell2mat(supix_cooccur1))) ; 
            % Type 3 : 
            ix_type3 = ix_cooccur1(supix_cooccur1_isneg) ; 
            % Type 4 :
            ix_type4 = ix_cooccur1(~supix_cooccur1_isneg) ;


        % --- during >1 sup SW --- : 
        ix_cooccur2 = find(cooccur_nb>1) ; %idx of deep SW cooccurring with 1 supSW 
        disp(['cases with multiple co-occurring slow waves detected :' num2str(length(ix_cooccur2))]) ; 

        all_SWtokeep_supix = [] ; 
        if length(ix_cooccur2) > 0
            % Find co-occurring peak with highest absolute amplitude :
            supix_cooccur2 = SWdeeppos_cooccuridx(ix_cooccur2) ; %idx of sup SW, for deep SW cooccurring with 2 supSW
            for i = 1:length(supix_cooccur2)
                tocompare_ix = supix_cooccur2{i} ; 
                
                switch cooccur_sorting
                    case 'amplitude' % if sort by peak amplitude 
                        [max_amp,max_ix] = max(abs(SWsup_amp(tocompare_ix)));
                        all_SWtokeep_supix(i) = tocompare_ix(max_ix) ; 
                    case 'delay' % if sort by peak delay
                        [min_delay,min_ix] = min(abs(SWsup_t(tocompare_ix)-peak_time));
                        all_SWtokeep_supix(i) = tocompare_ix(min_ix) ;
                end   
                
            end    

            % Look at whether co-occurring sup SW is negative (type 1) or positive (type 2)
            supix_cooccur2_isneg = logical(SWsup_isneg(all_SWtokeep_supix)) ; 
            % Type 3 : 
            ix_type3 = [ix_type3 ix_cooccur2(supix_cooccur2_isneg)] ; 
            % Type 4 :
            ix_type4 = [ix_type4 ix_cooccur2(~supix_cooccur2_isneg)] ;    
        end

    % Store slow wave peak amplitudes and peak times : 
    % peak amp : 
    slowwave_type6.deep_peakamp = subset(SWdeeppos.peakamp,ix_type6) ;   
    slowwave_type3.deep_peakamp = subset(SWdeeppos.peakamp,sort(ix_type3)) ;
    slowwave_type4.deep_peakamp = subset(SWdeeppos.peakamp,sort(ix_type4)) ;
    % peak times :
    slowwave_type6.deep_peaktimes = ts(Range(slowwave_type6.deep_peakamp)) ;   
    slowwave_type3.deep_peaktimes = ts(Range(slowwave_type3.deep_peakamp)) ;   
    slowwave_type4.deep_peaktimes = ts(Range(slowwave_type4.deep_peakamp)) ;   







    % --------------------------------- Sort by sup slow waves first --------------------------------- :



    %%%% Sup NEGATIVE SW (-> types 1/3/7) :
    disp('3/4...')

    SWsupneg_times = Range(SWsupneg.peaktimes) ; 
    SWdeep_amp = Data(SWdeep) ; 
    SWdeep_t = Range(SWdeep) ;
    
    % For each sup neg slow wave, get indices of co-occurring SWdeep :

    for k=1:length(SWsupneg_times) 
        peak_time = SWsupneg_times(k) ; 
        intv = intervalSet(peak_time-cooccur_delay*10,peak_time+cooccur_delay*10) ; % interval around peak of sup SW to detect co-occurring deep SW peaks
        cooccur_deepSW = belong(intv,Range(SWdeep)) ; 
        SWsupneg_cooccuridx{k} = find(cooccur_deepSW) ; % store idx/indices of deepSW cooccuring with this supneg SW
    end


    % Sort by SW types depending on co-occurring SWdeep : 

    cooccur_nb = cellfun('length',SWsupneg_cooccuridx) ; % number of co-occuring SWdeep

        % --- during no deep SW (type 7) --- :
        ix_type7 = find(cooccur_nb==0) ; 


        % --- during 1 deep SW --- : 
        ix_cooccur1 = find(cooccur_nb==1) ; %idx of deep SW cooccurring with 1 deepSW

            % Look at whether co-occurring deep SW is negative (type 1) or positive (type 3)
            deepix_cooccur1 = SWsupneg_cooccuridx(ix_cooccur1) ; %idx of deep SW, for sup SW cooccurring with 1 deepSW
            deepix_cooccur1_isneg = logical(SWdeep_isneg(cell2mat(deepix_cooccur1))) ; 
            % Type 1 : 
            ix_type1 = ix_cooccur1(deepix_cooccur1_isneg) ; 
            % Type 3 :
            ix_type3 = ix_cooccur1(~deepix_cooccur1_isneg) ;


        % --- during >1 sup SW --- : 
        ix_cooccur2 = find(cooccur_nb>1) ; %idx of sup SW cooccurring with 1 deepSW 
        disp(['cases with multiple co-occurring slow waves detected :' num2str(length(ix_cooccur2))]) ; 
        
        all_SWtokeep_deepix = [] ;
        if length(ix_cooccur2) > 0
            % Find co-occurring peak with highest absolute amplitude :
            deepix_cooccur2 = SWsupneg_cooccuridx(ix_cooccur2) ; %idx of deep SW, for sup SW cooccurring with 2 deepSW
            for i = 1:length(deepix_cooccur2)
                tocompare_ix = deepix_cooccur2{i} ; 
                
                switch cooccur_sorting
                    case 'amplitude' % if sort by peak amplitude 
                        [max_amp,max_ix] = max(abs(SWdeep_amp(tocompare_ix)));
                        all_SWtokeep_deepix(i) = tocompare_ix(max_ix) ;
                    case 'delay' % if sort by peak delay
                        [min_delay,min_ix] = min(abs(SWdeep_t(tocompare_ix)-peak_time));
                        all_SWtokeep_deepix(i) = tocompare_ix(min_ix) ;
                end   
                 
            end    

            % Look at whether co-occurring deep SW is negative (type 1) or positive (type 3)
            deepix_cooccur2_isneg = logical(SWdeep_isneg(all_SWtokeep_deepix)) ; 
            % Type 1 : 
            ix_type1 = [ix_type1 ix_cooccur2(deepix_cooccur2_isneg)] ; 
            % Type 3 :
            ix_type3 = [ix_type3 ix_cooccur2(~deepix_cooccur2_isneg)] ;    
        end

    % Store slow wave peak amplitudes and peak times : 
    % peak amp : 
    slowwave_type7.sup_peakamp = subset(SWsupneg.peakamp,ix_type7) ;   
    slowwave_type1.sup_peakamp = subset(SWsupneg.peakamp,sort(ix_type1)) ;
    slowwave_type3.sup_peakamp = subset(SWsupneg.peakamp,sort(ix_type3)) ;
    % peak times :
    slowwave_type7.sup_peaktimes = ts(Range(slowwave_type7.sup_peakamp)) ;   
    slowwave_type1.sup_peaktimes = ts(Range(slowwave_type1.sup_peakamp)) ;   
    slowwave_type3.sup_peaktimes = ts(Range(slowwave_type3.sup_peakamp)) ;   




    %%%% Sup POSITIVE SW (-> types 2/4/8) :
    disp('4/4...')

    SWsuppos_times = Range(SWsuppos.peaktimes) ; 
    SWdeep_amp = Data(SWdeep) ; 
    SWdeep_t = Range(SWdeep) ;

    % For each sup pos slow wave, get indices of co-occurring SWdeep :

    for k=1:length(SWsuppos_times) 
        peak_time = SWsuppos_times(k) ; 
        intv = intervalSet(peak_time-cooccur_delay*10,peak_time+cooccur_delay*10) ; % interval around peak of sup SW to detect co-occurring deep SW peaks
        cooccur_deepSW = belong(intv,Range(SWdeep)) ; 
        SWsuppos_cooccuridx{k} = find(cooccur_deepSW) ; % store idx/indices of deepSW cooccuring with this suppos SW
    end


    % Sort by SW types depending on co-occurring SWdeep : 

    cooccur_nb = cellfun('length',SWsuppos_cooccuridx) ; % number of co-occuring SWdeep

        % --- during no deep SW (type 8) --- :
        ix_type8 = find(cooccur_nb==0) ; 


        % --- during 1 deep SW --- : 
        ix_cooccur1 = find(cooccur_nb==1) ; %idx of deep SW cooccurring with 1 deepSW

            % Look at whether co-occurring deep SW is negative (type 2) or positive (type 4)
            deepix_cooccur1 = SWsuppos_cooccuridx(ix_cooccur1) ; %idx of deep SW, for sup SW cooccurring with 1 deepSW
            deepix_cooccur1_isneg = logical(SWdeep_isneg(cell2mat(deepix_cooccur1))) ; 
            % Type 2 : 
            ix_type2 = ix_cooccur1(deepix_cooccur1_isneg) ; 
            % Type 4 :
            ix_type4 = ix_cooccur1(~deepix_cooccur1_isneg) ;


        % --- during >1 sup SW --- : 
        ix_cooccur2 = find(cooccur_nb>1) ; %idx of sup SW cooccurring with 1 deepSW 
        disp(['cases with multiple co-occurring slow waves detected :' num2str(length(ix_cooccur2))]) ; 
        
        all_SWtokeep_deepix = [] ;
        if length(ix_cooccur2) > 0
            % Find co-occurring peak with highest absolute amplitude :
            deepix_cooccur2 = SWsuppos_cooccuridx(ix_cooccur2) ; %idx of deep SW, for sup SW cooccurring with 2 deepSW
            for i = 1:length(deepix_cooccur2)
                tocompare_ix = deepix_cooccur2{i} ; 
                
                switch cooccur_sorting
                    case 'amplitude' % if sort by peak amplitude 
                        [max_amp,max_ix] = max(abs(SWdeep_amp(tocompare_ix)));
                        all_SWtokeep_deepix(i) = tocompare_ix(max_ix) ;
                    case 'delay' % if sort by peak delay
                        [min_delay,min_ix] = min(abs(SWdeep_t(tocompare_ix)-peak_time));
                        all_SWtokeep_deepix(i) = tocompare_ix(min_ix) ;
                end     

            end    

            % Look at whether co-occurring deep SW is negative (type 1) or positive (type 3)
            deepix_cooccur2_isneg = logical(SWdeep_isneg(all_SWtokeep_deepix)) ; 
            % Type 2 : 
            ix_type2 = [ix_type2 ix_cooccur2(deepix_cooccur2_isneg)] ; 
            % Type 4 :
            ix_type4 = [ix_type4 ix_cooccur2(~deepix_cooccur2_isneg)] ;    
        end

    % Store slow wave peak amplitudes and peak times : 
    % peak amp : 
    slowwave_type8.sup_peakamp = subset(SWsuppos.peakamp,ix_type8) ;   
    slowwave_type2.sup_peakamp = subset(SWsuppos.peakamp,sort(ix_type2)) ;
    slowwave_type4.sup_peakamp = subset(SWsuppos.peakamp,sort(ix_type4)) ;
    % peak times :
    slowwave_type8.sup_peaktimes = ts(Range(slowwave_type8.sup_peakamp)) ;   
    slowwave_type2.sup_peaktimes = ts(Range(slowwave_type2.sup_peakamp)) ;   
    slowwave_type4.sup_peaktimes = ts(Range(slowwave_type4.sup_peakamp)) ;   


    %% SAVE OUTPUT 
    
    % Save detection parameters : 
    detection_parameters.deepchannel = deep_ch ; 
    detection_parameters.supchannel = sup_ch ; 
    detection_parameters.cooccur_delay = cooccur_delay ; 
    
    % Save file : 
    save(fullfile(foldername,[filename '.mat']), 'slowwave_type1', 'slowwave_type2', 'slowwave_type3', 'slowwave_type4', 'slowwave_type5', 'slowwave_type6', 'slowwave_type7', 'slowwave_type8', 'detection_parameters')
    disp('Done') 

end











