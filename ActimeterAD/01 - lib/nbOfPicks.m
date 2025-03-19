function [ state, f ] = nbOfPicks( s, sampleRate )
%nbOfPicks
%

%s = s(end - sampleRate + 1:end);
t = pickDetector(s, 50);
state = length(t);


end

