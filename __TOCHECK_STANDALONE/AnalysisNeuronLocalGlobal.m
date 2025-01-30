%AnalysisNeuronLocalGlobal

%filename='/media/GeorgeBackUp/DataDisk2/DataMMN/Mouse039/spikes/MMN-Mouse-38-11062012old';
filename='/media/GeorgeBackUp/DataDisk2/DataMMN/Mouse039/spikes/MMN-Mouse-38-11062012old/Figures';
%filename='/media/DISK_1/Dropbox/MMNP3b/FigureERCDehaene';

filename='/Volumes/HD-EG5/DataMMN/Mouse039/11062012/spikes/MMN-Mouse-38-11062012';

filename='/media/HP Portable Drive/DataElectrophy/DataMMN/Mouse039/15062012/spikes/MMN-Mouse-39-15062012');


load SpikeData
load Newstim

li=1;

try 
    TimeCorrection;
catch
    TimeCorrection=0;
end

try
    listAudNeuron;
catch
    listAudNeuron=[1:length(S)];
end

rg=Range(Ctrl{3},'ms');

if TimeCorrection
    FactorCorrection=1-23/(rg(end)-rg(1));
else
    FactorCorrection=1;
end


for num=listAudNeuron
figure('color',[1 1 1]), [fh,sq,sweeps] = RasterPETH(S{num}, ts(Range(Ctrl{3})*FactorCorrection), -6000, +6000,'BinSize',50);title(['Neuron n',num2str(num), ' ', cellnames{num},' Std'])
eval(['saveFigure(',num2str(gcf),',''FigureXXyNeuronNstd',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close
figure('color',[1 1 1]), [fh,sq2,sweeps2] = RasterPETH(S{num}, ts(Range(Dev{3})*FactorCorrection), -6000, +6000,'BinSize',50);title(['Neuron n',num2str(num), ' ', cellnames{num},' Dev'])
eval(['saveFigure(',num2str(gcf),',''FigureXXyNeuronNdev',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close

figure('color',[1 1 1]),
subplot(2,1,1), plot(Data(sq)/length(sweeps),'k','linewidth',li)
hold on, plot(Data(sq2)/length(sweeps2),'r','linewidth',li)
title(['XXy, Neuron n',num2str(num), ' ', cellnames{num}])
subplot(2,1,2), 
 plot(smooth(Data(sq)/length(sweeps),3),'k','linewidth',li)
hold on, plot(smooth(Data(sq2)/length(sweeps2),3),'r','linewidth',li)
eval(['saveFigure(',num2str(gcf),',''FigureXXyNeuronN',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close all
end


for num=listAudNeuron
figure('color',[1 1 1]), [fh,sq,sweeps] = RasterPETH(S{num}, ts(Range(Ctrl{4})*FactorCorrection), -6000, +6000,'BinSize',50);title(['Neuron n',num2str(num), ' ', cellnames{num},' Std'])
eval(['saveFigure(',num2str(gcf),',''FigureXyXNeuronNstd',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close
figure('color',[1 1 1]), [fh,sq2,sweeps2] = RasterPETH(S{num}, ts(Range(Dev{4})*FactorCorrection), -6000, +6000,'BinSize',50);title(['Neuron n',num2str(num), ' ', cellnames{num},' Dev'])
eval(['saveFigure(',num2str(gcf),',''FigureXyXNeuronNdev',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close

figure('color',[1 1 1]),
subplot(2,1,1), plot(Data(sq)/length(sweeps),'k','linewidth',li)
hold on, plot(Data(sq2)/length(sweeps2),'r','linewidth',li)
title(['XyX, Neuron n',num2str(num), ' ', cellnames{num}])
subplot(2,1,2), 
 plot(smooth(Data(sq)/length(sweeps),3),'k','linewidth',li)
hold on, plot(smooth(Data(sq2)/length(sweeps2),3),'r','linewidth',li)
eval(['saveFigure(',num2str(gcf),',''FigureXyXNeuronN',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close all
end





for num=listAudNeuron
figure('color',[1 1 1]), [fh,sq,sweeps] = RasterPETH(S{num}, ts(Range(Dev{6})*FactorCorrection), -6000, +6000,'BinSize',50);title(['Neuron n',num2str(num), ' ', cellnames{num},' Std'])
eval(['saveFigure(',num2str(gcf),',''FigureYYxNeuronNstd',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close
figure('color',[1 1 1]), [fh,sq2,sweeps2] = RasterPETH(S{num}, ts(Range(Ctrl{6})*FactorCorrection), -6000, +6000,'BinSize',50);title(['Neuron n',num2str(num), ' ', cellnames{num},' Dev'])
eval(['saveFigure(',num2str(gcf),',''FigureYYxNeuronNdev',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close

figure('color',[1 1 1]),
subplot(2,1,1), plot(Data(sq)/length(sweeps),'k','linewidth',li)
hold on, plot(Data(sq2)/length(sweeps2),'r','linewidth',li)
title(['YYx, Neuron n',num2str(num), ' ', cellnames{num}])
subplot(2,1,2), 
 plot(smooth(Data(sq)/length(sweeps),3),'k','linewidth',li)
hold on, plot(smooth(Data(sq2)/length(sweeps2),3),'r','linewidth',li)
eval(['saveFigure(',num2str(gcf),',''FigureYYxNeuronN',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close all
end






for num=listAudNeuron
figure('color',[1 1 1]), [fh,sq,sweeps] = RasterPETH(S{num}, ts(Range(Dev{7})*FactorCorrection), -6000, +6000,'BinSize',50);title(['Neuron n',num2str(num), ' ', cellnames{num},' Std'])
eval(['saveFigure(',num2str(gcf),',''FigureYxYNeuronNstd',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close
figure('color',[1 1 1]), [fh,sq2,sweeps2] = RasterPETH(S{num}, ts(Range(Ctrl{7})*FactorCorrection), -6000, +6000,'BinSize',50);title(['Neuron n',num2str(num), ' ', cellnames{num},' Dev'])
eval(['saveFigure(',num2str(gcf),',''FigureYxYNeuronNdev',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close

figure('color',[1 1 1]),
subplot(2,1,1), plot(Data(sq)/length(sweeps),'k','linewidth',li)
hold on, plot(Data(sq2)/length(sweeps2),'r','linewidth',li)
title(['YxY, Neuron n',num2str(num), ' ', cellnames{num}])
subplot(2,1,2), 
 plot(smooth(Data(sq)/length(sweeps),3),'k','linewidth',li)
hold on, plot(smooth(Data(sq2)/length(sweeps2),3),'r','linewidth',li)
eval(['saveFigure(',num2str(gcf),',''FigureYxYNeuronN',num2str(num),'-',cellnames{num},''',''',filename,''')'])
close all
end








