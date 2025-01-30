% close all
clear all
StepSizes = [0.5,1,1.5,2,3,4];
for st = 3%1:length(StepSizes)
    stepsize = StepSizes(st);
    
    load(['/home/vador/Dropbox/Mobs_member/SophieBagur/Figures/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'.mat'])
    load(['/home/vador/Dropbox/Mobs_member/SophieBagur/Figures/BehaviourOptoDurationEvents/DataFzingStatesopto_' num2str(stepsize),'.mat'])
    cols = {'k','b','r'}
    
    for l = 2:size(DurFzEp_GFP,2)
        for k=1:size(DurFzEp_GFP,1)
            ErrMat = (DurFzEp-DurFzEp_GFP(k,l)).^2+(DurActEp-DurActEp_GFP(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            [row,col] = find(ErrMat == val);
%             ErrMat(isinf(ErrMat))=NaN;
%             imagesc(log(ErrMat))
%             pause
            Err_PercFz_GFP(st,k,l) = (PercFz_GFP(k,l)-PercFz(row,col)).^2;
            Err_FreqInit_GFP(st,k,l) = (FreqInit_GFP(k,l)-FreqInit(row,col)).^2;
            
        end
    end
    
    for l = 2:size(DurFzEp_GFP,2)
        for k=1:size(DurFzEp_GFP,1)
            ErrMat = (DurFzEp-DurFzEp_CHR2(k,l)).^2+(DurActEp-DurActEp_CHR2(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            [row,col] = find(ErrMat == val);
            Err_PercFz_CHR2(st,k,l) = (PercFz_CHR2(k,l)-PercFz(row,col)).^2;
%             ErrMat(isinf(ErrMat))=NaN;
%             imagesc(log(ErrMat))
%             pause
            Err_FreqInit_CHR2(st,k,l) = (FreqInit_CHR2(k,l)-FreqInit(row,col)).^2;
            
        end
    end
    
end

% figure
% subplot(211)
% a=patch([1.4 1.4 1.6 1.6],[0 0.015 0.015 0],[0.9 0.9 0.9]);a.EdgeColor = [0.9 0.9 0.9];
% hold on
% errorbar(StepSizes,nanmean(Err_PercFz_GFP(:,:,2)'),stdError(Err_PercFz_GFP(:,:,2)'),stdError(Err_PercFz_GFP(:,:,2)'),'color',[0.4 0.8 0.4],'linewidth',2)
% errorbar(StepSizes,nanmean(Err_PercFz_CHR2(:,:,2)'),stdError(Err_PercFz_CHR2(:,:,2)'),stdError(Err_PercFz_CHR2(:,:,2)'),'color',[0.4 0.4 0.8],'linewidth',2)
% xlabel('Step size (s)')
% ylabel('Err')
% title('Percent Freezing')
% box off
% subplot(212)
% a=patch([1.4 1.4 1.6 1.6],[0 0.001 0.001 0],[0.9 0.9 0.9]);a.EdgeColor = [0.9 0.9 0.9];
% hold on
% errorbar(StepSizes,nanmean(Err_FreqInit_GFP(:,:,2)'),stdError(Err_FreqInit_GFP(:,:,2)'),stdError(Err_FreqInit_GFP(:,:,2)'),'color',[0.4 0.8 0.4],'linewidth',2)
% errorbar(StepSizes,nanmean(Err_FreqInit_CHR2(:,:,2)'),stdError(Err_FreqInit_CHR2(:,:,2)'),stdError(Err_FreqInit_CHR2(:,:,2)'),'color',[0.4 0.4 0.8],'linewidth',2)
% xlabel('Step size (s)')
% ylabel('Err')
% title('Number Episodes')
% box off


fig = figure;
subplot(221)
line([0.3 1],[0.3 1],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0.3 1]), ylim([0.3 1]), hold on
xlabel('PercFz-model'), ylabel('PercFz-data')
title('no laser')
subplot(223)
line([0 0.15],[0 0.15],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 0.15]),ylim([0 0.15]), hold on
xlabel('FreqInit-model'), ylabel('FreqInit-data')
title('no laser')
subplot(222)
line([0.3 1],[0.3 1],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0.3 1]), ylim([0.3 1]), hold on
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
        [row,col] = find(ErrMat == val);
        
        subplot(2,2,l-1)
        plot(PercFz(row,col),PercFz_GFP(k,l),'.','color',[0.4 0.8 0.4],'MarkerSize',20),hold on
        Err_PercFz_GFP(st,k,l) = (PercFz_GFP(k,l)-PercFz(row,col)).^2;
        subplot(2,2,l+1)
        plot(FreqInit(row,col),FreqInit_GFP(k,l),'.','color',[0.4 0.8 0.4],'MarkerSize',20),hold on
        Err_FreqInit_GFP(st,k,l) = (FreqInit_GFP(k,l)-FreqInit(row,col)).^2;
        FreqInit_GFP_model(k,l) = FreqInit(row,col);
    end
end

for l = 2:size(DurFzEp_GFP,2)
    for k=1:size(DurFzEp_GFP,1)
        ErrMat = (DurFzEp-DurFzEp_CHR2(k,l)).^2+(DurActEp-DurActEp_CHR2(k,l)).^2;
        ErrMat = naninterp(ErrMat);
        ErrMat = SmoothDec(ErrMat,2);
        val = min(min(ErrMat));
        [row,col] = find(ErrMat == val);
        subplot(2,2,l-1)
        plot(PercFz(row,col),PercFz_CHR2(k,l),'.','color',[0.4 0.4 0.8],'MarkerSize',20),hold on
        Err_PercFz_CHR2(st,k,l) = (PercFz_CHR2(k,l)-PercFz(row,col)).^2;
        subplot(2,2,l+1)
        plot(FreqInit(row,col),FreqInit_CHR2(k,l),'.','color',[0.4 0.4 0.8],'MarkerSize',20),hold on
        Err_FreqInit_CHR2(st,k,l) = (FreqInit_CHR2(k,l)-FreqInit(row,col)).^2;
        FreqInit_CHR2_model(k,l) = FreqInit(row,col);

    end
end




figure
for l = 2:size(DurFzEp_GFP,2)
    subplot(2,2,l-1)
    for k=1:size(DistribActEpisodes_CHR2,1)
        [Y,X]=hist(DistribActEpisodes_CHR2{k,l},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.4 0.4 0.8])
        Distrib_Act_CHR2{l}(k,:)=cumsum(Y)/sum(Y);
        hold on
    end
    
    for k=1:size(DistribActEpisodes_GFP,1)
        [Y,X]=hist(DistribActEpisodes_GFP{k,l},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.4 0.8 0.4])
        Distrib_Act_GFP{l}(k,:)=cumsum(Y)/sum(Y);
        hold on
    end
    
    subplot(2,2,l+1)
    for k=1:size(DistribFzEpisodes_CHR2,1)
        [Y,X]=hist(DistribFzEpisodes_CHR2{k,l},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.4 0.4 0.8])
        Distrib_Fz_CHR2{l}(k,:)=cumsum(Y)/sum(Y);
        hold on
    end
    
    for k=1:size(DistribFzEpisodes_GFP,1)
        [Y,X]=hist(DistribFzEpisodes_GFP{k,l},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.4 0.8 0.4])
        Distrib_Fz_GFP{l}(k,:)=cumsum(Y)/sum(Y);
        hold on
    end
    
end

for l = 2:size(DurFzEp_GFP,2)
    subplot(2,2,l-1)
    plot(X,nanmean(Distrib_Act_CHR2{l}),'color',[0.4 0.4 0.8],'linewidth',3)
    plot(X,nanmean(Distrib_Act_GFP{l}),'color',[0.4 0.8 0.4],'linewidth',4)
    xlabel('Dur Ep - Act (s)')
    if l==2
        title('no laser')
    else
        title(' laser')
    end
    xlim([0 60])
    subplot(2,2,l+1)
    plot(X,nanmean(Distrib_Fz_CHR2{l}),'color',[0.4 0.4 0.8],'linewidth',4)
    plot(X,nanmean(Distrib_Fz_GFP{l}),'color',[0.4 0.8 0.4],'linewidth',4)
    xlabel('Dur Ep - Fz (s)')
    if l==2
        title('no laser')
    else
        title(' laser')
    end
    xlim([0 80])
end




fig = figure;
for l = 2:size(DurFzEp_GFP,2)
    for k=1:size(DurFzEp_GFP,1)
        ErrMat = (DurFzEp-DurFzEp_GFP(k,l)).^2+(DurActEp-DurActEp_GFP(k,l)).^2;
        ErrMat = naninterp(ErrMat);
        ErrMat = SmoothDec(ErrMat,2);
        val = min(min(ErrMat));
        [row,col] = find(ErrMat == val);
        subplot(2,2,l-1)
        [Y,X]=hist(DistribActEpisodes{row,col},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.2 0.8 0.2]), hold on
        Distrib_Act_Model_GFP{l}(k,:)=cumsum(Y)/sum(Y);
        subplot(2,2,l+1)
        [Y,X]=hist(DistribFzEpisodes{row,col},[0:0.5:80]);
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
        [Y,X]=hist(DistribActEpisodes{row,col},[0:0.5:80]);
        plot(X,cumsum(Y)/sum(Y),'color',[0.4 0.4 0.8]), hold on
        Distrib_Act_Model_CHR2{l}(k,:)=cumsum(Y)/sum(Y);
        subplot(2,2,l+1)
        [Y,X]=hist(DistribFzEpisodes{row,col},[0:0.5:80]);
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




%%%
PFzEp = 1./((1+DurFzEp)./DurFzEp);
PFzEp_CHR2 = 1./((1+DurFzEp_CHR2)./DurFzEp_CHR2);
PFzEp_GFP = 1./((1+DurFzEp_GFP)./DurFzEp_GFP);

PActEp = 1./((1+DurActEp)./DurActEp);
PActEp_CHR2 = 1./((1+DurActEp_CHR2)./DurActEp_CHR2);
PActEp_GFP = 1./((1+DurActEp_GFP)./DurActEp_GFP);

Xlabels={'2 CS- no laser';'2 CS+ no laser'; 'CS+ +laser';};


%% Figures with probabilites
figure
subplot(212)
hold on
handles = plotSpread({PFzEp_CHR2(:,1);PFzEp_CHR2(:,2);PFzEp_CHR2(:,3)},'distributionColors',[0.4 0.4 0.8],'xValues',[1 2 3]+0.1);
set(handles{1},'MarkerSize',15)
handles = plotSpread({PFzEp_GFP(:,1);PFzEp_GFP(:,2);PFzEp_GFP(:,3)},'distributionColors',[ 0.4 0.8 0.4],'xValues',[1 2 3]-0.1);
set(handles{1},'MarkerSize',15)
for k = 1:3
    line([0.82 0.98]+k-1,[1 1]*nanmean(PFzEp_GFP(:,k)),'linewidth',2,'color','k')
    line([1.02 1.18]+k-1,[1 1]*nanmean(PFzEp_CHR2(:,k)),'linewidth',2,'color','k')
end
for k=1:3
    [p,h]=ranksum(PFzEp_CHR2(:,k),PFzEp_GFP(:,k))
    if p<0.05
        plot(k,1,'k*')
    end
end
xlim([0.5 3.5])
set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
ylabel('PFz/Fz')

subplot(211)
handles = plotSpread({PActEp_CHR2(:,1);PActEp_CHR2(:,2);PActEp_CHR2(:,3)},'distributionColors',[0.4 0.4 0.8],'xValues',[1.1 2.1 3.1]);
set(handles{1},'MarkerSize',15)
handles = plotSpread({PActEp_GFP(:,1);PActEp_GFP(:,2);PActEp_GFP(:,3)},'distributionColors',[ 0.4 0.8 0.4],'xValues',[0.9 1.9 2.9]);
set(handles{1},'MarkerSize',15)
for k = 1:3
    line([0.82 0.98]+k-1,[1 1]*nanmean(PActEp_GFP(:,k)),'linewidth',2,'color','k')
    line([1.02 1.18]+k-1,[1 1]*nanmean(PActEp_CHR2(:,k)),'linewidth',2,'color','k')
end
for k=1:3
    [p,h]=ranksum(PActEp_CHR2(:,k),PActEp_GFP(:,k));
    if p<0.05
        plot(k,1,'k*')
    end
end
xlim([0.5 3.5])
set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
ylabel('Mean active episode duration')
box off
xlim([0.5 3.5])
set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
ylabel('Pact/act')



%% Figures with duration
figure
subplot(212)
hold on
handles = plotSpread({DurFzEp_CHR2(:,1);DurFzEp_CHR2(:,2);DurFzEp_CHR2(:,3)},'distributionColors',[0.4 0.4 0.8],'xValues',[1 2 3]+0.1);
set(handles{1},'MarkerSize',15)
handles = plotSpread({DurFzEp_GFP(:,1);DurFzEp_GFP(:,2);DurFzEp_GFP(:,3)},'distributionColors',[ 0.4 0.8 0.4],'xValues',[1 2 3]-0.1);
set(handles{1},'MarkerSize',15)
for k = 1:3
    line([0.82 0.98]+k-1,[1 1]*nanmean(DurFzEp_GFP(:,k)),'linewidth',2,'color','k')
    line([1.02 1.18]+k-1,[1 1]*nanmean(DurFzEp_CHR2(:,k)),'linewidth',2,'color','k')
end
for k=1:3
    [p,h]=ranksum(DurFzEp_CHR2(:,k),DurFzEp_GFP(:,k))
    if p<0.05
        plot(k,35,'k*')
    end
end
xlim([0.5 3.5])
set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
ylabel('Fz bout duration (s)')

subplot(211)
handles = plotSpread({DurActEp_CHR2(:,1);DurActEp_CHR2(:,2);DurActEp_CHR2(:,3)},'distributionColors',[0.4 0.4 0.8],'xValues',[1.1 2.1 3.1]);
set(handles{1},'MarkerSize',15)
handles = plotSpread({DurActEp_GFP(:,1);DurActEp_GFP(:,2);DurActEp_GFP(:,3)},'distributionColors',[ 0.4 0.8 0.4],'xValues',[0.9 1.9 2.9]);
set(handles{1},'MarkerSize',15)
for k = 1:3
    line([0.82 0.98]+k-1,[1 1]*nanmean(DurActEp_GFP(:,k)),'linewidth',2,'color','k')
    line([1.02 1.18]+k-1,[1 1]*nanmean(DurActEp_CHR2(:,k)),'linewidth',2,'color','k')
end
for k=1:3
    [p,h]=ranksum(DurActEp_CHR2(:,k),DurActEp_GFP(:,k));
    if p<0.05
        plot(k,1,'k*')
        %             text(k,0.9,num2str(p))
    end
end
xlim([0.5 3.5])
set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
ylabel('Mean active episode duration')
box off
xlim([0.5 3.5])
set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
ylabel('Act bout duration (s)')

    
%   
%     %% Figures with number episodes and total freeze
%     figure
%     subplot(212)
%     hold on
%     errorbar([1:3],nanmean(FreqInit_CHR2),stdError(FreqInit_CHR2),'color',[0.4 0.4 0.8],'linewidth',3), hold on
%     errorbar([1:3],nanmean(FreqInit_GFP),stdError(FreqInit_GFP),'color',[0.4 0.8 0.4],'linewidth',3)
%     handles = plotSpread({FreqInit_CHR2(:,1);FreqInit_CHR2(:,2);FreqInit_CHR2(:,3)},'distributionColors',[ 0.4 0.4 1]);
%     set(handles{1},'MarkerSize',15)
%     handles = plotSpread({FreqInit_GFP(:,1);FreqInit_GFP(:,2);FreqInit_GFP(:,3)},'distributionColors',[ 0.4 1 0.4]);
%     set(handles{1},'MarkerSize',15)
%     for k=1:3
%         [p,h]=ranksum(FreqInit_CHR2(:,k),FreqInit_GFP(:,k));
%         if p<0.05
%             plot(k,0.12,'r*')
%             text(k,0.1,num2str(p))
%         end
%     end
%     xlim([0.5 3.5])
%     set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
%     ylabel('Number of freezing episodes')
%     
%     subplot(211)
%     errorbar([1:3],nanmean(PercFz_CHR2),stdError(PercFz_CHR2),'color',[0.4 0.4 0.8],'linewidth',3), hold on
%     errorbar([1:3],nanmean(PercFz_GFP),stdError(PercFz_GFP),'color',[0.4 0.8 0.4],'linewidth',3)
%     handles = plotSpread({PercFz_CHR2(:,1);PercFz_CHR2(:,2);PercFz_CHR2(:,3)},'distributionColors',[ 0.4 0.4 1]);
%     set(handles{1},'MarkerSize',15)
%     handles = plotSpread({PercFz_GFP(:,1);PercFz_GFP(:,2);PercFz_GFP(:,3)},'distributionColors',[ 0.4 1 0.4]);
%     set(handles{1},'MarkerSize',15)
%     for k=1:3
%         [p,h]=ranksum(PercFz_CHR2(:,k),PercFz_GFP(:,k))
%         if p<0.05
%             plot(k,1.1,'r*')
%             text(k,1.15,num2str(p))
%             
%         end
%     end
%     xlim([0.5 3.5])
%     set(gca,'XTick',[1:3],'XTickLabel',Xlabels)
%     ylabel('Percent time freezing')
%     box off
%     ylim([0 1.2])
%     
%     
% figure;
% clf
% subplot(221)
% scatter((PFzEp(:)),(PActEp(:)),30,PercFz(:),'filled'), hold on
% % scatter(log(PFzEp_GFP(:,2)),log(PActEp_GFP(:,2)),100,'k','filled')
% % scatter(log(PFzEp_GFP(:,2)),log(PActEp_GFP(:,2)),70,PercFz_GFP(:,2),'filled')
% % scatter(log(PFzEp_CHR2(:,2)),log(PActEp_CHR2(:,2)),100,'r','filled')
% % scatter(log(PFzEp_CHR2(:,2)),log(PActEp_CHR2(:,2)),70,PercFz_CHR2(:,2),'filled')
% % plot(log(nanmean(PFzEp_CHR2(:,2))),log(nanmean(PActEp_CHR2(:,2))),'+r','MarkerSize',20)
% % plot(log(nanmean(PFzEp_GFP(:,2))),log(nanmean(PActEp_GFP(:,2))),'+k','MarkerSize',20)
% [hdx,hdy]=errorbarxy((nanmean(PFzEp_CHR2(:,2))),(nanmean(PActEp_CHR2(:,2))),stdError((PFzEp_CHR2(:,2))),stdError((PActEp_CHR2(:,2))),'r');
% hdx.LineWidth=2;hdy.LineWidth=2;
% uistack(hdx,'top'),uistack(hdy,'top')
% [hdx,hdy]=errorbarxy((nanmean(PFzEp_GFP(:,2))),(nanmean(PActEp_GFP(:,2))),stdError((PFzEp_GFP(:,2))),stdError((PActEp_GFP(:,2))),'k');
% hdx.LineWidth=2;hdy.LineWidth=2;
% uistack(hdx,'top'),uistack(hdy,'top')
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% title('Total Freezing')
% subplot(222)
% scatter((PFzEp(:)),(PActEp(:)),30,FreqInit(:),'filled'), hold on
% % scatter(log(PFzEp_GFP(:,2)),log(PActEp_GFP(:,2)),100,'k','filled')
% % scatter(log(PFzEp_GFP(:,2)),log(PActEp_GFP(:,2)),70,FreqInit_GFP(:,2),'filled')
% % scatter(log(PFzEp_CHR2(:,2)),log(PActEp_CHR2(:,2)),100,'r','filled')
% % scatter(log(PFzEp_CHR2(:,2)),log(PActEp_CHR2(:,2)),70,FreqInit_CHR2(:,2),'filled')
% [hdx,hdy]=errorbarxy((nanmean(PFzEp_CHR2(:,2))),(nanmean(PActEp_CHR2(:,2))),stdError((PFzEp_CHR2(:,2))),stdError((PActEp_CHR2(:,2))),'r');
% hdx.LineWidth=2;hdy.LineWidth=2;
% uistack(hdx,'top'),uistack(hdy,'top')
% [hdx,hdy]=errorbarxy((nanmean(PFzEp_GFP(:,2))),(nanmean(PActEp_GFP(:,2))),stdError((PFzEp_GFP(:,2))),stdError((PActEp_GFP(:,2))),'k');
% hdx.LineWidth=2;hdy.LineWidth=2;
% uistack(hdx,'top'),uistack(hdy,'top')
% % plot(log(nanmean(PFzEp_CHR2(:,2))),log(nanmean(PActEp_CHR2(:,2))),'+r','MarkerSize',20)
% % plot(log(nanmean(PFzEp_GFP(:,2))),log(nanmean(PActEp_GFP(:,2))),'+k','MarkerSize',20)
% 
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% title('Number of freezing Onsets')
% subplot(223)
% scatter((PFzEp(:)),(PActEp(:)),30,PercFz(:),'filled'), hold on
% % scatter(log(PFzEp_GFP(:,3)),log(PActEp_GFP(:,3)),120,'k','filled')
% % scatter(log(PFzEp_GFP(:,3)),log(PActEp_GFP(:,3)),70,PercFz_GFP(:,3),'filled')
% % scatter(log(PFzEp_CHR2(:,3)),log(PActEp_CHR2(:,3)),120,'r','filled')
% % scatter(log(PFzEp_CHR2(:,3)),log(PActEp_CHR2(:,3)),70,PercFz_CHR2(:,3),'filled')
% [hdx,hdy]=errorbarxy((nanmean(PFzEp_CHR2(:,3))),(nanmean(PActEp_CHR2(:,3))),stdError((PFzEp_CHR2(:,3))),stdError((PActEp_CHR2(:,3))),'r');
% hdx.LineWidth=2;hdy.LineWidth=2;
% uistack(hdx,'top'),uistack(hdy,'top')
% [hdx,hdy]=errorbarxy((nanmean(PFzEp_GFP(:,3))),(nanmean(PActEp_GFP(:,3))),stdError((PFzEp_GFP(:,3))),stdError((PActEp_GFP(:,3))),'k');
% hdx.LineWidth=2;hdy.LineWidth=2;
% uistack(hdx,'top'),uistack(hdy,'top')
% % plot(log(nanmean(PFzEp_CHR2(:,3))),log(nanmean(PActEp_CHR2(:,3))),'+r','MarkerSize',20)
% % plot(log(nanmean(PFzEp_GFP(:,3))),log(nanmean(PActEp_GFP(:,3))),'+k','MarkerSize',20)
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% subplot(224)
% scatter((PFzEp(:)),(PActEp(:)),30,FreqInit(:),'filled'), hold on
% % scatter(log(PFzEp_GFP(:,3)),log(PActEp_GFP(:,3)),120,'k','filled')
% % scatter(log(PFzEp_GFP(:,3)),log(PActEp_GFP(:,3)),70,FreqInit_GFP(:,3),'filled')
% % scatter(log(PFzEp_CHR2(:,3)),log(PActEp_CHR2(:,3)),120,'r','filled')
% % scatter(log(PFzEp_CHR2(:,3)),log(PActEp_CHR2(:,3)),70,FreqInit_CHR2(:,3),'filled')
% [hdx,hdy]=errorbarxy(gca,(nanmean(PFzEp_CHR2(:,3))),(nanmean(PActEp_CHR2(:,3))),stdError((PFzEp_CHR2(:,3))),stdError((PActEp_CHR2(:,3))),'r');
% uistack(hdx,'top'),uistack(hdy,'top')
% hdx.LineWidth=2;hdy.LineWidth=2;
% [hdx,hdy]=errorbarxy((nanmean(PFzEp_GFP(:,3))),(nanmean(PActEp_GFP(:,3))),stdError((PFzEp_GFP(:,3))),stdError((PActEp_GFP(:,3))),'k');
% uistack(hdx,'top'),uistack(hdy,'top')
% hdx.LineWidth=2;hdy.LineWidth=2;
% % 
% % plot(log(nanmean(PFzEp_CHR2(:,3))),log(nanmean(PActEp_CHR2(:,3))),'+r','MarkerSize',20)
% % plot(log(nanmean(PFzEp_GFP(:,3))),log(nanmean(PActEp_GFP(:,3))),'+k','MarkerSize',20)
% xlabel('MeanFzDur (log scale)')
% ylabel('MeanActDur (log scale)')
% 
% 
%     