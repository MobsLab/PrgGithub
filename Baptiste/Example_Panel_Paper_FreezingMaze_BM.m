
%%
GetEmbReactMiceFolderList_BM
Mouse=688;
Session_type={'Ext'};

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
        OB_High_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Middle');
        HPC_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
        
        Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
        HRConcat.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
        Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
        
%         Freeze.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
%         Zone.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
%         ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = Zone.(Session_type{sess}).(Mouse_names{mouse}){1};
%         SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(Zone.(Session_type{sess}).(Mouse_names{mouse}){2} , Zone.(Session_type{sess}).(Mouse_names{mouse}){5});
        
%         Freeze_Shock = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
%         Freeze_Safe = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
    end
end
load('B_Low_Spectrum.mat'), RangeLow = Spectro{3};
load('B_Middle_Spectrum.mat'), RangeHigh = Spectro{3};

%%
% M688, Ext

load('/media/nas7/ProjetEmbReact/DataEmbReact/ExampleMouse.mat')

mouse=1; sess=1;

FreezeShock = intervalSet([742e4 759e4 804e4 819e4 836e4 844.5e4 853e4 871e4 921e4 936e4 954e4 965.8e4],[754e4 764e4 807e4 829e4 841.5e4 849e4 864e4 900e4 927.6e4 939.5e4 960e4 967.7e4]);
FreezeSafe = intervalSet([1144e4 1161e4 1184e4 1222e4 1242e4 1279e4 1311e4 1332e4 1390e4 1439e4 1469e4 1498e4],[1156e4 1169e4 1200e4 1238e4 1273e4 1302e4 1321e4 1376e4 1409e4 1448e4 1491e4 1504e4]);

Smooth_Acc=tsd(Range(Acc.Ext.(Mouse_names{mouse})),runmean(Data(Acc.Ext.(Mouse_names{mouse})),ceil(1/median(diff(Range(Acc.Ext.(Mouse_names{mouse}),'s'))))));
Smooth_Acc_FreezeShock = Restrict(Smooth_Acc,FreezeShock);
Smooth_Acc_FreezeSafe = Restrict(Smooth_Acc,FreezeSafe);

Smooth_HR=tsd(Range(HRConcat.Ext.(Mouse_names{mouse})),runmean(Data(HRConcat.Ext.(Mouse_names{mouse})),ceil(1/median(diff(Range(HRConcat.Ext.(Mouse_names{mouse}),'s'))))));
Smooth_HR_FreezeShock = Restrict(Smooth_HR,FreezeShock);
Smooth_HR_FreezeSafe = Restrict(Smooth_HR,FreezeSafe);

Smooth_Respi=tsd(Range(Respi.Ext.(Mouse_names{mouse})),movmean(Data(Respi.Ext.(Mouse_names{mouse})),ceil(1/median(diff(Range(Respi.Ext.(Mouse_names{mouse}),'s')))),'omitnan'));
Smooth_Respi_FreezeShock = Restrict(Smooth_Respi,FreezeShock);
Smooth_Respi_FreezeSafe = Restrict(Smooth_Respi,FreezeSafe);




figure
subplot(511)
plot(Range(Smooth_Acc,'s') , Data(Smooth_Acc)/1e7,'k','LineWidth',2)
hold on
plot(Range(Smooth_Acc_FreezeShock,'s') , Data(Smooth_Acc_FreezeShock)/1e7,'.','LineWidth',2,'Color',[1 .5 .5])
plot(Range(Smooth_Acc_FreezeSafe,'s') , Data(Smooth_Acc_FreezeSafe)/1e7,'.','LineWidth',2,'Color',[.5 .5 1])
xticklabels({'0','100','200','300','400','500','600','700','800','900'}), xlim([600 1550]), ylim([0 15])
ylabel('Motion (a.u.)'), xticks([600:100:1500])
box off

subplot(512), val=14.5;
imagesc(Range(OB_Low_Spec.Ext.(Mouse_names{mouse}))/1e4 , RangeLow , runmean(runmean(log10(Data(OB_Low_Spec.Ext.(Mouse_names{mouse}))'),10)',10)'), axis xy
hold on
plot(Range(Smooth_Respi_FreezeShock,'s') , Data(Smooth_Respi_FreezeShock),'.','LineWidth',2,'Color',[1 .5 .5])
plot(Range(Smooth_Respi_FreezeSafe,'s') , Data(Smooth_Respi_FreezeSafe),'.','LineWidth',2,'Color',[.5 .5 1])% line([600 1096],[val val],'Color',[1 .5 .5],'Linewidth',10)
line([600 1096],[val val],'Color',[1 .5 .5],'Linewidth',10)
line([1096 1117],[val val],'Color',[.8 .5 .8],'Linewidth',10)
line([1117 1600],[val val],'Color',[.5 .5 1],'Linewidth',10)
line([[742 759 804 819 836 844.5 853 871 921 936 954 965.8 1144 1161 1184 1222 1242 1279 1311 1332 1390 1439 1469 1498];...
    [754 764 807 829 841.5 849 864 900 927.6 939.5 960 967.7 1156 1169 1200 1238 1273 1302 1321 1376 1409 1448 1491 1504]],[12 12],'Color',[.7 .7 .7],'Linewidth',10)
xlim([600 1550]), ylim([0 15]), caxis([4.3 5.8])
xticklabels({'0','100','200','300','400','500','600','700','800','900'}), yticks([0:2:14]), %text(1658,-.1,'0')
h=hline(3.5,'--k'); h.LineWidth=.5;
xticks([600:100:1500])
ylabel('OB frequency (Hz)')

subplot(513)
plot(Range(Smooth_HR,'s') , Data(Smooth_HR),'k','LineWidth',2)
hold on
plot(Range(Smooth_HR_FreezeShock,'s') , Data(Smooth_HR_FreezeShock),'.','MarkerSize',10,'Color',[1 .5 .5])
plot(Range(Smooth_HR_FreezeSafe,'s') , Data(Smooth_HR_FreezeSafe),'.','MarkerSize',10,'Color',[.5 .5 1])
xlim([600 1550]), ylim([7 14.5])
ylabel('Heart rate (Hz)')
xticklabels({'0','100','200','300','400','500','600','700','800','900'})
box off

subplot(514); val=14.5;
imagesc(Range(HPC_Low_Spec.Ext.(Mouse_names{mouse}))/1e4 , RangeLow , runmean(runmean(log10(Data(HPC_Low_Spec.Ext.(Mouse_names{mouse}))'),10)',10)'), axis xy
% line([600 1096],[val val],'Color',[1 .5 .5],'Linewidth',10)
% line([1096 1117],[val val],'Color',[.8 .5 .8],'Linewidth',10)
% line([1117 1600],[val val],'Color',[.5 .5 1],'Linewidth',10)
% line([[742 759 804 819 836 844.5 853 871 921 936 954 965.8 1144 1161 1184 1222 1242 1279 1311 1332 1390 1439 1469 1498];...
%     [754 764 807 829 841.5 849 864 900 927.6 939.5 960 967.7 1156 1169 1200 1238 1273 1302 1321 1376 1409 1448 1491 1504]],[12 12],'Color',[.7 .7 .7],'Linewidth',10)
xlim([600 1550]), ylim([0 15]), caxis([4.3 5.4])
xticklabels({'0','100','200','300','400','500','600','700','800','900'}), yticks([0:2:14]), %text(1658,-.1,'0')
% h=hline(3.5,'--k'); h.LineWidth=.5;
xticks([600:100:1500])
ylabel('HPC frequency (Hz)')
% box off
% f=get(gca,'Children'); l=legend([f(7),f(6),f(5),f(4)],'Shock arm','Center','Safe arm','Freezing'); 
% l.Box='off';
% c=colorbar; c.Ticks=[]; c.Label.String='Power (log scale)';

subplot(515); val=14.5;
imagesc(Range(OB_High_Spec.Ext.(Mouse_names{mouse}))/1e4 , RangeHigh , runmean(runmean(log10(Data(OB_High_Spec.Ext.(Mouse_names{mouse}))'),5)',1000)'), axis xy
% line([600 1096],[val val],'Color',[1 .5 .5],'Linewidth',10)
% line([1096 1117],[val val],'Color',[.8 .5 .8],'Linewidth',10)
% line([1117 1600],[val val],'Color',[.5 .5 1],'Linewidth',10)
% line([[742 759 804 819 836 844.5 853 871 921 936 954 965.8 1144 1161 1184 1222 1242 1279 1311 1332 1390 1439 1469 1498];...
%     [754 764 807 829 841.5 849 864 900 927.6 939.5 960 967.7 1156 1169 1200 1238 1273 1302 1321 1376 1409 1448 1491 1504]],[95 95],'Color',[.7 .7 .7],'Linewidth',10)
xlim([600 1550]), ylim([30 100]), caxis([2.7 4])
xticklabels({'0','100','200','300','400','500','600','700','800','900'}), %yticks([0:2:14]), %text(1658,-.1,'0')
xticks([600:100:1500])
xlabel('time (s)'), ylabel('OB frequency (Hz)')
% box off
% f=get(gca,'Children'); l=legend([f(7),f(6),f(5),f(4)],'Shock arm','Center','Safe arm','Freezing'); 
% l.Box='off';
% c=colorbar; c.Ticks=[]; c.Label.String='Power (log scale)';


