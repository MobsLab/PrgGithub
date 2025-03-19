% TestTimingToneLFP
% 31.01.2017 KJ
%
% for each night, look at the timing of tones and if it is coherent with
% ohter data
%
% see TestTimingToneLFP2 TestTimingTone2  



Dir1=PathForExperimentsDeltaWavesTone('RdmTone');
Dir2=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);


% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 =PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);

Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    elseif strcmpi(Dir.manipe{p},'RdmTone')
        Dir.condition{p} = ['Random (' num2str(Dir.delay{p}*1000) 'ms)'];
    end
end


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    tonetiming_res.path{p}=Dir.path{p};
    tonetiming_res.manipe{p}=Dir.manipe{p};
    tonetiming_res.delay{p}=Dir.delay{p};
    tonetiming_res.name{p}=Dir.name{p};
    tonetiming_res.condition{p}=Dir.condition{p};

    %LFP
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP

    %Tones
    delay = Dir.delay{p}*1E4; %in 1E-4s

    load('DeltaSleepEvent.mat', 'TONEtime1_SWS')
    load('DeltaSleepEvent.mat', 'TONEtime2_SWS')
    
    if exist('TONEtime2_SWS','var')
        real_time = 1;
    else
        real_time=0;
    end

    %Mean curves
    tonetiming_res.nb_detect{p} = length(TONEtime1_SWS);
    tonetiming_res.Md_detect{p} = PlotRipRaw(LFPdeep,TONEtime1_SWS/1E4, 1000, 0, 0);
    if real_time
        tonetiming_res.nb_tone{p} = length(TONEtime2_SWS);
        tonetiming_res.Md_tone{p} = PlotRipRaw(LFPdeep,TONEtime2_SWS/1E4, 1000, 0, 0);
    end

    tonetiming_res.real_time{p}=real_time;

end
    

%saving data
cd([FolderProjetDelta 'Data/']) 
save TestTimingToneLFP.mat tonetiming_res
        











