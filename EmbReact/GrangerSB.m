function [Fx2y,Fy2x,freqBin]= GrangerSB(LFP1,LFP2,Epoch,order,params,movingwin,plo,StrucName)


% [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin]= GrangerMarie(LFP1,LFP2,Epoch,order,params,movingwin,plo)
%



% cd /media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse061/20130503
%
% load('LFPData/LFP4.mat')
%
% LFP1=LFP; % hpc
% load('LFPData/LFP7.mat')
%
% LFP2=LFP; %bulb
%
% load('/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Mouse061/20130503/SleepStagesPaCxDeep.mat')
%
% Epoch=subset(REMEpoch,3);


%--------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------

try
    order;
catch
    order=16;
end

try
    plo;
catch
    plo=1;
end

if round(1/median(diff(Range(LFP1,'s'))))>300
    LFP1=ResampleTSD(LFP1,250);
    LFP2=ResampleTSD(LFP2,250);
end


try
    params;
    params.Fs=round(1/median(diff(Range(LFP1,'s'))));
catch
    params.Fs=round(1/median(diff(Range(LFP1,'s'))));
    params.tapers=[3 9];
    params.pad=1;
    params.fpass=[0 min(125 ,params.Fs/2)];
    params.err=[1 0.05];
end


freqBin=[0.1:0.1:params.Fs/2];

try
    movingwin;
catch
    movingwin=[3 0.1];
end

[Fx2y,Fy2x]= one_bi_ga([Data(Restrict(LFP1,Epoch)),Data(Restrict(LFP2,Restrict(LFP1,Epoch)))],1,length(Data(Restrict(LFP1,Epoch))),order,params.Fs,freqBin);


if plo
    
    rg1=Range(Restrict(LFP1,Epoch),'s');
    
    MaxScal=params.fpass(2)/2;
    
    
    figure('Color',[1 1 1]), hold on
    
    plot(freqBin,Fx2y,'k','linewidth',2),
    hold on, plot(freqBin,Fy2x,'r','linewidth',2)
    title('Granger')
    xlabel('frequencies (Hz)')
    try
        legend([StrucName{1},'->',StrucName{2}],[StrucName{2},'->',StrucName{1}]);
    catch
        legend('1->2', '2->1');
    end
    yl=ylim; ylim([0 max(1,yl(2))])
    %xlim([params.fpass])
    set(gcf,'position',[16   390   713   425])
    
    
end

