%% Code for diffusion figures used for 11th april draft

clear all, close all
% Load Mice File Names
AllSlScoringMice


% Parameters
MatXEMG=[-2:8/99:6];
MatYEMG=[-2:4/99:2];
MatXGam=[-0.7:3.2/99:2.5];
MatYGam=[-1.5:3.5/99:2];
lim=[1,2,3,5,7,10,15,20];
jtouse=3;


% Compare diffusive and ballistic trajectories
for mm=7
    mm
    
    cd(filename2{mm})
    load('StateEpochSB.mat','SWSEpoch','wakeper','smooth_ghi','smooth_Theta','gamma_thresh','theta_thresh')%     %Find transition zone
    gammamean=mean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
    thetamean=mean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
    load('MapsTransitionProbaGam.mat')
    
    load('TransLimsGam.mat')
    figure
    subplot(211)
    imagesc(MatXGam,MatYGam,Val{3}'), axis xy, colormap bone
    hold on
    line(log([X1 X1])-gammamean,[min(MatYGam) max(MatYGam)],'color','r','linewidth',4)
    line(log([X2 X2])-gammamean,[min(MatYGam) max(MatYGam)],'color','r','linewidth',4)
    temp=AbortTrans{3};temp=dropShortIntervals(temp,0.5e4);
    for k=10:20
        plot(log(Data(Restrict(smooth_ghi,subset(temp,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp,k))))-(thetamean),'linewidth',2)
    end
    title('W to S')
    subplot(212)
    imagesc(MatXGam,MatYGam,Val{3}'), axis xy, colormap bone
    hold on
    line(log([X1 X1])-gammamean,[min(MatYGam) max(MatYGam)],'color','r','linewidth',4)
    line(log([X2 X2])-gammamean,[min(MatYGam) max(MatYGam)],'color','r','linewidth',4)
    temp=AbortTrans{2};temp=dropShortIntervals(temp,0.5e4);
    for k=2:11
        plot(log(Data(Restrict(smooth_ghi,subset(temp,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp,k))))-(thetamean),'linewidth',2)
    end
    title('S to W')
end


%% Show individual diffusion trajectories
clear all, close all
AllSlScoringMice
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