function [Q, handle] = NWbootstrap_epkv(X, Y, bins, bandwidth, alpha, resamples)

%
%SOLOMON HSIANG
%SMH2137@COLUMBIA.EDU
%MAY 2010
%----------------------
%
%[Q, handle] = NWbootstrap_epkv(X, Y, BINS, BANDWIDTH, ALPHA, RESAMPLES)
%
%Produces the non-parametric Nadaraya-Watson estimate of the mean of Y
%conditional on X, using an Epanechnikov kernal. It also estimates the  
%1-ALPHA confidence interval via bootstrapping and graphs both. 
%
%The Epanechnikov kernal is of the form: 
%                       weight = 3/4*(1-(u/h)^2)*(abs(u/h)<=1)
%
%in contrast to the function NWbootstrap that uses a Gaussian kernal. Note
%that no information beyond the location X +/- BANDWIDTH contributes the 
%estimate at location X, in contrast to a Gaussian kernal that distributes
%limited information beyond X +/- 2 * BANDWIDTH.
%
%X and Y are matrices of equal size (missing observations as NaNs are okay) 
%with any orientation. BINS is an integer number of bins along X that are 
%used to compute the conditional mean, BINS << n. BANDWIDTH is the standard
%deviation of the normal distribution used to weight observations - a 
%larger bandwidth will result in a smoother plot. ALPHA describes the 
%confidence interval that will be plotted, which will contain (1-ALPHA) of 
%the observations. RESAMPLES is the number of resamples done in the 
%bootstrap procedure to estimate the confidence interval.
%
%The output Q is an array that is 4 by BINS.  The first row is the values of
%x for each bin, the second row is the estimated conditional mean y(x) for
%that bin, and the the third and fourth rows are the bounds of the 1-ALPHA
%confidence interval CI_max(x) and CI_min(x) for each bin.
%
%If output HANDLE is specified, it returns the handle to the figure plotted.
%
%----------------------
%
%RECOMMENDED VALUES (approx):
%
%BINS < n/10 (more bins will slow the bootstrap)
%
%BANDWIDTH < (max(X) - min(X))/8
%BANDWIDTH > (max(X) - min(X))/(2*BINS)
%
%ALPHA = 0.05 (for 95% CI)
%
%RESAMPLES > 100, if you have time, = 10,000

%reshaping X and Y and removing NaNs

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

if bandwidth*2<(max(X)-min(X))/bins
    disp('WARNING (SOL): BANDWIDTH IS TOO SMALL FOR THE NUMBER OF BINS CHOSEN')
    disp('(INFORMATION MAY BE LOST DUE TO SPARSE SAMPLING)')
end

if bandwidth*2>(max(X)-min(X))
    disp('WARNING (SOL): BANDWIDTH IS SO LARGE THAT INFORMATION IS CARRIED TOO FAR')
    disp('(INFORMATION IS CARRIED ACROSS THE ENTIRE DOMAIN FOR EACH OBSERVATION)')
end

    



%estimating the mean

N=size(X);
h = bandwidth;
Nbins = bins;
xlow = min(X); xhigh = max(X);
range = xhigh-xlow;
bin_range = range/Nbins;
binsX = xlow+bin_range/2:bin_range:xhigh-bin_range/2;
binsY = nan(size(binsX));
for i = 1:Nbins
    dists_h = (X-binsX(i)*ones(size(X)))/h;
    weights = 3/4*(1-dists_h.^2).*(abs(dists_h)<=1);
    binsY(i) = (weights'*Y)/sum(weights);
end

%resampling to bootstrap CI

waitmessage = ['bootstrapping ' num2str(resamples) ' times'];
H = waitbar(0,waitmessage);

Nsamples = resamples;
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

sorted_samples = sort(resamples);
CI = [sorted_samples(round((1-alpha/2)*Nsamples),:);sorted_samples(round(alpha/2*Nsamples),:)];

figure
handle = plot(binsX,binsY,'k');
hold on
plot(binsX,CI(1,:),'k--')
plot(binsX,CI(2,:),'k--')
first = ['Epanechnikov kernal, bandwidth = ' num2str(h)];
second = [num2str((1-alpha)*100) '% confidence interval'];
legend(first, second)

Q = [binsX;binsY;CI];

