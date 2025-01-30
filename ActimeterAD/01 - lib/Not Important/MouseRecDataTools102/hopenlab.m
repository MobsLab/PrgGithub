function [par, endit] = hopenlab(p_nam, mtfile)
%  This function either prompts the user to open the LabVIEW file 
%  *.FeatVec with feature values computed from the MouseRec program
%  or if input argments are given, it directly opens the file
%  specified in the input arguments.
%
%    [par, endit] = hopenlab(pnam1, featvecfile)
%
%  Input arguments:
%     PNAM1 -  (required) string denoting path where file seach will
%     begin.  Use an empty matrix, [], if the current directory is desired.
%     FEATVECFILE -  string denoting name of *.FeatVec file.  (String
%     should contain extension)
%     
%  Output arguments:
%     PAR - data structure containing all the parameters stored in file
%     header along with the vector of sleepwake decisions.
%           par.headerinfo - structure with header information
%           par.sw - columnwise matrix with sleepwake decision stats for each
%           channel
%           par.swtrim - same as sw with stats cliped in [-6 6] range
%     ENDIT - Flag donoting if a file was opened (1) or not (0).
%
%       Dependencies: ostat()
% 
%    Updated by Kevin D. Donohue (kevin.donohue@sigsoln.com) July 2011

tinc=2;  %  Window increment in seconds for feature extraction (seconds)
stpt = 8/2;  %  Initial time point as the middle of the analysis window (seconds)
endit = 0;  %  Initalize open file flag to 0 (not opened)
par.pnam = 0;  % Initalize file path
par.fnam = 0;  % Initalize file name

%  Cases based on number of input arguments:
%  If just required path name is present prompt the user for the file and
%  start in the provided path:
if nargin == 1
    
	[fnam1, pnam1] = uigetfile([p_nam, {'*.FeatVec'; '*.featvec'}],'Select file with sleep-wake statistics');
    if isequal(fnam1,0)||isequal(pnam1,0)  % If file does not exist
        nooph = warndlg('File not found');   %  Give error and set flag
        pause(1)
        if ishandle(nooph)
            close(nooph);
        end
    else     %  File exists open it
        
        %  Open file assigning header values and sleep-wake decision statistic
        %  to data structure fields

        featurefile = [pnam1 fnam1];
        [par] = ostat(featurefile);
        par.pnam = pnam1;
        par.fnam = fnam1;
        %  Create a time axis in hours.  rws is number sleep-wake stats
        if  isfield(par,'sw') 
        [rws,cls] = size(par.sw);
        if rws ~= 0
            dtca = stpt +[0:rws-1]*tinc;  %  Time axis with half anaysis window offset
            %  Start time is seconds from midnight
            tst = par.headerinfo.sh*60^2+par.headerinfo.sm*60+par.headerinfo.ss;
            %  Time axis in hours
            par.taxhr = (tst+dtca)/60^2;  % Time array for each sample
            endit = 1;
        else
            endit = 0;
            par.txhr = [];
        end
        else
            endit = 0;
            par.txhr = [];
        end
    end
        
    % If file name is specified of the matfile
elseif nargin == 2
    featurefile= [pnam1 mtfile];
    fnam1=mtfile; 
    if isequal(fnam1,0)||isequal(pnam1,0)  % If file does not exist
        nooph = warndlg('File not found');   %  Give error and set flag
        pause(1)
        if ishandle(nooph)
            close(nooph);
        end
    else     %  File file exist open it and look for feature vector file with same base name
        featurefile = [pnam1 fnam1];
        [par] = ostat(featurefile);
        par.pnam = pnam1;
        par.fnam = fnam1;
        %  Create a time axis in hours
        [rws,cls] = size(par.sw);
        if rws ~= 0
            dtca = stpt +[0:rws-1]*tinc;
            tst = par.headerinfo.sh*60^2+par.headerinfo.sm*60+par.headerinfo.ss;
            par.taxhr = (tst+dtca)/60^2;  % Time array for each sample
            endit = 1;
        else
            endit = 0;
            par.txhr = [];
        end
    end
end

%  If file opened, check for changes in the database/matfile file.
%  Test to ensure all the data componts are present in the matfile


if endit == 1
    
    %  Test to see if corresponding mat file is present in the directory
     omat = [featurefile(1:end-7), 'mat'];
     % if it exists, load up the most recent parameters changes 
     if 2 == exist(omat)
        dd=load(omat);
        newparfieldvals = struct2cell(dd);
        newparfieldnames = fieldnames(dd);
 
        for fk=1:length(newparfieldnames)
            par = setfield(par,newparfieldnames{fk},newparfieldvals{fk});
        end
     end  
 end






