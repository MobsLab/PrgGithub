disp('Get INTAN DigitalInput')
chanDig=eval(answerdigin{1});
clear a
try
    load('LFPData/InfoLFP.mat')
    load(['LFPData/LFP' num2str(InfoLFP.channel(1)) '.mat'])
    Tmax=max(Range(LFP,'s'));
    LongFile=Tmax>3600;
    
    if LongFile==0 % short file --> all in one
        LFP_temp=GetWideBandData(chanDig);
        LFP_temp=LFP_temp(1:16:end,:);
        DigIN=LFP_temp(:,2);
        TimeIN=LFP_temp(:,1);
    else % long file --> load progressively
        disp('progressive loading')
        DigIN=[];TimeIN=[];

        for tt=1:ceil(Tmax/1000)
            disp(num2str(tt/ceil(Tmax/1000)))
            LFP_temp=GetWideBandData(chanDig,'intervals',[1000*(tt-1) min(1000*tt,Tmax)]) ;
            LFP_temp=LFP_temp(1:16:end,:);
            DigIN=[DigIN;LFP_temp(:,2)];
            TimeIN=[TimeIN;LFP_temp(:,1)];
        end
    end
    
    
    DigOUT=[];
    for k=0:15
        a(k+1)=2^k-0.1;
    end
    
    for k=eval(answerdigin{2}):-1:1
        DigOUT(k,:)=double(DigIN>a(k));
        DigIN(DigIN>a(k))=   DigIN(DigIN>a(k))-a(k)+0.1;
        DigTSD=tsd(TimeIN*1e4,DigOUT(k,:)');
    end
        save(['LFPData/DigInfo',num2str(k),'.mat'],'DigTSD')
    end
catch
        disp('problem for digin')
end

clear LFP_temp LFP DigOUT DigIN DigTSD TimeIn InfoLFP