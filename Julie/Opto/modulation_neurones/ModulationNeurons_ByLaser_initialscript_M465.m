% ModulationNeurons_ByLaser
% 09.05.2017

cd /media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126
res=pwd; 

load StimInfo
load([res,'/LFPData/InfoLFP']);

% get laser stim
temp=load('LFPData/LFP32.mat');
LFPlaser=temp.LFP;

int_laser=intervalSet(StimInfo.StartTime*1E4, StimInfo.StopTime*1E4);

ind_OI{1}=find(StimInfo.Freq==1);
ind_OI{2}=find(StimInfo.Freq==2);
ind_OI{3}=find(StimInfo.Freq==4);
ind_OI{4}=find(StimInfo.Freq==7);
ind_OI{5}=find(StimInfo.Freq==10);
ind_OI{6}=find(StimInfo.Freq==13);
ind_OI{7}=find(StimInfo.Freq==15);
ind_OI{8}=find(StimInfo.Freq==20);



if 0
figure, plot(Range(Restrict(LFPlaser,subset(int_laser,ind_OI(1))))*1E-4, Data(Restrict(LFPlaser,subset(int_laser,ind_OI(1)))))
end

WindWid=0.25;


% get spikes
if ~exist('S','var')
    load SpikeData.mat
end

removMUA=1;
[S,NumNeurons,numtt,TT]=GetSpikesFromStructure('PFCx',S,res,removMUA);


        
        % Triggered on opto stim
      
 
for fq=1:8
    for num=1:length(NumNeurons)
        Pht{num,fq}=[];    
        if size(Data(Restrict(S{NumNeurons(num)},subset(int_laser,ind_OI{fq}))),1)>1
            [Ph] = ModulationSquaredSignal(Restrict(LFPlaser,subset(int_laser,ind_OI{fq})),Restrict(S{NumNeurons(num)},subset(int_laser,ind_OI{fq})), 1,0);
            Pht{num,fq}=[Pht{num,fq};Ph];
        end
    end
end

for fq=1:8
    figure('Position',[  124          72        1710         902])
    
    for num=1:length(NumNeurons)

        subplot(5,8,num)
        try
            [mu(num,fq), Kappa(num,fq), pval(num,fq)] =JustPoltMod(Pht{num,fq},25);
        end
        if num==1,
            text(-0.5,1.5,['freq ' num2str(fq)],'units','normalized')
        end
    end
    saveas(gcf,[res '/modulation/freq' num2str(fq)])
    saveFigure(gcf,['freq' num2str(fq)],[res '/modulation/'])
end

K=Kappa;
K(pval>0.05)=nan;

PlotErrorSpreadN_KJ(K,'plotcolors',[0.7 0.7 0.7]);
set(gca,'xticklabel',[1 2 4 7 10 13 15 20])
ylim([0 0.65])
xlabel('stim frequency')
ylabel('Kappa')
title('only signficantly modulated neurons')
saveas(gcf,'Kappa')
saveFigure(gcf,'Kappa',res)

figure
PlotErrorBarN(K)
saveas(gcf,'PlotErrorBarN')
saveFigure(gcf,'PlotErrorBarN',res)

figure, bar(sum(~isnan(K)))
ylabel('nb signficantly modulated neurons')
xlabel('stim frequency')
saveas(gcf,'nb_mod_neurons')
saveFigure(gcf,'nb_mod_neurons',res)
%      for k=1:length(ind_OI)
%         figure('Position',[  124          72        1710         902])
%         for num=1:length(NumNeurons)
%             subplot(5,8,num)
%             if size(Data(Restrict(S{NumNeurons(num)},subset(int_laser,ind_OI(k)))),1)>1
%             [mu, Kappa, pval] = ModulationSquaredSignal(Restrict(LFPlaser,subset(int_laser,ind_OI(k))),S{NumNeurons(num)}, 1,0);
%             end
%         end
%     end
        
        
        
        
        
        ss=start(subset(int_laser,ind_OI(1)));
        ee=start(subset(int_laser,ind_OI(1)))+2*WindWid*1E4;
        interv=intervalSet(ss,ee);
        
        
        for num=1:length(NumNeurons)
        
            disp(['neuron #' num2str(num)])
            figure
            [fh,sq{num},sweeps{num}, rasterAx, histAx,dArea]=RasterPETH(S{NumNeurons(num)},ts(StTimes),-WindWid*1e4,WindWid*1e4,'BinSize',20);
            hold on
            
            hold on, plot((Range(Restrict(LFPlaser,interv))-ss-WindWid*1E4)*1E-1, Data(Restrict(LFPlaser,interv))*0.05,'r')
            
            
                [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{1,c},BroadStimEpoch,30,0);
                
%             [fh,sq{struct}{1,num},sweeps{struct}{1,num}, rasterAx, histAx,dArea]=RasterPETH(S{NumNeurons(num)},ts(StTimes),-WindWid*1e4,WindWid*1e4,'BinSize',20);
%             keyboard
%             [fh,sq{struct}{2,num},sweeps{struct}{2,num}, rasterAx, histAx,dArea]=RasterPETH(S{NumNeurons(num)},CSMoinsimes,-WindWidSnd*1e4,WindWidSnd*1e4,'BinSize',50);close(fh)
%             [fh,sq{struct}{3,num},sweeps{struct}{3,num}, rasterAx, histAx,dArea]=RasterPETH(S{NumNeurons(num)},CSPlusTimes,-WindWidSnd*1e4,WindWidSnd*1e4,'BinSize',50);close(fh)
%             FR(num)=length(S{NumNeurons(num)})/max(Range(LFP,'s'));
%             for c=1:2
%                 [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{1,c},BroadStimEpoch,30,0);
%                 [ph,mu{struct}(2+c,num), Kappa{struct}(2+c,num), pval{struct}(2+c,num),B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{1,c},NoStimEpoch,30,0);
%                 [ph,mu{struct}(4+c,num), Kappa{struct}(4+c,num), pval{struct}(4+c,num),B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{2,c},BroadStimEpoch,30,0);
%                 [ph,mu{struct}(6+c,num), Kappa{struct}(6+c,num), pval{struct}(6+c,num),B,C]=ModulationTheta(S{NumNeurons(num)},FilLFP{2,c},NoStimEpoch,30,0);
%                 
%             end
        end