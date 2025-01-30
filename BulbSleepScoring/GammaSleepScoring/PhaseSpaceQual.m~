clear all
close all

%% Look at superposition of phase spaces and theta distributions in and out of sleep
struc={'B','H','Pi','PF','Pa','PFSup','PaSup','Amyg'};
clear todo chan dataexis
m=1;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[1,10,NaN,4,13,6,2,NaN];

m=2;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[2,9,NaN,10,7,8,3,NaN];

m=3;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[6,10,NaN,5,13,1,7,NaN];

m=4;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D1/LPSD1-Mouse-123-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,1,1,1];
chan(m,:)=[15,6,0,4,9,12,NaN,3];

m=5;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD1/LPSD1-Mouse-124-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,0,0,1];
chan(m,:)=[11,2,12,8,4,15,NaN,15];

size_occ=100;
tot_occ=zeros(size_occ,size_occ);
tot_occ_sep=zeros(size_occ,size_occ);
totsp_occ=zeros(size_occ,size_occ);
totsp_lfp_occ=zeros(size_occ,size_occ);
tot_del1_occ=zeros(size_occ,size_occ);
tot_del2_occ=zeros(size_occ,size_occ);
inpercent=[0:0.05:1];
sp=figure;
splfp=figure;
dens=figure;
deltapow=figure;

for file =1:5
    cd(filename2{file})
    
    load('StateEpoch.mat','Mmov')
    load('StateEpochSB.mat')
    load('Oscillations.mat')
    t=Range(smooth_Theta);
    ti=t(5:100:end);
    time=ts(ti);
    theta_new=Restrict(smooth_Theta,time);
    ghi_new=Restrict(smooth_ghi,time);
    ghi_new=tsd(Range(theta_new),Data(ghi_new));
    
    %center on slow wave sleep
    ghi_new=tsd(Range(ghi_new),log(Data(ghi_new))-nanmean(log(Data(Restrict(ghi_new,SWSEpoch)))));
    theta_new=tsd(Range(theta_new),log(Data(theta_new))-nanmean(log(Data(Restrict(theta_new,SWSEpoch)))));
    
    TotalEpoch=intervalSet(0,max(ti))-NoiseEpoch-GndNoiseEpoch;
    try
        load('behavRousources.mat','PreEpoch')
        TotalEpoch=And(TotalEpoch,PreEpoch);
    end
   
    
    Epoch3{1}=SWSEpoch;
    Epoch3{2}=REMEpoch;
    Epoch3{3}=Wake;
    %  Get the contours and concentric regions
    for k=1:3
        k
        
        intdat_g=Data(Restrict(ghi_new,Epoch3{k}));
        intdat_t=Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,Epoch3{k})))));
        cent=[nanmean(intdat_g),nanmean(intdat_t)];
        distances=(intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
        dist=tsd(Range(Restrict(ghi_new,Epoch3{k})),distances);
        for i=1:length(inpercent)
            threshold=percentile(distances,inpercent(i));
            SubEpochC{k,i}=thresholdIntervals(dist,threshold,'Direction','Below');
        end
        distances=intdat_g-cent(1);
        dist=tsd(Range(Restrict(ghi_new,Epoch3{k})),distances);
        for i=1:length(inpercent)
            threshold=percentile(distances,inpercent(i));
            SubEpochLG{k,i}=thresholdIntervals(dist,threshold,'Direction','Below');
        end
        distances=intdat_t-cent(2);
        dist=tsd(Range(Restrict(theta_new,Epoch3{k})),distances);
        for i=1:length(inpercent)
            threshold=percentile(distances,inpercent(i));
            SubEpochLT{k,i}=thresholdIntervals(dist,threshold,'Direction','Below');
        end
        intdat_g=Data(Restrict(ghi_new,And(Epoch3{k},SubEpochC{k,length(inpercent)-1})));
        intdat_t=Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,And(Epoch3{k},SubEpochC{k,length(inpercent)-1}))))));
        K=convhull(intdat_g,intdat_t);
        Cont{file,k}(1,:)=intdat_g(K);
        Cont{file,k}(2,:)=intdat_t(K);
    end
   
     if file==3
        dat=Data(ghi_new);
        dat(dat<1.258 & dat>1.24)=NaN;
        ghi_new=tsd(Range(ghi_new),dat);
        
    end
        %% Density plots
        figure(dens)
        subplot(2,6,file)
        [sp_occ,x,y] = hist2dSB(Data(ghi_new),Data(theta_new),size_occ,size_occ,[-0.5,2.7;-1,2]);
        sp_occ=SmoothDec(sp_occ,[2,2]);
        imagesc(x,y,sp_occ'), axis xy
        colormap hot
        hold on
    for file=1:7
        plot(Cont{file,1}(1,:),Cont{file,1}(2,:),'color',[0.4 0.5 1],'linewidth',2)
        plot(Cont{file,2}(1,:),Cont{file,2}(2,:),'color',[1 0.2 0.2],'linewidth',2)
        plot(Cont{file,3}(1,:),Cont{file,3}(2,:),'color',[0.6 0.6 0.6],'linewidth',2)
    end
        tot_occ=tot_occ+sp_occ/sum(sum(sp_occ));
    
        subplot(2,6,file+6)
        sp_occ_sep=zeros(size_occ,size_occ);
        [sp_occ_int,x,y] = hist2dSB(Data(Restrict(ghi_new,SWSEpoch)),Data(Restrict(theta_new,SWSEpoch)),size_occ,size_occ,[-0.5,2.7;-1,2]);
        sp_occ_sep=sp_occ_sep+sp_occ_int/sum(sum(sp_occ_int));
        [sp_occ_int,x,y] = hist2dSB(Data(Restrict(ghi_new,REMEpoch)),Data(Restrict(theta_new,REMEpoch)),size_occ,size_occ,[-0.5,2.7;-1,2]);
        sp_occ_sep=sp_occ_sep+sp_occ_int/sum(sum(sp_occ_int));
        [sp_occ_int,x,y] = hist2dSB(Data(Restrict(ghi_new,Wake)),Data(Restrict(theta_new,Wake)),size_occ,size_occ,[-0.5,2.7;-1,2]);
        sp_occ_sep=sp_occ_sep+sp_occ_int/sum(sum(sp_occ_int));
        sp_occ_sep=SmoothDec(sp_occ_sep,[2,2]);
        imagesc(x,y,sp_occ_sep'), axis xy
        colormap hot
        tot_occ_sep=tot_occ_sep+sp_occ_sep/sum(sum(sp_occ_sep));
    
    
        %% Weighted by speed of body
        Mmov=tsd(Range(Mmov),Data(Mmov)/sum(Data(Mmov)));
        %comparative histograms
        [HmovWake{file}(2,:),HmovWake{file}(1,:)]=hist(Data(Restrict(Mmov,wakeper-GndNoiseEpoch-NoiseEpoch)),100);
        hold on
        [HmovSleep{file}(2,:),HmovSleep{file}(1,:)]=hist(Data(Restrict(Mmov,sleepper-GndNoiseEpoch-NoiseEpoch)),100);
        % regions around centre
        for k=1:3
            for i=2:length(inpercent)
                speed_regional{file}(k,i)=nanmean(Data(Restrict(Mmov,SubEpochC{k,i}-SubEpochC{k,i-1})));
                speed_regional{file}(k+3,i)=nanmean(Data(Restrict(Mmov,SubEpochLG{k,i}-SubEpochLG{k,i-1})));
                speed_regional{file}(k+6,i)=nanmean(Data(Restrict(Mmov,SubEpochLT{k,i}-SubEpochLT{k,i-1})));
            end
        end
    
    
    
        %% Weighted by LFP speed
        % 2d plot
        figure(splfp)
        speed=([0; Data(ghi_new)]-[Data(ghi_new); 0]).^2+([0; Data(theta_new)]-[Data(theta_new); 0]).^2;
        speed=[NaN;speed(2:end-1)];
        LFP_speed=tsd(Range(ghi_new),speed);
        [sp_LFP_occ,x,y] = weight2d(Data(ghi_new),Data(theta_new),size_occ,size_occ,Data(LFP_speed),[-0.5,2.7;-1,2]);
        sp_LFP_occ(isnan(sp_LFP_occ))=0;
            for k=1:100
                sp_LFP_occ(k,:)=runmean(sp_LFP_occ(k,:),2);
            end
            for k=1:100
                sp_LFP_occ(:,k)=runmean(sp_LFP_occ(:,k),2);
            end
        subplot(1,6,file)
        imagesc(x,y,(sp_LFP_occ)'), axis xy
        colormap hot
        totsp_lfp_occ=totsp_lfp_occ+sp_LFP_occ/sum(sum(sp_LFP_occ));
        % regions around centre
        for k=1:3
            for i=2:length(inpercent)
                speed_LFP_regional{file}(k,i)=nanmean(Data(Restrict(LFP_speed,SubEpochC{k,i}-SubEpochC{k,i-1})));
                speed_LFP_regional{file}(k+3,i)=nanmean(Data(Restrict(LFP_speed,SubEpochLG{k,i}-SubEpochLG{k,i-1})));
                speed_LFP_regional{file}(k+6,i)=nanmean(Data(Restrict(LFP_speed,SubEpochLT{k,i}-SubEpochLT{k,i-1})));
            end
        end
    
        %% Weighted by Delta Power
    
        % 2d plot
        figure(deltapow)
        for j=1:2
            Del1=Restrict(Del{j},Range(ghi_new));
            Del1=tsd(Range(ghi_new),Data(Del1));
            [sp_DEL_occ,x,y] = weight2d(Data(ghi_new),Data(theta_new),size_occ,size_occ,Data(Del1),[-0.5,2.7;-1,2]);
            sp_DEL_occ(isnan(sp_DEL_occ))=0;
            for k=1:100
                sp_DEL_occ(k,:)=runmean(sp_DEL_occ(k,:),2);
            end
            for k=1:100
                sp_DEL_occ(:,k)=runmean(sp_DEL_occ(:,k),2);
            end
            subplot(2,6,file+(j-1)*6);
            imagesc(x,y,sp_DEL_occ'), axis xy
            colormap hot
            if j==1
                tot_del1_occ=tot_del1_occ+sp_DEL_occ/sum(sum(sp_DEL_occ));
            elseif j==2
                tot_del2_occ=tot_del2_occ+sp_DEL_occ/sum(sum(sp_DEL_occ));
            end
    
            % regions around centre
            for k=1:3
                for i=2:length(inpercent)
                    speed_del_regional{file,j}(k,i)=nanmean(Data(Restrict(Del1,SubEpochC{k,i}-SubEpochC{k,i-1})));
                    speed_del_regional{file,j}(k+3,i)=nanmean(Data(Restrict(Del1,SubEpochLG{k,i}-SubEpochLG{k,i-1})));
                    speed_del_regional{file,j}(k+6,i)=nanmean(Data(Restrict(Del1,SubEpochLT{k,i}-SubEpochLT{k,i-1})));
                end
            end
    
        end
    
    
    
        %% Different sleep typical events
        Rapps{file}(1,1)=length(Restrict(Ripples{1},And(Ripples{2},Wake)))/length(Restrict(smooth_ghi,And(Ripples{2},Wake)));
        Rapps{file}(1,2)=length(Restrict(Ripples{1},And(Ripples{2},SWSEpoch)))/length(Restrict(smooth_ghi,And(Ripples{2},SWSEpoch)));
        Rapps{file}(1,3)=length(Restrict(Ripples{1},And(Ripples{2},REMEpoch)))/length(Restrict(smooth_ghi,And(Ripples{2},REMEpoch)));
    
        Rapps{file}(2,1)=length(Restrict(DeltaPa{1},And(DeltaPa{2},Wake)))/length(Restrict(smooth_ghi,And(DeltaPa{2},Wake)));
        Rapps{file}(2,2)=length(Restrict(DeltaPa{1},And(DeltaPa{2},SWSEpoch)))/length(Restrict(smooth_ghi,And(DeltaPa{2},SWSEpoch)));
        Rapps{file}(2,3)=length(Restrict(DeltaPa{1},And(DeltaPa{2},REMEpoch)))/length(Restrict(smooth_ghi,And(DeltaPa{2},REMEpoch)));
    
        Rapps{file}(3,1)=length(Restrict(DeltaPF{1},And(DeltaPF{2},Wake)))/length(Restrict(smooth_ghi,And(DeltaPF{2},Wake)));
        Rapps{file}(3,2)=length(Restrict(DeltaPF{1},And(DeltaPF{2},SWSEpoch)))/length(Restrict(smooth_ghi,And(DeltaPF{2},SWSEpoch)));
        Rapps{file}(3,3)=length(Restrict(DeltaPF{1},And(DeltaPF{2},REMEpoch)))/length(Restrict(smooth_ghi,And(DeltaPF{2},REMEpoch)));
    
        for j=1:4
            Rapps{file}(3+j,1)=length(Restrict(Spindles{j,1},And(Spindles{j,2},Wake)))/length(Restrict(smooth_ghi,And(Spindles{j,2},Wake)));
            Rapps{file}(3+j,2)=length(Restrict(Spindles{j,1},And(Spindles{j,2},SWSEpoch)))/length(Restrict(smooth_ghi,And(Spindles{j,2},SWSEpoch)));
            Rapps{file}(3+j,3)=length(Restrict(Spindles{j,1},And(Spindles{j,2},REMEpoch)))/length(Restrict(smooth_ghi,And(Spindles{j,2},REMEpoch)));
        end
    
    sleepper=And(sleepper,Epoch);
    wakeper=And(wakeper,Epoch);

    a=load('StateEpoch.mat','SWSEpoch','MovEpoch','REMEpoch')
    DiffMeth(file,1)=size(Data(Restrict(smooth_ghi,And(sleepper,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,sleepper)),1);
    DiffMeth(file,2)=size(Data(Restrict(smooth_ghi,And(wakeper,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,wakeper)),1);
    
    DiffMeth(file,3)=size(Data(Restrict(smooth_ghi,And(sleepper,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,sleepper)),1);
    DiffMeth(file,4)=size(Data(Restrict(smooth_ghi,And(wakeper,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,wakeper)),1);
    
    DiffMeth(file,5)=size(Data(Restrict(smooth_ghi,And(MicroWake,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,MicroWake)),1);
    DiffMeth(file,6)=size(Data(Restrict(smooth_ghi,And(MicroWake,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,MicroWake)),1);
    DiffMeth(file,7)=size(Data(Restrict(smooth_ghi,And(MicroWake,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,wakeper)),1);
    DiffMeth(file,8)=size(Data(Restrict(smooth_ghi,And(MicroWake,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,wakeper)),1);
    
    
    DiffMeth(file,9)=size(Data(Restrict(smooth_ghi,And(MicroSleep,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,MicroSleep)),1);
    DiffMeth(file,10)=size(Data(Restrict(smooth_ghi,And(MicroSleep,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,MicroSleep)),1);
    DiffMeth(file,11)=size(Data(Restrict(smooth_ghi,And(MicroSleep,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,sleepper)),1);
    DiffMeth(file,12)=size(Data(Restrict(smooth_ghi,And(MicroSleep,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,sleepper)),1);
    
    stsleep=Start(sleepper);
    stpsleep=Stop(sleepper);
    
    sleep_new=Or(And(intervalSet(Start(sleepper),Start(sleepper)+5*1e4),sleepper),And(intervalSet(Stop(sleepper)-5e4,Stop(sleepper)),sleepper));
    DiffMeth(file,13)=size(Data(Restrict(smooth_ghi,And(sleep_new,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,sleep_new)),1);
    DiffMeth(file,14)=size(Data(Restrict(smooth_ghi,And(sleep_new,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,sleep_new)),1);
    DiffMeth(file,15)=size(Data(Restrict(smooth_ghi,And(sleep_new,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,sleepper)),1);
    DiffMeth(file,16)=size(Data(Restrict(smooth_ghi,And(sleep_new,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,sleepper)),1);
    
    wake_new=Or(And(intervalSet(Start(wakeper),Start(wakeper)+5*1e4),wakeper),And(intervalSet(Stop(wakeper)-5e4,Stop(wakeper)),wakeper));
    DiffMeth(file,17)=size(Data(Restrict(smooth_ghi,And(wake_new,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,wake_new)),1);
    DiffMeth(file,18)=size(Data(Restrict(smooth_ghi,And(wake_new,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,wake_new)),1);
    DiffMeth(file,19)=size(Data(Restrict(smooth_ghi,And(wake_new,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,wakeper)),1);
    DiffMeth(file,20)=size(Data(Restrict(smooth_ghi,And(wake_new,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,wakeper)),1);

    
    DiffMeth(file,21)=size(Data(Restrict(smooth_ghi,And(strSleep,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,strSleep)),1);
    DiffMeth(file,22)=size(Data(Restrict(smooth_ghi,And(strSleep,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,strSleep)),1);
    DiffMeth(file,23)=size(Data(Restrict(smooth_ghi,And(strSleep,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,sleepper)),1);
    DiffMeth(file,24)=size(Data(Restrict(smooth_ghi,And(strSleep,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,sleepper)),1);

    
    DiffMeth(file,25)=size(Data(Restrict(smooth_ghi,And(strWake,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,strWake)),1);
    DiffMeth(file,26)=size(Data(Restrict(smooth_ghi,And(strWake,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,strWake)),1);
    DiffMeth(file,27)=size(Data(Restrict(smooth_ghi,And(strWake,Or(a.SWSEpoch,a.REMEpoch)))),1)/size(Data(Restrict(smooth_ghi,wakeper)),1);
    DiffMeth(file,28)=size(Data(Restrict(smooth_ghi,And(strWake,a.MovEpoch))),1)/size(Data(Restrict(smooth_ghi,wakeper)),1);

end

figure(deltapow)
subplot(2,6,6);
imagesc(x,y,tot_del1_occ'), axis xy
colormap hot

subplot(2,6,12);
imagesc(x,y,tot_del2_occ'), axis xy
colormap hot

figure(splfp)
subplot(1,6,6)
imagesc(x,y,(totsp_lfp_occ)'), axis xy
colormap hot


figure(dens)
subplot(2,6,6)
imagesc(x,y,tot_occ'), axis xy
colormap hot
hold on
for file=1:5
    
    plot(Cont{file,1}(1,:),Cont{file,1}(2,:),'color',[0.4 0.5 1],'linewidth',2)
    plot(Cont{file,2}(1,:),Cont{file,2}(2,:),'color',[1 0.2 0.2],'linewidth',2)
    plot(Cont{file,3}(1,:),Cont{file,3}(2,:),'color',[0.6 0.6 0.6],'linewidth',2)
end
subplot(2,6,12)
imagesc(x,y,tot_occ_sep'), axis xy
colormap hot
hold on
for file=1:5
    
    plot(Cont{file,1}(1,:),Cont{file,1}(2,:),'color',[0.4 0.5 1],'linewidth',2)
    plot(Cont{file,2}(1,:),Cont{file,2}(2,:),'color',[1 0.2 0.2],'linewidth',2)
    plot(Cont{file,3}(1,:),Cont{file,3}(2,:),'color',[0.6 0.6 0.6],'linewidth',2)
end

file=2;
    figure
plot(HmovWake{file}(1,:),HmovWake{file}(2,:)/sum(HmovWake{file}(2,:)),'color',[0.6 0.6 0.6],'linewidth',3)
hold on
plot(HmovSleep{file}(1,:),HmovSleep{file}(2,:)/sum(HmovSleep{file}(2,:)),'color',[104 255 104]/255,'linewidth',3)
box off

for file=1:5
% plot(HmovWake{file}(1,:),HmovWake{file}(2,:)/sum(HmovWake{file}(2,:)))
w(file)= nansum(HmovWake{file}(2,:)'.*HmovWake{file}(1,:)');
s(file)=nansum(HmovSleep{file}(2,:)'.*HmovSleep{file}(1,:)');
% hold on
% plot(HmovSleep{file}(1,:),HmovSleep{file}(2,:)/sum(HmovSleep{file}(2,:)),'r')
end
figure
clf
k1=bar(1,mean(s))
set(k1,'FaceColor',[204 255 204]/255)
hold on
k2=bar(2,mean(w))
set(k2,'FaceColor',[0.6 0.6 0.6])
errorbar([1,2],[mean(s),mean(w)],[stdError(s),stdError(w)],'k.')
xlim([0 3])
p=ranksum(w,s);
if p<0.05 & p>0.01
    plot(1.5,max(max(w,s)),'k*')
elseif p<0.01
        plot(1.5,max(max(w,s)),'k*')
        plot(1.55,max(max(w,s)),'k*')
end


        
%% Weighted by Epoch characteristics (length, dist from transition, dits to transition)

% 2d plot

% regions around centre


%% Weighted by Epoch duration
% 2d plot

% regions around centre


%% Weighted by delta power
% 2d plot

% regions around centre



%% Spindles - Ripples - DeltaWaves


%% Compare time

% Pie charts

% duration of error regions

% locatin of error regions


%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
%Analyse
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

figure



figure
for f=1:20
    plot(f,DiffMeth(:,f),'k.')
    hold on
end

figure
h=pie([mean(DiffMeth(:,1)) ;1-mean(DiffMeth(:,1))]);
set(h(1),'FaceColor',[204 255 204]/255)
set(h(3),'FaceColor',[0.6 0.6 0.6])
figure
needaccount=1-mean(DiffMeth(:,1));
account= mean(DiffMeth(:,12)+DiffMeth(:,15)+DiffMeth(:,24));
h=pie([account/needaccount ;(needaccount-account)/needaccount]);
set(h(1),'FaceColor','k')
set(h(3),'FaceColor','w')

figure
h=pie([mean(DiffMeth(:,2)) ;1-mean(DiffMeth(:,2))]);
set(h(3),'FaceColor',[204 255 204]/255)
set(h(1),'FaceColor',[0.6 0.6 0.6])
figure
needaccount=1-mean(DiffMeth(:,2));
account= mean(DiffMeth(:,8)+DiffMeth(:,20)+DiffMeth(:,27));
h=pie([account/needaccount ;(needaccount-account)/needaccount]);
set(h(1),'FaceColor','k')
set(h(3),'FaceColor','w')



%%%
for file=1:5
   for k=1:4
         spw(file,k)=Rapps{file}(3+k,1);
         sps(file,k)=Rapps{file}(3+k,2);
         spr(file,k)=Rapps{file}(3+k,3);
   end
   del(file,1)=Rapps{file}(2,1);
   del(file,2)=Rapps{file}(2,2);
   del(file,3)=Rapps{file}(2,3);
   del(file,4)=Rapps{file}(3,1);
   del(file,5)=Rapps{file}(3,2);
   del(file,6)=Rapps{file}(3,3);
   rip(file,1)=Rapps{file}(1,1);
   rip(file,2)=Rapps{file}(1,2);
   rip(file,3)=Rapps{file}(1,3);

end

figure
for j=1:3
    mean1=zeros(20,5);
    mean2=zeros(20,5);
    mean3=zeros(20,5);
for file=1:5
    subplot(3,3,1+(j-1)*3)
    mean1(:,file)=speed_del_regional{file,1}(1+(j-1)*3,2:end)/mean(speed_del_regional{file,1}(1,2:end));
    plot(inpercent(2:end),mean1(:,file))
    hold on
    subplot(3,3,2+(j-1)*3)
    mean2(:,file)=speed_del_regional{file,1}(2+(j-1)*3,2:end)/mean(speed_del_regional{file,1}(2,2:end));
    plot(inpercent(2:end),mean2(:,file))
    hold on
    subplot(3,3,3+(j-1)*3)
        mean3(:,file)=speed_del_regional{file,1}(3+(j-1)*3,2:end)/mean(speed_del_regional{file,1}(3,2:end));
    plot(inpercent(2:end),mean3(:,file))
    hold on
end
    subplot(3,3,1+(j-1)*3)
plot(inpercent(2:end),nanmean(mean1'),'r','linewidth',3)
[R,P]=corrcoef(inpercent(2:end),nanmean(mean1'));
title(num2str(P(1,2)))
    subplot(3,3,2+(j-1)*3)
plot(inpercent(2:end),nanmean(mean2'),'r','linewidth',3)
    [R,P]=corrcoef(inpercent(2:end),nanmean(mean2'));
title(num2str(P(1,2)))
subplot(3,3,3+(j-1)*3)
plot(inpercent(2:end),nanmean(mean3'),'r','linewidth',3)
[R,P]=corrcoef(inpercent(2:end),nanmean(mean3'));
title(num2str(P(1,2)))

end

figure
for j=1:3
    mean1=zeros(20,5);
    mean2=zeros(20,5);
    mean3=zeros(20,5);
for file=1:5
    subplot(3,3,1+(j-1)*3)
    mean1(:,file)=speed_del_regional{file,2}(1+(j-1)*3,2:end)/mean(speed_del_regional{file,2}(1,2:end));
    plot(inpercent(2:end),mean1(:,file))
    hold on
    subplot(3,3,2+(j-1)*3)
    mean2(:,file)=speed_del_regional{file,2}(2+(j-1)*3,2:end)/mean(speed_del_regional{file,2}(2,2:end));
    plot(inpercent(2:end),mean2(:,file))
    hold on
    subplot(3,3,3+(j-1)*3)
        mean3(:,file)=speed_del_regional{file,2}(3+(j-1)*3,2:end)/mean(speed_del_regional{file,2}(3,2:end));
    plot(inpercent(2:end),mean3(:,file))
    hold on
end
    subplot(3,3,1+(j-1)*3)
plot(inpercent(2:end),nanmean(mean1'),'r','linewidth',3)
[R,P]=corrcoef(inpercent(2:end),nanmean(mean1'));
title(num2str(P(1,2)))
    subplot(3,3,2+(j-1)*3)
plot(inpercent(2:end),nanmean(mean2'),'r','linewidth',3)
    [R,P]=corrcoef(inpercent(2:end),nanmean(mean2'));
title(num2str(P(1,2)))
subplot(3,3,3+(j-1)*3)
plot(inpercent(2:end),nanmean(mean3'),'r','linewidth',3)
[R,P]=corrcoef(inpercent(2:end),nanmean(mean3'));
title(num2str(P(1,2)))

end