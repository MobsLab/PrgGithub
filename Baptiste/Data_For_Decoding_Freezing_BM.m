

%% Generate all physio-brain params that indicate shock/safe
clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Group=22;
bin_size=2;

Mouse=Drugs_Groups_UMaze_BM(Group);
Session_type={'Cond'};
for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta','linearposition');
end

clearvars -except OutPutData Epoch1 NameEpoch CondSess FearSess Session_type Group bin_size

Mouse=Drugs_Groups_UMaze_BM(Group);
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta','linearposition'};

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        i=1;
        clear ep ind_to_use
        
        for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse, 3}))
            
            % for full 1s bin
            for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/(bin_size*1e4)))-1 % bin of 2s or less
                
                % define bin
                SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(bin-1)*bin_size*1e4 , Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(bin)*bin_size*1e4);
                
                % param in this bin
                for par=1:length(Params)
                    DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                end
                DATA.(Session_type{sess}).(Mouse_names{mouse})(par+1,i) = nanmedian(Range(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                
                i=i+1;
            end
            
            %             % for what's left in the episode, <1s of freezing epoch
            %             ind_to_use = ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/(bin_size*1e4)))-1; % se(Session_type{sess}) to last freezing episode indice
            %             SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(ind_to_use)*bin_size*1e4 , Stop(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))); % last small epoch is a bin with time < 2s
            %             for par=1:length(Params)
            %                 DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
            %             end
            %
            %             i=i+1;
        end
        
        disp(Mouse_names{mouse})
    end
end

clearvars -except bin_size DATA Epoch1 Group Mouse Mouse_names OutPutData Params Session_type sess

Saline=1;
SameAmount=0;
State=0;
General=1;

[mu , sigma , eigen_vector , Distance , Line] = Figures_PCA_Freezing_UMaze_BM(Mouse , DATA.(Session_type{1}) , Params , Saline , SameAmount , State , General);

a=suptitle('Ext, general, different amount'); a.FontSize=20;





[mu , sigma , eigen_vector , Distance , Line] = Figures_PCA_Freezing_UMaze_BM(Mouse , DATA.CondPost , Params([1:5 7:9]) , Saline , SameAmount , State , General);
[mu , sigma , eigen_vector , Distance , Line] = Figures_PCA_Freezing_UMaze_BM(Mouse , DATA.CondPost , Params , Saline , SameAmount , State , General , Line);

[mu , sigma , eigen_vector] = Figures_PCA_Freezing_UMaze_BM(Mouse , DATA2.Ext , Params([1:5 7:9]) , Saline , SameAmount , State , General);
[mu , sigma , eigen_vector , Distance] = Figures_PCA_Freezing_UMaze_BM(Mouse , DATA.CondPost , Params([1:5 7:9]) , Saline , SameAmount , State , General , Line);


Saline=0;
SameAmount=0;
State=0;
General=1;

Figures_PCA_Freezing_UMaze_BM(Mouse , DATA.Ext , Params , Saline , SameAmount , State , General);



clearvars -except DATA Epoch1 Mouse Mouse_names OutPutData Params Session_type mu sigma eigen_vector


save('/media/nas7/ProjetEmbReact/DataEmbReact/Data_For_Decoding/final/Data_Physio_Freezing_Saline_CondPost_2sFullBin.mat',...
    'mu','sigma','eigen_vector','-append')

save('/media/nas7/ProjetEmbReact/DataEmbReact/Data_For_Decoding/final/Data_Physio_Freezing_Saline_Ext_2sFullBin.mat')


%% Generate all physio-brain params sleep
clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Group=11;
bin_size=3;

Mouse=Drugs_Groups_UMaze_BM(Group);
Session_type={'sleep_pre'};
for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
        'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','pfc_delta_power');
    
    %     [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
    %         'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
end

clearvars -except OutPutData Epoch1 NameEpoch Sess Session_type Group bin_size

Mouse=Drugs_Groups_UMaze_BM(Group);
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try % are you sure ?
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
        if length(UMazeSleepSess.(Mouse_names{mouse}))==3
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
        else
            try
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            catch % for 11203... grrr
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            end
        end
    end
end


Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','pfc_delta_power','states'};
sta = [2 4 5];

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        try
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            i=1;
            clear ep ind_to_use
            
            for states=1:3
                for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse, sta(states)}))
                    
                    % for full 1s bin
                    for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep)))/(bin_size*1e4)))-1 % bin of 2s or less
                        
                        % define bin
                        SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep))+(bin-1)*bin_size*1e4 , Start(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep))+(bin)*bin_size*1e4);
                        
                        % param in this bin
                        for par=1:length(Params)-1
                            DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                        end
                        par=length(Params);
                        DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = states;
                        
                        
                        i=i+1;
                    end
                    
                    
                    % for what's left in the episode, <1s of freezing epoch
                    ind_to_use = ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep)))/(bin_size*1e4)))-1; % se(Session_type{sess}) to last freezing episode indice
                    SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep))+(ind_to_use)*bin_size*1e4 , Stop(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep))); % last small epoch is a bin with time < 2s
                    for par=1:length(Params)-1
                        DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                    end
                    par=length(Params);
                    DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = states;
                    
                    i=i+1;
                end
            end
            
            disp(Mouse_names{mouse})
        end
    end
end

clearvars -except DATA Epoch1 Mouse Mouse_names OutPutData Params Session_type bin_size

save('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Sleep.mat')


% remove mice not enough sleep
for mouse=1:length(Mouse)
    try
        if size(DATA.sleep_pre.(Mouse_names{mouse}),2)<100
            DATA.sleep_pre = rmfield(DATA.sleep_pre , Mouse_names{mouse});
        end
    end
end

% remove mice without sleep session
i=1;
for mouse=1:length(Mouse)
    if isfield(DATA.sleep_pre,Mouse_names{mouse})
        Mouse2(i)=Mouse(mouse);
        Mouse_names2{i}=Mouse_names{mouse};
        i=i+1;
    end
end
clear Mouse Mouse_names
Mouse=Mouse2;
Mouse_names=Mouse_names2;
clear Mouse2 Mouse_names2




[eig1 , eig2 , X , Y] = Figures_PCA_Freezing_UMaze_BM(Mouse , DATA.sleep_pre , Params , 1)




%% Generate all physio-brain params active
clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Group=11;
sta = [3 4];
bin_size=2;

Mouse=Drugs_Groups_UMaze_BM(Group);
Session_type={'CondPost'};
for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
    
%     [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
%         'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
end

clearvars -except OutPutData Epoch1 NameEpoch CondSess FearSess Session_type Group sta bin_size

Mouse=Drugs_Groups_UMaze_BM(Group);
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition','states'};
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        i=1;
        clear ep ind_to_use
        
        for states=1:2 % freezing and active 
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse, sta(states)}))
                
                % for full 1s bin
                for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep)))/(bin_size*1e4)))-1 % bin of 2s or less
                    
                    % define bin
                    SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep))+(bin-1)*bin_size*1e4 , Start(subset(Epoch1.(Session_type{sess}){mouse, sta(states)},ep))+(bin)*bin_size*1e4);
                    
                    % param in this bin
                    for par=1:length(Params)-1
                        DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                    end
                    par=length(Params);
                    DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = states;
                    
                    i=i+1;
                end
             end
        end
        disp(Mouse_names{mouse})
    end
end

clearvars -except bin_size DATA Epoch1 Group Mouse Mouse_names OutPutData Params Session_type sta


Figures_PCA_Freezing_UMaze_BM(Mouse , DATA.CondPost , Params , 1);











%%%%%%%%%%%%%%% SB %%%%%%%%%%%%%%%


%% Generate all physio-brain params that indicate shock/safe for drug mice
clear all
GroupNames = {'Saline_all','FlxChr_Ctrl','FlxChr','RipInhib_Ctrl','RipInhib'};
GroupId = [11,1,2,7,8,10];
bin_size=2;
Session_type={'Fear','Cond','CondPost','Ext','Fear','sleep_pre','TestPre','CondPre'};
for sess = 4:length(Session_type)
    for gg = 1:length(GroupNames)
        
%         GetAllSalineSessions_BM
%         GetEmbReactMiceFolderList_BM
        Group = GroupId(gg); % chronic fluo mice
        
        Mouse=Drugs_Groups_UMaze_BM(Group);
        
        if gg==1
            [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),...
                'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition','ob_low');
        else
            [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
                'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition','ob_low');
        end
        
        
        Mouse=Drugs_Groups_UMaze_BM(Group);
        Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition'};
        
        for mouse=1:length(Mouse)
            try
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                i=1;
                clear ep ind_to_use
                
                for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse, 3}))
                    
                    % for full 1s bin
                    for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/(bin_size*1e4)))-1 % bin of 2s or less
                        
                        % define bin
                        SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(bin-1)*bin_size*1e4 , Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(bin)*bin_size*1e4);
                        
                        % param in this bin
                        for par=1:length(Params)
                            DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                        end
                        
                        i=i+1;
                    end
                end
                
                disp(Mouse_names{mouse})
            end
        end
        
        save(['/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_',GroupNames{gg},'_',Session_type{sess},'_2sFullBins.mat'],...
            'DATA','Epoch1','Group','Mouse','Mouse_names','OutPutData','Params','Session_type','bin_size')
        clear DATA Mouse_names
    end
end

%% Generate all physio-brain params that indicate shock/safe for drug mice
clear all
GroupNames = {'Saline'};
GroupId = [11];
bin_size=2;

for gg = 1:length(GroupNames)
    
    GetAllSalineSessions_BM
    GetEmbReactMiceFolderList_BM
    Group = GroupId(gg); % chronic fluo mice
    
    
    Mouse=Drugs_Groups_UMaze_BM(Group);
    Session_type={'ext'};
    for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
        
        %     [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
        %         'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition');
    end
    
    
    Mouse=Drugs_Groups_UMaze_BM(Group);
    Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power','linearposition'};
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            %         try
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            i=1;
            clear ep ind_to_use
            
            for ep=1:length(Start(Epoch1.(Session_type{sess}){mouse, 3}))
                
                % for full 1s bin
                for bin=1:ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/(bin_size*1e4)))-1 % bin of 2s or less
                    
                    % define bin
                    SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(bin-1)*bin_size*1e4 , Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(bin)*bin_size*1e4);
                    
                    % param in this bin
                    for par=1:length(Params)
                        DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                    end
                    
                    i=i+1;
                end
                
                
                % for what's left in the episode, <1s of freezing epoch
                ind_to_use = ceil(((DurationEpoch(subset(Epoch1.(Session_type{sess}){mouse, 3},ep)))/(bin_size*1e4)))-1; % se(Session_type{sess}) to last freezing episode indice
                SmallEpoch = intervalSet(Start(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))+(ind_to_use)*bin_size*1e4 , Stop(subset(Epoch1.(Session_type{sess}){mouse, 3},ep))); % last small epoch is a bin with time < 2s
                for par=1:length(Params)
                    DATA.(Session_type{sess}).(Mouse_names{mouse})(par,i) = nanmedian(Data(Restrict(OutPutData.(Session_type{sess}).(Params{par}).tsd{mouse,1} , SmallEpoch)));
                end
                
                i=i+1;
            end
            
            disp(Mouse_names{mouse})
            %         end
        end
    end
    
    save(['/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_',GroupNames{gg},'_ext_2sbins.mat'],...
        'DATA','Epoch1','Group','Mouse','Mouse_names','OutPutData','Params','Session_type','bin_size')
    clear DATA Mouse_names
end

