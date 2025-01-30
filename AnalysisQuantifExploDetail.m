function [A,x,y,Positions,PF,PFb,GC,mapSs,V1,xtsd,ytsd]=AnalysisQuantifExploDetail(bef,trials,plo)

Vth=15;
smo=2;
logy=0;
Scalee=50;

try
    plo;
catch
    plo=0;
end

%load ParametersAnalyseICSS X Y S stim limMaz limM limMaze xMaz yMaz
load behavResources
% load AnalyseResourcesICSS
load AnalyseResourcesICSSLast PF PFb mapS mapSs
load ParametersAnalyseICSS varargin limMaze o M N


S=tsdArray({});

clear xMaz
clear yMaz
try
    load xyMaxOK xMaz yMaz
    xMaz;
catch
    load xyMax xMaz yMaz
end

try
    yMaz;
catch
    [X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,TrackingEpoch,1);
end


[X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz,0);

try
    bef;
catch
    bef='aft';
end

if bef=='bef'
    
   try
        trials;
        if length(trials)>length(N)&max(trials)<length(N)
        Epoch1=subset(QuantifExploEpoch,N);
        else
        Epoch1=subset(QuantifExploEpoch,N(trials));
        end
    catch
        Epoch1=subset(QuantifExploEpoch,N);
    end

else
    
    try
        trials;
        if length(trials)>=length(M)&max(trials)<length(M)
        Epoch1=subset(QuantifExploEpoch,M);
        else
        Epoch1=subset(QuantifExploEpoch,M(trials));
        end
   catch
       Epoch1=subset(QuantifExploEpoch,M);
   end
    
end
load ParametersAnalyseICSS varargin

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
   
   
if immobb
    [S,X,Y,V,Mvt,MvtOK,goEpoch]=RemoveImmobilePosition(S,X,Y,V,Vth,TrackingEpoch,SleepEpoch,RestEpoch);
end


GC=GravityCenter(PF);
load ParametersAnalyseICSS limM limMaze
load xyMax

if 1

    
    X1=Restrict(X,Epoch1);
    Y1=Restrict(Y,Epoch1);
    V1=Restrict(V,Epoch1);

        for i=1:length(Start(Epoch1))
            Positions{i}(:,1)=Data(Restrict(X1,subset(Epoch1,i)));
            Positions{i}(:,2)=Data(Restrict(Y1,subset(Epoch1,i)));
           % Vit{i}=Data(Restrict(V,Restrict(ytsd,subset(Epoch1,i))));
        end
        
            [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(Restrict(X,Epoch1)),Data(Restrict(Y,Epoch1)),Scalee,smo,logy,[ 0 max(xMaz)-min(xMaz) 0 max(yMaz)-min(yMaz)],0,1);
%             [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(Restrict(X,Epoch1)),Data(Restrict(Y,Epoch1)),Scalee,smo,logy,[0 max(yMaz)-min(yMaz) 0 max(xMaz)-min(xMaz)],0,1);

            xtsd=tsd(Range(Restrict(X,Epoch1)),x);
            ytsd=tsd(Range(Restrict(Y,Epoch1)),y);

        for i=1:length(Start(Epoch1))
            Positions{i}(:,1)=Data(Restrict(xtsd,subset(Epoch1,i)));
            Positions{i}(:,2)=Data(Restrict(ytsd,subset(Epoch1,i)));
           % Vit{i}=Data(Restrict(V,Restrict(ytsd,subset(Epoch1,i))));
        end
        
        
        
else

        if 1

                Scalee=62;
                x=rescale(Data(X),Scalee/10,Scalee-Scalee/10);
                y=rescale(Data(Y),Scalee/10,Scalee-Scalee/10);

                xtsd=tsd(Range(X),x);
                ytsd=tsd(Range(Y),y);


                X1=Restrict(xtsd,Epoch1);
                Y1=Restrict(ytsd,Epoch1);
                V1=Restrict(V,Epoch1);

                x=Data(Restrict(xtsd,Epoch1));
                y=Data(Restrict(ytsd,Epoch1));

        else


                Scalee=62;
                x=rescale(Data(X1),Scalee/10,Scalee-Scalee/10);
                y=rescale(Data(Y1),Scalee/10,Scalee-Scalee/10);

                % else
                %     
                %     Ext=limMaze;
                %     Scalee=62;
                % 
                %     try
                %         Ext;
                %         if length(Ext)<3
                %             Ext(3)=Ext(1);
                %             Ext(4)=Ext(2);
                %         end
                %         try
                %           x=rescale([Ext(1) Data(X1) Ext(2)],Scalee/10,Scalee-Scalee/10);x=x(2:end-1);
                %           y=rescale([Ext(3) Data(Y1) Ext(4)],Scalee/10,Scalee-Scalee/10);y=y(2:end-1);
                %         catch
                %           x=rescale([Ext(1); Data(X1) ;Ext(2)],Scalee/10,Scalee-Scalee/10);x=x(2:end-1);
                %           y=rescale([Ext(3) ;Data(Y1); Ext(4)],Scalee/10,Scalee-Scalee/10);y=y(2:end-1);  
                %         end
                %     catch
                % 
                %         x=rescale(Data(X1),Scalee/10,Scalee-Scalee/10);
                %         y=rescale(Data(Y1),Scalee/10,Scalee-Scalee/10);
                %     end




                xtsd=tsd(Range(X1),x);
                ytsd=tsd(Range(Y1),y);

        end

        % x=rescale(Data(X),Scal/10,Scal-Scal/10);
        % y=rescale(Data(Y),Scal/10,Scal-Scal/10);
        % xtsd=tsd(Range(X),x);
        % ytsd=tsd(Range(Y),y);
        % xtsd=Restrict(xtsd,X1);
        % ytsd=Restrict(ytsd,Y1);


        for i=1:length(Start(Epoch1))
            Positions{i}(:,1)=Data(Restrict(X1,subset(Epoch1,i)));
            Positions{i}(:,2)=Data(Restrict(Y1,subset(Epoch1,i)));
           % Vit{i}=Data(Restrict(V,Restrict(ytsd,subset(Epoch1,i))));
        end


        lim=[1 Scalee+2*Scalee/100];
        [occH, x1, x2] = hist2d([lim(1) ;x ;lim(2)], [lim(1) ;y ;lim(2)], Scalee, Scalee);
        %[occH, x1, x2] = hist2d(x,y, -Scalee/10:Scalee+Scalee/10, -Scalee/10:Scalee+Scalee/10);

        A=log(occH');
        A(isinf(A))=0;
        A(isnan(A))=0;


end


m1=A;
m1(PF==0)=0;
m2=SmoothDec(A,[smo smo]);
m2(PF==0)=0;




if plo
    
    figure('color',[1 1 1]), 
    subplot(1,3,1),imagesc(SmoothDec(A,[1 1 ])), axis xy
    subplot(1,3,2),hold on, plot(x,y,'color',[0.5 0.5 0.5]), 
    subplot(1,3,2),hold on, plot(x,y,'ko','markerfacecolor','k'), 
    xlim([0 Scalee]), ylim([0 Scalee])
    subplot(1,3,3), imagesc(SmoothDec(A,[1 1 ])), axis xy
    hold on, plot(x,y,'w.')



    figure('color',[1 1 1]), 
    subplot(2,4,1), imagesc(mapSs.time), axis xy, title('Occupancy')
    subplot(2,4,2), imagesc(mapSs.count), axis xy, title('Spikes')
    subplot(2,4,3), imagesc(mapSs.rate), axis xy, title('Spike rate')
    subplot(2,4,4),imagesc(PF+PFb), axis xy, title('Place Field')
    subplot(2,4,5),imagesc(A), axis xy, ca=caxis; title('Occupancy test')
    subplot(2,4,6), imagesc(m1), axis xy, caxis(ca)
    subplot(2,4,7), imagesc(SmoothDec(A,[smo smo])), axis xy, ca=caxis;
    subplot(2,4,8), imagesc(m2), axis xy, caxis(ca)

    figure('color',[1 1 1]),
    imagesc(PF+PFb), axis xy,colormap(jet)
    hold on, plot(x,y,'w.')


end




% 
% 
% 
% 
% %-------------------------------------------------------------------------
% %-------------------------------------------------------------------------
% %-------------------------------------------------------------------------
% % compute Instantaneous Angle
% 
% Angl=ComputeInstantaneuousAngle(Data(X),Data(Y));
% Ang=tsd(Range(X),Angl);
% Ang=Restrict(Ang,Mvt);
% 
% Ang1 = Restrict(Ang,Epoch1);
% Ang2 = Restrict(Ang,Epoch2);
% 
% %-------------------------------------------------------------------------
% %-------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% % Compute Distance to stimZone
% 
% 
% Xm=Restrict(X,QuantifExploEpoch);
% Ym=Restrict(Y,QuantifExploEpoch);
% 
% dxm=rescale([limMaz(1) ;Data(X) ;limMaz(2)],0,si);
% dym=rescale([limMaz(1) ;Data(Y) ;limMaz(2)],0,si);
% dxm=dxm(2:end-1);
% dym=dym(2:end-1);
% 
% %dxm=rescale(Data(X),0,si);
% %dym=rescale(Data(Y),0,si);
% 
% Xm=tsd(Range(X),dxm);
% Ym=tsd(Range(Y),dym);
% 
% if 1
%     lm=GravityCenter(PF);
%     dis=tsd(Range(Xm),sqrt((Data(Xm)-lm(1)).*(Data(Xm)-lm(1))+(Data(Ym)-lm(2)).*(Data(Ym)-lm(2))));
% else
%     Gstim(1)=mean(pxS);
%     Gstim(2)=mean(pyS);
%     dis=tsd(Range(X),sqrt((Data(X)-Gstim(1)).*(Data(X)-Gstim(1))+(Data(Y)-Gstim(2)).*(Data(Y)-Gstim(2))));
% end
% 
% 
% 
% 
% 

% 
% 
% %-----------------------------------------------
% %-------------------------------------------------------------------------
% %-------------------------------------------------------------------------
% 
% % Compute time spent in the stimulation area
% % Compute correlation coeff between explo and StimExplo
% 
% CorrelationCoef=[];
% TimeInStimArea=[];
% QuadrantTime=[];
% 
% nnbPre=1;
% nnbPost=1;
% 
%     for q=[N,M]
%         %i=rem(q,NbTrials);
%         %if i==0
%         %    i=NbTrials;
%         %end
%         
%         if ismember(q,N)
%             j=1; %pre
%         elseif ismember(q,M)
%             j=2; %post
%         end
%         Epoch=subset(QuantifExploEpoch,q);
%         durEpoch=End(Epoch,'s')-Start(Epoch,'s');
%         Xij=Restrict(X,Epoch);
%         Yij=Restrict(Y,Epoch);
%         
%         [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Xij,Yij,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
%         
%         mSij=OcRS;
%         mSij(PF==0)=0;
%         mSbij=OcRS;
%         mSbij(PFb==0)=0;
% 
%         if j==1
%                 TimeInStimAreaPre(nnbPre)=sum(sum(mSij));
%                 TimeInLargeStimAreaPre(nnbPre)=sum(sum(mSbij));
% 
%         else
%                 TimeInStimAreaPost(nnbPost)=sum(sum(mSij));
%                 TimeInLargeStimAreaPost(nnbPost)=sum(sum(mSbij));
% 
%         end
% 
%         
%         %r=corrcoef(mapS.rate(:),OcRS(:));
%         r=corrcoef(mapS.rate(find(BW==1)),OcRS(find(BW==1)));
%         val1=mapS.rate(find(BW==1));
%         val2=OcRS(find(BW==1));
%         
%         level1=max(val1)/5;
%         level2=max(val2)/5;
%        
%         [rcorrected,p1corrected]=corrcoef(val1(find(val1>level1|val2>level2)),val2(find(val1>level1|val2>level2)));
% 
%         CorrelationCoef(i,j)=r(1,2);
%         CorrelationCoefCorrected(i,j)=rcorrected(1,2);
%         
%         Angij=Restrict(Ang,Epoch);
%         try
%             int=thresholdIntervals(Restrict(dis,Epoch),Limdist,'Direction','Below');
%             intr=dropShortIntervals(int,tpsTh);
%             %int1r=int1;
%             rg=Start(intr,'s');
%             ref=Range(Restrict(dis,Epoch),'s');
%             tps=rg(1)-ref(1);
%             trajdir=intervalSet(ref(1)*1E4,rg(1)*1E4);
%             StdAngle(i,j)=std(Data(Restrict(Angij,trajdir)));
%             
%             if j==1
%                 StdAnglePre(nnbPre)=std(Data(Restrict(Angij,trajdir)));
%                % nnbPre=nnbPre+1;
%             else
%                 StdAnglePost(nnbPost)=std(Data(Restrict(Angij,trajdir)));                
%                 %nnbPost=nnbPost+1;
%             end
% 
%         catch
%             tps=limTemp;
%             if j==1
%                 StdAnglePre(nnbPre)=nanmean(Data(Ang2));
%                % nnbPre=nnbPre+1;
%             else
%                 StdAnglePost(nnbPost)=nanmean(Data(Ang2));               
%                 %nnbPost=nnbPost+1;
%             end
%             
%         end
%         
%         
% 
% %%% Time spent in  Stimulation area
% durEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
% durEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));
% 
% [Df1,Sf1,Ef1]=MeanDifNan(TimeInStimAreaPre');
% [Df2,Sf2,Ef2]=MeanDifNan(TimeInStimAreaPost');
% [Df3,Sf3,Ef3]=MeanDifNan(TimeInLargeStimAreaPre');
% [Df4,Sf4,Ef4]=MeanDifNan(TimeInLargeStimAreaPost');
% 
% 
% 
