
function FindInjectionTime_BM

load('SleepScoring_OBGamma.mat', 'Epoch_Drugs')
if 1%~exist('Epoch_Drugs')
    
    figure
    
    load('H_Low_Spectrum.mat')
    
    subplot(311)
    imagesc(Spectro{2} , Spectro{3} , log10(Spectro{1})'), axis xy, %caxis([0 4e4])
    xlim([max(Spectro{2})*.3 max(Spectro{2})*.7])
    
%         load('B_High_Spectrum.mat')
%     
%     subplot(312)
%     imagesc(Spectro{2} , Spectro{3} , log10(Spectro{1})'), axis xy, %caxis([0 4e4])
%     xlim([max(Spectro{2})*.3 max(Spectro{2})*.7])
%     
    load('behavResources.mat', 'MovAcctsd')
    
    subplot(313)
    plot(Range(MovAcctsd,'s') , runmean(Data(MovAcctsd),30))
    xlim([max(Spectro{2})*.3 max(Spectro{2})*.7])
    
    disp('Please put start and stop noise linked with unplugging mice for injection')
    [X,Y]=(ginput(2));
    
    start = X(1);
    stop = X(2);
    
    Epoch_Drugs{1} = intervalSet(0 , start*1e4); % before injection
    Epoch_Drugs{2} = intervalSet(stop*1e4 , stop*1e4+3600e4); % just after injection
    Epoch_Drugs{3} = intervalSet(stop*1e4+3600e4 , max(Spectro{2})*1e4); % long after injection
    
    save('SleepScoring_OBGamma.mat','Epoch_Drugs','-append')
    
    close
    
else
    disp('Injection time already found')
end

