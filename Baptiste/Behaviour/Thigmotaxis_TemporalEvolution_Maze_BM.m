
clear all
GetEmbReactMiceFolderList_BM
Session_type={'Cond'};
Group=11;

Trajectories_Function_Maze_BM

bin_size=1;
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        Sessions_List_ForLoop_BM
        
        ZoneEpoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
        SafeZoneEpoch.(Mouse_names{mouse})=or(ZoneEpoch.(Mouse_names{mouse}){2},ZoneEpoch.(Mouse_names{mouse}){5});
        Speed.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'speed');
        Moving.(Mouse_names{mouse}) = thresholdIntervals(Speed.(Mouse_names{mouse}) , 2 ,'Direction', 'Above');
        
        for bin=1:ceil(sum(DurationEpoch(TotEpoch.(Mouse_names{mouse}).(Session_type{sess})))/(bin_size*60e4))-1
            
            LittleEpoch = and(intervalSet(bin_size*60e4*(bin-1) , bin_size*60e4*bin) , and(UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) , ActiveEpoch.(Mouse_names{mouse}).(Session_type{sess})));
            %             LittleEpochDur = sum(DurationEpoch(LittleEpoch))/1e4;
            [Thigmo_score.(Mouse_names{mouse}).(Session_type{sess})(bin)] = Thigmo_From_Position_BM(Restrict(...
                Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , LittleEpoch));
            
            [Thigmo_score_safe.(Mouse_names{mouse}).(Session_type{sess})(bin)] = Thigmo_From_Position_BM(Restrict(...
                Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , and(LittleEpoch , SafeZoneEpoch.(Mouse_names{mouse}))));
            

        end
        
        Thigmo_score.(Mouse_names{mouse}).(Session_type{sess})(Thigmo_score.(Mouse_names{mouse}).(Session_type{sess})==0) = NaN;
        Thigmo_score_safe.(Mouse_names{mouse}).(Session_type{sess})(Thigmo_score_safe.(Mouse_names{mouse}).(Session_type{sess})==0) = NaN;
        Thigmo_score_safe_moving.(Mouse_names{mouse}).(Session_type{sess})(Thigmo_score_safe_moving.(Mouse_names{mouse}).(Session_type{sess})==0) = NaN;
        Thigmo_all.(Session_type{sess})(mouse,1:length(Thigmo_score.(Mouse_names{mouse}).(Session_type{sess}))) = Thigmo_score.(Mouse_names{mouse}).(Session_type{sess});
        Thigmo_all.(Session_type{sess})(Thigmo_all.(Session_type{sess})==0) = NaN;
    end
    disp(Mouse_names{mouse})
end



for mouse=1:length(Mouse)
    d = Thigmo_score_safe.(Mouse_names{mouse}).(Session_type{sess});
    Thigmo_safe(mouse,1:length(d)) = d;
    d = Thigmo_score_safe_moving.(Mouse_names{mouse}).(Session_type{sess});
    Thigmo_safe_moving(mouse,1:length(d)) = d;
end
Thigmo_safe(Thigmo_safe==0) = NaN;
Thigmo_safe([29],[61]) = NaN;
Thigmo_safe(51,66:68) = NaN;
Thigmo_safe_moving(Thigmo_safe_moving==0) = NaN;
Thigmo_safe_moving([29],[61]) = NaN;
Thigmo_safe_moving(51,66:68) = NaN;

figure
Data_to_use = Thigmo_safe(:,1:71);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:71] , movmean(Mean_All_Sp,2,'omitnan') , movmean(Conf_Inter,2,'omitnan') ,'-k',1); hold on;
xlabel('time (min)'), ylabel('Thigmotaxis, safe side (a.u.)')
xlim([0 71])

plot(nanmean(Thigmo_safe_moving))
hold on
plot(nanmean(Thigmo_safe))

















