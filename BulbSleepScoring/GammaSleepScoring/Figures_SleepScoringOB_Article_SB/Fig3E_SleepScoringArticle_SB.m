%% This code is used for 11th april draft

%% Compare separation of distributions

clear all, close all
% Load Mice File Names
AllSlScoringMice_SleepScoringArticle_SB

clear DurG DurE

% Gamma
for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat','smooth_ghi')%    e
    [YG{1,mm},XG{1,mm}]=hist(Data(smooth_ghi),500);
    [YG{2,mm},XG{2,mm}]=hist(log(Data(smooth_ghi)),500);
    
end

%EMG
nn=1;
for mm=1:m
    if ismember(mm,GoodForEMG)
        cd(filename2{mm})
        load('StateEpochEMGSB.mat','EMGData')%
        [YE{1,nn},XE{1,nn}]=hist(Data(EMGData),500);
        [YE{2,nn},XE{2,nn}]=hist(log(Data(EMGData)),500);
        nn=nn+1;
    end
end

% Peak to peak distance
% Goodness of fit for 2 gaussians
% Ashman's D
% How much overlap
% Excess intermdiary

%Gamma
k=2;
in=0;
for i=1:m
    [cf2,goodness2,output]=createFit2gaussWiOutPut(XG{k,i},(YG{k,i})/sum((YG{k,i})));
    if i==2
    plot(XG{k,i},YG{k,i}/sum(YG{k,i})),hold on
    plot(cf2)
    goodness2
    in=input('happy? 1/0 ');
    
    if in==0
        disp('Please show me where the two peaks are')
        [peaksX,peaksY]=(ginput(2));
        [cf2,goodness2,output]=createFit2gaussWiOutPut(XG{k,i},(YG{k,i})/sum((YG{k,i})),[peaksY(1) peaksX(1) abs(peaksX(1)-peaksX(2))/2 peaksY(2) peaksX(2) abs(peaksX(1)-peaksX(2))/2]);
        clf
        plot(XG{k,i},YG{k,i}/sum(YG{k,i})),hold on
        plot(cf2)
        goodness2
    end
    pause(3)
    clf
    end
    % goodness of fits
    Val(i,1)=goodness2.sse;
    Val(i,2)=goodness2.rsquare;
    Val(i,3)=goodness2.adjrsquare;
    Val(i,4)=goodness2.rmse;
    % distance between peaks
    a= coeffvalues(cf2);
    % overlap
    d=([min(XG{k,i}):max(XG{k,i})/1000:max(XG{k,i})]);
    Y1=normpdf(d,a(2),max(a(3)/sqrt(2),mean(diff(d))));
    Y2=normpdf(d,a(5),max(a(6)/sqrt(2),mean(diff(d))));
    Val(i,5)=sum(min(Y1,Y2)*mean(diff(d)));
    Val(i,6)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
    Val(i,7)=sum(abs(output.residuals(find(XG{k,i}<a(2),1,'last'):find(XG{k,i}>a(5),1,'first'))))./sum(abs(YG{k,i}/sum(YG{k,i})));
end


nn=1;
for i=1:m
    if ismember(i,GoodForEMG)
        [cf2,goodness2,output]=createFit2gaussWiOutPut(XE{k,nn},(YE{k,nn})/sum((YE{k,nn})));
        
        
        % goodness of fits
        Val1(nn,1)=goodness2.sse;
        Val1(nn,2)=goodness2.rsquare;
        Val1(nn,3)=goodness2.adjrsquare;
        Val1(nn,4)=goodness2.rmse;
        % distance between peaks
        a= coeffvalues(cf2);
        % overlap
        d=([min(XE{k,nn}):max(XE{k,nn})/1000:max(XE{k,nn})]);
        Y1=normpdf(d,a(2),max(a(3)/sqrt(2),mean(diff(d))));
        Y2=normpdf(d,a(5),max(a(6)/sqrt(2),mean(diff(d))));
        Val1(nn,5)=sum(min(Y1,Y2)*mean(diff(d)));
        Val1(nn,6)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
        Val1(nn,7)=sum(abs(output.residuals(find(XE{k,nn}<a(2),1,'last'):find(XE{k,nn}>a(5),1,'first'))))./sum(abs(YE{k,nn}/sum(YE{k,nn})));
        nn=nn+1;
    end
end



%% Get quality of REM fits
for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat','smooth_Theta','sleepper','theta_thresh')%     %Find transition zone
    [YG{1,mm},XG{1,mm}]=hist(Data(smooth_Theta),500);
    [YG{2,mm},XG{2,mm}]=hist(log(Data(Restrict(smooth_Theta,sleepper))),500);
    Threshold(mm)=log(theta_thresh);
end

k=2;
for i=1:m
    ind=find(XG{k,i}>log(theta_thresh),1,'first');
    X=XG{k,i}(1:ind);
    Y=YG{k,i}(1:ind);
    
    
    [cf2,goodness2,output]=createFit1gauss(X,Y/sum(Y));
    plot(X,Y/sum(Y)),hold on
    plot(cf2)
    pause
    % goodness of fits
    ValT(i,1)=goodness2.sse;
    ValT(i,2)=goodness2.rsquare;
    ValT(i,3)=goodness2.adjrsquare;
    ValT(i,4)=goodness2.rmse;
    hold off
end
save('/media/DataMOBsRAIDN/ProjetSlSc/AnalysisResults/ResultsPapier/GoodnessOfFits.mat','Val','Val1','ValT')

%%%%%
load('/media/DataMOBsRAIDN/ProjetSlSc/AnalysisResults/ResultsPapier/GoodnessOfFits.mat')


Parameters={'sse','R2','AdjR2','rmse','overlap','Asman''s D','unaccounted vals in mid'}

figure
for i=1:7
    subplot(3,3,i)
    bar([nanmean(Val(:,i)),nanmean(Val1(:,i))],'k');
    hold on
    errorbar([1,2],[nanmean(Val(:,i)),nanmean(Val1(:,i))],[stdError(Val(:,i)),stdError(Val1(:,i))],'.k');
    [h,p]=ttest2(Val(:,i),Val1(:,i));
    sigstar({[1,2]},p)
    title(Parameters{i})
    set(gca,'XTickLabel',{'Gamma','EMG'})
end

figure
k=1;
for i=[6,2,4,7]
    subplot(2,2,k)
    bar([nanmean(Val(:,i)),nanmean(Val1(:,i))],'k');
    hold on
    errorbar([1,2],[nanmean(Val(:,i)),nanmean(Val1(:,i))],[stdError(Val(:,i)),stdError(Val1(:,i))],'.k');
    [h,p]=ttest2(Val(:,i),Val1(:,i));
    sigstar({[1,2]},p)
    p
    title(Parameters{i})
    set(gca,'XTickLabel',{'Gamma','EMG'})
    k=k+1;
end


