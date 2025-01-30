%% Code used for 11th april draft
%% This code produces an example figure of transition zone and the duration of transition zones


clear all, 
%close all
% Load Mice File Names
AllSlScoringMice


% Parameters
MatXEMG=[-2:8/99:6];
MatYEMG=[-2:4/99:2];
MatXGam=[-0.7:3.2/99:2.5];
MatYGam=[-1.5:3.5/99:2];
lim=[1,2,3,5,7,10,15,20];
jtouse=3;


% Get general properties of all transitions : duration and frequency
clear DurG DurE
for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat','SWSEpoch','Wake','REMEpoch')%     %Find transition zone
    TotDur=max([max(Stop(Wake)),max(Stop(SWSEpoch)),max(Stop(REMEpoch))])/1e4;
    load('TransLimsGam.mat')
    
    %Wk to Sleep
    temp=dropShortIntervals(AbortTrans{3},0.2e4);
    DurG(1,mm)=mean((Stop(temp)-Start(temp))/1e4);
    DurG(2,mm)=length(Start(temp))./TotDur;

    %Sleep to Wk
    temp=dropShortIntervals(AbortTrans{2},0.2e4);
    DurG(3,mm)=mean((Stop(temp)-Start(temp))/1e4);
    DurG(4,mm)=length(Start(temp))./TotDur;

    %Sleep to Sleep
    temp=dropShortIntervals(AbortTrans{4},0.2e4);
    DurG(5,mm)=mean((Stop(temp)-Start(temp))/1e4);
    DurG(6,mm)=length(Start(temp))./TotDur;
    
    %Wake to Wake
    temp=dropShortIntervals(AbortTrans{1},0.2e4);
    DurG(7,mm)=mean((Stop(temp)-Start(temp))/1e4);
    DurG(8,mm)=length(Start(temp))./TotDur;
    
end

% W to S and S to W
figure
subplot(121)
PlotErrorBarN(DurG([1,3],:)',0,1);
box off
ylabel('Transition duration')
title('OB')
set(gca,'XTick',[1,2],'XTickLabel',{'W. to S.','S. to W.'})
subplot(122)
PlotErrorBarN(DurG([2,4],:)',0,1);
box off
ylabel('Transition frequency')
title('OB')
set(gca,'XTick',[1,2],'XTickLabel',{'W. to S.','S. to W.'})

figure
subplot(121)
PlotErrorBarN(DurG([5,7],:)',0,1);
box off
ylabel('Transition duration')
title('OB')
set(gca,'XTick',[1,2],'XTickLabel',{'S. to S.','W. to W.'})
subplot(122)
PlotErrorBarN(DurG([6,8],:)',0,1);
box off
ylabel('Transition frequency')
title('OB')
set(gca,'XTick',[1,2],'XTickLabel',{'S. to S.','W. to W.'})


%Gamma
% Look at autocorrelograms
Titres={'CrossCorr WtoS with WtoW','CrossCorr StoW with StoS'}
binsz=2;
totdur=200;
smoofact=2;
for mm=1:m
    mm
    cd(filename2{mm})
    load('TransLimsGam.mat')
    for i=1:4
        AbortTrans{i}=dropShortIntervals(AbortTrans{i},0.2e4);
    end
    num=1;
    
    [C,B]=CrossCorr(Start(AbortTrans{3}),Start( AbortTrans{1}),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    Tot{num,mm}=C/sum(C);
    
    num=2;
    [C,B]=CrossCorr(Start(AbortTrans{2}),Start(AbortTrans{4}),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    Tot{num,mm}=C/sum(C);
end

figure
for k=1:2
    subplot(1,2,k)
    g=shadedErrorBar(B/1e3,(mean(reshape([Tot{k,:}],length(C),m)')),[stdError(((reshape([Tot{k,:}],length(C),m)')))])
    title(Titres{k})
    ylim([0 0.04])
end
