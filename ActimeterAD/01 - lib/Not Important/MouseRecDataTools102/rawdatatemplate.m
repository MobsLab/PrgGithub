function rawdatatemplate(fnam, pnam)
% This function opens either the file entered by the input arguments
% or prompts the user with a navigation window to select a raw signal file
% saved using the MouseRec program.  
%
%             sleepwake(fnam, pnam)
%
% where FNAM is string of the filename be open and PNAM is the string
% of the path to its directory.  If no input arguments are given,
% a navigation window will launch.  If one argment is given, it will
% looks for the file in the current directory.
%
%  The program extracts the small blocks (~4 hours single channel) of the
%  input signal and computes the feature vector used in the sleep-wake
%  classification process.  It then saves the feature vector in a file with
%  the *.FeatVec extension. This can be opened by the sleepstats() program
%  for further analysis.
%  
%  The saved file consists of a header that includes:
%  A series of 32 bit words: the Max Voltage (dynamic range of quantizer/2),
%  sampling frequency, number of channels, start date/time of data collection
%  consisting of the start second, minute, hour, day, month, year; 
%  the light and dark onset times, and a string consisting mouse ID labels.
%
%  The data field consists 4 signal features consectuively stored as 16 bit
%  words off quantizer and interlaced for all channels
%
%     Dependencies: mousefeat(), omousefilelab(), rwheadermod()
%
%  Written by Kevin D. Donohue July 2011 (kevin.donohue@sigsoln.com)
%

% Set processing parameters 
% Fisher weights (developed December 2010) Not used in this program
fisherw = [0.0444    3.6295   -0.7047   -0.6516]';
thrbias = 1.2276; % Bias to put sleep-wake decision stats close to 0

% Frequency range in Hz for processing signal
lowlim = .5;
highlim = 10;

tincs = 2; % time increment in seconds to move analysis window
wins = 8; % Analysis window size in seconds
% Kaiser Window Beta value for tapering (emphasize middle of analysis
% window)
%tpin = 3; 
 %  Limit for number of seconds from each channel to be read in at a time
rlimit = 4*60*60;  %  4 hours 
%  If no arguments given, prompt user for them 
if nargin == 0
    [fnam, pnam] = uigetfile('*; *.bin', 'Open Signal file');
elseif nargin == 1
    pnam = [];
end

pp = find(fnam == '.');  %  Extract base name from file
if ~isempty(pp)  %  If extension present,
    fnamo = [pnam fnam(1:pp(end)-1)];  %  Only extract base name
else             %  otherwise base name is the same a full file name
    fnamo = [pnam fnam];  %
end
strold = strcat(pnam, fnam);
strout = [fnamo '.FeatVec'];
 %  Extract header information and write it to new file
[headerinfo, ldtimes, idcell, fidpos] = rwheadermod(strold, strout);  

%  If file can be opened and numbers are in range, proceed, If not
%  terminate program
if ~isempty(headerinfo.fs)
    c = headerinfo.chan;    %  Number of channels
    fs = headerinfo.fs;     %  Sampling Frequency

    %  Compute window length in samples
    winlen = round(wins*fs);
  %  Compute FIR filter parameters
    lfcutoff = lowlim;  %  Filter data, low frequency cutoff in Hz
    hfcutoff = highlim;  %  Filter data, high frequency cutoff in Hz
    filord = round(fs*2/lfcutoff)-1;
    filpar.b = fir1(filord,2*[lfcutoff hfcutoff]/fs);  %  Compute Filter coefficients
    filpar.a = 1;

    %  Loop to process each channel:
    for ct=1:c

     % Read in the Data channels
        ef = 0;  % Initalize end of file flag to zero
        lim = [0 rlimit];  % Set time limits in seconds for extracting raw data from file
        filpar.lim = lim;
        ampvec = [];
        str = strcat(pnam,fnam);
        [datach,info, hd, ef] = omousefilelab(str, ct-1, filpar);
        dtlen = length(datach);  %  Determine length of segement read
        if  dtlen > winlen %  If it was greater than one window size, process file
               %  Compute function from which to extract features
               [sp, ac, env, dtca, endoffset]=mousefeat(datach,fs,wins,tincs);
               sppkrat = sp.sm-sp.smt;  %  Log ratio of highest sleep peak to highest global peak
               corco = ac.sm;          %  Correlation coefficient value of sleep peak
               ecv = env.var;       %  Envelope coefficient of variance
               mamp = env.meanamplitude;
                 %  Build feature vector for current time segment
               fv = [sppkrat', corco', ecv', mamp'];
               %  If first time through, build time axis
               if ct==1
                  % Initial hour offset
                   tst = headerinfo.sh*60^2+headerinfo.sm*60+headerinfo.ss;
                   taxhr = (tst+dtca)/60^2;  % Time array for each sample
               end

        else
            error(['Data segment too small to process? Length = ' num2str(dtlen)])
        end
         delete(hd);  % close dialogbox
%     Step through rest of segments reading file to the end
        kseg = 0;  % Initalize segment index
        while ef == 0  %  While end of file not reached, get another segment
            kseg = kseg+1;  %  Increment segment index
            %  Offset to segment limits (back up first point to account for
            %  data and the end of last segment not used
            lim = [rlimit*kseg-wins+tincs+endoffset/fs rlimit*(kseg+1)];
            filpar.lim = lim;
            %  Get raw data
            str = strcat(pnam, fnam);
            [datach,info, hd, ef] = omousefilelab(str, ct-1, filpar);
            %  Compute function from which to extract features
            [sp, ac, env, dtca, endoffset]=mousefeat(datach,fs,wins,tincs);
            sppkrat = sp.sm-sp.smt;  %  Log ratio of highest sleep peak to highest global peak
            corco = ac.sm;          %  Correlation coefficient value of sleep peak
            ecv = env.var;     %  Envelope coefficient of variance
            mamp = env.meanamplitude;
           %  Build feature vector for current time segment
           fv = [fv; sppkrat', corco', ecv', mamp'];

%            da = fv*fisherw; % Features weighted by fisher weights
      %     chfea = [chfea; da];  %  Concatenate to featrue vector at previous time instants 
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           if ct==1
               taxhr = [taxhr (taxhr(end) + (dtca+tincs-wins/2)/60^2)];
           end
           delete(hd);  % close dialogbox
        end  %  End while loop
      %  ampstat = mean(fv(:,4));
      %  ampstd = std(fv(:,4));
      %  fv(:,4) = log(fv(:,4)+ 1/ampstd) - log(ampstat+ 1/ampstd);
      %  sw(:,ct) = fv*fisherw - thrbias;  %  Update current channel array and save what you have so far
        %         str = strcat(pnam, fnamo,'.mat');
%              save(str, 'headerinfo', 'taxhr', 'sw', 'idcell', 'ldtimes', 'thresh')
%            
     fid = fopen(strout,'r+','ieee-be');  %  Get file handle in read only mode
     sta = fseek(fid,fidpos,-1) ; %  Skip header info
     sta = fseek(fid,8*(4*(ct-1)+0),0) ; % offset to correct channel starting point
     cnt = fwrite(fid, fv(1,1) ,'double'); %write features
     cnt = fwrite(fid, fv(2:end,1) ,'double',8*(4*headerinfo.chan-1)); %write features
     sta = fseek(fid,fidpos,-1) ; %  Skip header info
     sta = fseek(fid,8*(4*(ct-1)+1),0) ; % offset to correct channel starting point
     cnt = fwrite(fid, fv(1,2) ,'double'); %write features
     cnt = fwrite(fid, fv(2:end,2) ,'double',8*(4*headerinfo.chan-1)); %write features
     sta = fseek(fid,fidpos,-1) ; %  Skip header info
     sta = fseek(fid,8*(4*(ct-1)+2),0) ; % offset to correct channel starting point
     cnt = fwrite(fid, fv(1,3) ,'double'); %write features
     cnt = fwrite(fid, fv(2:end,3) ,'double',8*(4*headerinfo.chan-1)); %write features
     sta = fseek(fid,fidpos,-1) ; %  Skip header info
     sta = fseek(fid,8*(4*(ct-1)+3),0) ; % offset to correct channel starting point
     cnt = fwrite(fid, fv(1,4) ,'double'); %write features
     cnt = fwrite(fid, fv(2:end,4) ,'double',8*(4*headerinfo.chan-1)); %write features
     
     
     %       cnt=fwrite(fid, chfea(2),'double',8*(headerinfo.chan-1), 'l')
     fclose(fid);  % close the file
    


    end
  %        str = strcat(pnam, fnamo,'.mat');
 %  save(str, 'headerinfo', 'taxhr', 'sw', 'idcell', 'ldtimes', 'thresh');
end
