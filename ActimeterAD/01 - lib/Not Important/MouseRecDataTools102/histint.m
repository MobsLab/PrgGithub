function [freq, bins, stats] = histint(seg,sampinc,thresh, bithresh, ignore_interupt)
%  This function creates a histogram of intervals based on
%  the number of consecutive points in SEG that exceed threshold THRESH.
%  Useful for characterizing sleep bout lenghts:
%
%      [freq, bins, stats] = 
%                  histint(seg,sampinc,tresh,bithresh,ignore_interup)
% 
%  Inputs:  SEG ->    Vector of detection statistics
%           SAMPINC ->  Sampling increment corresponding to SEG
%           THRESH -> Threshold value to appled to SEG for sleep-wake
%           classification
%           BITHRESH ->  Interval threshold value to compute a
%           quantile statistic in seconds.  It determines probability (frequency
%           of occurence) for intervals being greater than it.  Results in output
%           statistic stats.q = (1-cdf(bithresh)), where cdf is the cumulative
%           distribution function of the sleep bout lengths.
%           
%           IGNORE_INTERUPT ->  Limit for number of
%           seconds SEG is below sleep threshold so it will not
%           interrupt the consecutive count of values exceeding threshold.
%           Good for ignorning twitches during sleep. Default 4 seconds
%  Outputs: FREQ:  Frequency of sleep bout interval occurences
%           BINS:  Edges of intervals used for binning the histogram
%           STATS: Data structure with statistics on the interval histogram 
%                  including the following fields
%                  mean => Mean interval
%                  mode => Mode of the interval histogram
%                  std => Standard Deviation of the intervals
%                  median => Median of the intervals
%                  q => Portion of intervals less than BITHRESH
%                  pct90 =>  90th percentile
%                  pct10 =>  10th percentile
%
%   written by Kevin D. Donohue (kevin.donohue@sigsoln.com) August 8, 2006,
%   Updated June 16, 2008
%


%  Binarize input segement with threshold to sleep =1 and wake =0 intervals
dets = zeros(size(seg));  %  Initalize sleep-wake classification array
det_ind = find(seg > thresh);
if ~isempty(det_ind)
    dets(det_ind) = 1;  %  mark deteted sleep interval
end

%  If parameter given to ignore short bouts of  wake, convert it to samples, if not set to 1 sample 
if nargin == 4
    ignore_interupt_n = ceil(ignore_interupt/sampinc); % Convert seconds interval to number of samples
else
    ignore_interupt_n = ceil(4/sampinc);  %  Default value of 4 seconds
end

%  Count up the interval lengths
veccnt = 0;  %  Initalize counter through all detection statistics
k = 0;       %  Initilize counter to create vector of interval lengths
limt = length(seg);  %  find segment length to stop count
intv = 0;            % initalize interval value vector
%   Loop through all samples of detection vector
while veccnt < limt
    veccnt = veccnt + 1;  %  Get next detection result
    consec = 0;           %  reset concecutive sample counter
    gof = dets(veccnt);   %  Set continue flag with current detection result
    %  While sleep is detected in contiguous samples, count them up
    while gof == 1 && veccnt < limt
        consec = consec + 1;  %  Increment consecutive counter
        veccnt = veccnt + 1;  %  get next detection statistic
        %  Interrupt counter
        % if wake, look at next "ignore_interupt" samples to see if it is consectutive 
        gof = dets(veccnt);
        if gof == 0
            %  Look at whole interval for contiguous wake
            testf = sum(dets(veccnt+1:min([veccnt+ignore_interupt_n,limt])));
            if testf == 0  %  if all wake ...
              gof = 0;  %  If all wake, stop continue flag
            else  %  if contains a sleep, then continue counting sleep
              gof = 1;  % reset go flag and flip intermitten wakes to sleep
       %       dets(veccnt:min([veccnt+ignore_interupt_n,limt])) = 1;
            end
        end              
    end
    %  If sleep intervals found, store them in interval value vector
    if consec ~= 0
        k=k+1;
        intv(k) = consec;
    end
end

%  Prepare for histogram and stats computation
%  Find range of values
minv = min(intv);  %  Smallest sleep bout interval
maxv = max(intv);   % Largest sleep bout interval
%  Create a bin axis on the finest scale (one sample increment)
bins = [0,8,16,32,64,128,256, inf]; %logspace(0,3,30); % bins = 1:10:maxv(1); %
intv = intv*sampinc;  %  Scale intervals to seconds
freq = histc(intv,bins);  %  Compute frequency of occurence in each bin

%  if counts are present, trim histogram vectors and compute stats
if max(freq) > 0
    freq = freq(1:end-1);  %  Plotting frequency of occurrence
    bins = bins(1:end-1);  %  Plotting axes points (last point inf)
    %  Compute cdf(bithresh)
    stats.q = 1- length(intv(intv<bithresh))/length(intv);
    stats.mean = mean(intv);    %  Mean interval length
    stats.median = median(intv);  %  Median of interval length
    stats.std = std(intv);        %  Standard deviation of interval lengths 
    [mxp, indmxp] = max(freq);    %  most probable interval bin
    stats.mode = bins(indmxp(1));    %  Mode of histogram  
    stats.pct90 = prctile(intv,90);  % 90th percentile
    stats.pct10 = prctile(intv,10);  % 10th percentile
else  %  if no intervals found return 0 and empty vectors
    stats.mean = 0;
    stats.median = 0;
    stats.std = 0;
    stats.mode = 0;
    stats.q = 0;
    stats.freq = zeros(size(bins));
    stats.pct90 = 0;
    stats.pct10 = 0;
end   
