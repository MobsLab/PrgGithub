

clear all


l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat');
Session_type={'Cond'}; sess=1;
Drug_Group={'Saline'};
Group = 22;


l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_FlxChr_Ctrl_Cond_2sFullBins.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_FlxChr_Cond_2sFullBins.mat');
Drug_Group={'Saline','Flx'};
Group = [1 2];


l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Ctrl_Cond_2sFullBins.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Cond_2sFullBins.mat');
Drug_Group={'RipControl','RipInhib'};
Group = [7 8];



%%
Session_type={'Cond'}; sess=1;
FreqLim = 4.5; n=1;

%%
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse = 1:length(Mouse)
        
        clear D, D = Data(l{group}.OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
        Prop_shock{group}(n,mouse) = sum(D>FreqLim)/length(D);
        Prop_safe{group}(n,mouse) = sum(D<FreqLim)/length(D);
        Length_shock{group}(n,mouse) = sum(D>FreqLim)*.2;
        Length_safe{group}(n,mouse) = sum(D<FreqLim)*.2;
        
        clear D_shock, D_shock = Data(l{group}.OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
        Prop_shockShock{group}(n,mouse) = sum(D_shock>FreqLim)/length(D_shock);
        Prop_safeShock{group}(n,mouse) = sum(D_shock<FreqLim)/length(D_shock);
        Length_shockShock{group}(n,mouse) = sum(D_shock>FreqLim)*.2;
        Length_safeShock{group}(n,mouse) = sum(D_shock<FreqLim)*.2;
        
        clear D_safe, D_safe = Data(l{group}.OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
        Prop_shockSafe{group}(n,mouse) = sum(D_safe>FreqLim)/length(D_safe);
        Prop_safeSafe{group}(n,mouse) = sum(D_safe<FreqLim)/length(D_safe);
        Length_shockSafe{group}(n,mouse) = sum(D_safe>FreqLim)*.2;
        Length_safeSafe{group}(n,mouse) = sum(D_safe<FreqLim)*.2;
    end
    Prop_shock{group}(Prop_shock{group}==0)=NaN;
    Prop_safe{group}(Prop_safe{group}==0)=NaN;
    Prop_shockShock{group}(Prop_shockShock{group}==0)=NaN;
    Prop_safeShock{group}(Prop_safeShock{group}==0)=NaN;
    Prop_shockSafe{group}(Prop_shockSafe{group}==0)=NaN;
    Prop_safeSafe{group}(Prop_safeSafe{group}==0)=NaN;
end



%% figures
figure
A = log10(Length_shock{1})'; B = log10(Length_safe{1})';
PlotCorrelations_BM(A , B , 'conf_bound',1)
A = log10(Length_shock{2})'; B = log10(Length_safe{2})';
PlotCorrelations_BM(A , B , 'conf_bound',1 , 'colortouse' , [1 0 0])
makepretty
xlabel('Duration fz breathing >4.5Hz (log scale)'), ylabel('Fz breathing <4.5Hz (log scale)')
axis square



figure
a= pie([nanmean(Length_shockShock) nanmean(Length_shockSafe) nanmean(Length_safeShock) nanmean(Length_safeSafe)]);
set(a(1), 'FaceColor', [1 .5 .5]); set(a(3), 'FaceColor', [.7 .3 .3]); set(a(5), 'FaceColor', [.5 .5 1]); set(a(7), 'FaceColor', [.3 .3 .7]);
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Breathing>' num2str(FreqLim) 'Hz, shock side'],...
    ['Breathing>' num2str(FreqLim) 'Hz, safe side'],['Breathing<' num2str(FreqLim) 'Hz, shock side'],['Breathing<' num2str(FreqLim) 'Hz, safe side']);



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
a=bar([1],nanmean(Length_safeSafe_end./(Length_safeShock_end+Length_safeSafe_end)));
a.FaceColor=[.5 .5 1];
a=bar([2],[1]); hold on
a.FaceColor=[1 .5 .5];
a=bar([2],nanmean(Length_shockSafe_end./(Length_shockShock_end+Length_shockSafe_end)));
a.FaceColor=[.5 .5 1];
xticks([1 2]), xticklabels({'Fz<4','Fz>4'})
ylabel('proportion')
plot((rand(1,29)-.5)*.3+1,Length_safeSafe_end./(Length_safeShock_end+Length_safeSafe_end),'.k')
plot((rand(1,29)-.5)*.3+2,Length_shockSafe_end./(Length_shockShock_end+Length_shockSafe_end),'.k')
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


%% trash ?
try, Length_shockSafe_end{group}(n,mouse) = sum(D_safe(round(length(D_safe)*.9):end)>FreqLim)*.2; end
try, Length_safeSafe_end{group}(n,mouse) = sum(D_safe(round(length(D_safe)*.9):end)<FreqLim)*.2; end

try, Length_shockShock_end{group}(n,mouse) = sum(D_shock(round(length(D_shock)*.9):end)>FreqLim)*.2; end
try, Length_safeShock_end{group}(n,mouse) = sum(D_shock(round(length(D_shock)*.9):end)<FreqLim)*.2; end

try, Prop_safeShock_end{group}(n,mouse) = sum(D_shock(round(length(D_shock)*.9):end)<FreqLim)/length(D_shock(round(length(D_shock)*.9):end)); end
try, Prop_safeSafe_end{group}(n,mouse) = sum(D_safe(round(length(D_safe)*.9):end)<FreqLim)/length(D_safe(round(length(D_safe)*.9):end)); end
