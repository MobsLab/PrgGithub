clear all
disp('Get INTAN DigitalInput')
chanDig=0;
SetCurrentSession('digitalin.xml')

mkdir('LFPData')
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