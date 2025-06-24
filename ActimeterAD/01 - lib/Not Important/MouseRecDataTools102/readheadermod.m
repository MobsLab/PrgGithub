function [headers, ldtimes, idcell, fidpos] = readheadermod(fpath)
%  This function reads in only the header of the binary file create by
%  LabVIEW software MouseRec with path and filename in string FPATH.
%
%      [headers, ldtimes, idcell, fidpos] = readheadermod(fpath)
%
%  The output is a data structure HEADERS which consists of a series of 32
%  bit words: the Max Voltage (dynamic range of quantizer/2), headers.scale;
%  sampling frequency, headers.fs; number of channels headers.chan;, start of data colletion
%  consisting of the start second, headers.ss; minute, headers.sm; hour,
%  headers.sh; day, headers.date; month, year, headers.year.  Also returned
%  are the LDTIMES, which are the light-to-dark and dark-to-light times,
%  and idcell, the cell array of mouse IDs.  FIDPOS is the final file
%  position when the header is finished reading.
%
%   Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) July 2011

fid = fopen(fpath,'r');
%  If not opened sucessfully
if fid == -1  %  Set to empty output arrays
    headers.scale = []; % Amplitude scale
    headers.fs = []; %  Sampling Rate
    headers.chan = [];   %  Total number of channels
    headers.ss = [];   %  Start second
    headers.sm = [];   %  Start minute
    headers.sh = [];     %  Start hour
    headers.date = [];   %  Start date
    headers.month = []; %  Start month
    headers.year = [];   %  Start year
    ldtimes = cell(0,0); % cell array of light/dark times
    idcell = cell(0,0); %cell array of mouse IDs
    fidpos = -1;
    errordlg(['Cannot open file ' fpath]);    
else  %  If file opened sucessfully ...
    scale = (fread(fid,1, 'int32','b'));
    samprate = (fread(fid,1, 'int32','b'));
    chan = (fread(fid,1, 'int32','b'));
    second = (fread(fid,1, 'int32','b'));
    minute = (fread(fid,1, 'int32','b'));
    hour = (fread(fid,1, 'int32','b'));
    date = (fread(fid,1, 'int32','b'));
    month = (fread(fid,1, 'int32','b'));
    year = (fread(fid,1, 'int32','b'));
    dlh = (fread(fid,1, 'int32','b'));
    dlm = (fread(fid,1, 'int32','b'));
    dls = (fread(fid,1, 'int32','b'));
    ldh = (fread(fid,1, 'int32','b'));
    ldm = (fread(fid,1, 'int32','b'));
    lds = (fread(fid,1, 'int32','b'));

    %  Check to make sure numbers read in make sense
    if samprate > 512 || scale > 30 || month > 12 || date > 31 || hour > 24 || samprate < 40 ...
            || dlh > 23 || dlm > 59 || dls > 59 || ldh > 23 || ldm > 59 || lds > 59;
        headers.scale = []; % Amplitude scale
        headers.fs = []; %  Sampling Rate
        headers.chan = [];   %  Total number of channels
        headers.ss = [];   %  Start second
        headers.sm = [];   %  Start minute
        headers.sh = [];     %  Start hour
        headers.date = [];   %  Start date
        headers.month = []; %  Start month
        headers.year = [];   %  Start year
        ldtimes = cell(0,0); %cell array of light/dark times
        idcell = cell(0,0); %cell array of mouse IDs
        errordlg('Binary file not in proper format! Are you sure you picked the right file?');
        fidpos = -1;
    % If header values make sense
    else
        %This section reads the ID strings and stores them in dumcell

        dumcell = cell(chan,1);
        fseek(fid,4,0);
        for i = 1:chan
            value = fread(fid, 1, 'char=>int8');
            string = '';
            while value ~= 0
                string = [string char(value)];
                value = fread(fid, 1, 'char=>int8');
            end
            dumcell{i,1} = string;
           % if i ~= chan
                fseek(fid,3,0);
           % end
        end
        headers.scale = scale; % Amplitude scale
        headers.fs = samprate; %  Sampling Rate
        headers.chan = chan;   %  Total number of channels
        headers.ss = second;   %  Start second
        headers.sm = minute;   %  Start minute
        headers.sh = hour;     %  Start hour
        headers.date = date;   %  Start date
        headers.month = month; %  Start month
        headers.year = year;   %  Start year
        
        %Create LDTIMES cell array
        ldtimes = cell(1,2);
        ldtimes{1} = [num2str(dlh,'%.2d') ':' num2str(dlm,'%.2d') ':' num2str(dls,'%.2d')];
        ldtimes{2} = [num2str(ldh,'%.2d') ':' num2str(ldm,'%.2d') ':' num2str(lds,'%.2d')];
        
        idcell = dumcell;
    end
    fidpos = ftell(fid);  % Get current position of file pointer.
    fclose(fid);
end