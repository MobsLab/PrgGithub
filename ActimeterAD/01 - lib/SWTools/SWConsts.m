classdef (Sealed) SWConsts
    %SWConsts Define constants link to activity monitoring
    %   
    %   Warning. This class follows the Singleton Pattern from
    %   http://www.mathworks.com/help/matlab/matlab_oop/controlling-the-number-of-instances.html
    %   Please use SWConsts.getInstance to use the class.
    %
    % developed for the ProjetSLEEPcontrol-Antoine project
    % by antoine.delhomme@espci.fr
    %
    
    properties (Constant)
        % States
        %   IS_SLEEPING:        a mouse is sleeping
        %   IS_AWAKE:           a mouse is awake
        IS_SLEEPING = -1;
        IS_AWAKE = 1;
        
        % Events constant
        %   EVT_WAKE_UP:            a mouse wakes up
        %   EVT_WAKE_UP_CORR:       a mouse wakes up, corrected timestamps in
        %                           in parameter (delta in comparison of
        %                           the timestamps of the event)
        %   EVT_FALL_ASLEEP:        a mouse falls asleep
        %   ECT_FALL_ASLEEP_CORR:   a mouse falls asleep, corrected
        %                           timestamps in parameter (delta in
        %                           comparison of the timestamps of the
        %                           event)
        EVT_WAKE_UP = 1;
        EVT_WAKE_UP_CORR = 2;
        EVT_FALL_ASLEEP = -1;
        EVT_FALL_ASLEEP_CORR = -2;
        %   EVT_IS_AWAKE:           the mouse is awake according to the raw
        %                           activity scoring
        %   EVT_IS_SLEEPING:        the mouse is sleeping according to the
        %                           raw activity scoring
        EVT_IS_AWAKE = 3;
        EVT_IS_SLEEPING = -3;
        %   EVT_SOUND_STOP
        %   EVT_SOUND
        %   EVT_SOUND_OSC
        %   EVT_SOUND_TRAIN
        %   EVT_SOUND_STIM
        EVT_SOUND_STOP = 10;
        EVT_SOUND = 11;
        EVT_SOUND_OSC = 12;
        EVT_SOUND_TRAIN = 13;
        EVT_SOUND_STIM = 14;
        EVT_NOTHING = 30;
    end
    
    methods (Access = private)
        function obj = SWConsts()
            %Nothing to do
        end
    end
    
    methods (Static)
        function singleObj = getInstance()
            persistent localObj
            
            % If the object doesn't exist, create it
            if isempty(localObj)
                localObj = SWConsts();
            end
            
            % Return the object
            singleObj = localObj;
        end
    end
    
end

