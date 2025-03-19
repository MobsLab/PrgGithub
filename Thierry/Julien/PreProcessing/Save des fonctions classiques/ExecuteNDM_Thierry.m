% Mergedata and make lfps


ampliGoodToGo=0;
load('ExpeInfo.mat')
load('makedataBulbeInputs.mat')


spk=strcmp(answer{1},'yes');
doaccelero=strcmp(answer{2},'yes');
dodigitalin=strcmp(answer{3},'yes');
doanalogin=strcmp(answer{4},'yes');

NewFolderName = ['M' num2str(ExpeInfo.nmouse) '_' num2str(ExpeInfo.Date) '_' num2str(ExpeInfo.SessionName)];


if (exist('ampliGoodToGo=0'))
load('ExpeInfo.mat')
load('makedataBulbeInputs.mat')


spk=strcmp(answer{1},'yes');
doaccelero=strcmp(answer{2},'yes');
dodigitalin=strcmp(answer{3},'yes');
doanalogin=strcmp(answer{4},'yes');

NewFolderName = ['M' num2str(ExpeInfo.nmouse) '_' num2str(ExpeInfo.Date) '_' num2str(ExpeInfo.SessionName)];
end

if (exist('amplifier.dat','file')>0 |  exist(['amplifier_M' num2str(ExpeInfo.nmouse), '.dat'])>0) & not(exist('amplifier.lfp')>0)
    
    %% Subtract ref for LFP
    if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.dat'])==0 & exist(['amplifier.dat'])>0
        CallRefFunction_Thierry
    end
    
    %% Subtract ref for spikes
    if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.dat'])==0 & exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.dat'])>0 & spk==1
        CallRefFunctionSpikes_Thierry
    end
    %% Change ref channel in the function CallRefFunctionSpikes_Thierry
    %% merge digital data
    disp('Renaming and merging if necessary')
    if exist('digitalin.dat')>0 | exist('auxiliary.dat')>0
        
        if exist('auxiliary.dat')>0 
            system(['mv auxiliary.dat ' NewFolderName '-accelero.dat'])
        end
        if exist('analogin.dat')>0
            system(['mv analogin.dat ' NewFolderName '-analog.dat'])
        end
        if exist('digitalin.dat')>0
            system(['mv digitalin.dat ' NewFolderName '-digin.dat'])
        end
        
        system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '.dat ' NewFolderName '-wideband.dat'])
        
        if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.xml'])>0
            system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '.xml ' NewFolderName '.xml'])
        else
            system(['mv amplifier.xml ' NewFolderName '.xml'])
        end
        
        % merge
        system(['ndm_mergedat ' NewFolderName])
        
    else
        system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '.dat ' NewFolderName '.dat'])
        if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.xml'])>0
            system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '.xml ' NewFolderName '.xml'])
        else
            system(['mv amplifier.xml ' NewFolderName '.xml'])
        end
    end
    
    % rename spike data files
    if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.dat'])>0
        system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.dat ' NewFolderName '_SpikeRef.dat'])
        if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.xml'])>0
            system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.xml ' NewFolderName '_SpikeRef.xml'])
        else
            system(['mv amplifier_SpikeRef.xml ' NewFolderName '_SpikeRef.xml'])
        end
    end
    
    
    % make lfp file
    disp(' getting lfp')
    system(['ndm_lfp ' NewFolderName])
    
    % Spike pre processing
    if spk
        disp('getting spikes')
        system(['ndm_hipass ' NewFolderName '_SpikeRef'])
        system(['ndm_extractspikes ' NewFolderName '_SpikeRef'])
        system(['ndm_pca ' NewFolderName '_SpikeRef'])
    end
    
end  
