function [ state, f ] = Reccurency( s, sampleRate, lastState )
%Using reccurence plot
%

r = reccPlot(s);
rr = sum(sum(r < 0.05));

if rr <15500
    state = 1;
else
    state = 0;
end

% rrr = sum(sum(r));
% 
% if rrr > 36000
%     state = 1;
% else
%     state = 0;
% end

%coeff = @(x) 1 - 1/(1+exp(8*(x-0.6)));
%state = sum(sum(r < 0.02 + 0.03*coeff(sqrt(var(s)))));

%state = sum(sum(r < 0.05));
%state = sum(sum(r));

%state = sqrt(var(s));

% if rr < 25000
%     state = 1;
% else
%     state = 0;
% end

% state = sum(sum(r));

end

