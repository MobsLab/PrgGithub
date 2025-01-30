%AnalysMultiVar_25022016

%cd /Users/Bench/Dropbox/MOBS_workingON/AnalyseMultivarieMarie
load AnalysMultiVar_25022016

try
    sleepSess;
catch
    sleepSess='REM';
end

try
    ZS;
catch
    ZS=0;
end

id=[[1:7],[12:34],[36:39],41,42,43];

if sleepSess=='REM'
    test=(M251REM(:,id));
    test2=(M244REM(:,id));
elseif sleepSess=='SWS'
    test=(M251N2(:,id));
    test2=(M244N2(:,id));
end

 test(isnan(test))=0;
 test(isinf(test))=0;
 test2(isnan(test2))=0;
 test2(isinf(test2))=0;
 
 if ZS
  test=zscore(test);
  test2=zscore(test2);
 end
%   test(abs(test)>7)=7;

try
    [r,p]=corrcoef(test);
    [V,L]=pcacov(r);
    [BE,pc]=sort(V(:,1));
    figure('color',[1 1 1]), 
    subplot(1,6,1), plot(L,'ko-')
    subplot(1,6,2), plot(V(:,1),'ko-')
    subplot(1,6,3:4),imagesc(r)
    subplot(1,6,5:6),imagesc(r(pc,pc))
catch
    [r,p]=corrcoef(test);    
    r2=r;
    r2([29,32,36],:)=[];
    r2(:,[29,32,36])=[];
    [V,L]=pcacov(r2);
    [BE,pc]=sort(V(:,1));
    figure('color',[1 1 1]), 
    subplot(1,6,1), plot(L,'ko-')
    subplot(1,6,2), plot(V(:,1),'ko-')
    subplot(1,6,3:4),imagesc(r2)
    subplot(1,6,5:6),imagesc(r2(pc,pc))
end



y=(test(:,2:end));
x=(test(:,1));

y2=(test2(:,2:end));
x2=(test2(:,1));

[gl,dev,stats] = glmfit(y,x);
xfit = glmval(gl,y, 'identity');
xfit2 = glmval(gl,y2, 'identity');
figure('color',[1 1 1]), 
subplot(5,3,1), plot(x,xfit,'k.'), title(num2str(floor(1000*sqrt(sum((x-xfit).^2))/length(x))/1000))
subplot(5,3,2), plot(x2,xfit2,'r.'), title(num2str(floor(1000*sqrt(sum((x2-xfit2).^2))/length(x2))/1000))
subplot(5,3,3), plot(stats.beta,'ko-','markerfacecolor','k')

try
[gl,dev,stats] = glmfit(y,x,'poisson','link','log');
xfit = glmval(gl,y, 'log');
xfit2 = glmval(gl,y2, 'log');
subplot(5,3,4), plot(x,xfit,'k.'), title(num2str(floor(1000*sqrt(sum((x-xfit).^2))/length(x))/1000))
subplot(5,3,5), plot(x2,xfit2,'r.'), title(num2str(floor(1000*sqrt(sum((x2-xfit2).^2))/length(x2))/1000))
subplot(5,3,6), plot(stats.beta,'ko-','markerfacecolor','k')
end
try
[gl,dev,stats] = glmfit(y,x,'normal','link','log');
xfit = glmval(gl,y, 'log');
xfit2 = glmval(gl,y2, 'log');
subplot(5,3,7), plot(x,xfit,'k.'), title(num2str(floor(1000*sqrt(sum((x-xfit).^2))/length(x))/1000))
subplot(5,3,8), plot(x2,xfit2,'r.'), title(num2str(floor(100*sqrt(sum((x2-xfit2).^2))/length(x2))/1000))
subplot(5,3,9), plot(stats.beta,'ko-','markerfacecolor','k')
end
try
[gl,dev,stats] = glmfit(y,x,'gamma','link','reciprocal');
xfit = glmval(gl,y, 'reciprocal');
xfit2 = glmval(gl,y2, 'reciprocal');
subplot(5,3,10), plot(x,xfit,'k.'), title(num2str(floor(1000*sqrt(sum((x-xfit).^2))/length(x))/1000))
subplot(5,3,11), plot(x2,xfit2,'r.'), title(num2str(floor(1000*sqrt(sum((x2-xfit2).^2))/length(x2))/1000))
subplot(5,3,12), plot(stats.beta,'ko-','markerfacecolor','k')
end
[h,bi]=hist(x,100);
[h2,bi2]=hist(x2,100);
subplot(5,3,13:15), hold on, plot(bi,h,'k'), plot(bi2,h2,'r')


