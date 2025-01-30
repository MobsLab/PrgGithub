figure
cols=copper(16);
num=1;
clear sm_ghi
for chB=[10,13,5,2,6,1,7,0,4,3,8,15,9,14,11,12]
    chB
smootime=3;
load(strcat('LFPData/LFP',num2str(chB),'.mat'));


% find gamma epochs
disp(' ');
disp('... Creating Gamma Epochs ');
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
sm_ghi{num}=Data(Restrict(smooth_ghi,Epoch));
num=num+1;
end

clear peak gamma_thresh
for nn=1:num-1
    clf
[Y,X]=hist(log(sm_ghi{nn}),1000);
Y=Y/sum(Y);
st_ = [1.07e-2 0 0.101 3.49e-3 1.5 0.21];
[cf2,goodness2]=createFit2gauss(X,Y,[]);
a= coeffvalues(cf2);
b=intersect_gaussians(a(2), a(5), a(3), a(6));
[~,ind]=max(Y);
gamma_thresh{nn}=b(b>X(ind));
peak{nn}=a(2);


plot(X,Y)
hold on
h_ = plot(cf2,'fit',0.95);
set(h_(1),'Color',[1 0 0],...
    'LineStyle','-', 'LineWidth',2,...
    'Marker','none', 'MarkerSize',6);
try
line([(gamma_thresh{nn}) (gamma_thresh{nn})],[0 max(Y)],'linewidth',4,'color','R')
line([(peak{nn}) (peak{nn})],[0 max(Y)],'linewidth',4,'color','m')
in=input('happy? 1/0 ');
catch
    in=0;
end


if in==0
    disp('Please show me where the two peaks are')
    [peaksX,peaksY]=(ginput(2));
    [cf2,goodness2]=createFit2gauss(X,Y,[peaksY(1) peaksX(1) abs(peaksX(1)-peaksX(2))/2 peaksY(2) peaksX(2) abs(peaksX(1)-peaksX(2))/2]);
    h_ = plot(cf2,'fit',0.95);
    set(h_(1),'color',[0 1 0],...
        'LineStyle','-', 'LineWidth',2,...
        'Marker','none', 'MarkerSize',6);
    a= coeffvalues(cf2);
    b=intersect_gaussians(a(2), a(5), a(3), a(6));
    [~,ind]=max(Y);
    gamma_thresh{nn}=b(b>X(ind));
    peak{nn}=a(2);
    line([(gamma_thresh{nn}) (gamma_thresh{nn})],[0 max(Y)],'linewidth',4,'color','g')
    in=input('happy? 1/0 ');
    
end
        peak{nn}=mean(sm_ghi{nn}(sm_ghi{nn}<exp((gamma_thresh{nn})));
        line([(peak{nn}) (peak{nn})],[0 max(Y)],'linewidth',4,'color','y')

end

figure
for nn=1:num-1
    peak{nn}=log(mean(sm_ghi{nn}(sm_ghi{nn}<exp((gamma_thresh{nn})))));
[Y,X]=hist(log(sm_ghi{nn}),1000);
Y=Y/sum(Y);
plot(X-(peak{nn}),smooth(Y,2),'color',cols(nn,:),'linewidth',1)
hold on
line([(gamma_thresh{nn})-(peak{nn}) (gamma_thresh{nn})-(peak{nn})],[0 max(Y)],'linewidth',1,'color',cols(nn,:))
pause
end

clear Y
for nn=1:num-1
    peak{nn}=log(mean(sm_ghi{nn}(sm_ghi{nn}<exp((gamma_thresh{nn})))));
    [Y(nn,:),X]=hist(log(sm_ghi{nn})-(peak{nn}),[-1:0.1:2.5]);
end

