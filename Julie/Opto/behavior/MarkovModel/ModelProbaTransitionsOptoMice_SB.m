 clear all
Paramstepsize = 0.005;
for stepsize = [0.5,1,1.5,2,3,4]
    
    MinFzstepsize = ceil(2/stepsize);
    DurSimu = 1000/stepsize;
    
    for Pfz_fz = [Paramstepsize:Paramstepsize:1-Paramstepsize]
        for Pnofz_nofz = [Paramstepsize:Paramstepsize:1-Paramstepsize]
            Pfz_fz
            clear State
            State(1) = 1; % Act
            
            
            for k=2:DurSimu
                
                randnum = rand;
                if State(k-1) == 1
                    if randnum<=Pnofz_nofz
                        State(k) = 1;
                    else
                        State(k) = 0;
                    end
                else
                    if length(State)>MinFzstepsize
                        if sum(State(k-MinFzstepsize:k-1)) > 1
                            State(k) = 0;
                        else
                            if randnum<=Pfz_fz
                                State(k) = 0;
                            else
                                State(k) = 1;
                            end
                        end
                    else
                        State(k) = 0;
                    end
                end
                
            end
            
            StartFz = find(diff(State)==-1);
            StartAct = [0,find(diff(State)==1)];
            
            FreqInit(floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)) = length(find(diff(State)==1))./(length(State)*stepsize);
            PercFz(floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)) = (DurSimu-sum(State))./length(State);
            
            if State(end)==1
                DurActEp(floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)) = mean(StartFz - StartAct(1:end-1))*stepsize;
                DurFzEp(floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)) = mean(StartAct(2:end-1) - StartFz(1:end-1))*stepsize;
                
                DistribFzEpisodes{floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)} = (StartAct(2:end-1) - StartFz(1:end-1))*stepsize;
                DistribActEpisodes{floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)} = (StartFz - StartAct(1:end-1))*stepsize;

            else
                DurActEp(floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)) = mean(StartFz - StartAct)*stepsize;
                DurFzEp(floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)) = mean(StartAct(2:end) - StartFz(1:end-1))*stepsize;
                
                DistribFzEpisodes{floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)} = (StartAct(2:end) - StartFz(1:end-1))*stepsize;
                DistribActEpisodes{floor(Pfz_fz/Paramstepsize+0.001),floor(Pnofz_nofz/Paramstepsize+0.001)} = (StartFz - StartAct)*stepsize;

            end
            

            
        end
    end
    save(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'.mat'],...
        'DurActEp','DurFzEp','PercFz','FreqInit','DistribFzEpisodes','DistribActEpisodes')
    clear DurActEp DurFzEp PercFz FreqInit
    
end

figure
subplot(221)
imagesc([Paramstepsize:Paramstepsize:1-Paramstepsize],[Paramstepsize:Paramstepsize:1-Paramstepsize],log(MeanActDur))
axis xy
ylabel('Proba Fz-->Fz')
xlabel('Proba Act-->Act')
title('MeanActDur')
colorbar
subplot(222)
imagesc([Paramstepsize:Paramstepsize:1-Paramstepsize],[Paramstepsize:Paramstepsize:1-Paramstepsize],log(MeanFzDur))
axis xy
ylabel('Proba Fz-->Fz')
xlabel('Proba Act-->Act')
title('MeanFzDur')
colorbar
subplot(223)
imagesc([Paramstepsize:Paramstepsize:1-Paramstepsize],[Paramstepsize:Paramstepsize:1-Paramstepsize],(MeanFzTime))
axis xy
ylabel('Proba Fz-->Fz')
xlabel('Proba Act-->Act')
title('TotDur')
colorbar
subplot(224)
imagesc([Paramstepsize:Paramstepsize:1-Paramstepsize],[Paramstepsize:Paramstepsize:1-Paramstepsize],(NumTrans))
axis xy
ylabel('Proba Fz-->Fz')
xlabel('Proba Act-->Act')
title('Num Trans')
colorbar

close all
for stepsize = [0.5,1,1.5,2,3,4]
    
    fig = figure;
    fig.Name=num2str(stepsize);
    load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'.mat'])
    load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/DataFzingStatesopto_' num2str(stepsize),'.mat'])
    cols = {'k','b','r'}
    
    for l = 1:size(DurFzEp_GFP,2)
        for k=1:size(DurFzEp_GFP,1)
            ErrMat = (DurFzEp-DurFzEp_GFP(k,l)).^2+(DurActEp-DurActEp_GFP(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            [row,col] = find(ErrMat == val);
            subplot(221)
            plot(PercFz(row,col),PercFz_GFP(k,l),'*','color',cols{l}),hold on
            subplot(222)
            plot(FreqInit(row,col),FreqInit_GFP(k,l),'*','color',cols{l}),hold on
            
        end
    end
    subplot(221)
    line([0 1],[0 1])
    subplot(222)
    line([0 0.1],[0 0.1])
    
    for l = 1:size(DurFzEp_GFP,2)
        for k=1:size(DurFzEp_GFP,1)
            ErrMat = (DurFzEp-DurFzEp_CHR2(k,l)).^2+(DurActEp-DurActEp_CHR2(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            [row,col] = find(ErrMat == val);
            subplot(223)
            plot(PercFz(row,col),PercFz_CHR2(k,l),'*','color',cols{l}),hold on
            subplot(224)
            plot(FreqInit(row,col),FreqInit_CHR2(k,l),'*','color',cols{l}),hold on
            
        end
    end
    subplot(223)
    line([0 1],[0 1])
    xlabel('PercFz-model'), ylabel('PercFz-data')
    subplot(224)
    line([0 0.1],[0 0.1])
        xlabel('FreqInit-model'), ylabel('FreqInit-data')

end

% 
figure;
clf
subplot(221)
scatter(log(DurFzEp(:)),log(DurActEp(:)),10,PercFz(:),'filled'), hold on
scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),100,'k','filled')
scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),70,PercFz_GFP(:,2),'filled')
scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),120,'g','filled')
scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),70,PercFz_GFP(:,3),'filled')
xlabel('MeanFzDur (log scale)')
ylabel('MeanActDur (log scale)')
title('Total Freezing')
subplot(222)
scatter(log(DurFzEp(:)),log(DurActEp(:)),10,FreqInit(:),'filled'), hold on
scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),100,'k','filled')
scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),70,FreqInit_GFP(:,2),'filled')
scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),120,'g','filled')
scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),70,FreqInit_GFP(:,3),'filled')
xlabel('MeanFzDur (log scale)')
ylabel('MeanActDur (log scale)')
title('Number of freezing Onsets')
subplot(223)
scatter(log(DurFzEp(:)),log(DurActEp(:)),10,PercFz(:),'filled'), hold on
scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),100,'k','filled')
scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),70,PercFz_CHR2(:,2),'filled')
scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),120,'c','filled')
scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),70,PercFz_CHR2(:,3),'filled')
xlabel('MeanFzDur (log scale)')
ylabel('MeanActDur (log scale)')
subplot(224)
scatter(log(DurFzEp(:)),log(DurActEp(:)),10,FreqInit(:),'filled'), hold on
scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),100,'k','filled')
scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),70,FreqInit_CHR2(:,2),'filled')
scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),120,'c','filled')
scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),70,FreqInit_CHR2(:,3),'filled')
xlabel('MeanFzDur (log scale)')
ylabel('MeanActDur (log scale)')

figure;
clf
subplot(221)
scatter(log(DurFzEp(:)),log(DurActEp(:)),30,PercFz(:),'filled'), hold on
% scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),100,'k','filled')
% scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),70,PercFz_GFP(:,2),'filled')
% scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),100,'r','filled')
% scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),70,PercFz_CHR2(:,2),'filled')
% plot(log(nanmean(DurFzEp_CHR2(:,2))),log(nanmean(DurActEp_CHR2(:,2))),'+r','MarkerSize',20)
% plot(log(nanmean(DurFzEp_GFP(:,2))),log(nanmean(DurActEp_GFP(:,2))),'+k','MarkerSize',20)
[hdx,hdy]=errorbarxy(log(nanmean(DurFzEp_CHR2(:,2))),log(nanmean(DurActEp_CHR2(:,2))),stdError(log(DurFzEp_CHR2(:,2))),stdError(log(DurActEp_CHR2(:,2))),'r');
hdx.LineWidth=2;hdy.LineWidth=2;
uistack(hdx,'top'),uistack(hdy,'top')
[hdx,hdy]=errorbarxy(log(nanmean(DurFzEp_GFP(:,2))),log(nanmean(DurActEp_GFP(:,2))),stdError(log(DurFzEp_GFP(:,2))),stdError(log(DurActEp_GFP(:,2))),'k');
hdx.LineWidth=2;hdy.LineWidth=2;
uistack(hdx,'top'),uistack(hdy,'top')
xlabel('MeanFzDur (log scale)')
ylabel('MeanActDur (log scale)')
title('Total Freezing')
subplot(222)
scatter(log(DurFzEp(:)),log(DurActEp(:)),30,FreqInit(:),'filled'), hold on
% scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),100,'k','filled')
% scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),70,FreqInit_GFP(:,2),'filled')
% scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),100,'r','filled')
% scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),70,FreqInit_CHR2(:,2),'filled')
[hdx,hdy]=errorbarxy(log(nanmean(DurFzEp_CHR2(:,2))),log(nanmean(DurActEp_CHR2(:,2))),stdError(log(DurFzEp_CHR2(:,2))),stdError(log(DurActEp_CHR2(:,2))),'r');
hdx.LineWidth=2;hdy.LineWidth=2;
uistack(hdx,'top'),uistack(hdy,'top')
[hdx,hdy]=errorbarxy(log(nanmean(DurFzEp_GFP(:,2))),log(nanmean(DurActEp_GFP(:,2))),stdError(log(DurFzEp_GFP(:,2))),stdError(log(DurActEp_GFP(:,2))),'k');
hdx.LineWidth=2;hdy.LineWidth=2;
uistack(hdx,'top'),uistack(hdy,'top')
% plot(log(nanmean(DurFzEp_CHR2(:,2))),log(nanmean(DurActEp_CHR2(:,2))),'+r','MarkerSize',20)
% plot(log(nanmean(DurFzEp_GFP(:,2))),log(nanmean(DurActEp_GFP(:,2))),'+k','MarkerSize',20)

xlabel('MeanFzDur (log scale)')
ylabel('MeanActDur (log scale)')
title('Number of freezing Onsets')
subplot(223)
scatter(log(DurFzEp(:)),log(DurActEp(:)),30,PercFz(:),'filled'), hold on
% scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),120,'k','filled')
% scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),70,PercFz_GFP(:,3),'filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),120,'r','filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),70,PercFz_CHR2(:,3),'filled')
[hdx,hdy]=errorbarxy(log(nanmean(DurFzEp_CHR2(:,3))),log(nanmean(DurActEp_CHR2(:,3))),stdError(log(DurFzEp_CHR2(:,3))),stdError(log(DurActEp_CHR2(:,3))),'r');
hdx.LineWidth=2;hdy.LineWidth=2;
uistack(hdx,'top'),uistack(hdy,'top')
[hdx,hdy]=errorbarxy(log(nanmean(DurFzEp_GFP(:,3))),log(nanmean(DurActEp_GFP(:,3))),stdError(log(DurFzEp_GFP(:,3))),stdError(log(DurActEp_GFP(:,3))),'k');
hdx.LineWidth=2;hdy.LineWidth=2;
uistack(hdx,'top'),uistack(hdy,'top')
% plot(log(nanmean(DurFzEp_CHR2(:,3))),log(nanmean(DurActEp_CHR2(:,3))),'+r','MarkerSize',20)
% plot(log(nanmean(DurFzEp_GFP(:,3))),log(nanmean(DurActEp_GFP(:,3))),'+k','MarkerSize',20)
xlabel('MeanFzDur (log scale)')
ylabel('MeanActDur (log scale)')
subplot(224)
scatter(log(DurFzEp(:)),log(DurActEp(:)),30,FreqInit(:),'filled'), hold on
% scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),120,'k','filled')
% scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),70,FreqInit_GFP(:,3),'filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),120,'r','filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),70,FreqInit_CHR2(:,3),'filled')
[hdx,hdy]=errorbarxy(gca,log(nanmean(DurFzEp_CHR2(:,3))),log(nanmean(DurActEp_CHR2(:,3))),stdError(log(DurFzEp_CHR2(:,3))),stdError(log(DurActEp_CHR2(:,3))),'r');
uistack(hdx,'top'),uistack(hdy,'top')
hdx.LineWidth=2;hdy.LineWidth=2;
[hdx,hdy]=errorbarxy(log(nanmean(DurFzEp_GFP(:,3))),log(nanmean(DurActEp_GFP(:,3))),stdError(log(DurFzEp_GFP(:,3))),stdError(log(DurActEp_GFP(:,3))),'k');
uistack(hdx,'top'),uistack(hdy,'top')
hdx.LineWidth=2;hdy.LineWidth=2;
% 
% plot(log(nanmean(DurFzEp_CHR2(:,3))),log(nanmean(DurActEp_CHR2(:,3))),'+r','MarkerSize',20)
% plot(log(nanmean(DurFzEp_GFP(:,3))),log(nanmean(DurActEp_GFP(:,3))),'+k','MarkerSize',20)
xlabel('MeanFzDur (log scale)')
ylabel('MeanActDur (log scale)')



% 
% 
% 
% 
% figure
% subplot(221)
% %scatter(log(MeanFzDur(:)),log(MeanActDur(:)),10,MeanFzTime(:),'filled'), 
% hold on
% scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),100,'k','filled')
% scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),70,PercFz_GFP(:,3),'filled')
% scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),120,'g','filled')
% scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),70,PercFz_GFP(:,3),'filled')
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% title('Total Freezing')
% subplot(222)
% %scatter(log(MeanFzDur(:)),log(MeanActDur(:)),10,NumTrans(:),'filled'), 
% hold on
% scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),100,'k','filled')
% scatter(log(DurFzEp_GFP(:,2)),log(DurActEp_GFP(:,2)),70,FreqInit_GFP(:,3),'filled')
% scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),120,'g','filled')
% scatter(log(DurFzEp_GFP(:,3)),log(DurActEp_GFP(:,3)),70,FreqInit_GFP(:,3),'filled')
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% title('Number of freezing Onsets')
% subplot(223)
% %scatter(log(MeanFzDur(:)),log(MeanActDur(:)),10,MeanFzTime(:),'filled'),
% hold on
% scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),100,'k','filled')
% scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),70,PercFz_CHR2(:,3),'filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),120,'c','filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),70,PercFz_CHR2(:,3),'filled')
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% subplot(224)
% %scatter(log(MeanFzDur(:)),log(MeanActDur(:)),10,NumTrans(:),'filled'), 
% hold on
% scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),100,'k','filled')
% scatter(log(DurFzEp_CHR2(:,2)),log(DurActEp_CHR2(:,2)),70,FreqInit_CHR2(:,3),'filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),120,'c','filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),70,FreqInit_CHR2(:,3),'filled')
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% 
% 
% load('DataFzingStatesAllMiceOptoEpochs.mat')
% figure
% subplot(311)
% hold on
% scatter((DurFzEp_GFP(:)),(DurActEp_GFP(:)),50,'k','filled')
% xlabel('MeanFzDur ')
% ylabel('MeanActDur ')
% subplot(312)
% hold on
% scatter((DurFzEp_GFP(:)),(FreqInit_GFP(:)),50,'k','filled')
% xlabel('MeanFzDur ')
% ylabel('Number of freezing Onsets')
% subplot(313)
% hold on
% scatter((DurActEp_GFP(:)),(FreqInit_GFP(:)),50,'k','filled')
% xlabel('MeanActDur ')
% ylabel('Number of freezing Onsets')
% 
% load('DataFzingStatesopto.mat')
% subplot(311)
% hold on
% scatter((DurFzEp_GFP(:)),(DurActEp_GFP(:)),50,'g','filled')
% scatter((DurFzEp_CHR2(:)),(DurActEp_CHR2(:)),50,'b','filled')
% scatter((DurFzEp_CHR2(:,3)),(DurActEp_CHR2(:,3)),50,'r','filled')
% subplot(312)
% hold on
% scatter((DurFzEp_GFP(:)),(FreqInit_GFP(:)),50,'g','filled')
% scatter((DurFzEp_CHR2(:)),(FreqInit_CHR2(:)),50,'b','filled')
% scatter((DurFzEp_CHR2(:,3)),(FreqInit_CHR2(:,3)),50,'r','filled')
% subplot(313)
% hold on
% scatter((DurActEp_GFP(:)),(FreqInit_GFP(:)),50,'g','filled')
% scatter((DurActEp_CHR2(:)),(FreqInit_CHR2(:)),50,'b','filled')
% scatter((DurActEp_CHR2(:,3)),(FreqInit_CHR2(:,3)),50,'r','filled')
% 
% 
% %%
% load('DataFzingStatesAllMiceOptoEpochs.mat')
% figure
% subplot(311)
% hold on
% scatter(log(DurFzEp_GFP(:)),log(DurActEp_GFP(:)),50,'k','filled')
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% subplot(312)
% hold on
% scatter(log(DurFzEp_GFP(:)),(FreqInit_GFP(:)),50,'k','filled')
% xlabel('MeanFzDur (log scale)')
% ylabel('Number of freezing Onsets')
% subplot(313)
% hold on
% scatter(log(DurActEp_GFP(:)),(FreqInit_GFP(:)),50,'k','filled')
% xlabel('MeanActDur (log scale)')
% ylabel('Number of freezing Onsets')
% 
% load('DataFzingStatesopto.mat')
% subplot(311)
% hold on
% scatter(log(DurFzEp_GFP(:)),log(DurActEp_GFP(:)),50,'g','filled')
% scatter(log(DurFzEp_CHR2(:)),log(DurActEp_CHR2(:)),50,'b','filled')
% scatter(log(DurFzEp_CHR2(:,3)),log(DurActEp_CHR2(:,3)),50,'r','filled')
% subplot(312)
% hold on
% scatter(log(DurFzEp_GFP(:)),(FreqInit_GFP(:)),50,'g','filled')
% scatter(log(DurFzEp_CHR2(:)),(FreqInit_CHR2(:)),50,'b','filled')
% scatter(log(DurFzEp_CHR2(:,3)),(FreqInit_CHR2(:,3)),50,'r','filled')
% subplot(313)
% hold on
% scatter(log(DurActEp_GFP(:)),(FreqInit_GFP(:)),50,'g','filled')
% scatter(log(DurActEp_CHR2(:)),(FreqInit_CHR2(:)),50,'b','filled')
% scatter(log(DurActEp_CHR2(:,3)),(FreqInit_CHR2(:,3)),50,'r','filled')
% scatter(log(DurActEp_GFP(:,3)),(FreqInit_GFP(:,3)),50,'m','filled')
% 
% model.m
% Affichage de model.m en cours...