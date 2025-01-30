function [Tps,Val,Tps2,Val2,P,P2,X,Reg,Reg2]=GlobalSleepHomeostasisSleepCycle(dossier)



%[val,tps]=SleepHomeostasisSleepCycleFunction(homeo);
%load NREMepochsML op
%homeo{1}=op{4};
%homeo{2}=op{6};
%homeo{3}=op{5};
%homeo{4}=NewtsdZT;
%homeo{5}=DeltaEpoch;
%homeo{6}=1;

% [Dir24,nameSessions]=NREMstages_path('SD24h');
% [Dir6h,nameSessions]=NREMstages_path('SD6h');
% [DirOR,nameSessions]=NREMstages_path('OR');
% k=7; n=3; cd(Dir6h{k,n}), nameSessions{n}

% load behavResources NewtsdZT
% try
% load AllDeltaPFCx DeltaEpoch
% end
% try
% load DeltaWaves
% DeltaEpoch=deltas_PFCx;
% end
% load NREMepochsML op
% homeo{1}=op{4};
% homeo{2}=op{6};
% homeo{3}=op{5};
% homeo{4}=NewtsdZT;
% homeo{5}=DeltaEpoch;
% homeo{6}=1;
% figure, subplot(1,4,1:3), hold on
% [val,tps]=SleepHomeostasisSleepCycleFunction(homeo);
% subplot(1,4,4),
% bar([ sum(End(op{5},'s')-Start(op{5},'s')) sum(End(op{6},'s')-Start(op{6},'s')) sum(End(op{4},'s')-Start(op{4},'s'))]/60,1,'k'); title(num2str([sum(End(op{4},'s')-Start(op{4},'s'))/(sum(End(op{4},'s')-Start(op{4},'s'))+sum(End(op{6},'s')-Start(op{6},'s')))*100]))
% clear op DeltaEpoch NewtsdZT


%%
Dir1=PathForExperimentsBasalSleepRhythms;
Dir2=PathForExperimentsBasalSleepSpike;
Dir3=PathForExperimentsFakeSlowWave;
k=1;
Dir4temp = PathForExperimentsEmbReact('BaselineSleep');
for mousenum  = 1:length(Dir4temp.path)
for daynum = 1:length(Dir4temp.path{mousenum})
Dir4.path{k}=Dir4temp.path{mousenum}{daynum};
k=k+1;
end
end



%%
try
    eval(['Dir=',dossier,';']) 
catch
    DirA=MergePathForExperiment(Dir1,Dir2);
    DirB=MergePathForExperiment(Dir3,Dir4);
    Dir=MergePathForExperiment(DirA,DirB);
end

Tps=[];
Val=[];
Tps2=[];
Val2=[];
P=[];
P2=[];
X=[];
Reg=[];
Reg2=[];
a=1;
%%
for a=1:length(Dir.path)
    
    cd(Dir.path{a}), 
    try
    [tps, val, tps2, val2, p,p2,x, reg, reg2]=SleepHomeostasisSleepCycle; close

    Tps=[Tps;tps'];
    Tini=[Tini,[tps(1)*ones(length(tps),1),a*ones(length(tps2),1)]];
    Val=[Val;val];
    Tps2=[Tps2,tps2];
    Tini2=[Tini2,[tps2(1)*ones(length(tps2),1),a*ones(length(tps2),1)]];
    Val2=[Val2,val2'];
    P=[P;p];
    P2=[P2;p2];

    Reg=[Reg;reg'];
    Reg2=[Reg2;reg2'];
    X=[X;x'];

    end
end

%%
figure, 
plot(X,Reg,'k.')
hold on, plot(X,Reg2,'r.')
hold on, plot(Tps2,Val2,'ko','markerfacecolor','r')
hold on, plot(Tps,Val,'ko','markerfacecolor','k')
