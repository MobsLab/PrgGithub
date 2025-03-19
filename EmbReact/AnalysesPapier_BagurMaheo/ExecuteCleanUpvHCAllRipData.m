clear all
load('/media/nas8-2/ProjetEmbReact/transfer/AllSessions_BM.mat')
Group=[7 8];
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Path{group}{mouse} = CondSess.(Mouse_names{mouse});
    end
end

for group = 1:2
    for mouse = 1:length(Path{group})
        for folder = 1:length(Path{group}{mouse})
            disp(Path{group}{mouse}{folder})
            cd(Path{group}{mouse}{folder})
            % Clean Up OB
            load('ChannelsToAnalyse/Bulb_deep.mat')
            CleanVHCStimLFPS(Path{group}{mouse}{folder},channel)
            % Recalculate spectrum
             LowSpectrumSB(Path{group}{mouse}{folder},['LFP',num2str(channel),'_VHCClean'],'B_vHC_Clean');
        end
    end
end
