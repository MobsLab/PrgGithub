clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
num=1;
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        disp(Dir.path{d}{dd})
        
        load('BreathingInfo_ZeroCross.mat')
        dat{num} = Data(Frequecytsd);
        dat{num}(dat{num}>20) = [];
        Drug{num} = Dir.ExpeInfo{d}{dd}.DrugInjected;
        num = num+1;
    end
end

%%

clear all
[params,movingwin,suffix]=SpectrumParametersML('low');
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');

for d = 3:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        disp(Dir.path{d}{dd})
        
        clear chH chB chP chR
        
        % Check all spectra
        % Prefrontal cortex
        clear channel
        load('ChannelsToAnalyse/PFCx_deep.mat')
        chP=channel;
        if exist('P_LowSpectrum.mat')>0
            movefile('P_Low_Spectrum.mat','PFCx_Low_Spectrum.mat')
        end
        %         if exist('PFCx_Low_Spectrum.mat')==0
        disp('Calculating PFCx Spectrum')
        LowSpectrumSB([Dir.path{d}{dd} filesep],channel,'PFCx')
        %         end
        
        % OB
        clear channel
        load('ChannelsToAnalyse/Bulb_deep.mat')
        chB=channel;
        %         if exist('B_Low_Spectrum.mat')==0
        disp('Calculating OB Spectrum')
        LowSpectrumSB([Dir.path{d}{dd} filesep],channel,'B')
        %         end
        
        if  exist('LFPData/LocalOBActivity.mat')>0 % & exist('BLoc_Low_Spectrum.mat')==0
            disp('Calculating local OB Spectrum')
            load('LFPData/LocalOBActivity.mat')
            Spectro=LowSpectrumSBNoSaveCode(LFP,0);
            ch=OBChannels;
            save(strcat('BLoc_Low_Spectrum.mat'),'Spectro','ch','-v7.3')
        end
        
        % HPC
        clear channel
        try,load('ChannelsToAnalyse/dHPC_rip.mat')
            if isempty(channel)
                load('ChannelsToAnalyse/dHPC_deep.mat')
            end
        catch,try,
                load('ChannelsToAnalyse/dHPC_deep.mat')
            catch
                load('ChannelsToAnalyse/dHPC_sup.mat')
            end
        end
        chH=channel;
        %         if exist('H_Low_Spectrum.mat')==0
        disp('Calculating HPC Spectrum')
        LowSpectrumSB([Dir.path{d}{dd} filesep],channel,'H')
        %         end
        if exist('LFPData/LocalHPCActivity.mat')>0 % & exist('HLoc_Low_Spectrum.mat')==0
            disp('Calculating local HPC Spectrum')
            load('LFPData/LocalHPCActivity.mat')
            Spectro=LowSpectrumSBNoSaveCode(LFP,0);
            ch=HPCChannels;
            save(strcat('HLoc_Low_Spectrum.mat'),'Spectro','ch','-v7.3')
        end
        
        % Respiration
        clear channel
        load('ChannelsToAnalyse/Respi.mat')
        chR=channel;
        %         if exist('Respi_LowSpectrum.mat')==0
        disp('Calculating Respi Spectrum')
        LowSpectrumSB([Dir.path{d}{dd} filesep],channel,'Respi')
        %         end
        
        % Make sure noise Epochs exist
        load('SleepScoring_Accelero.mat','TotalNoiseEpoch')
        
        
        % Check all coherence
        mkdir('CohgramcDataL')
        AllCombi=combnk([chH,chB,chP,chR],2);
        for t=1:size(AllCombi,1)
            NameTemp1=['CohgramcDataL/Cohgram_',num2str(AllCombi(t,1)),'_',num2str(AllCombi(t,2)),'.mat'];
            NameTemp2=['CohgramcDataL/Cohgram_',num2str(AllCombi(t,2)),'_',num2str(AllCombi(t,1)),'.mat'];
            if not(exist(NameTemp1)>0 | exist(NameTemp2)>0)
                load(['LFPData/LFP',num2str(AllCombi(t,1)),'.mat']);LFP1=LFP;
                load(['LFPData/LFP',num2str(AllCombi(t,2)),'.mat']);LFP2=LFP;
                disp('calculating coherence')
                [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFP1),Data(LFP2),movingwin,params);
                save(NameTemp1,'C','phi','S12','confC','t','f')
                clear LFP1 LFP LFP C phi S12 S1 S2 t f confC phist
            end
        end
    end
    
end