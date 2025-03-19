DataLocationPFCMultipleDepths

for m=1:mm
    for ff=1:length(Filename{m})
        cd(Filename{m}{ff})
        for cc=1:size(ChanPairs{m},1)
            load(['LFPData/LFP',num2str(ChanPairs{m}(cc,1)),'.mat'])
            LFP1=LFP;
            load(['LFPData/LFP',num2str(ChanPairs{m}(cc,2)),'.mat'])
            LFP2=LFP;
            clear LFP
            % Calculation local LFP
            LFP=tsd(Range(LFP1),Data(LFP1)-Data(LFP2));
            save(['LFPData/',PairNames{m}{cc},'.mat'],'LFP')
            
            % Calculate local LFP spectrum high and low
            LowSpectrumSB([cd, filesep],PairNames{m}{cc},PairNames{m}{cc},0);
            LowSpectrumSB([cd, filesep],ChanPairs{m}(cc,1),[PairNames{m}{cc},'E1'],0);
            LowSpectrumSB([cd, filesep],ChanPairs{m}(cc,2),[PairNames{m}{cc},'E2'],0);
            
            HighSpectrum([cd, filesep],PairNames{m}{cc},PairNames{m}{cc});
            HighSpectrum([cd, filesep],ChanPairs{m}(cc,1),[PairNames{m}{cc},'E1']);
            HighSpectrum([cd, filesep],ChanPairs{m}(cc,2),[PairNames{m}{cc},'E2']);
            
            % Calculate local LFP coherence with OB
            load('ChannelsToAnalyse/Bulb_deep.mat')
            LowCohgramSB([cd, filesep],PairNames{m}{cc},PairNames{m}{cc},channel,'B', 0)
            LowCohgramSB([cd, filesep],ChanPairs{m}(cc,1),[PairNames{m}{cc},'E1'],channel,'B', 0)
            LowCohgramSB([cd, filesep],ChanPairs{m}(cc,2),[PairNames{m}{cc},'E2'],channel,'B', 0)
            clear channel
            % Calculate local LFP coherence with HPC
            if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                load('ChannelsToAnalyse/dHPC_rip.mat')
            else
                load('ChannelsToAnalyse/dHPC_deep.mat')
            end
            LowCohgramSB([cd, filesep],PairNames{m}{cc},PairNames{m}{cc},channel,'H', 0)
            LowCohgramSB([cd, filesep],ChanPairs{m}(cc,1),[PairNames{m}{cc},'E1'],channel,'H', 0)
            LowCohgramSB([cd, filesep],ChanPairs{m}(cc,2),[PairNames{m}{cc},'E2'],channel,'H', 0)
            clear channel
        end
    end
end




for m=1:mm
    for ff=1:length(Filename{m})
        cd(Filename{m}{ff})
        clear channel
        load('ChannelsToAnalyse/Bulb_deep.mat')
        LoadSpectrumML(channel,'pwd','low');
        
        for cc=1:size(AllChans{m},1)
            
            LoadSpectrumML(AllChans{m}(cc),'pwd','low');
            
            LoadCohgramML(channel,AllChans{m}(cc),'pwd','low');
            
            
        end
        
        
        
    end
    cd(SleepSession{m})
    
    LoadSpectrumML(channel,'pwd','low');
    
    for cc=1:size(AllChans{m},1)
        
        LoadSpectrumML(AllChans{m}(cc),'pwd','low');
        
        LoadCohgramML(channel,AllChans{m}(cc),'pwd','low');
        
    end
end

