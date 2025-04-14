function writeheadermod(fid,headers,ldtimes, idcell)
%  This function accepts the file ID fid ,header info(which includes scale,
%  sampling frequency, total number of channels, Start second,Start minute,
%  Start hour, Start date, Start month, and Start year), ldtimes (which 
%  includes light to dark and dark to light times) and idcell (which inlcudes,
%  mice id) and writes into a new file.
%
%     writeheadermod(fid,headers,ldtimes, idcell)
%
%  The output is a binary file which has the input information in it.

%   Written by Kevin Donohue March 2012 (donohue@engr.uky.edu)

%  Write time and sampling frequency information
    cnt1 = fwrite(fid,headers.scale, 'int32','b');
    cnt2 = fwrite(fid,headers.fs, 'int32','b');
    cnt3 = fwrite(fid,headers.chan, 'int32','b');
    cnt4 = fwrite(fid,headers.ss, 'int32','b');
    cnt5 = fwrite(fid,headers.sm, 'int32','b');
    cnt6 = fwrite(fid,headers.sh, 'int32','b');
    cnt7 = fwrite(fid,headers.date, 'int32','b');
    cnt8 = fwrite(fid,headers.month, 'int32','b');
    cnt9 = fwrite(fid,headers.year, 'int32','b');
 %  Parse out the hour minute and second from the dark-light time strings
    parsevec = find(ldtimes{1}== ':' );
    dlh = str2num(ldtimes{1}(1:parsevec(1)-1));
    dlm = str2num(ldtimes{1}(parsevec(1)+1:parsevec(2)-1));
    dls = str2num(ldtimes{1}(parsevec(2)+1:end));
    ldh = str2num(ldtimes{2}(1:parsevec(1)-1));
    ldm = str2num(ldtimes{2}(parsevec(1)+1:parsevec(2)-1));
    lds = str2num(ldtimes{2}(parsevec(2)+1:end));
    %  If empty, set to default values
    if isempty(dlh)
       dlh = 7;
    end
    if isempty(dlm)
        dlm=0;
    end
    if isempty(dls)
        dls=0;
    end
    % Write dark-light times
    fwrite(fid,dlh,'int32','b');
    fwrite(fid,dlm,'int32','b');
    fwrite(fid,dls,'int32','b');
    %  If empty set to default values
    if isempty(ldh)
       ldh = 19;
    end
    if isempty(ldm)
        ldm=0;
    end
    if isempty(lds)
        lds=0;
    end
    %  Write light-dark times
    fwrite(fid,ldh,'int32','b');
    fwrite(fid,ldm,'int32','b');
    fwrite(fid,lds,'int32','b');
    %  write Channel names with 0 marke between names
    parseflag = 0;    
    d2 = fwrite(fid, parseflag, 'int8');
    d2 = fwrite(fid, parseflag, 'int8');
    d2 = fwrite(fid, parseflag, 'int8');
    d2 = fwrite(fid, parseflag, 'int8');
    for i = 1:headers.chan
           d1= fwrite(fid, idcell{i},'char');
           d2 = fwrite(fid, parseflag, 'int8');
           d2 = fwrite(fid, parseflag, 'int8');
           d2 = fwrite(fid, parseflag, 'int8');
           d2 = fwrite(fid, parseflag, 'int8');
    end
    