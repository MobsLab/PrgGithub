function HomogeneityExplo

% homogeneity

disp('pas fini')

Epoch1=subset(QuantifExploEpoch,N);
Epoch2=subset(QuantifExploEpoch,M);
X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
Y2=Restrict(Y,Epoch2);
X2=Restrict(X,Epoch2);



[Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(X1,Y1,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
[Oc2,OcS2,OcR2,OcRS2]=OccupancyMapKB(X2,Y2,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close


try
    [OcT,OcST,OcRT,OcRST]=OccupancyMapKB(Restrict(X,EpochT),Restrict(X,EpochT),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
catch
    
    [OcT,OcST,OcRT,OcRST]=OccupancyMapKB(X,Y,'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
end


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
