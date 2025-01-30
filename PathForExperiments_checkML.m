%% get all files in /media
% takes a long time !!

try
    load /media/DataMOBsRAID/BilanDataML/PathAndInfoForExperimentML.mat
    disp('Loding NameFiles from existing /media/DataMOBsRAID/BilanDataML/PathAndInfoForExperimentML.mat')
    NameFiles;
catch
    % get all interesting folders
    a=0;
    a=a+1; Namedir{a}='/media/DataMOBs/PROJET OPTO';
    a=a+1; Namedir{a}='/media/DataMOBs/ProjetBULB';
    a=a+1; Namedir{a}='/media/DataMOBs/ProjetDPCPX';
    a=a+1; Namedir{a}='/media/DataMOBs/ProjetLPS';
    a=a+1; Namedir{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback';
    a=a+1; Namedir{a}='/media/DataMOBsRAID/ProjetAversion';
    a=a+1; Namedir{a}='/media/DataMOBsRAID/ProjetAstro-DataPlethysmo';
    a=a+1; Namedir{a}='/media/DataMOBsRAID/ProjetAstro';
    a=a+1; Namedir{a}='/media/DataMOBsRAID5/DataD1';
    a=a+1; Namedir{a}='/media/DataMOBsRAID5/DataB';
    a=a+1; Namedir{a}='/media/DataMOBsRAID5/DataD2';
    a=a+1; Namedir{a}='/media/DataMOBsRAID5/ProjetAstro';
    a=a+1; Namedir{a}='/media/DataMOBsRAID5/ProjetLocalGlobal';
    a=a+1; Namedir{a}='/media/DataMOBsRAID5/ProjetOPTO';
    a=a+1; Namedir{a}='/media/DataMOBsRAID5/ProjetSommeil';
    
    
    % get all .dat/.xml/.lfp files
    n_dat=0;
    n_xml=0;
    n_lfp=0;
    tempdatout=[];
    tempxmlout=[];
    templfpout=[];
    for a=1:length(Namedir)
        cd(Namedir{a})
        disp(' ');disp(Namedir{a})
        disp('       ... Searching dat files')
        [status,datout] = system('find -name *.dat');
        n_dat=n_dat+length(strfind(datout,'./'));
        datout=[datout,'./'];
        ind=[strfind(datout,'./')]; nametemp=[];
        for i=1:length(ind)-1;
            nametemp{i}=[Namedir{a},datout(ind(i)+1:ind(i+1)-1)];
        end
        tempdatout=[tempdatout,nametemp];
        
        disp('       ... Searching xml files')
        [status,xmlout] = system('find -name *.xml');
        n_xml=n_xml+length(strfind(xmlout,'./'));
        xmlout=[xmlout,'./'];
        ind=[strfind(xmlout,'./')]; nametemp=[];
        for i=1:length(ind)-1;
            nametemp{i}=[Namedir{a},xmlout(ind(i)+1:ind(i+1)-1)];
        end
        tempxmlout=[tempxmlout,nametemp];
        
        disp('       ... Searching lfp files')
        [status,lfpout] = system('find -name *.lfp');
        n_lfp=n_lfp+length(strfind(lfpout,'./'));
        lfpout=[lfpout,'./'];
        ind=[strfind(lfpout,'./')]; nametemp=[];
        for i=1:length(ind)-1;
            nametemp{i}=[Namedir{a},lfpout(ind(i)+1:ind(i+1)-1)];
        end
        templfpout=[templfpout,nametemp];
    end
    
    % separate in strings
    allout=[tempdatout,tempxmlout,templfpout];
    %
    
    NameFiles=tempdatout;
    % adding xml
    disp('discarding redondant .xml')
    for n=1:n_xml
        if sum(strcmp([allout{n_dat+n}(1:end-4),'dat'],NameFiles))==0
            %disp(['keeping ',nametemp{n_dat+n}])
            NameFiles=[NameFiles,allout(n_dat+n)];
        end
    end
    
    % adding lfp
    disp('discarding redondant .lfp')
    for n=1:n_lfp
        if sum(strcmp([allout{n_dat+n_xml+n}(1:end-4),'dat'],NameFiles)) + sum(strcmp([allout{n_dat+n_xml+n}(1:end-4),'xml'],NameFiles)) ==0
            %disp(['keeping ',nametemp{n_dat+n_xml+n}])
            NameFiles=[NameFiles,allout(n_dat+n_xml+n)];
        end
    end
    %
    % removing all
    disp('Removing intermediate .dat, mat.xml, time.dat, analogin.dat, auxiliary.dat or digitalout.dat')
    for a=1:20, numfi{a}=sprintf('-%02d-',a);end
    ind=nan(length(NameFiles),1);
    for n=1:length(NameFiles)
        if length(NameFiles{n})>14 ...
                && (strcmp(cellstr(NameFiles{n}(end-8:end)),{'.mat.xml'})...
                || strcmp(cellstr(NameFiles{n}(end-8:end)),{'time.dat'})...
                || strcmp(cellstr(NameFiles{n}(end-13:end-5)),{'-wideband'})...
                || strcmp(cellstr(NameFiles{n}(end-10:end)),{'supply.dat'})...
                || strcmp(cellstr(NameFiles{n}(end-12:end)),{'analogin.dat'})...
                || strcmp(cellstr(NameFiles{n}(end-13:end)),{'auxiliary.dat'})...
                || strcmp(cellstr(NameFiles{n}(end-14:end)),{'digitalout.dat'})...
                || strcmp(cellstr(NameFiles{n}(end-13:end)),{'digitalin.dat'})...
                || strcmp(cellstr(NameFiles{n}(end-11:end)),{'scoring.dat'})...
                || strcmp(cellstr(NameFiles{n}(end-7:end)),{'evt.dat'})...
                || strcmp(cellstr(NameFiles{n}(end-10:end)),{'signal.dat'}))
            ind(n)=0;
        else
            ind(n)=1;
        end
        
        for a=1:20
            if sum(strfind(NameFiles{n},numfi{a}))~=0
                ind(n)=0;
            end
        end
    end
    NameFiles=NameFiles(ind==1)';
    
    % saving
    save /media/DataMOBsRAID/BilanDataML/PathAndInfoForExperimentML NameFiles allout

end
%%
NameObject={'OB LFP' 'Delta PFCx' 'Delta PaCx' 'dHPC Ripples' 'Neurons PFCx' 'Neurons OB' 'Respi' 'EcoG/EEG PFCx' 'CleanWake' 'h_start Rec' 'h_end Rec'};

try 
    load /media/DataMOBsRAID/BilanDataML/PathAndInfoForExperimentML.mat
    Description;
catch
    Description=nan(length(NameFiles),1+length(NameObject));
end

try
    for a=1:length(NameFiles)
        disp(NameFiles{a})
        cd(NameFiles{a}(1:max(strfind(NameFiles{a},'/'))));
        
        % nameMouse
        ind=min(strfind(NameFiles{a},'Mouse'))+5;
        nameMouse=str2num(NameFiles{a}(ind:ind+2));
        
        % get Descrition Data Analysis
        clear defaultVal defaultans answer
        defaultVal=Description(a,:);
        
        for n=1:length(NameObject)
            if defaultVal(n)==0, defaultans{n}='no';
            elseif defaultVal(n)==1, defaultans{n}='yes';
            elseif defaultVal(n)==2, defaultans{n}='todo';
            else, defaultans{n}='undefined';
            end
        end
        
        answer = inputdlg(['Possible answer',NameObject],NameFiles{a},1,['yes/no/todo/undefined',defaultans]);
        if isempty(answer)
            disp('quitting (you should press ok to skip, not cancel)')
            cd /media/DataMOBsRAID/BilanDataML
            error;
        end
        
        answer=answer(2:end);
        temp=nan(1,length(NameObject));
        temp(strcmp(answer,'todo'))=2;
        temp(strcmp(answer,'yes'))=1;
        temp(strcmp(answer,'no'))=0;
        Description(a,:)=[nameMouse,temp];
        
        disp('    ...saving')
        save /media/DataMOBsRAID/BilanDataML/PathAndInfoForExperimentML -append Description NameObject
        
    end
end









