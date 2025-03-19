

%% Mouse example
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/ExampleMouse.mat')
% or after 
% edit Freezing_FarFromStims_Maze_BM.m

mouse=15; sess=1;
Freeze.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
FreezeShock = intervalSet([1686e4 1700e4],[1695e4 1707e4]);
FreezeSafe = intervalSet([1714e4],[1780e4]);

Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
Smooth_Acc=tsd(Range(Acc.Cond.(Mouse_names{mouse})),runmean(Data(Acc.Cond.(Mouse_names{mouse})),ceil(1/median(diff(Range(Acc.Cond.(Mouse_names{mouse}),'s'))))));
Smooth_Acc_Freeze = Restrict(Smooth_Acc,Freeze.Cond.(Mouse_names{mouse}));
Smooth_Acc_FreezeShock = Restrict(Smooth_Acc,FreezeShock);
Smooth_Acc_FreezeSafe = Restrict(Smooth_Acc,FreezeSafe);

HR.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'heartrate');
Smooth_HR=tsd(Range(HR.Cond.(Mouse_names{mouse})),runmean(Data(HR.Cond.(Mouse_names{mouse})),ceil(3/median(diff(Range(HR.Cond.(Mouse_names{mouse}),'s'))))));
Smooth_HR_Freeze = Restrict(Smooth_HR,Freeze.Cond.(Mouse_names{mouse}));
Smooth_HR_FreezeShock = Restrict(Smooth_HR,FreezeShock);
Smooth_HR_FreezeSafe = Restrict(Smooth_HR,FreezeSafe);


figure
a=subplot(3,4,1:3); %a.Position=[.13 .71 .694 .2157];
plot(Range(Smooth_Acc,'s') , Data(Smooth_Acc)/1e7,'k','LineWidth',2)
hold on
plot(Range(Smooth_Acc_FreezeShock,'s') , Data(Smooth_Acc_FreezeShock)/1e7,'.','LineWidth',2,'Color',[1 .5 .5])
plot(Range(Smooth_Acc_FreezeSafe,'s') , Data(Smooth_Acc_FreezeSafe)/1e7,'.','LineWidth',2,'Color',[.5 .5 1])
xticklabels({'','','','','','',''}), xlim([1660 1780]), ylim([0 15])
ylabel('Motion (a.u.)'), xticks([1660:20:1780])
f=get(gca,'Children'); l=legend([f(2),f(1)],'Freezing shock','Freezing safe'); l.Box='off';
box off

subplot(344)
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.accelero.mean(:,5)/1e7 OutPutData.Fear.accelero.mean(:,6)/1e7},Cols,X,Legends,1,0);
ylabel('Motion (a.u.)')
ylim([0 3])


a=subplot(3,4,5:7); val=14.5;
imagesc(Range(OB_Low_Spec.Cond.(Mouse_names{mouse}))/1e4 , Spectro{3} , runmean(runmean(log10(Spectro{3}'.*Data(OB_Low_Spec.Cond.(Mouse_names{mouse}))'),10)',10)'), axis xy
line([1660 1708],[val val],'Color',[1 .5 .5],'Linewidth',10)
line([1708 1711],[val val],'Color',[.8 .5 .8],'Linewidth',10)
line([1711 1780],[val val],'Color',[.5 .5 1],'Linewidth',10)
line([[1686 1700 1714];[1695 1707 1780]],[13 13],'Color',[.5 .5 .5],'Linewidth',10)
ylim([.15 15]), xlim([1660 1780]), 
xticklabels({'','','','','','',''}), yticks([0:2:14]), text(1658,-.1,'0')
h=hline(4.5,'--r'); h.LineWidth=3;xticks([1660:20:1780])
caxis([5.1 6.9])
ylabel('OB frequency (Hz)')
box off
f=get(gca,'Children'); l=legend([f(7),f(6),f(5),f(4)],'Shock arm','Center','Safe arm','Freezing'); 
l.Box='off';
c=colorbar; c.Ticks=[]; c.Label.String='Power (log scale)';
colormap jet

subplot(348)
MakeSpreadAndBoxPlot_BM({Freq_Max1 Freq_Max2},Cols,X,Legends,1,0);
ylabel('Frequency (Hz)')
ylim([0 7])


a=subplot(3,4,9:11); %a.Position=[.13 .11 .694 .2157];
plot(Range(Smooth_HR,'s') , Data(Smooth_HR),'k','LineWidth',2)
hold on
plot(Range(Smooth_HR_FreezeShock,'s') , Data(Smooth_HR_FreezeShock),'.','LineWidth',2,'Color',[1 .5 .5])
plot(Range(Smooth_HR_FreezeSafe,'s') , Data(Smooth_HR_FreezeSafe),'.','LineWidth',2,'Color',[.5 .5 1])
xlim([1660 1780]), ylim([8 14])
xlabel('time (s)'), ylabel('Heart rate (Hz)')
xticklabels({'0','20','40','60','80','100','120'})
box off

subplot(3,4,12)
MakeSpreadAndBoxPlot_BM(OutPutData.Fear.heartrate.mean(:,5:6),Cols,X,Legends,1,0);
ylabel('Heart rate (Hz)')





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
load('B_Low_Spectrum.mat')

Mouse=Drugs_Groups_UMaze_BM(11);
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
%     OB_Low_Spec.Ext.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
    try, Spec{mouse} = CleanSpectro(OB_Low_Spec.Fear.(Mouse_names{mouse}), Spectro{3} , 8); end
%     Freeze.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'epoch','epochname','freeze_epoch_camera');
    
    disp(Mouse_names{mouse})
end

figure
for mouse=25:length(Mouse)
    subplot(4,6,mouse-24)
    try, imagesc(Range(OB_Low_Spec.Fear.(Mouse_names{mouse}),'s') , Spectro{3} , runmean(runmean(log10(Spectro{3}.*Data(Spec{mouse}))',10)',10)'), axis xy, end
    line([(Start(Freeze.(Mouse_names{mouse}))/1e4)';(Stop(Freeze.(Mouse_names{mouse}))/1e4)'],[13 13],'Color',[0 0 0],'Linewidth',10)
end


figure, mouse=15;
imagesc(Range(OB_Low_Spec.Fear.(Mouse_names{mouse}),'s') , Spectro{3} , runmean(runmean(log10(Spectro{3}.*Data(Spec{mouse}))',10)',10)'), axis xy
xlim([500 1200])
line([(Start(Freeze.(Mouse_names{mouse}))/1e4)';(Stop(Freeze.(Mouse_names{mouse}))/1e4)'],[13 13],'Color',[0 0 0],'Linewidth',10)

figure, mouse=42;
imagesc(Range(OB_Low_Spec.Fear.(Mouse_names{mouse}),'s') , Spectro{3} , runmean(runmean(log10(Spectro{3}.*Data(Spec{mouse}))',10)',10)'), axis xy
xlim([4500 5600])
line([(Start(Freeze.(Mouse_names{mouse}))/1e4)';(Stop(Freeze.(Mouse_names{mouse}))/1e4)'],[13 13],'Color',[0 0 0],'Linewidth',10)


figure, mouse=15;
imagesc(Range(OB_Low_Spec.Fear.(Mouse_names{mouse}),'s') , Spectro{3} , runmean(runmean(log10(Data(Spec{mouse}))',10)',10)'), axis xy
xlim([500 1200])
line([(Start(Freeze.(Mouse_names{mouse}))/1e4)';(Stop(Freeze.(Mouse_names{mouse}))/1e4)'],[13 13],'Color',[0 0 0],'Linewidth',10)

figure, mouse=42;
imagesc(Range(OB_Low_Spec.Fear.(Mouse_names{mouse}),'s') , Spectro{3} , runmean(runmean(log10(Data(Spec{mouse}))',10)',10)'), axis xy
xlim([4500 5600])
line([(Start(Freeze.(Mouse_names{mouse}))/1e4)';(Stop(Freeze.(Mouse_names{mouse}))/1e4)'],[13 13],'Color',[0 0 0],'Linewidth',10)





subplot(122)
imagesc(Range(OB_Low_Spec.Ext.(Mouse_names{mouse}))/1e4 , Spectro{3} , runmean(runmean(log10(Spectro{3}'.*Data(Spec{mouse})'),10)',10)'), axis xy
xlim([1600 1800])
line([(Start(Freeze.(Mouse_names{mouse}))/1e4)';(Stop(Freeze.(Mouse_names{mouse}))/1e4)'],[13 13],'Color',[0 0 0],'Linewidth',10)


mouse=14; sess=1;
FreezeShock = intervalSet([1686e4 1700e4],[1695e4 1707e4]);
FreezeSafe = intervalSet([1714e4],[1780e4]);

Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
Smooth_Acc=tsd(Range(Acc.Cond.(Mouse_names{mouse})),runmean(Data(Acc.Cond.(Mouse_names{mouse})),ceil(1/median(diff(Range(Acc.Cond.(Mouse_names{mouse}),'s'))))));
Smooth_Acc_Freeze = Restrict(Smooth_Acc,Freeze.Cond.(Mouse_names{mouse}));
Smooth_Acc_FreezeShock = Restrict(Smooth_Acc,FreezeShock);
Smooth_Acc_FreezeSafe = Restrict(Smooth_Acc,FreezeSafe);

HR.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'heartrate');
Smooth_HR=tsd(Range(HR.Cond.(Mouse_names{mouse})),runmean(Data(HR.Cond.(Mouse_names{mouse})),ceil(3/median(diff(Range(HR.Cond.(Mouse_names{mouse}),'s'))))));
Smooth_HR_Freeze = Restrict(Smooth_HR,Freeze.Cond.(Mouse_names{mouse}));
Smooth_HR_FreezeShock = Restrict(Smooth_HR,FreezeShock);
Smooth_HR_FreezeSafe = Restrict(Smooth_HR,FreezeSafe);




