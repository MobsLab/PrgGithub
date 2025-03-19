function [d,headers, hd, ef, t] = omousefilelab(fname,ch, filpar)
%  This function opens the binary file created by the Labview data collection
%  program (see description of binary file below) with filename
%  in string FNAME.  CH is the channel to be extracted, starting with
%  0 as the first channel.  The optional argument FILPAR is a data structure
%  containing parameters for extracting specific data ranges and/or filtering.
%  The follow options are available:
%  filpar.lim => 2 element vector in seconds, denoting the begining and ending point
%  for the output segment where 0 is the begining of the file.  LIM = [0 inf]
%  is the default read, which is the whole segment.
%  filpar.a and flipar.b => are used to perform a zero phase filtering
%  operation, where filpar.a is a  vector with the denomenator coefficients
%  (set to 1 for FIR filter), and filpar.b is a vector with the numberator
%  coefficients
%  filpar.pos => the position of the message/status window 
%  filpar.showwin => flag set to 1 will display the read status window
%  (default), 0 will not show status window
%
%      [d, headers, hd, ef, t] = omousefilelab(fname, ch, filpar)
%
%  The output vector D is the samples from requested channel, HEADERS is a data
%  structure with fields containing information about the file, T is an optional
%  parameter for time axis (in seconds) associated with samples of D, EF is a flag
%  that indicates the end of file was reached if 1, and HD is the handle of
%  the message window that gives the status of the most recent read operation. 
%  The binary file format has signed 16 bit words in big endian format from N
%  interleaved channels.  The header consists of a series of 32 bit words
%  consisting of the following elements:  Max Voltage (dynamic range of quantizer/2),
%  sampling frequency, number of channels, start of data colletion: second, minute
%  hour, day, month, year, dark onset time hour, minute, second, and light onset time
%  hour, minute, second.  Then an array of strings (variable length is used to
%  label the data in each channel.  These are stored in the data structure info, as
%  headers.scale, headers.fs, headers.chan, headers.ss, headers.sm, headers.sh,
%  headers.date, headers.month, headers.year.  The light dark onset times are placed
%  in cell array headers.ldtime where the first element is 3 column vector
%  with the strings for the dark onset hour, minute, and second.  The
%  second element are the corresponding strings for the light onset time.
%  The labels are returned as a cell array with as many elements as
%  channels in headers.idcell
%
%  Dependencies: readheadermod()
%
%   Written by Kevin D. Donohue (kevin.donohue@sigsoln.com)  July 2011

%  Open file and read header if it exists.
[headers, ldtimes, idcell, fidpos] = readheadermod(fname);
ef = 0;  %  Initialize end of file flag to 0
noopen = 0;  %  Initalize file problem flag to 0 (alright)
if fidpos == -1  %  If can't open, set indicator flag
    noopen = 1;  %  set file problem flag
else %  If it can be opened ...
        %  Check to make sure numbers read in make sense
    if headers.fs > 512 ||  headers.month > 12 || headers.date > 31 || headers.sh > 24 || headers.fs < 40
        noopen = 1;  %  Set file problem flag
        errordlg('Binary file not in proper format! Are you sure you picked the right file?');
    % If requested channel is out of range
    elseif ch >= headers.chan
        noopen = 1;      
        errordlg(['Requested channel index ', int2str(ch) ...
            ' is larger than number of channels ', int2str(headers.chan)]);
    else
        %  Read rest of file
        if nargin == 3  %  if optional parameter given, set and any pertain to read limits
            if isfield(filpar, 'lim')
                lim = filpar.lim;
            else
                lim = [0 inf];
            end
            if isfield(filpar,'showwin')
                showwin = filpar.showwin;
            else
                showwin = 1;  %  Default
            end
        else  %  if optional parameter not given read whole file
            lim = [0 inf];
            showwin = 1;
        end
        %  Check to make sure limits make sense
        if lim(1) < 0 || lim(2) < 0
            noopen = 1;
            errordlg('Input Argument! Seconds for segment limits must be nonnegative')
        elseif lim(1) > lim(2)
            noopen = 1;        
            errordlg('Input Argument! Starting second must be smaller then ending second')
        else
            noopen = 0;  %  Go and open file
            fid=fopen(fname);
            %  Display Status Window
            if showwin == 1
                hd = helpdlg( ...
                {['Now Processing from hour ' num2str(round(lim(1)*100/3600)/100) ' to ' num2str(lim(2)/3600)] ...
                ['Sampling rate: ' num2str(headers.fs)] ...
                ['Number of channels: ' num2str(headers.chan)] ...
                ['Start Time(hour:min:sec): ' num2str(headers.sh) ':' num2str(headers.sm) ':' num2str(headers.ss)], ...
                ['Date(month/date/year): ' num2str(headers.month) '/' num2str(headers.date) '/' num2str(headers.year)]}, ...
                ['Processing Channel ' num2str(ch+1) ]) ;
                if nargin == 3
                    if isfield(filpar,'pos')
                        set(hd,'Position',filpar.pos);
                    end
                end
            else
                hd = [];
            end
        end
       
        %  If no bad flags were set go ahead and open file
        if noopen == 0
            %  Set pointer can be position to beginging of file
            fseek(fid,2*ch+fidpos,-1);               
            %if nargin > 2  %  if limits given
                 %  Move to desired position in data record to start with
                 %  desired channel 
                gs = round(lim(1)*headers.fs);  %  Lower limit in data record (sample number)      
                ge = round(lim(2)*headers.fs);  %  Upper limit in data record (sample number)
                fseek(fid,(gs)*2*headers.chan,0);   %  Move to the begining position with channel offset
                % Read data in Big endian format for a single channel, skipping
                 % interleaving channels
                [d, cnt] = fread(fid, (ge-gs+1), 'int16',2*headers.chan-2,'b'); 
                d = d'; %Each column is one channel
                %  If end of file is encountered before or at end of requested limit,
                %  set end of file flag
                if cnt <= (ge-gs);
                     ef=1;  
                end
                % Finished reading, close file
                fclose(fid);
                d = double(d)*headers.scale/2^15; % Convert data back to single floating pt. on original scale
                %  If filter parameters are given, FIR filter the segment, using
                %  forward and backward filtering for a 0-phase offset
                if isfield(filpar,'a') && isfield(filpar,'b')
                   d = filtfilt(filpar.b,filpar.a,d);
                end
                if nargout == 5 % create time axis in seconds relative to begining of file if requested
                   r = length(d);
                   t = lim(1)+((0:r-1)/headers.fs)';
                end
        else  %  if file had problems  Set outputs to empty arrays
                    d = [];
                    hd = -1;
                    ef=1;
                    t = [];
        end
    end
end
pause(.1);  %  Pause to respond to clear graphics click
