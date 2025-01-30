%%CountCoincidenceIntervals
% 12.03.2018 KJ
%
% Give the number of intervals overlapping or almost 
%
% [nb_overlap, nb1_alone, nb2_alone] = CountCoincidenceIntervals(interval1, interval2, margin)
%
%% INPUTS
%   
%   intv1:          interval1
%   intv2:          interval2
%   margin_intv:    margin in ts (10-4s)
% 
% 
%   see 
%       
%


function [nb_overlap, nb1_alone, nb2_alone] = CountCoincidenceIntervals(interval1, interval2, margin_intv)

% init
if nargin < 2
  error('Incorrect number of parameters.');
elseif nargin==2
    margin_intv = 0;
end

%inputs
evt1_tmp = (Start(interval1) + End(interval1))/2;
larger_intv2 = [Start(interval2)-margin_intv, End(interval2)+margin_intv];
%intersect
[status, ~, ~] = InIntervals(evt1_tmp,larger_intv2);

% count
nb_overlap = sum(status);
nb1_alone  = length(evt1_tmp) - nb_overlap;
nb2_alone  = length(Start(interval2)) - nb_overlap;
    
end