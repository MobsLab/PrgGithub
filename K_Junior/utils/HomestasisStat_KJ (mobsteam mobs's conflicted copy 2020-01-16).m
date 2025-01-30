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
% - rescale (optional)      = 0 no rescale, 1 rescale by max, 2 rescale by mean (default 0) 
% - smoothing (optional)    = smoothing (default 0)
%                           
%
% OUTPUT:
%
% - Hstat           = struct - data for homeostasis (x_intervals, y_density, x_peaks, y_peaks, p, reg)
%
%
% Example :
%   Hstat = HomestasisStat_KJ(x_density, y_density, Epoch, fittype)
%
% SEE 
%   DensityCurves_KJ DensityOccupation_KJ
%
%


function Hstat = HomestasisStat_KJ(x_density, y_density, Epoch, stattype,varargin)

%% CHECK INPUTS

if nargin < 4 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'rescale'
            rescale = varargin{i+1};
            if rescale<0
                error('Incorrect value for property ''rescale''.');
            end
        case 'smoothing'
            smoothing = varargin{i+1};
            if smoothing<0
                error('Incorrect value for property ''smoothing''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('rescale','var')
    rescale = 0;
end
if ~exist('smoothing','var')
    smoothing = 0;
end


%% Compute peaks
%peaks
if smoothing
    idx_maxima  = LocalMaxima(Smooth(y_density,smoothing));
else
    idx_maxima  = LocalMaxima(y_density);
end
tmp_peaks  = tsd(x_density(idx_maxima), idx_maxima);
if ~isempty(Epoch)
    tmp_peaks = Restrict(tmp_peaks, Epoch); %only extrema in Epoch
end
idx_maxima = Data(tmp_peaks);

max_peak = sort(y_density(idx_maxima),'descend');
max_peak = mean(max_peak(1:min(3,length(max_peak)))); %average 3 biggest points

idx1 = y_density(idx_maxima) > max_peak/3;
idx_peaks = idx_maxima(idx1);


%% Hstat

%rescale eventually
if rescale==1 % divide by Upper value
    if length(idx_peaks) > 10
        sort_peak = sort(y_density(idx_peaks));
        UpperValue = mean(sort_peak(end-4:end)); % 5 bigger peaks
        y_density  = y_density / UpperValue; 
    else
        sort_peak = sort(y_density);
        UpperValue = mean(sort_peak(end-50:end)); % 5 bigger peaks
        y_density  = y_density / UpperValue;
    end
elseif rescale==2 % percentage of (Epoch) mean
    if ~isempty(Epoch)
        tDensity = tsd(x_density,y_density);
        meanValue = mean(Data(Restrict(tDensity,Epoch)));
    else
        meanValue = mean(y_density);
    end
    y_density  = y_density / meanValue;  
end

%Hstat
x_intervals = x_density/3600E4; %x in hours

Hstat.x_intervals = x_intervals;
Hstat.y_density   = y_density;
Hstat.x_peaks  = x_intervals(idx_peaks);
Hstat.y_peaks  = y_density(idx_peaks);


%% Slopes, R, pvalue ...


if length(idx_peaks) < 8 && length(idx_maxima)>8
    idx_peaks = idx_maxima;
elseif length(idx_peaks) < 8
    idx_peaks = 1:4:length(y_density);
end

%if double split
try
    first_peak = Hstat.x_peaks(1);
    limSplit = first_peak+2;
catch
    limSplit = x_density(1)+3;
end

Hstat.limSplit = limSplit;

%regression
if stattype==1
    %one fit
    [p0,~] = polyfit(x_intervals(idx_peaks), y_density(idx_peaks), 1);
    reg0 = polyval(p0,x_intervals);
    [R2_0, pv0] = corrcoef(x_intervals(idx_peaks),y_density(idx_peaks));
    try
        R2_0 = R2_0(1,2)^2; pv0 = pv0(1,2);
    catch
        R2_0 = 02; pv0 = 1;
    end
    rmse0 = sqrt(mean((y_density-reg0).^2));
    
    %Hstat p and reg
    Hstat.p1    = p0;
    Hstat.reg0  = reg0;
    Hstat.pv0   = pv0;
    Hstat.R2_0  = R2_0;
    Hstat.rmse0 = rmse0;
    

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
    rmse1 = sqrt(mean((y_density(idx_peaks1)-polyval(p1,x_intervals(idx_peaks1))).^2));
    
    
    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);
    [R2_2, pv2] = corrcoef(x_intervals(idx_peaks2),y_density(idx_peaks2));
    try
        R2_2 = R2_2(1,2)^2; pv2 = pv2(1,2);
    catch
        R2_2 = 0; pv2 = 1;
    end
    rmse2 = sqrt(mean((y_density(idx_peaks2)-polyval(p2,x_intervals(idx_peaks2))).^2));
    
    %Hstat p and reg
    Hstat.p1    = p1;
    Hstat.reg1  = reg1;
    Hstat.pv1   = pv1;
    Hstat.R2_1  = R2_1;
    Hstat.rmse1 = rmse1;

    Hstat.p2    = p2;
    Hstat.reg2  = reg2;
    Hstat.pv2   = pv2;
    Hstat.R2_2  = R2_2;
    Hstat.rmse2 = rmse2;
    

elseif stattype==3
    %exponential fit
    funcexp = @(b,x)b(1)*exp(x * b(2));
    param0 = [100 -0.05];
    try
        mdl = fitnlm(x_intervals(idx_peaks), y_density(idx_peaks), funcexp, param0);
    catch
        mdl = fitnlm(x_intervals, y_density, funcexp, param0);
    end

    Hstat.exp_a   = mdl.Coefficients.Estimate(1);
    Hstat.exp_b   = mdl.Coefficients.Estimate(2);
    Hstat.pv_a    = mdl.Coefficients.pValue(1);
    Hstat.pv_b    = mdl.Coefficients.pValue(2);
    Hstat.exp_R2  = mdl.Rsquared.Adjusted;
    Hstat.reg_exp = funcexp([Hstat.exp_a Hstat.exp_b],x_intervals);
    Hstat.rmseExp = sqrt(mean((y_density-Hstat.reg_exp).^2));
    

elseif stattype==4
    %one fit
    [p0,~] = polyfit(x_intervals(idx_peaks), y_density(idx_peaks), 1);
    reg0 = polyval(p0,x_intervals);
    [R2_0, pv0] = corrcoef(x_intervals(idx_peaks),y_density(idx_peaks));
    try
        R2_0 = R2_0(1,2)^2; pv0 = pv0(1,2);
    catch
        R2_0 = 02; pv0 = 1;
    end
    rmse0 = sqrt(mean((y_density-reg0).^2));

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
    rmse1 = sqrt(mean((y_density(idx_peaks1)-polyval(p1,x_intervals(idx_peaks1))).^2));

    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);
    [R2_2, pv2] = corrcoef(x_intervals(idx_peaks2),y_density(idx_peaks2));
    try
        R2_2 = R2_2(1,2)^2; pv2 = pv2(1,2);
    catch
        R2_2 = 0; pv2 = 1;
    end
    rmse2 = sqrt(mean((y_density(idx_peaks2)-polyval(p2,x_intervals(idx_peaks2))).^2));
    

    %exponential fit
    funcexp = @(b,x)b(1)*exp(x * b(2));
    param0 = [100 -0.05];
    try
        mdl = fitnlm(x_intervals(idx_peaks), y_density(idx_peaks), funcexp, param0);
    catch
        try
            mdl = fitnlm(x_intervals, y_density, funcexp, param0);
        catch
            mdl = [];
        end
    end
    
    if ~isempty(mdl)
        exp_a  = mdl.Coefficients.Estimate(1);
        exp_b  = mdl.Coefficients.Estimate(2);
        pv_a   = mdl.Coefficients.pValue(1);
        pv_b   = mdl.Coefficients.pValue(2);
        exp_R2 = mdl.Rsquared.Adjusted;
        reg_exp = funcexp([exp_a exp_b],x_intervals);
        rmseExp = sqrt(mean((y_density-reg_exp).^2));
    else
        [f, gof] = fit(x_intervals(idx_peaks), y_density(idx_peaks),'exp1');
        exp_a   = f.a;
        exp_b   = f.b;
        pv_a    = nan;
        pv_b    = nan;
        exp_R2  = gof.rsquare;
        reg_exp = f(x_intervals);
        rmseExp = sqrt(mean((y_density-reg_exp).^2));
    end
    
    
    %Hstat p and reg
    Hstat.p0    = p0;
    Hstat.reg0  = reg0;
    Hstat.pv0   = pv0;
    Hstat.R2_0  = R2_0;
    Hstat.rmse0 = rmse0;

    Hstat.p1    = p1;
    Hstat.reg1  = reg1;
    Hstat.pv1   = pv1;
    Hstat.R2_1  = R2_1;
    Hstat.rmse1 = rmse1;
    
    Hstat.p2    = p2;
    Hstat.reg2  = reg2;
    Hstat.pv2   = pv2;
    Hstat.R2_2  = R2_2;
    Hstat.rmse2 = rmse2;

    Hstat.exp_a   = exp_a;
    Hstat.exp_b   = exp_b;
    Hstat.pv_a    = pv_a;
    Hstat.pv_b    = pv_b;
    Hstat.exp_R2  = exp_R2;
    Hstat.reg_exp = reg_exp;
    Hstat.rmseExp = rmseExp;
    
end



end
