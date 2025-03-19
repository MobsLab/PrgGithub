function PlotThetaRippCorrDuringStim_MC(plo)

try
    plo;
catch
    plo=0;
end

load LFPData/LFP1 LFP

load SleepScoring_OBGamma REMEpochWiNoise SmoothTheta 
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);

%to get opto stimulations
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
StimR=Range(Restrict(Stimts,REMEp))/1E4;

%to compute triggered ripples spectro averaged accross stimulations
load('Ripples.mat')
[Y,X] = hist(Start(RipplesEpoch,'s'),[0:1:max(Range(LFP,'s'))]);
Ripples_tsd = tsd(X*1E4,Y');
[MatRemRip,TpsRemRip] = PlotRipRaw_MC(Ripples_tsd, StimR, 60000, 0, 0);

%to get theta HPC signal around the stims
[MatRemThet,TpsRemThet] = PlotRipRaw_MC(SmoothTheta, StimR, 60000, 0, 0);

%to get time window of the opto stims
idxduring=find(MatRemRip(:,1)>0&MatRemRip(:,1)<60);
idxbefore=find(MatRemRip(:,1)>-60&MatRemRip(:,1)<0);


resRippBefore=[];
resThetBefore=[];
resRippDuring=[];
resThetDuring=[];
%loop to get ripples density and theta power during the opto stim
for k=1:length(StimREM)
    resRippDuring=[resRippDuring;TpsRemRip(k,idxduring)];
    resThetDuring=[resThetDuring;TpsRemThet(k,idxduring)];
    
    resRippBefore=[resRippBefore;TpsRemRip(k,idxbefore)];
    resThetBefore=[resThetBefore;TpsRemThet(k,idxbefore)];
end

if plo
    % correlation theta ripples
    h=figure('Color',[1 1 1]);
    s1=plot(mean(resThetDuring,2),mean(resRippDuring,2),'k+');
    set(s1,'MarkerSize',8,'Linewidth',2);
    hold on
    s2=plot(mean(resThetBefore,2),mean(resRippBefore,2),'r+');
    set(s2,'MarkerSize',8,'Linewidth',2);
    l=lsline;
    set(l,'LineWidth',1.5)
    xlabel('theta power')
    ylabel('ripples density (ripples/s)')
end

end
