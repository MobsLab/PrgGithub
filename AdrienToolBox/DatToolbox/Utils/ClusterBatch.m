function ClusterBatch(FunctName,JobName,varargin)


OwnerEmail = 'adrien.peyrache@gmail.com';

Nargin = length(varargin);
Nloops = length(varargin{1});

for ii=2:Nargin
    if length(varargin{ii}) ~= Nloops
        error(['Number of elements in argument #' num2str(ii) ' not compatible with the number ofelements in the first one']);
    end
end

for ii=1:Nloops
    if Nargin>0
        matlab_command = [FunctName '('];
        for jj=1:Nargin-1
            v = varargin{jj};
            v = v{ii};
            if jj>1
                v = [',' v];
            end
            matlab_command = [matlab_command v];
        end
        matlab_command = [matlab_command ')'];
    else
        matlab_command = FunctName;
    end
    keyboard
    %NyuFenMatlabBash([JobName '_' num2str(ii)],OwnerEmail,matlab_command);
end