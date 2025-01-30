function [homogeneity,D1,D2,r1,r2,tps1,tps2,ang1,ang2]=AnalyseQuantifExplo(o,n,m)

% o: epoch ICSS
% n epoch Pre
% m epoch Post
limTemp=30; % Time length per session (s)

try
    m;
catch
    m=n+8;
end

load behavResources

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


smo=2;
sizeMap=50;
tpsTh=0.75*1E4;
Limdist=30;
Vth=20;
            legend{1}='Pre';
            legend{2}='Post';   
            legend{3}='Pre';
            legend{4}='Post';   
            
            
%Epoch1=subset(QuantifExploEpoch,1:8);
%Epoch2=subset(QuantifExploEpoch,9:16);
%%Epoch2=subset(QuantifExploEpoch,17:24);

Epoch1=subset(QuantifExploEpoch,n);
Epoch2=subset(QuantifExploEpoch,m);


EpochS=ICSSEpoch;
EpochS=subset(EpochS,o);
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
Mvt=thresholdIntervals(V,Vth,'Direction','Above');
XS=Restrict(X,EpochS);
YS=Restrict(Y,EpochS);
stimS=Restrict(stim,EpochS);
X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
Y2=Restrict(Y,Epoch2);
X2=Restrict(X,Epoch2);

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


[mapS,mapSs,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceField(stimS,XS,YS,'size',sizeMap,'limitmaze',[0 350]);
% close 
% close 
% close

kk=GravityCenter(PF);

m=mapS.rate;
m(PF==0)=0;

[Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(X1,Y1,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 350]);close
[Oc2,OcS2,OcR2,OcRS2]=OccupancyMapKB(X2,Y2,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 350]);close

m1=OcR1;
m1(PF==0)=0;
m2=OcR2;
m2(PF==0)=0;

m1S=OcRS1;
m1S(PF==0)=0;
m2S=OcRS2;
m2S(PF==0)=0;


SE=strel('square',6);
PFb=imdilate(PF,SE);

mb=mapS.rate;
mb(PFb==0)=0;

m1b=OcR1;
m1b(PFb==0)=0;
m2b=OcR2;
m2b(PFb==0)=0;

m1Sb=OcRS1;
m1Sb(PFb==0)=0;
m2Sb=OcRS2;
m2Sb(PFb==0)=0;

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

% homogeneity
MO1=mean(mean(OcRS1));
MO2=mean(mean(OcRS2));
MOCRS1=OcRS1-MO1;
MOCRS2=OcRS2-MO2;
homogeneity(1,1)=1-100*sum(sum(MOCRS1.*MOCRS1))/(62^2);
homogeneity(2,1)=1-100*sum(sum(MOCRS2.*MOCRS2))/(62^2);


% compute Instantaneous Angle
Angl = ComputeInstantaneuousAngle(Data(X),Data(Y));
Ang=tsd(Range(X),Angl);
Ang=Restrict(Ang,Mvt);


Ang1 = Restrict(Ang,Epoch1);
Ang2 = Restrict(Ang,Epoch2);


durEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
durEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));

figure('color',[1 1 1]), 
subplot(2,3,1:2)
bar([sum(sum(m1S))/durEpoch1 sum(sum(m2S))/durEpoch2 sum(sum(m1Sb))/durEpoch1 sum(sum(m2Sb))/durEpoch2],'k')
ylabel('Time spent in  Stimulation area')
            set(gca,'xtick',1:4)
            set(gca,'xticklabel',legend)
            
numfig=gcf;

subplot(2,3,3)

r1=corrcoef(mapS.rate(:),OcRS1(:));
r2=corrcoef(mapS.rate(:),OcRS2(:));
r1=r1(1,2);
r2=r2(1,2);
bar([r1 r2],'k')
ylabel('Correlation Occ. Map vs Stim. area')
            set(gca,'xtick',1:2)
            set(gca,'xticklabel',legend)            

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

figure('color',[1 1 1]), 
subplot(2,3,1), imagesc(mapS.rate), axis xy, title('ICSS'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,3,4), imagesc(m),axis xy, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')

subplot(2,3,3), imagesc(OcRS2),axis xy, caS1=caxis; title('Explo Post'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,3,2), imagesc(OcRS1),axis xy,caxis(caS1); title('Explo Pre'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,3,6), imagesc(OcRS2+2*m2S), axis xy,caS2=caxis; hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,3,5), imagesc(OcRS1+2*m1S), axis xy,caxis(caS2), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')


figure('color',[1 1 1]), 
subplot(2,3,1), imagesc(mapS.rate), axis xy, title('ICSS'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,3,4), imagesc(mb),axis xy, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')

subplot(2,3,3), imagesc(OcRS2),axis xy, caS1=caxis; title('Explo Post'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,3,2), imagesc(OcRS1),axis xy,caxis(caS1); title('Explo Pre'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,3,6), imagesc(OcRS2+2*m2Sb), axis xy,caS2=caxis; hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,3,5), imagesc(OcRS1+2*m1Sb), axis xy,caxis(caS2), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')



%figure('color',[1 1 1]), bar([sum(sum(m1S)) sum(sum(m2S)) sum(sum(m1Sb)) sum(sum(m2Sb))])



Xm=Restrict(X,QuantifExploEpoch);
Ym=Restrict(Y,QuantifExploEpoch);

dxm=rescale([0 ;Data(X) ;300],0,si);
dym=rescale([0 ;Data(Y) ;300],0,si);

dxm=dxm(2:end-1);
dym=dym(2:end-1);

Xm=tsd(Range(X),dxm);
Ym=tsd(Range(Y),dym);
%dis=tsd(Range(Xm),sqrt((Data(Xm)-kk(1)).*(Data(Xm)-kk(1))+(Data(Ym)-kk(2)).*(Data(Ym)-kk(2))));


Gstim(1)=mean(pxS);
Gstim(2)=mean(pyS);


dis=tsd(Range(X),sqrt((Data(X)-Gstim(1)).*(Data(X)-Gstim(1))+(Data(Y)-Gstim(2)).*(Data(Y)-Gstim(2))));


if length(Start(Epoch1))==1
    
      
            dis1=Restrict(dis,Epoch1);
            dis2=Restrict(dis,Epoch2);
figure('color',[1 1 1]), hold on
plot(pxS,pyS,'.','Color',[0.7 0.7 0.7])
plot(Data(Restrict(X1,Epoch1)),Data(Restrict(Y1,Epoch1)))
plot(Data(Restrict(X2,Epoch2)),Data(Restrict(Y2,Epoch2)),'r');
st1=Start(Epoch1);
st2=Start(Epoch2);
plot(Data(Restrict(X1,st1)),Data(Restrict(Y1,st1)),'bo','markerfacecolor','b')
plot(Data(Restrict(X2,st2)),Data(Restrict(Y2,st2)),'ro','markerfacecolor','r')
numfig2=gcf;


            D1=sum(Data(dis1))/length(Data(dis1));
            D2=sum(Data(dis2))/length(Data(dis2));

            figure(numfig), subplot(2,3,4)
            bar([D1,D2],'k'), xlim([0 3])
            ylabel('Cumulative distance to Stim area (s)')
            set(gca,'xtick',1:2)
            set(gca,'xticklabel',legend)

            
            try
            int1=thresholdIntervals(dis1,Limdist,'Direction','Below');
            int1r=dropShortIntervals(int1,tpsTh);
            %int1r=int1;
            
            rg1=Start(int1r,'s');
            ref1=Range(dis1,'s');
            tps1=rg1(1)-ref1(1);
            trajdir1=intervalSet(ref1(1)*1E4,rg1(1)*1E4);
            ang1=std(Data(Restrict(Ang1,trajdir1)));
            
            catch
                
            tps1=limTemp;
            ang1=nanmean(Data(Ang1));
            end
            
            try
            int2=thresholdIntervals(dis2,Limdist,'Direction','Below');
            int2r=dropShortIntervals(int2,tpsTh);
            %int2r=int2;
            
            rg2=Start(int2r,'s');
            ref2=Range(dis2,'s');
            tps2=rg2(1)-ref2(1);
            trajdir2=intervalSet(ref2(1)*1E4,rg2(1)*1E4);
            
            ang2=std(Data(Restrict(Ang2,trajdir2)));            
            catch
            tps2=limTemp;    
            ang2=nanmean(Data(Ang2)); 
            end
          

            
            tps1(tps1>limTemp)=limTemp;
            tps2(tps2>limTemp)=limTemp;
                
                
            
figure(numfig2), hold on

try
epoghAng=Restrict(Ang,Epoch1);
%    scatter(Data(Restrict(X1,dis1)),Data(Restrict(Y1,dis1)),30,Data(Restrict(Ang,dis1)),'filled'), title(num2str(mean(Data(Restrict(Ang,dis1)))))
%scatter(Data(Restrict(X1,epoghAng)),Data(Restrict(Y1,epoghAng)),30,Data(Restrict(Ang,Epoch1)),'filled'), title(num2str(mean(Data(Restrict(Ang,Epoch1)))))
plot(Data(Restrict(X1,trajdir1)),Data(Restrict(Y1,trajdir1)),'b','linewidth',2)
end

try
plot(Data(Restrict(X2,trajdir2)),Data(Restrict(Y2,trajdir2)),'r','linewidth',2)
end
xlim([0 300])
ylim([0 300])


figure(numfig),            
            subplot(2,3,5)
            bar([tps1, tps2],'k'), %xlim([0 3])
            ylabel('Time delay to Stim area (s)')
            set(gca,'xtick',1:2)
            set(gca,'xticklabel',legend)


            
            subplot(2,3,6), hold on, %legend('Pre','Post');
            bar([ang1, ang2],'k'), xlim([0 3])
            ylabel('Cumulative angle to Stim area (deg)')
            set(gca,'xtick',1:2)
            set(gca,'xticklabel',legend)
else
    
    
    
        for i=1:length(Start(Epoch1))
            
            Ep1=subset(Epoch1,i);
            Ep2=subset(Epoch2,i);
            
            Dis1=Restrict(dis,Ep1);
            Dis2=Restrict(dis,Ep2);
    
            D1(i)=sum(Data(Dis1))/length(Data(Dis1));
            D2(i)=sum(Data(Dis2))/length(Data(Dis2));

            
            try
            int1=thresholdIntervals(Dis1,Limdist,'Direction','Below');
            int1r=dropshortIntervals(int1,tpsTh);
            rg1=Start(int1r,'s');
            ref1=Range(Dis1,'s');
            tps1(i)=rg1(1)-ref1(1);
            trajdir1=intervalSet(ref1(1)*1E4,rg1(1)*1E4);
            ang1(i)=std(Data(Restrict(Ang1,trajdir1))); 
            catch
            tps1(i)=limTemp;  
            ang1=nanmean(Data(Ang1)); 
            end
            
            try
            int2=thresholdIntervals(Dis2,Limdist,'Direction','Below');
            int2r=dropshortIntervals(int2,tpsTh);
            rg2=Start(int2r,'s');
            ref2=Range(Dis2,'s');
            tps2(i)=rg2(1)-ref2(1);
            trajdir2=intervalSet(ref2(1)*1E4,rg2(1)*1E4);
            ang2(i)=std(Data(Restrict(Ang2,trajdir2))); 
            catch
            tps2(i)=limTemp;  
            ang2(i)=nanmean(Data(Ang2)); 
            end
            
        end
              
            tps1(tps1>limTemp)=limTemp;
            tps2(tps2>limTemp)=limTemp;
        
        
        [Df1,Sf1,Ef1]=MeanDifNan(D1');
        [Df2,Sf2,Ef2]=MeanDifNan(D2');
        
        %keyboard
            figure(numfig), 
            subplot(2,3,4),hold on, 
            errorbar([Df1,Df2],[Ef1,Ef2],'k+')
            bar([Df1,Df2],'k'), xlim([0 3])            
            ylabel('Cumulative distance to Stim area (s)')
            set(gca,'xtick',1:2)
            set(gca,'xticklabel',legend)
            
            [tm1,ts1,te1]=MeanDifNan(tps1');
            [tm2,ts2,te2]=MeanDifNan(tps2');
                            
            subplot(2,3,5), hold on, %legend('Pre','Post');
            errorbar([tm1, tm2],[te1, te2],'k+')
            bar([tm1, tm2],'k'), xlim([0 3])
            ylabel('Time delay to Stim area (s)')
            set(gca,'xtick',1:2)
            set(gca,'xticklabel',legend)
            
            
            
            [am1,as1,ae1]=MeanDifNan(ang1');
            [am2,as2,ae2]=MeanDifNan(ang2');
            
            subplot(2,3,6), hold on, %legend('Pre','Post');
            errorbar([am1, am2],[ae1, ae2],'k+')
            bar([am1, am2],'k'), xlim([0 3])
            ylabel('Cumulative angle to Stim area (deg)')
            set(gca,'xtick',1:2)
            set(gca,'xticklabel',legend)
                      
end





%figure, 
%subplot(2,2,2), imagesc(OcR2),axis xy, ca1=caxis;
%subplot(2,2,1), imagesc(OcR1),axis xy,caxis(ca1)
%subplot(2,2,4), imagesc(OcR2+20*m2),axis xy, ca2=caxis;
%subplot(2,2,3), imagesc(OcR1+20*m1),axis xy,caxis(ca2)


%-------------------------------------------
% plot distance to stim zone

% figure, plot(Data(X1),Data(Y1),'ko')
% 
% circle([200,200],200,1000)
% hold on, circle([xc,yc],sqrt((x-xc)^2+(y-yc)^2),1000)
% hold on, scatter(Data(X1),Data(Y1),1)
% figure, bar(Range(X1)*10^(-4),Dist)
