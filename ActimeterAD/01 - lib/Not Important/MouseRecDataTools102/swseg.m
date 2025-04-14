function [nttax, ntind, dytax, dyind] = swseg(taxhr, daybtimes,nightftimes, ldhrs)
% This function segments sequential sleep-wake statistics into a cell array
% of daytime nightime segments:
%
%    [nttax, nttax, dytax, dtax] = 
%                        swseg(taxhr, daybtimes,nightftimes,ldhrs)
%
% The inputs are:
%  TAXHR =>  Time axis in hours for the sleep monitored secession
%  DAYBTIMES => vectors of times in hours for night to day transitions that exist over whole
%  the collected interval
%  NIGHTTIMES => vectors of times in hours for day to night transitions that exist over whole 
%  the collected interval
%  LDHRS = > vector of daily times for dark to light and light to dark
%  transistions
%  The outputs are:
%  NTTAX => cell array of all nighttime times in which each element is a
%  contiguous time array
%  NTIND = > cell array of corresponding indicies
%  DYTAX => cell array of all daytime times in which each element is a
%  continous time array
%  DYTIND = > cell array of corresponding indicies
%
%   written by Kevin D. Donohue (kevin.donohue@sigsoln.com) July 2007, 2011
% 

%  Check to see the light dark nature of the interval
%  if interval does not include a light-dark transition
if isempty(daybtimes) && isempty(nightftimes) %  No markers in measure time interval
   %  Find which cycle data occurs in
    if ldhrs(1) <= taxhr(1)  && ldhrs(2) > taxhr(1)  %  is it daytime?
          dytax{1} = taxhr;
          dyind{1} = 1:length(taxhr);
          nttax{1} = [];
          ntind{1} = [];
    else  %  is it night ?
          dytax{1} = [];
          dyind{1} = [];
          nttax{1} = taxhr;
          ntind{1} = 1:length(taxhr);
   end
 elseif isempty(daybtimes) % Only the nightmarker present
       dind = find(taxhr <= nightftimes);
       nind = find(taxhr >= nightftimes);
       dytax{1} = taxhr(dind);
       dyind{1} = dind;
       nttax{1} = taxhr(nind);
       ntind{1} = nind;
   
  elseif isempty(nightftimes)  % Only the daytime marker present
       dind = find(taxhr >= daybtimes);
       nind = find(taxhr <= daybtimes);
       dytax{1} = taxhr(dind);
       dyind{1} = dind;
       nttax{1} = taxhr(nind);
       ntind{1} = nind;
 else %  both types of marker present
       %  Find which marker appears first
       if daybtimes(1) < nightftimes(1)  %  Day first
               cnt = 1;  %  Initaize segment counter
               endent = length(daybtimes); % get counter limiy
               nind = find(taxhr < daybtimes(cnt));
               %  Initalize cell arrays for contiguous segments
               nttax = cell(endent,1);
               ntind = cell(endent,1);
               dytax = cell(endent-1,1);  % Day time will have one less in this case
               dyind = cell(endent-1,1);
               %  Initial segment in the night
               nttax{1} = taxhr(nind);
               ntind{1} = nind;
               %  Get subsequent sections

               for cnt = 1:endent-1
                   dind = find(taxhr < nightftimes(cnt) &  taxhr > daybtimes(cnt));
                   nind = find(taxhr < daybtimes(cnt+1) & taxhr > nightftimes(cnt));
                   dytax{cnt} = taxhr(dind);
                   dyind{cnt} = dind;
                   nttax{cnt+1} = taxhr(nind);
                   ntind{cnt+1} = nind;
               end
               %  Get final segments
               cnt = endent;
               if length(nightftimes) == cnt   % if a final nighttime marker exists, get last 2 segments
                   dind = find(taxhr < nightftimes(cnt) &  taxhr > daybtimes(cnt));
                   nind = find(taxhr > nightftimes(cnt));
                   dytax{cnt} = taxhr(dind);
                   dyind{cnt} = dind;
                   nttax{cnt+1} = taxhr(nind);
                   ntind{cnt+1} = nind;
               else % If final marker was a daytime marker, get last segment
                   dind = find(taxhr > daybtimes(cnt));
                   dytax{cnt} = taxhr(dind);
                   dyind{cnt} = dind;
               end
       else  %  if first marker is nighttime marker
               cnt = 1;  % initalize segment counter
               endent = length(nightftimes);  % set counter limit
               %  Initalize cell arrays for contiguous segments
               nttax = cell(endent-1,1);
               ntind = cell(endent-1,1);
               dytax = cell(endent,1);  % Day time will have more less in this case
               dyind = cell(endent,1);
               %  Get initial segment before first nighttime marker
               dind = find(taxhr < nightftimes(cnt));
               dytax{cnt} = taxhr(dind);
               dyind{cnt} = dind;
               %  Get rest of segments
               for cnt = 1:endent-1
                   nind = find(taxhr < daybtimes(cnt) & taxhr > nightftimes(cnt));
                   dind = find(taxhr < nightftimes(cnt+1) &  taxhr > daybtimes(cnt));
                   dytax{cnt+1} = taxhr(dind);
                   dyind{cnt+1} = dind;
                   nttax{cnt} = taxhr(nind);
                   ntind{cnt} = nind;
               end
               %  Get final segemnts
               cnt = endent;
               if length(daybtimes) == cnt  % if last marker is a daytime marker, the 2 final segemnts
                   nind = find(taxhr > nightftimes(cnt) &  taxhr < daybtimes(cnt));
                   dind = find(taxhr > daybtimes(cnt));
                   dytax{cnt+1} = taxhr(dind);
                   dyind{cnt+1} = dind;
                   nttax{cnt} = taxhr(nind);
                   ntind{cnt} = nind;
               else  %  if last marker is a nighttime marker, get final segement
                   nind = find(taxhr > nightftimes(cnt));
                   nttax{cnt} = taxhr(nind);
                   ntind{cnt} = nind;
               end
       end
           
end
