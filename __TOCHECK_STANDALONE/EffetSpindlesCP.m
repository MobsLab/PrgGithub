%EffetSpindlesCP

load('LFPData/InfoLFP.mat')

disp(' ')


try 
         channel;
    
catch
    
    disp('Choix automatique')
        if 0
                goodPfc=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
                goodDepth=InfoLFP.depth(strcmp(InfoLFP.structure,'PFCx'));

                try
                channel=goodPfc(find(goodDepth==-1));
                channel(1);
                catch
                    try
                        channel=goodPfc(find(goodDepth==0));
                        channel(1);
                    catch
                        channel=goodPfc(1);
                        disp('channel for Pfc not optimal ')
                    end
                end

        else

                load('ChannelsToAnalyse/PFCx_deep.mat')

        end

end

disp(['Channel for Pfc: ',num2str(channel)])
disp(' ')

eval(['load(''LFPData/LFP',num2str(channel),'.mat'')'])
eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])


%--------------------------------------------------------------------------

%--------------------------------------------------------------------------

load behavResources
st2=Start(CPEpoch,'s');
st1=Start(VEHEpoch,'s');

load StateEpoch SWSEpoch NoiseEpoch GndNoiseEpoch REMEpoch MovEpoch
% 


limLFP=8000;
AmplitudeNoiseEpoch1=thresholdIntervals(LFP,limLFP,'Direction','Above');
AmplitudeNoiseEpoch2=thresholdIntervals(LFP,-limLFP,'Direction','Below');
AmplitudeNoiseEpoch=or(AmplitudeNoiseEpoch1,AmplitudeNoiseEpoch2);
AmplitudeNoiseEpoch=intervalSet(Start(AmplitudeNoiseEpoch)-1*1E4,End(AmplitudeNoiseEpoch)+1*1E4);
AmplitudeNoiseEpoch=mergeCloseIntervals(AmplitudeNoiseEpoch,0.5);


SWSEpoch=SWSEpoch-GndNoiseEpoch;
SWSEpoch=SWSEpoch-NoiseEpoch;
try
SWSEpoch=SWSEpoch-AmplitudeNoiseEpoch;
end
try
SWSEpoch=SWSEpoch-WeirdNoiseEpoch;
end

REMEpoch=REMEpoch-GndNoiseEpoch;
REMEpoch=REMEpoch-NoiseEpoch;
try
REMEpoch=REMEpoch-AmplitudeNoiseEpoch;
end
try
REMEpoch=REMEpoch-WeirdNoiseEpoch;
end


Spi=FindSpindlesKarim(LFP,[4 16],SWSEpoch);
st1=Start(VEHEpoch,'s');
st2=Start(CPEpoch,'s');

eval(['save SpiMarie',num2str(channel),' Spi st1 st2 channel InfoLFP'])


