clear all,
mm=0;
% 248
ToFiltemp=[0:7,24:31];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150326-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-248-26032015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse248/20150327-EXT-48h-envB/';Filename{mm,2}='FEAR-Mouse-248-27032015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

% 244
ToFiltemp=[0:7,28:31];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150507-EXT-24h-envB/';Filename{mm,2}='FEAR-Mouse-244-07052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150506-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-244-06052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse244/20150508-EXT-48h-envC/';Filename{mm,2}='FEAR-Mouse-244-08052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

% 243
ToFiltemp=[0:7,28:31];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150506-EXT-24h-envC/'; Filename{mm,2}='FEAR-Mouse-243-06052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150507-EXT-24h-envB/';Filename{mm,2}='FEAR-Mouse-243-07052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse243/20150508-EXT-48h-envC/';Filename{mm,2}='FEAR-Mouse-243-08052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%249
ToFiltemp=[0:7,24:31];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150506-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-249-06052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150507-EXT-24h-envB/';Filename{mm,2}='FEAR-Mouse-249-07052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse249/20150508-EXT-48h-envC/';Filename{mm,2}='FEAR-Mouse-249-08052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%253
ToFiltemp=[8:23];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150703-EXT-24h-envC/FEAR-Mouse-253-03072015/';Filename{mm,2}='FEAR-Mouse-253-03072015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse253/20150704-EXT-48h-envB/FEAR-Mouse-253-04072015/';Filename{mm,2}='FEAR-Mouse-253-04072015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%254
ToFiltemp=[0:7,24:31];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150703-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-254-03072015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse254/20150704-EXT-48h-envB/FEAR-Mouse-254-04072015/';Filename{mm,2}='FEAR-Mouse-254-04072015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%258
ToFiltemp=[3:5,12:15];
NotToFiltemp=[0:15];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151204-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-258-20151204.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse258/20151205-EXT-48h-envB/';Filename{mm,2}='FEAR-Mouse-258-20151205.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%259
ToFiltemp=[4,5,7,10:13];
NotToFiltemp=[0:15];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151204-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-259-20151204.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse259/20151205-EXT-48h-envB/';Filename{mm,2}='FEAR-Mouse-259-20151205.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%299
ToFiltemp=[0:15];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151217-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-299-20151217.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse299/20151218-EXT-48h-envB/';Filename{mm,2}='FEAR-Mouse-299-20151218.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%250
ToFiltemp=[8:23];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150507-EXT-24h-envB/';Filename{mm,2}='FEAR-Mouse-250-07052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150506-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-250-06052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse250/20150508-EXT-48h-envC/';Filename{mm,2}='FEAR-Mouse-250-08052015.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%291
ToFiltemp=[12:29,31];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151204-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-291-20151204.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse291/20151205-EXT-48h-envB/';Filename{mm,2}='FEAR-Mouse-291-20151205.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%297
ToFiltemp=[0:3,12,13,14,16:24,26:31];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151217-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-297-20151217.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse297/20151218-EXT-48h-envB/';Filename{mm,2}='FEAR-Mouse-297-20151218.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;

%298
ToFiltemp=[0:25];
NotToFiltemp=[0:34];NotToFiltemp(ismember(NotToFiltemp,ToFiltemp))=[];
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151217-EXT-24h-envC/';Filename{mm,2}='FEAR-Mouse-298-20151217.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
mm=mm+1;Filename{mm,1}='/media/DataMOBsRAID/ProjetAversion/DATA-Fear/Mouse298/20151218-EXT-48h-envB/';Filename{mm,2}='FEAR-Mouse-298-20151218.dat';
ToFil{mm}=ToFiltemp;NotToFil{mm}=NotToFiltemp;
%
% WentWrong=[];
% for m=19
% try, cd(Filename{m,1})
% RefSubtraction_multi_AverageChans(Filename{m,2}, length([ToFil{m},NotToFil{m}]),1,'SpikeRef',ToFil{m},ToFil{m},NotToFil{m})
% movefile([Filename{m,2}(1:end-4) '_original.dat'],Filename{m,2})
% copyfile([Filename{m,2}(1:end-4) '.xml'],[Filename{m,2}(1:end-4) '_SpikeRef.xml'])
%
% system(['ndm_hipass ' Filename{m,2}(1:end-4) '_SpikeRef'])
% system(['ndm_extractspikes ' Filename{m,2}(1:end-4) '_SpikeRef'])
% system(['ndm_pca ' Filename{m,2}(1:end-4) '_SpikeRef'])
% for tet=1:6
% system(['KlustaKwiknew ' Filename{m,2}(1:end-4) '_SpikeRef ' num2str(tet)])
% end
% catch
%     WentWrong=[WentWrong,m];
% end
% end

WentWrong=[];
for m=1:mm
    try, 
        cd(Filename{m,1})
        
        SetCurrentSession([Filename{m,2}(1:end-4) '_SpikeRef.xml'])
        
        global DATA
        tetrodeChannels=DATA.spikeGroups.groups;
        
%         if exist('Waveforms.mat')>0
%             movefile('Waveforms.mat','WaveformsOld.mat')
%         end
%         if exist('SpikeData.mat')>0
%             movefile('SpikeData.mat','SpikeDataOld.mat')
%         end

        s=GetSpikes('output','full');
        a=1;
        clear S W
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
        disp('Done')
        
        
    catch
        WentWrong=[WentWrong,m];
    end
end



