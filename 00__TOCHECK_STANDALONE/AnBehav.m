function AnBehav(fname)
%%  Analyze maze behaviour

% Check tracking
close all
clear position vitesse

disp('get appropriate masks')
load(strcat(fname,'_analysis.mat'))
position=retrack(fname,BW_threshold,smaller_object_size,totmask,1);
  
    vitesse(3,:)=position(3,:);
    vitesse(1,2:end)=(position(1,2:end)-position(1,1:end-1))./(position(3,2:end)-position(3,1:end-1));
    vitesse(2,2:end)=(position(2,2:end)-position(2,1:end-1))./(position(3,2:end)-position(3,1:end-1));
    vitesse(4,2:end)=sqrt(vitesse(1,2:end).^2+vitesse(2,2:end).^2);
vitesse(:,vitesse(4,:)>250)=NaN;
position(:,vitesse(4,:)>250)=NaN;
    disp('Left or Right turns')
    [position,st,tsh,tlo,rthenl,lthenr,uniqpos]=LocatePts(position,choicemask,rewmask,xc,yc,xl,yl,xr,yr);
%     figure
%     imagesc(datas.image)
%     hold on
%     scatter(position(1,position(5,:)==1),position(2,position(5,:)==1),'c','filled')
%     scatter(position(1,position(5,:)==2),position(2,position(5,:)==2),'k','filled')
%     scatter(position(1,position(5,:)==3),position(2,position(5,:)==3),'r','filled')
%     scatter(position(1,position(5,:)==4),position(2,position(5,:)==4),'b','filled')
%     scatter(position(1,position(5,:)==5),position(2,position(5,:)==5),'y','filled')
%     colormap gray
%     
    %direction
    disp('looking at direction')
    cd ..
    [t1bu,t1bbu,d1bu,d1bbu,t2bu,t2bbu,t2cbu,d2bu,d2bbu,d2cbu]=get_direction(position,xl,yl,xc,yc,xr,yr,choicemask,rewmask,fname);
    
%    [Y,X]=hist(d1bu,100);
%     [Yb,Xb]=hist(d1bbu,50);
%     figure
%     clf
%     plot(X,Y/sum(Y),'linewidth',3,'color','r')
%     hold on
%     plot(Xb,Yb/sum(Yb),'g','linewidth',3)
%     scatter(nanmean(d1bu),max(Y/sum(Y))*0.8,120,'k','filled')
%     scatter(nanmean(d1bbu),max(Y/sum(Y))*0.8,120,'k','filled')
%     scatter(nanmean(d1bu),max(Y/sum(Y))*0.8,50,'r','filled')
%     scatter(nanmean(d1bbu),max(Y/sum(Y))*0.8,50,'g','filled')
%     legend('right way','wrongway')
%     xlabel('distance run')
%     
%     %speeds
%     vitesse(4,vitesse(4,:)<10)=NaN;
%     [Y1,X1]=hist(vitesse(4,position(5,:)==1),70);
%     [Y2,X2]=hist(vitesse(4,position(5,:)==2),70);
%     [Y3,X3]=hist(vitesse(4,position(5,:)==3),70);
%     [Y4,X4]=hist(vitesse(4,position(5,:)==4),70);
%     [Y5,X5]=hist(vitesse(4,position(5,:)==5),70);
%     figure
%     plot(X1,Y1/sum(Y1),'linewidth',3,'color','C')
%     hold on
%     plot(X2,Y2/sum(Y2),'linewidth',3,'color','k')
%     plot(X3,Y3/sum(Y3),'linewidth',3,'color','r')
%     plot(X4,Y4/sum(Y4),'linewidth',3,'color','b')
%     plot(X5,Y5/sum(Y5),'linewidth',3,'color','y')
%     xlim([0 600])
%     scatter(nanmedian(vitesse(4,position(5,:)==1)),max(Y3/sum(Y3))*0.8,120,'k','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==2)),max(Y3/sum(Y3))*0.8,120,'k','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==3)),max(Y3/sum(Y3))*0.8,120,'k','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==4)),max(Y3/sum(Y3))*0.8,120,'k','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==5)),max(Y3/sum(Y3))*0.8,120,'k','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==1)),max(Y3/sum(Y3))*0.8,50,'c','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==2)),max(Y3/sum(Y3))*0.8,50,'k','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==3)),max(Y3/sum(Y3))*0.8,50,'r','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==4)),max(Y3/sum(Y3))*0.8,50,'b','filled')
%     scatter(nanmedian(vitesse(4,position(5,:)==5)),max(Y3/sum(Y3))*0.8,50,'y','filled')
%     legend('short','long','return','choice','reward')
%     xlabel('speed')
    
% figure
% imagesc(double(datas.image(:,:,1)).*double(totmask));
% unfreezeColors
% colormap gray
% freezeColors
% hold on
% scatter(position(1,:),position(2,:),10,vitesse(4,:),'filled')
% colormap jet
% caxis([0 300])
% 
% figure
% subplot(121)
% a=[position(2,:)',position(1,:)'];    
% carte = carteOccupation(a,[60,60],[40 240;0 350]);
% imagesc(log(carte))
% subplot(122)
% mn=mean2D(position(2,:),position(1,:),vitesse(4,:),60,60,[240 40],[350 0]);
% imagesc(mn)
% colormap hot
%     save(strcat(fname,'_analysis.mat'),'position','vitesse','-append')



clear trew tchoice
choicetime=position(5,:)==4;
dchoicetime=diff(choicetime);
zeroind=find(dchoicetime);
if position(5,1)==4
   zeroind=[1,zeroind];
end
for i=1:floor(length(zeroind)/2)
    tchoice(i)=zeroind(2*i)-zeroind(2*i-1);
end

rewtime=position(5,:)==5;
drewtime=diff(rewtime);
zeroind=find(drewtime);
if position(5,1)==5
   zeroind=[1,zeroind];
end
for i=1:floor(length(zeroind)/2)-1
    trew(i)=zeroind(2*i)-zeroind(2*i-1);
end

    dt=median(diff( position(3,:)));
disp ('Figures to keep')
disp(num2str(mean(d1bu)/mean(d1bbu)))
disp(num2str(sum(d1bu)/sum(d1bbu)))
disp(num2str(st))
disp(num2str(sum(position(5,:)==4)*dt/position(3,end)))
disp(num2str(mean(tchoice)*dt))
disp(num2str(sum(position(5,:)==5)*dt/position(3,end)))
disp(num2str(mean(trew)*dt))
disp(num2str(position(3,end)))
figsint=[mean(d1bu)/mean(d1bbu),sum(d1bu)/sum(d1bbu),st,sum(position(5,:)==4)*dt/position(3,end),mean(tchoice)*dt,sum(position(5,:)==5)*dt/position(3,end),position(3,end),mean(trew)*dt,size(choicemask,1)*size(choicemask,2)];

save(strcat(fname,'_analysis.mat'),'figsint','-append')
save(strcat(fname,'_analysis.mat'),'position','vitesse','-append')
     save(strcat(fname,'_analysis.mat'),'t1bu','tchoice','trew','t1bbu','d1bu','d1bbu','t2bu','t2bbu','t2cbu','d2bu','d2bbu','d2cbu','position','st','uniqpos','tsh','tlo','rthenl','lthenr','-append')

   
    
end