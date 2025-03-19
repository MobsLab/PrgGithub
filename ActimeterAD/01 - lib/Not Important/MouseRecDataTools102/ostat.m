function [par] = ostat(fname)
% This function open the *.FeatVec file created by MouseRec that
% contains the feature vectors.  The header is read and informaion
% stored in field of data structure "headerinfo." The feature vectors
% for each channel are linearly weighted to obtain sleep-wake statistics
% that are stored columnwise in matrix "sw"
%
%    [par] = ostat(fname)
%  Input:
%    fname - string with path and file name of *.FeatVec
%  Output:
%     par - data structure with fields:
%           headerinfo - structure with header information
%           sw - columnwise matrix with sleepwake decision stats for each
%           channel
%           swtrim - same as sw with stats cliped in [-6 6] range
%           threshv - array with thresholds for making sleep-wake decisions
%           on the sw statistics, where thresholds are determine to minimize
%           the variance of statistics in each class
%
%    dependencies: readheadermod(), minstdt()
%
%   Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) July 2011

%  Weight for each feature
%fisherw = [0.0444    3.6295   -0.7047   -0.6516]';
fisherw = [0.0444   3.6295   -0.7047   -0.6516]';
%  Bias to put threshold near zero (done adaptively)
thrbias = 1.2276*(1.3);

%Read in Sleep-Wake Statistics file - Get header information
[par.headerinfo, par.ldtimes, par.idcell, fidpos] = readheadermod(fname);
%  If file can be opened, get and extract channel data
if fidpos ~= -1 
    %  loop to read in statistic value for each channel and compute
    %  sleep-wake statistics 
    hh = waitbar(0,['Reading in file']);
    ct = par.headerinfo.chan;
    for i=1:ct
        tdum=[];
         fid = fopen(fname,'r','ieee-be');  %  Get file handle in read only mode
         sta = fseek(fid,fidpos,-1);  %  Skip header info
         % offset to correct channel starting point for feature 1
         sta = fseek(fid,8*(4*(i-1) +0),0);  
         [f1,cnt(i)] = fread(fid, inf, 'double', 8*(4*par.headerinfo.chan-1),'b'); % read feature
         %  Reset file pointer to begining
         sta = fseek(fid,fidpos,-1);  %  Skip header info
         % offset to correct channel starting point for feature 2
         sta = fseek(fid,8*(4*(i-1) +1),0);         
         [f2,cnt(i)] = fread(fid, inf, 'double', 8*(4*par.headerinfo.chan-1),'b'); % read feature
         %  Reset file pointer to begining
         sta = fseek(fid,fidpos,-1);  %  Skip header info
         % offset to correct channel starting point for feature 3
         sta = fseek(fid,8*(4*(i-1) +2),0);
         [f3,cnt(i)] = fread(fid, inf, 'double', 8*(4*par.headerinfo.chan-1),'b'); % read feature
         %  Reset file pointer to begining
         sta = fseek(fid,fidpos,-1);
         % offset to correct channel starting point for feature 4
         sta = fseek(fid,8*(4*(i-1) +3),0);
         [f4t,cnt(i)] = fread(fid, inf, 'double', 8*(4*par.headerinfo.chan-1),'b'); % read feature
         fclose(fid);
         %  Extract amplitudes
         ampstat = nanmean(f4t);
         ampstd = nanstd(f4t);
         %  Normalize amplitude by over all mean and expand/compress with log scale
         f4 = log(f4t+.002) - log(ampstat+.002);
         %  Apply Fisher weights to get sleep wake statistics
         f1len = length(f4);
         par.sw(1:f1len,i) = [f1(1:f1len) f2(1:f1len) f3(1:f1len) f4(1:f1len)]*fisherw-thrbias; 
                           
         %Clipping up the sleep-wake statistics in amplitude to neglect the
         %undesired variations and make the threshold computation more
         %robust.
         
         %The range is given as a vector where the lower point first
         %and then the higher.
         crange=[-6 6]; %the two point vector to clip the amplitude
         dum=par.sw(:,i);  % dummy array for clipped data
         lindex = find(dum < crange(1)); %Find the index values of all sample points above low clip
         if ~isempty(lindex)  %  if points exist in this range ...
            dum(lindex) = crange(1);         %  Assign all points below, to the clip value
         end
         hindex = find(dum > crange(2));  % Find the index values of all sample points above high clip 
         if ~isempty(hindex)   %  if points exist in this range ...
             dum(hindex) = crange(2);         %  Assign all points above, to the clip value
         end
         par.swtrim(:,i)=dum; % storing the clipped sleep-wake statistics to the structure 'par'
        

           %  This section plots all histograms of stats
%             figure
%             hist(par.swtrim(:,i),100)
%             hold on
%             plot(par.threshv(i)*[1 1], ylim)
%             xlabel('Sleep-Wake Decision Statsitics')
%             title(['Channel ' int2str(i)])
%             hold off
            
            
%            waitbar(i/par.headerinfo.chan, hh);
%         end
     waitbar(i/par.headerinfo.chan, hh); 
    end
close(hh)
else
    par.sw = [];
end
