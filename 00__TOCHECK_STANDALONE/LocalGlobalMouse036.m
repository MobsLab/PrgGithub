% LocalGlobalMouse036

try
    cd('/Volumes/HD-EG5/DataMMN/Mouse036')
catch
    cd('/media/HD-EG5/DataMMN/Mouse036')
end


LFPnames{1}='Prefrontal Cortex, superfical layer';
LFPnames{2}='Prefrontal Cortex, superfical layer';
LFPnames{3}='Prefrontal Cortex, superfical layer';
LFPnames{4}='Prefrontal Cortex, superfical layer';

LFPnames{5}='Parietal Cortex, EEG';
LFPnames{6}='Parietal Cortex, ECog';
LFPnames{7}='Parietal Cortex, deep layer';
LFPnames{8}='Parietal Cortex, deep layer';
LFPnames{9}='Parietal Cortex, deep layer';

LFPnames{10}='Auditory Cortex, EEG';
LFPnames{11}='Auditory Cortex, ECog';
LFPnames{12}='Auditory Cortex, deep layer';
LFPnames{13}='Auditory Cortex, deep layer';
LFPnames{14}='Auditory Cortex, superficial layer';
LFPnames{15}='Auditory Cortex, superficial layer';

try


load ResMouse036
ResA1;


catch

    clear
    try
cd('/Volumes/HD-EG5/DataMMN/Mouse036/22052012/MMN-Mouse-36-22052012')
    catch
        cd('/media/HD-EG5/DataMMN/Mouse036/22052012/MMN-Mouse-36-22052012')
    end

CreateSTDMMN

clear
try
cd('/Volumes/HD-EG5/DataMMN/Mouse036/23052012/MMN-Mouse-36-23052012')
catch
cd('/media/HD-EG5/DataMMN/Mouse036/23052012/MMN-Mouse-36-23052012')
end
CreateSTDMMN

clear
try
cd('/Volumes/HD-EG5/DataMMN/Mouse036/04062012/MMN-Mouse-36-04062012')
catch
    cd('/media/HD-EG5/DataMMN/Mouse036/04062012/MMN-Mouse-36-04062012')
end

CreateSTDMMN
clear



LFPnames{1}='Prefrontal Cortex, superfical layer';
LFPnames{2}='Prefrontal Cortex, superfical layer';
LFPnames{3}='Prefrontal Cortex, superfical layer';
LFPnames{4}='Prefrontal Cortex, superfical layer';

LFPnames{5}='Parietal Cortex, EEG';
LFPnames{6}='Parietal Cortex, ECog';
LFPnames{7}='Parietal Cortex, deep layer';
LFPnames{8}='Parietal Cortex, deep layer';
LFPnames{9}='Parietal Cortex, deep layer';

LFPnames{10}='Auditory Cortex, EEG';
LFPnames{11}='Auditory Cortex, ECog';
LFPnames{12}='Auditory Cortex, deep layer';
LFPnames{13}='Auditory Cortex, deep layer';
LFPnames{14}='Auditory Cortex, superficial layer';
LFPnames{15}='Auditory Cortex, superficial layer';



cd('/Volumes/HD-EG5/DataMMN/Mouse036/22052012/MMN-Mouse-36-22052012')

load LFPData
le=length(LFP);

for i=1:le
eval(['ResA',num2str(i),'=plotSingleLocalGlobalLight(LFP,',num2str(i),', 2000, 1);']), close

try
eval(['save -Append ResMouse0362205 ResA',num2str(i)])
catch
eval(['save ResMouse0362205 ResA',num2str(i)])
end

end


cd('/Volumes/HD-EG5/DataMMN/Mouse036/23052012/MMN-Mouse-36-23052012')

load LFPData
for i=1:le
eval(['ResB',num2str(i),'=plotSingleLocalGlobalLight(LFP,',num2str(i),', 2000, 1);']), close
try
eval(['save -Append ResMouse0362305 ResB',num2str(i)])
catch
eval(['save ResMouse0362205 ResB',num2str(i)])
end
end

cd('/Volumes/HD-EG5/DataMMN/Mouse036/04062012/MMN-Mouse-36-04062012')

load LFPData
for i=1:le
eval(['ResC',num2str(i),'=plotSingleLocalGlobalLight(LFP,',num2str(i),', 2000, 1);']), close
try
eval(['save -Append ResMouse0362205 ResC',num2str(i)])
catch
eval(['save ResMouse0360406 ResC',num2str(i)])
end
end


cd('/Volumes/HD-EG5/DataMMN/Mouse036')

clear LFP
clear lfpnames
clear listLFP
clear i
save ResMouse036



end




for i=1:le
    
eval(['ResA=ResA',num2str(i),';'])
eval(['ResB=ResB',num2str(i),';'])
eval(['ResC=ResC',num2str(i),';'])

n=1;
try
    RLocalStd(i,:)=(ResA{n}*ResA{n+3}+ResB{n}*ResB{n+3}+ResC{n}*ResC{n+3})/(ResA{n+3}+ResB{n+3}+ResC{n+3});
end
try
    RLocalDev(i,:)=(ResA{n+4}*ResA{n+7}+ResB{n+4}*ResB{n+7}+ResC{n+4}*ResC{n+7})/(ResA{n+7}+ResB{n+7}+ResC{n+7});
end
n=9;
try
    RStd(i,:)=(ResA{n}*ResA{n+3}+ResB{n}*ResB{n+3}+ResC{n}*ResC{n+3})/(ResA{n+3}+ResB{n+3}+ResC{n+3});
end
try
    RDev(i,:)=(ResA{n+4}*ResA{n+7}+ResB{n+4}*ResB{n+7}+ResC{n+4}*ResC{n+7})/(ResA{n+7}+ResB{n+7}+ResC{n+7});
end

n=17;
try
    RGlobalStd(i,:)=(ResA{n}*ResA{n+3}+ResB{n}*ResB{n+3}+ResC{n}*ResC{n+3})/(ResA{n+3}+ResB{n+3}+ResC{n+3});
end
try
    RGlobalDev(i,:)=(ResA{n+4}*ResA{n+7}+ResB{n+4}*ResB{n+7}+ResC{n+4}*ResC{n+7})/(ResA{n+7}+ResB{n+7}+ResC{n+7});
end
end


smo=6;
tps=ResA1{3};

for i=1:le

%         figure('color',[1 1 1]), 
%         try
%             plot(tps,SmoothDec(RLocalStd(i,:),smo),'k','linewidth',1)
%         end
%         try
%             hold on, plot(tps,SmoothDec(RLocalDev(i,:),smo),'r','linewidth',1)
%         end
%         
%         try
%         plot(tps,SmoothDec(RStd(i,:),smo),'b','linewidth',1)
%         end
%         try
%             hold on, plot(tps,SmoothDec(RGlobalDev(i,:),smo),'g','linewidth',1)
%         end
%         yl=ylim;
%         line([0 0],yl,'color','k')
%         title(['Local Global, ',LFPnames(i)])
%         xlim([-600 700])
        
        
        figure('color',[1 1 1]),
        subplot(2,1,1)
        try
            plot(tps,SmoothDec(RLocalStd(i,:),smo),'k','linewidth',1)
        end
        try
            hold on, plot(tps,SmoothDec(RLocalDev(i,:),smo),'r','linewidth',1)
        end
        yl=ylim;
        line([0 0],yl,'color','k')
        xlim([-600 700])
        title(['Local effect, ',LFPnames(i)])
        

        %figure('color',[1 1 1]), 
        subplot(2,1,2)
        try
            plot(tps,SmoothDec(RGlobalStd(i,:),smo),'k','linewidth',1)
        end
        try
            hold on, plot(tps,SmoothDec(RGlobalDev(i,:),smo),'r','linewidth',1)
        end
        yl=ylim;
        line([0 0],yl,'color','k')
        title(['Global effect, ',LFPnames(i)])
        xlim([-600 700])

end


% 
% figure('color',[1 1 1]), 
% plot(tps,SmoothDec(RStd(i,:),smo),'k','linewidth',2)
% hold on, plot(tps,SmoothDec(RDev(i,:),smo),'r','linewidth',2)
% yl=ylim;
% line([0 0],yl,'color','k')
% 
% 
% figure('color',[1 1 1]), 
% plot(tps,SmoothDec(RGlobalStd(i,:),smo),'k','linewidth',2)
% hold on, plot(tps,SmoothDec(RGlobalDev(i,:),smo),'r','linewidth',2)
% yl=ylim;
% line([0 0],yl,'color','k')
% 




