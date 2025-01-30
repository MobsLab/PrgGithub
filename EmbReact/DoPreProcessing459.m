%makeDataBulbe
clear all

%% Initiation
warning off
res=pwd;
try, setCu; catch, setCu=0;end

load('makedataBulbeInputs')

spk=strcmp(answer{1},'yes');
if spk==1
    answer2 = inputdlg({'Do unit ID analysis?'},'WFInfo',1,{'yes'});
    spkinfo=strcmp(answer2{1},'yes');
end
dotrack=strcmp(answer{2},'yes');
dofreez=strcmp(answer{3},'yes');
doaccelero=strcmp(answer{4},'yes');
dodigitalin=strcmp(answer{5},'yes');redodigitalin=strcmp(answer{5},'redo');
FreqVideo=str2double(answer{6});
eval(['InjectionName=',answer{7},';'])

save makedataBulbeInputs answer

clear S LFP TT cellnames lfpnames
                SetCurrentSession(ls('*.xml'))
                SetCurrentSession('same')
                setCu=1;


%% ------------------------------------------------------------------------
%------------------------- LFP --------------------------------------------
%--------------------------------------------------------------------------
if 1
    disp(' '); disp('LFP Data')
    
    try clear reverseData;load([res,'/LFPData/ErrorREVERSE.mat'],'reverseData'); disp('!!! Reversing LFP signal !');end
    
    try
        load([res,'/LFPData/InfoLFP.mat'],'InfoLFP');
        load([res,'/LFPData/LFP',num2str(InfoLFP.channel(1))],'LFP');
        FragmentLFP='n';
    catch
        
        try
            load LFPData
            Range(LFP{1});
            FragmentLFP=input('LFPData.mat exists, do you want to fragment LFPData.mat in folder LFPData (y/n) ? ','s');
        catch
            FragmentLFP='y';
        end
    end
    
    if FragmentLFP=='y';
        try
            % infoLFP for each channel
            disp(' ');
            disp('...Creating InfoLFP.mat')
            try
                InfoLFP=listLFP_to_InfoLFP_ML(res);
            catch
                disp('retry listLFP_to_InfoLFP_ML');keyboard;
            end
            
            % LFPs
            disp(' ');
            disp('...Creating LFPData.mat')
            
            if setCu==0
                SetCurrentSession(ls('*.xml'))
                SetCurrentSession('same')
                setCu=1;
            end
            
            for i=1:length(InfoLFP.channel)
                LFP_temp=GetLFP(InfoLFP.channel(i));
                disp(['loading and saving LFP',num2str(InfoLFP.channel(i)),' in LFPData...']);
                LFP=tsd(LFP_temp(:,1)*1E4,LFP_temp(:,2));
                if exist('reverseData','var'), LFP=tsd(LFP_temp(:,1)*1E4,-LFP_temp(:,2));end
                save([res,'/LFPData/LFP',num2str(InfoLFP.channel(i))],'LFP');
                clear LFP LFP_temp
            end
            disp('Done')
        catch
            disp('problem for lfp')
            keyboard
        end
    else
        disp('Done')
    end
end





%% ------------------------------------------------------------------------
%------------- Get Accelerometer info from INTAN data ---------------------
%--------------------------------------------------------------------------

if 1
    disp(' ');
    disp('Get INTAN Accelerometer')
    try
        load('behavResources.mat','MovAcctsd')
        Range(MovAcctsd); disp('Done')
    catch
        load('LFPData/InfoLFP.mat')
        disp(' '); disp('Get Accelerometer info from INTAN data')
        cha=InfoLFP.channel(strcmp(InfoLFP.structure,'Accelero'));
        if isempty(cha)
            disp('No Accelero found in InfoLFP.mat')
            disp('Get accelero LFP.mat')
            
            [listfile,pathffile]=uigetfile('*.*','Get accelero LFP.mat','MultiSelect','on');
            if listfile==0
                disp('skip')
                doaccelero=0;
            else
                clear X Y Z
                disp('... Loading LFP.mat (wait!)')
                X=load([pathffile,listfile{1}],'LFP');
                Y=load([pathffile,listfile{2}],'LFP');
                Z=load([pathffile,listfile{3}],'LFP');
            end
            
        else
            clear X Y Z
            disp('... Loading LFP.mat (wait!)')
            X=load(['LFPData/LFP',num2str(cha(1)),'.mat'],'LFP');
            Y=load(['LFPData/LFP',num2str(cha(2)),'.mat'],'LFP');
            Z=load(['LFPData/LFP',num2str(cha(3)),'.mat'],'LFP');
        end
        
        if 1
            disp('... Creating movement Vector')
            MX=Data(X.LFP);
            MY=Data(Y.LFP);
            MZ=Data(Z.LFP);
            Rg=Range(X.LFP);
            Acc=MX.*MX+MY.*MY+MZ.*MZ;
            %Acc=sqrt(MX.*MX+MY.*MY+MZ.*MZ);
            disp('... DownSampling at 50Hz');
            MovAcctsd=tsd(Rg(1:25:end),double(abs([0;diff(Acc(1:25:end))])));
            
            figure('Color',[1 1 1]), plot(Range(MovAcctsd,'s'),abs(Data(MovAcctsd)))
            title('MovAcctsd from INTAN Accelerometer'); xlim([0 max(Range(MovAcctsd,'s'))]);
            if dofreez
                Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
                YL=ylim; hold on, plot(Range(Movtsd,'s'),rescale(Data(Movtsd),YL(1),YL(2)),'r');
                legend({'MovAcctsd','Movtsd'})
                ButtonName=questdlg('Use MovAcctsd for sleepscoringML ?','MovAcctsd or Movtsd','MovAcctsd','Movtsd','MovAcctsd');
                switch ButtonName
                    case 'MovAcctsd'
                        useMovAcctsd=1;
                    case 'Movtsd'
                        useMovAcctsd=0;
                end
            else
                legend('MovAcctsd')
                useMovAcctsd=1;
            end
            xlabel('Time (s)'); ylabel('abs(diff(X^2+Y^2+Z^2))');
            
            try
                save('behavResources','MovAcctsd','useMovAcctsd','-append')
            catch
                save('behavResources','MovAcctsd','useMovAcctsd')
            end
            disp('Done')
        end
    end
end

% %% ------------------------------------------------------------------------
% %---------- Get Digital Input from INTAN - add to LFP file ----------
% %--------------------------------------------------------------------------

if 1
    if setCu==0
        SetCurrentSession
        SetCurrentSession('same')
        setCu=1;
    end
    
    %% Alternative
    chanDig=35;
    LongFile=1;
    if LongFile==0
        LFP_temp=GetWideBandData(chanDig);
        LFP_temp=LFP_temp(1:16:end,:);
        DigIN=LFP_temp(:,2);
        TimeIN=temp(:,1);
    else
        disp('progressive loading')
        load('LFPData/InfoLFP.mat');
        load(['LFPData/LFP',num2str(InfoLFP.channel(1)),'.mat']);
        RecordingLength=max(Range(LFP,'s'));
        DigIN=[];TimeIN=[];
        
        for tt=1:ceil(RecordingLength/1000)
            disp(num2str(tt/ceil(RecordingLength/1000)))
            LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1000*tt,RecordingLength)]) ;
            LFP_temp=LFP_temp(1:16:end,:);
            DigIN=[DigIN;LFP_temp(:,2)];
            TimeIN=[TimeIN;LFP_temp(:,1)];
        end
    end
    
    DigOUT=[];
    for k=0:15
        a(k+1)=2^k-0.1;
    end
    
    for k=4:-1:1
        DigOUT(k,:)=double(DigIN>a(k));
        DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
        DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
        save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD','-v7.3')
    end
    
end
