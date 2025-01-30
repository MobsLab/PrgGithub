function concatfileslab()
% This program allows the user to select a sequence of feature vector files
%(*.FeatVec) created by MouseRec and concatenates them together.  No input
% arguments are requred. On execution a file navagator interface appears.
% Use this to select the files for concatenation and click "cancel" after
% all the files have been selected. It then extracts the start times from
% each file to determine the order of concatenation.  NaN values are
% inserted for samples that would have occured in the time gap. The
% concatenated sequence is save as a single file with the same file name
% as the earliest file, but ending with "cc" 
%
%   Written by Kevin D. Donohue, March 2012 (kevin.donohue@sigsoln.com)

%  Open file / Program Quit Menu Option
tinc=2;  %  Window increment in seconds for feature extraction (seconds)
stpt = 8/2;  %  Initial time point as the middle of the analysis window (seconds)
nflago = 'd';   %   Set dummy value to start menu in while loop
endit = 0;  % initalze file open to "Not Open"
anflago = ['o', 'v'];   %  flag values to generate desired actions
%  Loop to open and merge files until exit is selected
while (nflago ~= 'v')
    % Generate Menu
    kflago = menu('Program Options', 'Open Files to Merge', 'Exit Program');
    if kflago ~= 0
        nflago = anflago(kflago);  %  Assign option label if menu not canceled
    else  %  if canceled exit program
        nflago = 'v';
    end
    % Option to open file
    if nflago == 'o'
        %  Function to prompt user to get FeatVec file names 
        [flist, plist] = read_file_names();
        %  Open each file and extract start times
        for kk=1:length(flist)         
           [headerinfo, ldtimes, idcell, fidpos] = readheadermod([plist{kk},flist{kk}]);
           if isempty(headerinfo.fs)  %  If any file could not be opened: abort!
               errordlg('could not open file')
               kk = length(flist)+1;  %  Get out of loop
           else  %  If file could be opened, extract and save start time
               v(kk,:) = [headerinfo.year, headerinfo.month, ...
                   headerinfo.date, headerinfo.sh, headerinfo.sm, headerinfo.ss];
               endit=1;
           end
        end
        %  If files opened sucessfuly, concatenate! 
        if endit == 1;
            %  Sort out the files according to the time they were stamped
            [y,ii] = sort(datenum(v));
            %  Read files in in order
            for kk=1:length(flist)
                fname = [plist{ii(kk)},flist{ii(kk)}];
                [headerinfo, ldtimes, idcell, fidpos] = readheadermod(fname);
                % Read FeatVec file         
                fid = fopen(fname,'r','ieee-be');  %  Get file handle in read only mode
                sta = fseek(fid,fidpos,-1);  %  Skip header info
                [f1,cnt] = fread(fid, inf, 'double', 'b'); % read feature
                dtca = stpt +[0:floor(cnt/(4*headerinfo.chan))-1]*tinc;
                tst = headerinfo.sh*60^2+headerinfo.sm*60+headerinfo.ss;
                taxhr = (tst+dtca)/60^2;  % Time array for each sample
                if kk == 1  %  If first file, initialize arrays 
                    idcellcc = idcell;  %  Save initial channel labels
                    ldtimescc = ldtimes;  %  Save initial light-dark times
                    firstheaderinfo = headerinfo;  % store initial header time stamp for create file
                    newtaxhr = taxhr;  %  Initialize time axis
                    newout = f1; % Initialize outputvector
                    pnam = plist{ii(kk)};  % Store path of earliest file for saving output
                    fnam = flist{ii(kk)};  % Store name of earliest file for saving output
                    fnam = [fnam(1:end-8), 'cc.FeatVec']; %  Add a cc to file name to distinguish it
            
                    oldbeg = taxhr(1);  %  Save the beginging and ending time for computing the time
                    oldend = taxhr(end);   % gap between its end and the beging of the new file
                    
                else % If not first time through padd and concatenate 
                    timegap = y(kk)*24-y(kk-1)*24 - (oldend-oldbeg);  % Time gap in hours
                    if timegap <= 0
                        errordlg('Time gap between files is 0 or negative, cannot merge!')
                        endit = 0;
                    elseif timegap > 24
                        errordlg('Time gap between files is greater than 24 hrs, will not merge!')
                        endit = 0;
                    else
                        timeinterval  = taxhr(2)-taxhr(1);    %  Time interval between data points  
                        tfiller = [newtaxhr(end):timeinterval:taxhr(1)-timeinterval];  % time point vector for gap
                        filler = ones(round((timegap/timeinterval - 2))*4*headerinfo.chan,1)*NaN;   %  Create NaN matrix to fill gap in data matrix
                        newtaxhr = [newtaxhr, tfiller(2:end), taxhr];  %  Concantenate time vectors
                        newout = [newout; filler; f1];  % Concatenate data matrix
                        oldbeg = taxhr(1);   %  Save the beginging and ending time for computing the time
                        oldend = taxhr(end);   % gap between its end and the beging of the new file
                    end  %  Check on timestamp validity IF
                end  % First or later pass IF
            end  %  File concatenation loop
            if endit ==1  % if everything went ok, save it
                fpath= [pnam fnam]; 
                fid =fopen(fpath, 'w');
                writeheadermod(fid,firstheaderinfo,ldtimescc, idcellcc);
                fwrite(fid,newout','double','b');
                fclose(fid);
                disp(['File ', pnam, fnam, ' created and saved!']);
                nflago = 'v';
            end
        end  %  Concantenation IF file        
        
  end   %  End menu if 
    
end  %    Quit While loop
     



function [flist, plist] = read_file_names()
%  This function continue to prompt user for matfile names and saves them in
%  cell array FLIST.  The corresponding paths to each file is stored in
%  PATHLIST.
%
%    [flist, pathlist] = read_file_names()
%
%  Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) March 2012
%
%  Loop to prompt for file name
keeplooping = 1;
listcount = 0;
flist = cell(0);
plist = cell(0);
while keeplooping == 1
   % Get mat file name
   if listcount == 0  %  Use last path where file was found
       
      [fnam,pnam] = uigetfile('*.FeatVec','Input feature vector file for merging (hit cancel to start processing list)');
   else   %  Use current directory
      [fnam,pnam] = uigetfile([pnam '*.FeatVec'],'Input feature vector file for merging (hit cancel to start processing list)');
   end
   if isequal(fnam,0)|isequal(pnam,0)
         keeplooping = 0;
   else  %   If file found ...
          %  Check to see if already added
          hereflag = 0;
          for k=1:listcount
              if length(flist{k}) == length(fnam)
                  if sum(flist{k} == fnam) == length(fnam)
                      hereflag = 1;
                  end
              end
          end
          if hereflag == 1
              disp(['File already on list'])
          else
              listcount = listcount + 1;
              plist{listcount} = pnam;
              flist{listcount} = fnam;
             disp(['File ', pnam, fnam, ' found and added to merge list'])
          end
   end
end



