%% Code for diffusion figures used for 11th april draft

clear all, close all
% Load Mice File Names
AllSlScoringMice_SleepScoringArticle_SB


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
    load('StateEpochSB.mat','SWSEpoch','wakeper','smooth_ghi','smooth_Theta','gamma_thresh','theta_thresh')%    
    gammamean=mean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
    thetamean=mean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
    load('MapsTransitionProbaGam.mat')
    
    load('TransLimsGam.mat')
    figure
    subplot(211)
    imagesc(MatXGam,MatYGam,Val{3}'), axis xy, colormap bone
    hold on
    line(log([X1 X1])-gammamean,[min(MatYGam) max(MatYGam)],'color','k','linewidth',4)
    line(log([X2 X2])-gammamean,[min(MatYGam) max(MatYGam)],'color','k','linewidth',4)
    temp=AbortTrans{3};temp=dropShortIntervals(temp,0.5e4);
    for k=10:20
        plot(log(Data(Restrict(smooth_ghi,subset(temp,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp,k))))-(thetamean),'linewidth',2,'color','r')
    end
    title('W to S')
    
    subplot(212)
    imagesc(MatXGam,MatYGam,Val{3}'), axis xy, colormap bone
    hold on
    line(log([X1 X1])-gammamean,[min(MatYGam) max(MatYGam)],'color','k','linewidth',4)
    line(log([X2 X2])-gammamean,[min(MatYGam) max(MatYGam)],'color','k','linewidth',4)
    temp=AbortTrans{2};temp=dropShortIntervals(temp,0.5e4);
    for k=[2:7]
        plot(log(Data(Restrict(smooth_ghi,subset(temp,k))))-(gammamean),log(Data(Restrict(smooth_Theta,subset(temp,k))))-(thetamean),'linewidth',2,'color','b')
    end
    title('S to W')
end


