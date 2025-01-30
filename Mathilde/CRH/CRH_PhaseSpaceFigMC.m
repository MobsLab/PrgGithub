%% Code adapted from PhaseSpaceFig.mat (SB)
% clear all, close all

%% input dir
DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1106 1148 1149 1150]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1148 1149 1150]);

%%
DirCNO = PathForExperimentsAtropine_MC('Atropine');
% DirSaline = PathForExperimentsAtropine_MC('Baseline');

%%
size_occ = 100;
tot_occ = zeros(size_occ,size_occ);
inpercent = [0:0.05:1];
MatX = [-1:4/99:3];
MatY = [-2:4/99:2];

for file=1:length(DirCNO.path)
    cd(DirCNO.path{file}{1});
    clear Epoch smooth_Theta smooth_ghi
    load('SleepScoring_OBGamma.mat');
    
    % separate recording before/after injection
    durtotal = max([max(End(Wake)),max(End(SWSEpoch))]);
    Epoch1 = intervalSet(0,durtotal/2);
    Epoch2 = intervalSet(durtotal/2,durtotal);
    
    
    smooth_Theta = Restrict(SmoothTheta,Epoch);
    smooth_ghi = Restrict(SmoothGamma,Epoch);
    
    [C,I] = min([max(Range(smooth_Theta)),max(Range(smooth_ghi))]);
    smooth_Theta = Restrict(smooth_Theta,intervalSet(0,C));
    t = (Range(smooth_Theta));
    ti = t(5:100:end);
    time = ts(ti);
    TotalEpoch = intervalSet(0,max(ti))-TotalNoiseEpoch;
    smooth_Theta = Restrict(smooth_Theta,TotalEpoch);
    smooth_ghi = Restrict(smooth_ghi,TotalEpoch);
    
    theta_new = Restrict(smooth_Theta,Epoch2);
    ghi_new = Restrict(smooth_ghi,Epoch2);
    ghi_new = tsd(Range(theta_new),Data(ghi_new));
    % center on slow wave sleep
    GThresh{file} = log(Info.gamma_thresh)-nanmean(log(Data(Restrict(ghi_new,and(SWSEpoch,Epoch2)))));
    TThresh{file} = log(Info.theta_thresh)-nanmean(log(Data(Restrict(theta_new,and(SWSEpoch,Epoch2)))));
    
    ghi_new = tsd(Range(ghi_new),log(Data(ghi_new))-nanmean(log(Data(Restrict(ghi_new,and(SWSEpoch,Epoch2))))));
    theta_new = tsd(Range(theta_new),log(Data(theta_new))-nanmean(log(Data(Restrict(theta_new,and(SWSEpoch,Epoch2))))));
    
    [Yg{file},Xg{file}] = hist(Data(ghi_new),MatX);
    [Yt{file},Xt{file}] = hist(Data(Restrict(theta_new,or(and(SWSEpoch,Epoch2),and(REMEpoch,Epoch2)))),MatY);
    Epoch3{1} = and(SWSEpoch,Epoch2);
    Epoch3{2} = and(REMEpoch,Epoch2);
    Epoch3{3} = and(Wake,Epoch2);
    
    %%
    %  Get the contours and concentric regions
    for k=1:3
        intdat_g = Data(Restrict(ghi_new,Epoch3{k}));
        intdat_t = Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,Epoch3{k})))));
        cent = [nanmean(intdat_g),nanmean(intdat_t)];
        distances = (intdat_g-cent(1)).^2/nanmean((intdat_g-cent(1)).^2)+(intdat_t-cent(2)).^2/nanmean((intdat_t-cent(2)).^2);
        dist = tsd(Range(Restrict(ghi_new,Epoch3{k})),distances);
        if isempty(intdat_g)==0
            for i=1:length(inpercent)
                threshold = percentile(distances,inpercent(i));
                SubEpochC{k,i} = thresholdIntervals(dist,threshold,'Direction','Below');
            end
        else
        end
          if isempty(intdat_g)==0
        for y=1:4
            intdat_g = Data(Restrict(ghi_new,and(Epoch3{k},SubEpochC{k,length(inpercent)-y})));
            intdat_t = Data(Restrict(theta_new,ts(Range(Restrict(ghi_new,and(Epoch3{k},SubEpochC{k,length(inpercent)-y}))))));
            K = convhull(intdat_g,intdat_t);
            Cont{file,k,y}(1,:) = intdat_g(K);
            Cont{file,k,y}(2,:) = intdat_t(K);
        end
          else
          end
    end
    %%
    [sp_occtemp,x,y] = hist2d(Data(ghi_new),Data(theta_new),MatX,MatY);
    sp_occ{file} = sp_occtemp;
end

%% figure
figure
for file=1:length(DirCNO.path)
    try
        tot_occ = tot_occ+sp_occ{file}/sum(sum(sp_occ{file}));
    end
end
subplot(3,3,[2,3,5,6])
imagesc(x,y,log(tot_occ')), axis xy
hold on
colormap(paruly)
ylim([-1.2 2]), xlim([-0.7 2.5])

% plot ellipses for each state and each mouse
for file=1:length(DirCNO.path)
    subplot(3,3,[2,3,5,6])
    plot(Cont{file,1,2}(1,:),Cont{file,1,2}(2,:),'color',[0.4 0.5 1],'linewidth',2), hold on %NREM
    % check if there is REM after the injection (and if not don't plot the
    % elipse)
    if isempty(Cont{file,2,2})
    else
        plot(Cont{file,2,2}(1,:),Cont{file,2,2}(2,:),'color',[1 0.2 0.2],'linewidth',2) %REM
    end
    plot(Cont{file,3,2}(1,:),Cont{file,3,2}(2,:),'color',[0.6 0.6 0.6],'linewidth',2)%WAKE
    subplot(3,3,[8,9])
    st_ = [1.0e-2 Xg{file}(find(Yg{file}==max(Yg{file}))) 0.101 5e-3 Xg{file}(find(Yg{file}==max(Yg{file})))+1 0.21];
    [cf2,goodness2] = createFit2gauss(Xg{file},Yg{file}/sum(Yg{file}),st_);
    d = ([min(Xg{file}):max(Xg{file})/1000:max(Xg{file})]);a= coeffvalues(cf2);
    Y1 = normpdf(d,a(2),a(3));
    Y2 = normpdf(d,a(5),a(6));
    %     plot(d,Y1/sum(Y1),'color',[0.6 0.6 0.6],'linewidth',2), hold on
    %     plot(d,Y2/sum(Y2),'color',[0.6 0.6 0.6],'linewidth',2)
    plot(Xg{file},Yg{file}/sum(Yg{file}(Xg{file}<0.5)),'color',[0.6 0.6 0.6],'linewidth',1), hold on
%     plot(GThresh{file},0.17*file,'k*')
    plot(GThresh{file},0.03*file,'k*')

    xlabel('Gamma power (log scale)')
    subplot(3,3,[1,4])
    plot(Yt{file}/sum(Yt{file}),Xt{file},'color',[0.6 0.6 0.6],'linewidth',1), hold on
%     plot(0.07*file,TThresh{file},'k*')

        plot(0.007*file,TThresh{file},'k*')
ylabel('Theta/delta power (log scale)')
end

