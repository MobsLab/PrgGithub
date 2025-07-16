%% Figures exploring Sleep after OF

figure('color',[1 1 1])

Cols={[0.7 0.7 0.7],[0.3 0.3 0.3],[0.7 0.7 0.7],[0.3 0.3 0.3]};
X=[1:4];
Legends={'Saline Pre','Saline Post','Nicotine Pre','Nicotine Post'};

subplot(131)
MakeSpreadAndBoxPlot3_SB({PropWake.SalineOFSleep.Pre PropWake.SalineOFSleep.Post PropWake.NicotineOFSleep.Pre PropWake.NicotineOFSleep.Post},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Wake proportion');
makepretty_CH


subplot(132)
MakeSpreadAndBoxPlot3_SB({PropNREM.SalineOFSleep.Pre PropNREM.SalineOFSleep.Post PropNREM.NicotineOFSleep.Pre PropNREM.NicotineOFSleep.Post},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('NREM proportion');
makepretty_CH


subplot(133)
MakeSpreadAndBoxPlot3_SB({PropREM.SalineOFSleep.Pre PropREM.SalineOFSleep.Post PropREM.NicotineOFSleep.Pre PropREM.NicotineOFSleep.Post},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM proportion');
makepretty_CH

%%


figure('color',[1 1 1])

Cols={[0.7 0.7 0.7],[0.3 0.3 0.3]};
X=[1:2];
Legends={'Pre','Post'};
a = 1;

for i = 1:2
    
    subplot(2,3,a)
    MakeSpreadAndBoxPlot3_SB({PropWake.(Name{i}).Pre PropWake.(Name{i}).Post},Cols,X,Legends,'showpoints',1,'paired',1);
    ylabel('Wake proportion');
    makepretty_CH
    ylabel(Name{i})
    a=a+1;
    
    subplot(2,3,a)
    MakeSpreadAndBoxPlot3_SB({PropNREM.(Name{i}).Pre PropNREM.(Name{i}).Post},Cols,X,Legends,'showpoints',1,'paired',1);
    ylabel('NREM proportion');
    makepretty_CH
    a=a+1;
    
    
    subplot(2,3,a)
    MakeSpreadAndBoxPlot3_SB({PropREM.(Name{i}).Pre PropREM.(Name{i}).Post},Cols,X,Legends,'showpoints',1,'paired',1);
    ylabel('REM proportion');
    makepretty_CH
    a=a+1;
    
    
end

%%
figure
PlotCorrelations_BM(DistanceToCenter_mean.NicotineOF.Post,PropREM.NicotineOFSleep.Post,'colortouse','k')
xlabel('Mean distance to center')
ylabel('Proportion of REM in Sleep Post')

figure
PlotCorrelations_BM(PropREM.NicotineOFSleep.Pre,PropREM.NicotineOFSleep.Post,'colortouse','k')
xlabel('Proportion of REM in Sleep Pre')
ylabel('Proportion of REM in Sleep Post')

figure
PlotCorrelations_BM(DistanceToCenter_mean.NicotineOF.Post,PropNREM.NicotineOFSleep.Post,'colortouse','k')
xlabel('Mean distance to center')
ylabel('Proportion of NREM in Sleep Post')

%%


Col1 = [0,0,1];
Col2 = [1,0,0];
Col3 = [0,1,0];

time = linspace(1,5,10);

figure, hold on

subplot(211), hold on
a1 = errorbar(time, nanmean(WakePropTemp.SalineOFSleep.Pre),stdError(WakePropTemp.SalineOFSleep.Pre),'color',Col1);
plot(time,WakePropTemp.SalineOFSleep.Pre,'.b')
a2 = errorbar(time, nanmean(NREMPropTemp.SalineOFSleep.Pre),stdError(NREMPropTemp.SalineOFSleep.Pre),'color',Col2);
plot(time,NREMPropTemp.SalineOFSleep.Pre,'.r')
a3 = errorbar(time, nanmean(REMPropTemp.SalineOFSleep.Pre),stdError(REMPropTemp.SalineOFSleep.Pre),'color',Col3);
plot(time,REMPropTemp.SalineOFSleep.Pre,'.g')

ylabel('SleepPre')
xlabel('time (hours)')
legend([a1 a2 a3],'Wake','NREM','REM')
makepretty_CH

subplot(212), hold on
a1 = errorbar(time, nanmean(WakePropTemp.SalineOFSleep.Post),stdError(WakePropTemp.SalineOFSleep.Post),'color',Col1);
plot(time,WakePropTemp.SalineOFSleep.Post,'.b')
a2 = errorbar(time, nanmean(NREMPropTemp.SalineOFSleep.Post),stdError(NREMPropTemp.SalineOFSleep.Post),'color',Col2);
plot(time,NREMPropTemp.SalineOFSleep.Post,'.r')
a3 = errorbar(time, nanmean(REMPropTemp.SalineOFSleep.Post),stdError(REMPropTemp.SalineOFSleep.Post),'color',Col3);
plot(time,REMPropTemp.SalineOFSleep.Post,'.g')


ylabel('SleepPost')
xlabel('time (hours)')
legend([a1 a2 a3],'Wake','NREM','REM')
makepretty_CH

