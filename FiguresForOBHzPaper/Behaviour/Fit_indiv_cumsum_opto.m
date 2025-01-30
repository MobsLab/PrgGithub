%29.11.2017
clear all
cd  /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
res=pwd;
load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch')

load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer')
sav=1;
maxlength=100;
pas=2;
n=4;
colori={[0 0 0]; [0 0.7 1]};
h_CM=figure('Position',[ 88         537        1618         400]);
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

for k=0:1
    
    CM_allgfp{k+1}=nan(length(gfpmice),length([0:2:100]));
    CM_allch{k+1}=nan(length(gfpmice),length([0:2:100]));
    subplot(1,2,k+1)
    for mm=1:size(EpisodeDurAllmice_gfp,2)
        [Y,X]=hist(EpisodeDurAllmice_gfp{k+1,mm},[0:2:100]);
        Y=cumsum(Y)/sum(Y);
        CM_allgfp{k+1}(mm,:)=Y;
        [fitresult, gof] = createExpFit_FreezingTimes(X, Y,0);
        GFP_Fit(k+1,mm)=coeffvalues(fitresult);
        GFP_FitQual(k+1,mm)=(gof.rsquare);
        plot(X,Y*100,'Color',colori{1},'linewidth',0.3), hold on
    end
    
    for mm=1:size(EpisodeDurAllmice_ch,2)
        [Y,X]=hist(EpisodeDurAllmice_ch{k+1,mm},[0:2:100]);
        Y=cumsum(Y)/sum(Y);
        CM_allch{k+1}(mm,:)=Y;
        [fitresult, gof] = createExpFit_FreezingTimes(X, Y,0);
        CHR_Fit(k+1,mm)=coeffvalues(fitresult);
        CHR_FitQual(k+1,mm)=(gof.rsquare);
        plot(X,Y*100,'Color',colori{2},'linewidth',0.3), hold on
    end
    
    xlabel(Xlabels{k+1})
end

for man=1:length(gfpmice)

end
h_Fit=figure;
[p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({1./GFP_Fit([1 2],:)',1./CHR_Fit([1 2],:)'},'Fit',colori,'ranksum',1,1,1);
h_FitQual=figure;
[p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({GFP_FitQual([1 2],:)',CHR_FitQual([1 2],:)'},'Fit',colori,'ranksum',1,1,1);

if sav
    saveas(h_Fit.Number,['EpLengthCumSum_fit.fig'])
    saveFigure(h_Fit.Number,['EpLengthCumSum_fit' ],res)

end

figure(h_CM.Number);
for k=1:2
    subplot(1,2,k), hold on
    plot(X,nanmean(CM_allgfp{k}*100),'Color',colori{1},'LineWidth',3)
    plot(X,nanmean(CM_allch{k}*100),'Color',colori{2},'LineWidth',3)
    xlim([0 80])
    box off
    box off
end

if sav
    saveas(h_CM.Number,['EpLengthCumSum_indiv.fig'])
    saveFigure(h_CM.Number,['EpLengthCumSum_indiv' ],res)

end