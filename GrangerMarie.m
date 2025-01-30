function [granger2, granger_F, granger_pvalue,Fx2y,Fy2x,freqBin,S1,S2,t,f,Ctsd,confC,phistd]= GrangerMarie(LFP1,LFP2,Epoch,order,params,movingwin,plo,freqBin)


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
try
    freqBin;
catch
    freqBin=[0.1:0.1:params.Fs/2];
end
try
    movingwin;
catch
    movingwin=[3 0.1];
end


[C,phi,S12c,S1,S2,t,f,confC,phistd]=cohgramc(Data(Restrict(LFP1,Epoch)),Data(Restrict(LFP2,Restrict(LFP1,Epoch))),movingwin,params);

%C(C<confC)=0;

Ctsd=tsd(t*1E4,C);

[granger2, granger_F, granger_pvalue, granger_num, granger_den, granger_num_dof, granger_den_dof, granger_dir, granger_inst]=etc_granger([Data(Restrict(LFP1,Epoch)),Data(Restrict(LFP2,Restrict(LFP1,Epoch)))],order,'ts_name',{'LFP1','LFP2'});




[Fx2y,Fy2x]= one_bi_ga([Data(Restrict(LFP1,Epoch)),Data(Restrict(LFP2,Restrict(LFP1,Epoch)))],1,length(Data(Restrict(LFP1,Epoch))),order,params.Fs,freqBin);


if plo
    
    rg1=Range(Restrict(LFP1,Epoch),'s');

    MaxScal=params.fpass(2)/2;


    figure('Color',[1 1 1]), hold on
    subplot(2,2,1:2), 
    imagesc(t+rg1(1),f,C'), axis xy, hold on
    %plot(Range(Restrict(LFP1,Epoch),'s'),rescale(Data(Restrict(LFP1,Epoch)),2*MaxScal/4,3*MaxScal/4),'k','linewidth',2)
    %hold on, plot(Range(Restrict(LFP2,Epoch),'s'),rescale(Data(Restrict(LFP2,Epoch)),3*MaxScal/4,MaxScal),'k','linewidth',2)
    xlabel('time (s)'),ylabel('frequencies (Hz)'), title(['coherogram ' sprintf('%0.0f',tot_length(Epoch,'s')) ' sec'])  
    ylim([params.fpass])

    subplot(2,2,3), hold on
    plot(f,mean(Data(Ctsd)),'b','linewidth',2)
    plot([params.fpass], [confC confC], ':', 'Color', [0.5 0.5 0.5])
    ylabel('Coherence'), xlabel('frequencies (Hz)')
    ylim([0 1])

    subplot(2,2,4), hold on
    plot(freqBin,Fx2y,'k','linewidth',2), 
    hold on, plot(freqBin,Fy2x,'r','linewidth',2)
    title('Granger') 
    xlabel('frequencies (Hz)')
    legend('1->2', '2->1');

    yl=ylim; ylim([0 max(1,yl(2))])
    %xlim([params.fpass])
    set(gcf,'position',[16   390   713   425])


end

