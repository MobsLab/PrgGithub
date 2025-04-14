function CreateEvent_CH(Epoch,extens,varargin)
% This function allows visualisation of epochs on Neuroscope
% The Epoch entry must be an intervalSet with Start and Stop
% extens is a string with the name of the epoch (3 letters)

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch lower(varargin{i})
        case 'tag'
            tag = varargin{i+1};
    end
end

if ~exist('tag','var')
    extens = '';
end


clear evt

if exist('Epoch', 'var') && ~isempty(Epoch)
    
    Sta = Start(Epoch)/1e4;
    Sto = Stop(Epoch)/1e4;
    
    n = length(Sta);
    
    if n > 0
        
        evt.time = reshape([Sta(:)'; Sto(:)'], [], 1);
        evt.description = {};
        
        for i = 1:n
            evt.description{2*i-1} = strcat(tag,' start');
            evt.description{2*i} = strcat(tag,' stop');
        end
        
        CreateEvent(evt, extens, extens);
        
    else
        evt.time = [0];
        evt.description = {'No epoch detected'};
        
        CreateEvent(evt, extens, extens);
        disp('No epoch detected')
    end
else
    
    Yes = input('Epoch is empty or non-existing, do you want to create an empty event file? (0/1)')
    
    if Yes == 1
        evt.time = [0];
        evt.description = {'No epoch detected'};
        
        CreateEvent(evt, extens, extens);
        disp('No epoch detected')
    else
        disp('No epoch event created')
    end
    
end
end



