%% Figures atropine 

clear all;

MouseToDo = 15000; % Change this to process the mouse you want
MouseName{1} = ['M' num2str(MouseToDo)]

GetAtropineMice_CH

%% Spectros and accelero

figure

for i = 3:4
    cd(AtropineSess.(MouseName{1}){1,i})
    clear 'SpectroHLow' 'SpectroBHigh' 'SpectroBLow' 'FreqHLow' 'Sp_tsd_BHigh' 'Sp_tsd_BLow' 'NewMovAcctsd'
    
    SpectroHLow = load('H_Low_Spectrum.mat');
    SpectroBHigh = load('B_High_Spectrum.mat');
    SpectroBLow = load('B_Low_Spectrum.mat');
    load('behavResources.mat', 'MovAcctsd')
    load('StateEpochSB.mat', 'smooth_ghi')
    load('behavResources_SB.mat')
    
    FreqHLow = SpectroHLow.Spectro{3};
    FreqBHigh = SpectroBHigh.Spectro{3};
    FreqBLow = SpectroBLow.Spectro{3};
    
    
    Sp_tsd_Hlow = tsd(SpectroHLow.Spectro{2}*1e4 , SpectroHLow.Spectro{1});
    Sp_tsd_BHigh = tsd(SpectroBHigh.Spectro{2}*1e4 , SpectroBHigh.Spectro{1});
    Sp_tsd_BLow = tsd(SpectroBLow.Spectro{2}*1e4 , SpectroBLow.Spectro{1});
    
    smootime = 1
    NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd) , ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));
    SmoothGamma=tsd(Range(smooth_ghi),runmean(Data(smooth_ghi), ceil(smootime/median(diff(Range(smooth_ghi,'s'))))));
    
    
    % figure
    subplot(331);
    plot(FreqHLow, mean(Data(Sp_tsd_Hlow)));
    legend('Pre','Post');
    makepretty
    hold on
    title 'Mean Spectrum HPC Low';
    
    subplot(332);
    plot(FreqBHigh, mean(Data(Sp_tsd_BHigh)));
    legend('Pre','Post');
    makepretty
    hold on
    title 'Mean Spectrum Bulb High';
    
    subplot(333);
    plot(FreqBLow, mean(Data(Sp_tsd_BLow)));
    legend('Pre','Post');
    makepretty
    hold on
    title 'Mean Spectrum Bulb Low';
    
    subplot(312);
    plot(Range(SmoothGamma,'s')/60 , log10(Data(SmoothGamma))), xlim([0 15])
    legend('Pre','Post');
    makepretty
    hold on
    title('Bulb gamma power')
    
    subplot(313);
    plot(Range(NewMovAcctsd,'s')/60 , log10(Data(NewMovAcctsd)))
    xlim([0 15])
    % hline(Params.Accelero_thresh)
    legend('Pre','Post');
    xlabel('Time (minutes)')
    makepretty
    title('accelero')
    hold on
    
end
subplot(313);
hline(Params.Accelero_thresh,'--r')

A=mtitle(['OF ' num2str(MouseName{1})]); A.FontSize=20; A.FontWeight='bold';



