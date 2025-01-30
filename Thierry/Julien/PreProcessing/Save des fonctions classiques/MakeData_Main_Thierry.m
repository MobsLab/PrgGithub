%makeDataBulbe

load('makedataBulbeInputs.mat')
if not(exist('spk') & exist('doaccelero') & exist('dodigitalin') )
    spk=strcmp(answer{1},'yes');
    doaccelero=strcmp(answer{2},'yes');
    dodigitalin=strcmp(answer{3},'yes');
end


%% ------------------------------------------------------------------------
%------------------------- LFP --------------------------------------------
%--------------------------------------------------------------------------
load('LFPData/InfoLFP.mat')
if exist(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])==0
    MakeData_LFP
end

%% ------------------------------------------------------------------------
%----------------------- Spikes -------------------------------------------
%--------------------------------------------------------------------------
if 0
     %%MakeData_Spikes
end


%% ------------------------------------------------------------------------
%------------- Get Accelerometer info from INTAN data ---------------------
%--------------------------------------------------------------------------

if doaccelero
    MakeData_Accelero
end

% %% ------------------------------------------------------------------------
% %---------- Get Digital Input from INTAN - add to LFP file ----------
% %--------------------------------------------------------------------------

if dodigitalin
    MakeData_Digin
end



