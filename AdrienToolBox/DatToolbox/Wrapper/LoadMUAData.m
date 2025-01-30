function [S,shank] = LoadMUAData(fbasename,varargin)

[fbasename mergedir rootdir] = extractfbasename(fbasename);
fname = [rootdir filesep fbasename];

syst = LoadXml([fname '.xml'],'raw');
Fs = syst.SampleRate/10000; %TS toolbox works in 10^-4 s!

if ~isempty(varargin)
    channels = varargin{1};
else
    channels = (1:length(syst.SpkGrps));
end

try
    channels = channels(:)';
    S = {};
    shank = [];
    for ch=channels

        if exist([fname '.clu.' num2str(ch)],'file') && exist([fname '.res.' num2str(ch)],'file')
            clu = load([fname '.clu.' num2str(ch)]);
            res = load([fname '.res.' num2str(ch)]);

            clu = clu(2:end);
            S = [S;{ts(res(clu>0)/Fs)}];
            shank = [shank;ch];
            
        end

    end

    S = tsdArray(S);
    
catch
    warning(lasterr);
    keyboard
end
