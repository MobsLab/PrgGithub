classdef MetaData < handle
    %METADATA Class to handle the metadata of an experiment
    %   This class stores the metadata of an experiment and offers methods
    %   to easily save or load them.
    %
    % by antoine.delhomme@espci.fr
    
    properties (Abstract = true)
        % _metadatas_   list of the properties to save as metadata
    end
    
    methods
        function s = saveobj(obj)
            %Save
            %
            
        end
    end
    
end

