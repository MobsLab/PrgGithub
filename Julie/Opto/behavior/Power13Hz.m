% Power13Hz.m
% 31.10.2017
% le 09.11.2017 je change 10µlog10 -> log 10 
% mais figures des ppt faits en 10*log10

sav=0;
StepName={'HABlaser';'EXT-24'; 'EXT-48';'COND';};
stepN=2;
structlist={'Bulb_deep_right','Bulb_ventral_right','Bulb_deep_left','Bulb_ventral_left','Bulb_ecoG_right','Bulb_ecoG_left','PFCx_deep_right','PFCx_deep_left','PiCx_right','PiCx_left',};%'
cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017
temp=load([StepName{stepN} '_fullperiod_close2sound']);

% gfpmice=[1 2 3 4 5 6 7 8]; %gfpmice=[1 2 3 4 5];
chr2mice=[ 9 10 11 12 13 14 15 16];
period='fullperiod'; optionfullper='close2sound';

figure ('Position',[1975         516        1831         343]) %507         517       1571         312
n=5; k=1; Msize=8;
colori=jet(8);%lines(8);%hsv(8);%parula(8);%jet(8);
markeri={'o','*','s','x','.','.','o','s','*','x'};
%% Behavior
subplot(1,n,k), k=k+1; % cla
PlotErrorBarN(temp.bilan{stepN}(chr2mice,:),0,1,'ranksum',2) % newfig=0; paired=1,columntest=2
ylim([0 1]), title('ChR2')
ylabel([StepName{stepN} ' ' optionfullper ])
for man=1:size(temp.bilan{stepN}(chr2mice,:),1)
        plot(temp.bilan{stepN}(chr2mice(man),:),'Color',colori(man,:),'Marker','o','MarkerSize',3,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
end

cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/corr_Fz_13hz
temppower=load([StepName{stepN} '_power_' structlist{1}]);
for man=1:size(temppower.bilan{stepN},1)
    temppower.Dir.nb{man}=temppower.Dir.name{man}(end-2:end);
end

%% OB 
subplot(1,n,2); hold on % cla
PowerByStruct=[];
for i=1:6% cla
    temppower=load([StepName{stepN} '_power_' structlist{i}]); 
    Power=temppower.bilan{stepN}(:,4);
    Power=temppower.bilan{stepN}(:,4)./temppower.BasalPower13;
    for man=1:size(temppower.bilan{stepN},1)
        plot(man,log10(Power(man,1)),'Marker',markeri{i},'MarkerSize',Msize,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))  
    end
    PowerByStruct=[PowerByStruct Power(:,1)];
end
YL=ylim;
xlabel(' o deep * ventral . ecoG right') 
title(' sq deep x ventral . ecoG left') 
set(gca,'XTick',[],'XTickLabel',[])

subplot(1,n,3),hold on
for man=1:size(temppower.bilan{stepN},1)
    %     plot(man,log10(temppower.bilan{stepN}(man,4)),'.','MarkerSize',Msize)
        plot(man,log10(nanmean(PowerByStruct(man,1:4))),'Marker','o','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
end
ylim(YL)
title ('OB mean (deep + ventral)') 
ylabel('log10 power 13Hz')
for man=1:size(temppower.bilan{stepN},1)
    temppower.Dir.nb{man}=temppower.Dir.name{man}(end-2:end);
end
set(gca,'XTick',[1:size(temppower.bilan{stepN},1)],'XTickLabel',temppower.Dir.nb)
%% PFC and PiCx
subplot(1,n,4),hold on
for i=7:10% cla
    temppower=load([StepName{stepN} '_power_' structlist{i}]); 
    Power=temppower.bilan{stepN}(:,4)./temppower.BasalPower13;
    for man=1:size(temppower.bilan{stepN},1)
        plot(man,log10(Power(man,1)),'Marker',markeri{i},'MarkerSize',Msize,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))  
    end
    PowerByStruct=[PowerByStruct Power(:,1)];
end
title ('PFC and PiCx') 
xlabel(' o sq  =  PFC  /  * x = PiCx') 
subplot(1,n,4),hold on


subplot(1,n,5),hold on
for man=1:size(temppower.bilan{stepN},1)
        plot(man,log10(nanmean(PowerByStruct(man,7:10))),'Marker','o','MarkerSize',Msize,'MarkerEdgeColor',colori(man,:),'MarkerFaceColor',colori(man,:))
end
ylim(YL)
title ('mean (PFC +PiCx)') 
ylabel('log10 power 13Hz')
for man=1:size(temppower.bilan{stepN},1)
    temppower.Dir.nb{man}=temppower.Dir.name{man}(end-2:end);
end
set(gca,'XTick',[1:size(temppower.bilan{stepN},1)],'XTickLabel',temppower.Dir.nb)
if sav
    cd /media/DataMOBsRAIDN/ProjetAversion/OptoFear/Fear_Mar2-July-Oct2017/corr_Fz_13hz
    saveas(gcf,[StepName{stepN} '_power_allstt.fig'])
    saveas(gcf,[StepName{stepN} '_power_allstt.eps'])
    saveas(gcf,[StepName{stepN} '_power_allstt.png'])
    save([StepName{stepN} '_power_allstt'],'PowerByStruct','structlist','temppower');
end
