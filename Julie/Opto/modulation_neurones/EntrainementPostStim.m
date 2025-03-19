% code non pouruivi
% regardé avec karim, 
% on ne comprend pas ce que nous sort raster PETH
figure, 


PlotErrorSpreadN_KJ(mu,'plotcolors',[0.5 0.5 0.5],'newfig',0);hold on









%%
cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126
sav=0;
plo_indiv=0;
res=pwd;

load StimInfo
load ModNeurons
load SpikeData
load FiringRateBeforeAfter FR

removMUA=1;
[S,NumNeurons,numtt,TT]=GetSpikesFromStructure('PFCx',S,res,removMUA);

for fq=1:8
    ind_OI{fq}=find(StimInfo.Freq==fq_list(fq));
end


[up,down,idxUp,idxDown]=ZeroCrossings([Range(LFPlaser), -1.5+zscore(Data(LFPlaser))]);
uptps=tps(idxUp);
dotps=tps(idxDown);


fq=3;
num=7;
for fq=1:8
 stim_int_dur=subset(int_laser,ind_OI{fq});
figure('Position',[100+fq*300,100,300,500])
[fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH(PoolNeurons(S,id), ts(Start(stim_int_dur)), -10000, 10000,'BinSize',100);% Triggered on opto stim
title (num2str(fq_list(fq)))
end


num29;

 
num=12; % 13 Hz
num=5;% 10.5Hz
figure
[fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH(S{NumNeurons(num)}, ts(Start(stim_int_dur)), -100000, 10000,'BinSize',1000);% Triggered on opto stim

[fh,sq,sweeps] = RasterPETH(S{i}, Restrict(ts(BipP),StimLaserON), -8000,+16000,'BinSize',100,'Markers',{ts(CSp)},'MarkerTypes',{'r*','r'});title(['Cs+ laser ON, ',cellnames{i}])
    


[fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH(S, center, TStart, TEnd, varargin)% Triggered on opto stim



for fq=1:8
    for num=1:length(NumNeurons)
        Pht{num,fq}=[];    
        if size(Data(Restrict(S{NumNeurons(num)},subset(int_laser,ind_OI{fq}))),1)>1
            [Ph] = ModulationSquaredSignal(Restrict(LFPlaser,subset(int_laser,ind_OI{fq})),Restrict(S{NumNeurons(num)},subset(int_laser,ind_OI{fq})), 1,0);
            Pht{num,fq}=[Pht{num,fq};Ph];
        end
    end
end

