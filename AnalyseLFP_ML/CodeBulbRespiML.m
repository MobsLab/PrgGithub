%CodeBulbRespiML


%% INPUTS

%basename='wideband';
basename='10kHz';
OrderMultiChannel={'El_15','El_13','El_11','El_09','El_07','El_05','El_03','El_01','El_121'};
%OrderMultiChannel={'El_15','El_13','El_11','El_09','El_07','El_05','El_03','El_01','El_02','El_04','El_06','El_08','El_10','El_12','El_14','El_16'};
% Saving channels from -wideband recording in Data.mat

plotAllLFP=0;
scrsz = get(0,'ScreenSize');

%% INITIALIZATION


clear filenames RespiTSD LFP catEvent InfoLFP Calibration multCalib SynchroRespi RespiStart EndRespi Movtsd SpRespi SWSEpoch REMEpoch Frequency TidalVolume
disp(' ')
try 
    load('LFPData.mat','filenames')
    for i=1:length(filenames), disp(filenames{i});end
catch
    filenames=input('Enter basename of the files to analyze (e.g. {''file1'' ''file2''}): ');
    disp(['Info: using -',basename,' and -respiration as suffixes'])
    save LFPData filenames
end

%% save LFP
clear LFP1 LFP2 LFP3
disp(' ')
disp(['... Saving channels from -',basename,' recording in LFPData.mat'])

try 
    load('LFPData.mat','RespiTSD','LFP','catEvent');
    Range(RespiTSD); Range(LFP{1}); catEvent;
    disp('        LFPData.mat already exists, skipping this step');
catch
    
    try
        load('SynchroTemp.mat');SynchroLFP; EndWide; LFPStart;
        for ff=1:length(filenames), eval(['LFP',num2str(ff),';']);end
    catch
        
        LFP1=[]; save SynchroTemp LFP1
        for ff=1:length(filenames)
            disp(' ')
            disp([' * * * ',filenames{ff},' * * * '])
            try Swide=load([filenames{ff},'-',basename,'.mat']);catch, keyboard;end
            Swide=struct2cell(Swide);
            SynchroLFP{ff}=[];
            
            for i=1:length(Swide)
                if strfind(Swide{i}.title,'El_')
                    tempNum=find(strcmp(Swide{i}.title,OrderMultiChannel));
                    t=[1:Swide{i}.length]*Swide{i}.interval*1E4;
                    disp([Swide{i}.title,'   --> saving in SynchroTemp.mat - LFP',num2str(ff),...
                        '{',num2str(tempNum),'} (Fs=',num2str(floor(1/Swide{i}.interval)),'Hz)'])
                    eval(['LFP',num2str(ff),'{tempNum}=tsd(t,Swide{i}.values);'])
                    EndWide(ff)=max(t/1E4);
                    
                elseif strcmp(Swide{i}.title,'Di_D1_3') || strcmp(Swide{i}.title,'Di_D1_1')
                    disp([Swide{i}.title,'   --> saving in SynchroTemp.mat - SynchroLFP{',num2str(ff),'}'])
                    if isempty(SynchroLFP{ff})==0; keyboard;end
                    SynchroLFP{ff}=Swide{i}.times(1:2:end);
                    
                elseif (strcmp(Swide{i}.title,'Di_D1_2') || strcmp(Swide{i}.title,'Di_D1_0') ) && Swide{i}.length<=2
                    disp([Swide{i}.title,'   --> saving in SynchroTemp.mat - LFPStart(',num2str(ff),')'])
                    LFPStart(ff)=Swide{i}.times(1);
                else
                    disp([Swide{i}.title])
                end
            end
            
            eval(['LFP',num2str(ff),'=tsdArray(LFP',num2str(ff),');'])
            
            save('SynchroTemp','-append',['LFP',num2str(ff)])
        end
        save SynchroTemp SynchroLFP EndWide LFPStart -append
    end
end

%% define structure for each LFP channel

try
    load('InfoLFP.mat');InfoLFP.structure;
    disp('... InfoLFP already defined. Skipping this step')
    
catch
    disp('Creating InfoLFP.mat ...')
    disp('WARNING: Enter channels in the order of the EIB (dispite neuroscope)');
    InfoLFP=listLFP_to_InfoLFP_ML(pwd);
end
save LFPData InfoLFP -append

%% Calibration respi
try
    load('SynchroTemp.mat','Calibration');
    if exist('Calibration','var'), Range(Calibration);else, error;end
catch
    
    lis=dir;
    for i=3:length(dir)
        if isempty(strfind(lis(i).name,'alibration.mat'))==0
            disp(['Calibrating with ',lis(i).name])
            Swide=load(lis(i).name); Swide=struct2cell(Swide);
            for j=1:length(Swide)
                if strfind(Swide{j}.title,'untitled')
                    Calibration=tsd([1:Swide{j}.length]*Swide{j}.interval*1E4,Swide{j}.values);
                end
            end
        end
    end
    if exist('Calibration','var')==0
        disp('no calibration.mat')
        PathCalib=input('Enter path to get calibration :','s');
        load([PathCalib,'/SynchroTemp.mat'],'Calibration')
    end
    save LFPData Calibration -append
    save SynchroTemp Calibration -append
end

%% Respiration

disp(' ')
disp('... Saving channels from -respiration recording in LFPData.mat')

try 
    load('LFPData.mat','RespiTSD','LFP','catEvent');
    Range(RespiTSD); Range(LFP{1}); catEvent;
    disp('        respiration already difined in LFPData.mat, skipping this step');
catch
    
    try
        load('SynchroTemp.mat')
        SynchroTemp; SynchroRespi; RespiStart; EndRespi;
        for ff=1:length(filenames), eval(['RespiTemp',num2str(ff)]);end
    catch
        for ff=1:length(filenames)
            disp(' ')
            disp([' * * * ',filenames{ff},' * * * '])
            try Swide=load([filenames{ff},'-respiration.mat']);
            catch,  Swide=load([filenames{ff},'-Respiration.mat']);
            end
            Swide=struct2cell(Swide);
            
            for i=1:length(Swide)
                
                if strfind(Swide{i}.title,'untitled')
                    disp([Swide{i}.title,'   --> saving in SynchroTemp.mat - RespiTemp',num2str(ff)])
                    t=[1:Swide{i}.length]*Swide{i}.interval*1E4;
                    
                    eval(['RespiTemp',num2str(ff),'=tsd(t,Swide{i}.values);'])
                    EndRespi(ff)=max(t/1E4);
                    
                elseif strcmp(Swide{i}.title,'') && Swide{i}.length~=1
                    SynchroRespi{ff}=Swide{i}.times;
                    
                elseif strcmp(Swide{i}.title,'') && Swide{i}.length==1
                    RespiStart(ff)=Swide{i}.times;
                end
                
            end
            
            save('SynchroTemp','-append',['RespiTemp',num2str(ff)])
        end
        try, SynchroRespi; catch, SynchroRespi=[];end
        save SynchroTemp SynchroRespi RespiStart EndRespi -append
    end
end




%% Synchronize LFP and Respiration recordings + concatenation

try 
    load('LFPData.mat','RespiTSD','LFP','Movtsd');
    Range(RespiTSD); Range(LFP{1}); Range(Movtsd);
catch
    disp('... Synchronizing LFP, Respi and Movtsd')
    load('SynchroTemp.mat')
    for ff=1:length(filenames)
        if isempty(SynchroRespi{ff})==0 && isempty(SynchroLFP{ff})==0
            mm=min(length(SynchroRespi{ff}),length(SynchroLFP{ff}));
            advanceRespi(ff)=((SynchroRespi{ff}(mm)-SynchroLFP{ff}(mm))-(SynchroRespi{ff}(1)-SynchroLFP{ff}(1)))/(SynchroRespi{ff}(mm)-SynchroRespi{ff}(1));
            NewSynchroRespi{ff}=SynchroRespi{ff}*(1-advanceRespi(ff));
            removeStart{ff}=SynchroLFP{ff}(1:mm)-NewSynchroRespi{ff}(1:mm);
            NewSynchroRespi{ff}=NewSynchroRespi{ff}+mean(removeStart{ff});
        else
            advanceRespi(ff)=0;
            NewSynchroRespi{ff}=0;
            removeStart{ff}=0;
        end
    end
    
    save SynchroTemp advanceRespi -append
    
    
    for ff=1:length(filenames)
        
        % movement
        try
            load([filenames{ff},'.mat'],'Movtsd','Pos','PosMat');Movtsd;
            ok=input(['Length video is ',num2str(max(Range(Movtsd,'s'))/60),'s (y/n) ?  '],'s');
            if ok=='n',
                disp('Possible problem of video smapling:')
                ok=input(['Length video is ',num2str(max(Range(Movtsd,'s'))/120),'s (y/n) ?  '],'s');
                if ok=='y'
                    PosMat(:,1)=PosMat(:,1)/2; 
                    Pos(:,1)=Pos(:,1)/2;
                    Movtsd=tsd(Range(Movtsd)/2,Data(Movtsd));
                    save([filenames{ff},'.mat'],'-append','Movtsd','Pos','PosMat')
                    disp(['Position variables have been fixed in ',filenames{ff},'.mat'])
                else
                    disp('fix it by yourself!')
                end
            end
            
        catch
            disp('run ComputeTrackingAndImmobility')
            keyboard
        end
            
        newT=Range(Movtsd)*(1-advanceRespi(ff))+mean(removeStart{ff})*1E4;
        tempData=Data(Movtsd);
        NewMovtsd=tsd(newT(newT>0),tempData(newT>0));
        
        %LFP
        eval(['temp=LFP',num2str(ff),';'])
        
        %Respi
        eval(['tempR=RespiTemp',num2str(ff),';'])
        newT=Range(tempR)*(1-advanceRespi(ff))+mean(removeStart{ff})*1E4;
        tempData=Data(tempR);
        NewtempR=tsd(newT(newT>0),tempData(newT>0));
       
        
        % discard extra recording
        eval(['Le=intervalSet(min(Range(NewtempR)),min(max(Range(NewtempR)),max(Range(LFP',num2str(ff),'{1}))));'])
        
        if ff==1
            TempMov=Restrict(NewMovtsd,Le);
            for i=1:length(temp), LFP{i}=Restrict(temp{i},Le); end
            RespiTSD=Restrict(NewtempR,Le);
            catEvent(ff)=min(Range(RespiTSD,'s'));
        else
            % LFP
            for i=1:length(temp), 
                ttemp=LFP{i};
                LFP{i}=tsd([Range(ttemp);Range(Restrict(temp{i},Le))+max(Range(ttemp))],[Data(ttemp);Data(Restrict(temp{i},Le))]); 
            end
            ttemp=RespiTSD;
            RespiTSD=tsd([Range(ttemp);Range(Restrict(NewtempR,Le))+max(Range(ttemp))],[Data(ttemp);Data(Restrict(NewtempR,Le))]);
            catEvent(ff)=min(Range(Restrict(NewtempR,Le),'s')+max(Range(ttemp,'s')));
            
            ttemp=TempMov;
            TempMov=tsd([Range(ttemp);Range(Restrict(NewMovtsd,Le))+max(Range(ttemp))],[Data(ttemp);Data(Restrict(NewMovtsd,Le))]);
        end
        clear NewtempR NewMovtsd temp tempR ttemp
    end
    
    Movtsd=TempMov; clear TempMov 
    disp('... Saving Movtsd, LFP and RespiTSD in LFPData.mat')
    LFP=tsdArray(LFP);
    save LFPData RespiTSD LFP catEvent Movtsd -append
    
    PreEpoch=intervalSet(min(Range(RespiTSD)),max(Range(RespiTSD)));
    TrackingEpoch=intervalSet(min(Range(Movtsd)),max(Range(Movtsd)));

    save behavResources PreEpoch TrackingEpoch Movtsd
end

%% GetTimeOfDataRecordingML
list=dir; a=0;
for i=3:length(list)
    if length(list(i).name)>3 && strcmp(list(i).name(end-3:end),'.mcd') 
        a=a+1;
        ld=list(i).date;
        disp(['rec ',num2str(a),': ',ld])
        ind=strfind(ld,':');
        TimeEndRec(a,1:3)=[str2num(ld(ind(1)-2:ind(1)-1)),str2num(ld(ind(1)+1:ind(2)-1)),str2num(ld(ind(2)+1:end))];
    end
end

if a==0
    disp('No files.mcd found!')
else
    DiffTimeRec=sum([60*60*diff(TimeEndRec(:,1)),60*diff(TimeEndRec(:,2)),diff(TimeEndRec(:,3))],2);
    save TimeRec TimeEndRec DiffTimeRec
    save behavResources -append TimeEndRec DiffTimeRec
end



%% Determine TidalVolume and Frequency
disp(' ')
disp('... Determining TidalVolume and Frequency')
try 
    load('LFPData.mat','TidalVolume','Frequency');
    Range(TidalVolume); Range(Frequency);
    disp('         TidalVolume and Frequency already defined in LFPData.mat')
catch
    [TidalVolume,Frequency,Param,multCalib,NormRespiTSD,newRespiTSD]=PlethysmoSignalML(RespiTSD,Calibration,0,1, 0.06);
    save('LFPData.mat','-append','TidalVolume','Frequency','multCalib','NormRespiTSD','newRespiTSD')
end

try 
    load('SynchroTemp.mat')
    save SynchroTemp advanceRespi SynchroRespi RespiStart EndRespi SynchroLFP EndWide LFPStart multCalib Calibration Param
end


%% Display LFPs and respi

color={'b','r','k','g','c','m','y',[0.5 0.5 0.5],[0.5 0.1 0.1]};
if plotAllLFP
    try 
        i_temp=InfoLFP.channel(find(strcmp(InfoLFP.structure,'Bulb')));
        AdjustRespToLFP=mean(abs(Data(LFP{i_temp(1)})))/mean(abs(Data(RespiTSD)));
    catch
        i_temp=InfoLFP.channel(find(strcmp(InfoLFP.structure,'dHPC')));
        AdjustRespToLFP=mean(abs(Data(LFP{i_temp(1)})))/mean(abs(Data(RespiTSD)));
    end
    figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2])
    legendL={};a=1;b=1;
    try
        Ustruct=unique(InfoLFP.structure);
        for i=1:length(Ustruct)
            for j=InfoLFP.channel(find(strcmp(InfoLFP.structure,Ustruct(i))))
                if strcmp(InfoLFP.hemisphere(InfoLFP.channel==j),'Left')
                    hold on, plot(Range(LFP{j},'s'),Data(LFP{j})+a*0.0009,color{i}); a=a+1;
                    legendL=[legendL,{[Ustruct{i},'_L -Ch',num2str(j)]}];xlim([0,30])
                else
                    hold on, plot(Range(LFP{j},'s'),Data(LFP{j})-b*0.0009,'Color',color{i}); b=b+1;
                    legendL=[legendL,{[Ustruct{i},'_R -Ch',num2str(j)]}];xlim([0,30])
                end
            end
        end
    catch
        keyboard
    end
    hold on, plot(Range(RespiTSD,'s'),Data(RespiTSD)*AdjustRespToLFP,'Color',color{end}); xlim([0,30])
    legend([legendL,'Respiration (mL/s)'])
    title('LFP Right = below 0, else is LFP from left hemisphere')
end

%% save individual LFPs
saveLFP=LFP;
try
    eval(['lfp=load(''LFP',num2str(InfoLFP.channel(1)),'.mat'',''LFP'');']);
    Data(lfp);
catch
    disp('saving all LFPs in individual file.mat in LFPData folder:')
    AllLFP=load('LFPData.mat','LFP');
    for ch=1:length(InfoLFP.channel)
        disp(['      LFP',num2str(InfoLFP.channel(ch))])
        LFP=AllLFP.LFP{ch};
        eval(['save(''LFPData/LFP',num2str(InfoLFP.channel(ch)),'.mat'',''LFP'');'])
    end
end
LFP=saveLFP;

%% Sleep scoring
disp(' ')
try
    load('StateEpoch.mat');Start(SWSEpoch);Start(REMEpoch);
    disp('... SWSEpoch and REMEpoch already defined. Skipping this step')
catch
    disp('        * * * Sleep scoring * * *')
    % --- loading LFP HPC ---
    try
        Channel_SleepScor;
    catch
        if ~isempty(InfoLFP.channel(strcmp(InfoLFP.structure,'dHPC')))
            disp(['list channel dHPC : ',num2str(InfoLFP.channel(strcmp(InfoLFP.structure,'dHPC')))])
            disp(['        profondeur: ',num2str(InfoLFP.depth(strcmp(InfoLFP.structure,'dHPC')))])
        else
            disp('No dHPC channel, using PaCx! for sleep scoring')
            disp(['list channel PaCx : ',num2str(InfoLFP.channel(strcmp(InfoLFP.structure,'PaCx')))])
            disp(['        profondeur: ',num2str(InfoLFP.depth(strcmp(InfoLFP.structure,'PaCx')))])
        end
        Channel_SleepScor=input('-> Enter num of channel: ');
        save StateEpoch Channel_SleepScor
    end
    try
        disp('... Loading LFP...')
        lfp=LFP{Channel_SleepScor};
    catch
        keyboard
    end
    
    % --- loading position and movement ---
    clear Movtsd Mmov
    try
        load('StateEpoch.mat','Mmov'); Range(Mmov);
    catch
        pasPos=15;
        load('LFPData.mat','Movtsd');
        Mmov=Movtsd;
%         Mmov=Data(Movtsd); rgM=Range(Movtsd);
%         Mmov=Mmov(1:pasPos:end); rgM=rgM(1:pasPos:end);
%         Mmov=tsd(rgM,Mmov);
        save StateEpoch Mmov -append
    end
    
    % --- Creating StateEpoch ---
    
    params.Fs=1000;
    params.trialave=0; params.err=[1 0.0500];
    params.pad=2; params.fpass=[0 20];
    movingwin=[3 0.2]; params.tapers=[3 5];
    
    disp(' ');
    try
        load('StateEpoch.mat','Spectro')
        Sp=Spectro{1};
        t=Spectro{2};
        f=Spectro{3};
        disp('... Using already existing parameters for spectrogramm.');
    catch
        disp('... Calculating parameters for spectrogramm.');
        [Sp,t,f]=mtspecgramc(Data(lfp)*1E6,movingwin,params);
        Spectro={Sp,t,f};
        save StateEpoch Spectro -append;
    end
    
    % Display Data
    
    figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]),Ggf=gcf;
    subplot(2,1,1),imagesc(t,f,10*log10(Sp)'), axis xy, caxis([0 45]);
    title('Spectrogramm');
    
    
    % find theta epochs
    
    disp(' ');
    try
        ThetaRatioTSD; ThetaEpoch;
        disp('... Theta Epochs already exists, skipping this step.');
    catch
        pasTheta=100;
        disp('... Creating Theta Epochs ');
                
        FilTheta=FilterLFP(tsd(Range(lfp),Data(lfp)*1E6),[5 8],1024);
        FilDelta=FilterLFP(tsd(Range(lfp),Data(lfp)*1E6),[3 5],1024);
        
        HilTheta=hilbert(Data(FilTheta));
        HilDelta=hilbert(Data(FilDelta));
        
        H=abs(HilDelta);
        %H(H<100)=100;
        
        ThetaRatio=abs(HilTheta)./H;
        rgThetaRatio=Range(FilTheta,'s');
        
        ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),30);
        rgThetaRatio=rgThetaRatio(1:pasTheta:end);
        ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
        
        try
            ThetaI;ThetaThresh;
        catch
            ThetaI=[10 15];
            RequiredStdFactor=1.5;
            ThetaThresh=mean(Data(ThetaRatioTSD))+RequiredStdFactor*std(Data(ThetaRatioTSD));
        end
        
        Ok='n';
        while Ok~='y'
            ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above');
            ThetaEpoch=mergeCloseIntervals(ThetaEpoch,ThetaI(1)*1E4);
            ThetaEpoch=dropShortIntervals(ThetaEpoch,ThetaI(2)*1E4);
            figure(Ggf),
            hold off, subplot(2,1,2), plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch))-5,'r.');
            hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD)-5,'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]);
            hold on, line([catEvent;catEvent],[0 max(Data(ThetaRatioTSD))],'color','k','linewidth',2);
            
            title('Theta/Delta ratio (black), chosen thetaEpoch (red)  and  Movement (blue)');
            if ThetaThresh==mean(Data(ThetaRatioTSD))+RequiredStdFactor*std(Data(ThetaRatioTSD)), title(['Theta/Delta ratio (black) AUTOMATIC thetaEpoch (red, mean+',num2str(RequiredStdFactor),'std)  and  Movement (blue)']); end
            
            Ok=input('--- Are you satisfied with ThetaEpoch (y/n, m for manual) ? ','s');
            if Ok=='m'
                disp('Click on starts and ends of theta periods then press enter')
                T=ginput;
                try
                    ThetaEpoch=intervalSet(T(1:2:end,1)*1E4,T(2:2:end,1)*1E4);
                    hold off, subplot(2,1,2), plot(Range(Restrict(ThetaRatioTSD,ThetaEpoch),'s'),Data(Restrict(ThetaRatioTSD,ThetaEpoch))-5,'r.');
                    hold on, plot(Range(ThetaRatioTSD,'s'),Data(ThetaRatioTSD)-5,'k','linewidth',2);  xlim([0,max(Range(ThetaRatioTSD,'s'))]);
                    hold on, line([catEvent;catEvent],[0 max(Data(ThetaRatioTSD))],'color','k','linewidth',2);
                    Ok=input('--- Are you satisfied with ThetaEpoch (y/n) ? ','s');
                end
            end
            
            if Ok~='y'
                ThetaThresh=input(['Give new theta threshold (AUTOMATIC=',num2str(mean(Data(ThetaRatioTSD))+RequiredStdFactor*std(Data(ThetaRatioTSD))),') :']);
                %ThetaI=input('Give new [mergeCloseIntervals dropShortIntervals] for theta (Default=[10 15]) :');
            end
        end
        
        save('StateEpoch','ThetaEpoch', 'ThetaRatioTSD','ThetaI','ThetaThresh','pasTheta','-append');
    end
    close
    
    disp(' ')
    disp('Using standard sleepscoring script from now...')
    disp(' !!!!! at ''''missing behavResources.mat'''' enter return !!!')
    sleepscoringML
end

%% Spectre Respi
tempData=Data(Frequency);
[Sp,f]=hist(tempData(tempData<20),[0.01:0.02:20]);
tot=sum(Sp);
Sp=Sp*100/tot;
if 1
    figure('Color',[1,1,1]), plot(f,SmoothDec(Sp,1.2))
    xlim([0 20]); xlabel('Frequencies (Hz)'); ylabel('Distribution')
    title('Respiration Frequency spectrum')
end


%% plot LFP depending on vigilance states
if plotAllLFP
i=find(strcmp(InfoLFP.structure,'Bulb')); 
disp(['num channels Bulb: ',num2str(InfoLFP.channel(i))]); 
disp(['             prof: ',num2str(InfoLFP.depth(i))])
j=input('Enter channel to analyze: ');

NameEpochs={'SWSEpoch','REMEpoch','MovEpoch'};
figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]);Ftac=gcf;
load('LFPData.mat','LFP')
for nn=1:length(NameEpochs)
    eval(['epoch=',NameEpochs{nn},';'])
    st=Start(epoch,'s'); lengthSamp=Stop(epoch,'s')-Start(epoch,'s');st=st(lengthSamp>10);
    for kk=1:6
        subplot(length(NameEpochs),6,6*(nn-1)+kk), plot(Range(Restrict(LFP{j},epoch),'s'),Data(Restrict(LFP{j},epoch)),color{i});
        try hold on, plot(Range(Restrict(RespiTSD,epoch),'s'),Data(Restrict(RespiTSD,epoch))*AdjustAmpRespToLFP+1.5/1E3,color{end}); xlim([st(kk)+5,st(kk)+10]);end
        ylim([-2 3]/1E3)
        if kk==1, title([filenames{1}(strfind(filenames{1},'Mouse'):strfind(filenames{1},'Mouse')+16)]); ylabel(NameEpochs{nn});end
    end
    
end
legend({['LFP',InfoLFP.structure{i}]},'Respiration')

end
%% Save Figure
if plotAllLFP
    nameFolderSave=input('     * Enter Folder where figures should be saved in DataPlethysmo: ','s');
    if exist(['/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/',nameFolderSave],'dir')==0, mkdir(['/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/'],nameFolderSave);end
    
    saveFigure(Ftac,['Trace-',filenames{1}(strfind(filenames{1},'Mouse'):strfind(filenames{1},'Mouse')+16)],['/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/',nameFolderSave])
end

%% Run CodeBulbAnalyRespiML

disp('run CodeBulbAnalyRespiML ?')

%% Run FindRespiAndMovEpochs
disp('run FindRespiAndMovEpochs ?')



%%


% movingwin=[4,1];
% params.tapers=[3 5];
% params.Fs=1000;
% params.fpass=[0 70];
% [C,phi,S12,S1,S2,t,f]=cohgramc(ch6,respi(1:length(ch6)),movingwin,params);
% [Cb,phib,S12b,S1b,S2b,tb,fb]=cohgramc(ch6,ch7,movingwin,params);
% [Cc,phic,S12c,S1c,S2c,tc,fc]=cohgramc(ch6,ch14,movingwin,params);
% [Cd,phid,S12d,S1d,S2d,td,fd]=cohgramc(ch6,ch12,movingwin,params);
% 
% [Ce,phie,S12e,S1e,S2e,te,fe]=cohgramc(respi(1:length(ch6)),ch7,movingwin,params);
% [Cf,phif,S12f,S1f,S2f,tf,ff]=cohgramc(respi(1:length(ch6)),ch14,movingwin,params);
% [Cg,phig,S12g,S1g,S2g,tg,fg]=cohgramc(respi(1:length(ch6)),ch12,movingwin,params);
% 
% 
% [Ch,phih,S12h,S1h,S2h,th,fh]=cohgramc(ch6,ch11,movingwin,params);
% [Ci,phii,S12i,S1i,S2i,ti,fi]=cohgramc(respi(1:length(ch6)),ch11,movingwin,params);
% 
% % 
% % figure('color',[1 1 1]),
% % subplot(4,1,1),imagesc(t,f,C'), axis xy
% % subplot(4,1,2),imagesc(t,f,Cb'), axis xy
% % subplot(4,1,3),imagesc(t,f,Cc'), axis xy
% % subplot(4,1,4),imagesc(t,f,Cd'), axis xy
% % 
% 
% 
% figure('color',[1 1 1]),
% subplot(5,2,1),imagesc(t,f,SmoothDec(C',[2 2])), axis xy
% subplot(5,2,3),imagesc(t,f,SmoothDec(Cb',[2 2])), axis xy
% subplot(5,2,4),imagesc(t,f,SmoothDec(Ce',[2 2])), axis xy
% subplot(5,2,5),imagesc(t,f,SmoothDec(Cc',[2 2])), axis xy
% subplot(5,2,6),imagesc(t,f,SmoothDec(Cf',[2 2])), axis xy
% subplot(5,2,7),imagesc(t,f,SmoothDec(Cd',[2 2])), axis xy
% subplot(5,2,8),imagesc(t,f,SmoothDec(Cg',[2 2])), axis xy
% subplot(5,2,9),imagesc(t,f,SmoothDec(Ch',[2 2])), axis xy
% subplot(5,2,10),imagesc(t,f,SmoothDec(Ci',[2 2])), axis xy
% 
% 
% figure('Color',[1 1 1]), plot(tpsRespi,respi*200,'k', 'linewidth',2)
% hold on, plot(tpsMov,Data(Movtsd)+30,'b','linewidth',1)
% 
% plot(tpsCh,ch3*1E4-60,'k')
% plot(tpsCh,ch14*1E4-20,'r')
% plot(tpsCh,ch1*1E4-40,'b')
% plot(tpsCh,ch15*1E4+20,'r')
% 
% 
