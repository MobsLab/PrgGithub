downsamplefact = 500;
timepoints = Range(smooth_Theta);
timepoints = timepoints(1:downsamplefact:end);

smooth_Theta = Restrict(smooth_Theta,ts(timepoints))
smooth_ghi = Restrict(smooth_ghi,ts(timepoints))
plot(log(Data(smooth_ghi)),log(Data(smooth_Theta)),'.')
hold on
plot(log(Data(Restrict(smooth_ghi,Epoch{1}))),log(Data(Restrict(smooth_Theta,Epoch{1}))),'r.')
plot(log(Data(Restrict(smooth_ghi,Epoch{2}))),log(Data(Restrict(smooth_Theta,Epoch{2}))),'k.')
plot(log(Data(Restrict(smooth_ghi,Epoch{3}))),log(Data(Restrict(smooth_Theta,Epoch{3}))),'g.')
MatX=[-1:4/99:3];
MatY=[-2:4/99:2];

[sp_occtemp,x,y] = hist2d((Data(Restrict(smooth_ghi,Epoch{3}))),(Data(Restrict(smooth_Theta,Epoch{3}))),50,50);

inpercent=[0:0.05:1];

Epoch3{1}=SWSEpoch;
Epoch3{2}=REMEpoch;
Epoch3{3}=Wake;
theta_new = smooth_Theta;
ghi_new = smooth_ghi;
%  Get the contours and concentric regions
for k=1:3
    intdat_g=Data(Restrict(ghi_new,Epoch3{k}));
    intdat_t=Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,Epoch3{k})))));
    cent=[nanmean(intdat_g),nanmean(intdat_t)];
    distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
    dist=tsd(Range(Restrict(ghi_new,Epoch3{k})),distances);
    for i=1:length(inpercent)
        threshold=percentile(distances,inpercent(i));
        SubEpochC{k,i}=thresholdIntervals(dist,threshold,'Direction','Below');
    end
    
    for y=1:4
        intdat_g=Data(Restrict(ghi_new,and(Epoch3{k},SubEpochC{k,length(inpercent)-y})));
        intdat_t=Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,and(Epoch3{k},SubEpochC{k,length(inpercent)-y}))))));
        K=convhull(intdat_g,intdat_t);
        Cont{1,k,y}(1,:)=intdat_g(K);
        Cont{1,k,y}(2,:)=intdat_t(K);
    end
end
figure
for k = [1:5,7]
subplot(2,4,k)
[sp_occtemp,x,y] = hist2d((Data(Restrict(smooth_ghi,Epoch{k}))),(Data(Restrict(smooth_Theta,Epoch{k}))),50,50);
imagesc(x,y,sp_occtemp)
X = nanmean((Data(Restrict(smooth_ghi,Epoch{k}))));
Y = nanmean((Data(Restrict(smooth_Theta,Epoch{k}))));
axis xy

hold on
    plot(Cont{1,1,2}(1,:),Cont{1,1,2}(2,:),'color',[0.4 0.5 1],'linewidth',2), hold on
    plot(Cont{1,2,2}(1,:),Cont{1,2,2}(2,:),'color',[1 0.2 0.2],'linewidth',2)
    plot(Cont{1,3,2}(1,:),Cont{1,3,2}(2,:),'color',[0.6 0.6 0.6],'linewidth',2)
    plot(X,Y,'+')

end