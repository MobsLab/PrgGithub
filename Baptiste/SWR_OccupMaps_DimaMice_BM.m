
clear all
MiceNumber = [905,911,994,1161,1162,1168,1186,1230,1239];
Session_type={'Cond'};
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/HPC_Reactivations/Data
window_around_rip = [0.2 0.2];


for mm=1:length(MiceNumber)
    % moving epochs
    for sess=1:length(Session_type)
        mm
        
        clear Ripples FreezeEpoch LinPos StimEpoch NoiseEpoch Vtsd Spikes Q
        load(['RippleReactInfo_NewRipples_' Session_type{sess} '_Mouse',num2str(MiceNumber(mm)),'.mat'])
        
        try
            TotalNoiseEpoch = or(StimEpoch , NoiseEpoch);
        catch
            try
                TotalNoiseEpoch = NoiseEpoch;
            catch
                TotalNoiseEpoch = intervalSet([],[]);
            end
        end
        
        AfterStimEpoch = intervalSet(Start(StimEpoch) , Start(StimEpoch)+.1e4);
        TotalNoiseEpoch = or(or(StimEpoch , NoiseEpoch) , AfterStimEpoch);
        
        FreezeSafe = and(thresholdIntervals(LinPos,0.6,'Direction','Above') , FreezeEpoch);
        Ripples_Epoch = mergeCloseIntervals(intervalSet(Range(Ripples)-window_around_rip(1)*1e4,Range(Ripples)+window_around_rip(2)*1e4),0.1*1e4);
        Ripples_FreezeSafe = and(Ripples_Epoch , FreezeSafe);
        Ripples_FreezeSafe = Ripples_FreezeSafe-TotalNoiseEpoch;
        
        try
            OccupMap(mm,:,:) = hist2d([Data(Restrict(Xtsd , Ripples_FreezeSafe)) ;0; 0; 1; 1] , [Data(Restrict(Ytsd , Ripples_FreezeSafe)) ;0;1;0;1] , 100 , 100);
            OccupMap2(mm,:,:) = OccupMap(mm,:,:)/sum(sum(squeeze(OccupMap(mm,:,:))));
            OccupMap3(mm,:,:) = squeeze(OccupMap2(mm,:,:))';
        end
        
    end
end
% OccupMap3(OccupMap3==0)=NaN;

clear D
A = squeeze(nanmean(OccupMap3));
for i=1:10
    for ii=1:10
        
        D(i,ii) = nanmean(nanmean(A((i-1)*10+1:i*10,(ii-1)*10+1:ii*10)));
        
    end
end
D(1:8,5:6)=NaN;




%% figures
figure
imagesc(smooth2a(D,1,1))
axis xy, axis off, hold on, axis square, caxis([0 1e-3]), c=caxis;
sizeMap=10; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
colormap hot

a=area([4.6 6.4],[8.4 8.4]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;




%% trash ?
figure
A = squeeze(nanmean(OccupMap3));
A(isnan(A))=0;
imagesc(SmoothDec(A,2))
axis xy, axis off, hold on, axis square, caxis([0 1e-2]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;




%% eyelid
load('/media/nas7/ProjetEmbReact/DataEmbReact/Trajectories_Eyelid_Cond.mat')


clear D D2 D3
A = squeeze(nanmean(OccupMap.Ripples.Cond{1}));
A2 = squeeze(nanmean(OccupMap.Ripples_Blocked.Cond{1}));
A3 = squeeze(nanmean(OccupMap.Ripples_Unblocked.Cond{1}));
for i=1:10
    for ii=1:10
        
        D(i,ii) = nanmean(nanmean(A((i-1)*10+1:i*10,(ii-1)*10+1:ii*10)));
        D2(i,ii) = nanmean(nanmean(A2((i-1)*10+1:i*10,(ii-1)*10+1:ii*10)));
        D3(i,ii) = nanmean(nanmean(A3((i-1)*10+1:i*10,(ii-1)*10+1:ii*10)));
        
    end
end
D(1:8,5:6)=NaN;
D2(1:8,5:6)=NaN;
D3(1:8,5:6)=NaN;

figure
subplot(131)
imagesc(smooth2a(D,1,1))
axis xy, axis off, hold on, axis square, caxis([0 1e-3]), c=caxis;
sizeMap=10; Maze_Frame_BM
colormap hot
a=area([4.6 6.4],[8.4 8.4]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
title('All')

subplot(132)
imagesc(smooth2a(D2,1,1))
axis xy, axis off, hold on, axis square, caxis([0 1e-3]), c=caxis;
sizeMap=10; Maze_Frame_BM
colormap hot
a=area([4.6 6.4],[8.4 8.4]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
title('Blocked')

subplot(133)
imagesc(smooth2a(D3,1,1))
axis xy, axis off, hold on, axis square, caxis([0 1e-3]), c=caxis;
sizeMap=10; Maze_Frame_BM
colormap hot
a=area([4.6 6.4],[8.4 8.4]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
title('Unblocked')



