function RP = occupationVSdecoding(dirAnalysis, dur)

    eval(['cd ',dirAnalysis])

    load('DataDoAnalysisFor1mouse.mat')
    eval(['load DataPred',num2str(dur)])

    binS=[0.01:0.02:0.99];
    
    LinearPredTsd = eval(['LinearPredTsd',num2str(dur)]);
    LinearTrueTsd = eval(['LinearTrueTsd',num2str(dur)]);

    [h1h,b1h]=hist(Data(Restrict(LinearPredTsd,hab)),binS);
    [h2h,b2h]=hist(Data(Restrict(LinearTrueTsd,hab)),binS);
    
    [h1post,b1post]=hist(Data(Restrict(LinearPredTsd,testPost)),binS);
    [h2post,b2post]=hist(Data(Restrict(LinearTrueTsd,testPost)),binS);

    [h1,b1]=hist(Data(Restrict(LinearPredTsd,condi)),binS);
    [h2,b2]=hist(Data(Restrict(LinearTrueTsd,condi)),binS);

%     figure
%     subplot(2,2,1), hold on, plot(b1h,h1h), plot(b2h,h2h)
%     subplot(2,2,2), hold on, plot(b1,h1), plot(b2,h2)
% 
%     subplot(2,2,3), hold on, plot(b1h,h1h/max(h1h)), plot(b2h,h2h/max(h2h))
%     subplot(2,2,4), hold on, plot(b1,h1/max(h1)), plot(b2,h2/max(h2))

    [r,p]=corrcoef(h1,h2);
    [rh,ph]=corrcoef(h1h,h2h);
    [rpost,ppost]=corrcoef(h1post,h2post);
    RP(1) = rh(2);
    RP(2) = ph(2);
    RP(3) = r(2);
    RP(4) = p(2);
    RP(5) = rpost(2);
    RP(6) = ppost(2);
end

