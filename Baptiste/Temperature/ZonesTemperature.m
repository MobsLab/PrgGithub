function TempConcat = ZonesTemperature(Mouse_name,FolderList,tsd_used)

Mouse_name={['M' num2str(Mouse_name)]};

% Freezing Epoch, Zone Epoch, Stim Epoch
TempConcat.FreezeEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'Epoch','epochname','freezeepoch');
TempConcat.ZoneEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'epoch','epochname','zoneepoch');
TempConcat.StimEpoch=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'epoch','epochname','stimepoch');


switch tsd_used
    case 'Tail'
        Tail.Fear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'tailtemperature');
        %Room.Fear=ConcatenateDataFromFolders_SB(FolderList.(Mouse_name{1}),'roomtemperature');
        TempConcat.Fear=Tail.Fear;
    case 'Mask'
        Mask.Fear=ConcatenateDataFromFolders_BM(FolderList.(Mouse_name{1}),'masktemperature');
        %Room.Fear=ConcatenateDataFromFolders_BM(FolderList.(Mouse_name{1}),'roomtemperature');
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

end









