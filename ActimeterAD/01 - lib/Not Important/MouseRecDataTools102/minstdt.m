function mint = minstdt(arry)
%  This function finds a minimum standard deviation  threshold to separate 2
%  clusters of statistics.  Input ARRY is an array of decision statistics.
%
%    mint = minstdt(arry)
%
%  and output MINT is the threshold.  Weighted minimum standard deviation
%  minimized is given by:
%
%    wsd =  (n1*sigma1+n2*sigma2)/(n1+n2)
%  where n1 and n2 are the number of decision statitics below and above
%  proposed threshold and sigma1 and sigma2 are the standard deviations
%  of decision staitistics below and above proposed threshold.
%
%  If distribution is strongly unimodal theshold is set at 0 if it
%  is greater than the 5/95th percentile or at the 5/95th percentile
%  (but within threshold limits of -1.5 to 1.5
%
%   Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) March 2010

%r = length(arry);
tlimits = [-1.4 1.4];  %  selected treshold is limited to this range
%Trim outliers
hvl=ssprctile(arry,5);%tenth percentile value of the sleep-wake statistics
 hvu=ssprctile(arry,95);%ninety percentile value of the sleep-wake statistics
 hvd=hvu(1)-hvl(1); %  distance between 10th and 90th percentile
%  find values in percentile range
 gg = find((arry > hvl(1) & arry < hvu(1) ));
 arry = arry(gg);  %  trim;
 inc = (tlimits(2)-tlimits(1))/100;  % hds Divide histgram range into 100 bins
thrshis = 6*[-24:24]/24; %  Set threshold to sweep for histogram
thrs = [tlimits(1):inc:tlimits(2)];
%  Make sure data exists in valid threshold range, if not set to 0 
 
 if length(thrs) > 2 && ~isempty(thrs)  
        stdt = zeros(1,length(thrs));
        for k=1:length(thrs)
            m1 = arry(arry <= thrs(k));
            m2 = arry(arry> thrs(k));
            n1 = length(m1);
            n2 = length(m2);
            %  Weighted STD to minimize
            stdt(k) =  ((n1*std(m1)+n2*std(m2))/(n1+n2+eps));
        end
        %  Select minimum over all trials
        [mv, mintind] = min(stdt);
        if ~isempty(mintind)
            % Get threshold corresponding to minimum
            mint = thrs(mintind(end));
        else % no minimum found set threshold to 0
            mint = 0;
        end

        %  Check for unimodal distribution
        [xx,nn] = hist(arry,thrshis);
        [mv,mp] = max(xx);
        maxpos = nn(mp(1));
        %  If threshold near the modal point of histogram
        %  set to extreme end of distribution to indicate one behavior
        if mint < maxpos+.25 && mint > maxpos-.25
          %  If modal point negative
            if maxpos < 0;
               %mint = max([0, hvu]);
               %mint = min([mint, tlimits(2)]);
               mint = 2;
            else % If modal point positive
               %mint = min([0, hvl]);
               %mint = max([mint, tlimits(1)]);
               mint = -2;
           end
        end
else
    mint=0; % if threshold is out of range
end

