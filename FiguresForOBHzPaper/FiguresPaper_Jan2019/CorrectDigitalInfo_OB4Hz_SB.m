clear all
Dir = PathForExperimentFEAR('Fear-electrophy');


for mm=55:100
    
    cd(Dir.path{mm})
    
    disp(Dir.path{mm})
    
    
    clear ExpeInfo
    h = GUI_StepOne_ExperimentInfo;
    waitfor(h)
    
    
    load('ExpeInfo.mat')
    load('LFPData/InfoLFP.mat')
    ExpeInfo.InfoLFP = InfoLFP;
    
    cd('ChannelsToAnalyse/')
    FileInfo=dir('*.mat');
    for f=1:size(FileInfo,1)
        load(FileInfo(f).name)
        eval(['ExpeInfo.ChannelsToAnalyse.',FileInfo(f).name(1:end-4),'=channel;'])
    end
    cd ..
    
    %% Get the digital info
    if 1
        SetCurrentSession
        disp('Get INTAN DigitalInput')
        chanDig=input('give dig chan');
        
        load('LFPData/InfoLFP.mat')
        load(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
        Tmax=max(Range(LFP,'s'));
        LongFile=Tmax>3600;
        
        LFP_temp=GetWideBandData(chanDig);
        LFP_temp=LFP_temp(1:16:end,:);
        DigIN=LFP_temp(:,2);
        TimeIN=LFP_temp(:,1);
        
        
        DigOUT=[];
        for k=0:15
            a(k+1)=2^k-0.1;
        end
        % added this so no mistakes can be made in giving number of digital
        % channels
        MaxVal = max(DigIN);
        ChannelNumber = max(find(a<MaxVal));
        
        for k=ChannelNumber:-1:1
            DigOUT(k,:)=double(DigIN>a(k));
            DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
            DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
            save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
        end
        clear LFP_temp LFP DigOUT DigIN DigTSD TimeIn InfoLFP
        
        %% give DigID the right names
        ExpeInfo.DigID{2}
        
        for ch = 1:ChannelNumber
            subplot(ChannelNumber,1,ch)
            load(['LFPData/DigInfo',num2str(ch),'.mat'],'DigTSD')
            plot(Range(DigTSD,'s'),Data(DigTSD))
        end
        keyboard
    else
        ExpeInfo.DigID= cell(1);
        
    end
    
    ExpeInfo.group = 'CTRL';
    if ismember(ExpeInfo.nmouse,[230,249,250,291,297,298])
        ExpeInfo.group = 'OBX';
    end
    
    ExpeInfo
    keyboard
    save('ExpeInfo.mat','ExpeInfo')
    
end


%
% DigInputName = ...
%     {'ONOFF',... % when intan goes on and off
%     'STIM',... % for PAG/MFB stim
%     'CS+WN','CS+Tone','CS-WN','CS-Tone',... % for fear conditionning
%     'DeltaTone',... % for the delta tone project
%     'CAMERASYNC',...
%     'Laser',...
%     'Shock',... % for an electric shock
%     'NaN'
%     };