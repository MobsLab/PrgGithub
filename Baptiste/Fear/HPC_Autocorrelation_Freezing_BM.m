%% HPC auto-corrélation in Sophie's data

GetEmbReactMiceFolderList_BM

% Mean OB Spectrum
Mouse=[688 739 777 779 849 893 1096];

for mouse =1:length(Mouse)
    
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    
end

cd(CondSess.M688{1, 1}  )
load('B_Low_Spectrum.mat')
Session_type={'Fear','Cond','Ext'};
% Calculating data for each mouse
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        
        if sess==1
            Epoch_to_use=FearSess.(Mouse_names{mouse});
        elseif sess==2
            Epoch_to_use=CondSess.(Mouse_names{mouse});
        elseif sess==3
            Epoch_to_use=ExtSess.(Mouse_names{mouse});
        end
        try
        HPCSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(Epoch_to_use,'spectrum','prefix','H_Low');
        OBSpec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(Epoch_to_use,'spectrum','prefix','B_Low');
        
        Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Epoch_to_use,'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Epoch_to_use,'Epoch','epochname','zoneepoch');
        
        ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        
        HPCSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(HPCSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        HPCSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(HPCSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        HPCSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(HPCSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
             
        OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        OBSpec.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        OBSpec.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(OBSpec.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
     
        end
    end
    disp(Mouse_names{mouse})
end



HPC_Autocorrelation_Freezing_SumUp_BM(HPCSpec,OBSpec,Spectro,Mouse,Mouse_names,'SB')


figure; imagesc(Spectro{3} , Spectro{3} , corrcoef(log(Data(HPCSpec.Cond.Fz_Shock.(Mouse_names{mouse}))))); axis xy
makepretty
xlabel('Frequency (Hz)')










