
function [chi,p]=testHomogeneity(si,FAC)


try
    FAC;
catch
    FAC=0;
end


load behavResources

%o,N,M,NumNeuron,NumExplo



o=2:4;
N=17:24;
M=25:32;
NumNeuron=0;

try 
    NumNeuron;
    NumExplo;
catch   
NumNeuron=0; % 0 si pas de place field, 6 pr M17-20110622
NumExplo=1; % Explo pour calculer le place field
end


limTemp=30; % Time length per session (s)
limMaz=400;
NbTrials=8;
Epoch1=subset(QuantifExploEpoch,N);
Epoch2=subset(QuantifExploEpoch,M);
X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
Y2=Restrict(Y,Epoch2);
X2=Restrict(X,Epoch2);
smo=2;
sizeMap=22;
tpsTh=0.75*1E4;
Limdist=30;
Vth=20;

EpochS=ICSSEpoch;
EpochS=subset(EpochS,o);

Mvt=thresholdIntervals(V,Vth,'Direction','Above');
XS=Restrict(X,EpochS);
YS=Restrict(Y,EpochS);
stimS=Restrict(stim,EpochS);



[Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(X1,Y1,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 limMaz]);close
[Oc2,OcS2,OcR2,OcRS2]=OccupancyMapKB(X2,Y2,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 limMaz]);close
[OcS,OcSS,OcRS,OcRSS]=OccupancyMapKB(XS,YS,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 limMaz]);close
try
[OcT,OcST,OcRT,OcRST]=OccupancyMapKB(Restrict(X,EpochT),Restrict(X,EpochT),'axis',[0 15],'smoothing',0.5,'size',si,'limitmaze',[0 limitmaze]);close
catch
[OcT,OcST,OcRT,OcRST]=OccupancyMapKB(X,Y,'axis',[0 15],'smoothing',0.5,'size',si,'limitmaze',[0 limMaz]);close    
end

BW=OcT;
BW(BW>0)=1;
[B,L,N,A] = bwboundaries(BW);
BW(L>0)=1;


if FAC

        a=1;

        for fac=1:2:20

                test2=OcRS2;
                mtest2=mean(mean(test2(find(BW==1))))*ones(size(test2,1),size(test2,2));

                test1=OcRS1;
                mtest1=mean(mean(test1(find(BW==1))))*ones(size(test1,1),size(test1,2));

                VOcR1=OcRS1+1*mtest1;
                VOcR1(find(BW==0))=[];

                VOcR2=OcRS2+0.55*mtest2;
                VOcR2=rand(size(test1,1),size(test1,2))+fac*rescale(OcRS2,0,1);

                figure, imagesc(VOcR2), caxis([0 18])
                VOcR2(find(BW==0))=[];

                MO1=mean(mean(VOcR1))*ones(size(VOcR1,1),size(VOcR1,2));
                MO2=mean(mean(VOcR2))*ones(size(VOcR2,1),size(VOcR2,2));
                MOCR1=VOcR1-MO1;
                MOCR2=VOcR2-MO2;
                homogeneity(1,1)=1-sum(abs(MOCR1(:)))/(100+length(VOcR1)*mean(MO1));
                homogeneity(2,1)=1-sum(abs(MOCR2(:)))/(100+length(VOcR1)*mean(MO2));
                chi(1,a)=sum((VOcR1(:)-MO1(:)).^2./MO1(:).^2);
                p(1,a)=1-gammainc(chi(1,1)/2,(length(MO1(:))-1)/2);

                chi(2,a)=sum((VOcR2(:)-MO2(:)).^2./MO2(:).^2);
                p(2,a)=1-gammainc(chi(2,1)/2,(length(MO2(:))-1)/2);
                a=a+1;
                title([num2str(fac),', chi=',num2str(chi(2,1)),', p=',num2str(p(2,1))])
                
        end

else
    

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
        %title([' chi=',num2str(chi(2,1)),', p=',num2str(p(2,1))])

    
end



chi=chi';
p=p';
