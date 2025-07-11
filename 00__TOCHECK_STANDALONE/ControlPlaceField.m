
function ControlPlaceField(a,Epoch)


    
       
        load behavResources tpsdeb tpsfin
        %tpsDeb=140;
        %tpsFin=700;

       % tpsDeb=tpsdeb{1};
        %tpsFin=tpsfin{1};

        %Epoch=intervalSet(tpsDeb*1E4,tpsFin*1E4);
        tpsDeb=Start(Epoch,'s');
        tpsFin=End(Epoch,'s');
       
        try 
            cleannnn;
        catch
            cleannnn=1;
        end
        
if 1
        try 
            Epoch;
        catch

            load behavResources V
            rgs=Range(V);
            tpsDeb=rgs(1);
            tpsFin=rgs(end);
            Epoch=intervalSet(rgs(1),rgs(end));
        end

        


        try
            S;
            X;
            Y;
            W;
            S=Restrict(S,Epoch);
            X=Restrict(X,Epoch);
            Y=Restrict(Y,Epoch);
            V=Restrict(V,Epoch);

        catch

            load behavResources
            load SpikeData
            try
                W;
            catch
                load Waveforms
            end


            S=Restrict(S,Epoch);
            X=Restrict(X,Epoch);
            Y=Restrict(Y,Epoch);
            V=Restrict(V,Epoch);

        end

end


if cleannnn

        figure('color',[1 1 1]),
        plot(Data(X),Data(Y))
        title('Delimiter le contour de l''environnement');
        [xMaz,yMaz]=ginput;

        goodEpoch1=thresholdIntervals(X,min(xMaz),'Direction','Above');
        goodEpoch2=thresholdIntervals(X,max(xMaz),'Direction','Below');
        goodEpoch3=thresholdIntervals(Y,min(yMaz),'Direction','Above');
        goodEpoch4=thresholdIntervals(Y,max(yMaz),'Direction','Below');

        goodEpoch=intersect(intersect(goodEpoch1,goodEpoch2),intersect(goodEpoch3,goodEpoch4));

        X=Restrict(X,goodEpoch);
        Y=Restrict(Y,goodEpoch);
        S=Restrict(S,goodEpoch);
        V=Restrict(V,goodEpoch);
        % 
        % Xx=Data(X);
        % Yy=Data(Y);
        % Xx(Xx<=min(xMaz))=min(xMaz);
        % Xx(Xx>=max(xMaz))=max(xMaz);
        % Yy(Yy<=min(yMaz))=min(yMaz);
        % Yy(Yy>=max(yMaz))=max(yMaz);
        % X=tsd(Range(X),Xx-min(xMaz));
        % Y=tsd(Range(Y),Yy-min(yMaz));
        cleannnn=0;

end





try
    a;
   
catch
    a=input('numero du neurone: ');
end

threshold=0.7;

positions=[Range(X,'s') Data(X) Data(Y)];
spikes=Range(S{a},'s');
[fm,st] = FiringMap(positions,spikes);      % firing map for a place cell
%figure('color',[1 1 1]),;PlotColorMap(fm.rate,fm.time);
[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,phf]=PlaceField(S{a},X,Y,'smoothing',3,'size',60);
%figure('color',[1 1 1]),;PlotColorMap(fm.rate,fm.time,'bar','on');

figure('color',[1 1 1]), 
subplot(2,1,1);PlotColorMap(fm.rate,fm.time,'bar','on');
subplot(2,1,2),imagesc(st.field), axis xy, colorbar
title(cellnames{a})



%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

if 0
    

    figure('color',[1 1 1]), hold on
    num=gcf;
    figure(num), hold on, plot(px,py,'k.')




    clear id
    [id,x,y]=selectData;
    try
    if length(id{1})==0
        ID=id{2};
        clear id
        id=ID;
    end
    end
    figure(num), hold on, plot(px(id),py(id),'r.')
    clear id2

    [id2,x2,y2]=selectData;
    try
    if length(id2{1})==0
        ID2=id2{2};
        clear id2
        id2=ID2;
    end
    end

    figure(num), hold on, plot(px(id2),py(id2),'g.')




    wfo=W{a};

    figure('color',[1 1 1]),
    num2=gcf;
    subplot(1,2,1)
    for b=1:size(wfo,2)
    hold on, plot(b*2500+squeeze(wfo(id,b,:))','k')
    end
    yl1=ylim;


    figure(num2)
    subplot(1,2,2)
    for b=1:size(wfo,2)
    hold on, plot(b*2500+squeeze(wfo(id2,b,:))','k')
    end

    yl2=ylim;

    figure(num2)
    subplot(1,2,1), ylim([min(yl1(1),yl2(1)), max(yl1(2),yl2(2))])
    subplot(1,2,2), ylim([min(yl1(1),yl2(1)), max(yl1(2),yl2(2))])

end



%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

if 1
    


wfo=W{a};
rg=Range(S{a});
wfo=wfo(find((rg>tpsDeb*1E4&rg<tpsFin*1E4)),:,:);



    
    [MM,m]=sort(mean(squeeze(wfo(:,:,14))));
    numCh=m(1);
    numCh2=m(2);
    
    numCh3=m(3);
    numCh4=m(4);
    
test=squeeze(wfo(:,numCh,:));
test2=squeeze(wfo(:,numCh2,:));
test3=squeeze(wfo(:,numCh3,:));
test4=squeeze(wfo(:,numCh4,:));

[m,idx]=sort(test(:,14)');




figure('color',[1 1 1]),

subplot(2,4,1),hold on,
plot(mean(test(idx(1:length(idx)/3),:)),'k')
plot(mean(test(idx(end-length(idx)/3:end),:)),'r')
title(num2str(numCh))

subplot(2,4,2),hold on,
plot(mean(test2(idx(1:length(idx)/3),:)),'k')
plot(mean(test2(idx(end-length(idx)/3:end),:)),'r')
title(num2str(numCh2))

subplot(2,4,3),hold on,
plot(mean(test3(idx(1:length(idx)/3),:)),'k')
plot(mean(test3(idx(end-length(idx)/3:end),:)),'r')
title(num2str(numCh3))

subplot(2,4,4),hold on,
plot(mean(test4(idx(1:length(idx)/3),:)),'k')
plot(mean(test4(idx(end-length(idx)/3:end),:)),'r')
title(num2str(numCh4))




subplot(2,4,5),hold on,
plot(test(idx(1:length(idx)/3),:)','k')
plot(3000+test(idx(end-length(idx)/3:end),:)','r')

subplot(2,4,6),hold on,
plot(test2(idx(1:length(idx)/3),:)','k')
hold on, plot(3000+test2(idx(end-length(idx)/3:end),:)','r')

subplot(2,4,7),hold on,
plot(test3(idx(1:length(idx)/3),:)','k')
hold on, plot(3000+test3(idx(end-length(idx)/3:end),:)','r')

subplot(2,4,8),hold on,
plot(test4(idx(1:length(idx)/3),:)','k')
hold on, plot(3000+test4(idx(end-length(idx)/3:end),:)','r')



rg=Range(S{a});
rg=rg(rg>tpsDeb*1E4&rg<tpsFin*1E4);


rgA=ts(sort(rg(idx(1:length(idx)/3))));
rgB=ts(sort(rg(end-length(idx)/3:end)));

pxA =Data(Restrict(X,rgA,'align','closest'));
pyA =Data(Restrict(Y,rgA,'align','closest'));

pxB =Data(Restrict(X,rgB,'align','closest'));
pyB =Data(Restrict(Y,rgB,'align','closest'));


figure('color',[1 1 1]),
subplot(3,1,1),
plot(Data(X),Data(Y),'color',[0.9 0.9 0.9])
hold on, plot(px,py,'.','color',[0.7 0.7 0.7])
hold on, plot(pxA,pyA,'k.')
hold on, plot(pxB,pyB,'r.')
title(cellnames{a})


subplot(3,1,2),
plot(Data(X),Data(Y),'color',[0.9 0.9 0.9])
hold on, plot(px,py,'.','color',[0.7 0.7 0.7])
hold on, plot(pxA,pyA,'k.')


subplot(3,1,3),
plot(Data(X),Data(Y),'color',[0.9 0.9 0.9])
hold on, plot(px,py,'.','color',[0.7 0.7 0.7])
hold on, plot(pxB,pyB,'r.')


end



