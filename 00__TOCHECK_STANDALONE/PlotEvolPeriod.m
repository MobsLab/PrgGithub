function [M,StateBef]=PlotEvolPeriod(Sp,t,f,Epoch)



limitSWS=30;
lim1=2;
lim2=4;
Stsd=tsd(t*1E4,Sp);

load StateEpochSB SWSEpoch REMEpoch Wake wakeper TotalNoiseEpoch GndNoiseEpoch

SWSEpoch=and(SWSEpoch,Epoch);
REMEpoch=and(REMEpoch,Epoch);
Wake=and(Wake,Epoch);


Sle=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1,10); close
Sle=Restrict(Sle,Epoch);

load behavResources Movtsd
st=Start(SWSEpoch);
%t=Range(Movtsd);
%temp=(Data(Restrict(Sle,ts(st-600))));
for i=1:length(Start(SWSEpoch))
    temp=(Data(Restrict(Sle,intervalSet(st(i)-650,st(i)))));
    try
        StateBefIni(i)=temp(1);
    catch
    ttemp=Data(Sle);
    StateBefIni(i)=ttemp(1);
    end
    
end

id=find(StateBefIni>-1);
SWSEpoch=subset(SWSEpoch,id);
SWSEpoch=dropShortIntervals(SWSEpoch,1E4);


figure('color',[1 1 1])
subplot(1,3,1:2)
imagesc(t,f,10*log10(Sp')), axis xy
Sle=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,10); 
Sle=Restrict(Sle,Epoch);

subplot(1,3,3),
DurSWS=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
DurREM=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
DurWake=sum(End(Wake,'s')-Start(Wake,'s'));
DurTot=sum(End(Epoch,'s')-Start(Epoch,'s'));
PlotErrorBar3(DurWake/DurTot*100, DurSWS/DurTot*100, DurREM/DurTot*100,0,0)

legendStateBef{1}='State before SWS';
legendStateBef{2}='% of wake before SWS (10 min)';
legendStateBef{3}='% of REM before SWS (10 min)';
legendStateBef{4}='% of wake before SWS (1 min)';
legendStateBef{5}='% of REM before SWS (1 min)';

legendM{1}='Power Bulb 2-4Hz';
legendM{2}='std Power Bulb 2-4Hz';
legendM{3}='Duration SWS (s)';
legendM{4}='Power Bulb 2-4Hz (0-15s)';
legendM{5}='Power Bulb 2-4Hz (15-30s)';



clear M
 for i=1:length(Start(SWSEpoch))
     
    Sp2=Data(Restrict(Stsd,subset(SWSEpoch,i)));
    Ep=subset(SWSEpoch,i);
    Ep2=intervalSet(Start(Ep),Start(Ep)+limitSWS/2*1E4);
    Ep3=and(Ep,Ep2);
    Sp3=Data(Restrict(Stsd,Ep3));
    
    Ep4=intervalSet(Start(Ep)+15E4,Start(Ep)+limitSWS*1E4);
    Ep5=and(Ep,Ep4);
    Sp4=Data(Restrict(Stsd,Ep5));
    
    M(i,1)=mean(mean(Sp2(:,find(f>lim1&f<lim2)),2));
    M(i,2)=std(mean(Sp2(:,find(f>lim1&f<lim2)),2));
    M(i,3)=sum(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'));
    M(i,4)=mean(mean(Sp3(:,find(f>lim1&f<lim2)),2));
    M(i,5)=mean(mean(Sp4(:,find(f>lim1&f<lim2)),2));
    
 end


 
figure('color',[1 1 1]),
plot(M(:,1),'k','linewidth',2)
hold on, plot(M(:,1)+M(:,2),'k','linewidth',1)
hold on, plot(M(:,1)-M(:,2),'k','linewidth',1)
hold on, plot(M(:,3)*1E3,'color',[0.7 0.7 0.7])
[r,p]=corrcoef(1:size(M,1),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
ylabel('Power 2-4 Hz')

 
 
clear StateBef


load behavResources Movtsd
st=Start(SWSEpoch);
%t=Range(Movtsd);
%temp=(Data(Restrict(Sle,ts(st-600))));
for i=1:length(Start(SWSEpoch))
    temp=(Data(Restrict(Sle,intervalSet(st(i)-650,st(i)))));
    StateBef(i,1)=temp(1);
end

for i=1:length(Start(SWSEpoch))
    ctrl=(Data(Restrict(Sle,intervalSet(st(i)-10*60E4,st(i)))));
    StateBef(i,2)=length(find(ctrl==4))/length(ctrl)*100;
    StateBef(i,3)=length(find(ctrl==3))/length(ctrl)*100;

    ctrl=(Data(Restrict(Sle,intervalSet(st(i)-2*60E4,st(i)))));
    StateBef(i,4)=length(find(ctrl==4))/length(ctrl)*100;
    StateBef(i,5)=length(find(ctrl==3))/length(ctrl)*100;
end

figure('color',[1 1 1]), hist(StateBef(:,1),[-1:5])


stSWS=Start(SWSEpoch,'s');





%%
 if 0
            figure('color',[1 1 1]),
            subplot(3,2,1), scatter(StateBef(:,2),M(:,1),50,stSWS,'filled')
            [r,p]=corrcoef(StateBef(:,2),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            ylabel('Power in 2-4Hz')
            xlim([0 100])

            subplot(3,2,2), scatter(StateBef(:,3),M(:,1),50,stSWS,'filled')
            [r,p]=corrcoef(StateBef(:,3),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlim([0 100])

            subplot(3,2,3), scatter(StateBef(:,2),M(:,4),50,stSWS,'filled')
            [r,p]=corrcoef(StateBef(:,2),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            ylabel('Power in 2-4Hz in the 15 first sec')
            xlim([0 100])

            subplot(3,2,4), scatter(StateBef(:,3),M(:,4),50,stSWS,'filled')
            [r,p]=corrcoef(StateBef(:,3),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlim([0 100])

            idx=find(~isnan(M(:,5)));
            subplot(3,2,5), scatter(StateBef(idx,2),M(idx,5),50,stSWS(idx),'filled')
            [r,p]=corrcoef(StateBef(idx,2),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlabel('% of Wake in the 10 min before SWS')
            ylabel('Power in 2-4Hz in the periods 15-30 sec')
            xlim([0 100])

            subplot(3,2,6), scatter(StateBef(idx,3),M(idx,5),50,stSWS(idx),'filled')
            [r,p]=corrcoef(StateBef(idx,3),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlabel('% of REM in the 10 min before SWS')
            xlim([0 100])

            figure('color',[1 1 1]),
            subplot(3,2,1), scatter(StateBef(:,4),M(:,1),50,stSWS,'filled')
            [r,p]=corrcoef(StateBef(:,4),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            ylabel('Power in 2-4Hz')
            xlim([0 100])

            subplot(3,2,2), scatter(StateBef(:,5),M(:,1),50,stSWS,'filled')
            [r,p]=corrcoef(StateBef(:,5),M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlim([0 100])

            subplot(3,2,3), scatter(StateBef(:,4),M(:,4),50,stSWS,'filled')
            [r,p]=corrcoef(StateBef(:,4),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            ylabel('Power in 2-4Hz in the 15 first sec')
            xlim([0 100])

            subplot(3,2,4), scatter(StateBef(:,5),M(:,4),50,stSWS,'filled')
            [r,p]=corrcoef(StateBef(:,5),M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlim([0 100])

            idx=find(~isnan(M(:,5)));
            subplot(3,2,5), scatter(StateBef(idx,4),M(idx,5),50,stSWS(idx),'filled')
            [r,p]=corrcoef(StateBef(idx,4),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlabel('% of Wake in the 2 min before SWS')
            ylabel('Power in 2-4Hz in the periods 15-30 sec')
            xlim([0 100])

            subplot(3,2,6), scatter(StateBef(idx,5),M(idx,5),50,stSWS(idx),'filled')
            [r,p]=corrcoef(StateBef(idx,5),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlabel('% of REM in the 2 min before SWS')
            xlim([0 100])







            figure('color',[1 1 1]),
            subplot(3,2,1), scatter(stSWS,M(:,1),50,StateBef(:,2),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS,M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            ylabel('Power in 2-4Hz')
            % xlim([0 100])

            subplot(3,2,2), scatter(stSWS,M(:,1),50,StateBef(:,3),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS,M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            % xlim([0 100])

            subplot(3,2,3), scatter(stSWS,M(:,4),50,StateBef(:,2),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS,M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            ylabel('Power in 2-4Hz in the 15 first sec')
            % xlim([0 100])

            subplot(3,2,4), scatter(stSWS,M(:,4),50,StateBef(:,3),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS,M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            % xlim([0 100])

            idx=find(~isnan(M(:,5)));
            subplot(3,2,5), scatter(stSWS(idx),M(idx,5),50,StateBef(idx,2),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS(idx),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlabel('Time of SWS (caxis: % wake before)')
            ylabel('Power in 2-4Hz in the periods 15-30 sec')
            % xlim([0 100])

            subplot(3,2,6), scatter(stSWS(idx),M(idx,5),50,StateBef(idx,3),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS(idx),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlabel('Time of SWS (caxis: % REM Before)'), caxis([0 100])
            % xlim([0 100])


            figure('color',[1 1 1]),
            subplot(3,2,1), scatter(stSWS,M(:,1),50,StateBef(:,4),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS,M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            ylabel('Power in 2-4Hz'), caxis([0 100])
            % xlim([0 100])

            subplot(3,2,2), scatter(stSWS,M(:,1),50,StateBef(:,5),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS,M(:,1));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            % xlim([0 100])

            subplot(3,2,3), scatter(stSWS,M(:,4),50,StateBef(:,4),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS,M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            ylabel('Power in 2-4Hz in the 15 first sec')
            % xlim([0 100])

            subplot(3,2,4), scatter(stSWS,M(:,4),50,StateBef(:,5),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS,M(:,4));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            % xlim([0 100])
            % 
            idx=find(~isnan(M(:,5)));
            subplot(3,2,5), scatter(stSWS(idx),M(idx,5),50,StateBef(idx,4),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS(idx),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlabel('Time of SWS (caxis: % wake before)')
            ylabel('Power in 2-4Hz in the periods 15-30 sec')
            % xlim([0 100])

            subplot(3,2,6), scatter(stSWS(idx),M(idx,5),50,StateBef(idx,5),'filled'), caxis([0 100])
            [r,p]=corrcoef(stSWS(idx),M(idx,5));title(['r=',num2str(floor(r(2,1)*100)/100),', p=',num2str(floor(p(2,1)*1000)/1000)])
            xlabel('Time of SWS (caxis: % REM before)')
            % xlim([0 100])

end





figure('color',[1 1 1]), 
subplot(2,2,4), dis=PlotLine3D(stSWS,StateBef(:,2),M(:,1),0);
xlabel('Start SWS')
zlabel(legendM{1})
ylabel(legendStateBef{2})
subplot(2,2,1), scatter(stSWS,M(:,1),30,StateBef(:,2),'filled')
xlabel('Start SWS')
ylabel(legendM{1})
subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,M(:,1),'filled')
xlabel(legendStateBef{2})
ylabel('Start SWS')
subplot(2,2,3), scatter(StateBef(:,2),M(:,1),30,stSWS,'filled')
xlabel(legendStateBef{2})
ylabel(legendM{1})

  figure('color',[1 1 1]), 
subplot(2,2,4), dis=PlotLine3D(stSWS,StateBef(:,2),M(:,4),0);
xlabel('Start SWS')
zlabel(legendM{4})
ylabel(legendStateBef{2})
subplot(2,2,1), scatter(stSWS,M(:,4),30,StateBef(:,2),'filled')
xlabel('Start SWS')
ylabel(legendM{4})
subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,M(:,4),'filled')
xlabel(legendStateBef{2})
ylabel('Start SWS')
subplot(2,2,3), scatter(StateBef(:,2),M(:,4),30,stSWS,'filled')
xlabel(legendStateBef{2})
ylabel(legendM{4})
      
        
        
        
        
        
        
if 0


        figure('color',[1 1 1]), 
        subplot(2,2,4), dis=PlotLine3D(stSWS,M(:,1),StateBef(:,2),0);
        subplot(2,2,1), scatter(stSWS,M(:,1),30,dis,'filled')
        xlabel('Start SWS')
        ylabel(legendM{1})
        subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,dis,'filled')
        xlabel(legendStateBef{2})
        ylabel('Start SWS')
        subplot(2,2,3), scatter(StateBef(:,2),M(:,1),30,dis,'filled')
        xlabel(legendStateBef{2})
        ylabel(legendM{1})


        figure('color',[1 1 1]), 
        subplot(2,2,4), dis=PlotLine3D(stSWS,M(:,4),StateBef(:,2),0);
        subplot(2,2,1), scatter(stSWS,M(:,4),30,dis,'filled')
        xlabel('Start SWS')
        ylabel(legendM{4})
        subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,dis,'filled')
        xlabel(legendStateBef{2})
        ylabel('Start SWS')
        subplot(2,2,3), scatter(StateBef(:,2),M(:,4),30,dis,'filled')
        xlabel(legendStateBef{2})
        ylabel(legendM{4})


        figure('color',[1 1 1]), 
        subplot(2,2,4), dis=PlotLine3D(stSWS,M(:,1),StateBef(:,4),0);
        subplot(2,2,1), scatter(stSWS,M(:,1),30,dis,'filled')
        xlabel('Start SWS')
        ylabel(legendM{1})
        subplot(2,2,2), scatter(StateBef(:,4),stSWS,30,dis,'filled')
        xlabel(legendStateBef{4})
        ylabel('Start SWS')
        subplot(2,2,3), scatter(StateBef(:,4),M(:,1),30,dis,'filled')
        xlabel(legendStateBef{4})
        ylabel(legendM{1})

        figure('color',[1 1 1]), 
        subplot(2,2,4), dis=PlotLine3D(stSWS,M(:,4),StateBef(:,3),0);
        subplot(2,2,1), scatter(stSWS,M(:,4),30,dis,'filled')
        xlabel('Start SWS')
        ylabel(legendM{4})
        subplot(2,2,2), scatter(StateBef(:,2),stSWS,30,dis,'filled')
        xlabel(legendStateBef{2})
        ylabel('Start SWS')
        subplot(2,2,3), scatter(StateBef(:,2),M(:,4),30,dis,'filled')
        xlabel(legendStateBef{2})
        ylabel(legendM{4})


end



 