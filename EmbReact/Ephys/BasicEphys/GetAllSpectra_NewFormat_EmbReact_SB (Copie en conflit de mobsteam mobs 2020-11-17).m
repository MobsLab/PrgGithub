for ss=28:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            %if (Dir.ExpeInfo{d}{dd}.nmouse==796)
            try
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})
                
                load('LFPData/InfoLFP.mat')
                InfoLFP.structure(find(~cellfun(@isempty,strfind(InfoLFP.structure,'HPC')))) = {'dHPC'};
                save('LFPData/InfoLFP.mat','InfoLFP')


                
                channels_PFCx = GetDifferentLocationStructure('PFCx');
                channels_HPC = GetDifferentLocationStructure('dHPC');
                load('ChannelsToAnalyse/Bulb_deep.mat')
                channels_Bulb = channel;
                
                AllChans = [channels_PFCx(:);channels_HPC(:);channels_Bulb(:)];
                for ch = 1:length(AllChans)
                    disp(['Spectro ' num2str(AllChans(ch))])
                    LoadSpectrumML(AllChans(ch),[cd filesep],'low');
                end
                
                for ch = 1:length(channels_PFCx)
                    disp(['Spectro ' num2str(channels_PFCx(ch))])
                    LoadCohgramML(channels_PFCx(ch),channels_Bulb,[cd filesep],'low');
                end
                
            catch
                disp(['Problem' Dir.path{d}{dd}])
            end
        end
    end
    
end