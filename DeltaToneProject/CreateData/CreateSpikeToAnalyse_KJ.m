% CreateSpikeToAnalyse_KJ
% 07.11.2017 KJ
%
% create spike to analyse
%
% Info
%   see MakeWaveformDataKJ, IdentifyWaveforms
%


try
    mkdir('SpikesToAnalyse')
    %% Find structures
    load(fullfile(pwd,'LFPData','InfoLFP.mat'));

    %LFP structures
    lfp_structures = unique(InfoLFP.structure);
    lfp_structures(strcmpi(lfp_structures,'accelero'))=[];
    lfp_structures(strcmpi(lfp_structures,'ekg'))=[];
    lfp_structures(strcmpi(lfp_structures,'nan'))=[];
    lfp_structures(strcmpi(lfp_structures,'ref'))=[];
    lfp_structures(strcmpi(lfp_structures,'noise'))=[];
    
    
    for i=1:length(lfp_structures)
        structure = lfp_structures{i};
        [NumNeurons, NumMua] = CreateSpikeToAnalyse(structure);
        
        % save
        if ~isempty(NumNeurons) || ~isempty(NumMua)
            number = NumNeurons;
            save(['SpikesToAnalyse/' structure '_Neurons'],'number')
            number = NumMua;
            save(['SpikesToAnalyse/' structure '_MUA'],'number')   
        end
    end
    
    
    %% Right PFCx
    if exist('ChannelsToAnalyse/PFCx_deep_right','file')==2
        [neurons_right, mua_right] = CreateSpikeToAnalyse('PFCx','right');
        %save
        number = neurons_right;
        save SpikesToAnalyse/PFCx_r_Neurons number
        number = mua_right;
        save SpikesToAnalyse/PFCx_r_MUA number
    end
    
    %% Left PFCx
    if exist('ChannelsToAnalyse/PFCx_deep_left','file')==2
        [neurons_left, mua_left] = CreateSpikeToAnalyse('PFCx','left');
        %save
        number = neurons_left;
        save SpikesToAnalyse/PFCx_l_Neurons number
        number = mua_left;
        save SpikesToAnalyse/PFCx_l_MUA number
    end


catch
    disp('problem for this record') 
end

