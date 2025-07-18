% DROPBOX  Return root path of local Dropbox folder
%    PATH = DROPBOX() returns the path.
%    PATH = DROPBOX(RELATIVE) returns the full path to a file or folder
%    relative to the root Dropbox path.
%
% DROPBOX keeps track of the location of your Dropbox folder across
% different machines and operating systems. On first-time use, it asks the
% user to locate the local Dropbox folder through a GUI window. The m-file
% then updates itself to recognize different machines through their
% hostname, so that only one copy of the file is needed (that you can keep
% in your Dropbox). DROPBOX does not rely on MATLAB preferences so it is
% robust across MATLAB versions and after fresh installs.
%
% Because the file edits itself, user changes are not recommended; the name
% of the file can be changed, however.

% DO NOT EDIT THIS FILE %

function p = GitHubLocation(varargin)

switch strtrim(evalc('system(''hostname'');'))
    % Start hostname cases
    case 'gruffalo'
        p = fullfile('/home/gruffalo/',varargin{:});
    case 'MobsEcolo'
        p = fullfile('/home/greta',varargin{:});
    case 'mobshamilton-HP-Z440-Workstation'
        p = fullfile('/home/mobshamilton/Desktop/Alice/GitHub/',varargin{:});
    case 'pinky'
        p = fullfile('/home/pinky/Documents',varargin{:});
    case 'mouse'
        p = fullfile('/home/mickey/Documents/Theotime', varargin{:});
    case 'ratatouille'
        p = fullfile('/home/ratatouille/', varargin{:});
    case 'pinky-VirtualBox'
        p = fullfile('/media/sf_mickey/Documents/Theotime', varargin{:});
    case 'mobs'
        p = fullfile('/home/bernard/', varargin{:});
        
        % End hostname cases
    otherwise
        dbdr = uigetdir(pwd,'Please locate your GitHub folder.');
        if ~dbdr
            error('GitHub:GitHub:folderNotFound',...
                'Your GitHub folder could not be located.')
        end
        tempfile = tempname();
        thisfile = which(mfilename);
        fi = fopen(thisfile,'r');
        fo = fopen(tempfile,'wt');
        if fo<0
            error('GitHub:GitHub:tempnameFailed',...
                'Could not write temporary file to %s.',tempfile);
        end
        while ~feof(fi)
            buffer = fgetl(fi);
            buffer
            if strcmp(buffer,'%##%')
                keyboard
                thishost = strtrim(evalc('system(''hostname'');'));
                fprintf(fo,'    case ''%s''\n',thishost);
                fprintf(fo,'        p = fullfile(''%s'',varargin{:});\n',dbdr);
            end
            fprintf(fo,'%s\n',buffer);
        end
        fclose(fi);
        fclose(fo);
        [success errmsg errid] = movefile(tempfile,thisfile,'f');
        if ~success
            error(errid,errmsg);
        end
        fprintf('Host ''%s'' added to %s.m!\n',thishost,mfilename);
end
