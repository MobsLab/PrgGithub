


load('SleepScoring_OBGamma.mat')
load('behavResources.mat', 'MovAcctsd')

Acc_Wake=Restrict(MovAcctsd,Wake);

% defining quiet epoch, <4e7 accelero & >10s
logDataWake = log10(Data(Acc_Wake)); logDataWake(logDataWake==-Inf)=0;
New_Acc_Wake=tsd(Range(Acc_Wake),runmean(logDataWake,1000));
thresh=GetGaussianThresh_BM(Data(New_Acc_Wake));
Quiet_Wake=thresholdIntervals(New_Acc_Wake,10^(thresh),'Direction','Below');
Quiet_Wake=dropShortIntervals(Quiet_Wake,10*1e4);
Quiet_Wake=mergeCloseIntervals(Quiet_Wake,5*1e4);
Active_Wake = Wake-Quiet_Wake;



sum(Stop(Quiet_Wake)-Start(Quiet_Wake))/sum(Stop(Wake)-Start(Wake))


New_Acc_Wake=tsd(Range(Acc_Wake),runmean(Data(Acc_Wake),1000));
thresh=GetGaussianThresh_BM(Data(New_Acc_Wake));


clear all
load('StateEpochSB.mat', 'Wake')
load('behavResources.mat', 'MovAcctsd')
Acc_Wake=Restrict(MovAcctsd,Wake);

n=1;
for run_val = linspace(3,4.5,12)
    
    Data_to_use = runmean(Data(Acc_Wake) , round(10^(run_val)));
    subplot(3,4,n)
    [Y,X]=hist(log10(Data_to_use),1000);
    Y=Y/sum(Y);
    [cf2,goodness2]=createFit2gauss(X,Y,[]);
    a= coeffvalues(cf2);
    b=intersect_gaussians(a(2), a(5), a(3), a(6));
    
    thresh=b(find(b>a(2)&b<a(5)));
    plot(X,Y); %xlim([6 9])
    hold on
    h_ = plot(cf2,'fit',0.95);
    set(h_(1),'Color',[1 0 0],...
        'LineStyle','-', 'LineWidth',2,...
        'Marker','none', 'MarkerSize',6);
    n=n+1;
    
end


