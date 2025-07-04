function Res=QuantifExploFiringvsSpeed(NumNeuron,n,N,M,varargin)


%n=8; %epoch QuantifExploPost
% disp('  ')
% n=input('Number of epoch for QuantifEplxoEpoch Post: ');
% disp('  ')

smo=3;
Vth=15;

a=7; b=58; 
%a=5; b=56; 

sizeMap=50;

thPF=0.3;
posArt=1;
sav=0;
immobb=0;
limTemp=0;



load SpikeData S cellnames
load behavResources

 for i = 1:2:length(varargin),

   %           if ~isa(varargin{i},'char'),
    %            error(['Parameter ' num2str(i) ' is not a property (type ''help ICSSexplo'' for details).']);
     %         end

              switch(lower(varargin{i})),

                case 'smoothing',
                  smo = varargin{i+1};
                  if ~isa(smo,'numeric'),
                    error('Incorrect value for property ''smoothing'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'figure',
                  plo = varargin{i+1};
                  if ~isa(plo,'numeric'),
                    error('Incorrect value for property ''figure'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
               case 'positions',
                  posArt = varargin{i+1};
                  if posArt=='y'
                      posArt=1;
                  else
                      posArt=0;
                  end
                  if ~isa(posArt,'numeric'),
                    error('Incorrect value for property ''positions'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'immobility',
                  immobb = varargin{i+1};
                  if immobb=='y'
                      immobb=1;
                  else
                      immobb=0;
                  end
               
                  if ~isa(immobb,'numeric'),
                    error('Incorrect value for property ''immobility'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
  
                case 'save',
                  sav = varargin{i+1};
                  if sav=='y'
                      sav=1;
                  else
                      sav=0;
                  end
                  
                  if ~isa(immobb,'numeric'),
                    error('Incorrect value for property ''immobility'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                  
                case 'speed',
                  Vth = varargin{i+1};
                  if ~isa(Vth,'numeric'),
                    error('Incorrect value for property ''speed'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'time',
                  limTemp = varargin{i+1};
                  if ~isa(limTemp,'numeric'),
                    error('Incorrect value for property ''time'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'size',
                  sizeMap = varargin{i+1};
                  if ~isa(sizeMap,'numeric'),
                    error('Incorrect value for property ''size'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end 

         
            
                 
                  
              end
 end
 

listQuantif=find(diff(Start(QuantifExploEpoch,'s'))>200);


disp(' ')
disp(num2str(listQuantif))
disp(num2str(length(Start(QuantifExploEpoch,'s'))))
disp(' ')
namePos'
disp(' ')
%length(N)
%length(M)




 if limTemp>0
     
     for i=1:length(Start(QuantifExploEpoch))
        
         epochtemp=subset(QuantifExploEpoch,i);
         sttemp(i)=Start(QuantifExploEpoch);
         
     end
  QuantifExploEpoch=intervalSet(sttemp,sttemp+limTemp*1E4);   
 end
 
 
 si=sizeMap;               
 

Mvt=thresholdIntervals(V,Vth, 'Direction','Above');
ep=TrackingEpoch-SleepEpoch;
ep=ep-RestEpoch;
[X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,ep,posArt);

dis=tsd(Range(X),sqrt((Data(X)-max(Data(X))/2).^2+(Data(Y)-max(Data(Y))/2).^2));
EpochOk=thresholdIntervals(dis,limMaz(2)/2,'Direction','Below');

X=Restrict(X,EpochOk);
Y=Restrict(Y,EpochOk);
S=Restrict(S,EpochOk);

N=RemoveFalseTrialQuantifExplo(N,70,X,Y,QuantifExploEpoch);
M=RemoveFalseTrialQuantifExplo(M,70,X,Y,QuantifExploEpoch);


if 1
    

        for k=N

            try
        Epoch=intervalSet(tpsdeb{n}*1E4,tpsfin{n}*1E4);Epoch=intersect(Epoch,TrackingEpoch);
        Xr=Restrict(X,Epoch);
        Yr=Restrict(Y,Epoch);
        Sr=Restrict(S,Epoch);

        Epoch=subset(QuantifExploEpoch,k);

        Xe=Restrict(X,Epoch);
        Ye=Restrict(Y,Epoch);
        Se=Restrict(S,Epoch);
        Ve=Restrict(V,Epoch);
        px =Data(Restrict(Xe,Se{NumNeuron},'align','closest'));
        py =Data(Restrict(Ye,Se{NumNeuron},'align','closest'));

        figure('color',[1 1 1]),
        hold on, plot(Data(Xr),Data(Yr),'color',[0.7 0.7 0.7])
        hold on, plot(Data(Xe),Data(Ye),'color','k','linewidth',2)
        hold on, scatter(px,py,30,[1:length(px)],'filled')
        title([num2str(k),' total ',cellnames{NumNeuron}])
        colorbar


        figure('color',[1 1 1]),
        hold on, plot(Data(Xr),Data(Yr),'color',[0.7 0.7 0.7])
        hold on, plot(px,py,'ko','markerfacecolor','k','markersize',15)
        hold on, scatter(Data(Xe),Data(Ye),30,Data(Ve),'filled')
        %hold on, plot(px,py,'ko','markerfacecolor','k','markersize',10)
        title([num2str(k),' speed'])
        colorbar


        if 1
        Mvt=thresholdIntervals(V,15, 'Direction','Above');
        Epoch2=intersect(Epoch,Mvt);

        Xem=Restrict(X,Epoch2);
        Yem=Restrict(Y,Epoch2);
        Sem=Restrict(S,Epoch2);
        pxm =Data(Restrict(Xem,Sem{NumNeuron},'align','closest'));
        pym =Data(Restrict(Yem,Sem{NumNeuron},'align','closest'));
        
        figure('color',[1 1 1]),
        hold on, plot(Data(Xr),Data(Yr),'color',[0.7 0.7 0.7])
        hold on, plot(Data(Xem),Data(Yem),'color','k','linewidth',2)
        hold on, scatter(pxm,pym,30,[1:length(pxm)],'filled')
        title([num2str(k),' without mvt ',cellnames{NumNeuron}])
        colorbar
        end
        %PlaceField(Restrict(S{36},Epoch),Restrict(X,Epoch),Restrict(Y,Epoch));title([num2str(k),' ',cellnames{36}])
        %PlaceField(Restrict(S{36},Epoch2),Restrict(X,Epoch2),Restrict(Y,Epoch2));title([num2str(k),' speed ',cellnames{36}])

            end
        end

end

if 0

        EpochT1=subset(QuantifExploEpoch,N);
        EpochT1=intersect(EpochT1,TrackingEpoch);

        %EpochT1=intervalSet(tpsdeb{2}*1E4,tpsfin{2}*1E4);EpochT1=intersect(EpochT1,TrackingEpoch);


        Xt=Restrict(X,EpochT1);
        Yt=Restrict(Y,EpochT1);

        St=Restrict(S,EpochT1);

        St=Restrict(S,intersect(EpochT1,Mvt));

        rg1=Range(St{NumNeuron});

        figure, [fh, rasterAx, histAx, matValPre] = ImagePETH(V, ts(rg1), -45000, +25000,'BinSize',2000);


        pxt =Data(Restrict(Xt,St{NumNeuron},'align','closest'));
        pyt =Data(Restrict(Yt,St{NumNeuron},'align','closest'));
        figure('color',[1 1 1]),
        hold on, plot(Data(Xr),Data(Yr),'color',[0.7 0.7 0.7])
        hold on, plot(Data(Xt),Data(Yt),'color','k','linewidth',2)
        hold on, scatter(pxt,pyt,30,[1:length(pxt)],'filled')
        title(['Total ',cellnames{NumNeuron}])
        colorbar



        EpochT2=subset(QuantifExploEpoch,M);
        EpochT2=intersect(EpochT2,TrackingEpoch);

        %EpochT2=intervalSet(tpsdeb{9}*1E4,tpsfin{9}*1E4);EpochT2=intersect(EpochT2,TrackingEpoch);


        Xt=Restrict(X,EpochT2);
        Yt=Restrict(Y,EpochT2);

        St=Restrict(S,EpochT);
        St=Restrict(S,intersect(EpochT2,Mvt));
        rg2=Range(St{NumNeuron});

            figure, [fh, rasterAx, histAx, matValPost] = ImagePETH(V, ts(rg2), -45000, +25000,'BinSize',2000);

        pxt =Data(Restrict(Xt,St{NumNeuron},'align','closest'));
        pyt =Data(Restrict(Yt,St{NumNeuron},'align','closest'));
        figure('color',[1 1 1]),
        hold on, plot(Data(Xr),Data(Yr),'color',[0.7 0.7 0.7])
        hold on, plot(Data(Xt),Data(Yt),'color','k','linewidth',2)
        hold on, scatter(pxt,pyt,30,[1:length(pxt)],'filled')
        title(['Total ',cellnames{NumNeuron}])
        colorbar


        figure('color',[1 1 1]),hold on
        try
            plot(Range(matValPost,'s'),mean(Data(matValPre)'),'k','linewidth',2)
            plot(Range(matValPost,'s'),mean(Data(matValPost)'),'r','linewidth',2)
            yl=ylim;
        line([0 0],yl,'color','k')
        end

        ylabel('Speed')
        xlabel('Time from spikes (s)')


        [h1,b1]=hist(Data(Restrict(V,EpochT1)),[0:100]);
        [h2,b2]=hist(Data(Restrict(V,EpochT2)),[0:100]);
        figure('color',[1 1 1]),
        subplot(1,2,1),hold on
        plot(b1,h1,'k','linewidth',2)
        plot(b2,h2,'r','linewidth',2)
        xlim([0 99])
        xlabel('Speed')

        subplot(1,2,2),hold on
        plot(b1,h1/max(h1),'k','linewidth',2)
        plot(b2,h2/max(h2),'r','linewidth',2)
        xlim([0 99])
        ylim([0 1.2])
        xlabel('NormalizedSpeed')


end




%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------




%smo=0.01;
%si=20;

% smo=1.2
% si=50;


EpochT1=subset(QuantifExploEpoch,N);
mapPre=PlaceField(Restrict(S{NumNeuron},EpochT1),Restrict(X,EpochT1),Restrict(Y,EpochT1),'smoothing',smo,'size',si);title(['Pre ',cellnames{NumNeuron}]), close
EpochT2=subset(QuantifExploEpoch,M);
mapPost=PlaceField(Restrict(S{NumNeuron},EpochT2),Restrict(X,EpochT2),Restrict(Y,EpochT2),'smoothing',smo,'size',si);title(['Post ',cellnames{NumNeuron}]), close
valXpre=mapPre.count(:);
valYpre=mapPre.time(:);
valXpost=mapPost.count(:);
valYpost=mapPost.time(:);
[r1,p1]=corrcoef(valXpre,valYpre);
[r2,p2]=corrcoef(valXpost,valYpost);
level1x=max(valXpre)/4;
level2x=max(valXpost)/4;
level1y=max(valYpre)/4;
level2y=max(valYpost)/4;
[r1c,p1c]=corrcoef(valXpre(find(valXpre>level1x|valYpre>level1y)),valYpre(find(valXpre>level1x|valYpre>level1y)));
[r2c,p2c]=corrcoef(valXpost(find(valXpost>level2x|valYpost>level2y)),valYpost(find(valXpost>level2x|valYpost>level2y)));


figure('color',[1 1 1])
subplot(2,2,1), imagesc(mapPre.count), axis xy; ylabel('count'), title('with immobility')
subplot(2,2,2), imagesc(mapPost.count), axis xy
subplot(2,2,3), imagesc(mapPre.time), axis xy; xlabel('Pre'); ylabel('time')
subplot(2,2,4), imagesc(mapPost.time), axis xy; xlabel('Post')

EpochT1=subset(QuantifExploEpoch,N);EpochT1=intersect(EpochT1,Mvt);
mapPreM=PlaceField(Restrict(S{NumNeuron},EpochT1),Restrict(X,EpochT1),Restrict(Y,EpochT1),'smoothing',smo,'size',si);title(['Pre Mvt ',cellnames{NumNeuron}]), close

EpochT2=subset(QuantifExploEpoch,M);EpochT2=intersect(EpochT2,Mvt);
mapPostM=PlaceField(Restrict(S{NumNeuron},EpochT2),Restrict(X,EpochT2),Restrict(Y,EpochT2),'smoothing',smo,'size',si);title(['Post Mvt ',cellnames{NumNeuron}]), close

valXpreM=mapPreM.count(:);
valYpreM=mapPreM.time(:);
valXpostM=mapPostM.count(:);
valYpostM=mapPostM.time(:);
[r1b,p1b]=corrcoef(valXpreM,valYpreM);
[r2b,p2b]=corrcoef(valXpostM,valYpostM);

figure('color',[1 1 1])
subplot(2,2,1), imagesc(mapPreM.count), axis xy; ylabel('count'), title('without immobility')
subplot(2,2,2), imagesc(mapPostM.count), axis xy
subplot(2,2,3), imagesc(mapPreM.time), axis xy; xlabel('Pre'); ylabel('time')
subplot(2,2,4), imagesc(mapPostM.time), axis xy; xlabel('Post')

level1xM=max(valXpreM)/4;
level2xM=max(valXpostM)/4;
level1yM=max(valYpreM)/4;
level2yM=max(valYpostM)/4;

[r1bc,p1bc]=corrcoef(valXpreM(find(valXpreM>level1xM|valYpreM>level1yM)),valYpreM(find(valXpreM>level1xM|valYpreM>level1yM)));
[r2bc,p2bc]=corrcoef(valXpostM(find(valXpostM>level2xM|valYpostM>level2yM)),valYpostM(find(valXpostM>level2xM|valYpostM>level2yM)));

R1=r1(1,2);P1=p1(1,2); R2=r2(1,2);P2=p2(1,2); 
R1b=r1b(1,2);P1b=p1b(1,2); R2b=r2b(1,2);P2b=p2b(1,2); 


R1c=r1c(1,2);P1c=p1c(1,2); R2c=r2c(1,2);P2c=p2c(1,2); 
R1bc=r1bc(1,2);P1bc=p1bc(1,2); R2bc=r2bc(1,2);P2bc=p2bc(1,2); 

Res(1,:)=[R1 R2 P1 P2];
Res(2,:)=[R1c R2c P1c P2c];

Res(3,:)=[R1b R2b P1b P2b];
Res(4,:)=[R1bc R2bc P1bc P2bc];

figure('color',[1 1 1])
subplot(2,2,1), hold on
plot(valXpre,valYpre,'.')
plot(valXpost,valYpost,'r.')
xlabel('count')
ylabel('time')
title('with immobility')
subplot(2,2,2), hold on
plot(valXpreM,valYpreM,'.')
plot(valXpostM,valYpostM,'r.')
xlabel('count')
ylabel('time')
title('without immobility')

subplot(2,2,3), hold on
plot(valXpre(find(valXpre>level1x|valYpre>level1y)),valYpre(find(valXpre>level1x|valYpre>level1y)),'.')
plot(valXpost(find(valXpost>level2x|valYpost>level2y)),valYpost(find(valXpost>level2x|valYpost>level2y)),'r.')
xlabel('count')
ylabel('time')

subplot(2,2,4), hold on
plot(valXpreM(find(valXpreM>level1xM|valYpreM>level1yM)),valYpreM(find(valXpreM>level1xM|valYpreM>level1yM)),'.')
plot(valXpostM(find(valXpostM>level2xM|valYpostM>level2yM)),valYpostM(find(valXpostM>level2xM|valYpostM>level2yM)),'r.')
xlabel('count')
ylabel('time')



%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

try
    ExploEpoch=intersect(ExploEpoch,TrackingEpoch); 
    if immobb
        ExploEpoch=intersect(ExploEpoch,Mvt); 
    end

    PlaceField(Restrict(S{NumNeuron},ExploEpoch),Restrict(X,ExploEpoch),Restrict(Y,ExploEpoch));title(['Total Explo ',cellnames{NumNeuron}])
catch
    CreateExploEpoch
    ExploEpoch=intersect(ExploEpoch,TrackingEpoch);
    if immobb
        ExploEpoch=intersect(ExploEpoch,Mvt); 
    end
    PlaceField(Restrict(S{NumNeuron},ExploEpoch),Restrict(X,ExploEpoch),Restrict(Y,ExploEpoch));title(['Total Explo ',cellnames{NumNeuron}])
end

try
EpochC=intervalSet(tpsdeb{n+1}*1E4,tpsfin{n+1}*1E4);EpochC=intersect(EpochC,TrackingEpoch);
if immobb
    EpochC=intersect(EpochC,Mvt); 
end
PlaceField(Restrict(S{NumNeuron},EpochC),Restrict(X,EpochC),Restrict(Y,EpochC));title([namePos{n+1},' ',cellnames{NumNeuron}])
EpochC=intervalSet(tpsdeb{1}*1E4,tpsfin{1}*1E4);EpochC=intersect(EpochC,TrackingEpoch);
if immobb
    EpochC=intersect(EpochC,Mvt); 
end
PlaceField(Restrict(S{NumNeuron},EpochC),Restrict(X,EpochC),Restrict(Y,EpochC));title([namePos{1},' ',cellnames{NumNeuron}])
end

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


EpochT1=subset(QuantifExploEpoch,N);
EpochT2=subset(QuantifExploEpoch,M);



px1 =Data(Restrict(X,Restrict(S{NumNeuron},EpochT1),'align','closest'));
py1 =Data(Restrict(Y,Restrict(S{NumNeuron},EpochT1),'align','closest'));

px2 =Data(Restrict(X,Restrict(S{NumNeuron},EpochT2),'align','closest'));
py2 =Data(Restrict(Y,Restrict(S{NumNeuron},EpochT2),'align','closest'));

tempX1=rescale([Data(Restrict(X,EpochT1)); px1],a,b);
tempX2=rescale([Data(Restrict(X,EpochT2)); px2],a,b);

tempY1=rescale([Data(Restrict(Y,EpochT1)); py1],a,b);
tempY2=rescale([Data(Restrict(Y,EpochT2)); py2],a,b);

PosX1=tempX1(1:length(Data(Restrict(X,EpochT1))));
PosY1=tempY1(1:length(Data(Restrict(Y,EpochT1))));
PosX2=tempX2(1:length(Data(Restrict(X,EpochT2))));
PosY2=tempY2(1:length(Data(Restrict(Y,EpochT2))));


px1=tempX1(end-length(px1)+1:end);
py1=tempY1(end-length(py1)+1:end);
px2=tempX2(end-length(px2)+1:end);
py2=tempY2(end-length(py2)+1:end);




figure('color',[1 1 1])

subplot(2,3,1), hold on
imagesc(mapPre.time), axis xy, 
hold on, plot(rescale(Data(Restrict(X,EpochT1)),a,b),rescale(Data(Restrict(Y,EpochT1)),a ,b),'w')
ylabel('Pre')
xlim([0.5 61.5])
ylim([0.5 61.5]) 
title('with immobility')
ca=caxis;
caxis([0 ca(2)-ca(2)/4])


subplot(2,3,2), hold on
imagesc(mapPre.time), axis xy, 
hold on, plot(px1,py1,'wo','markerfacecolor','k','markersize',5)
xlim([0.5 61.5])
ylim([0.5 61.5]) 
title('with immobility')
ca=caxis;
caxis([0 ca(2)-ca(2)/4])

subplot(2,3,3), hold on
imagesc(mapPre.count), axis xy, 
hold on, plot(rescale(Data(Restrict(X,EpochT1)),a,b),rescale(Data(Restrict(Y,EpochT1)),a ,b),'w')
xlim([0.5 61.5])
ylim([0.5 61.5]) 
title('with immobility')
ca=caxis;
caxis([0 ca(2)-ca(2)/4])

subplot(2,3,4), hold on
imagesc(mapPost.time), axis xy, 
hold on, plot(rescale(Data(Restrict(X,EpochT2)),a,b),rescale(Data(Restrict(Y,EpochT2)),a ,b),'w')
ylabel('Post')
xlim([0.5 61.5])
ylim([0.5 61.5]) 
ca=caxis;
caxis([0 ca(2)-ca(2)/4])

subplot(2,3,5), hold on
imagesc(mapPost.time), axis xy, 
hold on, plot(px2,py2,'wo','markerfacecolor','k','markersize',5)
xlim([0.5 61.5])
ylim([0.5 61.5]) 
ca=caxis;
caxis([0 ca(2)-ca(2)/4])

subplot(2,3,6), hold on
imagesc(mapPost.count), axis xy, 
hold on, plot(rescale(Data(Restrict(X,EpochT2)),a,b),rescale(Data(Restrict(Y,EpochT2)),a ,b),'w')
xlim([0.5 61.5])
ylim([0.5 61.5]) 
ca=caxis;
caxis([0 ca(2)-ca(2)/4])




%-------------------------------------------------------------------------



EpochT1=subset(QuantifExploEpoch,N);EpochT1=intersect(EpochT1,Mvt);
EpochT2=subset(QuantifExploEpoch,M);EpochT2=intersect(EpochT2,Mvt);

a=7; b=58; 

px1 =Data(Restrict(X,Restrict(S{NumNeuron},EpochT1),'align','closest'));
py1 =Data(Restrict(Y,Restrict(S{NumNeuron},EpochT1),'align','closest'));

px2 =Data(Restrict(X,Restrict(S{NumNeuron},EpochT2),'align','closest'));
py2 =Data(Restrict(Y,Restrict(S{NumNeuron},EpochT2),'align','closest'));

tempX1=rescale([Data(Restrict(X,EpochT1)); px1],a,b);
tempX2=rescale([Data(Restrict(X,EpochT2)); px2],a,b);

tempY1=rescale([Data(Restrict(Y,EpochT1)); py1],a,b);
tempY2=rescale([Data(Restrict(Y,EpochT2)); py2],a,b);

PosX1=tempX1(1:length(Data(Restrict(X,EpochT1))));
PosY1=tempY1(1:length(Data(Restrict(Y,EpochT1))));
PosX2=tempX2(1:length(Data(Restrict(X,EpochT2))));
PosY2=tempY2(1:length(Data(Restrict(Y,EpochT2))));


px1=tempX1(end-length(px1)+1:end);
py1=tempY1(end-length(py1)+1:end);
px2=tempX2(end-length(px2)+1:end);
py2=tempY2(end-length(py2)+1:end);




figure('color',[1 1 1])

subplot(2,3,1), hold on
imagesc(mapPreM.time), axis xy, 
hold on, plot(rescale(Data(Restrict(X,EpochT1)),a,b),rescale(Data(Restrict(Y,EpochT1)),a ,b),'w')
ylabel('Pre')
xlim([0.5 61.5])
ylim([0.5 61.5]) 
title('without immobility')

subplot(2,3,2), hold on
imagesc(mapPreM.time), axis xy, 
hold on, plot(px1,py1,'wo','markerfacecolor','k','markersize',5)
xlim([0.5 61.5])
ylim([0.5 61.5]) 
title('without immobility')

subplot(2,3,3), hold on
imagesc(mapPreM.count), axis xy, 
hold on, plot(rescale(Data(Restrict(X,EpochT1)),a,b),rescale(Data(Restrict(Y,EpochT1)),a ,b),'w')
xlim([0.5 61.5])
ylim([0.5 61.5]) 
title('without immobility')

subplot(2,3,4), hold on
imagesc(mapPostM.time), axis xy, 
hold on, plot(rescale(Data(Restrict(X,EpochT2)),a,b),rescale(Data(Restrict(Y,EpochT2)),a ,b),'w')
ylabel('Post')
xlim([0.5 61.5])
ylim([0.5 61.5]) 

subplot(2,3,5), hold on
imagesc(mapPostM.time), axis xy, 
hold on, plot(px2,py2,'wo','markerfacecolor','k','markersize',5)
xlim([0.5 61.5])
ylim([0.5 61.5]) 

subplot(2,3,6), hold on
imagesc(mapPostM.count), axis xy, 
hold on, plot(rescale(Data(Restrict(X,EpochT2)),a,b),rescale(Data(Restrict(Y,EpochT2)),a ,b),'w')
xlim([0.5 61.5])
ylim([0.5 61.5]) 


