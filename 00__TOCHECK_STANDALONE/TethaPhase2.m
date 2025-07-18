function [ph, thpeaks] = ThetaPhase2(S, CRtheta)
% ph = ThetaPhase(S, CRtheta, ThStart, ThEnd)
%
% Computes the theta phase of each spike for a group of cells 
%
% INPUTS:
% S:              cell array of ts objects containing the spike trains
% CRtheta:        EEG tsd object filtered for theta
% ThStart, Thend: arrays containig the start and stop times of the valid
%                 theta epochs
%
% OUTPUTS: 
% ph:             cell array of tsd abjects containing the phase of each
%                 spike in S and the theta cycle number

% batta 2000
% status: alpha

try 
    
    S{1};


dth = diff(Data(CRtheta));

dth1 = [0 dth'];
dth2 = [dth' 0];
clear dth;

t = Range(CRtheta, 'ts');

thpeaks = t(find (dth1 > 0 & dth2 < 0));

ep = timeSpan(CRtheta);
ThStart = Start(ep);
ThEnd = End(ep);
clear t;


for iC = 1:length(S)
  s = Data(Restrict(S{iC}, ThStart, ThEnd));
  ph{iC} = zeros(size(s));
  pks = zeros(size(s));
  for j = 1:length(s)
    pk = binsearch_floor(thpeaks, s(j));
    ph{iC}(j) = (s(j) - thpeaks(pk)) / (thpeaks(pk+1) - thpeaks(pk));
    pks(j) = pk;
   % if any(ph{iC} > 1 ) 
    %    keyboard
    %end
    
  end

  ph{iC} = tsd(s, [ph{iC} pks]);
end


catch

dth = diff(Data(CRtheta));

dth1 = [0 dth'];
dth2 = [dth' 0];
clear dth;

%t = Range(CRtheta, 'ts');
t = Range(CRtheta);

thpeaks = t(find (dth1 > 0 & dth2 < 0));

ep = TimeSpan(CRtheta);
ThStart = Start(ep);
ThEnd = End(ep);
clear t;

%  keyboard

%  for iC = 1:length(S)
  s = Data(Restrict(S, ThStart, ThEnd));
  ph = zeros(size(s));
  pks = zeros(size(s));
  for j = 1:length(s)
    pk = binsearch_floor(thpeaks, s(j));
    ph(j) = (s(j) - thpeaks(pk)) / (thpeaks(pk+1) - thpeaks(pk));
    pks(j) = pk;
   % if any(ph{iC} > 1 ) 
    %    keyboard
    %end
    
  end

  ph = tsd(s, [ph pks]);
%  end

end