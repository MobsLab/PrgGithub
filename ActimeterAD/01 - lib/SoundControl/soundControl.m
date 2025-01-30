classdef (Sealed) soundControl < handle
    %SOUNDCONTROL Drive up to 12 sound channels
    %   Drive an Arduino to control up to 12 sound channels. For each
    %   channel, it is possible to select which sound is provided from two
    %   sources (typically a white noise and a tune) and to tune its
    %   gain (ie volume).
    %
    %   Warning. This class follows the Singleton Pattern from
    %   http://www.mathworks.com/help/matlab/matlab_oop/controlling-the-number-of-instances.html
    %   Please use soundControl.getInstance to get use the class.
    %
    %   Remark. The Arduino has to be loaded with soundControl.ino
    %
    % by antoine.delhomme@espci.fr
    %
    
    properties (Constant)
        % Constants
        % Sound index
        %   SOUND_NOISE:    white noise
        %   SOUND_TUNE:     tune (typically at 5kHz)
        SOUND_NOISE = 0;
        SOUND_TUNE = 1;
        % Mode index
        %   MODE_NONE:      default mode
        %   MODE_OSC:       modulation with a sinus
        %   MODE_RAMP:      modulation with a ramp
        %   MODE_TRAIN:     modulation with a train of pulses
        MODE_NONE = 0;
        MODE_OSC = 1;
        MODE_RAMP = 2;
        MODE_TRAIN = 3;
    end
    
    properties
        % General properties
        %   port:       port on which the Arduino is connected
        %   baudRtae:   baudrate of the connexion
        port;
        baudRate;
        
        % Intern objects
        %   s:  serial connexion
        s;
        
    end
    
    methods (Access = private)
        function obj = soundControl(port, baudRate)
            %soundControl Constructor of the class
            %   Init the serial connexion
            %
            
            fprintf('[soundControl] Init the serial connexion ...');
            
            obj.s = serial(port);
            set(obj.s,'BaudRate', baudRate);
            fopen(obj.s);
            
            % A pause is necessary as Matlab causes some disorder with the
            % Arduino opening the serial connexion.
            pause(1);
            
            fprintf('\t[Done]\n');
        end
    end
    
    methods (Static)
        function singleObj = getInstance(port, baudRate)
            persistent localObj
            
            % If those parameters are not given, set them to some
            % default values.
            if nargin < 1
                port = 'COM21';
            end

            if nargin < 2
                baudRate = 9600;
            end
            
            if isempty(localObj) || ~isvalid(localObj) 
                localObj = soundControl(port, baudRate);
            elseif (strcmp(port, localObj.port))
                warning('soundControl is currently configure with port %s. You have to delete it before trying tu use another port. (%s)', localObj.port, port');
            elseif (baudRate ~= localObj.baudRate)
                warning('soundControl is currently configure with baudrate %d. You have to delete it before trying tu use another baudrate. (%s)', localObj.baudRate, baudRate');
            end
            
            singleObj = localObj;
        end
    end
    
    methods
        function setChannel(obj, channelID, source, gain, mode)
            % setChannel Set the source and the gain of a channel
            %   channelID:  id of the channel (typically from 0 to 11)
            %   source:     in soundControl.SOUND_*
            %   gain:       from 0 to 255
            %               gain (dB) = 31.5 - 0.5*(255 - gain)
            %                   gain = 0   --> -inf dB
            %                   gain = 1   --> -95.6 dB
            %                   gain = 192 -->  0 dB
            %                   gain = 255 -->  3.1 dB
            %   mode:       in soundCOntrol.MODE_*
            %
            
            if (nargin < 5)
                mode = obj.MODE_NONE;
            end
            
            if (source ~= obj.SOUND_NOISE) ...
                    && (source ~= obj.SOUND_TUNE)
                error('soundControl:BadInput', 'Unknown source index: %d.\n', source);
            end
            
            if gain < 0 || gain > 255
                error('soundControl:BadInput', 'Gain out of limits [0, 255] (gain = %d).\n', gain);
            end
            
            if (mode ~= obj.MODE_NONE) ...
                    && (mode ~= obj.MODE_OSC) ...
                    && (mode ~= obj.MODE_RAMP) ...
                    && (mode ~= obj.MODE_TRAIN)
                error('soundControl:BadInput', 'Unknown mode index: %d\n', mode);
            end
            
            fwrite(obj.s, channelID - 1, 'uchar' );
            fwrite(obj.s, source + bitshift(mode, 4), 'uchar' );
            fwrite(obj.s, gain, 'uchar' );
        end
        
        function delete(obj)
            %DELETE Delete properly the object
            %
            
            fprintf('[soundControl] Close the serial connexion ...');
            
            % Close the serial connexion
            fclose(obj.s);
            delete(obj.s);
            
            fprintf('\t[Done]\n');
        end
    end
    
end

