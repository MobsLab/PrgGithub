%%HomestasisStat_KJ
% 07.09.2019 KJ
%
% function Hstat = HomestasisStat_KJ(x_density, y_density, Epoch, stattype)
%
% INPUT:
% - x_density       = timestamps of density curves
% - y_density       = values - number of events per windowsize
% - Epoch           = intervalSet - restriction of homestasis
% - stattype        = type of stat :
%
% OUTPUT:
%
% - Hstat           = struct - data for homeostasis (x_intervals, y_density, x_peaks, y_peaks, p, reg)
%
%
% Example :
%   Hstat = HomestasisStat_KJ(x_density, y_density, fittype)
%
% SEE 
%   DensityCurves_KJ DensityOccupation_KJ
%
%


function Hstat = HomestasisStat_KJ(x_density, y_density, Epoch, stattype)

%% CHECK INPUTS

if nargin < 3
  error('Incorrect number of parameters.');
end


x_intervals = x_density/3600E4;
%peaks
idx_maxima  = LocalMaxima(y_density);
tmp_peaks  = tsd(x_density(idx_maxima), idx_maxima);
if ~isempty(Epoch)
    idx_maxima = Restrict(tmp_peaks, Epoch); %only extrema in Epoch
end
idx_maxima = Data(tmp_peaks);
idx1 = y_density(idx_maxima) > max(y_density(idx_maxima))/3;
idx_peaks = idx_maxima(idx1);

%Hstat
Hstat.x_intervals = x_intervals;
Hstat.y_density   = y_density;
Hstat.x_peaks  = x_intervals(idx_peaks);
Hstat.y_peaks  = y_density(idx_peaks);


%if double split
try
    first_peak = Hstat.x_peaks(1);
    limSplit = first_peak+3;
catch
    limSplit = x_density(1)+3;
end

Hstat.limSplit = limSplit;

%regression
if stattype==1
    %one fit
    if length(idx_peaks)<3
        idx_peaks = idx_maxima;
    end
    [p0,~] = polyfit(x_intervals(idx_peaks), y_density(idx_peaks), 1);
    reg0 = polyval(p0,x_intervals);
    [R2_0, pv0] = corrcoef(x_intervals(idx_peaks),y_density(idx_peaks));
    try
        R2_0 = R2_0(1,2)^2; pv0 = pv0(1,2);
    catch
        R2_0 = 02; pv0 = 1;
    end
    %Hstat p and reg
    Hstat.p1   = p0;
    Hstat.reg0 = reg0;
    Hstat.pv0  = pv0;
    Hstat.R2_0 = R2_0;

elseif stattype==2
    idx1 = x_intervals(idx_peaks)<limSplit;
    idx2 = x_intervals(idx_peaks)>=limSplit;
    idx_peaks1 = idx_peaks(idx1);
    idx_peaks2 = idx_peaks(idx2);
    if length(idx_peaks1) < 3
        idx1 = x_intervals(idx_maxima)<limSplit;
        idx_peaks1 = idx_maxima(idx1);
    end
    if length(idx_peaks2) < 3
        idx2 = x_intervals(idx_maxima)>=limSplit;
        idx_peaks2 = idx_maxima(idx2);
    end

    %double fit
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);
    [R2_1, pv1] = corrcoef(x_intervals(idx_peaks1),y_density(idx_peaks1));
    try
        R2_1 = R2_1(1,2)^2; pv1 = pv1(1,2);
    catch
        R2_1 = 0; pv1 = 1;
    end

    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);
    [R2_2, pv2] = corrcoef(x_intervals(idx_peaks2),y_density(idx_peaks2));
    try
        R2_2 = R2_2(1,2)^2; pv2 = pv2(1,2);
    catch
        R2_2 = 0; pv2 = 1;
    end

    %Hstat p and reg
    Hstat.p1   = p1;
    Hstat.reg1 = reg1;
    Hstat.pv1  = pv1;
    Hstat.R2_1 = R2_1;

    Hstat.p2   = p2;
    Hstat.reg2 = reg2;
    Hstat.pv2  = pv2;
    Hstat.R2_2 = R2_2;

elseif stattype==3
    %exponential fit
    if length(idx_peaks)<10
        idx_peaks = idx_maxima;
    end
    [f, gof] = fit(x_intervals(idx_peaks), y_density(idx_peaks),'exp1');
    %Hstat
    Hstat.a = f.a;
    Hstat.b = f.b;
    Hstat.R2 = gof.rsquare;


elseif stattype==4

    %one fit
    if length(idx_peaks) < 3
        idx_peaks = idx_maxima;
    end
    [p0,~] = polyfit(x_intervals(idx_peaks), y_density(idx_peaks), 1);
    reg0 = polyval(p0,x_intervals);
    [R2_0, pv0] = corrcoef(x_intervals(idx_peaks),y_density(idx_peaks));
    try
        R2_0 = R2_0(1,2)^2; pv0 = pv0(1,2);
    catch
        R2_0 = 02; pv0 = 1;
    end

    %split before and after limSplit
    idx1 = x_intervals(idx_peaks)<limSplit;
    idx2 = x_intervals(idx_peaks)>=limSplit;
    idx_peaks1 = idx_peaks(idx1);
    idx_peaks2 = idx_peaks(idx2);
    if length(idx_peaks1) < 3
        idx1 = x_intervals(idx_maxima)<limSplit;
        idx_peaks1 = idx_maxima(idx1);
    end
    if length(idx_peaks2) < 3
        idx2 = x_intervals(idx_maxima)>=limSplit;
        idx_peaks2 = idx_maxima(idx2);
    end

    %double fit
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);
    [R2_1, pv1] = corrcoef(x_intervals(idx_peaks1),y_density(idx_peaks1));
    try
        R2_1 = R2_1(1,2)^2; pv1 = pv1(1,2);
    catch
        R2_1 = 0; pv1 = 1;
    end

    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);
    [R2_2, pv2] = corrcoef(x_intervals(idx_peaks2),y_density(idx_peaks2));
    try
        R2_2 = R2_2(1,2)^2; pv2 = pv2(1,2);
    catch
        R2_2 = 0; pv2 = 1;
    end

    %exponential fit
    if length(idx_peaks)<10
        idx_peaks = idx_maxima;
    end
    try
        [f, gof] = fit(x_intervals(idx_peaks), y_density(idx_peaks),'exp1');
    catch
        [f, gof] = fit(x_intervals, y_density,'exp1');
    end

    %Hstat p and reg
    Hstat.p0   = p0;
    Hstat.reg0 = reg0;
    Hstat.pv0  = pv0;
    Hstat.R2_0 = R2_0;

    Hstat.p1   = p1;
    Hstat.reg1 = reg1;
    Hstat.pv1  = pv1;
    Hstat.R2_1 = R2_1;

    Hstat.p2   = p2;
    Hstat.reg2 = reg2;
    Hstat.pv2  = pv2;
    Hstat.R2_2 = R2_2;

    Hstat.exp_a = f.a;
    Hstat.exp_b = f.b;
    Hstat.exp_R2 = gof.rsquare;

end



end
