
function HistData = Get_Data_Peak_Spectrum_BM(Mouse_numb)

GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM
Mouse=Mouse_numb; clear Mouse_names
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end

Session_type={'Fear','Cond','Ext','CondPre','CondPost'};
Restrain={'All','Free','Blocked'};
cd('/media/nas4/ProjetEmbReact/Mouse775/20180815/ProjectEmbReact_M775_20180815_TestPre_PreDrug/TestPre1/'); load('B_Low_Spectrum.mat')
Side={'All','Shock','Safe'};

for sess=1:length(Session_type) % generate all data required for analyses
    for res=1%:length(Restrain)
        
        if sess==1
            FolderList=FearSess;
        elseif sess==2
            FolderList=CondSess;
        elseif sess==3
            FolderList=ExtSess;        
        elseif sess==4
            FolderList=CondPreSess;        
        elseif sess==5
            FolderList=CondPostSess;
        end
        
        for mouse = 1:length(Mouse_names)
            try
                OBSpec_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
                Freeze_Epoch_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
                ZoneEpoch_Prelim=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
                BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','blockedepoch');
                TotEpoch.(Session_type{sess}).(Mouse_names{mouse})=intervalSet(0,max(Range(OBSpec_Prelim)));
                Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})=TotEpoch.(Session_type{sess}).(Mouse_names{mouse})-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
                if res==1
                    OBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=OBSpec_Prelim;
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=Freeze_Epoch_Prelim;
                    ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse})=ZoneEpoch_Prelim;
                elseif res==2
                    OBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict( OBSpec_Prelim , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = and(Freeze_Epoch_Prelim , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                    for zones=1:5; ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){zones} = and(ZoneEpoch_Prelim{zones} , Non_BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})); end
                elseif res==3
                    OBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = Restrict( OBSpec_Prelim , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
                    FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = and(Freeze_Epoch_Prelim , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
                    for zones=1:5; ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){zones} = and(ZoneEpoch_Prelim{zones} , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse})); end
                end
                ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){1};
                SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}){5});
                
                OB_Freeze.(Session_type{sess}).(Restrain{res}).All.(Mouse_names{mouse}) = Restrict(OBSpecConcat.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}),FreezeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                OB_Freeze.(Session_type{sess}).(Restrain{res}).Shock.(Mouse_names{mouse}) = Restrict(OB_Freeze.(Session_type{sess}).(Restrain{res}).All.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
                OB_Freeze.(Session_type{sess}).(Restrain{res}).Safe.(Mouse_names{mouse}) = Restrict(OB_Freeze.(Session_type{sess}).(Restrain{res}).All.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Restrain{res}).(Mouse_names{mouse}));
            
            Mouse_names{mouse};
            end
        end
    end
end



for sess=1:length(Session_type) % generate all data required for analyses
    for res=1%:length(Restrain)
        
        if sess==1
            FolderList=FearSess;
        elseif sess==2
            FolderList=CondSess;
        elseif sess==3
            FolderList=ExtSess;
        elseif sess==4
            FolderList=CondPreSess;
        elseif sess==5
            FolderList=CondPostSess;
        end
        
        for mouse = 1:length(Mouse_names)
            
            for side=1:length(Side)
                Spectro_to_use=OB_Freeze.(Session_type{sess}).(Restrain{res}).(Side{side}).(Mouse_names{mouse});
                try
                    Spectrum_Frequency=ConvertSpectrum_in_Frequencies_BM(Spectro{3} , Range(Spectro_to_use) , Data(Spectro_to_use));
                    DataSpectrum_Frequency = Data(Spectrum_Frequency);
                    DataSpectrum_Frequency(or(DataSpectrum_Frequency<1,DataSpectrum_Frequency>8))=NaN;
                    h=histogram(DataSpectrum_Frequency,'BinLimits',[1 8],'NumBins',91); % 91=sum(and(1<Spectro{3},Spectro{3}<8))
                    HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
                end
            end
        end
    end
end
close