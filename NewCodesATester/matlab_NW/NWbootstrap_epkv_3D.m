function [Q, handle] = NWbootstrap_epkv_3D(X1, X2, Y, bins1, bins2, bandwidth1, bandwidth2, alpha, resamples)

%
%SOLOMON HSIANG
%SMH2137@COLUMBIA.EDU
%JULY 2010
%----------------------
%
%[Q, handle] = NWbootstrap_epkv_3D(X1, X2, Y, bins1, bins2, bandwidth1, bandwidth2, alpha, resamples)
%
%Produces the non-parametric Nadaraya-Watson estimate of the mean of Y
%conditional on X1 and X2, using an Epanechnikov kernal. It also estimates 
% the 1-ALPHA confidence interval via bootstrapping and graphs both. 
%
%The Epanechnikov kernal is of the form: 
%                       weight = 3/4*(1-(u/h)^2)*(abs(u/h)<=1)
%
%Where h is the bandwidth. In this 2D space, distances are first converted
%to bandwidth-equivelent distances (eg X1_u = X1/bandwidth1) and then
%distances are computed between points in this Eucliean space (u = (X1_u^2
%+ X2_u^2)^0.5.
%
%In contrast to the function NWbootstrap that uses a Gaussian kernal. Note
%that no information beyond the location X +/- BANDWIDTH contributes the 
%estimate at location X, in contrast to a Gaussian kernal that distributes
%limited information beyond X +/- 2 * BANDWIDTH.
%
%X1, X2 and Y are matrices of equal size (missing observations as NaNs are
%okay) with any orientation. BINS1 and BINS2 are integer numbers of bins along X1 and X2 that are used to compute the conditional mean, BINS << n. BANDWIDTH1 and BANDWIDTH2 are half the width of the kernal used to weight observations - a 
%larger bandwidth will result in a smoother plot. ALPHA describes the 
%confidence interval that will be plotted, which will contain (1-ALPHA) of 
%the observations. RESAMPLES is the number of resamples done in the 
%bootstrap procedure to estimate the confidence interval.
%
%Confidence intervals are plotted as vertical black whiskers. To prevent CI
%from being plotted, set ALPHA = 1.
%
%The output Q is a structure containing the parameters of the estimated
%surface and the actual estimate. The estimate includes values of X1 and X2
%along the axes, the conditional mean at each value of (x1, x2) and the CI
%at each value of (x1, x2).
%
%The plotted figure can be regenerated with the command:
%
%surf(Q.output.X1, Q.output.X2, X.output.mean')
%
%The transpose of MEAN is used because, for some reason, the function SURF
%plots surfaces backwards of other functions (eg. PLOT3).
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

SX1 = size(X1);
SX2 = size(X2);
SY = size(Y);
X1 = reshape(X1,SX1(1)*SX1(2),1);
X2 = reshape(X2,SX2(1)*SX2(2),1);
Y = reshape(Y,SY(1)*SY(2),1);

if length(Y) ~= length(X1)
    disp('SOL: X1 AND Y MUST BE THE SAME SIZE')
    Q = false;
    return
end

if length(Y) ~= length(X2)
    disp('SOL: X2 AND Y MUST BE THE SAME SIZE')
    Q = false;
    return
end

keep_obs = min(isfinite(X1),isfinite(X2)); %1 if no missing obs in X1, X2 or Y
keep_obs = min(keep_obs, isfinite(Y));

X1 = X1(keep_obs); %dropping obs with any missing variable
X2 = X2(keep_obs);
Y = Y(keep_obs);


%checking bandwidth for scaling

if bandwidth1*2<(max(X1)-min(X1))/bins1 
    disp('WARNING (SOL): BANDWIDTH FOR X1 IS TOO SMALL FOR THE NUMBER OF BINS CHOSEN')
    disp('(INFORMATION MAY BE LOST DUE TO SPARSE SAMPLING)')
end

if bandwidth2*2<(max(X2)-min(X2))/bins2 
    disp('WARNING (SOL): BANDWIDTH FOR X2 IS TOO SMALL FOR THE NUMBER OF BINS CHOSEN')
    disp('(INFORMATION MAY BE LOST DUE TO SPARSE SAMPLING)')
end


if bandwidth1*2>(max(X1)-min(X1))
    disp('WARNING (SOL): BANDWIDTH FOR X1 IS SO LARGE THAT INFORMATION IS CARRIED TOO FAR')
    disp('(INFORMATION IS CARRIED ACROSS THE ENTIRE DOMAIN FOR EACH OBSERVATION)')
end


if bandwidth2*2>(max(X2)-min(X2))
    disp('WARNING (SOL): BANDWIDTH FOR X2 IS SO LARGE THAT INFORMATION IS CARRIED TOO FAR')
    disp('(INFORMATION IS CARRIED ACROSS THE ENTIRE DOMAIN FOR EACH OBSERVATION)')
end

%finding the bounds of the support

N=length(X1);

h1 = bandwidth1;
h2 = bandwidth2;

x1low = min(X1); x1high = max(X1);
x2low = min(X2); x2high = max(X2);
range1 = x1high-x1low;
range2 = x2high-x2low;

Nbins1 = bins1;
Nbins2 = bins2;

bin_range1 = range1/Nbins1; %size of a bin in each direction
bin_range2 = range2/Nbins2;

%max and min values in the sample are at the outer edge of the extreme bins
binsX1 = x1low+bin_range1/2:bin_range1:x1high-bin_range1/2;
binsX2 = x2low+bin_range2/2:bin_range2:x2high-bin_range2/2;

binsY = nan(Nbins1, Nbins2);


%estimating the mean

for i = 1:Nbins1
    for j = 1:Nbins2
        
        %compute normalized distance in each dimension (to the designated
        %bin)
        dists_h1 = (X1-binsX1(i)*ones(size(X1)))/h1;
        dists_h2 = (X2-binsX2(j)*ones(size(X2)))/h2;
        
        %total distance in normalized units
        dists = (dists_h1.^2 + dists_h2.^2).^0.5;
        
        %weights under the Epanechnikov kernel
        weights = 3/4*(1-dists.^2).*(abs(dists)<=1);
        
        binsY(i,j) = (weights'*Y)/sum(weights);
        
    end
end

%binsY = binsY.*isfinite(binsY);

mean_Y = binsY;

%resampling to bootstrap CI

waitmessage = ['bootstrapping ' num2str(resamples) ' times'];
H = waitbar(0,waitmessage);

Nsamples = resamples;

resamples = nan(Nbins1, Nbins2, Nsamples);

for k = 1:Nsamples
    
    rs = ceil(rand(N,1)*N); %vector of random indicies specifying obs to include
    
    %disp(rs)
    
    %subsamples
    X1_rs = X1(rs);
    X2_rs = X2(rs);
    Y_rs = Y(rs);
    
    %disp(X1_rs)
    
    waitbar(k/Nsamples,H);
    
    %estimating the mean for the subsample
    
    for i = 1:Nbins1
        for j = 1:Nbins2

            %compute normalized distance in each dimension (to the designated
            %bin at [i,j])
            dists_h1 = (X1_rs-binsX1(i)*ones(size(X1_rs)))/h1;
            dists_h2 = (X2_rs-binsX2(j)*ones(size(X2_rs)))/h2;
            
            %total distance in normalized units
            dists = (dists_h1.^2 + dists_h2.^2).^0.5;

            %weights under the Epanechnikov kernel
            weights = 3/4*(1-dists.^2).*(abs(dists)<=1);
            
            binsY(i,j) = (weights'*Y_rs)/sum(weights);

        end
    end

    resamples(:,:,k) = binsY;

end

close(H)

sorted_samples = sort(resamples,3,'descend');

CI = cat(3,sorted_samples(:,:,round((1-alpha/2)*Nsamples)),sorted_samples(:,:,round(alpha/2*Nsamples)));

figure
handle = surf(binsX1, binsX2, binsY');
xlabel('X1')
ylabel('X2')
zlabel('Y')
hold on

%plotting CI

for i = 1:Nbins1
    for j = 1:Nbins2
        plot3([binsX1(i) binsX1(i)], [binsX2(j) binsX2(j)], [CI(i,j,1) CI(i,j,2)],'k')

    end
end
            
string = ['Epanechnikov kernal, bandwidth: X1 = ' num2str(h1) ', X2 = ' num2str(h2) ' (' num2str((1-alpha)*100) '% CI)'];
title(string)

results = struct('X1', binsX1, 'X2', binsX2, 'mean', mean_Y, 'CI', CI);
parameters = struct('estimator', 'Nadaraya-Watson', 'kernal','Epanechnikov', 'bandwidth_X1', bandwidth1, 'bandwidth_X2', bandwidth2, 'alpha', alpha,'resamples', Nsamples);
Q = struct('parameters', parameters, 'results',results);




