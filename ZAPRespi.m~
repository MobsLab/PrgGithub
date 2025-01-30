%ZAPRespi


Stat=1; %SWS
% Stat=2; %REM
%Stat=3; %Wake


try
    LFP;

catch
        load LFPData
        load StateEpoch
end


        try
            ListLFP;
        catch
            load ListLFP
        end
        
        try
            listBulb=listLFP.channels{strcmp(listLFP.name,'Bulb')};
        catch
            listBulb=[];
        end
        listPFC=listLFP.channels{strcmp(listLFP.name,'PFCx')};
        listPar=listLFP.channels{strcmp(listLFP.name,'PaCx')};
        listAud=listLFP.channels{strcmp(listLFP.name,'AuCx')};
        listHpc=listLFP.channels{strcmp(listLFP.name,'dHPC')};
   
    if length(listBulb)>1
    listT=[listBulb listPFC listPar listAud listHpc];
    else
    listT=[listPFC listPar listAud listHpc];    
    end
    
try
    Amp;    
    
catch
    [zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[0 7]);
    if Stat==1
         td=Range(Restrict(AmplitudeRespi,SWSEpoch));pas=5;
    elseif Stat==2
         td=Range(Restrict(AmplitudeRespi,REMEpoch));pas=1;
     elseif Stat==3
        td=Range(Restrict(AmplitudeRespi,and(MovEpoch,ThetaEpoch)));pas=1;
    end
    
        clear Amp
        for i=2:pas:length(td)-1
            Epoch=intervalSet(td(i),td(i+1));
            for num=listT
            Amp(num,i,1)=td(i+1)-td(i);
            Amp(num,i,2)=td(i)-td(i-1);
            Amp(num,i,3)=max(Data(Restrict(RespiTSD,Epoch)));
            Amp(num,i,4)=min(Data(Restrict(RespiTSD,Epoch)));
            Amp(num,i,5)=max(Data(Restrict(LFP{num},Epoch)));
            Amp(num,i,6)=min(Data(Restrict(LFP{num},Epoch)));
            end
        end
end

% id=find(Amp(:,3)>0.007&Amp(:,4)<-0.007);
% %id2=find(Amp(:,4)<-0.007);
% %id=sort([id1 ;id2]);
% figure('color',[1 1 1]),
% subplot(2,2,1),hold on
% plot(Amp(id,1)/10,Amp(id,3),'k.')
% plot(Amp(id,1)/10,Amp(id,4),'r.')
% xlim([0 700])
% ylim([-0.1 0.1])
% subplot(2,2,2),hold on
% plot(Amp(id,1)/10,Amp(id,5),'k.')
% plot(Amp(id,1)/10,Amp(id,6),'r.')
% xlim([0 700])
% subplot(2,2,3),hold on
% plot(Amp(id,2)/10,Amp(id,3),'k.')
% plot(Amp(id,2)/10,Amp(id,4),'r.')
% xlim([0 700])
% ylim([-0.1 0.1])
% subplot(2,2,4),hold on
% plot(Amp(id,2)/10,Amp(id,5),'k.')
% plot(Amp(id,2)/10,Amp(id,6),'r.')
% xlim([0 700])
% 
% 
% id=find(Amp(:,3)>0.007&Amp(:,4)<-0.007);
% figure('color',[1 1 1]),
% subplot(2,1,1),hold on
% plot(1./(Amp(id,1)/1E4),max(Amp(id,3),abs(Amp(id,4))),'k.')
% subplot(2,1,2),hold on
% plot(1./(Amp(id,1)/1E4),max(Amp(id,5),abs(Amp(id,6))),'k.')

try
    id=find(Amp(listBulb(3),:,3)>0.007&Amp(listBulb(3),:,4)<-0.007);
catch
%     id =1:length(Amp);
    id=find(Amp(num,:,1)>800&Amp(num,:,3)<0.07);
end
figure('color',[1 1 1]),
subplot(4,4,1),hold on
plot(Amp(num,id,1)/10,max(Amp(num,id,3),abs(Amp(num,id,4))),'k.')
xlim([0 700])
ylim([0 0.1])

for i=1:15
        clear iddx
        iddx=find(Amp(num,id,1)>(i-1)*500&Amp(num,id,1)<i*500);
        if length(iddx)>2
        [Mt,St,Et]=MeanDifNan(max(Amp(num,id(iddx),3),abs(Amp(num,id(iddx),4)))');
        M(1,i)=Mt;
        S(1,i)=St;
        E(1,i)=Et;
        else
            M(1,i)=nan;
            E(1,i)=nan;
            S(1,i)=nan;
        end
    end

    %figure, 
    k=1;
    plot([1:15]*50, M(1,:),'color',[0 k/16 (16-k)/16],'linewidth',2)
    hold on, plot([1:15]*50, M(1,:)+S(1,:),'color',[0 k/16 (16-k)/16])
    hold on, plot([1:15]*50, M(1,:)-S(1,:),'color',[0 k/16 (16-k)/16])
    
    
    
% subplot(2,1,2),hold on
% plot(Amp(num,id,1)/10,max(Amp(num,id,5),abs(Amp(num,id,6))),'k.')
% xlim([0 700])


k=2;
for num=[listBulb listPFC listPar listAud listHpc]
    
    subplot(4,4,k),hold on
    plot(Amp(num,id,1)/10,max(Amp(num,id,5),abs(Amp(num,id,6))),'k.')
    xlim([0 700])

    clear Et
    clear St
    clear Mt

    for i=1:15
        clear iddx
        iddx=find(Amp(num,id,1)>(i-1)*500&Amp(num,id,1)<i*500);
        if length(iddx)>2
        [Mt,St,Et]=MeanDifNan(max(Amp(num,id(iddx),5),abs(Amp(num,id(iddx),6)))');
        M(num,i)=Mt;
        S(num,i)=St;
        E(num,i)=Et;
        else
            M(num,i)=nan;
            E(num,i)=nan;
            S(num,i)=nan;
        end
    end

    %figure, 
    plot([1:15]*50, M(num,:),'color',[0 k/16 (16-k)/16],'linewidth',2)
    hold on, plot([1:15]*50, M(num,:)+S(num,:),'color',[0 k/16 (16-k)/16])
    hold on, plot([1:15]*50, M(num,:)-S(num,:),'color',[0 k/16 (16-k)/16])

k=k+1;
end


figure('color',[1 1 1]),hold on
k=1;
    if isnan(M(1,4))
        M(1,4)=(M(1,3)+M(1,5))/2;
    end
     if isnan(M(1,5))
        M(1,5)=(M(1,4)+M(1,6))/2;
    end
    plot([1:15]*50, M(1,:)/max(M(1,:)),'color','k','linewidth',4)
   k=k+1; 
for num=[listBulb listPFC listPar listAud listHpc]
    if isnan(M(num,4))
        M(num,4)=(M(num,3)+M(num,5))/2;
    end
    if isnan(M(num,5))
        M(num,5)=(M(num,4)+M(num,6))/2;
    end
    plot([1:15]*50, M(num,:)/max(M(num,:)),'color',[0 k/16 (16-k)/16],'linewidth',2)
   k=k+1; 
end
ylim([0.2 1.3])
xlim([0 750])
