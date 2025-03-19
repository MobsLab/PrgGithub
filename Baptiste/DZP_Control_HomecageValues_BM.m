

l=load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/DZP_Sleep.mat');

Cols={[.3, .8, .93],[.85, .325, .1]};
X=[1:2];
Legends={'Saline','DZP'};


figure
subplot(221)
MakeSpreadAndBoxPlot3_SB(Wake_prop_late,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Wake/Total'), ylim([0 .8]), title('Baseline sleep')
makepretty_BM2
subplot(222)
MakeSpreadAndBoxPlot3_SB(l.Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .8]), title('Sleep after UMaze')
makepretty_BM2

subplot(223)
MakeSpreadAndBoxPlot3_SB(REM_prop_late,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM/sleep'), ylim([0 .25])
makepretty_BM2
subplot(224)
MakeSpreadAndBoxPlot3_SB(l.Prop.REM_s_l_e_e_p,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .25])
makepretty_BM2


%%
l=load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_DZP_Physio_Cond.mat', 'Length_shock', 'Length_safe');
l.Length_safe(1,12)=NaN;
l.Length_shock(1,12)=NaN;

figure
subplot(221)
MakeSpreadAndBoxPlot3_SB(Length_shock,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Fz>4.5Hz duration (s)'), ylim([0 450]), title('Baseline sleep')
makepretty_BM2

subplot(223)
MakeSpreadAndBoxPlot3_SB(Length_safe,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Fz<4.5Hz duration (s)'), ylim([0 750])
makepretty_BM2

subplot(222)
MakeSpreadAndBoxPlot3_SB({l.Length_shock(1,:) l.Length_shock(2,:)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 450]), title('during U-Maze')
makepretty_BM2

subplot(224)
MakeSpreadAndBoxPlot3_SB({l.Length_safe(1,:) l.Length_safe(2,:)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 750])
makepretty_BM2


%%
l=load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_DZP_Physio_Cond.mat', 'OutPutData');

SWR_occ{1}([3:5]) = NaN;
SWR_occ{1}([3]) = NaN;


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(SWR_occ,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.2]), ylabel('SWR occurence, immobility (#/s)'), title('in homecage')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB({l.OutPutData.Saline.Cond.ripples.mean(:,3) l.OutPutData.Diazepam.Cond.ripples.mean(:,3)},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 1.2]), title('during U-Maze')
makepretty_BM2



%%
l2=load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_DZP_HR.mat', 'OutPutData');
l3=load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Sleep_Pre_Values_DZP.mat', 'HR_Wake');
HR_FzAftInj{2}(1)=NaN;


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({HR_WakeAfterInj{1}-HR_WakeBefInj{1} HR_WakeAfterInj{2}-HR_WakeBefInj{2}},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-2 3]), ylabel('HR after injection (norm)'), title('in homecage')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB({l2.OutPutData.Saline.Cond.heartrate.mean(:,1)-HR_Wake{1}' l2.OutPutData.Diazepam.Cond.heartrate.mean(:,1)-HR_Wake{2}'},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-2 3]), title('during U-Maze')
makepretty_BM2



figure
MakeSpreadAndBoxPlot3_SB({HR_WakeAfterInj{1}-HR_WakeBefInj{1} HR_WakeAfterInj{2}-HR_WakeBefInj{2}},Cols,X,Legends,'showpoints',1,'paired',0);


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({HR_FzAftInj{1}-HR_WakeBefInj{1} HR_FzAftInj{2}-HR_WakeBefInj{2}},Cols,X,Legends,'showpoints',1,'paired',0);

figure
MakeSpreadAndBoxPlot3_SB(HR_WakeBefInj,Cols,X,Legends,'showpoints',1,'paired',0);



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Speed_WakeAfterInj,Cols,X,Legends,'showpoints',1,'paired',0);
subplot(122)
MakeSpreadAndBoxPlot3_SB(Acc_WakeAfterInj,Cols,X,Legends,'showpoints',1,'paired',0);






for drug = 1:2
    HR_WakeAfterInj{drug}(HR_WakeAfterInj{drug}==0) = NaN;
    HR_WakeBefInj{drug}(HR_WakeBefInj{drug}==0) = NaN;
    HR_FzAftInj{drug}(HR_FzAftInj{drug}==0) = NaN;
end





