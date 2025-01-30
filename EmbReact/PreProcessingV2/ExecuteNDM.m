% Mergedata and make lfps

for f=1:length(FolderName)
    GoodToGo=0;
    cd(FolderName{f})
    disp(FolderName{f})
    load('ExpeInfo.mat')
    
    % this was old way to do processing
    %     spk=strcmp(answer{1},'yes');
    %     doaccelero=strcmp(answer{2},'yes');
    %     dodigitalin=strcmp(answer{3},'yes');
    %     doanalogin=strcmp(answer{4},'yes');
    
    spk = ExpeInfo.PreProcessingInfo.DoSpikes;
    doaccelero = ExpeInfo.PreProcessingInfo.NumAccelero>0;
    dodigitalin = ExpeInfo.PreProcessingInfo.NumDigChan>0;
    doanalogin = ExpeInfo.PreProcessingInfo.NumAnalog>0;
    
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'ProjectEmbReact')):end),'/','_');
    
    
    if (exist('amplifier.dat')>0 |  exist(['amplifier_M' num2str(ExpeInfo.nmouse), '.dat'])>0) & not(exist('amplifier.lfp')>0)
        
        if ExpeInfo.nmouse==490
            system('cp /media/DataMOBS56_/ProjectEmbReact/Mouse490/OrderedFiles/amplifier.xml amplifier.xml')
            system('cp /media/DataMOBS56_/ProjectEmbReact/Mouse490/OrderedFiles/amplifier_SpikeRef.xml amplifier_SpikeRef.xml')
        elseif ExpeInfo.nmouse==514
            Questions={'SpikeData (yes/no)','INTAN accelero',...
                'INTAN Digital input'};
            spk=strcmp(answer{1},'yes');
            doaccelero=strcmp(answer{2},'yes');
            dodigitalin=strcmp(answer{3},'yes');
            save makedataBulbeInputs answer answerdigin Questions spk doaccelero dodigitalin
            system('cp /media/DataMOS69/OrderedFiles/amplifier.xml amplifier.xml')
            system('cp /media/DataMOS69/OrderedFiles/amplifier_SpikeRef.xml amplifier_SpikeRef.xml')
        end
        
        if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.dat'])==0 & exist(['amplifier.dat'])>0
            %             CallRefFunction
            % subtract the reference
            RefChannel = ExpeInfo.ChannelToAnalyse.Ref;
            % do subtraction on all the wideband channels
            ChanToSub = [0 : ExpeInfo.PreProcessingInfo.NumWideband-1];
            ChanToSub(ChanToSub==RefChannel) = [];
            % special case for breathing
            if isfield(ExpeInfo.ChannelToAnalyse,'Respi')
                ChanToSub(ChanToSub==ExpeInfo.ChannelToAnalyse.Respi) = [];
            end
            ChanToSave = [0 :ExpeInfo.PreProcessingInfo.NumWideband-1];
            ChanToSave(ChanToSub+1) = [];
            % Do the subtraction
            RefSubtraction_multi('amplifier.dat',ExpeInfo.PreProcessingInfo.NumWideband,1,['M' num2str(ExpeInfo.nmouse)],ChanToSub,RefChannel,ChanToSave);
            
        end
        
        % if its not a sleep session, check that there is digital input
        if or(exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.dat'])==0,...
                exist('digitalin.dat')==0) & ExpeInfo.SleepSession==0
            disp('problem with files - sort out and then')
            keyboard
            GoodToGo=input('Are we good to go? 1/0');
        else
            GoodToGo=1;
        end
        
        
        if GoodToGo
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
                
                system(['ndm_mergedat ' NewFolderName])
            else
                system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '.dat ' NewFolderName '.dat'])
                if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.xml'])>0
                    system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '.xml ' NewFolderName '.xml'])
                else
                    system(['mv amplifier.xml ' NewFolderName '.xml'])
                end
            end
            
            if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.dat'])>0
                system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.dat ' NewFolderName '_SpikeRef.dat'])
                if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.xml'])>0
                    system(['mv amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.xml ' NewFolderName '_SpikeRef.xml'])
                else
                    system(['mv amplifier_SpikeRef.xml ' NewFolderName '_SpikeRef.xml'])
                end
                
            end
            
            disp(' getting lfp')
            system(['ndm_lfp ' NewFolderName])
            
            if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '_SpikeRef.dat'])==0 & exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.dat'])>0 & spk==1
                % careful, has been merged with accelero etc
                CallRefSpikeFunction
            end
            
            % Do we do spike pre processing
            if spk
                disp('getting spikes')
                system(['ndm_hipass ' NewFolderName '_SpikeRef'])
                % this was commented because I'm goign to sort everything
                % together
                %             system(['ndm_extractspikes ' NewFolderName '_SpikeRef'])
                %             system(['ndm_pca ' NewFolderName '_SpikeRef'])
            end
            
        end
    elseif exist('amplifier.lfp')>0
        system(['mv amplifier.lfp ' NewFolderName '.lfp'])
        system(['mv amplifier.dat ' NewFolderName '.dat'])
        system(['mv amplifier.xml ' NewFolderName '.xml'])
        
    end
end
