function [ state, f ] = Cross( s, sampleRate, lastState )
%Cross 
%

block = s(end - sampleRate + 1:end);
% Compute the std of all but the last block of the group
std_before = sqrt(var( s(1:end-sampleRate) ));
threshold = 0.1*std_before;

% Count the number of threshold crossing
cross_up = block > (std_before + threshold);
cross_down = block < (std_before - threshold);
nbOfCross_up = sum(xor(cross_up(1:end-1), cross_up(2:end)));
nbOfCross_down = sum(xor(cross_down(1:end-1), cross_down(2:end)));

if nbOfCross_up + nbOfCross_down > 1
    state = 1;
else
    state = -1;
end

end

