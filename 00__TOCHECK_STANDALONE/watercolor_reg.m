function [Q, handle] = watercolor_reg(X, Y, bins, bandwidth, varargin)

%----------------------
%SOLOMON HSIANG
%SHSIANG@PRINCETON.EDU
%AUG 2012
%----------------------
%
%[Q, handle] = watercolor_reg(X, Y, BINS, BANDWIDTH, options)
%
%version 1.0
%
%WATERCOLOR_REG estimates a non-parametric regression (Nadaraya-Watson) and
%plots it "visually weighted" based on the observational density of the
%underlying data.  Specifically, the darkness of the distribution is the
%estimated probability that the conditional mean is at a given value.  The
%estimated conditional mean is plotted white, so it contrasts most strongly
%with the probability density when the estimate is more certain. Coloration
%in the probability density function reflects probability mass, so the
%quantity of "ink" used along a vertical line integral is always conserved
%(since the vertical integral of the probability density must equal one).
%The probability density at each value of X is estimated by a kernel 
%density using bootstrapped estimates of the conditional mean. 
%
%For complete details on the regression model, type 'help NWbootstrap_epkv'
%
%OPTIONAL ARGUMENTS:
%   RESAMPLES   - integer scaler
%   COLORVECTOR - three element colorvector
%
%WATERCOLOR_REG(X, Y, BINS, BANDWIDTH, RESAMPLES) specifies the number of
%times that the conditional mean is estimated to construct the probability
%density. A larger value for resamples will produce more accurate results,
%however the completion time of the program is roughly BINS * RESAMPLES. If
%RESAMPLES is not specified, 100 resamples is the default.
%
%WATERCOLOR_REG(X, Y, BINS, BANDWIDTH, COLORVECTOR) plots the maximum color
%as the color specified by the three-element vector COLORVECTOR (eg 
%[0 .3 .9]). If COLORVECTOR is not specified, black is used ([0 0 0]).
%
%The output Q is an structure with the values of x for each bin, and the 
%estimated conditional mean y(x) for that bin.
%
%If output HANDLE is specified, it returns the handle to the figure plotted.
%
%Requires functions 
%       DROP_MISSING_Y.m
%       PLOT_COLORED_FILL.m
%
%NOTE: WATERCOLOR_REG is identical to the "SMOOTH" option of VWREGRESS
%
%See also NWbootstrap_epkv, NWbootstrap_epkv_3D, NWbootstrap, vwregress,
%boxplot_regression
%
%--------------------------------------------------------------------------
%
%WHEN USING THIS CODE, PLEASE CITE: 
%
%   Hsiang, S.M. (2012) "Visually-weighted regression", working paper
%
%THE DEVELOPMENT OF THIS PROCEDURE IS DISCUSSED IN THESE POSTS:
%
%   http://www.fight-entropy.com/2012/08/visually-weighted-confidence-intervals.html
%   http://www.fight-entropy.com/2012/07/visually-weighted-regression.html
%   http://www.fight-entropy.com/2012/08/watercolor-regression.html
%
%THIS FUNCTION AND RELATED FUNCTIONS ARE AVAILABLE FOR DOWNLOAD AT
%   
%   http://www.solomonhsiang.com/computing/data-visualization
%
%--------------------------------------------------------------------------
%
%RECOMMENDED VALUES (approx):
%
%BINS < n/10 (more bins will slow the bootstrap if RESAMPLES is specified)
%
%BANDWIDTH < (max(X) - min(X))/8
%BANDWIDTH > (max(X) - min(X))/(2*BINS)
%
%
%RESAMPLES > 100, if you have time, = 10,000
%
%----------------------
%
%EXAMPLE:
%
%     x = randn(100,1);
%     e = randn(100,1);
%     y = 2*x+x.^2+4*e;
% 
%     watercolor_reg(x, y, 30, 1);
%     watercolor_reg(x, y, 100, 1, 150);
%     watercolor_reg(x, y, 100, 1, 150, [.5 0 0]);
%
%----------------------


%---------------------------------------reshaping X and Y and removing NaNs

S = size(X);
S2 = size(Y);
X = reshape(X,S(1)*S(2),1);
Y = reshape(Y,S2(1)*S2(2),1);

if length(Y) ~= length(X)
    disp('SOL: X AND Y MUST BE THE SAME SIZE')
    Q = nan(1);
    return
end

[Y, X] = drop_missing_Y(Y, X);

%---------------------------checking that bandwidth selection is reasonable

if bandwidth*2<(max(X)-min(X))/bins
    disp('WARNING (SOL): BANDWIDTH IS TOO SMALL FOR THE NUMBER OF BINS CHOSEN')
    disp('(INFORMATION MAY BE LOST DUE TO SPARSE SAMPLING)')
end

if bandwidth*2>(max(X)-min(X))
    disp('WARNING (SOL): BANDWIDTH IS SO LARGE THAT INFORMATION IS CARRIED TOO FAR')
    disp('(INFORMATION IS CARRIED ACROSS THE ENTIRE DOMAIN FOR EACH OBSERVATION)')
end

%----estimating the conditional mean with Nadaraya-Watson kernal regression

N=size(X);
h = bandwidth;
Nbins = bins;
xlow = min(X); xhigh = max(X);
range = xhigh-xlow;
bin_range = range/Nbins;
binsX = xlow+bin_range/2:bin_range:xhigh-bin_range/2;
binsY = nan(size(binsX));
binsW = nan(size(binsX));
for i = 1:Nbins
    dists_h = (X-binsX(i)*ones(size(X)))/h;
    weights = 3/4*(1-dists_h.^2).*(abs(dists_h)<=1);
    binsY(i) = (weights'*Y)/sum(weights);
    binsW(i) = sum(weights);
end

%---------------------------------------------------------- parsing options

%set defaults

mean_colorvector = [1 1 1]; %set conditional mean is white
%mean_colorvector = [0 0 0]; %set conditional mean is white


linewidthscalar = .5; %conditional mean line width = .5 is default

colorvector = [0 0 0];  %black is default for probability mass color
Nsamples = 100;         %100 resamples is default

alpha = 0.05;           %"conserve ink" based on the 95% CI interval

S = size(varargin);

if S(2) > 0
    for s = 1:S(2)
        if isnumeric(varargin{s})
            if length(varargin{s}) == 1
                Nsamples = varargin{s};
            elseif length(varargin{s}) == 3
                colorvector = varargin{s};
            end
        end
    end
end

%------------------------------ bootstraping estimates for spaghetti and CI

waitmessage = ['bootstrapping ' num2str(Nsamples) ' times'];
H = waitbar(0,waitmessage);

resamples = nan(Nsamples, Nbins);
for j = 1:Nsamples
    rs = ceil(rand(length(X),1)*length(X));
    X_rs = X(rs);
    Y_rs = Y(rs);
    waitbar(j/Nsamples,H);
    for i = 1:Nbins
        dists_h = (X_rs-binsX(i)*ones(N))/h;
        weights = 3/4*(1-dists_h.^2).*(abs(dists_h)<=1);
        resamples(j,i) = (weights'*Y_rs)/sum(weights);
    end
end

close(H)

%compute CI to quickly approximate the relative weights needed to conserve
%ink

sorted_samples = sort(resamples);
CI = [sorted_samples(round((1-alpha/2)*Nsamples),:);sorted_samples(round(alpha/2*Nsamples),:)];

binsW = 1./abs(diff(CI,1));
for i=1:length(binsW)
    if isnan(binsW(i))
        binsW(i) = min(binsW);
    end
end

%---------------- computing smoothed distribution of conditional mean prob.

%the approach here is to define a new coordinate system in Y here
%(called "grids") that correspond to the xvalues in binsX. The grids
%span the range of bootstrapped estimates and break that range up into
%bins (Vbins = Nbins = BINS). The bootstapped "spaghetti" plot is then
%transformed into a smooth kernel density (over Y) within each x-bin.
%If many bootstrapped estimates fall in a bin, it has a high
%probability and the color saturation is heightened to reflect that.
%This is repeated for each x-bin so that the entire range of
%bootstrapped estimates is made into a smooth joint distribution in X
%and Y.

%The mean regression line is here plotted as white so that it strongly
%contrasts with a background of high density (confident) bootstrapped
%estimates. If the background is diffuse, it will be close to white and
%the conditional mean will not contrast well. This will lower its
%visual weight.

%The visual weighting scheme of the estimated distribution is designed
%to have "fixed ink" for each x-bin. The vertical integrated amount of
%color should be constant for a vertical line integral.

Vbins = bins; %use same number of bins in vertical as used in horizontal
Vgrids = nan(Vbins,Nbins); %verticies for smoothing grid
Vmasses = nan(Vbins,Nbins);  %number of bootstrapped estimates at each vertex
Vranges = nan(1,Nbins); %store the grid scale size for each vertical grid

for j = 1:Nbins
    
    %vertical range for each bin
    ylow = min(sorted_samples(:,j));
    yhigh = max(sorted_samples(:,j));
    range = yhigh-ylow;
    
    V_h = range/10; %set bandwidth to be 1/10 of range
    
    Vgrid_range = range/Vbins;
    
    %bin specific vertical grid
    grid = ylow+Vgrid_range/2:Vgrid_range:yhigh-Vgrid_range/2';
    gbins = length(grid);
    %mass (of boostrapped estimates) at each grid point in the bin
    mass = nan(size(grid));
    
    %compute kernel density along the vertical grid
    for i = 1:gbins
        
        dists_h = (sorted_samples(:,j)-grid(i)*ones(size(sorted_samples(:,j))))/V_h;
        
        weights = 3/4*(1-dists_h.^2).*(abs(dists_h)<=1);
        
        mass(i) = nansum(weights);
        
    end
    
    Vgrids(1:gbins,j) = grid;
    Vmasses(1:gbins,j) = mass';
    Vranges(j) = Vgrid_range;
    
end

%scale mass by 1/Vgrid_range since narrower grid means more mass in
%each grid cell

Vmasses_scaled = Vmasses.*repmat(1./Vranges,Vbins,1);

%to prevent NaNs from crashing the plot_colored_fill function
for i=1:Nbins
    for j = 1:Vbins
        if isnan(Vmasses_scaled(i,j))
            Vmasses_scaled(i,j) = nanmin(nanmin(Vmasses_scaled,[],1),[],2);
        end
    end
end

%because the plot_colored_fill function scales each grid row to the max
%of that row, need a vector to store the densities of the max in each
%row:
max_Vmass2 = nanmax(Vmasses_scaled,[],2);
max_Vmass = max_Vmass2/nanmax(max_Vmass2); %rescale to have a max of one

for i = 1:Vbins-1
    %scale the color of each grid row relative to the max in that row
    Vgrid_row_colorvector = [1 1 1]-([1 1 1]-colorvector)*max_Vmass(i);
    
    plot_colored_fill(binsX,Vgrids(i,:),Vgrids(i+1,:), ...
        mean(Vmasses_scaled(i:i+1,:),1),Vgrid_row_colorvector, [1 1 1]);

end


%     %section to plot out the moving grid system used to smooth the
%     %resampled estimates (illustrative only)
%     for i = 1:Vbins
%         plot(binsX,Vgrids(i,:),'Color', [1 1 1]*.1, 'LineWidth', .05)
%     end
%     for j = 1:Nbins
%         plot([binsX(j), binsX(j)], [Vgrids(1,j), Vgrids(end,j)], 'Color', [1 1 1]*.1, 'LineWidth', .05)
%     end

%----------------------------------------------------------Plotting results

%plot conditional mean
handle = plot(binsX,binsY,'Color', mean_colorvector, 'LineWidth', linewidthscalar);

%label the plot
xlabel('X')
ylabel('Y')
box off
hold on

titlestring = ['Epanechnikov bwidth = ' num2str(bandwidth) ' [' num2str(Nsamples) ' resamples]'];
title(titlestring);

axis tight
box off

%OUTPUT

Q = struct('X',binsX,'Y', binsY);
    