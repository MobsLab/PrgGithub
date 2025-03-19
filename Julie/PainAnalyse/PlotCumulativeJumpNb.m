% Plot Cumulative JumpNb
try
    cd /media/DataMOBsRAID/ProjetAversion/PAIN/manip22souris_sham-obx
catch
    cd \\NASDELUXE2\DataMOBsRAID\ProjetAversion\PAIN\manip22souris_sham-obx %path windows
end
res=pwd;
load PainData_22souris_rampe90.mat

%% define groups
obxNb=[269:279];
for k=1:length(obxNb)
    obx{k}=num2str(obxNb(k));
end

shamNb=[280:290];
for k=1:length(shamNb)
    sham{k}=num2str(shamNb(k));
end
Cum1=cumsum(JumpNb{1,1},2);
Cum2=cumsum(JumpNb{1,2},2);
figure, subplot(1,2,1),plot([0:89],Cum1),title('sham'), legend(sham)
set(gca,'Xtick',[0:6:90],'XtickLabel',[30:45])
subplot(1,2,2),plot([0:89],Cum2),title('obx'),legend(obx)
set(gca,'Xtick',[0:6:90],'XtickLabel',[30:45])
ylim([0 100])

%saveas (gcf, 'CumulativeJumpNb.fig')
%saveFigure(gcf,'CumulativeJumpNb',res)