function [pkact, actnint] = wakeactivity(sw,par, newthresh,nightftimes, daybtimes, plotflag)
%  This function plots the percent wake activity for detection statistics
%  in vector SW over interval PAR.WINTV.  SW must be long enough to include 
%  2 light onset.  The program works on the first dark onset between 2
%  light on sets.  It also finds significant peak after a sharp upward gradient
%  within interval PAR.ACTRANGE [hour before, hour after] dark onset and
%  computes the time from dark onset.  These values are output in vector
%  PEAK_ACT (Peak Activity) and ACT_ONSET (Activity Onset):
%
%     [peak_act, act_onset] =
%                   wakeactivity(sw,par,nightftimes, daybtimes, plotflag)
%
%  Inputs:
%  SW - vector with detection statistics
%  PAR - Data stucture with
%        par.taxhr => vector time axis for SW in hours,
%        par.wintv also => sliding window interval in hours,
%        par.actrange (optional) => range in hours relative to dark onset for
%        finding peak activity and activity onset [hours before, hours after]
%        note hours before are subtracted from dark onset and hour after
%        are added to dark onset. Default [3, 6]
%        
%  NIGTHFTIMES - Vector with nightfall times relative time axis PAR.TAXHR
%  DAYBTIMES - Vector with daybreak times relative time axis PAR.TAXHR
%  PLOTFLAG - (optional) if set to 1 (default) the wake activity plot will appear
%             any other value will inhibit the plot
%  Outputs:
%  PEAK_ACT - vector with activity peak after Onset
%  ACT_ONSET - vector with activitity onset times 
%
%   Dependencies: peakfind()
%
%  Written by Kevin D. Donohue (kevin.donohue@sigsoln.com) August 13, 2010
%



tol = .05;  %  percent change of local max to be ignored
%  set default plotting condition
if nargin == 4
    plotflag = 1;
end

%  Set nightfall interval for peak activity and activity onset times
if isfield(par,'actrange')
  hb = par.actrange(1);
  ha = par.actrange(2);
else  % Default values
  hb = 3;
  ha = 6;
end

%  Number of detection statistic samples corresponding to averaging interval
wlen = round(par.wintv/(par.taxhr(2)-par.taxhr(1)));
smpphr = round(1/(par.taxhr(2)-par.taxhr(1)));  % Samples per hour
%  Sample every minute in averaging over interval 
% intskip = round((1/60)/(par.taxhr(2)-par.taxhr(1)));  %  one minute skipping 
intskip=round(par.winc*smpphr);

% Window to average out short transient spikes before computing gradient
% to get strong trend in upward gradient
hrint = round(3*smpphr/intskip)+1;    % 3 Hour interval 

%  Create detection result vector
[nr, nc] = size(sw);
swd = zeros(nr,1);
swdind = find(sw <= newthresh);
swd(swdind) = 1;  %  Assign 1 to every sample detected as sleep
subcnt = 0;  % Start counter for sampled detection percentages

hlen = fix(wlen/2);  %  Get half window for symetric averaging about a point
acthlen = fix(wlen/2);  %  Get half window length for activity statistics
%  Step through detection statistic vector and take wake percentages
 for kwa = 1:intskip:nr-intskip-1
     subcnt = subcnt + 1;
     pwts(subcnt) = 100*mean(swd(max([kwa-hlen,1]):min([kwa+hlen,nr])));
     ggsma(subcnt) = 100*mean(swd(max([kwa-acthlen,1]):min([kwa+acthlen,nr])));
     pwttaxs(subcnt) = par.taxhr(kwa)+par.tshift;
 end

  ppos = zeros(length(daybtimes)-1,1);  %  Allocate peak position vector
  mmag = zeros(length(daybtimes)-1,1);  %  Allocate peak amplitude vector

  %  Loop through each pair of consecutive light onsets to find activity stats 
 for kday=1:length(daybtimes)-1
     %  Find activity Onset within an interval about nightfall
     ntd = find(nightftimes > daybtimes(kday));
     nt = nightftimes(ntd(1));  % dark onset time for current interval
     % Indices for interval of interest
     dind = find((pwttaxs >= nt - hb) & (pwttaxs < nt + ha));  
     % If no indces exist for interval of intest exist, the gradient peak
     %  and magnitude is set to NaN
     if ~isempty(dind)
         [maxactm indmpa] = max(ggsma(dind));
         %  Limit gradient rise to that before the max peak
         gradsrh = dind(2:indmpa(1));
         if length(gradsrh) < 2
             gradsrh = dind;  %  If no max or max at first index
         end
         %  Find mean for whole day to ensure activity onset crosses average
         %  activity level
         dayrng = find(pwttaxs >= daybtimes(kday) & pwttaxs <= daybtimes(kday+1));
         gg1 = ggsma;
         avgact = mean(gg1(dayrng));  %  mean percent wake for current day
         %  Find points in interval of interest less than day average
         %  to exclude them from potential activity onset times
         toosmall = find(gg1(dind) < avgact);
         %  Ensure fast gradient leads to a high enough wake activity level
         gg1(dind(toosmall))=avgact;
         %  Find the corresponding gradient peaks
         gg = gradient(gg1);  %  Take gradient of censored waveform
         % Look for peak gradients before max point in interal
         [pos, mag] = peakfind(gg(gradsrh), gradsrh);
         [gmag, gind] = max(mag(2:end-1));
         if isempty(gind)  %  In max gradient found assign NaN for magnitude
            pposao(kday)= NaN;  % Position of activity onset
            mmagao(kday) = NaN;  %  Gradient value at detection point
         else   % If gradient found, back up to last local
                %   minimum of Wake activity
                % Look for close pre gradients within TOL% of max
            plim = gmag(1)-tol*gmag(1);
            validmaxs = find(mag >= plim);
            k = 1;  %Initalize back counter
            stp = round(pos(validmaxs(1)));  % Initial position for gradient MAX
            stval = ggsma(stp);
            %  Loop Back until local minimum found, within TOL% margin and
            %  greater than 75% of average value
            while stp-k > dind(1) && stval >= ggsma(stp-k-1)-tol*stval && stval >= ggsma(stp-k) - tol*stval ...
                   && ggsma(stp-k) > .75*avgact
                     stval = ggsma(stp-k);
                 k=k+1;
            end
            pposao(kday) = pwttaxs(stp-k+1);% Position of activity onset
            mmagao(kday) = mag(validmaxs(1)+1);%  Gradient value at detection point
          end
     else
           pposao(kday)=NaN;% Position of activity onset
           mmagao(kday)=NaN;%  Gradient value at detection point
     end
      %  If a activity onset found, find the peak activity (first
      %  significant peak to follow activity onset)
      if ~isnan(pposao(kday))  
      % Find peak activity after activity onset
      vind = find((pwttaxs >= pposao(kday)) & (pwttaxs < nt + ha));  % Interval of interest
      %if there is no peak activity after onset, the gradient peak and magnitude is set to NaN 
      if ~isempty(vind)
          [pos, mag] = peakfind(ggsma(vind),vind);  %  Local maxima wake levels
          [gmag, gind] = max(mag(1:end)); %  Find largest peak
          % if no max found set level to NaN
          if isempty(gind)
              pposap(kday)=pposao(kday);
              mmagap(kday) = NaN;
          else
             % Look for wake peaks within TOL% of max
             plim = gmag(1)-tol*gmag(1); 
             validmaxs = find(mag >= plim);
             % if falls on the nightfall border, make sure it is the max
              if validmaxs(1) == 1 && length(validmaxs) > 1
                  if mag(validmaxs(1)) < mag(validmaxs(2))
                      validmaxs(1) = validmaxs(2);  %  Move it to the max off NT border
                  end
              end            
              %  Assign peak activity closest to activity onset.
              pposap(kday) = pwttaxs(round(pos(validmaxs(1))));  % Peak activity position
              mmagap(kday) = ggsma(round(pos(validmaxs(1))));   % Peak activity value
          end
      else
           pposap(kday)=NaN;
           mmagap(kday)=NaN;
      end
      else
           pposap(kday)=NaN;
           mmagap(kday)=NaN;
      end
 end
%  Plot figure if requested
 if plotflag == 1
     
     plot(pwttaxs,pwts)
     yh = get(gca,'Ylim');  %  get height of plot
     %  If nightfall markers exist plot time to peak
     %  activity data as a vertical line and text label
     if ~isempty(nightftimes) && ~isempty(kday)
        ppos = pposao; 
        ntind = find(nightftimes > daybtimes(1));
        actnint = zeros(length(ppos),1);  %  Allocate interval vector
        for kalines = 1:length(ppos)
            plot(ppos(kalines)*ones(1,2), yh, 'r:')
            actnint(kalines) = ppos(kalines)-nightftimes(ntind(kalines));
            text(ppos(kalines),40+ .05*(yh(2)-yh(1)) , [num2str(actnint(kalines),3) ' hrs'] );
            text(ppos(kalines),40,  'From Dark' );
        end
        plot(pposap, mmagap, 'gx')
     else
         actnint = [];
         pkact = [];
     end
 else
     if length(daybtimes) > 1
     
     if ~isempty(nightftimes)
        ppos = pposao; 
        ntind = find(nightftimes > daybtimes(1));
        actnint = zeros(length(ppos),1);  %  Allocate interval vector
        for kalines = 1:length(ppos)
            actnint(kalines) = ppos(kalines)-nightftimes(ntind(kalines));
        end
        ppos = pposap; 
        ntind = find(nightftimes > daybtimes(1));
        pkact = zeros(length(ppos),1);  %  Allocate interval vector
        for kalines = 1:length(ppos)
            pkact(kalines) = ppos(kalines)-nightftimes(ntind(kalines));
        end
     else
         actnint = [];
         pkact = [];
     end
     else
         actnint = [];
         pkact = [];
     end
 end
