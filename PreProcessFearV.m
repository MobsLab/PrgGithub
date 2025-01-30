clear all
mm=0;
mm=mm+1;Filename{mm}='/media/DataMOBs55bis/FEAR_souris_Marie/intan_data/Mouse-394/';
TetrodeChans{mm}=[0:7];
mm=mm+1;Filename{mm}='/media/DataMOBs55bis/FEAR_souris_Marie/intan_data/Mouse-395/';
TetrodeChans{mm}=[0:6,16:27,29:31];
mm=mm+1;Filename{mm}='/media/DataMOBs55bis/FEAR_souris_Marie/intan_data/Mouse-402/';
TetrodeChans{mm}=[0:7,16:31];
mm=mm+1;Filename{mm}='/media/DataMOBs55bis/FEAR_souris_Marie/intan_data/Mouse-403/';
TetrodeChans{mm}=[0:14,16,18:22];
mm=mm+1;Filename{mm}='/media/DataMOBs55bis/FEAR_souris_Marie/intan_data/Mouse-450/';
TetrodeChans{mm}=[0:7,16:31];
mm=mm+1;Filename{mm}='/media/DataMOBs55bis/FEAR_souris_Marie/intan_data/Mouse-451/';
TetrodeChans{mm}=[0:23];

% DidntWork=[];
% for m=2:mm
%     cd(Filename{m})
%     GetFolderName=dir;
%     AmplifierXMLFile=[cd filesep 'amplifier.xml'];
%     AmplifierXMLFileSpikes=[cd filesep 'amplifier_Spikes.xml'];
%
%     num=0;
%     clear Folders
%     for g=1:length(GetFolderName)
%         if not(isempty(findstr(GetFolderName(g).name,'FEAR')))
%             num=num+1;
%             Folders{num}=GetFolderName(g).name
%         end
%     end
%
%     for f=1:length(Folders)
%         try
%             cd(Filename{m})
%             cd(Folders{f})
%             ChansToKeep=[0:31];   ChansToKeep(ismember(ChansToKeep,TetrodeChans{m}))=[];
%             load('LFPData/InfoLFP.mat')
%             RefChan= InfoLFP.channel(find(strcmp(InfoLFP.structure,'Ref')));
%             RefSubtraction_multi_AverageChans('amplifier.dat',32,1,'SubRefSpk', TetrodeChans{m}(:)', TetrodeChans{m}(:)', ChansToKeep)
%             RefSubtraction_multi('amplifier_original.dat',32,1,'SubNorm', [0:31],RefChan,[]);
%
%             movefile('amplifier_original_SubNorm.dat',[Folders{f} '-wideband.dat'])
%             movefile('digitalin.dat',[Folders{f} '-digin.dat'])
%             movefile('auxiliary.dat',[Folders{f} '-accelero.dat'])
%             movefile('amplifier_SubRefSpk.dat',[Folders{f} '_SubRefSpk.dat'])
%
%             copyfile(AmplifierXMLFile,[Folders{f} '.xml'])
%             copyfile(AmplifierXMLFileSpikes,[Folders{f} '_SubRefSpk.xml'])
%
%             system(['ndm_mergedat ' Folders{f}])
%             system(['ndm_lfp ' Folders{f}])
%
%             system(['ndm_hipass ' Folders{f} '_SubRefSpk'])
%             system(['ndm_extractspikes ' Folders{f} '_SubRefSpk'])
%             system(['ndm_pca ' Folders{f} '_SubRefSpk'])
%             mkdir('OriginalClusters')
%             for tet=1:10
%                 system(['KlustaKwiknew ' Folders{f} '_SubRefSpk ' num2str(tet)])
%                 try,copyfile([Folders{f} '_SubRefSpk.clu.' num2str(tet)],['OriginalClusters/' Folders{f} '_SubRefSpk.clu.' num2str(tet)]),end
%             end
%         catch
%             DidntWork=[DidntWork;[m,f]];
%         end
%     end
%
% end

DidntWork=[];
for m=1:mm
    cd(Filename{m})
    GetFolderName=dir;
    
    num=0;
    clear Folders
    for g=1:length(GetFolderName)
        if not(isempty(findstr(GetFolderName(g).name,'EXT')))
            num=num+1;
            Folders{num}=GetFolderName(g).name,
        end
    end
    
    for f=1:length(Folders)
        try
            cd(Filename{m})
            cd(Folders{f})
            res=cd;
            % Load LFPs
            SetCurrentSession([Folders{f} '.xml']);
            load('LFPData/InfoLFP.mat')
            for i=1:length(InfoLFP.channel)
                LFP_temp=GetLFP(InfoLFP.channel(i));
                disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
                LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                if exist('reverseData','var'), LFP=tsd(LFP_temp(:,1)*1E4,-LFP_temp(:,2));end
                save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'LFP');
                clear LFP LFP_temp
            end
            disp('LFP Done')
            
            % Load Spikes
            SetCurrentSession([Folders{f} '_SubRefSpk.xml']);
            global DATA
            tetrodeChannels=DATA.spikeGroups.groups;
            s=GetSpikes('output','full');
            a=1;
            clear S
            for i=1:20
                for j=1:200
                    try
                        if length(find(s(:,2)==i&s(:,3)==j))>1
                            S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
                            TT{a}=[i,j];
                            cellnames{a}=['TT',num2str(i),'c',num2str(j)];
                            
                            tempW = GetSpikeWaveforms([i j]);
                            disp(['Cluster : ',cellnames{a},' > done'])
                            for elec=1:size(tempW,2)
                                W{a}(elec,:)=mean(squeeze(tempW(:,elec,:)));
                            end
                            a=a+1;
                        end
                    end
                end
                disp(['Tetrodes #',num2str(i),' > done'])
            end
            
            try
                S=tsdArray(S);
            end
            
            clear tempW
            save SpikeData -v7.3 S s TT cellnames tetrodeChannels
            save Waveforms -v7.3 W cellnames
            disp('Done Spikes')
            
            % Calculate spectra
            load('ChannelsToAnalyse/Bulb_deep.mat')
            LowSpectrumSB([cd filesep],channel,'B');
            try,load('ChannelsToAnalyse/dHPC_rip.mat')
                LowSpectrumSB([cd filesep],channel,'H');
            catch,load('ChannelsToAnalyse/dHPC_deep.mat')
                LowSpectrumSB([cd filesep],channel,'H');
            end
            load('ChannelsToAnalyse/PFCx_deep.mat')
            LowSpectrumSB([cd filesep],channel,'PFCc');
            
        catch
            DidntWork=[DidntWork;[m,f]];
        end
    end
    
end