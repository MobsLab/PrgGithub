%%% Plot Data Marie
Display=5; %en secondes
StartDisplay=0; %en secondes

 try
        load SpikeData
        load LFPData
        load behavResources
 catch
     makeData
 end
 
 try 
     listGoodLFP;
 catch
     listGoodLFP=[1 2 3 4];
 end

% ---------- plot LFP --------

figure('Color',[1 1 1]), f=gcf;
Stim{1}=stim;
hold on, subplot(3,1,1), RasterPlot(Stim,'FigureHandle',f)

color={'r' 'k' 'b' 'c'};
for i=listGoodLFP
hold on, subplot(3,1,2), plot(Range(LFP{i},'s'),i*1E4+Data(LFP{i}),color{i})
end

% -------Raster Plot ----------
Leg={};
for s=1:length(S)
    Leg=[Leg ['T',num2str(TT{s}(1)),' N',num2str(TT{s}(2))]];
end
hold on, subplot(3,1,3), RasterPlot(S(2:4),'FigureHandle',f)
legend(Leg);


n=StartDisplay;
GoON='+';
while GoON~='f'
    subplot(3,1,1), xlim([n n+Display]*1E4);
    subplot(3,1,2), xlim([n n+Display]);
    subplot(3,1,3), xlim([n n+Display]*1E4);

    GoON=input('Go to next/previous pannel(+/-) or Finish/Save(f/s) or chose Parameter(p) :','s');
    if GoON=='+'    
        n=n+Display;
    elseif GoON=='-'
        n=n-Display;
    elseif GoON=='s'
        filename=input('Give a name to the figure: ','s');
        saveFigure(f,filename,'/media/DISK_1/Dropbox/MasterMarie/Figures/');
        disp([num2str(filename),' saved.']);
        GoON=input('Go to next/previous pannel(+/-) or Finish/Save(f/s) or chose Parameter(p) :','s');
    elseif GoON=='p'
        Display=input('Length of Display (s) :');
        n=input('Start of the Display (s) :');
    end
end

