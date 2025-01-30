%% Code used for april 11th draft
clear all, close all
AllSlScoringMice


size_occ=100;
tot_occ=zeros(size_occ,size_occ);
inpercent=[0:0.05:1];
MatX=[-1:4/99:3];
MatY=[-2:4/99:2];

for file=1:m
    try
        file/m
        cd(filename2{file})
        clear Epoch smooth_Theta smooth_ghi
        load('StateEpochSB.mat');
        if sum((Stop(SWSEpoch)-Start(SWSEpoch))/1e4)/60>60 & sum((Stop(Wake)-Start(Wake))/1e4)/60>60
            if exist('Epoch')
                smooth_Theta=Restrict(smooth_Theta,Epoch);
                smooth_ghi=Restrict(smooth_ghi,Epoch);
            end
            [C,I]=min([max(Range(smooth_Theta)),max(Range(smooth_ghi))]);
            smooth_Theta=Restrict(smooth_Theta,intervalSet(0,C));
            t=(Range(smooth_Theta));
            ti=t(5:100:end);
            time=ts(ti);
            TotalEpoch=intervalSet(0,max(ti))-NoiseEpoch-GndNoiseEpoch;
            smooth_Theta=Restrict(smooth_Theta,TotalEpoch);
            smooth_ghi=Restrict(smooth_ghi,TotalEpoch);
            
            theta_new=Restrict(smooth_Theta,time);
            ghi_new=Restrict(smooth_ghi,time);
            ghi_new=tsd(Range(theta_new),Data(ghi_new));
            %center on slow wave sleep
            GThresh{file}=log(gamma_thresh)-nanmean(log(Data(Restrict(ghi_new,SWSEpoch))));
            TThresh{file}=log(theta_thresh)-nanmean(log(Data(Restrict(theta_new,SWSEpoch))));
            
            ghi_new=tsd(Range(ghi_new),log(Data(ghi_new))-nanmean(log(Data(Restrict(ghi_new,SWSEpoch)))));
            theta_new=tsd(Range(theta_new),log(Data(theta_new))-nanmean(log(Data(Restrict(theta_new,SWSEpoch)))));
            
            [Yg{file},Xg{file}]=hist(Data(ghi_new),MatX);
            [Yt{file},Xt{file}]=hist(Data(Restrict(theta_new,sleepper)),MatY);
            Epoch3{1}=SWSEpoch;
            Epoch3{2}=REMEpoch;
            Epoch3{3}=Wake;
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
                    intdat_g=Data(Restrict(ghi_new,And(Epoch3{k},SubEpochC{k,length(inpercent)-y})));
                    intdat_t=Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,And(Epoch3{k},SubEpochC{k,length(inpercent)-y}))))));
                    K=convhull(intdat_g,intdat_t);
                    Cont{file,k,y}(1,:)=intdat_g(K);
                    Cont{file,k,y}(2,:)=intdat_t(K);
                end
            end
            MatX=[-1:4/99:3];
            MatY=[-2:4/99:2];
            [sp_occtemp,x,y] = hist2d(Data(ghi_new),Data(theta_new),MatX,MatY);
            sp_occ{file}=sp_occtemp;
        else
            file
        end
    end
end



figure
tot_occ=zeros(100,100);
for file=1:m
    try
        tot_occ=tot_occ+sp_occ{file}/sum(sum(sp_occ{file}));
    end
end
subplot(3,3,[2,3,5,6])
imagesc(x,y,log(tot_occ')),axis xy
hold on
colormap(paruly)
ylim([-1.2 2]), xlim([-0.7 2.5])
for file=1:m
    
    subplot(3,3,[2,3,5,6])
    plot(Cont{file,1,2}(1,:),Cont{file,1,2}(2,:),'color',[0.4 0.5 1],'linewidth',2), hold on
    plot(Cont{file,2,2}(1,:),Cont{file,2,2}(2,:),'color',[1 0.2 0.2],'linewidth',2)
    plot(Cont{file,3,2}(1,:),Cont{file,3,2}(2,:),'color',[0.6 0.6 0.6],'linewidth',2)
    subplot(3,3,[8,9])
    st_ = [1.0e-2 Xg{file}(find(Yg{file}==max(Yg{file}))) 0.101 5e-3 Xg{file}(find(Yg{file}==max(Yg{file})))+1 0.21];
    [cf2,goodness2]=createFit2gauss(Xg{file},Yg{file}/sum(Yg{file}),st_);
    d=([min(Xg{file}):max(Xg{file})/1000:max(Xg{file})]);a= coeffvalues(cf2);
    Y1=normpdf(d,a(2),a(3));
    Y2=normpdf(d,a(5),a(6));
    % plot(d,Y1/sum(Y1),'color',[0.6 0.6 0.6],'linewidth',2), hold on
    % plot(d,Y2/sum(Y2),'color',[0.6 0.6 0.6],'linewidth',2)
    plot(Xg{file},Yg{file}/sum(Yg{file}(Xg{file}<0.5)),'color',[0.6 0.6 0.6],'linewidth',1), hold on
    plot(GThresh{file},0.17*file/m,'k*')
    subplot(3,3,[1,4])
    plot(Yt{file}/sum(Yt{file}),Xt{file},'color',[0.6 0.6 0.6],'linewidth',1), hold on
    plot(0.07*file/m,TThresh{file},'k*')
    
    
end
subplot(3,3,[2,3,5,6])
set(gca,'TickLength',[0 0],'XTick',[],'YTick',[])


save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/PhaseSpaceAllMice.mat','Cont','sp_occ','Xg','Yg','Xt','Yt')