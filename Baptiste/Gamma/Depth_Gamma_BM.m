
mkdir SpectrumData_BM

for chan_num=[18:22]
    
    MiddleSpectrum_BM([cd filesep],chan_num,'B')
    movefile('B_Middle_Spectrum.mat' , ['B_Middle_Spectrum_' num2str(chan_num) '.mat'])
    movefile(['B_Middle_Spectrum_' num2str(chan_num) '.mat'] , 'SpectrumData_BM')
    
end



%%

cd('/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130416/BULB-Mouse-61-16042013/')
cd('/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130416/BULB-Mouse-61-16042013/SpectrumData_BM')

cd('/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M730')
cd('/media/DataMOBsRAIDN/ProjetSlSc/C3H&DBA/M730/SpectrumData_BM')

load('SleepScoring_OBGamma.mat')

%[10 13 2 1 0 4 3 15 9 14 11 12]
for  chan_num=[17:22]
    try
        load(['B_Middle_Spectrum_' num2str(chan_num) '.mat'])
        Sptsd{chan_num}=tsd(Spectro{2}*1e4 , Spectro{1});
        Sptsd_Wake{chan_num} = Restrict(Sptsd{chan_num} , Wake);
        Sptsd_NREM{chan_num} = Restrict(Sptsd{chan_num} , SWSEpoch);
        Sptsd_REM{chan_num} = Restrict(Sptsd{chan_num} , REMEpoch);
    end
end


% Mean spectrum
figure

n=1;
for  chan_num=[17:22]
    try
        subplot(2,3,n)
        plot(Spectro{3} , nanmean(Data(Sptsd_Wake{chan_num})),'b')
        hold on
        plot(Spectro{3} , nanmean(Data(Sptsd_NREM{chan_num})),'r')
        plot(Spectro{3} , nanmean(Data(Sptsd_REM{chan_num})),'g')
        
        if n==1; legend('Wake','NREM','REM'); end
        makepretty
        ylim([0 1.5e4])
        
        title(num2str(chan_num))
        set(gca,'yscale','log')
        
        n=n+1;
    end
end

ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')


