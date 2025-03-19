function amplitude = maxThresholdOfDuration(tsa, duration)
%   
% INPUTS:  
% tsa: tsd object
% duration: duration of an iterval in ms
% OUTPUT:
% amplitude: maximum amplitude above which the signal is, 
 

rg = Range(tsa);
signal = Data(tsa);
duration = duration * 10;  % convert in E-4s

if rg(end)-rg(1) < duration
    error('tsd is shorter than the duration argument')
end

s1 = signal(1:(end-1));
s2 = signal(2:end);

sup_th = max(signal);
inf_th = min(signal);

thr = 10000;
while abs((sup_th+inf_th)/2 - thr)> 0.05
    thr = (sup_th+inf_th)/2;
    st = rg(s1 <= thr & s2 > thr); %start crossing
    en = rg(s1 >= thr & s2 < thr); %end
    
    %fix sizes
    if length(st)<length(en)
        st = [rg(1);st];
    elseif length(st)>length(en)
        en = [en;rg(end)];
    end
    
    if max(en-st)>duration
        inf_th = thr;
    elseif max(en-st)<duration
        sup_th = thr;
    else
        break
    end
    
end

amplitude = thr;