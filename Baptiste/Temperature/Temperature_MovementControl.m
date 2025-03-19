function Control = Temperature_MovementControl(Mouse_name, FolderList, tsd_used)

Mouse_name={['M' num2str(Mouse_name)]};

% Freezing Epoch, Zone Epoch, Stim Epoch
TempConcat.FreezeEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','freezeepoch');
TempConcat.ZoneEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'epoch','epochname','zoneepoch');
TempConcat.StimEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'epoch','epochname','stimepoch');

switch tsd_used
    case 'Tail'
        Tail.Fear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'tailtemperature');
        TempConcat.Fear=Tail.Fear;
    case 'Mask'
        Mask.Fear=ConcatenateDataFromFolders_BM(FolderList.(Mouse_name{1}),'masktemperature');
        TempConcat.Fear=Mask.Fear;
end

% Making all the Explo and Fz tsd
TempConcat.FearFz=Restrict( TempConcat.Fear, TempConcat.FreezeEpoch);
TotalEpoch = intervalSet(0,max(Range(TempConcat.Fear)));
Non_FreezinggAccEpoch=TotalEpoch-TempConcat.FreezeEpoch;
TempConcat.FearExplo=Restrict( TempConcat.Fear, Non_FreezinggAccEpoch);
TempConcat.FearFz1=Restrict(TempConcat.Fear,and(TempConcat.FreezeEpoch,TempConcat.ZoneEpoch{1}));
TempConcat.FearFz2=Restrict(TempConcat.Fear,and(TempConcat.FreezeEpoch,TempConcat.ZoneEpoch{2}));
TempConcat.FearFz4=Restrict(TempConcat.Fear,and(TempConcat.FreezeEpoch,TempConcat.ZoneEpoch{4}));
TempConcat.FearFz5=Restrict(TempConcat.Fear,and(TempConcat.FreezeEpoch,TempConcat.ZoneEpoch{5}));
TempConcat.FearExplo1=Restrict(TempConcat.Fear,and(Non_FreezinggAccEpoch,TempConcat.ZoneEpoch{1}));
TempConcat.FearExplo2=Restrict(TempConcat.Fear,and(Non_FreezinggAccEpoch,TempConcat.ZoneEpoch{2}));
TempConcat.FearExplo4=Restrict(TempConcat.Fear,and(Non_FreezinggAccEpoch,TempConcat.ZoneEpoch{4}));
TempConcat.FearExplo5=Restrict(TempConcat.Fear,and(Non_FreezinggAccEpoch,TempConcat.ZoneEpoch{5}));

TempConcat.FearFzShock=Restrict(TempConcat.Fear,and(TempConcat.FreezeEpoch,or(TempConcat.ZoneEpoch{1},TempConcat.ZoneEpoch{4})));
TempConcat.FearFzSafe=Restrict(TempConcat.Fear,and(TempConcat.FreezeEpoch,or(TempConcat.ZoneEpoch{2},TempConcat.ZoneEpoch{5})));
TempConcat.FearExploShock=Restrict(TempConcat.Fear,and(Non_FreezinggAccEpoch,or(TempConcat.ZoneEpoch{1},TempConcat.ZoneEpoch{4})));
TempConcat.FearExploSafe=Restrict(TempConcat.Fear,and(Non_FreezinggAccEpoch,or(TempConcat.ZoneEpoch{2},TempConcat.ZoneEpoch{5})));

Control.FearTemp=TempConcat.Fear;

Control.FearAcc=ConcatenateDataFromFolders_BM(FolderList.(Mouse_name{1}),'accelero');
Control.FearAccFz=Restrict( Control.FearAcc, TempConcat.FreezeEpoch);
Control.FearTempInt = Restrict(Control.FearTemp,ts(Range(Control.FearAcc)));

Control.FearTempExplo=TempConcat.FearExplo;
Control.FearTempFz=TempConcat.FearFz;
Control.FearTempFzShock=TempConcat.FearFzShock;
Control.FearTempFzSafe=TempConcat.FearFzSafe;
% find automatically values for 10% data hotest and coolest
FearTemp=Data(Control.FearTempExplo);
FearAcc=Data(Control.FearAcc);

TemperatureTreshold=40;
FearTemp_hot=FearTemp>TemperatureTreshold;
while sum(FearTemp_hot)/length(FearTemp)<0.1
    FearTemp_hot=FearTemp>TemperatureTreshold;
    TemperatureTreshold=TemperatureTreshold-0.1;
end

TemperatureTreshold=20;
FearTemp_cold=FearTemp<TemperatureTreshold;
while sum(FearTemp_cold)/length(FearTemp)<0.1
    FearTemp_cold=FearTemp<TemperatureTreshold;
    TemperatureTreshold=TemperatureTreshold+0.1;
end

Control.Temp_Accelero(1)=length(Data(Control.FearTempFz))/length(Data(Control.FearTemp));
Control.Temp_Accelero(2)=length(Data(Control.FearTempFzShock))/length(Data(Control.FearTempFz));

Control.Temp_Accelero(3)=nanmean(Data(Control.FearTemp));
Control.Temp_Accelero(4)=nanmean(Data(Control.FearTempFz));
Control.Temp_Accelero(5)=nanmean(Data(Control.FearTempExplo));

Control.Temp_Accelero(6)=nanmean(Data(Control.FearAcc));
Control.Temp_Accelero(7)=mean(FearAcc(FearTemp_hot));
Control.Temp_Accelero(8)=mean(FearAcc(FearTemp_cold));
Control.Temp_Accelero(9)=nanmean(Data(Control.FearAccFz));
end 


