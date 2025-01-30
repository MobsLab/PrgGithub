% FigurePowerAnalysis 

cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
load  DataParcoursPowerDownHomeostasis
% 
% As(1,:)=Start(SWSEpoch,'s');
% As(2,:)=End(SWSEpoch,'s')-Start(SWSEpoch,'s');
% As(3,:)=PowSWS;
% As(4,:)=nbDownSWS;
% As(5,:)=FrDownSWS;
% As(6,:)=DurSWS;
% As(7,:)=IntSWS;
% As(8,:)=IntSWS./DurSWS;
% As(9,:)=AmpDeltaDownSWS;
% As(10,:)=AmpDeltaUpSWS;
% As(11,:)=FrSWSNoUp;
% As(12,:)=FrSWS;
% As(13,:)=FrBefSWS;
% As(14,:)=FrAftSWS;
% As(15,:)=FrAftSWS-FrBefSWS;


figure('color',[1 1 1]), 
subplot(1,2,1), 
for a=1:13
plot(MM1{a}(:,1),MM1{a}(:,2),'k')
hold on, plot(MM2{a}(:,1),MM2{a}(:,2),'r')
end

MMT1=zeros(2001,1);
MMT2=zeros(2001,1);
for a=1:13
    MMT1=MMT1+MM1{a}(:,2);
    MMT2=MMT2+MM2{a}(:,2);
end
subplot(1,2,2), 
plot(MM1{a}(:,1),MMT1/13,'k','linewidth',2)
hold on, plot(MM2{a}(:,1),MMT2/13,'r','linewidth',2)


dayOK=[1 3 4 5 6 7 11 12 13];


for i=1:13
   Fr(i)=nanmean(As{i}(12,:)); 
end
% 
% for a=1:13
% figure('color',[1 1 1]),  hold on
% scatter(As{a}(6,:),As{a}(7,:),20,10*log10(As{a}(3,:)),'filled'), title([MiceName{a},' ',num2str(floor(1000*Fr(a))/1000)])
%  set(gca,'yscale','log')
% set(gca,'xscale','log')
% xlabel('Duration Down (ms)')
% ylabel('ISI Down (ms)')
% end
% 

k=1;
figure('color',[1 1 1]),  
for a=dayOK
            if Fr(a)>0.021
subplot(2,4,k), hold on
scatter(As{a}(6,:),As{a}(7,:),20,10*log10(As{a}(3,:)),'filled'), title([MiceName{a},' ',num2str(floor(1000*Fr(a))/1000)]), caxis([25 31])
 set(gca,'yscale','log')
set(gca,'xscale','log')
set(gca,'xtick',6E1:20:2E2)
set(gca,'ytick',[500 2000 5000 1E4 5E4 1E5])
xlabel('Duration Down (ms)')
ylabel('ISI Down (ms)')
xlim([6E1 2E2])
k=k+1;
            end
            
end


figure('color',[1 1 1]),  hold on
for a=dayOK
        if Fr(a)>0.021
plot(As{a}(7,:),As{a}(3,:),'.','color','k'), title('Power')
        end
end
 set(gca,'yscale','log')
set(gca,'xscale','log')
ylabel('Power')
xlabel('ISI Down (ms)')



figure('color',[1 1 1]),  hold on
for a=dayOK
        if Fr(a)>0.021
plot(As{a}(7,:)/max(As{a}(7,:)),As{a}(3,:)/max(As{a}(3,:)),'o-','markersize',2,'color',[a/13,0 1]), title('Power')
        end
end
 set(gca,'yscale','log')
set(gca,'xscale','log')
ylabel('Power')
xlabel('ISI Down (ms)')


figure('color',[1 1 1]),  hold on
for a=dayOK
        if Fr(a)>0.021
plot(As{a}(6,:)/max(As{a}(6,:)),As{a}(3,:)/max(As{a}(3,:)),'o-','markersize',2,'color',[a/13,0 1]), title('Power')
        end
end
 set(gca,'yscale','log')
set(gca,'xscale','log')
ylabel('Power')
xlabel('Duration Down (ms)')





figure('color',[1 1 1]),  hold on
for a=dayOK
        if Fr(a)>0.021
plot(As{a}(6,:),As{a}(3,:),'.','color','k'), title('Power')
        end
end
 set(gca,'yscale','log')
set(gca,'xscale','log')
ylabel('Power')
xlabel('Duration Down (ms)')




figure('color',[1 1 1]),  hold on
for a=dayOK
    if Fr(a)>0.021
    scatter(As{a}(6,:),As{a}(7,:),20,10*log10(As{a}(3,:)),'filled'), title('Power')
    end
end
 set(gca,'yscale','log')
set(gca,'xscale','log')
xlabel('Duration Down (ms)')
ylabel('ISI Down (ms)')



% figure('color',[1 1 1]),  hold on
% for a=dayOK
%         if Fr(a)>0.021
% plot(As{a}(6,:),As{a}(7,:),'.','color',[a/13,0 1]), title('Power')
%         end
% end
%  set(gca,'yscale','log')
% set(gca,'xscale','log')
% xlabel('Duration Down (ms)')
% ylabel('ISI Down (ms)')


% 
% figure('color',[1 1 1]),  hold on
% for a=1:13
% scatter(As{a}(6,:),As{a}(7,:),50,As{a}(1,:),'filled'), title('Time')
% end
%  set(gca,'yscale','log')
% set(gca,'xscale','log')
% xlabel('Duration Down (ms)')
% ylabel('ISI Down (ms)')

