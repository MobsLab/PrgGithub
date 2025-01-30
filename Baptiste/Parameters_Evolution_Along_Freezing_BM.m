


GetEmbReactMiceFolderList_BM

clearvars -except FearSess CondPreSess CondPostSess ExtSess
Mouse = [688,739,777,849,1170,1189,1251,1253,1254,1391,1392,1393,1394];

Session_type={'Fear','CondPre','CondPost','Ext'};
Side={'All','Shock','Safe'};

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Sessions_List_ForLoop_BM
        
        Rip.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'ripples_all');
        Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'respi_freq_bm');
        FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname', 'freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}) , 'epoch' , 'epochname', 'zoneepoch');
        FzShock_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1});
        FzSafe_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5} , ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2}));
        
        for side = 1:3
            if side==1
                Epoch_to_use = FreezeEpoch;
            elseif side==2
                Epoch_to_use = FzShock_Epoch;
            elseif side==3
                Epoch_to_use = FzSafe_Epoch;
            end
            
            Rip_Fz.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Rip.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use.(Session_type{sess}).(Mouse_names{mouse}));
            Respi_Fz.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , Epoch_to_use.(Session_type{sess}).(Mouse_names{mouse}));
            
            clear D; D = Data(Rip_Fz.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}));
            RipFrequency_Fz.(Side{side}).(Session_type{sess})(mouse) = nanmean(D(:,5));
            
            RespiFrequency_Fz.(Side{side}).(Session_type{sess})(mouse) = nanmean(Data(Respi_Fz.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})));
        end
    end
end


Cols = {[1 .5 .5],[.5 .5 1]};
X = [1,2];
Legends ={'Shock' 'Safe'};
NoLegends ={'' ''};


figure
for sess=1:3
    subplot(1,3,sess)
    MakeSpreadAndBoxPlot2_SB({RespiFrequency_Fz.Shock.(Session_type{sess}) RespiFrequency_Fz.Safe.(Session_type{sess})},Cols,X,Legends,'showpoints',0);
    ylim([3 8])
end

figure
for sess=1:3
    subplot(1,3,sess)
    MakeSpreadAndBoxPlot2_SB({RipFrequency_Fz.Shock.(Session_type{sess}) RipFrequency_Fz.Safe.(Session_type{sess})},Cols,X,Legends,'showpoints',0);
    ylim([170 205])
end


Cols = {[.5 1 .5],[.2 .4 .9]};
X = [1,2];
Legends ={'ConPre' 'Ext'};
NoLegends ={'' ''};

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({RipFrequency_Fz.Shock.CondPre RipFrequency_Fz.Shock.Ext},Cols,X,Legends,'showpoints',0);
ylim([170 210])

subplot(122)
MakeSpreadAndBoxPlot2_SB({RipFrequency_Fz.Safe.CondPre RipFrequency_Fz.Safe.Ext},Cols,X,Legends,'showpoints',0);
ylim([170 210])


for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side = 1:3
            try
                
                clear D; D = Data(Rip_Fz.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}));
                Rip_Frequency_Evolution.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = interp1(linspace(0,1,size(D,1)) , runmean(D(:,5),round(size(D,1)/25)) , linspace(0,1,100));
                Rip_Frequency_Evolution_All.(Side{side}).(Session_type{sess})(mouse,:) = Rip_Frequency_Evolution.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                Rip_Frequency_Evolution_All.(Side{side}).(Session_type{sess})(Rip_Frequency_Evolution_All.(Side{side}).(Session_type{sess})==0) = NaN;
                
            end
        end
    end
end

figure
plot(nanmean(Rip_Frequency_Evolution_All.(Side{1}).(Session_type{sess})),'k')
hold on
plot(nanmean(Rip_Frequency_Evolution_All.(Side{2}).(Session_type{sess})),'r')
plot(nanmean(Rip_Frequency_Evolution_All.(Side{3}).(Session_type{sess})),'b')
makepretty

figure
plot(nanmean(Rip_Frequency_Evolution_All.(Side{1}).(Session_type{sess})-nanmean(Rip_Frequency_Evolution_All.(Side{1}).(Session_type{sess}),2)),'k')
hold on
plot(nanmean(Rip_Frequency_Evolution_All.(Side{2}).(Session_type{sess})-nanmean(Rip_Frequency_Evolution_All.(Side{2}).(Session_type{sess}),2)),'r')
plot(nanmean(Rip_Frequency_Evolution_All.(Side{3}).(Session_type{sess})-nanmean(Rip_Frequency_Evolution_All.(Side{3}).(Session_type{sess}),2)),'b')
makepretty







