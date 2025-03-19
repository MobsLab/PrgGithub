function DirR = RestrictListOfClinicalTrial(Dir, varargin)
%   DirR = RestrictPathForExperiment(Dir,varargin)
%
% INPUT:
% - Dir                     Struct - List of Experiments 
% 
% - night                   (optional) double array
%                           Night number(s)
% - subject                 (optional) double array
%                           Subject number(s)
% - date                    (optional) string
%                           Record date(s)
%
%
% OUTPUT:
% - DirR                    Struct - List of Experiments 
%
%
% SEE 
%   FusionListOfClinicalTrial
%


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin),
    if ~ischar(varargin{i}),
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i})),
        case 'night',
            night = varargin{i+1};
            if ~isvector(night)
                error('Incorrect value for property ''night''.');
            end
        case 'subject',
            subject = varargin{i+1};
            if ~isvector(subject)
                error('Incorrect value for property ''subject''.');
            end
        case 'date',
            date = varargin{i+1};
            if ~isstring(date) && ~isstruct(date)
                error('Incorrect value for property ''date''.');
            end

        otherwise,
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%% Selection

if exist('night','var')
    night_selected = ismember(Dir.night,night);
else
    night_selected = ones(length(Dir.night));
end

if exist('subject','var')
    subject_selected = ismember(Dir.subject,subject);
else
    subject_selected = ones(length(Dir.subject));
end

if exist('date','var')
    date_selected = ismember(Dir.date,date);
else
    date_selected = ones(length(Dir.date));
end

record_selected = night_selected .* subject_selected .* date_selected;


%% Dir
DirR.filereference = Dir.filereference(record_selected);
DirR.filename = Dir.filename(record_selected);
DirR.processing = Dir.processing(record_selected);
DirR.date = Dir.date(record_selected);
DirR.subject = Dir.subject(record_selected);
DirR.night = Dir.night(record_selected);
DirR.condition = Dir.condition(record_selected);
DirR.channel_sw = Dir.channel_sw(record_selected);

end
