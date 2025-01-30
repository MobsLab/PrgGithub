DataLocationPFCMultipleDepths

%% Spectra and coherence

for m=1:mm
    
    for ff=1:length(Filename{m})
        cd(Filename{m}{ff})
        disp(Filename{m}{ff})
        clear channel
        load('ChannelsToAnalyse/Bulb_deep.mat')
        LoadSpectrumML(channel,pwd,'low');
        
        for cc=1:size(AllChans{m},2)
            
            LoadSpectrumML(AllChans{m}(cc),pwd,'low');
            
            LoadCohgramML(channel,AllChans{m}(cc),pwd,'low');
            
            
        end
        
        
    end
    cd(SleepSession{m})
    disp(SleepSession{m})
    
    LoadSpectrumML(channel,pwd,'low');
    
    for cc=1:size(AllChans{m},2)
        
        LoadSpectrumML(AllChans{m}(cc),pwd,'low');
        
        LoadCohgramML(channel,AllChans{m}(cc),pwd,'low');
        
    end
end




