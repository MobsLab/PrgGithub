% ParcoursPowerDownHomeostasis


exp='BASAL';
Generate=0;
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback



if Generate
    Dir=PathForExperimentsDeltaSleepNew(exp);
    a=1;
    for i=1:length(Dir.path)
    %            try
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(i),'}'')'])
    disp(pwd)
    [As{a},Aw{a},Ar{a},rs{a},rsZ{a},rr{a},rrZ{a},rw{a},rwZ{a},idx1{a},idx2{a},R1{a},R2{a},MM1{a},MM2{a}]=PowerDownHomeostasis(1,0);close all
    MiceName{a}=Dir.name{i};
    PathOK{a}=Dir.path{i};
    a=a+1;
    %            end
    end
    save DataParcoursPowerDownHomeostasis
end





cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback
load  DataParcoursPowerDownHomeostasis

k=0;
k=k+1; ti{k}='Start periods';
k=k+1; ti{k}='Dur periods';
k=k+1; ti{k}='Power';
k=k+1; ti{k}='Nb Down';
k=k+1; ti{k}='Occ Down';
k=k+1; ti{k}='Dur Down';
k=k+1; ti{k}='ISI Down';
k=k+1; ti{k}='Ratio ISI/Dur Down';
k=k+1; ti{k}='Ampl Delta Down';
k=k+1; ti{k}='Ampl Delta Up';
k=k+1; ti{k}='Fr no Up';
k=k+1; ti{k}='Fr';
k=k+1; ti{k}='Fr Bef';
k=k+1; ti{k}='Fr Aft';
k=k+1; ti{k}='Diff Fr';

        
   for i=1:15
       for j=i:15
            k=1;
            figure('color',[1 1 1]),  
            for a=dayOK
                    if Fr(a)>0.021
                        subplot(2,3,k), hold on
                        scatter(As{a}(i,:),As{a}(j,:),20,10*log10(As{a}(3,:)),'filled'), title([MiceName{a},' ',num2str(floor(1000*Fr(a))/1000)]), caxis([25 31])
                         set(gca,'yscale','log')
                        set(gca,'xscale','log')
%                         set(gca,'xtick',6E1:20:2E2)
%                         set(gca,'ytick',[500 2000 5000 1E4 5E4 1E5])
                        xlabel(ti{i})
                        ylabel(ti{j})
%                         xlim([6E1 2E2])
                        k=k+1;
                    end

            end
       end
   end       

   
   clear R
clear P
clear r
clear p
  % ind=3:15;
   ind=[3 6 7 8 9 10];
   
  for a=dayOK
  for i=ind
       for j=ind
           test1=As{a}(i,:);
           test2=As{a}(j,:);           
           test1=10*log10(abs(test1));
           test2=10*log10(abs(test2)); 
           id1=find(isnan(test1));
           id2=find(isnan(test2));
           test1([id1,id2])=[];
           test2([id1,id2])=[];
        [rtemp,ptemp]=corrcoef(test1,test2);
        r(a,i,j)=rtemp(2,1);
        p(a,i,j)=ptemp(2,1);
       end
  end  
  end
    
   for i=1:length(ind)
       for j=1:length(ind)
            R(i,j)=nanmean(squeeze(r(:,ind(i),ind(j))));
            P(i,j)=nanmean(squeeze(p(:,ind(i),ind(j))));
       end
   end
   
   figure('color',[1 1 1]), 
   subplot(1,2,1),imagesc(R), axis xy
   set(gca,'xtick',1:length(ind))
   set(gca,'ytick',1:length(ind))
%    set(gca,'xticklabel',ti)
   set(gca,'yticklabel',ti(ind))
   line([0.5 0.5],[0 length(ind)+0.5],'color','w','linewidth',2)
line([1.5 1.5],[0 15.5],'color','w','linewidth',2)
   subplot(1,2,2),imagesc(P), axis xy
      set(gca,'xtick',1:length(ind))
   set(gca,'ytick',1:length(ind))
%    set(gca,'xticklabel',ti)
   set(gca,'yticklabel',ti(ind))
   line([0.5 0.5],[0 15.5],'color','w','linewidth',2)
line([1.5 1.5],[0 15.5],'color','w','linewidth',2)
caxis([0 0.05])
   



   savin=1;
if savin
  % clear num
   %num=gcf;
   for i=1:num
%    try
       figure(i)
   set(i,'position',[73           2        1664        1080])
   eval(['saveFigure(',num2str(i),',''ParcoursPowerDownHomeostasis',exp,'fig',num2str(i),''',''/media/DataMOBsRAID/ProjetBreathDeltaFeedback'')'])
   close
%    end
   end
end



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
            subplot(2,3,k), hold on
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




