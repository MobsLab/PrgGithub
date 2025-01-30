%BilanParcoursSleepCycle

% try
%  cd /media/mobssenior/Data2/Dropbox/Kteam
% catch
%  cd /Users/Bench/Dropbox/Kteam
% end
% load DataParcoursSleepCycle


% Mat(:,1)=DurSleepCycle;
% Mat(:,2)=TimeSleepCycleMin;
% Mat(:,3)=TotalTimeREMPerCycle;
% Mat(:,4)=RatioTimeREMPerCycle;
% Mat(:,5)=NbSWSPerCycle;
% Mat(:,6)=MeanTimeSWSPerCycle;
% Mat(:,7)=TotalTimeSWSPerCycle;
% Mat(:,8)=RatioTimeSWSPerCycle;
% Mat(:,9)=NbWakePerCycle;
% Mat(:,10)=MeanTimeWakePerCycle;
% Mat(:,11)=TotalTimeWakePerCycle;
% Mat(:,12)=RatioTimeWakePerCycle;
% Mat(:,13)=TimeDebRecording;
% Mat(:,14)=TimeSleepCycle;

%-----------------------------------------------------------------
%-----------------------------------------------------------------

nbSlCy=44; % 35;% 28; %44;

% listMice=[[1:13],[24:28]];
%listMice=[[1:8],[10:13],[24:28]];
listMice=1:13; %13; %28;%13;
%listMice=1:13; %28;%13;
% listMice(18)=[];
% listMice(6)=[];
try
    power;
catch
    power=[2 4];
    %power=[10 15];
    %power=[6 9];
end

%-----------------------------------------------------------------
%-----------------------------------------------------------------
 
for i=listMice%1:length(ReNormT)
    try
        Rt=Rt+ReNormT{i}';
    catch
        Rt=ReNormT{i}';
    end    
end


try temps=tps{1}; catch temps=tps;end
try fff=ff{1}(1,:); catch fff=ff(1,:);end

%-----------------------------------------------------------------
%% figure1
%-----------------------------------------------------------------
figure('color',[1 1 1]), imagesc(1:13,fff(1,:),Rt), axis xy
k=1;
clear pow
clear var
clear varz
for i=listMice
pow(k,:)=mean(ReNormT{i}(:,find(fff>power(1)&fff<power(2))),2);
var(k,:)=polyfit(temps(1,:),log(pow(k,:)),1);
varz(k,:)=polyfit(temps(1,:),log(4+zscore(pow(k,:))),1);
k=k+1;
end

%-----------------------------------------------------------------
%% figure2
%-----------------------------------------------------------------
figure('color',[1 1 1]), 
subplot(2,3,1), plot(pow'), hold on, plot(mean(pow),'k','linewidth',2)
subplot(2,3,2), plot(10*log10(pow)'), hold on, plot(mean(10*log10(pow)),'k','linewidth',2)
subplot(2,3,3), plot(zscore(pow')), hold on, plot(mean(zscore(pow')'),'k','linewidth',2)
subplot(2,3,4), hold on, 
for i=1:length(listMice)
    plot(temps(1,:),exp(var(i,2))*exp(temps(1,:)*var(i,1)),'color',[i/length(listMice) 0 (length(listMice)-i)/length(listMice)])
end
subplot(2,3,6), hold on, 
for i=1:length(listMice)
    plot(temps(1,:),exp(varz(i,2))*exp(temps(1,:)*varz(i,1))-4,'color',[i/length(listMice) 0 (length(listMice)-i)/length(listMice)])
end

clear pow2
clear var2
clear var2z
k=1;
for i=listMice
    a=1;
    for j=1:size(ReNormT2{i},1)/length(tps(1,:))
    pow2(k,a,:)=mean(ReNormT2{i}(j:j+100,find(fff>power(1)&fff<power(2))),2);
    var2(k,a,:)=polyfit(temps(1,:)',log(squeeze(pow2(k,a,:))),1);
    var2z(k,a,:)=polyfit(temps(1,:)',log(4+zscore(squeeze(pow2(k,a,:)))),1);
    a=a+1;
    end
    k=k+1;
end

% figure, 
% subplot(2,1,1), hold on
% subplot(2,1,2), hold on
% plot(zscore(mean(ReNormT2{i}(j:j+100,find(fff>2.5&fff<4)),2)))
%plot(mean(ReNormT2{i}(j:j+100,find(fff>2.5&fff<4)),2)), title(num2str(j))


clear Rt2
clear Rt2z
a=1;b=1;
for j=1:101:nbSlCy*100
        Rt2{a}=[];
        Rt2z{a}=[];
        Nb(b)=0;
        for i=listMice
            try
            Rt2{a}=[Rt2{a};mean(ReNormT2{i}(j:j+99,find(fff>power(1)&fff<power(2))),2)'];
            Rt2z{a}=[Rt2z{a};zscore(mean(ReNormT2{i}(j:j+99,find(fff>power(1)&fff<power(2))),2))'];
            Nb(b)=Nb(b)+1;
            end
        end
        a=a+1;
        b=b+1;
end
%-----------------------------------------------------------------
%% figure3
%-----------------------------------------------------------------
figure('color',[1 1 1]), plot(Nb,'ko-','markerfacecolor','k')


%-----------------------------------------------------------------
%% figure4
%-----------------------------------------------------------------
RtsleCy=[];
RtsleCyz=[];
for i=1:length(Rt2z)
    try
    RtsleCy=[RtsleCy;mean(Rt2{i})];
    RtsleCyz=[RtsleCyz;mean(Rt2z{i})];
    end
end

figure('color',[1 1 1]),
subplot(2,3,1), imagesc(RtsleCy)
subplot(2,3,2), imagesc(10*log10(RtsleCy))
subplot(2,3,3), imagesc(RtsleCyz)
 for i=1:length(Rt2z)
    subplot(2,3,4),hold on, plot(mean(Rt2{i})','color',[i/length(Rt2z) 0 (length(Rt2z)-i)/length(Rt2z)])
    subplot(2,3,5),hold on, plot(mean(10*log10(Rt2{i}))','color',[i/length(Rt2z) 0 (length(Rt2z)-i)/length(Rt2z)])    
     subplot(2,3,6),hold on, plot(mean(Rt2z{i})','color',[i/length(Rt2z) 0 (length(Rt2z)-i)/length(Rt2z)])
 end   
    
%-----------------------------------------------------------------
%% figure5
%----------------------------------------------------------------- 
le=size(RtsleCyz,1);
figure('color',[1 1 1]), plot(mean(RtsleCyz(1:floor(le/3),:)),'k')
hold on, plot(mean(RtsleCyz(floor(2*le/3):le,:)),'r')
 
%-----------------------------------------------------------------
 
N1t=zeros(1,size(ReNormTnew{1},2));
N2t=zeros(1,size(ReNormTnew{1},2));
N3t=zeros(1,size(ReNormTnew{1},2));
Ret=zeros(1,size(ReNormTnew{1},2));
Wat=zeros(1,size(ReNormTnew{1},2));
for i=listMice%1:length(ReNormTnew)
    N1t=N1t+ReNormTnew{i}(1,:);
    N2t=N2t+ReNormTnew{i}(2,:);
    N3t=N3t+ReNormTnew{i}(3,:);
    Ret=Ret+ReNormTnew{i}(4,:);
    Wat=Wat+ReNormTnew{i}(5,:); 
end
%-----------------------------------------------------------------
%% figure6
%----------------------------------------------------------------- 
figure('color',[1 1 1]), hold on 
plot(N1t/length(listMice),'c')
plot(N2t/length(listMice),'m')
plot(N3t/length(listMice),'r')
plot(Ret/length(listMice),'b')
plot(Wat/length(listMice),'k')


%-----------------------------------------------------------------
%% figure7
%----------------------------------------------------------------- 
smo=60;
figure('color',[1 1 1]), hold on 
plot(smooth(N1t/length(listMice),smo),'c','linewidth',2)
plot(smooth(N2t/length(listMice),smo),'m','linewidth',2)
plot(smooth(N3t/length(listMice),smo),'r','linewidth',2)
plot(smooth(Ret/length(listMice),smo),'b','linewidth',2)
plot(smooth(Wat/length(listMice),smo),'k','linewidth',2)


REMt=[];WAKEt=[];
for i=listMice
    REMt=[REMt;ReNormTnew{i}(4,:)];
    WAKEt=[WAKEt;ReNormTnew{i}(5,:)];
end
%-----------------------------------------------------------------
%% figure8
%----------------------------------------------------------------- 

figure('color',[1 1 1]), 
subplot(1,2,1), imagesc(REMt), axis xy
set(gca,'yticklabel',nameMouse)
set(gca,'ytick',[1:28])
subplot(1,2,2), imagesc(WAKEt), axis xy
set(gca,'yticklabel',nameMouse)
set(gca,'ytick',[1:28])



M1t=zeros(size(M1{1},1),size(M1{1},2));
M2t=zeros(size(M1{1},1),size(M1{1},2));
M3t=zeros(size(M1{1},1),size(M1{1},2));
list=listMice;
%list(18)=[];
for i=list
    try
    tempp=M1{i};tempp(find(isinf(tempp)))=nan;
    M1t=M1t+tempp;
    catch
    M1t=M1t+tempp(1:size(M1{1},1),:);        
    end
    try
    tempp=M2{i};tempp(find(isinf(tempp)))=nan;
    M2t=M2t+tempp;
    catch
    M2t=M2t+tempp(1:size(M2{1},1),:);
    end
    try
    tempp=M3{i};tempp(find(isinf(tempp)))=nan;
    M3t=M3t+Mtempp;
    catch
    M3t=M3t+tempp(1:size(M3{1},1),:);    
    end
end
%-----------------------------------------------------------------
%% figure9
%----------------------------------------------------------------- 
figure('color',[1 1 1])
subplot(3,1,1), imagesc(M1t), axis xy
subplot(3,1,2), imagesc(M2t), axis xy
subplot(3,1,3), imagesc(M3t), axis xy


clear temp
k=1;
for i=listMice
temp(k,:)=CaracSlCy{i};
k=k+1;
end
%-----------------------------------------------------------------
%% figure10
%----------------------------------------------------------------- 
figure('color',[1 1 1]), 
subplot(3,3,1), hist(temp(:,1)/60,20), title([num2str(floor(mean(temp(:,1)/60))),'; ', num2str(floor(std(temp(:,1))/mean(temp(:,1))*100))])
subplot(3,3,2), hist(temp(:,2),20), title([num2str(floor(mean(temp(:,2)))),'; ', num2str(floor(std(temp(:,2))/mean(temp(:,2))*100))])
subplot(3,3,3), hist(temp(:,3)/60,20), title([num2str(floor(mean(temp(:,3)/60))),'; ', num2str(floor(std(temp(:,3))/mean(temp(:,3))*100))])
subplot(3,3,4), hist(temp(:,4)/60,20), title([num2str(floor(mean(temp(:,4)/60))),'; ', num2str(floor(std(temp(:,4))/mean(temp(:,4))*100))])
subplot(3,3,5), hist(temp(:,5),20), title([num2str(floor(mean(temp(:,5)))),'; ', num2str(floor(std(temp(:,5))/mean(temp(:,5))*100))])
subplot(3,3,6), hist(temp(:,6)/60,20), title([num2str(floor(mean(temp(:,6)/60))),'; ', num2str(floor(std(temp(:,6))/mean(temp(:,6))*100))])
subplot(3,3,7), hist(temp(:,7)/60,20), title([num2str(floor(mean(temp(:,7)/60))),'; ', num2str(floor(std(temp(:,7))/mean(temp(:,7))*100))])
subplot(3,3,8), hist(temp(:,8),20), title([num2str(floor(mean(temp(:,8)))),'; ', num2str(floor(std(temp(:,8))/mean(temp(:,8))*100))])
subplot(3,3,9), hist(temp(:,9)/60,20), title([num2str(floor(mean(temp(:,9)/60))),'; ', num2str(floor(std(temp(:,9))/mean(temp(:,9))*100))])




temp1=[];
temp2=[];
temp3=[];
temp4=[];
temp5=[];
temp6=[];
temp7=[];
temp8=[];
temp9=[];
temp10=[];
temp11=[];
temp12=[];
temp13=[];
temp14=[];
for i=listMice
%     id=find(Mat1{i}(:,1)>150&Mat1{i}(:,3)>30&Mat1{i}(:,7)>30);
    id=find(Mat1{i}(:,3)>30&Mat1{i}(:,7)>30);    
    temp1=[temp1;Mat1{i}(id,1)];
    temp2=[temp2;Mat1{i}(id,2)];
    temp3=[temp3;Mat1{i}(id,3)];
    temp4=[temp4;Mat1{i}(id,4)];
    temp5=[temp5;Mat1{i}(id,5)];
    temp6=[temp6;Mat1{i}(id,6)];
    temp7=[temp7;Mat1{i}(id,7)];
    temp8=[temp8;Mat1{i}(id,8)];
    temp9=[temp9;Mat1{i}(id,9)];
    temp10=[temp10;Mat1{i}(id,10)];
    temp11=[temp11;Mat1{i}(id,11)];
    temp12=[temp12;Mat1{i}(id,12)];
    temp13=[temp13;Mat1{i}(id,13)];
    temp14=[temp14;Mat1{i}(id,14)];
end
%-----------------------------------------------------------------
%% figure11
%----------------------------------------------------------------- 
figure('color',[1 1 1]),
for i=1:14
eval(['subplot(4,4,',num2str(i),'), hist(temp',num2str(i),',100),title(',num2str(i),')'])
end

% 
% PlotErrorBar2(temp1(pointslist)/60,temp1(id2)/60)
% PlotErrorBar2(temp2(pointslist),temp2(id2))
% for i=1:14
% eval(['PlotErrorBar2(temp',num2str(i),'(pointslist),temp',num2str(i),'(id2))'])
% end

%-----------------------------------------------------------------
%% figure12
%----------------------------------------------------------------- 
try
figure('color',[1 1 1]), 
subplot(1,4,1), hold on
for i=listMice
    plot(Mat2{i}(1,:),Mat2{i}(2,:)/Mat2{i}(2,1),'k')
end
% ylim([0 18*1E4])
subplot(1,4,2), hold on
for i=listMice
    plot(Mat2{i}(1,:),Mat2{i}(3,:)/Mat2{i}(3,1),'r')
end
% ylim([0 18*1E4])
subplot(1,4,3), hold on
for i=listMice
    plot(Mat2{i}(1,:),Mat2{i}(2,:)/Mat2{i}(2,1),'k')
end
for i=listMice
    plot(Mat2{i}(1,:),Mat2{i}(3,:)/Mat2{i}(3,1),'r')
end
% ylim([0 18*1E4])


idx=find(Mat2{i}(1,:)>60);
idx=idx(1);
a=1;
for dela=0:0.05:1
    idOK2=[];idOK3=[];
for i=listMice
    if Mat2{i}(2,idx)/Mat2{i}(2,1)>dela
    idOK2=[idOK2,i];
    end
    if Mat2{i}(3,idx)/Mat2{i}(3,1)>dela
    idOK3=[idOK3,i];
    end
end
A(a,:)=[length(idOK2)/length(Mat2)*100, length(idOK3)/length(Mat2)*100];
a=a+1;
end

subplot(1,4,4), hold on
plot(0:0.05:1,A(:,1),'ko-')
hold on, plot(0:0.05:1,A(:,2),'ro-')

iddnx=0:0.05:1;
[BE,idd]=max(A(:,1)-A(:,2));

line([iddnx(idd) iddnx(idd)],ylim)
subplot(1,4,1), hold on
line(xlim,[iddnx(idd) iddnx(idd)])
subplot(1,4,2), hold on
line(xlim,[iddnx(idd) iddnx(idd)])
subplot(1,4,3), hold on
line(xlim,[iddnx(idd) iddnx(idd)])
title([num2str(floor(A(idd,1))),'%,  ',num2str(floor(A(idd,2))),'%'])
catch
%     close
end
% idx=find(Mat2{i}(1,:)>60);
% idx=idx(1);idOK2=[];idOK3=[];
% for i=1:length(Mat2)
% if Mat2{i}(2,idx)/Mat2{i}(2,1)>0.3
% idOK2=[idOK2,i];
% end
% if Mat2{i}(3,idx)/Mat2{i}(3,1)>0.3
% idOK3=[idOK3,i];
% end
% end

%-----------------------------------------------------------------
%% figure13
%----------------------------------------------------------------- 

try
figure('color',[1 1 1]), 
subplot(1,4,1), hold on
for i=listMice%1:length(Mat2)
    plot(Mat2{i}(1,:),Mat2{i}(2,:)/Mat2{i}(2,1),'k')
end
% ylim([0 18*1E4])
subplot(1,4,2), hold on
for i=listMice%1:length(Mat2)
    plot(Mat2{i}(1,:),Mat2{i}(3,:)/Mat2{i}(3,1),'r')
end
% ylim([0 18*1E4])
subplot(1,4,3), hold on
for i=listMice%1:length(Mat2)
    plot(Mat2{i}(1,:),Mat2{i}(2,:)/Mat2{i}(2,1),'k')
end
for i=listMice%1:length(Mat2)
    plot(Mat2{i}(1,:),Mat2{i}(3,:)/Mat2{i}(3,1),'r')
end
% ylim([0 18*1E4])


idx=find(Mat2{i}(1,:)>60);
idx=idx(1);
a=1;
for dela=0:0.05:1
    idOK2=[];idOK3=[];
for i=listMice%1:length(Mat2)
    if Mat2{i}(2,idx)/Mat2{i}(2,1)>dela
    idOK2=[idOK2,i];
    end
    if Mat2{i}(3,idx)/Mat2{i}(3,1)>dela
    idOK3=[idOK3,i];
    end
end
A(a,:)=[length(idOK2)/length(Mat2)*100, length(idOK3)/length(Mat2)*100];
a=a+1;
end

subplot(1,4,4), hold on
plot(0:0.05:1,A(:,1),'ko-')
hold on, plot(0:0.05:1,A(:,2),'ro-')

iddnx=0:0.05:1;
[BE,idd]=max(A(:,1)-A(:,2));

idd=idd-1;

line([iddnx(idd) iddnx(idd)],ylim)
subplot(1,4,1), hold on
line(xlim,[iddnx(idd) iddnx(idd)])
subplot(1,4,2), hold on
line(xlim,[iddnx(idd) iddnx(idd)])
subplot(1,4,3), hold on
line(xlim,[iddnx(idd) iddnx(idd)])
title([num2str(floor(A(idd,1))),'%,  ',num2str(floor(A(idd,2))),'%'])
catch
%     close
end
% idx=find(Mat2{i}(1,:)>60);
% idx=idx(1);idOK2=[];idOK3=[];
% for i=1:length(Mat2)
% if Mat2{i}(2,idx)/Mat2{i}(2,1)>0.3
% idOK2=[idOK2,i];
% end
% if Mat2{i}(3,idx)/Mat2{i}(3,1)>0.3
% idOK3=[idOK3,i];
% end
% end

%-----------------------------------------------------------------
%% figure14
%----------------------------------------------------------------- 
try
    figure('color',[1 1 1]), 
subplot(1,5,1), hold on
for i=listMice%1:length(Mat3)
    plot(Mat2{i}(1,:),Mat3{i}(:,:)'./(ones(size(Mat3{i}(:,:)',1),1)*Mat3{i}(:,1)'),'k')
end
% ylim([0 18*1E4])
subplot(1,5,2), hold on
for i=listMice%1:length(Mat2)
    plot(Mat2{i}(1,:),Mat4{i}(:,:)'./(ones(size(Mat4{i}(:,:)',1),1)*Mat4{i}(:,1)'),'r')
end
% ylim([0 18*1E4])
subplot(1,5,3), hold on
for i=listMice%1:length(Mat2)
    plot(Mat2{i}(1,:),Mat3{i}(:,:)'./(ones(size(Mat3{i}(:,:)',1),1)*Mat3{i}(:,1)'),'k')
end
for i=listMice%1:length(Mat2)
    plot(Mat2{i}(1,:),Mat4{i}(:,:)'./(ones(size(Mat4{i}(:,:)',1),1)*Mat4{i}(:,1)'),'r')
end

idx=find(Mat2{i}(1,:)>60);
idx=idx(1);
A1=[];
for i=listMice%1:length(Mat3)
A1=[A1,Mat3{i}(:,idx)'./(ones(size(Mat3{i}(:,idx)',1),1)*Mat3{i}(:,1)')];
end
A2=[];
for i=listMice%1:length(Mat4)
A2=[A2,Mat4{i}(:,idx)'./(ones(size(Mat4{i}(:,idx)',1),1)*Mat4{i}(:,1)')];
end

[hh,bb]=hist(A1,100);[hh2,bb2]=hist(A2,100);
subplot(1,5,4), hold on
plot(bb2,hh2/sum(hh2),'r','linewidth',2)
plot(bb,hh/sum(hh),'k','linewidth',2)     
    

a=1;
for i=0.1:0.01:6
perTh(a,1)=length(find(A1>i))/length(A1)*100;
perTh(a,2)=length(find(A2>i))/length(A2)*100;
a=a+1;
end
set(gca,'xscale','log')
set(gca,'xtick',[0.3 1 5])

subplot(1,5,5), hold on
plot(0.1:0.01:6,perTh(:,1),'k','linewidth',2)
plot(0.1:0.01:6,perTh(:,2),'r','linewidth',2) 
set(gca,'xscale','log')
set(gca,'xtick',[0.1 0.3 0.6 1 2 3 4 5])

[BE,id]=max(perTh(:,1)-perTh(:,2));
id=id-1;

indx=0.1:0.01:6;
%indx(id)
line([indx(id) indx(id)],ylim)
title([num2str(floor(perTh(id,1))),'%,  ',num2str(floor(perTh(id,2))),'%'])
subplot(1,5,4), hold on
line([indx(id) indx(id)],ylim)
xlim([0.06 7])

subplot(1,5,1), hold on
line(xlim, [indx(id) indx(id)])
subplot(1,5,2), hold on
line(xlim, [indx(id) indx(id)])
subplot(1,5,3), hold on
line(xlim, [indx(id) indx(id)])

catch
%     close
end


%-----------------------------------------------------------------
%% figure15
%----------------------------------------------------------------- 

try
    k=1;
for i=listMice%1:length(Mat2)
    val(k,1)=Mat2{i}(2,idx)/Mat2{i}(2,1);
    val(k,2)=Mat2{i}(3,idx)/Mat2{i}(3,1);
    val(k,3)=Mat2{i}(4,idx)/Mat2{i}(4,1);  
    k=k+1;
end
end
try
figure('color',[1 1 1]),
subplot(1,5,1:2), hold on
plot(val(:,1),1:length(Mat2),'ko-')
plot(val(:,2),1:length(Mat2),'ro-')
plot(val(:,3),1:length(Mat2),'bo-')
set(gca,'yticklabel',nameMouse(listMice))
set(gca,'ytick',[1:length(listMice)])
subplot(1,5,4:5), hold on
plot(log10(val(:,2)./val(:,1)),1:length(listMice),'ko-')
line([0 0],ylim,'color','r')
set(gca,'yticklabel',nameMouse(listMice))
set(gca,'ytick',[1:length(listMice)])
catch
%     close
end


%-----------------------------------------------------------------
%% figure16
%----------------------------------------------------------------- 

try
figure('color',[1 1 1]),
subplot(1,2,1), 
imagesc(zscore(pow')')
set(gca,'ytick',[1:length((listMice))])
set(gca,'yticklabel',nameMouse(listMice))

clear decExp
for i=1:length(listMice)%1:size(var,1)
decExp(i,:)=exp(var(i,2))*exp(temps(1,:)*var(i,1));
end
subplot(1,2,2), 
imagesc(decExp)
set(gca,'ytick',[1:length(listMice)])
set(gca,'yticklabel',nameMouse(listMice))

k=1;
for i=listMice%1:length(Mat1)
    Bi(k,:)=mean(Mat1{i});
    k=k+1;
end
catch
%     close
end

%-----------------------------------------------------------------
%% figure17
%----------------------------------------------------------------- 

try
% [r,p]=corrcoef([Bi,var,temp]);
GlobalData=[Bi,var,temp];
[r,p]=corrcoef(zscore(GlobalData));
[V,L]=pcacov(r);
pc1=V(:,1);
[BE,iddd1]=sort(pc1);
pc2=V(:,2);
[BE,iddd2]=sort(pc2);

i=0;
i=i+1;varname{i}='DurSleepCycle';                           %1
i=i+1;varname{i}='TimeSleepCycleMin';                       %2
i=i+1;varname{i}='TotalTimeREMPerCycle';                    %3
i=i+1;varname{i}='RatioTimeREMPerCycle';                    %4
i=i+1;varname{i}='NbSWSPerCycle';                           %5
i=i+1;varname{i}='MeanTimeSWSPerCycle';                     %6
i=i+1;varname{i}='TotalTimeSWSPerCycle';                    %7
i=i+1;varname{i}='RatioTimeSWSPerCycle';                    %8
i=i+1;varname{i}='NbWakePerCycle';                          %9
i=i+1;varname{i}='MeanTimeWakePerCycle';                    %10
i=i+1;varname{i}='TotalTimeWakePerCycle';                   %11
i=i+1;varname{i}='RatioTimeWakePerCycle';                   %12
i=i+1;varname{i}='TimeDebRecording';                        %13
i=i+1;varname{i}='TimeSleepCycle';                          %14
i=i+1;varname{i}='Fit exp 1';                               %15
i=i+1;varname{i}='Fit exp 2';                               %16
i=i+1;varname{i}='Mean duration Sleep Cycle (min)';         %17
i=i+1;varname{i}='Nb Sleep Cycle';                          %18
i=i+1;varname{i}='Mean ISI Sleep Cycle (min)';              %19
i=i+1;varname{i}='Mean duration Sleep Cycle (min), REM>15'; %20
i=i+1;varname{i}='Nb Sleep Cycle, REM>15';                  %21
i=i+1;varname{i}='Mean ISI Sleep Cycle (min), REM>15';      %22
i=i+1;varname{i}='Mean duration Sleep Cycle (min), REM>30'; %23
i=i+1;varname{i}='Nb Sleep Cycle, REM>30';                  %24
i=i+1;varname{i}='Mean ISI Sleep Cycle (min), REM>30';      %25
end

try
figure('color',[1 1 1]), 
subplot(2,6,2:3), imagesc(r(iddd1,iddd1))
set(gca,'ytick',[1:length(varname)])
set(gca,'yticklabel',varname(iddd1))
subplot(2,6,5:6), imagesc(zscore(GlobalData(:,iddd1)))
set(gca,'ytick',[1:length(nameMouse)])
set(gca,'yticklabel',nameMouse)
axis xy
subplot(2,6,8:9), imagesc(r(iddd2,iddd2))
set(gca,'ytick',[1:length(varname)])
set(gca,'yticklabel',varname(iddd2))
subplot(2,6,11:12), imagesc(zscore(GlobalData(:,iddd2)))
set(gca,'ytick',[1:length(nameMouse)])
set(gca,'yticklabel',nameMouse)
axis xy
catch
%     close
end
% a=1;
% figure('color',[1 1 1]),
% for i=1:9
%     subplot(9,2,a), plot(temp(:,i),var(:,1),'k.')%,'markerfacecolor','k')
%     a=a+1;
%     subplot(9,2,a), plot(temp(:,i),var(:,2),'k.')%,'markerfacecolor','k')
%     a=a+1;
% end



%-----------------------------------------------------------------
%% figure18
%----------------------------------------------------------------- 


figure('color',[1 1 1]),
subplot(1,2,1);
surf(SmoothDec(RtsleCy(end:-1:1,:),[1,1]),'EdgeColor','none'), axis xy
%caxis([0 4E5])
subplot(1,2,2);
surf(SmoothDec(zscore(RtsleCy(end:-1:1,:)')',[1,1]),'EdgeColor','none'), axis xy


%-----------------------------------------------------------------
%% figure19
%----------------------------------------------------------------- 
[r,p]=corrcoef(temp1(1:end-1)/60,temp1(2:end)/60);
[ht,bt]=hist(temp1/60,100);
figure('color',[1 1 1]), 
subplot(1,2,1), bar(bt,ht,1,'k'), hold on, plot(bt,smooth(ht,10),'r','linewidth',2)
set(gca,'xscale','log')
set(gca,'xtick',[1 2 3 4 5 6 7 8 9 10 15 20 60])

subplot(1,2,2), plot(temp1(1:end-1)/60,temp1(2:end)/60,'k.-')
set(gca,'yscale','log')
set(gca,'xscale','log')
title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
set(gca,'xtick',[1 2 3 4 5 6 7 8 10 15 20 40 60 100 500])
set(gca,'ytick',[1 2 3 4 5 6 7 8 10 15 20 40 60 100 500])


%-----------------------------------------------------------------
%% figure20
%----------------------------------------------------------------- 


Ct=[];
for i=listMice%1:length(C)
    Ct=[Ct;C{i}'];
end
figure('color',[1 1 1]), 
subplot(3,1,1:2), imagesc(Ct), 
subplot(3,1,3), plot(B{1}/1E3/60,mean(Ct),'k')


%-----------------------------------------------------------------
%% figure21
%----------------------------------------------------------------- 
%nbSlCy=45;
R1t=zeros(nbSlCy,size(R1{1},2));
R2t=zeros(nbSlCy,size(R1{1},2));
R3t=zeros(nbSlCy,size(R1{1},2));
R4t=zeros(nbSlCy,size(R1{1},2));
R5t=zeros(nbSlCy,size(R1{1},2));
for j=1:nbSlCy   
    nbb(j)=0;
    for i=listMice%1:length(R1)
        try
        R1t(j,:)=R1t(j,:)+R1{i}(j,:);
        R2t(j,:)=R2t(j,:)+R2{i}(j,:);
        R3t(j,:)=R3t(j,:)+R3{i}(j,:);
        R4t(j,:)=R4t(j,:)+R4{i}(j,:);
        R5t(j,:)=R5t(j,:)+R5{i}(j,:);   
        nbb(j)=nbb(j)+1;
    end
    end
end

for i=1:nbSlCy
    R1t(i,:)=R1t(i,:)/nbb(i);
    R2t(i,:)=R2t(i,:)/nbb(i);
    R3t(i,:)=R3t(i,:)/nbb(i);
    R4t(i,:)=R4t(i,:)/nbb(i);
    R5t(i,:)=R5t(i,:)/nbb(i);
end

figure('color',[1 1 1]), 
subplot(5,3,1), imagesc(R1t), caxis([0 1]), axis xy
subplot(5,3,4), imagesc(R2t), caxis([0 1]), axis xy
subplot(5,3,7), imagesc(R3t), caxis([0 1]), axis xy
subplot(5,3,10), imagesc(R4t), caxis([0 1]), axis xy
subplot(5,3,13), imagesc(R5t), caxis([0 1]), axis xy
for i=1:nbSlCy
subplot(5,3,2),surf(R1t,'EdgeColor','none'), xlim([0 10001])
subplot(5,3,5),surf(R2t,'EdgeColor','none'), xlim([0 10001])%hold on, plot3(tpsb{1},i*ones(length(tpsb{1}),1),R2t(i,:),'color',[i/50 0 0])
subplot(5,3,8),surf(R3t,'EdgeColor','none'), xlim([0 10001])%hold on, plot3(tpsb{1},i*ones(length(tpsb{1}),1),R3t(i,:),'color',[i/50 0 0])
subplot(5,3,11),surf(R4t,'EdgeColor','none'), xlim([0 10001])%hold on, plot3(tpsb{1},i*ones(length(tpsb{1}),1),R4t(i,:),'color',[i/50 0 0])
subplot(5,3,14),surf(R5t,'EdgeColor','none'), xlim([0 10001])%hold on,plot3(tpsb{1},i*ones(length(tpsb{1}),1),R5t(i,:),'color',[i/50 0 0])
end

subplot(5,3,3), plot(mean(R1t(1:10,:),1), 'k','linewidth',2), hold on, plot(mean(R1t(end-10:end,:),1), 'r','linewidth',2),xlim([0 10001])
subplot(5,3,6), plot(mean(R2t(1:10,:),1), 'k','linewidth',2), hold on, plot(mean(R2t(end-10:end,:),1), 'r','linewidth',2),xlim([0 10001])
subplot(5,3,9), plot(mean(R3t(1:10,:),1), 'k','linewidth',2), hold on, plot(mean(R3t(end-10:end,:),1), 'r','linewidth',2),xlim([0 10001])
subplot(5,3,12), plot(mean(R4t(1:10,:),1), 'k','linewidth',2), hold on, plot(mean(R4t(end-10:end,:),1), 'r','linewidth',2),xlim([0 10001])
subplot(5,3,15), plot(mean(R5t(1:10,:),1), 'k','linewidth',2), hold on, plot(mean(R5t(end-10:end,:),1), 'r','linewidth',2),xlim([0 10001])


%-----------------------------------------------------------------
%% figure22
%----------------------------------------------------------------- 

figure('color',[1 1 1]),
k=1;
for i=listMice    
 subplot(floor(length(listMice)/5)+1,5,k), imagesc(ReNormT{i}'), axis xy, title(nameMouse(i))
 k=k+1;
end

%-----------------------------------------------------------------
%% figure23
%----------------------------------------------------------------- 


if 0
    figure('color',[1 1 1]), 
    try
    for i=1:2:length(temp1-13)
        clf, hold on
        plot(temp1(1:end-1)/60,temp1(2:end)/60,'k.-')
        plot(temp1(i:i+10)/60,temp1(i+1:i+11)/60,'r.-','linewidth',2)
        plot(temp1(i:i+10)/60,temp1(i+2:i+12)/60,'g.-','linewidth',2)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
        set(gca,'xtick',[1 2 3 4 5 6 7 8 10 15 20 40 60 100 500])
        set(gca,'ytick',[1 2 3 4 5 6 7 8 10 15 20 40 60 100 500])
        pause(0.1)
    end
    end
    set(gca,'yscale','log')
    set(gca,'xscale','log')
    title(['r=',num2str(r(2,1)),', p=',num2str(p(2,1))])
    set(gca,'xtick',[1 2 3 4 5 6 7 8 10 15 20 40 60 100 500])
    set(gca,'ytick',[1 2 3 4 5 6 7 8 10 15 20 40 60 100 500])
end



