% AnalyseNosePokeOdor

%% INITIALIZATION
% anoying problem
plo=1; % 1 if display wanted, 0 otherwise
res=pwd;
if isempty(strfind(res,'/')),mark='\';else mark='/';end
% manipes odeurs, septembre 2014
scrsz = get(0,'ScreenSize');
%scrsz=scrsz/2;
clear NosePokesIntervals NosePokeData NosePokes newStartSignal newStopSignal 
clear namePhase lengthPhase d_obj PercExclu Ratio_IMAonREAL ref
clear NameTrackFiles CaractSniffALL PosMatALL NamePokeFiles
clear StartSignal StopSignal NosePokeSignal NosePokeSignalRaw CTRLArduinoSignal
clear Name_StartChannel Name_StopChannel Name_NosePokeRaw Name_NosePokeStep Name_ControlArduino 

try 
    load('NosePokeData.mat','NamePokeFiles'); NamePokeFiles;
catch
    NamePokeFiles=uigetfile('.mat','Load Expe Files','MultiSelect','on');
    try NamePokeFiles{:}; catch, NamePokeFiles={NamePokeFiles};end
    save NosePokeData NamePokeFiles
end
basename=NamePokeFiles{1}(1:23);
disp(' '); disp(['     * * * ',basename,' * * *']);


% Channels correspondance

Name_StartChannel='Di_D1_2';
Name_StopChannel='Di_D1_3';
Name_NosePokeRaw='Di_D1_11';
Name_NosePokeStep='Di_D1_13';
Name_ControlArduino='Di_D1_14';


%% LOAD DATA FROM .MAT FILES
try 
    load('NosePokeData.mat'); 
    NosePokeSignal;
    disp('NosePokeData already defined.. skipping this step')
    
catch
    
    disp(' '); disp('Loading and saving NosePokeData... ')
    StartSignal=[];
    StopSignal=[];
    NosePokeSignal=[];
    NosePokeSignalRaw=[];
    CTRLArduinoSignal=[];
    for ff=1:length(NamePokeFiles)
        
        disp(['  - ',NamePokeFiles{ff}])
        
        % load file
        try Swide=load(NamePokeFiles{ff});catch, keyboard;end
        Swide=struct2cell(Swide);
        
        % get specific channels
        for i=1:length(Swide)
            if strcmp(Swide{i}.title,Name_StartChannel)
                disp([Swide{i}.title,'   --> saving in NosePokeData.mat - StartSignal'])
                StartSignal=[StartSignal;[Swide{i}.times(1:2:end,:),ff*ones(length(Swide{i}.times(1:2:end,:)),1)]];
                
            elseif strcmp(Swide{i}.title,Name_StopChannel)
                disp([Swide{i}.title,'   --> saving in NosePokeData.mat - StopSignal'])
                StopSignal=[StopSignal;[Swide{i}.times(1:2:end,:),ff*ones(length(Swide{i}.times(1:2:end,:)),1)]];
                
            elseif strcmp(Swide{i}.title,Name_NosePokeStep)
                disp([Swide{i}.title,'   --> saving in NosePokeData.mat - NosePokeSignal'])
                NosePokeSignal=[NosePokeSignal;[Swide{i}.times,ff*ones(length(Swide{i}.times),1),double(Swide{i}.level)]];
                
            elseif strcmp(Swide{i}.title,Name_NosePokeRaw)
                disp([Swide{i}.title,'   --> saving in NosePokeData.mat - NosePokeSignalRaw'])
                NosePokeSignalRaw=[NosePokeSignalRaw;[Swide{i}.times,ff*ones(length(Swide{i}.times),1),double(Swide{i}.level)]];
                
            elseif strcmp(Swide{i}.title,Name_ControlArduino)
                disp([Swide{i}.title,'   --> saving in NosePokeData.mat - CTRLArduinoSignal'])
                CTRLArduinoSignal=[CTRLArduinoSignal;[Swide{i}.times(1:2:end,:),ff*ones(length(Swide{i}.times(1:2:end,:)),1)]];
                
            end
        end
    end
    % remove Arduino artefacts
    if ~isempty(CTRLArduinoSignal)
        for ff=1:length(NamePokeFiles)
            temp=CTRLArduinoSignal(CTRLArduinoSignal(:,2)==ff,1);
            for tt=1:length(temp)
                StartSignal(abs(StartSignal(:,1)-temp(tt))<1/1E6 & StartSignal(:,2)==ff,:)=[];
                StopSignal(abs(StopSignal(:,1)-temp(tt))<1/1E6 & StopSignal(:,2)==ff,:)=[];
                NosePokeSignal(abs(NosePokeSignal(:,1)-temp(tt))<1/1E6 & NosePokeSignal(:,2)==ff,:)=[];
                NosePokeSignalRaw(abs(NosePokeSignalRaw(:,1)-temp(tt))<1/1E6 & NosePokeSignalRaw(:,2)==ff,:)=[];
            end
        end
    end
    save NosePokeData -append basename StartSignal StopSignal NosePokeSignal NosePokeSignalRaw CTRLArduinoSignal
    save NosePokeData -append Name_StartChannel Name_StopChannel Name_NosePokeRaw Name_NosePokeStep Name_ControlArduino 
end

%% LOAD TRACKING AND SNIFF CARACTERISTICS DATA

try
    load('TrackSniffData.mat');
    PosMatALL;ref;
    disp('TrackSniffData already defined.. skipping this step')
    
catch
    list=dir;
    NameTrackFiles=[];
    PosMatALL=[];
    CaractSniffALL=[];
    disp(' ');disp('Loading and saving CaractSniff and PosMat from... ')
    for i=3:length(list)
        if exist(list(i).name,'dir')==7 && strcmp(list(i).name(1:23),basename)
            disp(['  - ',list(i).name])
            
            NameTrackFiles=[NameTrackFiles,{list(i).name}];
            if length(NameTrackFiles)==1
                TempLoad=load([list(i).name,mark,'AroundOdorON.mat'],'namePhase','lengthPhase','d_obj','PercExclu','Ratio_IMAonREAL','OdorInfo');
                OdorInfo=TempLoad.OdorInfo;
                namePhase=TempLoad.namePhase;
                lengthPhase=TempLoad.lengthPhase;
                d_obj=TempLoad.d_obj;
                PercExclu=TempLoad.PercExclu;
                Ratio_IMAonREAL=TempLoad.Ratio_IMAonREAL;
                TempLoad=load([list(i).name,mark,'InfoTracking.mat'],'ref');
                ref=TempLoad.ref;
            end
            
            TempLoad=load([list(i).name,mark,'AroundOdorON.mat'],'CaractSniff');
            CaractSniffALL=[CaractSniffALL;[length(NameTrackFiles)*ones(size(TempLoad.CaractSniff,1),1),TempLoad.CaractSniff]];
            
            TempLoad=load([list(i).name,mark,'InfoTracking.mat'],'PosMat');
            PosMatALL=[PosMatALL;[length(NameTrackFiles)*ones(size(TempLoad.PosMat,1),1),TempLoad.PosMat]];
            
            
        end
    end
    
    save TrackSniffData NameTrackFiles CaractSniffALL PosMatALL basename
    save TrackSniffData -append namePhase lengthPhase d_obj PercExclu Ratio_IMAonREAL ref OdorInfo
end



%% FITTING NOSEPOKE AND TRACKING FILES
    
try
    NosePokes;
    disp('NosePokes already defined for all files. Skipping this step')
    
catch
    
    disp(' ');disp('Computing NosePokes matrice...');
    
    if length(NameTrackFiles)==size(StartSignal,1);
        disp(' file.mcd includes all and only the good track files');
        
        NosePokes=[NosePokeSignal,nan(size(NosePokeSignal,1),1)];
        numFiles=1;
        for ff=1:length(NamePokeFiles)
            numFiles=find(StopSignal(:,2)==ff);
            for i=1:length(numFiles)
                index=find(NosePokeSignal(:,2)==ff & NosePokeSignal(:,1)<StopSignal(numFiles(i)) & NosePokeSignal(:,1)>=StartSignal(numFiles(i)));
                NosePokes(index,4)=numFiles(i)*ones(length(index),1);
            end
        end
        newStartSignal=StartSignal;
        newStopSignal=StopSignal;
        
    else
        
        if size(StopSignal,1)==size(StartSignal,1)
            disp(['file.mcd includes ',num2str(size(StartSignal,1)),' periods, for ',num2str(length(NameTrackFiles)),' track files']);
            
            LengthFiles=[floor(StopSignal-StartSignal),nan(length(StopSignal),1)];
            LengthFiles(1:length(lengthPhase),3)=lengthPhase';
            for i=1:length(LengthFiles)
                disp(['   Period ',num2str(i),'- ',num2str(LengthFiles(i,:))])
            end
            
            removePokePeriods=input('Enter Period to discard (e.g. [10 11]): ');
            while length(LengthFiles)-length(removePokePeriods)~=length(NameTrackFiles)
                disp([num2str(length(LengthFiles)-length(NameTrackFiles)),' periods must be removed!'])
                removePokePeriods=input('Enter Period to discard (e.g. [10 11]): ');
            end
            
            newStartSignal=StartSignal; newStartSignal(removePokePeriods,:)=[];
            newStopSignal=StopSignal;newStopSignal(removePokePeriods,:)=[];
            
            NosePokes=[NosePokeSignal,nan(size(NosePokeSignal,1),1)];
            numFiles=1;
            for ff=1:length(NamePokeFiles)
                numFiles=find(newStopSignal(:,2)==ff);
                for i=1:length(numFiles)
                    index=find(NosePokeSignal(:,2)==ff & NosePokeSignal(:,1)<newStopSignal(numFiles(i)) & NosePokeSignal(:,1)>=newStartSignal(numFiles(i)));
                    NosePokes(index,4)=numFiles(i)*ones(length(index),1);
                end
            end
            
        else
            if size(StopSignal,1)==length(NameTrackFiles)
                disp('Extracting good periods from file.mcd ');
                
                newStopSignal=StopSignal;
                newStartSignal=[];
                for ff=1:length(NamePokeFiles)
                    tempStops=StopSignal(StopSignal(:,2)==ff,1);
                    for i=1:length(tempStops)
                        tempStarts=StartSignal(StartSignal(:,2)==ff,:);
                        index=find(tempStarts(:,1)-tempStops(i)<0);
                        newStartSignal=[newStartSignal;tempStarts(max(index),:)];
                    end
                end
                
                NosePokes=[NosePokeSignal,nan(size(NosePokeSignal,1),1)];
                numFiles=1;
                for ff=1:length(NamePokeFiles)
                    numFiles=find(StopSignal(:,2)==ff);
                    for i=1:length(numFiles)
                        index=find(NosePokeSignal(:,2)==ff & NosePokeSignal(:,1)<StopSignal(numFiles(i)) & NosePokeSignal(:,1)>=newStartSignal(numFiles(i)));
                        NosePokes(index,4)=numFiles(i)*ones(length(index),1);
                    end
                end
                
                disp('For information:')
                LengthFiles=[floor(newStopSignal-newStartSignal),nan(length(newStopSignal),1)];
                LengthFiles(1:length(lengthPhase),3)=lengthPhase';
                for i=1:length(LengthFiles)
                    disp(['   Period ',num2str(i),'- ',num2str(LengthFiles(i,:))])
                end
            
            else
                disp('Trop chiant !!!!!!!!!');
                disp('Do your self NosePokes newStartSignal newStopSignal');keyboard;
            end
            
        end
    end
        save NosePokeData -append NosePokes newStartSignal newStopSignal
end


%% ANALYSE NOSEPOKE

try
    Start(NosePokesIntervals{1});
    disp('NosePokesIntervals already exists. Skipping this step.')
catch
    disp(' ');disp('Creating array NosePokesIntervals')
    for i=1:length(NameTrackFiles)
        clear PokeSTART PokeSTOP PeriodStart PeriodStop
        PokeSTART=NosePokes(NosePokes(:,4)==i & NosePokes(:,3)==0,1);
        PokeSTOP=NosePokes(NosePokes(:,4)==i & NosePokes(:,3)==1,1);
        
        PeriodStart=newStartSignal(i);
        PeriodStop=newStopSignal(i);
        
        
        if length(PokeSTART)==length(PokeSTOP)+1
            PokeSTOP=[PokeSTOP;PeriodStop];
        elseif length(PokeSTART)+1==length(PokeSTOP)
            PokeSTART=[PeriodStart;PokeSTART];
        elseif abs(length(PokeSTART)-length(PokeSTOP))>1
            disp(['Problem NosePoke ',NameTrackFiles{i}]); keyboard;
        end
        
        try NosePokesIntervals{i}=intervalSet(PokeSTART*1E4,PokeSTOP*1E4);catch, keyboard;end
        if ~plo, disp([NameTrackFiles{i}(length(basename)+1:end),': ',num2str(length(PokeSTART)),' NosePokes (',num2str(round(10*sum(PokeSTOP-PokeSTART))/10),'s)']);end
    end
    save NosePokeData -append NosePokesIntervals
end




%% COMPUTE AND SAVE MATT

try
    load('MATTsave.mat');MATTdisp;MATT;
    disp('MATTsave.mat alreday exists.. skipping this step')
catch
    % ---------------------------------------------------------------------
    % display nosepokes
    %parameters={'Nb NosePokes','% time in NosePoke','time in NosePoke','Interval InterNosePoke'};
    parameters={'Nb NosePokes','% time in NosePoke','Zscore % NosePoke','% Time in NosePoke Zone','% NosePoke when in Zone'};
    MATTdisp=zeros(length(NameTrackFiles),length(parameters));
    MATTdispSelect=[]; indexSelect=[];ste=[];sti=[];
    
    % to zscore
    SUMall=zeros(length(NameTrackFiles),1);
    for i=1:length(NameTrackFiles)
        try SUMall(i)=100*sum(Stop(NosePokesIntervals{i},'s')-Start(NosePokesIntervals{i},'s'))/(newStopSignal(i)-newStartSignal(i));end
    end
    zscoreSUMall=zscore(SUMall);
    
    
    %
    DistFromO=(PosMatALL(:,3)-OdorInfo(1)).*(PosMatALL(:,3)-OdorInfo(1)) +(PosMatALL(:,4)-OdorInfo(2)).*(PosMatALL(:,4)-OdorInfo(2));
    
    for i=1:length(NameTrackFiles)
        tempIntervals=NosePokesIntervals{i};
        sti=Start(tempIntervals,'s');
        ste=Stop(tempIntervals,'s');
        
        if ~isempty(Start(tempIntervals))
            indexPos=find(PosMatALL(:,1)==i & DistFromO<(5*Ratio_IMAonREAL)^2);
            
            MATTdisp(i,1)=length(sti);
            MATTdisp(i,2)=100*sum(ste-sti)/(newStopSignal(i)-newStartSignal(i));
            MATTdisp(i,3)=zscoreSUMall(i);
            %MATTdisp(i,3)=sum(ste-sti);
            %if length(sti)>2, MATTdisp(i,4)=mean(sti(2:end)-ste(1:end-1));else, MATTdisp(i,4)=NaN; end
            MATTdisp(i,4)= 100*(length(indexPos)/length(find(PosMatALL(:,1)==i)))  ;
            MATTdisp(i,5)= 100*(sum(ste-sti)/(length(indexPos)*mean(diff(PosMatALL(PosMatALL(:,1)==i,2)))))  ;
        
        end
        
        disp([NameTrackFiles{i}(length(basename)+1:end),': ',num2str(length(sti)),' NosePokes (',num2str(round(10*sum(ste-sti))/10),'s)'])
    
%         if ~isempty([strfind(namePhase{i},'Solvant'),strfind(namePhase{i},'Odor')])
        if rem(i,2)==0
            MATTdispSelect=[MATTdispSelect;MATTdisp(i,:)];
            indexSelect=[indexSelect,i];
        end
    
    end
    % nmouse
    try
        indexSep=strfind(basename,'-');indexSep=indexSep(indexSep>strfind(basename,'Mouse-'));
        nmouse=str2num(basename(indexSep(1)+1:indexSep(2)-1));
    catch
        nmouse=input('Enter number of the mouse: ');
    end
    
    A=ones(length(parameters),1)*[1:length(NameTrackFiles)]; A=A';A=A(:);
    B=ones(length(NameTrackFiles),1)*[1:length(parameters)]; B=B(:);
    MATT=[ones(size(A))*nmouse,B,A,MATTdisp(:)];
    
    disp('saving analysis in MATTsave.mat')
    save MATTsave MATTdispSelect MATTdisp parameters indexSelect MATT
end
    

%% DISPLAY RESULTS
if plo
    figure('Color',[1 1 1],'Position',[scrsz(1) scrsz(2) scrsz(3)*4/5 scrsz(4)*2/3]), numF1=gcf;
    for pp=1:length(parameters)
        subplot(length(parameters),1,pp), bar(MATTdisp(:,pp));
        ylabel(parameters{pp}), title(basename),
        set(gca,'XTick',1:size(MATTdisp,1))
        set(gca,'XTickLabel',namePhase)
    end
    
    figure('Color',[1 1 1],'Position',[scrsz(1) scrsz(2) scrsz(3)/2 scrsz(4)]), numF2=gcf;
    for pp=1:length(parameters)
        subplot(length(parameters),1,pp), bar(MATTdispSelect(:,pp));
        ylabel(parameters{pp}), title(basename),
        set(gca,'XTick',1:size(MATTdispSelect,1))
        set(gca,'XTickLabel',namePhase(indexSelect))
    end
    
    
    % ---------------------------------------------------------------------
    % display Tracking
    figure('Color',[1 1 1],'Position',scrsz); numF3=gcf; colormap gray
    for i=1:length(NameTrackFiles)
        subplot(ceil(sqrt(length(NameTrackFiles))),ceil(length(NameTrackFiles)/sqrt(length(NameTrackFiles))),i)        
        imagesc(ref);
        hold on, plot(PosMatALL(PosMatALL(:,1)==i,3),PosMatALL(PosMatALL(:,1)==i,4))
        title(namePhase{i}); axis image; axis off
    end
    text(-100,300,['Tracking ',basename])
    
    try 
        subplot(ceil(sqrt(length(NameTrackFiles))),ceil(length(NameTrackFiles)/sqrt(length(NameTrackFiles))),length(NameTrackFiles)+1)
        imagesc(ref);
        circli = rsmak('circle',5*Ratio_IMAonREAL,[OdorInfo(1),OdorInfo(2)]);
        hold on, fnplt(circli,'Color','r'); axis image; axis off
        title('NosePoke Zone')
    end
    
    
    try FolderTosave=uigetdir('C:\Users\Karim\Desktop\Data-Electrophy\ProjetBO-Depression\Olfaction-dKO\FIGURES','Save figures in folder');
    catch, FolderTosave=uigetdir(res,'Save figures in folder');end
    if FolderTosave~=0
        try 
            saveFigure(numF1,[basename,'-ALLsessions'],FolderTosave);
        saveFigure(numF2,[basename,'-ODORSessions'],FolderTosave);
        saveFigure(numF3,['Tracking',basename],FolderTosave);
        disp(['Figures have been saved in ',FolderTosave]);
        catch
            disp('PROBLEM saving figures');keybord
        end
    end
end

%% END

disp(' '); disp('now run LaunchAnalyseNosePokeOdor');


