close all
clear all
StepSizes = [0.5,1,1.5,2,3,4];
for st = 1:length(StepSizes)
    stepsize = StepSizes(st);
    
    load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'NoMemory.mat'])
    load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/DataFzingStatesopto_' num2str(stepsize),'.mat'])
    cols = {'k','b','r'}
    
    for l = 2:size(DurFzEp_GFP,2)
        for k=1:size(DurFzEp_GFP,1)
            ErrMat = (DurFzEp-DurFzEp_GFP(k,l)).^2+(DurActEp-DurActEp_GFP(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            row = find(ErrMat == val);
            Err_PercFz_GFP(st,k,l) = (PercFz_GFP(k,l)-PercFz(row)).^2;
            Err_FreqInit_GFP(st,k,l) = (FreqInit_GFP(k,l)-FreqInit(row)).^2;
            
        end
    end
    
    for l = 2:size(DurFzEp_GFP,2)
        for k=1:size(DurFzEp_GFP,1)
            ErrMat = (DurFzEp-DurFzEp_CHR2(k,l)).^2+(DurActEp-DurActEp_CHR2(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            row = find(ErrMat == val);
            Err_PercFz_CHR2(st,k,l) = (PercFz_CHR2(k,l)-PercFz(row)).^2;
            Err_FreqInit_CHR2(st,k,l) = (FreqInit_CHR2(k,l)-FreqInit(row)).^2;
            
        end
    end
    
end

figure
subplot(211)
hold on
errorbar(StepSizes,nanmean(Err_PercFz_GFP(:,:,2)'),stdError(Err_PercFz_GFP(:,:,2)'),stdError(Err_PercFz_GFP(:,:,2)'),'color',[0.4 0.8 0.4],'linewidth',2)
errorbar(StepSizes,nanmean(Err_PercFz_CHR2(:,:,2)'),stdError(Err_PercFz_CHR2(:,:,2)'),stdError(Err_PercFz_CHR2(:,:,2)'),'color',[0.4 0.4 0.8],'linewidth',2)
xlabel('Step size (s)')
ylabel('Err')
title('Percent Freezing')
box off
subplot(212)
hold on
errorbar(StepSizes,nanmean(Err_FreqInit_GFP(:,:,2)'),stdError(Err_FreqInit_GFP(:,:,2)'),stdError(Err_FreqInit_GFP(:,:,2)'),'color',[0.4 0.8 0.4],'linewidth',2)
errorbar(StepSizes,nanmean(Err_FreqInit_CHR2(:,:,2)'),stdError(Err_FreqInit_CHR2(:,:,2)'),stdError(Err_FreqInit_CHR2(:,:,2)'),'color',[0.4 0.4 0.8],'linewidth',2)
xlabel('Step size (s)')
ylabel('Err')
title('Number Episodes')
box off


%%
st = 3;
stepsize = StepSizes(st);

fig = figure;
fig.Name=num2str(stepsize);
load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'NoMemory.mat'])
load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/DataFzingStatesopto_' num2str(stepsize),'.mat'])

fig = figure;
subplot(221)
line([0.25 1],[0.25 1],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0.25 1]), ylim([0.25 1]), hold on
xlabel('PercFz-model'), ylabel('PercFz-data')
title('no laser')
subplot(223)
line([0 0.15],[0 0.15],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 0.15]),ylim([0 0.15]), hold on
xlabel('FreqInit-model'), ylabel('FreqInit-data')
title('no laser')
subplot(222)
line([0.25 1],[0.25 1],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0.25 1]), ylim([0.25 1]), hold on
xlabel('PercFz-model'), ylabel('PercFz-data')
title('laser')
subplot(224)
line([0 0.15],[0 0.15],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 0.15]),ylim([0 0.15]), hold on
xlabel('FreqInit-model'), ylabel('FreqInit-data')
title('laser')

for l = 2:size(DurFzEp_GFP,2)
    for k=1:size(DurFzEp_GFP,1)
        ErrMat = (DurFzEp-DurFzEp_GFP(k,l)).^2+(DurActEp-DurActEp_GFP(k,l)).^2;
        ErrMat = naninterp(ErrMat);
        ErrMat = SmoothDec(ErrMat,2);
        val = min(min(ErrMat));
        [row] = find(ErrMat == val);
        
        subplot(2,2,l-1)
        plot(PercFz(row),PercFz_GFP(k,l),'.','color',[0.4 0.8 0.4],'MarkerSize',20),hold on
        Err_PercFz_GFP(st,k,l) = (PercFz_GFP(k,l)-PercFz(row)).^2;
        subplot(2,2,l+1)
        plot(FreqInit(row),FreqInit_GFP(k,l),'.','color',[0.4 0.8 0.4],'MarkerSize',20),hold on
        Err_FreqInit_GFP(st,k,l) = (FreqInit_GFP(k,l)-FreqInit(row)).^2;
        
    end
end

for l = 2:size(DurFzEp_GFP,2)
    for k=1:size(DurFzEp_GFP,1)
        ErrMat = (DurFzEp-DurFzEp_CHR2(k,l)).^2+(DurActEp-DurActEp_CHR2(k,l)).^2;
        ErrMat = naninterp(ErrMat);
        ErrMat = SmoothDec(ErrMat,2);
        val = min(min(ErrMat));
        [row] = find(ErrMat == val);
        subplot(2,2,l-1)
        plot(PercFz(row),PercFz_CHR2(k,l),'.','color',[0.4 0.4 0.8],'MarkerSize',20),hold on
        Err_PercFz_CHR2(st,k,l) = (PercFz_CHR2(k,l)-PercFz(row)).^2;
        subplot(2,2,l+1)
        plot(FreqInit(row),FreqInit_CHR2(k,l),'.','color',[0.4 0.4 0.8],'MarkerSize',20),hold on
        Err_FreqInit_CHR2(st,k,l) = (FreqInit_CHR2(k,l)-FreqInit(row)).^2;
        
    end
end


%%%


fig = figure;
for l = 2:size(DurFzEp_GFP,2)
    for k=1:size(DurFzEp_GFP,1)
        ErrMat = (DurFzEp-DurFzEp_GFP(k,l)).^2+(DurActEp-DurActEp_GFP(k,l)).^2;
        ErrMat = naninterp(ErrMat);
        ErrMat = SmoothDec(ErrMat,2);
        val = min(min(ErrMat));
        [row,col] = find(ErrMat == val);
        subplot(2,2,l-1)
        [Y,X]=hist(DistribActEpisodes{row},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.2 0.8 0.2]), hold on
        Distrib_Act_Model_GFP{l}(k,:)=cumsum(Y)/sum(Y);
        subplot(2,2,l+1)
        [Y,X]=hist(DistribFzEpisodes{row},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.2 0.8 0.2]), hold on
        Distrib_Fz_Model_GFP{l}(k,:)=cumsum(Y)/sum(Y);
    end
end

for l = 2:size(DurFzEp_CHR2,2)
    for k=1:size(DurFzEp_CHR2,1)
        ErrMat = (DurFzEp-DurFzEp_CHR2(k,l)).^2+(DurActEp-DurActEp_CHR2(k,l)).^2;
        ErrMat = naninterp(ErrMat);
        ErrMat = SmoothDec(ErrMat,2);
        val = min(min(ErrMat));
        [row,col] = find(ErrMat == val);
        subplot(2,2,l-1)
        [Y,X]=hist(DistribActEpisodes{row},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.4 0.4 0.8]), hold on
        Distrib_Act_Model_CHR2{l}(k,:)=cumsum(Y)/sum(Y);
        subplot(2,2,l+1)
        [Y,X]=hist(DistribFzEpisodes{row},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.4 0.4 0.8]), hold on
        Distrib_Fz_Model_CHR2{l}(k,:)=cumsum(Y)/sum(Y);
        
    end
end



for l = 2:size(DurFzEp_GFP,2)
    subplot(2,2,l-1)
    plot(X,nanmean(Distrib_Act_Model_CHR2{l}),'color',[0.4 0.4 0.8],'linewidth',4), hold on
    plot(X,nanmean(Distrib_Act_Model_GFP{l}),'color',[0.4 0.8 0.4],'linewidth',4)
    xlabel('Dur Ep - Act (s)')
    if l==2
        title('no laser')
    else
        title(' laser')
    end
    xlim([0 60])
    subplot(2,2,l+1)
    plot(X,nanmean(Distrib_Fz_Model_CHR2{l}),'color',[0.4 0.4 0.8],'linewidth',4), hold on
    plot(X,nanmean(Distrib_Fz_Model_GFP{l}),'color',[0.2 0.8 0.2],'linewidth',4)
    xlabel('Dur Ep - Fz (s)')
    if l==2
        title('no laser')
    else
        title(' laser')
    end
    xlim([0 80])
    
end

