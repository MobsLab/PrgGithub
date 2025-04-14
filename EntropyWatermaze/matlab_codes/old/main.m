        %SAVE ALL YOUR different FILESNAMES WITH THE SAME VARIABLE NAME p_xy (if you read/saved
        %your data trhough main_read.m, your alread have it!); that is, if you have
        %data, save it as: save data.mat p_xy,
        %this way the filename=data but when you load it the value is called by p_xy.
        function main
        display('Main program started running:');
        clear all;
        %Group 1 load data
        uiload;
        %Make sure your filename (name of data) is saved as p_xy (variable name). To do this, try: save filename p_xy,
        %rawdata1 has the size of Time x 2 x n where Time is the total
        %time, 2=indicates 2 dimension for (x,y) points and n is
        %the number of animals.
        rawdata1= p_xy;
        %Group 2 load data
        uiload;
        rawdata2=p_xy;
        WMinit;% includes the required constants
        data1=rawdata1*sc;
        data2=rawdata2*sc;
        [Time dum n1]=size(data1); %Time=total time and it should
                                   %be the same for data1 and data2
        [Time dum n2]=size(data2);
        %Quadrant measure (loc=4 means platform is located in the
        %bottom-right side of the tank)
        
        [Q1,Q2]=Q_percents(data1,data2,Xctr,Yctr,loc);
        fprintf('Average percent quadrant for group 1=%.2f and for group 2 is=%.2f\n',mean(Q1),mean(Q2));
        fprintf('Standard deviation percent quadrant for group 1=%.2f and for group 2 is=%.2f\n',std(Q1),std(Q2));
        
        %ttest for quadrant measure 
        [Hyp_Q pval_Q]=ttest2(Q1,Q2,.05);
        fprintf('P-value for Quadrant measure is %f\n',pval_Q);
        
        %Zone measure (Rz=radius of zone)
        [Z1,Z2]=Z_percents(data1,data2,Xp,Yp,Rz);
        fprintf('Average Zone measure for group 1=%.2f and for group 2 is=%.2f\n',mean(Z1),mean(Z2));
        fprintf('Standard deviation of Zone measure for group 1=%.2f and for group 2 is=%.2f\n',std(Z1),std(Z2));
        
        [Hyp_Z pval_Z]=ttest2(Z1,Z2,.05);
        fprintf('P-value for Zone measure is %f\n',pval_Z);
        
        %Crossing measure (5=radius of platform)
        [X1,X2]=Crossings(data1,data2,Xp,Yp,5);
        
        fprintf('Average Crossing measure for group 1=%.2f and for group 2 is=%.2f\n',mean(X1),mean(X2));
        fprintf('Standard deviation of Crossing measure for group 1=%.2f and for group 2 is=%.2f\n',std(X1),std(X2));        
        [Hyp_X pval_X]=ttest2(X1,X2,.05);
        fprintf('P-value for Crossing measure is %f\n',pval_X);
        
        
        %Entropy and Proximity measure, (Entropy=H and Proximity=P)
        [H1, P1]=Final_measure(data1,Xp,Yp); %For data1
        [H2, P2]=Final_measure(data2,Xp,Yp); %For data2
        fprintf('Average Proximity measure for group 1=%.2f and for group 2 is=%.2f\n',mean(P1),mean(P2));
        fprintf('Standard deviation of Proximity measure for group 1=%.2f and for group 2 is=%.2f\n',std(P1),std(P2));
        fprintf('Average Entropy measure for group 1=%.2f and for group 2 is=%.2f\n',mean(H1),mean(H2));
        fprintf('Standard deviation of Entropy measure for group 1=%.2f and for group 2 is=%.2f\n',std(H1),std(H2));
        [Hyp_P pval_P]=ttest2(P1,P2,.05); 
        fprintf('P-value for Proximity measure is %f\n',pval_P); 
        [Hyp_H pval_H]=ttest2(H1,H2,.05);
        fprintf('P-value for Entropy measure is %f\n',pval_H);

        denplot(rawdata1,rawdata2);
        