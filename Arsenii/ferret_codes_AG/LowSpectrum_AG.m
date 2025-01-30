function LowSpectrum_AG(filename, ch, struc, imouse, Dir)

if filename(end) ~= filesep
    filename = [filename filesep];
end

if isnumeric(ch) % added by SB to allow loading of LFP files that are not single channels - for example local act
    load([Dir.path{imouse}{1}, strcat('LFPData\LFP', num2str(ch),'.mat')]);
else
    load([Dir.path{imouse}{1}, strcat('LFPData\', ch,'.mat')]);
end


% Below is a modification from Juliy 2017, to harmonize codes in the lab, only change is that params.fpass = [0 20] become params. fpass = [0.1 20];
[params, movingwin, suffix] = SpectrumParametersBM('low'); % low or high

disp('...calculating spectrogramm.');

if ~isempty(strcmp(filename, 'ProjetAversion'))
    Breath = LFP;
end

[Sp,t,f] = mtspecgramc(Data(LFP), movingwin, params);

Spectro = {Sp,t,f};
save([strcat([filename, struc,'_Low_Spectrum.mat'])],'Spectro','ch','-v7.3')

end