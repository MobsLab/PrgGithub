


[MatRemThet,MatRemGam,MatRemDel,MatRemRip,MatRemRipStart,MatRemRipEnd,MatRemBet,MatRemBetStart,MatRemBetEnd] = PlotEMGandSpectroHPCduringStim_MC_SB(plo)

%% index before / during stims
idxduringT=find(MatRemThet(:,1)>0&MatRemThet(:,1)<30);
idxbeforeT=find(MatRemThet(:,1)>-30&MatRemThet(:,1)<0);

idxduringB=find(MatRemBet(:,1)>0&MatRemBet(:,1)<30);
idxbeforeB=find(MatRemBet(:,1)>-30&MatRemBet(:,1)<0);

idxduringR=find(MatRemRip(:,1)>0&MatRemRip(:,1)<30);
idxbeforeR=find(MatRemRip(:,1)>-30&MatRemRip(:,1)<0);

idxduringE=find(MatRemEMG(:,1)>0&MatRemEMG(:,1)<30);
idxbeforeE=find(MatRemEMG(:,1)>-30&MatRemEMG(:,1)<0);

resduringRipp=[];
resbeforeRipp=[];
resduringThet=[];
resbeforeThet=[];
resduringBet=[];
resbeforeBet=[];
resduringEMG=[];
resbeforeEMG=[];

for k=1:length(StimR)
    resduringRipp=[resduringRipp;TpsRemRip(k,idxduringR)];
    resbeforeRipp=[resbeforeRipp;TpsRemRip(k,idxbeforeR)];
    resduringThet=[resduringThet;TpsRemThet(k,idxduringT)];
    resbeforeThet=[resbeforeThet;TpsRemThet(k,idxbeforeT)];
    resduringBet=[resduringBet;TpsRemBet(k,idxduringB)];
    resbeforeBet=[resbeforeBet;TpsRemBet(k,idxbeforeB)];    
    resduringEMG=[resduringEMG;TpsRemEMG(k,idxduringE)];
    resbeforeEMG=[resbeforeEMG;TpsRemEMG(k,idxbeforeE)];     
end

avEMGBef=mean(resbeforeEMG,2);
avBetBef=mean(resbeforeBet,2);
avThetBef=mean(resbeforeThet,2);
avRippBef=mean(resbeforeRipp,2);

avEMGDur=mean(resduringEMG,2);
avBetDur=mean(resduringBet,2);
avThetDur=mean(resduringThet,2);
avRippDur=mean(resduringRipp,2);

%% theta et ripples
figure, hold on,
s1=plot(avThetBef,avRippBef,'ko',avThetDur,avRippDur,'r+');
set(s1,'MarkerSize',8,'Linewidth',2);
xlabel('theta power')
ylabel('ripples density (ripples/s)')
legend('before','after')
for i=1:length(StimR)
    hold on,plot([avThetBef(i),avThetDur(i)], [avRippBef(i),avRippDur(i)],'k')
end
legend('before','during')

%% theta et beta
figure, hold on,
s1=plot(avThetBef,avBetBef,'ko',avThetDur,avBetDur,'r+');
set(s1,'MarkerSize',8,'Linewidth',2);
xlabel('theta power')
ylabel('beta power')
legend('before','after')
for i=1:length(StimR)
    hold on,plot([avThetBef(i),avThetDur(i)], [avBetBef(i),avBetDur(i)],'k')
end
legend('before','during')

%% theta et EMG
figure, hold on,
s1=plot(avThetBef,avEMGBef,'ko',avThetDur,avEMGDur,'r+');
set(s1,'MarkerSize',8,'Linewidth',2);
xlabel('theta power')
ylabel('EMG')
legend('before','after')
for i=1:length(StimR)
    hold on,plot([avThetBef(i),avThetDur(i)], [avEMGBef(i),avEMGDur(i)],'k')
end
legend('before','during')

%% beta et ripples
figure, hold on,
s1=plot(avBetBef,avRippBef,'ko',avBetDur,avRippDur,'r+');
set(s1,'MarkerSize',8,'Linewidth',2);
xlabel('beta power')
ylabel('ripples density (ripples/s)')
legend('before','after')
for i=1:length(StimR)
    hold on,plot([avBetBef(i),avBetDur(i)], [avRippBef(i),avRippDur(i)],'k')
end
legend('before','during')

%% beta et EMG
figure, hold on,
s1=plot(avBetBef,avEMGBef,'ko',avBetDur,avEMGDur,'r+');
set(s1,'MarkerSize',8,'Linewidth',2);
xlabel('beta power')
ylabel('EMG')
legend('before','after')
for i=1:length(StimR)
    hold on,plot([avBetBef(i),avBetDur(i)], [avEMGBef(i),avEMGDur(i)],'k')
end
legend('before','during')

%% ripples et EMG
figure, hold on,
s1=plot(avRippBef,avEMGBef,'ko',avRippDur,avEMGDur,'r+');
set(s1,'MarkerSize',8,'Linewidth',2);
xlabel('ripples')
ylabel('EMG')
legend('before','after')
for i=1:length(StimR)
    hold on,plot([avRippBef(i),avRippDur(i)], [avEMGBef(i),avEMGDur(i)],'k')
end
legend('before','during')