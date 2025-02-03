
function [FinalEpoch,X,Y,Modif]=controlEpochML(filename,POS,ref_im,list)

% [FinalEpoch,X,Y,Modif]=controlEpoch(filename,POS,list,ref_im)
% filename = name.avi
% POS = position file
% list (optional) = list of good subset GoodEpoch
% ref_im (optional) = image of reference

%% Determine Quantif Explo Epochs

X=tsd(POS(:,1)*1E4,POS(:,2));
Y=tsd(POS(:,1)*1E4,POS(:,3));


eval(['load ',filename])

Pos=Pos(1:end-7,:);


if length(Pos)~=length(POS)
    
    disp('problem')
    FinalEpoch=[];
    X=[];
    Y=[];
    Modif=[];
else
    
    
    th=0.95;
    smogood=10;
    goodvalue=tsd(POS(:,1)*1E4,SmoothDec(Pos(:,4),smogood));
    GoodEpoch=thresholdIntervals(goodvalue, th,'Direction','Above');
    GoodEpoch=mergeCloseIntervals(GoodEpoch,5*1E4);% to check
    % GoodEpoch=dropshortIntervals(GoodEpoch,15*1E4); % to check
    % GoodEpoch=droplongIntervals(GoodEpoch,50*1E4);  % to check
    
    
    figure('Color',[1 1 1]), hold on
    num1=gcf;
    plot(POS(:,1),Pos(:,4),'color',[0.7 0.7 0.7])
    plot(POS(:,1),Data(goodvalue),'k','linewidth',2)
    yl=ylim;
    xl=xlim;
    line([Start(GoodEpoch,'s') Start(GoodEpoch,'s')],yl,'color','g','linewidth',3)
    line([End(GoodEpoch,'s') End(GoodEpoch,'s')],yl,'color','r','linewidth',3)
    line(xl,[th th],yl,'color','b')
    
    
    title([filename(27:end-9),' nombre d''essai : ',num2str(length(Start(GoodEpoch)))])
    
    oki=input('Seuils ok ? (o/n) : ','s');
    
    while strcmp(oki,'n')
        
        th=input(['seuil (default value ',num2str(th),') :']);
        smogood=input(['smoothing (default value ',num2str(smogood),') :']);
        
        goodvalue=tsd(POS(:,1)*1E4,SmoothDec(Pos(:,4),smogood));
        GoodEpoch=thresholdIntervals(goodvalue, th,'Direction','Above');
        GoodEpoch=mergeCloseIntervals(GoodEpoch,5*1E4);% to check
        %     GoodEpoch=dropshortIntervals(GoodEpoch,15*1E4); % to check
        %     GoodEpoch=droplongIntervals(GoodEpoch,50*1E4);  % to check
        
        
        figure(num1), clf, hold on
        plot(POS(:,1),Pos(:,4),'color',[0.7 0.7 0.7])
        plot(POS(:,1),Data(goodvalue),'k','linewidth',2)
        yl=ylim;
        xl=xlim;
        line([Start(GoodEpoch,'s') Start(GoodEpoch,'s')],yl,'color','g','linewidth',3)
        line([End(GoodEpoch,'s') End(GoodEpoch,'s')],yl,'color','r','linewidth',3)
        line(xl,[th th],yl,'color','b')
        title([filename(27:end-9),' nombre d''essai : ',num2str(length(Start(GoodEpoch)))])
        
        oki=input('Seuils ok ? (o/n) : ','s');
    end
    
    
    ch=input('liste des bons essai?');
    
    Temp=GoodEpoch;
    clear GoodEpoch
    b=1;
    for i=ch
        tt=subset(Temp,i);
        tps(b,1)=Start(tt);
        tps(b,2)=End(tt);
        b=b+1;
    end
    
    
    GoodEpoch=intervalSet(tps(:,1),tps(:,2));
    
    figure(num1), clf, hold on
    plot(POS(:,1),Pos(:,4),'color',[0.7 0.7 0.7])
    plot(POS(:,1),Data(goodvalue),'k','linewidth',2)
    yl=ylim;
    xl=xlim;
    line([Start(GoodEpoch,'s') Start(GoodEpoch,'s')],yl,'color','g','linewidth',3)
    line([End(GoodEpoch,'s') End(GoodEpoch,'s')],yl,'color','r','linewidth',3)
    line(xl,[th th],yl,'color','b')
    title([filename(27:end-9),' nombre d''essai : ',num2str(length(Start(GoodEpoch)))])
    
    

    
    
    Xr=Restrict(X,GoodEpoch);
    Yr=Restrict(Y,GoodEpoch);
    
    figure('Color',[1 1 1]), hold on
    num=gcf;
    
    try
        list;
    catch
        list=[1:length(Start(GoodEpoch))];
    end
    a=1;

    %% affine start and stop time for each trial
    figure('Color',[1 1 1]); numRef=gcf; StartPoints=[];
    inni=0;
    
    for i=list
        ok='n';
        
        subepoch=subset(GoodEpoch,i);
        st=Start(subepoch)-10E4;
        en=End(subepoch)+10E4;
        st(st<0)=0;
        bandEpoch=intervalSet(st,en);
        
        % image ref
        figure(numRef), imagesc(ref_im); axis xy;
        hold on, plot(Data(Restrict(X,bandEpoch)),Data(Restrict(Y,bandEpoch)),'Color',[0.7 0.7 0.7])
        title('Ref Image and position for subEpoch');
            xl_ref=xlim;
            yl_ref=ylim;
        if ~isempty(StartPoints), 
            hold on, plot(StartPoints(:,1),StartPoints(:,2),'ko','markerfacecolor','k','linewidth',5)
        end
        
        while ~strcmp(ok,'o')
            figure(num), hold on,
            
            plot(Data(Restrict(X,bandEpoch)),Data(Restrict(Y,bandEpoch)),'Color',[0.7 0.7 0.7])
            scatter(Data(Restrict(X,bandEpoch)),Data(Restrict(Y,bandEpoch)),20,Range(Restrict(Y,bandEpoch),'s'),'filled'), colorbar
            plot(Data(Restrict(X,subepoch)),Data(Restrict(Y,subepoch)),'b')
            Xsub=Data(Restrict(X,subepoch));
            Ysub=Data(Restrict(Y,subepoch));
            tsub=Range(Restrict(X,subepoch));
            
            plot(Xsub(1),Ysub(1),'ko','markerfacecolor','k','linewidth',5)
            plot(Xsub(end),Ysub(end),'ro','markerfacecolor','r','linewidth',5)
            title([filename(27:end-9),' essai ',num2str(a),',  temps essai :',num2str(tsub(end)/1E4-tsub(1)/1E4),' s'])
            xlim(xl_ref)
            ylim(yl_ref)
            
            %ok=input('Les extremites sont-elles ok? (o/n) : ','s');
                deb=input('changer le debut (+/- sec) : ');
                
                fin=input('changer la fin (+/- sec) : ');
                
                if deb==[]
                    deb=0;
                end
                
                if fin==[]
                    fin=0;
                end
                
                Xdeb=Data(Restrict(X,ts(tsub(1)+deb*1E4)));
                Ydeb=Data(Restrict(Y,ts(tsub(1)+deb*1E4)));
                Xfin=Data(Restrict(X,ts(tsub(end)+fin*1E4)));
                Yfin=Data(Restrict(Y,ts(tsub(end)+fin*1E4)));
                
                newbandEpoch=intervalSet(tsub(1)+deb*1E4-10E4,tsub(end)+fin*1E4+10E4);
                newsubepoch=intervalSet(Start(subepoch)+deb*1E4,Stop(subepoch)+fin*1E4);
                figure(num), hold on,
                plot(Data(Restrict(X,newbandEpoch)),Data(Restrict(Y,newbandEpoch)),'Color',[0.7 0.7 0.7])
                plot(Data(Restrict(X,newsubepoch)),Data(Restrict(Y,newsubepoch)),'b')
                plot(Xdeb,Ydeb,'bo','markerfacecolor','b','linewidth',5)
                plot(Xfin,Yfin,'go','markerfacecolor','g','linewidth',5)
                title([filename(27:end-9),' essai ',num2str(a),',  temps essai :',num2str(tsub(end)/1E4+fin-(tsub(1)/1E4+deb)),' s'])
                ok=input('Les extremites sont-elles ok? (o/n) : ','s');
                
                figure(num),clf, hold on
                
                StartPoints(i,1:2)=[Xdeb,Ydeb];
            
        end
        
        Modif(a,1)=i;
        Modif(a,2)=deb;
        Modif(a,3)=fin;
        a=a+1;

    end
    
    close (numRef);
    
    %plot(Data(Xr),Data(Yr),'k','linewidth',2)
    
    Final=[];
    
    
    for j=1:length(Start(GoodEpoch))
        
        subepoch=subset(GoodEpoch,j);
        if ismember(j,Modif(:,1));
            Final=[Final;[Start(subepoch)+Modif(j,2)*1E4,End(subepoch)+Modif(j,3)*1E4]];
        else
            Final=[Final; [Start(subepoch),End(subepoch)]];
        end
        
    end
    
    FinalEpoch=intervalSet(Final(:,1),Final(:,2));
    
    
    figure(num),clf, hold on
    
    for i=list
        
        
        subepoch=subset(FinalEpoch,i);
        
        st=Start(subepoch)-10E4;
        en=End(subepoch)+10E4;
        st(st<0)=0;
        
        bandEpoch=intervalSet(st,en);
        
        plot(Data(Restrict(X,bandEpoch)),Data(Restrict(Y,bandEpoch)),'Color','r')
        plot(Data(Restrict(X,subepoch)),Data(Restrict(Y,subepoch)),'b')
        Xsub=Data(Restrict(X,subepoch));
        Ysub=Data(Restrict(Y,subepoch));
        plot(Xsub(1),Ysub(1),'bo','markerfacecolor','b','linewidth',5)
        plot(Xsub(end),Ysub(end),'ro','markerfacecolor','r','linewidth',5)
        xlim(xl_ref)
        ylim(yl_ref)
        
    end
    
    close(num1)
    
    % PosTemp(:,1)=Data(Restrict(X,FinalEpoch);
    % PosTemp(:,2)=Data(Restrict(Y,FinalEpoch);
    %
    % [PosC,speed]=RemoveArtifacts(PosTemp,Art);
    %
    % X=tsd(PosC(:,1),PosC(:,2));
    % Y=tsd(PosC(:,1),PosC(:,3));
    
end

