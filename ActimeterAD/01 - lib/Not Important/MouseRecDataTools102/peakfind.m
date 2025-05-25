function [pos, mag] = peakfind(sig, tx, smth, sz)
% This function finds and estimates local maxima in the vector SIG.
% TX is the time index for SIG, and peak locations and magnitude
% are interpolated based on the second order gradient estimates
%
%    [pos, mag] = peakfind(sig, tx, smth, sz)
%
% When the gradient goes from a postive value to a negative value, linear 
% interpolation is used to estimate the peak between these points.
% Inputs SMTH and SZ are optional.  If present they will smooth the signal
% before applying the gradient algorithm to find the peaks.
% For SMTH = 'lin' a hamming window of length SZ (relative to time index
% values in TX) is convolved with the signal to smooth out less significant peaks. 
% The output values are in vecotor POS, which include the positions of the local
% maximum (it will always include the endpoints) and corresponding vector MAG, includes
% the values of the peaks.  If smoothing was applied, MAG will be the smoothed
% value points.
%
%  Update June 2005, Kevin D. Donohue (kevin.donohue@sigsoln.com)


%  Get size and dimension of input vecotor
[r,c] = size(sig);
% Compute sampling interval (assuming time axis points are uniform)
intv = (tx(2)-tx(1));
fs = 1/intv;  %  Get sampling frequency 

%  Apply smoothing if requested
if nargin > 2
    if strcmp(smth,'lin')
        win = hamming(fix(sz*fs)+1);
        win = win/sum(win);   %  Normalize window
        wl = length(win);        
        da = cumsum(win(1:wl));
        swhl = sum(win) ./ (da(fix(wl/2)+1:length(da)));
        hwl = length(swhl);
        if r > 1
            tsig = conv2(sig,win,'same');
            tsig(1:hwl) = tsig(1:hwl).*swhl;  %  Compensate for edge averaging
            tsig(length(tsig)-hwl+1:length(tsig)) = tsig(length(tsig)-hwl+1:length(tsig)).*flipud(swhl);
        else
            swhl = swhl';
            win = win';
            tsig = conv2(sig,win,'same');
            tsig(1:hwl) = tsig(1:hwl).*swhl;  %  Compensate for edge averaging
            tsig(length(tsig)-hwl+1:length(tsig)) = tsig(length(tsig)-hwl+1:length(tsig)).*fliplr(swhl);
        end
    end
else
    tsig = sig;
end

%  Compute gradients at every point
dsig = gradient(tsig,intv);
%  Start through gradient values to detect a change from positive to
%  negative, indicate a peak
count = 1;
%  First point point in array is always selected
mag(count) = tsig(1);
pos(count) = tx(1);
%  Step through rest of array
for k=2:length(dsig)
    %  Gradients change sign or = 0
    if(dsig(k) <= 0 && dsig(k-1) >= 0)
        count = count +1;
        if dsig(k) == dsig(k-1)
            % if gradients are equal (0), we have flat field, just store all
            % points and the middle point will be selected later in the
            % program
            [dum, idum] = max(tsig((k-1):k));
            mag(count) = dum(1);
            pos(count) = tx(k+idum-2);
        else  %  If gradient changes direction
            %  Interpolate to find peak between the change in gradient
            %  points, use a weighted average between the 2 peaks
              magdum = max(tsig(k-1:k));  %  Find max between the 2 end points
              mag(count) = magdum(1);  % In case both equal, just select one
          % Weighted average only works for positive numbers, so we need to
          % check for diffent combinations of positive and negative values 
          if tsig(k) > 0 && tsig(k-1) > 0  % both positive
              pos(count) = (tsig(k)*tx(k) + tsig(k-1)*tx(k-1))/sum(tsig(k-1:k));
          elseif tsig(k) < 0 && tsig(k-1) < 0  % both negative
              t1 = abs(tsig(k-1))-min(tsig);  %  shift up to postive values
              t2 = abs(tsig(k))-min(tsig);
              pos(count) = (t2*tx(k) + t1*tx(k-1))/(t1+t2);
          elseif tsig(k) == 0 && tsig(k-1)==0  %  Both zero
              pos(count) = mean(tx(k-1:k));
          elseif tsig(k) <= 0 && tsig(k-1) >= 0   % Only first point positive 
              pos(count) = tx(k-1);
          else                           %  Only second point postive
              pos(count) = tx(k);
          end
        end
    end
end
% Include last point if it was not already slected in the last loop.
if pos(count) ~= tx(length(tx))
    pos(count+1) = tx(length(tx));
    mag(count+1) = tsig(length(tx));
end

% Check for flat fields, choose center of field as maximum.
k=1;
nk =0;

% Select middle of flat fields and edges
nmag = zeros(length(pos),1);  %  Preallocate trimmed magnitudes
npos = zeros(length(pos),1);  %  Preallocate trimmed positions
while k < length(pos)
    %  Consecutive peaks are detected, use middle point
   if (mag(k) == mag(k+1))
        count = 1;
        nk=nk+1;
        nmag(nk)=mag(k);
        npos(nk)= pos(k);
        %  Count out consecutive points
        while count+k < length(pos) && mag(k) == mag(k+count) 
            count = count + 1;
        end
        nk=nk+1;
        nmag(nk) = mag(k);
        npos(nk) = pos(k + fix(count/2));
        % if even number select at half interval in center 
        if count/2 ~= fix(count/2)
           npos(nk) = npos(nk) + intv/2;
        end
        k = k+count;
        %  Also include end point of flat field
        nk=nk+1;
        nmag(nk) = mag(k-1);
        npos(nk) = pos(k-1);

   else
       nk=nk+1;
       nmag(nk) = mag(k);
       npos(nk) = pos(k);
       k=k+1;
   end
end
%  Reassign points to limit prune flat field points
nmag(nk+1) = mag(k);
npos(nk+1) = pos(k);
mag = nmag(1:(nk+1));
pos = npos(1:(nk+1));
