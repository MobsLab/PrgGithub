
function [Res1,Res2,Ccros,Bcros,nchannelSpk,JP1,JP2,dt]=JPETHComplexSpikesRipples(S,W,cellnames,PlaceCellTrig,Ripples,SleepEpoch,nchannelSpk)

% cd /media/HardBackUp/DataSauvegarde/Mouse029/20120203/ICSS-Mouse-29-03022012
% 
%      
% load SpikeData
% load behavResources
% load Waveforms
% 
% MFBburst=1; num=1; choicTh=5;ControlStimMFBRipplesSleep
%    
% 
% 
% close all
% 
% for PlaceCellTrig=1:length(S)
%     
% 
% M=PlotRipRaw(LFP{num},Ripples,70);

%PlaceCellTrig=20;

nbBinJPETH=500;

        figure('color',[1 1 1]), hold on, [fh,sqA,sweepsA] = RasterPETH(S{PlaceCellTrig},ts(Ripples(:,2)*1E4),-1000,1000);title([num2str(PlaceCellTrig)])
        sPl=Range(Restrict(S{PlaceCellTrig},SleepEpoch));
        %
        % st=Range(Restrict(S{PlaceCellTrig},SleepEpoch),'s');
        % buSpk = burstinfo(st,0.02);
        % burstSpk=tsd(buSpk.t_start*1E4,buSpk.i_start);
        % idburstSpk=buSpk.i_start;
        wfo=PlotWaveforms(W,PlaceCellTrig,SleepEpoch);

        try
        if nchannelSpk(PlaceCellTrig)==0;
        nchannelSpk(PlaceCellTrig)=input('num of channel: ');
        end
        catch
        nchannelSpk(PlaceCellTrig)=input('num of channel: ');
        end
        
        LargeSpk=squeeze(wfo(:,nchannelSpk(PlaceCellTrig),:));

        [BE,id]=sort(LargeSpk(:,14));
        lee=length(id);
        figure('color',[1 1 1]), plot(mean(LargeSpk(id(floor(3*lee/4:lee)),:)),'k')
        hold on, plot(mean(LargeSpk(id(1:1*floor(lee/4)),:)),'r')
        try
        sPl1=sort(sPl(id(1:1*floor(lee/4))));
        sPl2=sort(sPl(id(floor(3*lee/4:lee))));
        end
        
        [C{PlaceCellTrig},B]=CrossCorr(sPl1,sPl2,1,100); title([num2str(PlaceCellTrig),'; sPl1,sPl2'])
        figure('color',[1 1 1]), bar(B,C{PlaceCellTrig},1,'k')
        
        
        [jp1{PlaceCellTrig},dt]=JPETH(Ripples(:,2)*1E4, sPl1,sPl2,1,nbBinJPETH);
        figure('color',[1 1 1]), imagesc(dt,dt,jp1{PlaceCellTrig}), axis xy, title([num2str(PlaceCellTrig),'; Ripples(:,2)*1E4, sPl1,sPl2'])
        yl=ylim;
        hold on, line([yl(1) yl(2)],[0 0],'color','w')
        hold on, line([0 0],[yl(1) yl(2)],'color','w')
        [jp2{PlaceCellTrig},dt]=JPETH(sPl2,Ripples(:,2)*1E4, sPl1,1,nbBinJPETH);
        figure('color',[1 1 1]), imagesc(dt,dt,jp2{PlaceCellTrig}), axis xy, title([num2str(PlaceCellTrig),'; sPl2,Ripples(:,2)*1E4, sPl1'])
        yl=ylim;
        hold on, line([yl(1) yl(2)],[0 0],'color','w')
        hold on, line([0 0],[yl(1) yl(2)],'color','w')
        
        figure('color',[1 1 1]), hold on, [fh,sq1,sweeps1] = RasterPETH(tsd(sPl1,sPl1),ts(Ripples(:,2)*1E4),-1000,1000);title([num2str(PlaceCellTrig),', sPl1']),close
        figure('color',[1 1 1]), hold on, [fh,sq2,sweeps2] = RasterPETH(tsd(sPl2,sPl2),ts(Ripples(:,2)*1E4),-1000,1000);title([num2str(PlaceCellTrig),', sPl1']),close
       
%         figure('color',[1 1 1]), hold on, 
%         plot(Data(sqA)/length(sweepsA),'r')
%         plot(Data(sq1)/length(sweeps1),'k')
%         plot(Data(sq2)/length(sweeps2),'b')
        
        figure('color',[1 1 1]), hold on, 
        subplot(3,1,1),bar(Range(sqA,'ms'), Data(sqA)/length(sweepsA),1,'r') ,xlim([-100 100])%,'linewidth',2)
        subplot(3,1,2),bar(Range(sqA,'ms'), Data(sq1)/length(sweeps1),1,'k') ,xlim([-100 100]), yl1=ylim;
        subplot(3,1,3),bar(Range(sqA,'ms'), Data(sq2)/length(sweeps2),1,'b') ,xlim([-100 100]), yl2=ylim;
        subplot(3,1,2),ylim([0 max(yl1(2),yl2(2))])
        subplot(3,1,3),ylim([0 max(yl1(2),yl2(2))])
        %close all

        Res1=[Range(sqA,'ms'), Data(sq1)/length(sweeps1)];
        Res2=[Range(sqA,'ms'), Data(sq2)/length(sweeps2)];
        
        Ccros=C{PlaceCellTrig};
        Bcros=B;
        
        JP1=jp1{PlaceCellTrig};
        JP2=jp2{PlaceCellTrig};        
% end