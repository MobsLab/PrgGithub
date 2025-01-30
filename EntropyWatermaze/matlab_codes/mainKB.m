
function [Q1,Q2,Z1,Z2,X1,X2,H1,P1,H2,P2,p_xy,p_xy2,M1,M2]=mainKB(namefile,a,b)

%SAVE ALL YOUR different FILESNAMES WITH THE SAME VARIABLE NAME p_xy (if you read/saved
%your data trhough main_read.m, your alread have it!); that is, if you have
%data, save it as: save data.mat p_xy,
%this way the filename=data but when you load it the value is
%called by p_xy.
        
        display('Main program started running:');
%         clear all;
        %Group 1 load data
        
%         uiload;
        %load pxy

        
        
            
               WMinit;% includes the required constants
               
               
%         ang=pi/5;
        ang=0;
%         dt=1/30;
     
        
%--------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------


        
        M1=dlmread(namefile(a).name);

        dt=median(diff(M1(:,4)));
        
        for i=1:length(M1)-1
            Vx = (M1(i,1)-M1(i+1,1))/(dt);
            Vy = (M1(i,2)-M1(i+1,2))/(dt);
            Vitesse1(i) = sqrt(Vx^2+Vy^2);
        end;

        Vit1=SmoothDec(Vitesse1',1);
%         M1=M1(Vit1>vitTh,:);
        M1=M1(find(Vit1>vitTh&Vit1<vitArt),:);

        Xrange=[10 230];
        Yrange=[10 230];
        
%         p_xy(:,:,1)=Rotate(M1(:,1:2),ang);
        p_xy(:,:,1)=M1(:,1:2);
        
        p_xy(:,1)=rescale(p_xy(:,1),Xrange(1),Xrange(2));
        p_xy(:,2)=rescale(p_xy(:,2),Yrange(1),Yrange(2));
        
        M2=dlmread(namefile(b).name);
        
        for i=1:length(M2)-1
        Vx = (M2(i,1)-M2(i+1,1))/(dt);
        Vy = (M2(i,2)-M2(i+1,2))/(dt);
        Vitesse2(i) = sqrt(Vx^2+Vy^2);
        end;

        Vit2=SmoothDec(Vitesse2',1);
%         M2=M2(Vit2>vitTh,:);
        M2=M2(find(Vit2>vitTh&Vit2<vitArt),:);        

%         p_xy2(:,:,1)=Rotate(M2(:,1:2),ang);
        p_xy2(:,:,1)=M2(:,1:2);
        
        p_xy2(:,1)=rescale(p_xy2(:,1),Xrange(1),Xrange(2));
        p_xy2(:,2)=rescale(p_xy2(:,2),Yrange(1),Yrange(2));
        
        m1=length(p_xy);
        m2=length(p_xy2);
        
        p_xy=p_xy(1:min(m1,m2),:);
        p_xy2=p_xy2(1:min(m1,m2),:);        

        M1=M1(1:min(m1,m2),:);
        M2=M2(1:min(m1,m2),:); 

        
O=p_xy;
p_xy=[O(:,2) O(:,1)];
O=p_xy2;
p_xy2=[O(:,2) O(:,1)];

%%-------------------------------------------------------------------------------------------------------------------------------------------------


        figure('color',[1 1 1]), 
        subplot(1,2,1), 
        plot(p_xy(:,1),p_xy(:,2),'k')
        hold on, plot(p_xy(M1(:,3)==zon1,1),p_xy(M1(:,3)==zon1,2),'r','linewidth',1)
        hold on, plot(p_xy(M1(:,3)==zon2,1),p_xy(M1(:,3)==zon2,2),'g','linewidth',1)
        hold on, plot(p_xy(M1(:,3)==zon3,1),p_xy(M1(:,3)==zon3,2),'b','linewidth',1)
        hold on, plot(p_xy(M1(:,3)==zon4,1),p_xy(M1(:,3)==zon4,2),'y','linewidth',1)
        title(namefile(a).name)
        
        subplot(1,2,2), 
        plot(p_xy2(:,1),p_xy2(:,2),'k')
        hold on, plot(p_xy2(M2(:,3)==zon1,1),p_xy2(M2(:,3)==zon1,2),'r','linewidth',1)
        hold on, plot(p_xy2(M2(:,3)==zon2,1),p_xy2(M2(:,3)==zon2,2),'g','linewidth',1)
        hold on, plot(p_xy2(M2(:,3)==zon3,1),p_xy2(M2(:,3)==zon3,2),'b','linewidth',1)
        hold on, plot(p_xy2(M2(:,3)==zon4,1),p_xy2(M2(:,3)==zon4,2),'y','linewidth',1)
        title(namefile(b).name)
        

%--------------------------------------------------------------------------------------------------------------------------------------------------
%%--------------------------------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------------------
        %Make sure your filename (name of data) is saved as p_xy (variable name). To do this, try: save filename p_xy,
        %rawdata1 has the size of Time x 2 x n where Time is the total
        %time, 2=indicates 2 dimension for (x,y) points and n is
        %the number of animals.
        rawdata1= p_xy;
        %Group 2 load data

%         uiload;
        %load pxy2
        
        rawdata2=p_xy2;
        
 
        
        
        data1=rawdata1*sc;
        data2=rawdata2*sc;
        [Time dum n1]=size(data1); %Time=total time and it should
                                   %be the same for data1 and data2
        [Time dum n2]=size(data2);
        %Quadrant measure (loc=4 means platform is located in the
        %bottom-right side of the tank)
        
        disp('  ')
        
        [Q1,Q2]=Q_percents(data1,data2,Xctr,Yctr,loc);
        fprintf('Average percent quadrant for group 1=%.2f and for group 2=%.2f\n',mean(Q1),mean(Q2));
%         fprintf('Standard deviation percent quadrant for group 1=%.2f and for group 2 is=%.2f\n',std(Q1),std(Q2));
        
        %ttest for quadrant measure 
        [Hyp_Q pval_Q]=ttest2(Q1,Q2,.05);
%         fprintf('P-value for Quadrant measure is %f\n',pval_Q);
        disp('  ')
        
        %Zone measure (Rz=radius of zone)
        [Z1,Z2]=Z_percents(data1,data2,Xp,Yp,Rz+outZone);
        fprintf('Average Zone measure for group 1=%.2f and for group 2=%.2f\n',mean(Z1),mean(Z2));
%         fprintf('Standard deviation of Zone measure for group 1=%.2f and for group 2 is=%.2f\n',std(Z1),std(Z2));
        
        [Hyp_Z pval_Z]=ttest2(Z1,Z2,.05);
%         fprintf('P-value for Zone measure is %f\n',pval_Z);
        disp('  ')
        
        %Crossing measure (5=radius of platform)
        [X1,X2]=Crossings(data1,data2,Xp,Yp,Rz);
        
        fprintf('Average Crossing measure for group 1=%.2f and for group 2=%.2f\n',mean(X1),mean(X2));
%         fprintf('Standard deviation of Crossing measure for group 1=%.2f and for group 2 is=%.2f\n',std(X1),std(X2));        
        [Hyp_X pval_X]=ttest2(X1,X2,.05);
%         fprintf('P-value for Crossing measure is %f\n',pval_X);
        disp('  ')
        
        %Entropy and Proximity measure, (Entropy=H and Proximity=P)
        [H1, P1]=Final_measure(data1,Xp,Yp); %For data1
        [H2, P2]=Final_measure(data2,Xp,Yp); %For data2

%         temp1=NME(data1);
%         temp2=NME(data2);
%         H1=temp1(2);
%         H2=temp2(2);
        
        fprintf('Average Proximity measure for group 1=%.2f and for group 2=%.2f\n',mean(P1),mean(P2));
%         fprintf('Standard deviation of Proximity measure for group 1=%.2f and for group 2 is=%.2f\n',std(P1),std(P2));
        disp('  ')
        fprintf('Average Entropy measure for group 1=%.2f and for group 2=%.2f\n',mean(H1),mean(H2));
%         fprintf('Standard deviation of Entropy measure for group 1=%.2f and for group 2 is=%.2f\n',std(H1),std(H2));
        disp('  ')
        [Hyp_P pval_P]=ttest2(P1,P2,.05); 
%         fprintf('P-value for Proximity measure is %f\n',pval_P); 
        [Hyp_H pval_H]=ttest2(H1,H2,.05);
%         fprintf('P-value for Entropy measure is %f\n',pval_H);

        denplot(rawdata1,rawdata2);
        
        subplot(1,2,1),
%         title(namefile(a).name)
        title(['Q ',num2str(floor(Q1)),', Z ',num2str(floor(Z1)),', X ',num2str(X1),', H ',num2str(floor(H1*10)/10),', P ',num2str(floor(P1))])
        subplot(1,2,2),
%         title(namefile(b).name)
        title(['Q ',num2str(floor(Q2)),', Z ',num2str(floor(Z2)),', X ',num2str(X2),', H ',num2str(floor(H2*10)/10),', P ',num2str(floor(P2))])
        
        