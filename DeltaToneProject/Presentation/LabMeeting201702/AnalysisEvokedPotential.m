% AnalysisEvokedPotential
% 15.02.2017 KJ
%
% analysis of the evoked potential in the PFCx
%   - here the data are collected
%
%
% see 
%    ToneEvokedPotential
%  



%% Dir
Dir1=PathForExperimentsDeltaWavesTone('RdmTone');
Dir2=PathForExperimentsDeltaWavesTone('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);

% Dir1 = PathForExperimentsDeltaKJHD('RdmTone');
% Dir2 = PathForExperimentsDeltaKJHD('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);

Dir = RestrictPathForExperiment(Dir,'nMice',[243 244 251 252]);

Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    elseif strcmpi(Dir.manipe{p},'RdmTone')
        Dir.condition{p} = ['Random (' num2str(Dir.delay{p}*1000) 'ms)'];
    end
end

%params
windowsize = 1000;


%% loop
for p=1:length(Dir.path)
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)

        clearvars -except Dir p windowsize evoked_res
        
        evoked_res.path{p}=Dir.path{p};
        evoked_res.manipe{p}=Dir.manipe{p};
        evoked_res.delay{p}=Dir.delay{p};
        evoked_res.name{p}=Dir.name{p};
        evoked_res.condition{p}=Dir.condition{p};

        %% load
        
        %PFCx deep
        load ChannelsToAnalyse/PFCx_deep
        eval(['load LFPData/LFP',num2str(channel)])
        PFCx_deep=LFP;
        clear LFP
        
        %PFCx sup
        load ChannelsToAnalyse/PFCx_sup
        eval(['load LFPData/LFP',num2str(channel)])
        PFCx_sup=LFP;
        clear LFP
        
        %PFCx 1
        load ChannelsToAnalyse/PFCx_1
        eval(['load LFPData/LFP',num2str(channel)])
        PFCx_1=LFP;
        clear LFP
        
        %PFCx 2
        load ChannelsToAnalyse/PFCx_2
        eval(['load LFPData/LFP',num2str(channel)])
        PFCx_2=LFP;
        clear LFP

        %Tones
        delay = Dir.delay{p}*1E4; %in 1E-4s
        load('DeltaSleepEvent.mat', 'TONEtime2_SWS')
        TonesEvent = (TONEtime2_SWS + delay)/1E4;
        evoked_res.nb_tones{p} = length(TONEtime2_SWS);
        
        %% load
        
        %PFCx deep
        Met = PlotRipRaw(PFCx_deep,TonesEvent, windowsize,0,0);
        evoked_res.deep.x{p} = Met(:,1);
        evoked_res.deep.y{p} = Met(:,2);
        
        %PFCx sup
        Met = PlotRipRaw(PFCx_sup,TonesEvent, windowsize,0,0);
        evoked_res.sup.x{p} = Met(:,1);
        evoked_res.sup.y{p} = Met(:,2);
        
        %PFCx 1
        Met = PlotRipRaw(PFCx_1,TonesEvent, windowsize,0,0);
        evoked_res.pfc1.x{p} = Met(:,1);
        evoked_res.pfc1.y{p} = Met(:,2);
        
        %PFCx 2
        Met = PlotRipRaw(PFCx_2,TonesEvent, windowsize,0,0);
        evoked_res.pfc2.x{p} = Met(:,1);
        evoked_res.pfc2.y{p} = Met(:,2);
        


end


%saving data
cd([FolderProjetDelta 'Data/']) 
save AnalysisEvokedPotential.mat evoked_res windowsize
        














