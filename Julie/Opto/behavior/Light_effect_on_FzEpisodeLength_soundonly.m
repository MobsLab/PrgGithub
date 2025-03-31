%29.11.2017

cd  /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
res=pwd;
% load(['EXT-24_fullperiod_close2sound_acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanMovAccSmotsd','bilanFreezeAccEpoch',...
%     'csm','csp','CSplInt','CSmiInt')
FullPerClo2sound=load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer','csm','csp','CSplInt','CSmiInt');

SoundOnly=load(['EXT-24_soundonly__acc2'], 'bilan','gfpmice','chr2mice','StepName', 'Dir','period','bilanMovAccSmotsd','optionfullper','bilanFreezeAccEpoch',...
    'csm','csp','CSplInt','CSmiInt');
% load('EXT-24_fullperiod_close2sound_acc_epochs','CsminPer','CspluPer0','CspluPer1','CspluPer2','CspluPer3','NosoundNoLaserPer','NosoundWithLaserPer','csm','csp','CSplInt','CSmiInt')
bilan=SoundOnly.bilan;
gfpmice=SoundOnly.gfpmice;
chr2mice=SoundOnly.chr2mice;
bilanMovAccSmotsd=SoundOnly.bilanMovAccSmotsd;
bilanFreezeAccEpoch=SoundOnly.bilanFreezeAccEpoch;
chr2mice=SoundOnly.chr2mice;
SoundOnly.CsminPer=intervalSet(Start(subset(SoundOnly.CSmiInt,[1:4])),Start(subset(SoundOnly.CSmiInt,[1:4]))+30*1e4) ;
SoundOnly.CspluPer0=intervalSet(Start(subset(SoundOnly.CSplInt,[1:2])),Start(subset(SoundOnly.CSplInt,[1:2]))+30*1e4) ;%=subset(CSplInt,[1:2]); ne fonctionne pas
SoundOnly.CspluPer1=intervalSet(Start(subset(SoundOnly.CSplInt,[3:4])),Start(subset(SoundOnly.CSplInt,[3:4]))+30*1e4) ;%=subset(CSplInt,[3:4]);       
SoundOnly.CspluPer2=intervalSet(Start(subset(SoundOnly.CSplInt,[5:8])),Start(subset(SoundOnly.CSplInt,[5:8]))+30*1e4) ;%=subset(CSplInt,[5:8]);
SoundOnly.CspluPer3=intervalSet(Start(subset(SoundOnly.CSplInt,[9:12])),Start(subset(SoundOnly.CSplInt,[9:12]))+30*1e4) ;%=subset(CSplInt,[9:12]);
% 
% CsminPer=SoundOnly.CsminPer;
% CspluPer0=SoundOnly.CspluPer0;
% CspluPer1=SoundOnly.CspluPer1;
% CspluPer2=SoundOnly.CspluPer2;
% CspluPer3=SoundOnly.CspluPer3;

CsminPer=FullPerClo2sound.CsminPer-SoundOnly.CsminPer;
CspluPer0=FullPerClo2sound.CspluPer0-SoundOnly.CspluPer0;
CspluPer1=FullPerClo2sound.CspluPer1-SoundOnly.CspluPer1;
CspluPer2=FullPerClo2sound.CspluPer2-SoundOnly.CspluPer2;
CspluPer3=FullPerClo2sound.CspluPer3-SoundOnly.CspluPer3;
if 0
figure; 
line([Start(SoundOnly.CSmiInt) End(SoundOnly.CSmiInt)],[2 2],'Color','k')
line([Start(SoundOnly.CSplInt) End(SoundOnly.CSplInt)],[2 2],'Color','b')

figure,  hold on,
line([Start(FullPerClo2sound.CsminPer) End(FullPerClo2sound.CsminPer)],[1 1],'Color','b')
line([Start(SoundOnly.CsminPer) End(SoundOnly.CsminPer)],[2 2],'Color','b')
line([Start(CsminPer) End(CsminPer)],[3 3],'Color','b')

line([Start(FullPerClo2sound.CspluPer0) End(FullPerClo2sound.CspluPer0)],[1 1],'Color','k')
line([Start(subset(SoundOnly.CspluPer0,1)) End(subset(SoundOnly.CspluPer0,1))],[2 2],'Color','k')
line([Start(subset(SoundOnly.CspluPer0,2)) End(subset(SoundOnly.CspluPer0,2))],[2 2],'Color','k')
line([Start(subset(CspluPer0,1)) End(subset(CspluPer0,1))],[3 3],'Color','k')
line([Start(subset(CspluPer0,2)) End(subset(CspluPer0,2))],[3 3],'Color','k')

line([Start(FullPerClo2sound.CspluPer1) End(FullPerClo2sound.CspluPer1)],[1 1],'Color','c')
line([Start(subset(SoundOnly.CspluPer1,1)) End(subset(SoundOnly.CspluPer1,1))],[2 2],'Color','c')
line([Start(subset(SoundOnly.CspluPer1,2)) End(subset(SoundOnly.CspluPer1,2))],[2 2],'Color','c')
line([Start(subset(CspluPer1,1)) End(subset(CspluPer1,1))],[3 3],'Color','c')
line([Start(subset(CspluPer1,2)) End(subset(CspluPer1,2))],[3 3],'Color','c')

line([Start(FullPerClo2sound.CspluPer2) End(FullPerClo2sound.CspluPer2)],[1 1],'Color',[0.5 0.5 0.5])
line([Start(SoundOnly.CspluPer2) End(SoundOnly.CspluPer2)],[2 2],'Color',[0.5 0.5 0.5])
line([Start(CspluPer2) End(CspluPer2)],[3 3],'Color',[0.5 0.5 0.5])

line([Start(FullPerClo2sound.CspluPer3) End(FullPerClo2sound.CspluPer3)],[1 1],'Color',[0.7 0.7 0.7])
line([Start(SoundOnly.CspluPer3) End(SoundOnly.CspluPer3)],[2 2],'Color',[0.7 0.7 0.7])
line([Start(CspluPer3) End(CspluPer3)],[3 3],'Color',[0.7 0.7 0.7])

title('1: full per 2: sound only 3: remaining')
ylim([0 10])
end
sav=0;
colori={[0 0 0]; [0 0.7 1]};
col_OI=[1:4];
%% distribution
% if 1
maxlength=100;
pas=2;
EpisodeDurAllmice_gfp=[];
n=4;
h_cumsum=figure('Position',[ 88         537        1618         400]);
Xlabels={'2 CS+ no laser'; '2 CS+ +laser'; '4 CS+ +laser'; '4 CS+ +laser'; };
NbEp_gfp=nan(length(gfpmice),4);
NbEp_ch=nan(length(chr2mice),4);
MeanDurEp_gfp=nan(length(gfpmice),4);
MeanDurEp_ch=nan(length(chr2mice),4);
EpAboveTh_gfp=nan(length(gfpmice),4);
EpAboveTh_ch=nan(length(chr2mice),4);
PropEpAboveTh_gfp=nan(length(gfpmice),4);
PropEpAboveTh_ch=nan(length(chr2mice),4);
DurTh=20;
for k=0:3
    
    eval([ 'EPOI= CspluPer' num2str(k) ';']);
    
    subplot(1,4,k+1)
    a=1;
    for man=gfpmice
        Ep=bilanFreezeAccEpoch{man};
        EpisodeDur=End(and(Ep, EPOI))-Start(and(Ep, EPOI));
        EpisodeDurAllmice_gfp=[EpisodeDurAllmice_gfp; EpisodeDur];
        MeanDurEp_gfp(a,k+1)=mean(EpisodeDur);
        NbEp_gfp(a,k+1)=length(EpisodeDur);
        EpAboveTh_gfp(a,k+1)=sum(EpisodeDur>DurTh*1E4);
        PropEpAboveTh_gfp(a,k+1)=sum(EpisodeDur>DurTh*1E4)/length(EpisodeDur);
        a=a+1;
    end
    
    [n1_gfp, xout]=hist (EpisodeDurAllmice_gfp*1E-4,[1:pas:maxlength]);
    
    
    plot(xout, cumsum(n1_gfp)./sum(n1_gfp),'Color',colori{1})
    % plot(xout, n1_gfp)
    % plot(xout, n1_gfp./sum(n1_gfp))
    NbEp(k+1,1)=sum(n1_gfp);
    
    
    EpisodeDurAllmice_ch=[];
    a=1;
    for man=chr2mice
        
        Ep=bilanFreezeAccEpoch{man};
        EpisodeDur=End(and(Ep, EPOI))-Start(and(Ep, EPOI));
        EpisodeDurAllmice_ch=[EpisodeDurAllmice_ch; EpisodeDur];
        
        MeanDurEp_ch(a,k+1)=mean(EpisodeDur);
        NbEp_ch(a,k+1)=length(EpisodeDur);
        EpAboveTh_ch(a,k+1)=sum(EpisodeDur>DurTh*1E4);
        PropEpAboveTh_ch(a,k+1)=sum(EpisodeDur>DurTh*1E4)/length(EpisodeDur);
        clear EpisodeDur
        a=a+1;
    end
    
    [n1_ch, xout]=hist (EpisodeDurAllmice_ch*1E-4,[1:pas:maxlength]);
    hold on
    plot(xout, cumsum(n1_ch)./sum(n1_ch),'Color',colori{2})
    % plot(xout, n1_ch)
    % plot(xout, n1_ch./sum(n1_ch))
    % plotSpread({EpisodeDurAllmice_gfp,EpisodeDurAllmice_ch},'showMM',4)
    
    % [p,h,stats]=ranksum(EpisodeDurAllmice_gfp,EpisodeDurAllmice_ch)
    % text(0.8,0.8, num2str(p),'units','normalized')
    
    title(['nb: gfp  ' num2str(sum(n1_gfp)) ' chr2  ' num2str(sum(n1_ch))])
    if k==0, legend('gfp','chr2'),end
    YL=ylim;
    plot([DurTh DurTh],[0 YL(2)],':k')
    xlabel(Xlabels{k+1})
    NbEp(k+1,2)=sum(n1_ch);
    if k==0, ylabel('proba'), end
    xlim([0 80])
end
if sav
    saveas(h_cumsum.Number,['EpLengthCumSum' num2str(DurTh) '.fig'])
    saveFigure(h_cumsum.Number,['EpLengthCumSum' num2str(DurTh) ],res)
end
%% Nb and prop of episodes above 20sec
h_abov=figure('Position',[   126   549   431   364]); ; 
% [p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({EpAboveTh_gfp(:,[1,2]),EpAboveTh_ch(:,[1,2])},['nb Episodes above ' num2str(DurTh)],colori,'ranksum',1,1,1);
[p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({EpAboveTh_gfp(:,:),EpAboveTh_ch(:,:)},['nb Episodes above ' num2str(DurTh)],colori,'ranksum',1,1,1);
if sav
    saveas(h_abov.Number,['NbEpisodesAbove' num2str(DurTh) '.fig'])
    saveFigure(h_abov.Number,['NbEpisodesAbove' num2str(DurTh) ],res)
end
h_propabov=figure('Position',[   126   549   431   364]); ; 
% [p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({PropEpAboveTh_gfp(:,[1,2]),PropEpAboveTh_ch(:,[1,2])},['Prop Episodes above ' num2str(DurTh)],colori,'ranksum',1,1,1);
[p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({PropEpAboveTh_gfp(:,:),PropEpAboveTh_ch(:,:)},['Prop Episodes above ' num2str(DurTh)],colori,'ranksum',1,1,1);
if sav
    saveas(h_propabov.Number,['PropEpisodesAbove' num2str(DurTh) '.fig'])
    saveFigure(h_propabov.Number,['PropNbEpisodesAbove' num2str(DurTh) ],res)
end
 
%% Figure article
figure('Position',[682   502   301   420]) % no light
bar(1,nanmean(PropEpAboveTh_gfp(:,1)*100),'FaceColor',colori{1}), hold on
bar(2,nanmean(PropEpAboveTh_ch(:,1)*100),'FaceColor',colori{2}), hold on
handlesplot=plotSpread({PropEpAboveTh_gfp(:,1)*100,PropEpAboveTh_ch(:,1)*100},'distributionColors',[1 1 1 ; 1 1 1]); hold on
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread({PropEpAboveTh_gfp(:,1)*100,PropEpAboveTh_ch(:,1)*100},'distributionColors',[0 0 0;0 0 1]); hold on
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',[1,2],'XTickLabel',{'GFP','ChR2'})
ylabel('% events longer than 20s')
ylim([0 80]), xlim([0.5 2.5])
title('light off')
box off
figure('Position',[682   502   301   420]) %  light
bar(1,nanmean(PropEpAboveTh_gfp(:,2)*100),'k'), hold on
bar(2,nanmean(PropEpAboveTh_ch(:,2)*100),'FaceColor',colori{2}), hold on
handlesplot=plotSpread({PropEpAboveTh_gfp(:,2)*100,PropEpAboveTh_ch(:,2)*100},'distributionColors',[1 1 1 ; 1 1 1]); hold on
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread({PropEpAboveTh_gfp(:,2)*100,PropEpAboveTh_ch(:,2)*100},'distributionColors',[0 0 0;0 0 1]); hold on
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',[1,2],'XTickLabel',{'GFP','ChR2'})
ylabel('% events longer than 20s')
ylim([0 80]), xlim([0.5 2.5])
title('light on')
box off

%% nombre et durée moyenne
h_EpNb=figure('Position',[125         578        1163         363]); ; 
subplot(131), PlotErrorBarN(NbEp_gfp(:,col_OI),0,0,'ranksum',1), title('gfp')
subplot(132), PlotErrorBarN(NbEp_ch(:,col_OI),0,0,'ranksum',1), title('chr2')
subplot(133), 
[p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({NbEp_gfp(:,col_OI),NbEp_ch(:,col_OI)},'nb Fz Episodes',colori,'ranksum',1,3,3);
if sav
    saveas(h_EpNb.Number,['NbEpisodes.fig'])
    saveFigure(h_EpNb.Number,['NbEpisodes' ],res)
end

h_EpDur=figure('Position',[125         578        1163         363]); 
subplot(131), PlotErrorBarN(MeanDurEp_gfp(:,col_OI),0,0,'ranksum',1), title('gfp')
subplot(132), PlotErrorBarN(MeanDurEp_ch(:,col_OI),0,0,'ranksum',1), title('chr2')
subplot(133), 
[p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen({MeanDurEp_gfp(:,col_OI),MeanDurEp_ch(:,col_OI)},'Episodes Duration',colori,'ranksum',1,3,3);
% [p_an,table_an,stats_an,Pkw_g,table_kw_g,p_mw,stats_mw]=BarPlotBulbSham_gen(Table,TableName,Gpcolor,test,n,p,j,varargin)
if sav
    saveas(h_EpDur.Number,['EpDur.fig'])
    saveFigure(h_EpDur.Number,['EpDur'],res)
end

%% Fig article
%% Number of events
figure('Position',[682   502   301   420]) % no light
bar(1,nanmedian(NbEp_gfp(:,1)),'k'), hold on
bar(2,nanmedian(NbEp_ch(:,1)),'FaceColor',colori{2}), hold on
handlesplot=plotSpread({NbEp_gfp(:,1),NbEp_ch(:,1)},'distributionColors',[1 1 1 ; 1 1 1]); hold on
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread({NbEp_gfp(:,1),NbEp_ch(:,1)},'distributionColors',[0 0 0;0 0 1]); hold on
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',[1,2],'XTickLabel',{'GFP','ChR2'})
ylabel('Number of FZ episodes')
ylim([0 15]), box off
title('light off')

figure('Position',[682   502   301   420]) %  light
bar(1,nanmedian(NbEp_gfp(:,2)),'k'), hold on
bar(2,nanmedian(NbEp_ch(:,2)),'FaceColor',colori{2}), hold on
handlesplot=plotSpread({NbEp_gfp(:,2),NbEp_ch(:,2)},'distributionColors',[1 1 1 ; 1 1 1]); hold on
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread({NbEp_gfp(:,2),NbEp_ch(:,2)},'distributionColors',[0 0 0;0 0 1]); hold on
set(handlesplot{1},'MarkerSize',20)
set(gca,'XTick',[1,2],'XTickLabel',{'GFP','ChR2'})
ylim([0 15]), box off
title('light on')
ylabel('Number of FZ episodes')

%% Duration of events
figure('Position',[682   502   301   420]) % no light
bar(1,nanmedian(MeanDurEp_gfp(:,1)/1e4),'k'), hold on
bar(2,nanmedian(MeanDurEp_ch(:,1)/1e4),'b'), hold on
handlesplot=plotSpread({MeanDurEp_gfp(:,1)/1e4,MeanDurEp_ch(:,1)/1e4},'distributionColors',[1 1 1 ; 1 1 1]); hold on
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread({MeanDurEp_gfp(:,1)/1e4,MeanDurEp_ch(:,1)/1e4},'distributionColors',[0 0 0;0 0 1]); hold on
set(handlesplot{1},'MarkerSize',20)
ylim([0 30]), box off
set(gca,'XTick',[1,2],'XTickLabel',{'GFP','ChR2'})
ylabel('Duration of FZ episodes (s)')
title('light off')

figure('Position',[682   502   301   420]) %  light
bar(1,nanmedian(MeanDurEp_gfp(:,2))/1e4,'k'), hold on
bar(2,nanmedian(MeanDurEp_ch(:,2))/1e4,'b'), hold on
handlesplot=plotSpread({MeanDurEp_gfp(:,2)/1e4,MeanDurEp_ch(:,2)/1e4},'distributionColors',[1 1 1 ; 1 1 1]); hold on
set(handlesplot{1},'MarkerSize',25)
handlesplot=plotSpread({MeanDurEp_gfp(:,2)/1e4,MeanDurEp_ch(:,2)/1e4},'distributionColors',[0 0 0;0 0 1]); hold on
set(handlesplot{1},'MarkerSize',20)
ylim([0 30]), box off
set(gca,'XTick',[1,2],'XTickLabel',{'GFP','ChR2'})
ylabel('Duration of FZ episodes (s)')
title('light on')

%end

%% freezing triggé sur le CS
tmax=71000;
Fzing_gfp=nan(length(gfpmice),tmax);
MovAcc_gfp=nan(length(gfpmice),tmax);
    a=1;
for man=gfpmice

    MovAcctsd=bilanMovAccSmotsd{man};
    FreezeEpoch=bilanFreezeAccEpoch{man};
    AllTimes=Range(MovAcctsd,'s');
    FreezeTimes=Range(Restrict(MovAcctsd,FreezeEpoch),'s');
    
    Fzing=ismember(AllTimes,FreezeTimes);   
    Fzing_gfp(a,:)=Fzing(1:tmax);
    
    TmaxEpoch=ts(0,AllTimes(tmax));
    MovAcc_gfp(a,:)=Data(Restrict(MovAcctsd,TmaxEpoch),'s');
%     Fzingtsd=tsd(AllTimes(1:tmax)*1E4, Fzing(1:tmax));

    a=a+1;
end


Fzing_ch=nan(length(chr2mice),tmax);
    a=1;
for man=chr2mice

    MovAcctsd=bilanMovAccSmotsd{man};
    FreezeEpoch=bilanFreezeAccEpoch{man};
    AllTimes=Range(MovAcctsd,'s');
    FreezeTimes=Range(Restrict(MovAcctsd,FreezeEpoch),'s');
    Fzing=ismember(AllTimes,FreezeTimes);
    Fzing_ch(a,:)=Fzing(1:tmax);
    
    a=a+1;
end
% figure, subplot(121),imagesc(Fzing_gfp), 
% subplot(122),imagesc(Fzing_ch)
% figure, subplot(121)

smo=40;
figure('Position',[ 137         517        1755         405])
hold on
plot(AllTimes(1:tmax),SmoothDec(nanmean(Fzing_gfp),smo))
plot(AllTimes(1:tmax),SmoothDec(nanmean(Fzing_ch),smo))
line([csp csp+30],[0.9 0.9])


Fzingtsd_gfp=tsd(AllTimes(1:tmax)*1E4, nanmean(Fzing_gfp(:,1:tmax))');
Fzingtsd_ch=tsd(AllTimes(1:tmax)*1E4, nanmean(Fzing_ch(:,1:tmax))');

dur=60000;
[M_gfp_all,T_gfp_all]=PlotRipRaw(Fzingtsd_gfp,csp,dur);
[M_ch_all,T_ch_all]=PlotRipRaw(Fzingtsd_ch,csp,dur );

a=1;
for k=1:2:11
[M_gfp{a},T_gfp{a}]=PlotRipRaw(Fzingtsd_gfp,csp([k k+1]),dur);
[M_ch{a},T_ch{a}]=PlotRipRaw(Fzingtsd_ch,csp([k k+1]),dur );
a=a+1;
end
figure('Position',[  279         448        3223         451]), n=6;
for a=1:n
    subplot(1,n,a)
    plot(M_gfp{a}(:,1),SmoothDec(M_gfp{a}(:,2),smo)),hold on
    plot(M_ch{a}(:,1),SmoothDec(M_ch{a}(:,2),smo))
    ylim([0 1 ])
    xlim([-60 60])
end


plot(M_gfp(:,1),M_gfp(:,2)),hold on
plot(M_ch(:,1),M_ch(:,2))


figure, subplot(1,4,1)


  Fzingtsd_gfp=tsd(AllTimes(1:tmax)*1E4, nanmean(Fzing_gfp(:,1:tmax))');
[M,T]=PlotRipRaw(Fzingtsd_gfp,csp,45000);
figure, plot(M(:,1),M(:,2))
