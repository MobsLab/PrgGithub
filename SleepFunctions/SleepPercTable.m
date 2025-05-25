function Table=SleepPercTable(bin,samplenb,thtps,thdet)


mousenames={'516','520','522'};

for j=1:size(mousenames,2)
    
    filename=['cond_' mousenames{j} '-1'];
    load ([ filename '.mat']);

    for i=1:samplenb

        %debut &limit : temporal window in seconds
        debut=1+(i-1)*bin;
        limit=i*bin;
        if i==9
            limit=520;
        end
        %on multiplie par 6 car il y a 6 points de mesure par seconde 
        deb=1+(debut-1)*6;
        lim=limit*6;

        B=A(1,deb:lim);
        t1=t(1,deb:lim);

        dur=round(t1(end)-t1(1));
        Btsd=tsd(t1*1E4',SmoothDec(B',1));

        try
            thdet;
        catch    
            [c,s]=kmeans(B,2);
            thdet=mean(B(s==1))+std(B(s==1));
        end

        idFr=find(B<thdet);

        Sleep=thresholdIntervals(Btsd,thdet,'Direction','Below');
        Sleep2=dropShortIntervals(Sleep,thtps*1E4);

        PercF=sum(End(Sleep2,'s')-Start(Sleep2,'s'))/dur*100;
        thF=thdet;

        Table(j,i)=PercF;
    end
end

    
% Msavefile=[cd '\' filename '_' num2str(debut) '-' num2str(limit) '.mat'];
% save (Msavefile, 'B', 't1', 'Btsd', 'PercF', 'thF');





% %PLOT THE DATA
% [hh1,kk1]=hist(B(s==1),50);
% [hh2,kk2]=hist(B(s==2),50);
% figure, bar(kk1,hh1,'k');
% hold on, bar(kk2,hh2,'r');


% %SAVE THE DATA
% filename=filename(1:(end-4));
% cd=['C:\Program Files\MATLAB\R2008a\work\zJu\' exp_name];
% 
% Msavefile=[cd '\' analysis '_' filename  '.mat'];
% save (Msavefile, 'A', 't', 'Atsd', 'Perc', 'Sleep', 'Sleep2', 'idFr',
% 'th');