function A_resampled=ResampleTSD(A,F)

% function A_resampled=ResampleTSD(A,F);
% 
% inputs:
% A = tsd
% F = sampling frequency (Hz) required for A_resampled
%
% outputs:
% A_resampled = tsd with sampling frequency at F

%% initialization

if ~exist('A','var') || ~exist('F','var')
    error('Missing input arguments')
end
    
try 
    Range(A);
catch
    error('first input must be a tsd')
end


%% resample

F_A=round(1/mean(diff(Range(A,'s'))));


if mean(diff(Range(A,'s')))/var(diff(Range(A,'s')))<1E4
    disp('WARNING: sampling is not regular! consider another function to resample!!')
end

Rg_A=Range(A);

Dt_A_resampled=resample(Data(A),F,F_A);
Rg_A_resampled=Rg_A(1):(Rg_A(end)-Rg_A(1))/(length(Dt_A_resampled)-1):Rg_A(end);

%% recreate new tsd

A_resampled=tsd(Rg_A_resampled,Dt_A_resampled);
