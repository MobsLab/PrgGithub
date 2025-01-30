function Episodes = Temperature_ShockEpisodes2(Mouse_name,FolderList,ChosenEpoch)

Mouse_name={['M' num2str(Mouse_name)]};

switch ChosenEpoch
    case 'All'
        FreezeEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','stimepoch');
        StartShockEpoch=Start(FreezeEpoch);
    case 'First'
        %StartShockEpoch=Start(ZonesTemperatu.Tail_Room.(Mouse_name{1}).StimEpoch);
        %StartShockEpoch=StartShockEpoch(1);
    otherwise
        disp('ERROR')
end


OnsetShock=StartShockEpoch/1e4;

AccConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'accelero');
% Accelero
[M_Acc,T_Acc] = PlotRipRaw(AccConcat,OnsetShock,5*1e3);
close
T_Acc(T_Acc==0)=NaN;
if length(OnsetShock)==1
    T_Acc_Interp(sess,:)=interp1(linspace(0,1,size(T_Acc,1)),T_Acc(:,sess),linspace(0,1,100));
else
    for sess=1:size(T_Acc,1)
        T_Acc_Interp(sess,:)=interp1(linspace(0,1,size(T_Acc,2)),T_Acc(sess,:),linspace(0,1,100));
    end
end
Episodes.Acc_Interp=T_Acc_Interp(:,1:100);


SpeedConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'speed');
% Speed
[M_Speed,T_Speed] = PlotRipRaw(SpeedConcat,OnsetShock,5*1e3);
close
T_Speed(T_Speed==0)=NaN;
if length(OnsetShock)==1
    T_Speed_Interp(sess,:)=interp1(linspace(0,1,size(T_Speed,1)),T_Speed(:,sess),linspace(0,1,100));
else
    for sess=1:size(T_Speed,1)
        T_Speed_Interp(sess,:)=interp1(linspace(0,1,size(T_Speed,2)),T_Speed(sess,:),linspace(0,1,100));
    end
end
Episodes.Speed_Interp=T_Speed_Interp(:,1:100);

% Respi
RespiConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'instfreq','suffix_instfreq','B');
[M_Respi,T_Respi] = PlotRipRaw(RespiConcat,OnsetShock,5*1e3);
close
T_Respi(T_Respi==0)=NaN;
if length(OnsetShock)==1
    T_Respi_Interp(sess,:)=interp1(linspace(0,1,size(T_Respi,1)),T_Respi(:,sess),linspace(0,1,100));
else
    for sess=1:size(T_Respi,1)
        T_Respi_Interp(sess,:)=interp1(linspace(0,1,size(T_Respi,2)),T_Respi(sess,:),linspace(0,1,100));
    end
end
Episodes.Respi_Interp=T_Respi_Interp(:,1:100);


% Heart Rate
HRConcat=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'heartrate');
if length(HRConcat)==0
    Episodes.HR_Interp=nan(size(Episodes.Respi_Interp,2),100);
else
    [M_HR,T_HR] = PlotRipRaw(HRConcat,OnsetShock,5*1e3);
    close
    T_HR(T_HR==0)=NaN;
    if length(OnsetShock)==1
        T_HR_Interp(sess,:)=interp1(linspace(0,1,size(T_HR,1)),T_HR(:,sess),linspace(0,1,100));
    else
        for sess=1:size(T_HR,1)
            T_HR_Interp(sess,:)=interp1(linspace(0,1,size(T_HR,2)),T_HR(sess,:),linspace(0,1,100));
        end
    end
    Episodes.HR_Interp=T_HR_Interp(:,1:100);
end

% Tail Temperature
TailFear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'tailtemperature');
RoomFear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'roomtemperature');
TTempConcat=tsd([Range(TailFear)],[Data(TailFear)-0.804.*Data(RoomFear)]);
[M_TTemp,T_TTemp] = PlotRipRaw(TTempConcat,OnsetShock,5*1e3);
close
T_TTemp(T_TTemp==0)=NaN;
if length(OnsetShock)==1
    T_TTemp_Interp(sess,:)=interp1(linspace(0,1,size(T_TTemp,1)),T_TTemp(:,sess),linspace(0,1,100));
else
    for sess=1:size(T_TTemp,1)
        T_TTemp_Interp(sess,:)=interp1(linspace(0,1,size(T_TTemp,2)),T_TTemp(sess,:),linspace(0,1,100));
    end
end
Episodes.TTemp_Interp=T_TTemp_Interp(:,1:100);


% Mask Temperature
MaskFear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'masktemperature');
RoomFear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'roomtemperature');
MTempConcat=tsd([Range(MaskFear)],[Data(MaskFear)-0.381.*Data(RoomFear)]);
[M_MTemp,T_MTemp] = PlotRipRaw(MTempConcat,OnsetShock,5*1e3);
close
T_MTemp(T_MTemp==0)=NaN;
if length(OnsetShock)==1
    T_MTemp_Interp(sess,:)=interp1(linspace(0,1,size(T_MTemp,1)),T_MTemp(:,sess),linspace(0,1,100));
else
    for sess=1:size(T_MTemp,1)
        T_MTemp_Interp(sess,:)=interp1(linspace(0,1,size(T_MTemp,2)),T_MTemp(sess,:),linspace(0,1,100));
    end
end
Episodes.MTemp_Interp=T_MTemp_Interp(:,1:100);



end






