%%  Analyze maze behaviour

% Check tracking

fname='Fear_1';

disp('get appropriate masks')
cd(fname)
load('frame000001.mat');
try
    totmask;
    xc;
    colormap gray
    subplot(121)
    imagesc(datas.image);
    subplot(122)
    imagesc(double(datas.image).*double(totmask));
    hold on
catch
    [x1,y1,BW,x,y]=roipoly(datas.image);
    posmask=poly2mask(x,y,size(datas.image,1),size(datas.image,2));
    [x1,y1,BW,x,y]=roipoly(datas.image);
    negmask=poly2mask(x,y,size(datas.image,1),size(datas.image,2));
    totmask=(double(posmask).*(1-double(negmask)));
end

    try
        plot(xch,ych,'linewidth',4)
        plot(xre,yre,'linewidth',4)
        plot(xc,yc)
        plot(xl,yl)
        plot(xr,yr)
        scatter(xl,yl)
        scatter(xc,yc)
        scatter(xr,yr)
    catch
        disp('choice zone')
        [x1,y1,BW,xch,ych]=roipoly(datas.image);
        choicemask=poly2mask(xch,ych,size(datas.image,1),size(datas.image,2));
        disp('reward zone')
        [x1,y1,BW,xre,yre]=roipoly(datas.image);
        rewmask=poly2mask(xre,yre,size(datas.image,1),size(datas.image,2));
        clf
        imagesc(datas.image)
        hold on
        plot(xch,ych,'linewidth',4)
        plot(xre,yre,'linewidth',4)
        disp('long spots 20')
        [xl,yl]=ginput;
        clf
        imagesc(datas.image)
        hold on
        plot(xch,ych,'linewidth',4)
        plot(xre,yre,'linewidth',4)
        disp('short spots 15')
        [xc,yc]=ginput;
        clf
        imagesc(datas.image)
        hold on
        plot(xch,ych,'linewidth',4)
        plot(xre,yre,'linewidth',4)
        disp('return spots 15')
        [xr,yr]=ginput;
        clf
        colormap gray
        subplot(121)
        imagesc(datas.image);
        subplot(122)
        imagesc(double(datas.image).*double(totmask));
        hold on
        plot(xc,yc)
        plot(xl,yl)
        plot(xr,yr)
        scatter(xl,yl)
        scatter(xc,yc)
        scatter(xr,yr)
        plot(xch,ych,'linewidth',4)
        plot(xre,yre,'linewidth',4)
        
    end
    sat=0;
    cd ..
    save(strcat(fname,'_analysis.mat'),'xc','yc','yl','xl','xr','yr','xch','ych','xre','yre','totmask','rewmask','choicemask')
    check_tracking(fname,0.1);
    sat=input('Are you statisfied? O:no/1:yes');
    BW_threshold=0.22;
    smaller_object_size=40;
    if sat==0
        position=retrack(fname,BW_threshold,smaller_object_size,totmask);
    else
        position=extractpos(fname,totmask);
        
    end

    vitesse(3,:)=position(3,:);
    vitesse(1,2:end)=(position(1,2:end)-position(1,1:end-1))./(position(3,2:end)-position(3,1:end-1));
    vitesse(2,2:end)=(position(2,2:end)-position(2,1:end-1))./(position(3,2:end)-position(3,1:end-1));
    vitesse(4,2:end)=sqrt(vitesse(1,2:end).^2+vitesse(2,2:end).^2);
        save(strcat(fname,'_analysis.mat'),'position','vitesse','-append')

        
    disp('Left or Right turns')
    [position,st,tsh,tlo,rthenl,lthenr,uniqpos]=LocatePts(position,choicemask,rewmask,xc,yc,xl,yl,xr,yr);
            
    save(strcat(fname,'_analysis.mat'),'position','st','tsh','tlo','tch','rthenl','lthenr','uniqpos','-append')

    figure
    imagesc(datas.image)
    hold on
    scatter(position(1,position(5,:)==1),position(2,position(5,:)==1),'c','filled')
    scatter(position(1,position(5,:)==2),position(2,position(5,:)==2),'k','filled')
    scatter(position(1,position(5,:)==3),position(2,position(5,:)==3),'r','filled')
    scatter(position(1,position(5,:)==4),position(2,position(5,:)==4),'b','filled')
    scatter(position(1,position(5,:)==5),position(2,position(5,:)==5),'y','filled')
    colormap gray
    
    %direction
    disp('looking at direction')
    [t1,d1,t1b,d1b,t2,d2,t2b,d2b,t2c,d2c]=get_direction(position,xl,yl,xc,yc,xr,yr,choicemask,rewmask,fname);
    
    [Y,X]=hist(d1,50);
    [Yb,Xb]=hist(d1b,50);
    figure
    plot(X,Y/sum(Y),'linewidth',3,'color','r')
    hold on
    plot(Xb,Yb/sum(Yb),'g','linewidth',3)
    scatter(nanmedian(d1),max(Y/sum(Y))*0.8,120,'k','filled')
    scatter(nanmedian(d1b),max(Y/sum(Y))*0.8,120,'k','filled')
    scatter(nanmedian(d1),max(Y/sum(Y))*0.8,50,'r','filled')
    scatter(nanmedian(d1b),max(Y/sum(Y))*0.8,50,'g','filled')
    legend('right way','wrongway')
    xlabel('distance run')
    
    %speeds
    vitesse(4,vitesse(4,:)<10)=NaN;
    [Y1,X1]=hist(vitesse(4,position(5,:)==1),70);
    [Y2,X2]=hist(vitesse(4,position(5,:)==2),150);
    [Y3,X3]=hist(vitesse(4,position(5,:)==3),150);
    [Y4,X4]=hist(vitesse(4,position(5,:)==4),50);
    [Y5,X5]=hist(vitesse(4,position(5,:)==5),150);
    figure
    plot(X1,Y1/sum(Y1),'linewidth',3,'color','C')
    hold on
    plot(X2,Y2/sum(Y2),'linewidth',3,'color','k')
    plot(X3,Y3/sum(Y3),'linewidth',3,'color','r')
    plot(X4,Y4/sum(Y4),'linewidth',3,'color','b')
    plot(X5,Y5/sum(Y5),'linewidth',3,'color','y')
    xlim([0 600])
    scatter(nanmedian(vitesse(4,position(5,:)==1)),max(Y3/sum(Y3))*0.8,120,'k','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==2)),max(Y3/sum(Y3))*0.8,120,'k','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==3)),max(Y3/sum(Y3))*0.8,120,'k','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==4)),max(Y3/sum(Y3))*0.8,120,'k','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==5)),max(Y3/sum(Y3))*0.8,120,'k','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==1)),max(Y3/sum(Y3))*0.8,50,'c','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==2)),max(Y3/sum(Y3))*0.8,50,'k','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==3)),max(Y3/sum(Y3))*0.8,50,'r','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==4)),max(Y3/sum(Y3))*0.8,50,'b','filled')
    scatter(nanmedian(vitesse(4,position(5,:)==5)),max(Y3/sum(Y3))*0.8,50,'y','filled')
    legend('short','long','return','choice','reward')
    xlabel('speed')
    
figure
imagesc(double(datas.image(:,:,1)).*double(totmask));
unfreezeColors
colormap gray
freezeColors
hold on
scatter(position(1,:),position(2,:),10,vitesse(6,:),'filled')
colormap jet
caxis([0 300])

figure
subplot(121)
a=[position(2,:)',position(1,:)'];    
carte = carteOccupation(a,[80,80],[40 240;0 350]);
imagesc(log(carte))
subplot(122)
mn=mean2D(position(2,:),position(1,:),vitesse(6,:),80,80,[240 40],[350 0]);
imagesc(mn)
colormap hot



    choicetime=position(5,:)==4;
    dchoicetime=diff(choicetime);
    zeroind=find(dchoicetime);
    for i=1:floor(length(zeroind)/2)
        tchoice(i)=zeroind(2*i+1)-zeroind(2*i);
    end
    tchoice=[tchoice;[1:length(tchoice)]];
    tc=sortrows(tchoice');
    
   
    
    
    %Look at zones and position
%     cd(fname)
    direct=dir;
    framenum=size(direct,1)-3;
    nx = 32;
    ny = 24;
    % try
    % clear position vitesse
    % end
    figure(32)
    % clear position vitesse
    start = 1;
    cols=[0,0,1;0,1,0;1,0,0;0.5,0.5,0.5;1,1,1];
    for i=start:framenum
        eval(strcat('load(''',direct(2+i).name,''')'))
        imagesc(datas.image)
        axis image
        colormap gray
%         hold on
%         if isnan(position(1,i-start+1))==0
%             plot(position(1,i-start+1),position(2,i-start+1), '.','color',cols(position(5,i),:))
%         else
%             plot(1,1,'g.')
%         end
        pause(0.01)
        clf
    end
