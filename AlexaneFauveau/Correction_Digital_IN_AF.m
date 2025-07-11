
clear all

% change that for it to be the name of xml
FileName='M1597_20240529_Eyelid';

SetCurrentSession(FileName)

load('ExpeInfo.mat')

spk = ExpeInfo.PreProcessingInfo.DoSpikes;
doaccelero = ExpeInfo.PreProcessingInfo.NumAccelero>0;
dodigitalin = ExpeInfo.PreProcessingInfo.NumDigChan>0;
doanalogin = ExpeInfo.PreProcessingInfo.NumAnalog>0;
answerdigin{1} = num2str(find(~cellfun(@isempty,strfind(ExpeInfo.InfoLFP.structure,'Digin')))-1);
answerdigin{2} = 9;


disp('Get INTAN DigitalInput')
chanDig=eval(answerdigin{1});

try
    load('LFPData/InfoLFP.mat')
    load(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
    Tmax=max(Range(LFP,'s'));
    LongFile=Tmax>3600;
    
    if LongFile==0 % short file --> all in one
        LFP_temp=GetWideBandData(chanDig);
        LFP_temp=LFP_temp(1:16:end,:);  % no subsampling for very short stims as VHC, add by BM on 04/04/2023
        DigIN=LFP_temp(:,2);
        TimeIN=LFP_temp(:,1);
    else % long file --> load progressively
        disp('progressive loading')
        DigIN=[];TimeIN=[];
        
        for tt=1:ceil(Tmax/1000)
            disp(num2str(tt/ceil(Tmax/1000)))
            % we load 1001 seconds of data
            LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1001*tt,Tmax)]);
            % just keep 1000 seconds of data - there are sometimes problems
            % at the end
            LastToKeep =  find(LFP_temp(:,1)>min(1000*tt,Tmax),1,'first')-1;
            LFP_temp(LastToKeep:end,:)=[];
            LFP_temp=LFP_temp(1:16:end,:);
            DigIN=[DigIN;LFP_temp(:,2)];
            TimeIN=[TimeIN;LFP_temp(:,1)];
        end
    end
    
    
    DigOUT=[];
    try answerdigin{2}, catch answerdigin{2} = [];end
    if ~isempty(answerdigin{2}) % If you select the number of channels manually, do the following
        ChannelNumber = (answerdigin{2});
        
        for k=0:ChannelNumber
            a(k+1)=2^k-0.1;
        end
        
        for k=ChannelNumber:-1:1
            DigOUT(k,:)=double(DigIN>a(k));
            DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
            DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
            save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
        end
        
    else   % If you have no idea how many channels you had
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
        
    end
    
catch
    disp('problem for digin')
    
end


load('ExpeInfo.mat')
ExpeInfo.DigID{1}='ONOFF';
ExpeInfo.DigID{2}='NaN';
ExpeInfo.DigID{3}='STIM';
ExpeInfo.DigID{4}='NaN';
ExpeInfo.DigID{5}='NaN';
ExpeInfo.DigID{6}='NaN';
ExpeInfo.DigID{7}='NaN';
ExpeInfo.DigID{8}='NaN';
ExpeInfo.DigID{9}='PIEZO';
ExpeInfo.NumDigInput= 9;
save('ExpeInfo.mat','ExpeInfo')


MakeData_TTLInfo


Start(TTLInfo.Sync)
size(Start(TTLInfo.StimEpoch))
size(Start(TTLInfo.Sync))




figure
for i=1:ChannelNumber
    
    subplot(4,4,i)
    load(['LFPData/DigInfo' num2str(i) '.mat'])
    plot(Data(DigTSD))
end


figure
for i=1:9
    
    subplot(4,4,i)
    load(['LFPData/DigInfo' num2str(i) '.mat'])
    plot(Data(DigTSD))
end






