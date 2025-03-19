%% Show individual diffusion trajectories
clear all, close all
AllSlScoringMice_SleepScoringArticle_SB
close all
%% Get all diffusion curves
DiffDurTimes=4;
dt=0.0008;
dd=1;
DiffDur=DiffDurTimes(dd);
normaldur=DiffDur/dt;

figure
time=[dt:dt:dt*normaldur];
for mm=1:m
    mm
    cd(filename2{mm})
    load(strcat('DisplacementMeasure',num2str(DiffDur),'Part1.mat'))
    disp('Part1')
    g=1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));    temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare;end %Wake
    g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%SWS
    g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end %REM
    g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%WtoS
    g=g+1;if not(isempty(GammDisp{g})),[cf_,goodness]=FitDiffusion(time,mean(GammDisp{g}));     temp=coeffvalues(cf_);CoeffAG(g,mm)=temp(2);CoeffDG(g,mm)=temp(1);RsqG(g,mm)=goodness.rsquare; end%StoW
    plot((time),(mean(GammDisp{4})./(CoeffDG(4,mm)*2)),'r'), hold on
    plot((time),(mean(GammDisp{5})./(CoeffDG(5,mm)*2)),'b'), hold on
    RememberCurves_SW(mm,:) = (mean(GammDisp{4})./(CoeffDG(4,mm)*2));
    RememberCurves_WS(mm,:) = (mean(GammDisp{5})./(CoeffDG(5,mm)*2));

end
plot(time,time.^mean(CoeffAG(5,:)),'k','linewidth',4)
plot(time,time.^mean(CoeffAG(4,:)),'k','linewidth',4)
box off

% Compare D and alpha
figure
ToUse=[4:5];
subplot(121)
PlotErrorBar(CoeffAG(4:5,:)',0)
% for g=1:2
%     plot(g-0.3,CoeffAG(ToUse(g),:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffAG(ToUse(g),:),'.','color','k','MarkerSize',10)
% end
[h,p]=ttest(CoeffAG(4,:),CoeffAG(5,:));
sigstar({[1,2]},p)
set(gca,'XTick',[1:2],'Xticklabel',{'W--S','S--W'})
ylabel('Gamma - alpha')
subplot(122)
PlotErrorBar((CoeffDG(ToUse,:)'./(CoeffDG(1,:)'*ones(2,1)')),0)
% for g=1:2
%     plot(g-0.3,CoeffDG(ToUse(g),:)./CoeffDG(1,:),'.','color','w','MarkerSize',21)
%     plot(g-0.3,CoeffDG(ToUse(g),:)./CoeffDG(1,:),'.','color','k','MarkerSize',10)
% end
a=CoeffDG(ToUse,:)'./(CoeffDG(1,:)'*ones(2,1)');
[h,p]=ttest(a(1,:),a(2,:));
sigstar({[1,2]},p)
set(gca,'XTick',[1:2],'Xticklabel',{'W--S','S--W'})
ylabel('Gamma-D')
%mean(RsqG(4,:))= 0.99667135912408;
%mean(RsqG(5,:))= 0.999498919322401;