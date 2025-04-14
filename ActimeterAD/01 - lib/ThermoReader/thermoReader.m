classdef thermoReader < handle
    %THERMOREADER Read the temperature from the serial port
    %   Collect the temperature value send by an Arduino on the serial port
    %   using the thermoReader program.
    %
    % by antoine.delhomme@espci.fr
    %
    
    properties
        % General properties
        %   port:       port on which the Arduino is connected
        %   baudRtae:   baudrate of the connexion
        port;
        baudRate;
        
        % Intern object
        %   s:          handle of the serial connexion
        s;
    end
    
    methods
        function obj = thermoReader(port, baudRate)
            %thermoReader Constructor of the class
            %
            
            % If those parameters are not given, set them to some default
            % values.
            if nargin < 1
                obj.port = 'COM21';
            else
                obj.port = port;
            end
            
            if nargin < 2
                obj.baudRate = 9600;
            else
                obj.baudRate = baudRate;
            end
            
            % Init the serial connexion
            %   It is set up in manual mode to read the temperature only
            %   when it is needed.
            obj.s = serial(obj.port);
            set(obj.s, 'BaudRate', obj.baudRate);
            obj.s.ReadAsyncMode = 'manual';

            fopen(obj.s);
        end
        
        function t = getTemperature(obj)
            % getTemperature Get the temperature from the sensor
            %   Get the temperature from the serial connexion, a delay may
            %   occur. Its maximum value is given by the time between two
            %   redings of the sensor by the Arduino. (typically 2s)
            %
            
            % Read the temperature from the serial connexion
            obj.s.readasync();
            t = fscanf(obj.s, '%f', 4);
        end
        
        function delete(obj)
            %DELETE     Delete properly the object
            %
            
            % Close the serial connexion
            fclose(obj.s);
            delete(obj.s);
        end
    end
    
end

