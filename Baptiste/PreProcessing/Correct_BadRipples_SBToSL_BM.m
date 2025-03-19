

GetEmbReactMiceFolderList_BM


for mouse=62:length(Mouse)
    for sess=1:length(Sess.(Mouse_names{mouse}))
        
        cd(Sess.(Mouse_names{mouse}){sess})
        
        if exist('Ripples.mat')==2
            if sess==1
                disp(cd)
                channel = input('non rip channel ? ');
                for sess2=1:length(Sess.(Mouse_names{mouse}))
                    
                    cd(Sess.(Mouse_names{mouse}){sess2})
                    save('ChannelsToAnalyse/nonRip.mat','channel')
                end
                cd(Sess.(Mouse_names{mouse}){sess})
            end
            
            CreateRipplesSleep_BM('recompute',1,'restrict',1)
            
            Mouse(mouse)
            Sess.(Mouse_names{mouse}){sess}
        end
    end
end



