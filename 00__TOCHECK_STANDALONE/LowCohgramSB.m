function LowCohgramSB(filename,ch1,struc1,ch2,struc2)

% whitening was removed on 14/05/2018
if isnan(ch1)|isnan(ch2)
   return 
end

if isnumeric(ch1) % added by SB to allow loading of LFP files that are not single channels - for example local act
    load(strcat('LFPData/LFP',num2str(ch1),'.mat'));
    LFP1=LFP;
else
    load(strcat('LFPData/',ch1,'.mat'));
    LFP1=LFP;
end



if isnumeric(ch2) % added by SB to allow loading of LFP files that are not single channels - for example local act
    load(strcat('LFPData/LFP',num2str(ch2),'.mat'));
    LFP2 = LFP;
else
    load(strcat('LFPData/',ch2,'.mat'));
    LFP2=LFP;
end

% if whiten
%     [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
%     LFP2=tsd(Range(LFP),y);
% else
%     LFP2=LFP;
% end


% Below is a modification from Juliy 2017, to harmonize codes in the lab, only change is that params.fpass=[0 20] become params.fpass=[0.1 20];
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high

disp('... Calculating coherence.');


[C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1),Data(LFP2),movingwin,params);

Coherence={C,t,f};
SingleSpectro.ch1={S1,t,f};
SingleSpectro.ch2={S2,t,f};
CrossSpectro={S12,t,f};
save(strcat(filename,struc1,'_',struc2,'_Low_Coherence.mat'),'Coherence','SingleSpectro','CrossSpectro','ch1','ch2','phi','confC','-v7.3')

end