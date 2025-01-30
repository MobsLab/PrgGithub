function [PercIn,PercOut,PercInb,PercOutb,m1,m2,m1b,m2b,SiPF,SiPFb,SiGlob,A,PercInCtrl,PercOutCtrl,PercInCtrlb,PercOutCtrlb,m1Ctrl,m2Ctrl,m1bCtrl,m2bCtrl,SiPFCtrl,SiPFbCtrl,SiGlobCtrl,ACtrl,DelayPF,DelayPFb,DelayPFCtrl,DelayPFbCtrl]=TempVitAngPF(trii,smo,logy)


plo=0;

try
    trii;
catch
    trii=1:4;
end

try
    smo;
catch
    smo=2;
end

try
    logy;
catch
    logy=0;
end


load('MyColormaps','mycmap')
%load AnalyseResourcesICSS 
load behavResources

S=tsdArray({});

load ParametersAnalyseICSS varargin limMaze o M N

try
    
            trii;
            tri=N(trii);
        % catch
        %     tri=N;

        Epoch1=subset(QuantifExploEpoch,tri);

        immobb=0;

        i=1;
           try 
               while immobb==0
                if varargin{i}=='immobility'& varargin{i+1}=='y'
                    immobb=1;
                else
                    immobb=0;
                end
                i=i+1;
               end
           catch
               immobb=0;
           end


           for i=1:length(varargin)-1
              try
                if varargin{i}=='speed'
                    Vth=varargin{i+1};
                end
              end
           end



        %Epoch=thresholdIntervals(V,5,'Direction','Above');

        load AnalyseResourcesICSSLast PF PFb mapS mapSs
        S=tsdArray({});

        clear xMaz
        clear yMaz
        try
           load xyMaxOK xMaz yMaz
            xMaz;
        catch
            load xyMax xMaz yMaz
        end

        [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz,0);

        if immobb
            [S,X,Y,V,Mvt,MvtOK,goEpoch]=RemoveImmobilePosition(S,X,Y,V,Vth,TrackingEpoch,SleepEpoch,RestEpoch);
        end

        X1=Restrict(X,Epoch1);
        Y1=Restrict(Y,Epoch1);


        % 
        % Angl=ComputeInstantaneuousAngle(Data(X),Data(Y));
        % Ang=tsd(Range(X),Angl);
        % Ang=Data(Restrict(Ang,Restrict(V,Restrict(X1,Epoch1))));

        % [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(Restrict(X1,Epoch1)),Data(Restrict(Y1,Epoch1)),50,smo,logy,[0 max(yMaz)-min(yMaz) 0 max(xMaz)-min(xMaz)],plo,1); 
        [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(Restrict(X1,Epoch1)),Data(Restrict(Y1,Epoch1)),50,smo,logy,[ 0 max(xMaz)-min(xMaz) 0 max(yMaz)-min(yMaz)],plo,1); 
        % [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(Restrict(X1,Epoch1)),Data(Restrict(Y1,Epoch1)),50,smo,logy,limM); 

        res=pwd;
        le=length(res);

        if plo
            set(gcf,'Colormap',mycmap)
            title([res(le-16:le),', pre'])
        end



        dee=0;

        tpsPos=Range(Restrict(X1,Epoch1),'s');

        %clear 
        idxY=[];
        %clear 
        idxN=[];

        a=1;b=1;
        for i=1:length(x)
            if PF(round(y(i))+dee,round(x(i))+dee)==1
                idxY(a)=i;
                a=a+1;
                else
                idxN(b)=i;
                b=b+1;
            end
        end
        
        try
        DelayPFCtrl=tpsPos(idxY(1))-tpsPos(1);
        catch
            DelayPFCtrl=60;
        end
        
        

        if plo

            try
                figure('color',[1 1 1]),
                %figure(2),clf
                subplot(2,2,1), imagesc(PF), axis xy, title([res(le-16:le),'pre'])
                hold on, plot(round(x)+dee,round(y)+dee,'w.')
                hold on, plot(round(x(idxY))+dee,round(y(idxY))+dee,'k.')%,'markerfacecolor','k')
                hold on, plot(round(x(1))+dee,round(y(1))+dee,'ko','markerfacecolor','y')
            %     subplot(2,5,2), PlotErrorBar2(paramm(idxY),paramm(idxN),0)
            %     set(gca,'xtick',[1 2])
            %     set(gca,'xticklabel',{'In' 'Out'})
            %     [h1,b1]=hist(paramm(idxY),[0:2:100]);
            %     [h2,b2]=hist(paramm(idxN),[0:2:100]);
            %     subplot(2,5,3),plot(b1,h1,'r','linewidth',2), hold on, plot(b2,h2,'k','linewidth',2), xlim([0 98])
            %     subplot(2,5,4),plot(b1,h1/sum(h1),'r','linewidth',2), hold on, plot(b2,h2/sum(h2),'k','linewidth',2), xlim([0 95])
                subplot(2,2,2),PlotErrorBar2(length(idxY)/(length(idxY)+length(idxN))*100,length(idxN)/(length(idxY)+length(idxN))*100,0)
                set(gca,'xtick',[1 2])
                set(gca,'xticklabel',{'In' 'Out'})
            end

        end



        %clear 
        idxY=[];
        %clear 
        idxN=[];

        a=1;b=1;
        for i=1:length(x)
            if PFb(round(y(i))+dee,round(x(i))+dee)==1
                idxY(a)=i;
                a=a+1;
            else
                idxN(b)=i;
                b=b+1;
            end
        end
        
        try
        DelayPFbCtrl=tpsPos(idxY(1))-tpsPos(1);
        catch
            DelayPFbCtrl=60;
        end

        
        if plo
            try
                subplot(2,2,3), imagesc(PFb), axis xy
                hold on, plot(round(x)+dee,round(y)+dee,'w.')
                hold on, plot(round(x(idxY))+dee,round(y(idxY))+dee,'k.')%,'markerfacecolor','k')
                hold on, plot(round(x(1))+dee,round(y(1))+dee,'ko','markerfacecolor','y')
            %     subplot(2,5,7), PlotErrorBar2(paramm(idxY),paramm(idxN),0)
            %     set(gca,'xtick',[1 2])
            %     set(gca,'xticklabel',{'In' 'Out'})
            %     [h1,b1]=hist(paramm(idxY),[0:2:100]);
            %     [h2,b2]=hist(paramm(idxN),[0:2:100]);
            %     subplot(2,5,8),plot(b1,h1,'r','linewidth',2), hold on, plot(b2,h2,'k','linewidth',2), xlim([0 98])
            %     subplot(2,5,9),plot(b1,h1/sum(h1),'r','linewidth',2), hold on, plot(b2,h2/sum(h2),'k','linewidth',2), xlim([0 95])
                subplot(2,2,4),PlotErrorBar2(length(idxY)/length(x)*100,length(idxN)/length(x)*100,0)
                set(gca,'xtick',[1 2])
                set(gca,'xticklabel',{'In' 'Out'})
            end
        end


        %------------------------------------------------------------------------------------------------------------------------------


        [PercInCtrl,PercOutCtrl,PercInCtrlb,PercOutCtrlb,m1Ctrl,m2Ctrl,m1bCtrl,m2bCtrl,SiPFCtrl,SiPFbCtrl,SiGlobCtrl,ACtrl]=QuantifExploPFControl(PF,PFb,Restrict(X1,Epoch1),Restrict(Y1,Epoch1));


catch

        PercInCtrl=[];
        PercOutCtrl=[];
        PercInCtrlb=[];
        PercOutCtrlb=[];
        m1Ctrl=[];
        m2Ctrl=[];
        m1bCtrl=[];
        m2bCtrl=[];
        SiPFCtrl=[];
        SiPFbCtrl=[];
        SiGlobCtrl=[];
    
end


%------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------



 try
            trii;
            tri=M(trii);
        % % catch
        % %     tri=M;


        Epoch1=subset(QuantifExploEpoch,tri);
        %Epoch=thresholdIntervals(V,5,'Direction','Above');

        load ParametersAnalyseICSS varargin
        load behavResources X Y V

        immobb=0;

        i=1;
           try 
               while immobb==0
                if varargin{i}=='immobility'& varargin{i+1}=='y'
                    immobb=1;
                else
                    immobb=0;
                end
                i=i+1;
               end
           catch
               immobb=0;
           end


           for i=1:length(varargin)-1
              try
                if varargin{i}=='speed'
                    Vth=varargin{i+1};
                end
              end
           end

           try
            load xyMaxOK
           xMaz;
           catch
            load xyMax
           end

        [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz,0);

        if immobb
            [S,X,Y,V,Mvt,MvtOK,goEpoch]=RemoveImmobilePosition(S,X,Y,V,Vth,TrackingEpoch,SleepEpoch,RestEpoch);
        end


        X1=Restrict(X,Epoch1);
        Y1=Restrict(Y,Epoch1);

        vit=Data(Restrict(V,Restrict(X1,Epoch1)));

        % 
        % Angl=ComputeInstantaneuousAngle(Data(X),Data(Y));
        % Ang=tsd(Range(X),Angl);
        % Ang=Data(Restrict(Ang,Restrict(V,Restrict(X1,Epoch1))));


        [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(Restrict(X1,Epoch1)),Data(Restrict(Y1,Epoch1)),50,smo,logy,[0 max(yMaz)-min(yMaz) 0 max(xMaz)-min(xMaz)],plo,1); 
        % [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(Restrict(X1,Epoch1)),Data(Restrict(Y1,Epoch1)),50,smo,logy,limM);

        res=pwd;
        le=length(res);

        if plo
            set(gcf,'Colormap',mycmap)
            title([res(le-16:le),', post'])

        end

        tpsPos=Range(Restrict(X1,Epoch1),'s');

        %clear 
        idxY=[];
        %clear 
        idxN=[];

        a=1;b=1;
        for i=1:length(x)
        if PF(round(y(i))+dee,round(x(i))+dee)==1
        idxY(a)=i;
        a=a+1;
        else
        idxN(b)=i;
        b=b+1;
        end
        end

        try
        DelayPF=tpsPos(idxY(1))-tpsPos(1);    
        catch
        DelayPF=60;
        end
        
        if plo

            try
            figure('color',[1 1 1]),
            %figure(3),clf
            subplot(2,2,1), imagesc(PF), axis xy, title([res(le-16:le),'post'])
            hold on, plot(round(x)+dee,round(y)+dee,'w.')
            hold on, plot(round(x(idxY))+dee,round(y(idxY))+dee,'k.')%,'markerfacecolor','k')
            hold on, plot(round(x(1))+dee,round(y(1))+dee,'ko','markerfacecolor','y')
            % subplot(2,5,2), PlotErrorBar2(paramm(idxY),paramm(idxN),0)
            % set(gca,'xtick',[1 2])
            % set(gca,'xticklabel',{'In' 'Out'})
            % [h1,b1]=hist(paramm(idxY),[0:2:100]);
            % [h2,b2]=hist(paramm(idxN),[0:2:100]);
            % subplot(2,5,3),plot(b1,h1,'r','linewidth',2), hold on, plot(b2,h2,'k','linewidth',2), xlim([0 98])
            % subplot(2,5,4),plot(b1,h1/sum(h1),'r','linewidth',2), hold on, plot(b2,h2/sum(h2),'k','linewidth',2), xlim([0 95])
            subplot(2,2,2),PlotErrorBar2(length(idxY)/length(x)*100,length(idxN)/length(x)*100,0)
            set(gca,'xtick',[1 2])
            set(gca,'xticklabel',{'In' 'Out'})
            end

        end



        %clear 
        idxY=[];
        %clear 
        idxN=[];

        a=1;b=1;
        for i=1:length(x)
        if PFb(round(y(i))+dee,round(x(i))+dee)==1
        idxY(a)=i;
        a=a+1;
        else
        idxN(b)=i;
        b=b+1;
        end
        end

        try
        DelayPFb=tpsPos(idxY(1))-tpsPos(1);
        catch
        DelayPFb=60;
        end
        
        if plo

            try
            subplot(2,2,3), imagesc(PFb), axis xy
            hold on, plot(round(x)+dee,round(y)+dee,'w.')
            hold on, plot(round(x(idxY))+dee,round(y(idxY))+dee,'k.')%,'markerfacecolor','k')
            hold on, plot(round(x(1))+dee,round(y(1))+dee,'ko','markerfacecolor','y')
            % subplot(2,5,7), PlotErrorBar2(paramm(idxY),paramm(idxN),0)
            % set(gca,'xtick',[1 2])
            % set(gca,'xticklabel',{'In' 'Out'})
            % [h1,b1]=hist(paramm(idxY),[0:2:100]);
            % [h2,b2]=hist(paramm(idxN),[0:2:100]);
            % subplot(2,5,8),plot(b1,h1,'r','linewidth',2), hold on, plot(b2,h2,'k','linewidth',2), xlim([0 98])
            % subplot(2,5,9),plot(b1,h1/sum(h1),'r','linewidth',2), hold on, plot(b2,h2/sum(h2),'k','linewidth',2), xlim([0 95])
            subplot(2,2,4),PlotErrorBar2(length(idxY)/(length(idxY)+length(idxN))*100,length(idxN)/(length(idxY)+length(idxN))*100,0)
            set(gca,'xtick',[1 2])
            set(gca,'xticklabel',{'In' 'Out'})
            end

        end



        %------------------------------------------------------------------------------------------------------------------------------


        [PercIn,PercOut,PercInb,PercOutb,m1,m2,m1b,m2b,SiPF,SiPFb,SiGlob,A]=QuantifExploPFControl(PF,PFb,Restrict(X1,Epoch1),Restrict(Y1,Epoch1));

catch
    
        PercIn=[];
        PercOut=[];
        PercInb=[];
        PercOutb=[];
        m1=[];
        m2=[];
        m1b=[];
        m2b=[];
        SiPF=[];
        SiPFb=[];
        SiGlob=[];
end



