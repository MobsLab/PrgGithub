%% Mergedata and make lfps

for f=1:length(FolderName)
    GoodToGo=0;
    cd(FolderName{f})
    disp(FolderName{f})
    load('ExpeInfo.mat')
    NewFolderName=strrep(FolderName{f}(max(findstr(FolderName{f},'FluoxetineETM')):end),'/','_');
    
    if convertCharsToStrings(ExpeInfo.PreProcessingInfo.TypeOfSystem) == 'Intan'

        spk = ExpeInfo.PreProcessingInfo.DoSpikes;
        doaccelero = ExpeInfo.PreProcessingInfo.NumAccelero>0;
        dodigitalin = ExpeInfo.PreProcessingInfo.NumDigChan>0;
        doanalogin = ExpeInfo.PreProcessingInfo.NumAnalog>0;
        
        
        if (exist('amplifier.dat')>0 |  exist(['amplifier_M' num2str(ExpeInfo.nmouse), '.dat'])>0) & not(exist('amplifier.lfp')>0)
            
            
            if exist(['amplifier_M' num2str(ExpeInfo.nmouse) '.dat'])==0 & exist(['amplifier.dat'])>0
                if ~isnan(ExpeInfo.ChannelToAnalyse.Ref)
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
                else
                    Appendice=['amplifier_M' num2str(ExpeInfo.nmouse)];
                    system(['mv amplifier.dat ' Appendice '.dat'])
                end % This part was modified by BM when a mouse dosen't have a ref
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
                
                delete([NewFolderName '_original.dat']);
                
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
        
    else % processing OE files
        
        % rename folder with OE data into 'OpenEphys'
        a=dir; folder_name_OE = a(11,1).name;
        movefile(folder_name_OE,'OpenEphys')
        clear a
        
        cd('./OpenEphys')
        
        out_ind = regexp(ExpeInfo.PreProcessingInfo.FolderForConcatenation_Ephys{1}, 'continuous');
        StartFile = dir(['structure.oebin']);
        if isempty(StartFile)
            error('structure.oebin was not found. It should be present at the same level as "continuous" folder');
        end
        ind_start=strfind(StartFile.date,':');
        TimeBeginRec(1,1:3)=[str2num(StartFile.date(ind_start(1)-2:ind_start(1)-1)),...
            str2num(StartFile.date(ind_start(1)+1:ind_start(2)-1)),str2num(StartFile.date(ind_start(2)+1:end))];
        
        StopFile=dir('./continuous/Rhythm_FPGA-100.0/*dat');
        ind_stop=strfind(StopFile.date,':');
        TimeEndRec(1,1:3)=[str2num(StopFile.date(ind_stop(1)-2:ind_stop(1)-1)),...
            str2num(StopFile.date(ind_stop(1)+1:ind_stop(2)-1)),str2num(StopFile.date(ind_stop(2)+1:end))];
        
        disp(['File starts at ' num2str(TimeBeginRec(1,1:3)) ' and ends at ' num2str(TimeEndRec(1,1:3))])
    
        
        %% here is the place where we check if the ephys is the right length comapred to the behav resources - to do
        
        %% copy ephys files that are ref subtracted and merged
        if isnan(ExpeInfo.ChannelToAnalyse.Ref)
            
            % copy the .dat and the .xml
            copyfile(fullfile([pwd '/continuous/Rhythm_FPGA-100.0'], 'continuous.dat'),...
                fullfile([pwd '/continuous/Rhythm_FPGA-100.0'],...
                [NewFolderName  '.dat']));
            movefile(fullfile([pwd '/continuous/Rhythm_FPGA-100.0'],...
                [NewFolderName  '.dat']), FolderName{f});

                    cd('..')

        else
                        
            % subtract the reference
            RefChannel = ExpeInfo.ChannelToAnalyse.Ref;
            % do subtraction on all the wideband channels
            ChanToSub = [0 : ExpeInfo.PreProcessingInfo.NumWideband-1];
            ChanToSub(ChanToSub==RefChannel) = [];
            % special case for breathing
            if isfield(ExpeInfo.ChannelToAnalyse,'Respi')
                ChanToSub(ChanToSub==ExpeInfo.ChannelToAnalyse.Respi) = [];
            end
            ChanToSave = [0 :ExpeInfo.PreProcessingInfo.TotalChannels-1];
            ChanToSave(ChanToSub+1) = [];
            
            copyfile(fullfile([pwd '/continuous/Rhythm_FPGA-100.0'], 'continuous.dat'),...
                fullfile([pwd '/continuous/Rhythm_FPGA-100.0'],...
                [NewFolderName  '.dat']));
            movefile(fullfile([pwd '/continuous/Rhythm_FPGA-100.0'],...
                [NewFolderName  '.dat']), FolderName{f});
            
            cd('..')
            
            % Do the subtraction
            RefSubtraction_multi([NewFolderName '.dat'],ExpeInfo.PreProcessingInfo.TotalChannels,1,...
                ['M' num2str(ExpeInfo.nmouse)],ChanToSub,RefChannel,ChanToSave);
            
            disp(['file is merged and ref subtracted - copying ...'])
            % copy the file
            movefile([NewFolderName '_M' num2str(ExpeInfo.nmouse) '.dat'] , [NewFolderName '.dat']);
            delete([NewFolderName '_original.dat']);
   
        end
        
        
        %% make lfp
        movefile( 'amplifier.xml', [NewFolderName '.xml']);
        system(['ndm_lfp ' FolderName{f} '/' NewFolderName])
        
        %% Make TTL info
        MakeData_Digin_ForOE_Data_BM
    end
end
