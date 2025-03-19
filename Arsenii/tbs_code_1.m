
Spectro{2} = linspace(1.5,3.6027e3,27006);
27006



LFP_norm = Data(LFP)-nanmean(Data(LFP));


[params,movingwin,suffix]=SpectrumParametersBM('low'); % low or high

[Sp,t,f]=mtspecgramc(LFP_norm,movingwin,params);

Spectro={Sp,t,f};
save(strcat([pwd,'B_Low_Spectrum.mat']),'Spectro','ch','-v7.3')




