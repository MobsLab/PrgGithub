function [M1hr,M2hr,M3hr,M1s,M2s,M3s,M1l,M2l,M3l,M1pr,M2pr,M3pr]=PETHSpindlesRipples(SpiH,SpiL,Rip)


  load LFPdHPC
M1hr=PlotRipRaw(LFP{1},Rip(:,2),80);close
M2hr=PlotRipRaw(LFP{2},Rip(:,2),80);close
try
M3hr=PlotRipRaw(LFP{3},Rip(:,2),80);close
catch
M3hr=[];    
end



load LFPPFCx
M1s=PlotRipRaw(LFP{1},SpiH(:,2),500);close
M2s=PlotRipRaw(LFP{2},SpiH(:,2),500);close
M3s=PlotRipRaw(LFP{3},SpiH(:,2),500);close


M1l=PlotRipRaw(LFP{1},SpiL(:,2),500);close
M2l=PlotRipRaw(LFP{2},SpiL(:,2),500);close
M3l=PlotRipRaw(LFP{3},SpiL(:,2),500);close


M1pr=PlotRipRaw(LFP{1},Rip(:,2),500);close
M2pr=PlotRipRaw(LFP{2},Rip(:,2),500);close
M3pr=PlotRipRaw(LFP{3},Rip(:,2),500);close


figure('color',[1 1 1]), 
try
subplot(2,2,1), plot(M1pr(:,1),M1pr(:,2),'k')
end
try
    hold on, plot(M1pr(:,1),M2pr(:,2),'b')
end
try
    hold on, plot(M1pr(:,1),M3pr(:,2),'r')
end
subplot(2,2,2), 
try
    plot(M1hr(:,1),M1hr(:,2),'k')
end
try
    hold on, plot(M1hr(:,1),M2hr(:,2),'b')
end
try
hold on, plot(M1hr(:,1),M3hr(:,2),'r') 
end
subplot(2,2,3), 
try
plot(M1s(:,1),M1s(:,2),'k')
end
try
    hold on, plot(M1s(:,1),M2s(:,2),'b')
end
try
hold on, plot(M1s(:,1),M3s(:,2),'r')
end
subplot(2,2,4), 
try
plot(M1l(:,1),M1l(:,2),'k')
end
try
hold on, plot(M1l(:,1),M2l(:,2),'b')
end
try
    hold on, plot(M1l(:,1),M3l(:,2),'r')
end