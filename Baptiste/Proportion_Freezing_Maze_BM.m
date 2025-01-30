

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat')
Session_type={'Cond'}; sess=1;
Drug_Group={'Saline'};

FreqLim = 4; n=1;
for mouse = 1:length(Mouse)
    
    clear D, D = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
    Prop_shock(n,mouse) = sum(D>FreqLim)/length(D);
    Prop_safe(n,mouse) = sum(D<FreqLim)/length(D);
    Length_shock(n,mouse) = sum(D>FreqLim)*.2;
    Length_safe(n,mouse) = sum(D<FreqLim)*.2;
    
    clear D_shock, D_shock = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
    Prop_shockShock(n,mouse) = sum(D_shock>FreqLim)/length(D_shock);
    Prop_safeShock(n,mouse) = sum(D_shock<FreqLim)/length(D_shock);
    try, Prop_safeShock_end(n,mouse) = sum(D_shock(round(length(D_shock)*.9):end)<FreqLim)/length(D_shock(round(length(D_shock)*.9):end)); end
    Length_shockShock(n,mouse) = sum(D_shock>FreqLim)*.2;
    Length_safeShock(n,mouse) = sum(D_shock<FreqLim)*.2;
    
    
    clear D_safe, D_safe = Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
    Prop_shockSafe(n,mouse) = sum(D_safe>FreqLim)/length(D_safe);
    Prop_safeSafe(n,mouse) = sum(D_safe<FreqLim)/length(D_safe);
    try, Prop_safeSafe_end(n,mouse) = sum(D_safe(round(length(D_safe)*.9):end)<FreqLim)/length(D_safe(round(length(D_safe)*.9):end)); end
    Length_shockSafe(n,mouse) = sum(D_safe>FreqLim)*.2;
    Length_safeSafe(n,mouse) = sum(D_safe<FreqLim)*.2;
    
end
Prop_shock(Prop_shock==0)=NaN;
Prop_safe(Prop_safe==0)=NaN;
Prop_shockShock(Prop_shockShock==0)=NaN;
Prop_safeShock(Prop_safeShock==0)=NaN;
Prop_shockSafe(Prop_shockSafe==0)=NaN;
Prop_safeSafe(Prop_safeSafe==0)=NaN;



%% figures
figure
a= pie([nanmean(Length_shockShock) nanmean(Length_shockSafe) nanmean(Length_safeShock) nanmean(Length_safeSafe)]); 
set(a(1), 'FaceColor', [1 .5 .5]); set(a(3), 'FaceColor', [.7 .3 .3]); set(a(5), 'FaceColor', [.5 .5 1]); set(a(7), 'FaceColor', [.3 .3 .7]);
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],'Breathing>4Hz, shock side','Breathing>4Hz, safe side','Breathing<4Hz, shock side','Breathing<4Hz, safe side');



figure
subplot(121)
a=bar([1],[1]); hold on
a.FaceColor=[1 .5 .5]; 
a=bar([1],nanmean(Prop_safeShock));
a.FaceColor=[.5 .5 1]; 
a=bar([2],[1]); hold on
a.FaceColor=[1 .5 .5]; 
a=bar([2],nanmean(Prop_safeSafe));
a.FaceColor=[.5 .5 1]; 
xticks([1 2]), xticklabels({'Shock side','Safe side'})
ylabel('proportion')
plot((rand(1,29)-.5)*.3+1,Prop_safeShock,'.k')
plot((rand(1,29)-.5)*.3+2,Prop_safeSafe,'.k')
f=get(gca,'Children'); legend([f(6),f(5)],['Fz>' num2str(FreqLim) 'Hz'],['Fz<' num2str(FreqLim) 'Hz']);
makepretty_BM2
xtickangle(45)
grid on
title('all')

subplot(122)
a=bar([1],[1]); hold on
a.FaceColor=[1 .5 .5];
a=bar([1],nanmean(Prop_safeShock_end));
a.FaceColor=[.5 .5 1];
a=bar([2],[1]); hold on
a.FaceColor=[1 .5 .5];
a=bar([2],nanmean(Prop_safeSafe_end));
a.FaceColor=[.5 .5 1];
xticks([1 2]), xticklabels({'Shock side','Safe side'})
ylabel('proportion')
plot((rand(1,29)-.5)*.3+1,Prop_safeShock_end,'.k')
plot((rand(1,29)-.5)*.3+2,Prop_safeSafe_end,'.k')
f=get(gca,'Children'); legend([f(6),f(5)],['Fz>' num2str(FreqLim) 'Hz'],['Fz<' num2str(FreqLim) 'Hz']);
makepretty_BM2
xtickangle(45)
grid on
title('end')




figure
a=bar([1],[1]); hold on
a.FaceColor=[1 .5 .5]; 
a=bar([1],nanmean(Length_safeSafe./(Length_safeShock+Length_safeSafe)));
a.FaceColor=[.5 .5 1]; 
a=bar([2],[1]); hold on
a.FaceColor=[1 .5 .5]; 
a=bar([2],nanmean(Length_shockSafe./(Length_shockShock+Length_shockSafe)));
a.FaceColor=[.5 .5 1]; 
xticks([1 2]), xticklabels({'Fz<4','Fz>4'})
ylabel('proportion')
plot((rand(1,29)-.5)*.3+1,Length_safeSafe./(Length_safeShock+Length_safeSafe),'.k')
plot((rand(1,29)-.5)*.3+2,Length_shockSafe./(Length_shockShock+Length_shockSafe),'.k')
f=get(gca,'Children'); legend([f(6),f(5)],'shock side','safe side');
makepretty_BM2
xtickangle(45)
grid on





figure
a=barh([1],[-nanmean(Length_shock(1,:))],'stacked'); hold on
b=barh([1],[-nanmean(Length_shockSafe(1,:))],'stacked'); hold on
errorbar(-nanmean(Prop_shock(1,:)),1,nanstd(Prop_shock(1,:))/sqrt(length(Prop_shock(1,:))),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 
b.FaceColor=[.7 .3 .3]; 

a=barh([1],[nanmean(Length_safe(1,:))],'stacked'); 
b=barh([1],[nanmean(Length_safeSafe(1,:))],'stacked'); 
errorbar(nanmean(Prop_safe(1,:)),1,0,nanstd(Prop_safe(1,:))/sqrt(length(Prop_safe(1,:))),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
b.FaceColor=[.3 .3 .7]; 
xlabel('freezing mode (s)')
yticklabels({'Saline'}), 
makepretty_BM2
% xlim([-.6 .6])
f=get(gca,'Children'); legend([f(6),f(5),f(3),f(2)],'Breathing>4Hz, shock side','Breathing>4Hz, safe side','Breathing<4Hz, shock side','Breathing<4Hz, safe side');







%% tools
figure
subplot(131)
MakeSpreadAndBoxPlot3_SB({Prop_safeSafe([1:4 14:16 18 20 23:29]) Prop_safeSafe([5:13 17 19 21 22])},{[.3 .3 .3],[1 0 0]},[1 2],{'short','long'},'showpoints',1,'paired',0)

subplot(132)
MakeSpreadAndBoxPlot3_SB({Prop_safeSafe([1:8 14:29]) Prop_safeSafe([9:13])},{[.3 .3 .3],[0 1 0]},[1 2],{'all','long Maze 1'},'showpoints',1,'paired',0)

subplot(133)
MakeSpreadAndBoxPlot3_SB({Prop_safeSafe([1:13]) Prop_safeSafe([14:29])},{[.3 .3 .3],[0 0 1]},[1 2],{'Maze1','Maze4'},'showpoints',1,'paired',0)



figure
MakeSpreadAndBoxPlot3_SB({Prop_safeShock([14:29]) Prop_safeSafe([14:29])},{[.3 .3 .3],[0 0 1]},[1 2],{'Maze1','Maze4'},'showpoints',0,'paired',1)



PlotCorrelations_BM([1:29] , Prop_safeSafe)
hold on
PlotCorrelations_BM([1:5] , Prop_safeSafe([9:13]) , 'colortouse' , 'r')
axis square

subplot(132)
PlotCorrelations_BM([1:29] , Prop_safeSafe)
hold on
PlotCorrelations_BM([1:5] , Prop_safeSafe([ ]) , 'colortouse' , 'r')


Prop_safeSafe([9:13])


