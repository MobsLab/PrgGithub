function [ state, f ] = Ampl( s, sampleRate )
%Ampl
%

sd = sqrt(var(s));

extra_before = sum(s(1:end-sampleRate) > sd);
extra_last = sum(s(end-sampleRate+1:end) > sd);

if 3*extra_last > extra_before
    state = 1;
else
    state = -1;
end


end

