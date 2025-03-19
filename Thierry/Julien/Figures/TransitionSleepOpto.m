function [Mat,tps]=TransitionSleepOpto(Spectro,StimTime,freq,LimTime,StimTimeREM) 
% MATRICE OÙ CHAQUE LIGNE CORRESPOND AU SPECTRE EN PUISSANCE D'UNE STIM 
%Spectro
%StimeTime = events
%freq = borne de frequence regardée 
%LimTime = temps avant et après (définir fenêtre en seconde)
%StimTimeREM = redéfinir le temps de l'évènement

opt=0;


if length(freq)>2

    fq=find(Spectro{3}>freq(1)&Spectro{3}<freq(2)); 
    fq2=find(Spectro{3}>freq(3)&Spectro{3}<freq(4));
     thetaPower=10*log10(mean(Spectro{1}(:,fq),2))./(10*log10(mean(Spectro{1}(:,fq2),2)));
     vv=tsd(Spectro{2}*1E4,thetaPower);
else
    
  fq=find(Spectro{3}>freq(1)&Spectro{3}<freq(2)); 
  thetaPower=10*log10(mean(Spectro{1}(:,fq),2));
  vv=tsd(Spectro{2}*1E4,thetaPower);
end


if opt==0

figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(StimTime), -LimTime*1E4, LimTime*1E4,'BinSize',1000);

else

figure, [fh, rasterAx, histAx, matVal] = ImagePETH(vv, ts(StimTime), -LimTime*1E4, LimTime*1E4,'BinSize',1000,'Markers',ts(StimTimeREM));

end


Mat=Data(matVal)';
tps=Range(matVal,'s');