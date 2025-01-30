function [tEpoch, SpEpoch ,numF]=SpectroEpochML(Spi,ti,fi,epoch,plo)
 
% SpectroEpochML
%
% inputs :
% [Spi,ti,fi] = outputs argument of the function mtspecgramc
% epoch = intervalSet of the epoch on which the spetrogram should be restricted
% plo = 1 if display is wanted, 0 otherwise
%
% outputs
% tEpoch= time vector of restricted spectro
% SpEpoch = power matrix for each time and frequency, restricted to epoch.
% numF = figure number if plo=1

%% initialisation
try
    Start(epoch); 
catch
    error('epoch needs to be an intervalSet');
end

if isequal([length(ti),length(fi)],size(Spi))==0, 
    error('check arguments: [Spi,ti,fi] are not consistent...');
end

if exist('plo','var')==0, 
    plo=0;
end


%% compute
Ttemp=ts(ti*1E4);
t=Range(Restrict(Ttemp,epoch),'s');
Ii=ismember(floor(ti'*1E4),floor(t*1E4));
ratio=length(ti)/(max(ti)-min(ti));

tEpoch=[1:length(t)]/ratio;
SpEpoch=Spi(Ii,:);



%% display figure
if plo
    figure('Color',[1 1 1]),  numF=gcf;
    subplot(1,2,1),
    imagesc(tEpoch,fi,10*log10(SpEpoch)'); axis xy;
    ylabel('frequency (Hz)') ; xlabel('time (s)') ;
    title('Spectrum restricted to given epoch')
    
    subplot(1,2,2),
    plot(fi,mean(SpEpoch,1), 'linewidth',2)
    xlabel('frequency (Hz)')
    ylabel('signal power');
    title('Power frequency spectrum')
else
    numF=nan;
end