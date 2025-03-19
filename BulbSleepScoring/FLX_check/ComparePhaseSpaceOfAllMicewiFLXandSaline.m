%% Code used for april 11th draft
clear all, close all
Mice = [666,667,668,669];
for mm=1:4
    FileName{mm} = {
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180222_Day_saline',
        '/media/DataMOBsRAIDN/ProjectEmbReact/FLX_Ctrl_exp/MouseX/20180223_Day_fluoxetine'};
        FileName{mm} = strrep(FileName{mm},'MouseX',['Mouse',num2str(Mice(mm))]);
end


size_occ=100;
tot_occ=zeros(size_occ,size_occ);
inpercent=[0:0.05:1];
MatX=[-1:4/99:3];
MatY=[-2:4/99:2];

for mm=1:4
    for ep = 1:2
        cd(FileName{mm}{ep})
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
            GThresh{mm}(ep)=log(gamma_thresh)-nanmean(log(Data(Restrict(ghi_new,SWSEpoch))));
            TThresh{mm}(ep)=log(theta_thresh)-nanmean(log(Data(Restrict(theta_new,SWSEpoch))));
            
            ghi_new=tsd(Range(ghi_new),log(Data(ghi_new))-nanmean(log(Data(Restrict(ghi_new,SWSEpoch)))));
            theta_new=tsd(Range(theta_new),log(Data(theta_new))-nanmean(log(Data(Restrict(theta_new,SWSEpoch)))));
            
            [Yg{mm}{ep},Xg{mm}{ep}]=hist(Data(ghi_new),MatX);
            [Yt{mm}{ep},Xt{mm}{ep}]=hist(Data(Restrict(theta_new,sleepper)),MatY);
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
                
                for y=2
                    intdat_g=Data(Restrict(ghi_new,and(Epoch3{k},SubEpochC{k,length(inpercent)-y})));
                    intdat_t=Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,and(Epoch3{k},SubEpochC{k,length(inpercent)-y}))))));
                    K=convhull(intdat_g,intdat_t);
                    Cont{mm,k,y}{ep}(1,:)=intdat_g(K);
                    Cont{mm,k,y}{ep}(2,:)=intdat_t(K);
                end
            end
            MatX=[-1:4/99:3];
            MatY=[-2:4/99:2];
            [sp_occtemp,x,y] = hist2d(Data(ghi_new),Data(theta_new),MatX,MatY);
            sp_occ{mm}{ep}=sp_occtemp;
            
        end
    end
end


figure
tot_occ=zeros(100,100);
for file=1:4
    try
        tot_occ=tot_occ+sp_occ{file}{1}/sum(sum(sp_occ{file}{1}));
    end
end

subplot(3,3,[2,3,5,6])
imagesc(MatX,MatY,log(tot_occ')),axis xy
hold on
colormap(paruly)
ylim([-1.2 2]), xlim([-0.7 2.5])
for file=1:4
    
    subplot(3,3,[2,3,5,6])
    plot(Cont{file,1,2}{1}(1,:),Cont{file,1,2}{1}(2,:),'color',[0.6 .6 .6],'linewidth',3), hold on
    plot(Cont{file,2,2}{1}(1,:),Cont{file,2,2}{1}(2,:),'color',[.6 .6 .6],'linewidth',3)
    plot(Cont{file,3,2}{1}(1,:),Cont{file,3,2}{1}(2,:),'color',[0.6 0.6 0.6],'linewidth',3)
    subplot(3,3,[8,9])
    st_ = [1.0e-2 Xg{file}{1}(find(Yg{file}{1}==max(Yg{file}{1}))) 0.101 5e-3 Xg{file}{1}(find(Yg{file}{1}==max(Yg{file}{1})))+1 0.21];
    [cf2,goodness2]=createFit2gauss(Xg{file}{1},Yg{file}{1}/sum(Yg{file}{1}),st_);
    d=([min(Xg{file}{1}):max(Xg{file}{1})/1000:max(Xg{file}{1})]);a= coeffvalues(cf2);
    Y1=normpdf(d,a(2),a(3));
    Y2=normpdf(d,a(5),a(6));
    % plot(d,Y1/sum(Y1),'color',[0.6 0.6 0.6],'linewidth',2), hold on
    % plot(d,Y2/sum(Y2),'color',[0.6 0.6 0.6],'linewidth',2)
    plot(Xg{file}{1},Yg{file}{1}/sum(Yg{file}{1}(Xg{file}{1}<0.5)),'color',[0.6 0.6 0.6],'linewidth',1), hold on
    plot(GThresh{file}(1),0.18*file/4,'*','color',[0.6 0.6 0.6])
    subplot(3,3,[1,4])
    plot(Yt{file}{1}/sum(Yt{file}{1}),Xt{file}{1},'color',[0.6 0.6 0.6],'linewidth',1), hold on
    plot(0.06*file/4,TThresh{file}(1),'k*','color',[0.6 0.6 0.6])    
end
subplot(3,3,[2,3,5,6])
set(gca,'TickLength',[0 0],'XTick',[],'YTick',[])


FactDarker = 0.7;
subplot(3,3,[2,3,5,6])
hold on
colormap(paruly)
ylim([-1.2 2]), xlim([-0.7 2.5])
for file=1:4
    
    subplot(3,3,[2,3,5,6])
    plot(Cont{file,1,2}{2}(1,:),Cont{file,1,2}{2}(2,:),'color','k','linewidth',3), hold on
    plot(Cont{file,2,2}{2}(1,:),Cont{file,2,2}{2}(2,:),'color','k','linewidth',3)
    plot(Cont{file,3,2}{2}(1,:),Cont{file,3,2}{2}(2,:),'color','k','linewidth',3)
    subplot(3,3,[8,9])
    st_ = [1.0e-2 Xg{file}{2}(find(Yg{file}{2}==max(Yg{file}{2}))) 0.101 5e-3 Xg{file}{2}(find(Yg{file}{2}==max(Yg{file}{2})))+1 0.21];
    [cf2,goodness2]=createFit2gauss(Xg{file}{2},Yg{file}{2}/sum(Yg{file}{2}),st_);
    d=([min(Xg{file}{2}):max(Xg{file}{2})/1000:max(Xg{file}{2})]);a= coeffvalues(cf2);
    Y1=normpdf(d,a(2),a(3));
    Y2=normpdf(d,a(5),a(6));
    % plot(d,Y1/sum(Y1),'color',[0.6 0.6 0.6],'linewidth',2), hold on
    % plot(d,Y2/sum(Y2),'color',[0.6 0.6 0.6],'linewidth',2)
    plot(Xg{file}{2},Yg{file}{2}/sum(Yg{file}{2}(Xg{file}{2}<0.5)),'color','k','linewidth',1), hold on
    plot(GThresh{file}(1),0.18*file/4-0.02,'k+')
    subplot(3,3,[1,4])
    plot(Yt{file}{2}/sum(Yt{file}{2}),Xt{file}{2},'color','k','linewidth',1), hold on
    plot((0.06*file/4)-0.005,TThresh{file}(2),'k+')
    
    
end
subplot(3,3,[2,3,5,6])
set(gca,'TickLength',[0 0],'XTick',[],'YTick',[])
