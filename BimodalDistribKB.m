function [h,x,f,h1,x1,f1,h2,x2,f2]=BimodalDistribKB(X,n)


try
    n;
catch
    if length(find(X<0))==0
        n=max(X)+max(X)/10;
        m=-max(X)/10;
    else
    n=max(abs(X))+max(abs(X))/10;
    m=n;
    end
end


[c,s]=kmeans(X,2);
amplUp=abs(c(1)-c(2));

Bins=[-m:2*n/50:n];
[h,x]=hist(X,Bins);
[h2,x2]=hist(X(s==2),Bins);
[h1,x1]=hist(X(s==1),Bins);


%[h,x]=hist(X,50);
%[h2,x2]=hist(X(s==2),50);
%[h1,x1]=hist(X(s==1),50);

Clu1m=mean(X(s==1));
Clu1s=std(X(s==1));
Clu2m=mean(X(s==2));
Clu2s=std(X(s==2));

f1 = gauss_distribution(x1, Clu1m,Clu1s);
f2 = gauss_distribution(x2, Clu2m,Clu2s);
f = gauss_distribution(x, mean(X),std(X));

s=2;
h=smooth(h,s);
h1=smooth(h1,s);
h2=smooth(h2,s);
f=smooth(f,s);
f1=smooth(f1,s);
f2=smooth(f2,s);

[HBimod,PBimod]=kstest2(h,f1/sum(f1)*sum(h1)+f2/sum(f)*sum(h1));
[HUnimod,PUnimod]=kstest2(h,f/sum(f)*sum(h));


% figure, 
% hold on, bar(x,h,1,'k')
% plot(x,f/sum(f)*sum(h),'b','linewidth',2)
% hold on, plot(x1,f1/sum(f1)*sum(h1),'r','linewidth',2)
% hold on, plot(x2,f2/sum(f2)*sum(h2),'g','linewidth',2)

figure('Color',[1 1 1]), 
hold on, bar(x,h/sum(h),1,'k')
plot(x,f/sum(f),'b','linewidth',2)
hold on, plot(x1,f1/sum(f1)*sum(h1)/sum(h),'r','linewidth',2)
hold on, plot(x2,f2/sum(f2)*sum(h2)/sum(h),'g','linewidth',2)
hold on, plot(unique([x1,x2]),f1/sum(f1)*sum(h1)/sum(h)+f2/sum(f2)*sum(h2)/sum(h),'y','linewidth',2)

ylabel('Percentage')
title(['p unimodal: ', num2str(PUnimod),',  p bimodal: ', num2str(PBimod)])







