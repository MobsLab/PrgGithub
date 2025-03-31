function PlotSafeAndShock(Mice)
    global DATAtable
    nSafeFreez = sum(DATAtable.(Mice).Position > 0.5);
    nShockFreez = sum(DATAtable.(Mice).Position < 0.5);
    if nSafeFreez && nShockFreez
        figure;

        plot(1:2:2*nSafeFreez, runmean(DATAtable.(Mice).OB_Frequency(DATAtable.(Mice).Position > 0.5), 10)), hold on 
        plot(1:2:2*nShockFreez, runmean(DATAtable.(Mice).OB_Frequency(DATAtable.(Mice).Position < 0.5), 10))
        title(Mice)
        xlabel('Concatenated Freezing Time (seconds)')
        ylabel('Breathing (Hz)')
        
    end 
    
end

