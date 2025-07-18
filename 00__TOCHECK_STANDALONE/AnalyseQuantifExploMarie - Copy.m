function [mapS,OcRS1,OcRS2,homogeneity,TimeInStimArea,CorrelationCoefCorrected,DistanceToStimZone,DelayToStimZone]=AnalyseQuantifExploMarie(o,N,M,NumNeuron,NumExplo)

% o: epoch ICSS
% N: epoch Pre
% M: epoch Post
% NumNeuron: number of the neuron choosen for the placeField (if 0 use stimulation)
% NumExpo: num of the session to compute the place field


thPF=0.5;
smo=3;
sizeMap=50;
tpsTh=0.75*1E4;
Limdist=30;
Vth=20;


%EpochT
NbTrials=length(N);

if NbTrials==8
    limTemp=30; % Time length per session (s)
else 
    limTemp=60;
end

limTemp=60;

sav=1;
try 
    NumNeuron;
    NumExplo;
catch   
NumNeuron=0; % 0 si pas de place field, 6 pr M17-20110622
NumExplo=1; % Explo pour calculer le place field
end

load behavResources
load SpikeData

limMaz=[0 400];


figure('color',[1 1 1]),
plot(Data(Restrict(X,TrackingEpoch)),Data(Restrict(Y,TrackingEpoch)))
Title('Delimiter le contour de l''environnement');
[xMaz,yMaz]=ginput;

limMaze=[min(min(xMaz),min(yMaz)),max(max(xMaz),max(yMaz))];
limM=[limMaze(1)-0.05*diff(limMaze),limMaze(2)+0.05*diff(limMaze)];


Xx=Data(X);
Yy=Data(Y);
Xx(Xx<=min(xMaz))=min(xMaz);
Xx(Xx>=max(xMaz))=max(xMaz);
Yy(Yy<=min(yMaz))=min(yMaz);
Yy(Yy>=max(yMaz))=max(yMaz);
X=tsd(Range(X),Xx-min(xMaz));
Y=tsd(Range(Y),Yy-min(yMaz));
limMaz=[0 max(max(xMaz)-min(xMaz),max(yMaz)-min(yMaz))];
plot(Data(Restrict(X,TrackingEpoch)),Data(Restrict(Y,TrackingEpoch)),'k')  
axis image
Axs=axis;
close




%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%close all

        legend{1}='Pre';
        legend{2}='Post';
        legend{3}='Pre';
        legend{4}='Post';

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
kl=Range(X);
MvtOK=intervalSet(kl(1),kl(end))-Mvt;
goEpoch=intersect(TrackingEpoch,intervalSet(kl(1),kl(end))-SleepEpoch-RestEpoch);

if 1
figure('color',[1 1 1]), 
hist(Data(Restrict(V,goEpoch)),[0:1:100]), xlim([0 100])

S=Restrict(S,MvtOK);
X=Restrict(X,MvtOK);
Y=Restrict(Y,MvtOK);
V=Restrict(V,MvtOK);

end



Epoch1=subset(QuantifExploEpoch,N);
Epoch2=subset(QuantifExploEpoch,M);
X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
Y2=Restrict(Y,Epoch2);
X2=Restrict(X,Epoch2);



%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
EpochS=ICSSEpoch;
EpochS=subset(EpochS,o);
XS=Restrict(X,EpochS);
YS=Restrict(Y,EpochS);
stimS=Restrict(stim,EpochS);

if NumNeuron==0
    nom='Stim Area';
    %[mapS,mapSs,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceField(stimS,XS,YS,'size',sizeMap,'limitmaze',limMaz,'smoothing',6);
    [mapS,mapSs,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceFieldPoisson(stimS,XS,YS,'size',sizeMap,'limitmaze',limMaz,'smoothing',smo,'threshold',thPF);
    %positions=[Range(Restrict(X,Epoch),'s') Data(Restrict(X,Epoch)) Data(Restrict(Y,Epoch))];
    %[fm,st] = FiringMap(positions,Range(stimS,'s'));   
    %PF=st.field;

else
    nom='Place Field';
    
%     XS=X;
%     YS=Y;
    Starts=[];
    Ends=[];
    for i=NumExplo
    Starts=[Starts,tpsdeb{i}];
    Ends=[Ends,tpsfin{i}];
    end
    Epoch=intervalSet(Starts*1E4,Ends*1E4);
    spike=Restrict(S{NumNeuron},Epoch);
    [mapS,mapSs,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceField(spike,Restrict(X,Epoch),Restrict(Y,Epoch),'size',sizeMap,'limitmaze',limMaz,'smoothing',smo,'threshold',thPF);
    hold on; title(['Neuron ',num2str(NumNeuron)]);
    %PlaceFieldPoisson(spike,Restrict(X,Epoch),Restrict(Y,Epoch),'size',sizeMap,'limitmaze',limMaz,'smoothing',smo);
    %         [mapMv,mapSMv,statsMv,pxMv,pyMv]=PlaceField(Restrict(spike,Mvt),Restrict(X,Mvt),Restrict(Y,Mvt),'smoothing',3,'size',50);
    %         hold on; title(['RestrictEpoch; Neuron ',num2str(NumNeuron)]);
%positions=[Range(Restrict(X,Epoch),'s') Data(Restrict(X,Epoch)) Data(Restrict(Y,Epoch))];
%[fm,st] = FiringMap(positions,Range(spike,'s'));   
%PF=st.field;

end

rS=corrcoef(mapS.rate(:),mapS.time(:));
ICSSefficiency=rS(1,2);



kk=GravityCenter(PF);

m=mapS.rate;
m(PF==0)=0;
SE=strel('square',6);
PFb=imdilate(PF,SE);
mb=mapS.rate;
mb(PFb==0)=0;



[Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(X1,Y1,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
[Oc2,OcS2,OcR2,OcRS2]=OccupancyMapKB(X2,Y2,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
[OcS,OcSS,OcRS,OcRSS]=OccupancyMapKB(XS,YS,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
try
[OcT,OcST,OcRT,OcRST]=OccupancyMapKB(Restrict(X,EpochT),Restrict(X,EpochT),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
catch
    
    [OcT,OcST,OcRT,OcRST]=OccupancyMapKB(X,Y,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
end

m1=OcR1;
m1(PF==0)=0;
m2=OcR2;
m2(PF==0)=0;
mS=OcRS;
mS(PF==0)=0;

m1S=OcRS1;
m1S(PF==0)=0;
m2S=OcRS2;
m2S(PF==0)=0;
mSS=OcRSS;
mSS(PF==0)=0;

m1b=OcR1;
m1b(PFb==0)=0;
m2b=OcR2;
m2b(PFb==0)=0;
mSb=OcRS;
mSb(PFb==0)=0;

m1Sb=OcRS1;
m1Sb(PFb==0)=0;
m2Sb=OcRS2;
m2Sb(PFb==0)=0;
mSSb=OcRSS;
mSSb(PFb==0)=0;

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% homogeneity

BW=OcT;
BW(BW>0)=1;
[B,L,Nn,Aa] = bwboundaries(BW);
BW(L>0)=1;



%figure('color',[1 1 1]), 
%subplot(2,1,1), imagesc(OcRS1), axis xy, ca=caxis;
%subplot(2,1,2), imagesc(BW+OcRS1-1),axis xy, caxis([-0.1 ca(2)])



VOcR1=OcRS1;
VOcR1(find(BW==0))=[];

VOcR2=OcRS2;
VOcR2(find(BW==0))=[];

MO1=mean(mean(VOcR1))*ones(size(VOcR1,1),size(VOcR1,2));
MO2=mean(mean(VOcR2))*ones(size(VOcR2,1),size(VOcR2,2));
MOCR1=VOcR1-MO1;
MOCR2=VOcR2-MO2;
homogeneity(1,1)=1-sum(abs(MOCR1(:)))/(100+length(VOcR1)*mean(MO1));
homogeneity(2,1)=1-sum(abs(MOCR2(:)))/(100+length(VOcR1)*mean(MO2));



chi(1,1)=sum((VOcR1(:)-MO1(:)).^2./MO1(:).^2);
p(1,1)=1-gammainc(chi(1,1)/2,(length(MO1(:))-1)/2);

chi(2,1)=sum((VOcR2(:)-MO2(:)).^2./MO2(:).^2);
p(2,1)=1-gammainc(chi(2,1)/2,(length(MO2(:))-1)/2);

homogeneity(1,2)=chi(1,1);
homogeneity(1,3)=p(1,1);
homogeneity(2,2)=chi(2,1);
homogeneity(2,3)=p(2,1);


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% compute Instantaneous Angle
Angl = ComputeInstantaneuousAngle(Data(X),Data(Y));
Ang=tsd(Range(X),Angl);
Ang=Restrict(Ang,Mvt);


Ang1 = Restrict(Ang,Epoch1);
Ang2 = Restrict(Ang,Epoch2);



%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Compute Distance to stimZone

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

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
% Compute exploration in quadrant (8 zones of 3hours)
      
ce=[round((max([Data(X1);Data(X2)])-min([Data(X1);Data(X2)]))/2),round((max([Data(Y1);Data(Y2)])-min([Data(Y1);Data(Y2)]))/2)];
% figure, plot([Data(X1);Data(X2)], [Data(Y1);Data(Y2)]);xlim([0,300]);ylim([0,300]);
% Nfig=gcf;
% [xq,yq]=ginput('limite basse du quadrant',1);
% hold on, plot([ce(1) xq],[ce(2) yq],'r-')
% ok=input('La limite basse du quadrant de stimulation est-elle ok? (o/n)','s');
% 
% while ok~='o'
%     figure(Nfig), plot([Data(X1);Data(X2)], [Data(Y1);Data(Y2)]);xlim([0,300]);ylim([0,300]);
%     [xq,yq]=ginput('limite basse du quadrant',1);
%     hold on, plot([ce(1) xq],[ce(2) yq],'r-')
%     ok=input('La limite basse du quadrant de stimulation est-elle ok? (o/n)','s');
% end  
        
 
%-----------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

% Compute time spent in the stimulation area
% Compute correlation coeff between explo and StimExplo

CorrelationCoef=[];
TimeInStimArea=[];
QuadrantTime=[];

    for q=[N,M]
        i=rem(q,NbTrials);
        if i==0
            i=NbTrials;
        end
        if ismember(q,N)
            j=1; %pre
        elseif ismember(q,M)
            j=2; %post
        end
        Epoch=subset(QuantifExploEpoch,q);
        durEpoch=End(Epoch,'s')-Start(Epoch,'s');
        Xij=Restrict(X,Epoch);
        Yij=Restrict(Y,Epoch);
        
        [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Xij,Yij,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
        
        mSij=OcRS;
        mSij(PF==0)=0;
        mSbij=OcRS;
        mSbij(PFb==0)=0;

        TimeInStimArea(i,j)=sum(sum(mSij));
        TimeInLargeStimArea(i,j)=sum(sum(mSbij));
        %r=corrcoef(mapS.rate(:),OcRS(:));
        r=corrcoef(mapS.rate(find(BW==1)),OcRS(find(BW==1)));
        val1=mapS.rate(find(BW==1));
        val2=OcRS(find(BW==1));
        
        level1=max(val1)/5;
        level2=max(val2)/5;
       
        [rcorrected,p1corrected]=corrcoef(val1(find(val1>level1|val2>level2)),val2(find(val1>level1|val2>level2)));

        CorrelationCoef(i,j)=r(1,2);
        CorrelationCoefCorrected(i,j)=rcorrected(1,2);
        
        Angij=Restrict(Ang,Epoch);
        try
            int=thresholdIntervals(Restrict(dis,Epoch),Limdist,'Direction','Below');
            intr=dropShortIntervals(int,tpsTh);
            %int1r=int1;
            rg=Start(intr,'s');
            ref=Range(Restrict(dis,Epoch),'s');
            tps=rg(1)-ref(1);
            trajdir=intervalSet(ref(1)*1E4,rg(1)*1E4);
            StdAngle(i,j)=std(Data(Restrict(Angij,trajdir)));    
        catch
            tps=limTemp;
            StdAngle(i,j)=nanmean(Data(Ang2));
            
        end
        
        zone1=thresholdIntervals(Xij,ce(1),'Direction','Above');
        zone2=thresholdIntervals(Xij,ce(1),'Direction','Below');
        zone3=thresholdIntervals(Yij,ce(2),'Direction','Above');
        zone4=thresholdIntervals(Yij,ce(2),'Direction','Below');
        
        zoneNE=and(zone1,zone3);
        zoneSE=and(zone1,zone4);
        zoneNW=and(zone2,zone3);
        zoneSW=and(zone2,zone4);
        % 1+5 NE, 2+6 SE, 3+7 NW, 4+8 SW 
        QuadrantTime(i,(j-1)*4+1)=length(Data(Restrict(Xij,zoneNE)))/30;
        QuadrantTime(i,(j-1)*4+2)=length(Data(Restrict(Xij,zoneSE)))/30;
        QuadrantTime(i,(j-1)*4+3)=length(Data(Restrict(Xij,zoneNW)))/30;
        QuadrantTime(i,(j-1)*4+4)=length(Data(Restrict(Xij,zoneSW)))/30;
    end

%keyboard


figure('color',[1 1 1]), 
EpochA1=subset(QuantifExploEpoch,N);
EpochA2=subset(QuantifExploEpoch,M);
subplot(1,3,1), hold on 
plot(Data(Restrict(X,EpochA1)),Data(Restrict(Y,EpochA1)),'color', 'b')
subplot(1,3,2), hold on 
plot(Data(Restrict(X,EpochA2)),Data(Restrict(Y,EpochA2)),'color', 'r')
subplot(1,3,3), hold on 
plot(Data(Restrict(X,EpochA1)),Data(Restrict(Y,EpochA1)),'color', [0.7 0.7 1])
plot(Data(Restrict(X,EpochA2)),Data(Restrict(Y,EpochA2)),'color', [1 0.7 0.7])



figure('color',[1 1 1]), 
AllsessionFig=gcf;
Colori={'b' 'c' 'g' 'r' 'b' 'c' 'g' 'r' 'k'};
L=length(Start(TrackingEpoch));
Lq=length(Start(QuantifExploEpoch));
PloSiz=ceil((L-Lq+round(Lq/NbTrials))/4);
c=0;q=0;

for l=1:L
    try
        
        if N<4|M<4
            TrackEpoch=subset(TrackingEpoch,l);
            TrackEpoch=intersect(TrackingEpoch,intervalSet(tpsdeb{c+1}*1E4,tpsfin{c+1}*1E4));
        else
            TrackEpoch=subset(TrackingEpoch,l);
        end

        if ismember(Start(TrackEpoch),Start(QuantifExploEpoch))==1
              q=q+1;
              col=q;
              if rem((q-1),NbTrials)==0
                  c=c+1;
                  col=1;
                  q=1;
              end
        else
              c=c+1;
              col=9;
        end
      
      hold on, subplot(PloSiz,4,c), plot(Data(Restrict(X,TrackEpoch)),Data(Restrict(Y,TrackEpoch)),Colori{col});xlim(limMaz);ylim(limMaz); axis(Axs)

      title(namePos{c}(27:end-9));
      
      if ismember(Start(TrackEpoch),Start(ICSSEpoch))==1
          RgStim=Range(Restrict(stim,TrackEpoch));
          FirstStim=RgStim(1);
          FirstEpoch=intervalSet(FirstStim,Stop(TrackEpoch));
          hold on, subplot(PloSiz,4,c), plot(Data(Restrict(X,FirstEpoch)),Data(Restrict(Y,FirstEpoch)),'b');xlim(limMaz);ylim(limMaz);axis(Axs)
      end
    end
end
      
%---------------------------
%---------- plot ----------

%%% Time spent in  Stimulation area
durEpoch1=sum(End(Epoch1,'s')-Start(Epoch1,'s'));
durEpoch2=sum(End(Epoch2,'s')-Start(Epoch2,'s'));

[Df1,Sf1,Ef1]=MeanDifNan(TimeInStimArea(:,1));
[Df2,Sf2,Ef2]=MeanDifNan(TimeInStimArea(:,2));
[Df3,Sf3,Ef3]=MeanDifNan(TimeInLargeStimArea(:,1));
[Df4,Sf4,Ef4]=MeanDifNan(TimeInLargeStimArea(:,2));
[h,pTiA]=ttest(TimeInStimArea(:,1),TimeInStimArea(:,2));
[h,pTiLA]=ttest(TimeInLargeStimArea(:,1),TimeInLargeStimArea(:,2));
    
figure('color',[1 1 1]),
subplot(2,3,1:2); hold on,
errorbar([Df1,Df2,Df3,Df4],[Ef1,Ef2,Ef3,Ef4],'k+')
bar([Df1,Df2,Df3,Df4],'k'), xlim([0 5])
% bar([sum(sum(m1S))/durEpoch1 sum(sum(m2S))/durEpoch2 sum(sum(m1Sb))/durEpoch1 sum(sum(m2Sb))/durEpoch2],'k')
ylabel(['Time spent in  ',num2str(nom),' (%)'])
xlabel(['larged p=',num2str(pTiA),' unlarged p=',num2str(pTiLA)])
set(gca,'xtick',1:4)
set(gca,'xticklabel',legend)

numfig=gcf;

subplot(2,3,3)

[r1,p1]=corrcoef(mapS.rate(find(BW==1)),OcRS1(find(BW==1)));
[r2,p2]=corrcoef(mapS.rate(find(BW==1)),OcRS2(find(BW==1)));

val1=mapS.rate(find(BW==1));
val2=OcRS1(find(BW==1));
val3=OcRS2(find(BW==1));

level1=max(val1)/5;
level2=max(val2)/5;
level3=max(val3)/5;

[r1corrected,p1c]=corrcoef(val1(find(val1>level1|val2>level2)),val2(find(val1>level1|val2>level2)));
[r2corrected,p2c]=corrcoef(val1(find(val1>level1|val3>level3)),val3(find(val1>level1|val3>level3)));

r1=r1(1,2);
r2=r2(1,2);
r1c=r1corrected(1,2);
r2c=r2corrected(1,2);

CorrelationCoef(10,1)=r1;CorrelationCoef(11,1)=p1(1,2);
CorrelationCoef(10,2)=r2;CorrelationCoef(11,2)=p2(1,2);
CorrelationCoefCorrected(10,1)=r1c; CorrelationCoefCorrected(11,1)=p1c(1,2);
CorrelationCoefCorrected(10,2)=r2c; CorrelationCoefCorrected(11,2)=p2c(1,2);

bar([r1 r2 r1c r2c],'k')
ylabel(['Correlation Occ. Map vs ',num2str(nom)])
xlabel(['p value= ',num2str(floor(p1(1,2)*1000)/1000),'  ',num2str(floor(p2(1,2)*1000)/1000),'  ',num2str(floor(p1c(1,2)*1000)/1000),'  ',num2str(floor(p2c(1,2)*1000)/1000)])
set(gca,'xtick',1:4)
set(gca,'xticklabel',legend)


%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

figure('color',[1 1 1]),
subplot(2,4,4), imagesc(-OcRS2),axis xy, caS1=caxis; title('Explo Post'), colorbar,hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,4,2), imagesc(-OcRS1),axis xy,caxis(caS1); title('Explo Pre'),colorbar, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,4,5), imagesc(m),colorbar,axis xy, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')

if NumNeuron==0
    subplot(2,4,1), imagesc(mapS.rate), axis xy, title('ICSS'),colorbar, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
    subplot(2,4,3), imagesc(-OcRSS),axis xy,caxis(caS1); title('Explo ICSS'),colorbar, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
else
    subplot(2,4,3), imagesc(-OcRSS),axis xy,caxis(caS1); title('Sleep/Explo ICSS'),colorbar, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
    subplot(2,4,1), imagesc(mapS.rate), axis xy, title('PlaceField'),colorbar, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
end


subplot(2,4,8), imagesc(-(OcRS2+2*m2S)), axis xy,caS2=caxis;colorbar, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
subplot(2,4,6), imagesc(-(OcRS1+2*m1S)), axis xy,caxis(caS2),colorbar, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')


% figure('color',[1 1 1]),
% subplot(2,3,1), imagesc(mapS.rate), axis xy, title('ICSS/Spike'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
% subplot(2,3,4), imagesc(mb),axis xy, hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
% 
% subplot(2,3,3), imagesc(OcRS2),axis xy, caS1=caxis; title('Explo Post'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
% subplot(2,3,2), imagesc(OcRS1),axis xy,caxis(caS1); title('Explo Pre'), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
% subplot(2,3,6), imagesc(OcRS2+2*m2Sb), axis xy,caS2=caxis; hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
% subplot(2,3,5), imagesc(OcRS1+2*m1Sb), axis xy,caxis(caS2), hold on, plot(kk(1),kk(2),'ko','markerFaceColor','w')
%--------------------------------------------------------------------------



if length(Start(Epoch1))==1
    dis1=Restrict(dis,Epoch1);
    dis2=Restrict(dis,Epoch2);
    figure('color',[1 1 1]), hold on
    plot(pxS,pyS,'.','Color',[0.7 0.7 0.7])
    plot(Data(Restrict(X,Epoch1)),Data(Restrict(Y,Epoch1)))
    plot(Data(Restrict(X,Epoch2)),Data(Restrict(Y,Epoch2)),'r');
    st1=Start(Epoch1);
    st2=Start(Epoch2);
    plot(Data(Restrict(X,st1)),Data(Restrict(Y,st1)),'bo','markerfacecolor','b')
    plot(Data(Restrict(X,st2)),Data(Restrict(Y,st2)),'ro','markerfacecolor','r')
    numfig2=gcf;
    
    
    D1=sum(Data(dis1))/length(Data(dis1));
    D2=sum(Data(dis2))/length(Data(dis2));
    
    figure(numfig), subplot(2,3,4)
    bar([D1/2,D2/2],'k'), xlim([0 3]) % Attention!!! Distance divisée par 2 pour avoir la valeur en cm !!! (calcul approximatif)
    ylabel(['Mean distance to ',num2str(nom),' (cm)'])
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
    ylabel(['Time delay to ',num2str(nom),' (s)'])
    set(gca,'xtick',1:2)
    set(gca,'xticklabel',legend)
        
    subplot(2,3,6), hold on, %legend('Pre','Post');
    bar([ang1, ang2],'k'), xlim([0 3])
    ylabel(['Cumulative angle to ',num2str(nom),' (deg)'])
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
        DistanceToStimZone=[D1',D2'];
        
        try
            int1=thresholdIntervals(Dis1,Limdist,'Direction','Below');
            int1r=dropShortIntervals(int1,tpsTh);
            rg1=Start(int1r,'s');
            ref1=Range(Dis1,'s');
            tps1(i)=rg1(1)-ref1(1);
            trajdir1=intervalSet(ref1(1)*1E4,rg1(1)*1E4);
            ang1(i)=std(Data(Restrict(Ang1,trajdir1)));
        catch
            tps1(i)=limTemp;
            ang1(i)=nanmean(Data(Ang1));
        end
        
        try
            int2=thresholdIntervals(Dis2,Limdist,'Direction','Below');
            int2r=dropShortIntervals(int2,tpsTh);
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
        
    %%% Cumulative distance to Stim area
    [Df1,Sf1,Ef1]=MeanDifNan(D1');
    [Df2,Sf2,Ef2]=MeanDifNan(D2');
    [h,pDis]=ttest(D1,D2);    

    figure(numfig),
    subplot(2,3,4),hold on,
    errorbar([Df1,Df2],[Ef1,Ef2],'k+')
    bar([Df1,Df2],'k'), xlim([0 3])
    ylabel(['Mean distance to ',num2str(nom),' (cm)'])
    xlabel(['p value = ',num2str(pDis)])
    set(gca,'xtick',1:2)
    set(gca,'xticklabel',legend)
    
    
    %%% Time delay to Stim area
    tps1(tps1>limTemp)=limTemp;
    tps2(tps2>limTemp)=limTemp;
    DelayToStimZone=[tps1',tps2'];
    [tm1,ts1,te1]=MeanDifNan(tps1');
    [tm2,ts2,te2]=MeanDifNan(tps2');
    [h,pTps]=ttest(tps1,tps2);
    
    subplot(2,3,5), hold on, %legend('Pre','Post');
    errorbar([tm1, tm2],[te1, te2],'k+')
    bar([tm1, tm2],'k'), xlim([0 3])
    ylabel(['Time delay to ',num2str(nom),' (s)'])
    xlabel(['p value = ',num2str(pTps)])
    set(gca,'xtick',1:2)
    set(gca,'xticklabel',legend)
    
    
    %%% Cumulative angle to Stim area
%     StdAngle=[ang1',ang2'];
    [am1,as1,ae1]=MeanDifNan(ang1');
    [am2,as2,ae2]=MeanDifNan(ang2');
    [h,pAng]=ttest(ang1,ang2);
    
    subplot(2,3,6), hold on, %legend('Pre','Post');
    errorbar([am1, am2],[ae1, ae2],'k+')
    bar([am1, am2],'k'), xlim([0 3])
    ylabel(['Cumulative angle to ',num2str(nom),' (deg)'])
    xlabel(['p value = ',num2str(pAng)])
    set(gca,'xtick',1:2)
    set(gca,'xticklabel',legend)
    
end


if sav==1
    c=cd;
    filename=([num2str(c(end-21:end)),'-AnalyseResourcesICSS-',num2str(o)]);
    save filename homogeneity TimeInStimArea TimeInLargeStimArea CorrelationCoef CorrelationCoefCorrected DistanceToStimZone StdAngle DelayToStimZone QuadrantTime mapS mapSs
end


%keyboard



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
