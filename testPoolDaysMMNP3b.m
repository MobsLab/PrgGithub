% testPoolDaysMMNP3b

if 1
    
        th=3000;
        pval=0.05;

        W1=2;
        W2=3;
        W3=1;

        load matVal1
        M=matVal;

        load matVal2
        M2=matVal;

        rg=Range(matVal{1,1});
        rg=rg(1:1499);

        for i=1:16
            for j=1:10
                temp1=Data(M{i,j});
                temp2=Data(M2{i,j});

                a=1;
                for k=1:size(temp1,2)
                    try
                    if length(find(abs(temp1(:,a))>th))>5
                        temp1(:,a)=[];  
                    else
                        a=a+1;  
                    end

                    end
                end

                a=1;
                for k=1:size(temp2,2)
                try
                    if length(find(abs(temp2(:,a))>th))>5
                        temp2(:,a)=[];    
                    else
                    a=a+1;
                    end
                end
                end
                    temp1=temp1(1:1499,:);
                    temp2=temp2(1:1499,:);
                    try

                        mmin=135;
                        mmax=140;
                        mmin2=150;
                        mmax2=160;
                        
                    [BE,id]=sort(mean(temp1(mmin2:mmax2,:)-temp1(mmin:mmax,:)));
                    
                    if mean(temp1(mmin2:mmax2,id(1))-temp1(mmin:mmax,id(1)))<mean(temp1(mmin2:mmax2,id(end))-temp1(mmin:mmax,id(end)))
%                     if mean(temp1(mmin:mmax,id(1)))>mean(temp1(mmin:mmax,id(end))) 
                        temp1=temp1(:,id(floor(W1*length(id)/W2):end));
                    else
                        temp1=temp1(:,id(1:floor(W3*length(id)/W2)));
                    end

                    clear id

%                       [BE,id]=sort(mean(temp2(mmin:mmax,:)));
                    [BE,id]=sort(mean(temp2(mmin2:mmax2,:)-temp2(mmin:mmax,:)));
                    
                    if mean(temp2(mmin2:mmax2,id(1))-temp2(mmin:mmax,id(1)))<mean(temp2(mmin2:mmax2,id(end))-temp2(mmin:mmax,id(end)))
                        
%                     if mean(temp2(mmin:mmax,id(1)))>mean(temp2(mmin:mmax,id(end))) 
                        temp2=temp2(:,id(floor(W1*length(id)/W2):end));
                    else
                        temp2=temp2(:,id(1:floor(W3*length(id)/W2)));
                    end

                    end



                Mt{i,j}=tsd(rg,[temp1,temp2]);
            end
        end

        clear matVal

        matVal=Mt;



        i=16;


end


 figure(1),clf, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'g','linewidth',1)
    hold on, title(['effet LOCAL: FreqAAAAA (K) vs FreqBBBBA (R)      +  freqBBBBB (G) - channeln° ',num2str(i)]) 
    hold on, axis([-100 1100 -1000 800])
    for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
    end
    [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,3},matVal{i,1}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  
    
    [h,p]=ttest2(Data(matVal{i,2})',Data(Restrict(matVal{i,3},matVal{i,2}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,400, 500);
    hold on, plot(rg(p<pval),pr(p<pval),'gx')  
    
    
    %----------------------------------------------------------------------
    % Effet Local Deviant B
    %----------------------------------------------------------------------    
    figure(2),clf, plot(Range(matVal{i,2},'ms'),mean(Data(matVal{i,2})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
    end
    hold on, title(['effet LOCAL: FreqBBBBB vs FreqAAAAB     +  freqAAAAA - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1000 800])
    [h,p]=ttest2(Data(matVal{i,2})',Data(Restrict(matVal{i,4},matVal{i,2}))');
    rg=Range(matVal{i,2},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  
    
    [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,4},matVal{i,1}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,400, 500);
    hold on, plot(rg(p<pval),pr(p<pval),'gx')  
    
    
    %----------------------------------------------------------------------
    % Effet Global Deviant A
    %----------------------------------------------------------------------    
    figure(3),clf, plot(Range(matVal{i,3},'ms'),mean(Data(matVal{i,3})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,5},'ms'),mean(Data(matVal{i,5})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
    end
    hold on, title(['effet GLOBAL: FreqBBBBA vs RareBBBBA  +  freqBBBBB - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1000 800])
    
    [h,p]=ttest2(Data(matVal{i,3})',Data(Restrict(matVal{i,5},matVal{i,3}))');
    rg=Range(matVal{i,2},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  
    
    [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,3},matVal{i,1}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,400, 500);
    hold on, plot(rg(p<pval),pr(p<pval),'gx')  
    
    %----------------------------------------------------------------------
    % Effet Global Deviant B
    %---------------------------------------------------------------------- 
    figure(4),clf, plot(Range(matVal{i,4},'ms'),mean(Data(matVal{i,4})'),'k','linewidth',2)
    hold on, plot(Range(matVal{i,6},'ms'),mean(Data(matVal{i,6})'),'r','linewidth',2)
    hold on, plot(Range(matVal{i,1},'ms'),mean(Data(matVal{i,1})'),'g','linewidth',1)    
        for a=0:150:600
        hold on, plot(a,min(axis):max(axis),'r','linewidth',10);
    end
    hold on, title(['effet GLOBAL: FreqAAAAB vs RareAAAAB     +  freqAAAAA - channeln°',num2str(i)])
    hold on, axis([-100 1100 -1000 800])  
    [h,p]=ttest2(Data(matVal{i,4})',Data(Restrict(matVal{i,6},matVal{i,4}))');
    rg=Range(matVal{i,2},'ms');
    pr=rescale(p,500, 600);
    hold on, plot(rg(p<pval),pr(p<pval),'bx')  

    [h,p]=ttest2(Data(matVal{i,1})',Data(Restrict(matVal{i,4},matVal{i,1}))');
    rg=Range(matVal{i,1},'ms');
    pr=rescale(p,400, 500);
    hold on, plot(rg(p<pval),pr(p<pval),'gx')      

    
    figure(5),clf, imagesc(Data(matVal{i,5})'), axis xy, hold on,plot(rescale(nanmean(Data(matVal{i,5})'),5, 20),'k','linewidth',1)
    