%  methode utilisation xcorr----------------------------------------------                        
%  petit programme pour comprendre la methode----------------------------- 
% ------------------------------------------------------------------------
                        
                        
AmpNoisett=0;                           % try with different value of AmpNoisett (from 1 to 20)
dela=10;                                % try with different delays (en sec), default: 10s
freqtt=1;                               % sampling frequency (en Hz) au minimum 2x sup à la freqce max du signal
freqSinusoidtt=0.01;                    % frequency of the sinusoid (en Hz),  default: 0.01Hz
periodSinusoidtt=1/freqSinusoidtt;      % period of the sinusoid (en sec),    default: 100s

ttt=[1:1000];                           
Ftt=sin(2*pi*ttt*freqSinusoidtt)+AmpNoisett*randn(1,1000)/2;        % sin(2*pi*ttt*freqSinusoidtt)=0 à chaque fois que ttt=n/freqSinusoid
Ytt=sin((ttt-dela)*2*pi*freqSinusoidtt)+AmpNoisett*randn(1,1000)/2;
figure('Color',[1 1 1])
subplot(2,1,1), plotyy(ttt,Ftt,ttt,Ytt)
title(['Ft bleu, Yt vert,   Frequency ',num2str(freqSinusoidtt),'Hz,  Yt follows Ft with delay (',num2str(dela),' sec)'])
[Ctt,lagtt,Ptt,CPMtt,CPmtt] = StatsXcorr(Ftt,Ytt,freqtt,100); % ref: F= field
subplot(2,1,2),  hold on
plot(lagtt,CPmtt,'Color',[0.4 0.4 0.4],'linewidth',2)
plot(lagtt,CPMtt,'Color',[0.4 0.4 0.4],'linewidth',2)
plot(lagtt,Ctt,'k','linewidth',2)
yltt=ylim;
hold on, line([0 0],[yltt(1) yltt(2)],'Color','r')
title(['Ft reference, Ratio noise/signal:',num2str(AmpNoisett)])
xlim([-200 200])
