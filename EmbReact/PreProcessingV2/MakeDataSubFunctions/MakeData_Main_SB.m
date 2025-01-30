%makeDataBulbe
load('ExpeInfo.mat')

spk = ExpeInfo.PreProcessingInfo.DoSpikes;
doaccelero = ExpeInfo.PreProcessingInfo.NumAccelero>0;
dodigitalin = ExpeInfo.PreProcessingInfo.NumDigChan>0;
doanalogin = ExpeInfo.PreProcessingInfo.NumAnalog>0;
answerdigin{1} = num2str(find(~cellfun(@isempty,strfind(ExpeInfo.InfoLFP.structure,'Digin')))-1);
answerdigin{2} = ExpeInfo.PreProcessingInfo.NumDigInput;

spk = 0;
%% ------------------------------------------------------------------------
%------------------------- LFP --------------------------------------------
%--------------------------------------------------------------------------
load('LFPData/InfoLFP.mat')
if exist(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])==0
    if ExpeInfo.PreProcessingInfo.TypeOfSystem=='Intan'
        MakeData_LFP
    else
        MakeData_LFP_BM
    end
end

%% ------------------------------------------------------------------------
%----------------------- Spikes -------------------------------------------
%--------------------------------------------------------------------------
if spk
    RemoveMUA=0;
    MakeData_Spikes
end


% %% ------------------------------------------------------------------------
% %---------- Get Digital Input from INTAN - add to LFP file ----------
% %--------------------------------------------------------------------------

if dodigitalin
    if convertCharsToStrings(ExpeInfo.PreProcessingInfo.TypeOfSystem) == 'Intan'
        MakeData_Digin_BM
    end
end


%% ------------------------------------------------------------------------
%------------- Get Accelerometer info from INTAN data ---------------------
%--------------------------------------------------------------------------

if doaccelero
    MakeData_Accelero
end
%% ------------------------------------------------------------------------
%------------- Get time of recording  ---------------------
%--------------------------------------------------------------------------
% if ~convertCharsToStrings(ExpeInfo.PreProcessingInfo.TypeOfSystem) == 'Intan'
%     
%     StartFile = dir(['./OpenEphys/structure.oebin']);
%     if isempty(StartFile)
%         error('structure.oebin was not found. It should be present at the same level as "continuous" folder');
%     end
%     ind_start=strfind(StartFile.date,':');
%     TimeBeginRec(1,1:3)=[str2num(StartFile.date(ind_start(1)-2:ind_start(1)-1)),...
%         str2num(StartFile.date(ind_start(1)+1:ind_start(2)-1)),str2num(StartFile.date(ind_start(2)+1:end))];
%     
%     StopFile=dir('./*dat');
%     ind_stop=strfind(StopFile.date,':');
%     TimeEndRec(1,1:3)=[str2num(StopFile.date(ind_stop(1)-2:ind_stop(1)-1)),...
%         str2num(StopFile.date(ind_stop(1)+1:ind_stop(2)-1)),str2num(StopFile.date(ind_stop(2)+1:end))];
%     
%     save('behavResources.mat','TimeEndRec','TimeBeginRec','-append')
%     
% end

MakeData_RecordingTime

