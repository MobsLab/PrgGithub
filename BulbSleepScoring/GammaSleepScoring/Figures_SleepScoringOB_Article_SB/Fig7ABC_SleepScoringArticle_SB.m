%% Code used for 11th april draft
%% This code produces an example figure of transition zone and the duration of transition zones


clear all, close all
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
    
    %Sleep to Wk
    temp=dropShortIntervals(AbortTrans{2},0.2e4);
    DurG(2,mm)=mean((Stop(temp)-Start(temp))/1e4);
    
    %Sleep to Sleep
    temp=dropShortIntervals(AbortTrans{4},0.2e4);
    DurG(3,mm)=mean((Stop(temp)-Start(temp))/1e4);
    DurG(5,mm)=length(Start(temp))./TotDur;
    
    %Wake to Wake
    temp=dropShortIntervals(AbortTrans{1},0.2e4);
    DurG(4,mm)=mean((Stop(temp)-Start(temp))/1e4);
    DurG(6,mm)=length(Start(temp))./TotDur;
    
    
end

PlotErrorBar(DurG(1:2,:)');
[h,p]=ttest(DurG(1,:),DurG(2,:));
sigstar({[1,2]},p)
box off
ylabel('Transition duration')
title('OB')
set(gca,'XTick',[1,2],'XTickLabel',{'W. to S.','S. to W.'})


PlotErrorBar(DurG(3:4,:)');
[h,p]=ttest(DurG(3,:),DurG(4,:));
sigstar({[1,2]},p)
box off
ylabel('Transition duration')
title('OB')
set(gca,'XTick',[1,2],'XTickLabel',{'S. to S.','W. to W.'})

PlotErrorBar(DurG(5:6,:)');
[h,p]=ttest(DurG(5,:),DurG(6,:));
sigstar({[1,2]},p)
box off
ylabel('Transition frequency')
title('OB')
set(gca,'XTick',[1,2],'XTickLabel',{'S. to S.','W. to W.'})


%% Example of four types of trajectories we are going to use
MatXGam=[-0.7:3.2/99:2.5];MatYGam=[-1.5:3.5/99:2];
%% use mm=11
for mm=11
    mm
    figure
    cd(filename2{mm})
    load('StateEpochSB.mat','SWSEpoch','smooth_ghi','smooth_Theta','gamma_thresh','theta_thresh')%     %Find transition zone
    load('MapsTransitionProbaGam.mat')
    load('TransLimsGam.mat')
    gammamean=mean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
    thetamean=mean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
    imagesc(MatXGam,MatYGam,Val{3}'), axis xy, colormap bone
    temp=AbortTrans{1};temp=dropShortIntervals(temp,0.5e4);
    temp2=intervalSet(Start(temp)-1e4,Stop(temp)+1e4);
    for k=5
        hold on
        line(log([X1 X1])-gammamean,[min(MatYGam) max(MatYGam)],'color','r','linewidth',4)
        line(log([X2 X2])-gammamean,[min(MatYGam) max(MatYGam)],'color','r','linewidth',4)
        plot(log(Data(Restrict(smooth_ghi,subset(temp2,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp2,k))))-(thetamean)+0.3,'k', 'linewidth',4)
        plot(log(Data(Restrict(smooth_ghi,subset(temp,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp,k))))-(thetamean)+0.3,'color',[0.6 0.6 0.6],'linewidth',2)
        a=log(Data(Restrict(smooth_ghi,subset(temp2,k))))-(gammamean);
        b=log(Data(Restrict(smooth_Theta,subset(temp2,k))))-(thetamean)+0.3;
    end
    
    temp=AbortTrans{4};temp=dropShortIntervals(temp,0.5e4);
    temp2=intervalSet(Start(temp)-1e4,Stop(temp)+1e4);
    for k=[10]
        hold on
        plot(log(Data(Restrict(smooth_ghi,subset(temp2,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp2,k))))-(thetamean)+0.1,'b', 'linewidth',4)
        plot(log(Data(Restrict(smooth_ghi,subset(temp,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp,k))))-(thetamean)+0.1,'c','linewidth',2)
        a=log(Data(Restrict(smooth_ghi,subset(temp2,k))))-(gammamean);
        b=log(Data(Restrict(smooth_Theta,subset(temp2,k))))-(thetamean)+0.1;
    end
    
        temp=AbortTrans{2};temp=dropShortIntervals(temp,0.5e4);
        temp2=intervalSet(Start(temp)-1e4,Stop(temp)+1e4);
        for k=6
            hold on
            plot(log(Data(Restrict(smooth_ghi,subset(temp2,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp2,k))))-(thetamean)-0.2,'color',[0.5 0.3 1] ,'linewidth',4)
            plot(log(Data(Restrict(smooth_ghi,subset(temp,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp,k))))-(thetamean)-0.2,'color','c','linewidth',2)
            a=log(Data(Restrict(smooth_ghi,subset(temp2,k))))-(gammamean);
            b=log(Data(Restrict(smooth_Theta,subset(temp2,k))))-(thetamean)-0.2;
        end
    
    temp=AbortTrans{3};temp=dropShortIntervals(temp,0.5e4);
    temp2=intervalSet(Start(temp)-1.5e4,Stop(temp)+1.5e4);
    for k=9
        hold on
        plot(log(Data(Restrict(smooth_ghi,subset(temp2,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp2,k))))-(thetamean)+0.1,'color',[0.2 0.6 0.5], 'linewidth',4)
        plot(log(Data(Restrict(smooth_ghi,subset(temp,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp,k))))-(thetamean)+0.1,'g','linewidth',2)
        a=log(Data(Restrict(smooth_ghi,subset(temp2,k))))-(gammamean);
        b=log(Data(Restrict(smooth_Theta,subset(temp2,k))))-(thetamean)+0.15;
    end
    
end


%Gamma
% Look at autocorrelograms
Titres={'CrossCorr WtoS with WtoW','CrossCorr StoW with StoS'}
binsz=2;
totdur=200;
smoofact=2;
for mm=1:15
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
    g=shadedErrorBar(B/1e3,(mean(reshape([Tot{k,:}],length(C),15)')),[stdError(((reshape([Tot{k,:}],length(C),15)')))])
    title(Titres{k})
    ylim([0 0.04])
end

% How many transitions have at least one aborted transition in the
% preceeding 20s
clear Strt
for mm=1:15
    mm
    cd(filename2{mm})
    load('TransLimsGam.mat')
    for i=[2,3]
        AbortTrans{i}=dropShortIntervals(AbortTrans{i},1e4);
    end

    Strt{1,mm}=Start(AbortTrans{3});
    Strt2=Start(AbortTrans{1});
    for k=1:length(Strt{1,mm})
       Strt{1,mm}(k)=length(find(Strt2<Strt{1,mm}(k) & Strt2>Strt{1,mm}(k)-20*1e4));
    end
    
    Strt{2,mm}=Start(AbortTrans{2});
    Strt2=Start(AbortTrans{4});
     for k=1:length(Strt{2,mm})
       Strt{2,mm}(k)=length(find(Strt2<Strt{2,mm}(k) & Strt2>Strt{2,mm}(k)-20*1e4));
    end
end

Vals2=[];
for mm=1:15
Vals2=[Vals2;(Strt{2,mm}>0)];
end
Vals1=[];
for mm=1:15
Vals1=[Vals1;(Strt{1,mm}>0)];
end

%Same for EMG
% Look at autocorrelograms
Titres={'CrossCorr WtoS with WtoW','CrossCorr StoW with StoS'}
totdur=200;
smoofact=2;
nn=1;
clear Tot
for mm=1:6
        cd(filename{mm})
        load('TransLimsEMG.mat')   
        for i=1:4
        AbortTrans{i}=dropShortIntervals(AbortTrans{i},0.2e4);
    end
    num=1;
    
    [C,B]=CrossCorr(Start(AbortTrans{3}),Start( AbortTrans{1}),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    Tot{num,nn}=C/sum(C);
    
    num=2;
    [C,B]=CrossCorr(Start(AbortTrans{2}),Start(AbortTrans{4}),binsz*1e3,totdur/binsz);
    C=runmean(C,smoofact);
    Tot{num,nn}=C/sum(C);
    nn=nn+1;
 end
    


figure
for k=1:2
    subplot(1,2,k)
    g=shadedErrorBar(B/1e3,(mean(reshape([Tot{k,:}],length(C),nn-1)')),[stdError(((reshape([Tot{k,:}],length(C),nn-1)')))])
    title(Titres{k})
    ylim([0 0.03])
end

% How many transitions have at least one aborted transition in the
% preceeding 20s
clear Strt
for mm=1:6
    mm
    cd(filename{mm})
        load('TransLimsEMG.mat')   
    for i=[2,3]
        AbortTrans{i}=dropShortIntervals(AbortTrans{i},1e4);
    end

    Strt{1,mm}=Start(AbortTrans{3});
    Strt2=Start(AbortTrans{1});
    for k=1:length(Strt{1,mm})
       Strt{1,mm}(k)=length(find(Strt2<Strt{1,mm}(k) & Strt2>Strt{1,mm}(k)-20*1e4));
    end
    
    Strt{2,mm}=Start(AbortTrans{2});
    Strt2=Start(AbortTrans{4});
     for k=1:length(Strt{2,mm})
       Strt{2,mm}(k)=length(find(Strt2<Strt{2,mm}(k) & Strt2>Strt{2,mm}(k)-20*1e4));
    end
end

Vals2=[];
for mm=1:6
Vals2=[Vals2;(Strt{2,mm}>0)];
end
Vals1=[];
for mm=1:6
Vals1=[Vals1;(Strt{1,mm}>0)];
end

