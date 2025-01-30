% Correlate_Fz_Power13Hz.m
% 30.10.2017
% plots data produced by Light_effect_on_Power13hz.m

%% INITIALIZE
sav=0;
StepName={'HABlaser';'EXT-24'; 'EXT-48';'COND';};
stepN=2;
% Stt_OI=1:4; structures_of_interest='bulb deep + ventral L-R'; 
% Stt_OI=7:8; structures_of_interest='PFC deep L-R'; 
Stt_OI=9:10; structures_of_interest='PiCx L-R'; 
%% Load data
cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
temp=load([StepName{stepN} '_fullperiod_close2sound']);
Fz=temp.bilan{stepN};

% cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/corr_Fz_13hz
cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/corr_Fz_13hz/norm_BasalPower13
load([StepName{stepN} '_power_allstt'])
Power=nanmean(PowerByStruct(:,Stt_OI),2);

% gfpmice=[1 2 3 4 5 6 7 8]; %gfpmice=[1 2 3 4 5];
chr2mice=[ 9 10 11 12 13 14 15 16];
period='fullperiod'; optionfullper='close2sound';
YLpower=[30 60];

%% Freezing
figure ('Position',[ 1975         516        1831         343]) %507         517       1571         312
n=5; k=1; Msize=20;
colori=jet(8);%lines(8);%hsv(8);%parula(8);%jet(8);

subplot(1,n,k), k=k+1; 
PlotErrorBarN(Fz(chr2mice,:),0,1,'ranksum',2) % newfig=0; paired=1,columntest=2
for man=1:size(temp.bilan{stepN}(chr2mice,:),1)
        plot(temp.bilan{stepN}(chr2mice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
end
ylim([0 1]), title('ChR2')
ylabel([StepName{stepN} ' ' optionfullper ])

%% Power
for man=1:size(Power,1)
    temppower.Dir.nb{man}=temppower.Dir.name{man}(end-2:end);
end

subplot(1,n,k), k=k+1; hold on % cla
for man=1:size(Fz(chr2mice,:),1)
%     plot(man,Power(man,1),'.','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:))
    plot(man,10*log10(Power(man,1)),'.','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:))
end
set(gca,'XTick',[1:size(Power,1)],'XTickLabel',temppower.Dir.nb)
ylabel('log power 13Hz')
title(structures_of_interest); % title ('mean deep+ ventral L/R')
% ylim(YLpower)


% subplot(1,n,k), k=k+1; hold on % cla
% for man=1:size(Power,1)
% plot(Power(man,4), Fz(chr2mice(man),4),'.','MarkerSize',Msize)
% end
% xlabel('power 13Hz')
% ylabel('Freezing CS+ laser (4) ')

%% Corr Log Power / Fz
subplot(1,n,k), k=k+1; hold on
for man=1:size(Fz(chr2mice,:),1)
    
% plot(Power(man,1), Fz(chr2mice(man),4),'.','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:))
plot(10*log10(Power(man,1)), Fz(chr2mice(man),4),'.','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:))
end
xlabel('log power 13Hz')
ylabel('Freezing CS+ laser (4)')
ylim([0 1]),
% xlim(YLpower)

%% Corr Log Power (4-3) / Fz
subplot(1,n,k), k=k+1; hold on
for man=1:size(Fz(chr2mice,:),1)
%     plot(Power(man,1), Fz(chr2mice(man),3)-Fz(chr2mice(man),4),'.','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:))
    plot(10*log10(Power(man,1)), Fz(chr2mice(man),3)-Fz(chr2mice(man),4),'.','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:))
end
xlabel('log power 13Hz')
ylabel('Freezing decrease (3 - 4)')
ylim([0 1]),
%xlim(YLpower)

%% Corr Log Power Mod Index / Fz
subplot(1,n,k), k=k+1; hold on
for man=1:size(Fz(chr2mice,:),1)
% plot(Power(man,1), (Fz(chr2mice(man),4)-Fz(chr2mice(man),3))./(Fz(chr2mice(man),3)+Fz(chr2mice(man),4)),'.','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:))
plot(10*log10(Power(man,1)), (Fz(chr2mice(man),4)-Fz(chr2mice(man),3))./(Fz(chr2mice(man),3)+Fz(chr2mice(man),4)),'.','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:))
end
xlabel('log power 13Hz')
ylabel('Fz Mod Index (4-3)/(4+3)')
ylim([-1 1]),
%xlim(YLpower)
XL=xlim; plot([XL(1) XL(2)],[0 0],'Color',[0.5 0.5 0.5])

if sav
    
cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/corr_Fz_13hz; res=pwd;
saveas(gcf,['Corr_Fz_Power13Hz_' StepName{stepN} '_' structures_of_interest '.fig']);
saveas(gcf,['Corr_Fz_Power13Hz_' StepName{stepN} '_'  structures_of_interest '.eps']);
saveas(gcf,['Corr_Fz_Power13Hz_' StepName{stepN} '_' structures_of_interest '.png']);
% saveFigure(gcf,['Corr_Fz_Power13Hz_' StepName{stepN} '_'  structlist{1} ],res);
end
