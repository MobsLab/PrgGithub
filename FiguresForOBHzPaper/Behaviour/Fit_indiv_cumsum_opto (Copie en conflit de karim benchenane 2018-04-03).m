%29.11.2017
clear all
cd  /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch')

load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer')
maxlength=100;
pas=2;
n=4;
figure('Position',[ 88         537        1618         400])
Xlabels={'2 CS+ no laser'; '2 CS+ +laser'; '4 CS+ +laser'; '4 CS+ +laser'; };
NbEp_gfp=nan(length(gfpmice),4);
NbEp_ch=nan(length(chr2mice),4);
MeanDurEp_gfp=nan(length(gfpmice),4);
MeanDurEp_ch=nan(length(chr2mice),4);
for k=0:3
    
    eval([ 'EPOI= CspluPer' num2str(k) ';']);
    a=1;
    for man=1:length(gfpmice)
        Ep=bilanFreezeAccEpoch{gfpmice(man)};
        EpisodeDur=End(and(Ep, EPOI))-Start(and(Ep, EPOI));
        EpisodeDurAllmice_gfp{k+1,man}= EpisodeDur/1e4;
    end
    
    
    for man=1:length(chr2mice)
        
        Ep=bilanFreezeAccEpoch{chr2mice(man)};
        EpisodeDur=End(and(Ep, EPOI))-Start(and(Ep, EPOI));
        EpisodeDurAllmice_ch{k+1,man}=EpisodeDur/1e4;
        
    end
end

clf
Xlabels={'2 CS+ no laser'; '2 CS+ +laser'; '4 CS+ +laser'; '4 CS+ +laser'; };
for k=0:3
    subplot(1,4,k+1)
    for mm=1:size(EpisodeDurAllmice_gfp,2)
        [Y,X]=hist(EpisodeDurAllmice_gfp{k+1,mm},[0:2:100]);
        Y=cumsum(Y)/sum(Y);
        [fitresult, gof] = createExpFit_FreezingTimes(X, Y,0);
        GFP_Fit(k+1,mm)=coeffvalues(fitresult);
        GFP_FitQual(k+1,mm)=(gof.rsquare);
        plot(X,Y,'k','linewidth',2), hold on
    end
    
    for mm=1:size(EpisodeDurAllmice_ch,2)
        [Y,X]=hist(EpisodeDurAllmice_ch{k+1,mm},[0:2:100]);
        Y=cumsum(Y)/sum(Y);
        [fitresult, gof] = createExpFit_FreezingTimes(X, Y,0);
        CHR_Fit(k+1,mm)=coeffvalues(fitresult);
        CHR_FitQual(k+1,mm)=(gof.rsquare);
        plot(X,Y,'b','linewidth',2), hold on
    end
    
    xlabel(Xlabels{k+1})
end

figure
[p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({GFP_Fit',CHR_Fit'},'Fit',{'k','b'},'ranksum',1,1,1);
