cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

for sess = 1:length(Sess.(Mouse_names{1}))
    cd(Sess.(Mouse_names{1}){sess})
    disp(Sess.(Mouse_names{1}){sess})
    clear channel
    if not(exist('StateEpochSB.mat'))>0
        if (exist('ChannelsToAnalyse/Bulb_deep.mat'))
        load('ChannelsToAnalyse/Bulb_deep.mat')
        channel;
        FindNoiseEpoch_BM([cd filesep],channel,0);
        else
            load('ChannelsToAnalyse/dHPC_rip.mat')
             channel;
        FindNoiseEpoch([cd filesep],channel,0);
        end
    end
    close all
end
