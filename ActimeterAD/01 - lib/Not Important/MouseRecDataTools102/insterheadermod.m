function [headers, ldtimes, idcell, fidpos] = insterheadermod(fpath)
%  This function reads in only the header of the binary file create by the Labview
%  data collection program (Aaron Daniels March 2007) see
%  description of binary file below) with path and filename in string FPATH.
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
%   Written by Aaron Daniels(aed.uky.edu)  March 2007

gg = find(fpath == '.');
fn = [fpath(1:gg(1)) 'Feat'];
fnnew = [fpath(1:gg(1)-1) 'a.FeatVec'];
fid = fopen(fn,'r','ieee-be');
fid2=fopen(fpath ,'r','ieee-be');
fid1 = fopen(fnnew ,'w','ieee-be');

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
    errordlg(['Cannot open file ' fname])
else  %  If file opened sucessfully ...
    scale = (fread(fid,1, 'int32'));
    fwrite(fid1,scale,'int32');
    samprate = (fread(fid,1, 'int32'));
    fwrite(fid1,samprate,'int32');
    chan = (fread(fid,1, 'int32'));
    fwrite(fid1,chan,'int32');
    second = (fread(fid,1, 'int32'));
    fwrite(fid1,second,'int32');
    minute = (fread(fid,1, 'int32'));
    fwrite(fid1,minute,'int32');
    hour = (fread(fid,1, 'int32'));
    fwrite(fid1,hour,'int32');
    date = (fread(fid,1, 'int32'));
    fwrite(fid1,date,'int32');
    month = (fread(fid,1, 'int32'));
    fwrite(fid1,month,'int32');
    year = (fread(fid,1, 'int32'));
    fwrite(fid1,year,'int32');
    dlh = (fread(fid,1, 'int32'));
    fwrite(fid1,dlh,'int32');
    dlm = (fread(fid,1, 'int32'));
    fwrite(fid1,dlm,'int32');
    dls = (fread(fid,1, 'int32'));
    fwrite(fid1,dls,'int32');
    ldh = (fread(fid,1, 'int32'));
    fwrite(fid1,ldh,'int32');
    ldm = (fread(fid,1, 'int32'));
    fwrite(fid1,ldm,'int32');
    lds = (fread(fid,1, 'int32'));
    fwrite(fid1,lds,'int32');
   
    
    %  Check to make sure numbers read in make sense
    if samprate > 512 | scale > 30 | month > 12 | date > 31 | hour > 24 | samprate < 40 ...
            | dlh > 23 | dlm > 59 | dls > 59 | ldh > 23 | ldm > 59 | lds > 59
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
        d=fwrite(fid1,0,'uint8',3);
        for i = 1:chan
            value = fread(fid, 1, 'char=>int8');
            fwrite(fid1,value,'char');
            string = '';
            while value ~= 0
                string = [string char(value)];
                value = fread(fid, 1, 'char=>int8');
                fwrite(fid1,value,'char');
            end
            dumcell{i,1} = string;
            % if i ~= chan
           fseek(fid,3,0);
          fwrite(fid1,0,'uint8',2); 
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
    fidpos = ftell(fid1);  % Get current position of file pointer.
    % [dd,cc] = fread(fid, 10, 'int16' ,8*15,'b')
    fclose(fid);
    
end

data = fread(fid2,'int16');
fwrite(fid1,data,'int16');
fclose(fid1);
fclose(fid2);