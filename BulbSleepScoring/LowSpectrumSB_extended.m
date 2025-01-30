function LowSpectrumSB_extended(filename,ch,struc,whiten)

if filename(end)==filesep
    
else
    filename = [filename filesep];
end

try whiten; catch, whiten=0; end
% modified to whiten signal if asked to
if isnumeric(ch) % added by SB to allow loading of LFP files that are not single channels - for example local act
    load(strcat('LFPData/LFP',num2str(ch),'.mat'));
else
    load(strcat('LFPData/',ch,'.mat'));
end

if whiten
[y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
LFP=tsd(Range(LFP),y);
end


% Below is a modification from Juliy 2017, to harmonize codes in the lab, only change is that params.fpass=[0 20] become params.fpass=[0.1 20];
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

disp('... Calculating spectrogramm.');

if ~isempty(strcmp(filename, 'ProjetAversion'))
    Breath=LFP;
end

[Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
params.fpass = [0.1 40];

Spectro={Sp,t,f};
save(strcat(filename,struc,'_LowExt_Spectrum.mat'),'Spectro','ch','-v7.3')

end