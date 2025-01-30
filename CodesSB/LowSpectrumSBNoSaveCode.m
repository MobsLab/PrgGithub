function Spectro=LowSpectrumSBNoSaveCode(LFP,whiten)

try whiten; catch, whiten=0; end
% modified to whiten signal if asked to

if whiten
[y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
LFP=tsd(Range(LFP),y);
end

% Below is a modification from Juliy 2017, to harmonize codes in the lab, only change is that params.fpass=[0 20] become params.fpass=[0.1 20];
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

disp('... Calculating spectrogramm.');

[Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);

Spectro={Sp,t,f};


end