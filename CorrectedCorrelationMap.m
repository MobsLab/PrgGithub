function [r1,p1,r3,p3,rcorrected,pcorrected]=CorrectedCorrelationMap(X,Y,Epoch1,Epoch2,varargin)


%   X,Y,Epoch1,Epoch2
%   varargin:
%      'smoothing',
%      'limitmaze',
%      'sizeMaze',		
%      'threshold',
%


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



smo=1;
si=62;
sizeMap=50;
limitmaze=350;
th=1;
levth=5;
tsa=0;


for i = 1:2:length(varargin),
	
	switch(lower(varargin{i})),
		
        case 'smoothing',
			smo = varargin{i+1};
		
		case 'limitmaze',
			limitmaze = varargin{i+1};
			
		case 'sizeMaze',
			si = varargin{i+1};
			
        case 'threshold',
			th = varargin{i+1};
        
        case 'spikes'
            tsa=varargin{i+1};
    
    end
    
end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
Y2=Restrict(Y,Epoch2);
X2=Restrict(X,Epoch2);

try
    tsa1=Restrict(tsa,Epoch1);
    tsa2=Restrict(tsa,Epoch2);
end


try 
    tsa;

    [mapS1,mapSs1,statsS1,pxS1,pyS1,Fr1,si,PF1,centre1]=PlaceField(tsa1,X1,Y1,'size',sizeMap,'smoothing',smo*3,'limitmaze',[0 limitmaze]);close
    [mapS2,mapSs2,statsS2,pxS2,pyS2,Fr2,si,PF2,centre2]=PlaceField(tsa2,X2,Y2,'size',sizeMap,'smoothing',smo*3,'limitmaze',[0 limitmaze]);close

    OcRS1=mapS1.rate;
    OcRS2=mapS2.rate;
    
catch
    
    [Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(X1,Y1,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 limitmaze]);close
    [Oc2,OcS2,OcR2,OcRS2]=OccupancyMapKB(X2,Y2,'axis',[0 15],'smoothing',smo,'size',si,'limitmaze',[0 limitmaze]);close

end

[OcT,OcST,OcRT,OcRST]=OccupancyMapKB(X,Y,'axis',[0 15],'smoothing',0.5,'size',si,'limitmaze',[0 limitmaze]);close





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


BW=OcT;
BW(BW>0)=1;
[B,L,N,A] = bwboundaries(BW);
BW(L>0)=1;

val1b=OcRS1;
val2b=OcRS2;

val1=OcRS1(find(BW==1));
val2=OcRS2(find(BW==1));


if th==1
    
    level1=max(val1)/levth;
    level2=max(val2)/levth;
else
    level1=percentile(val1,th);
    level2=percentile(val2,th);
end

val1c=val1(find(val1>level1|val2>level2));
val2c=val2(find(val1>level1|val2>level2));


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


[r1,p1]=corrcoef(val1b(:),val2b(:));
[r2,p2]=corrcoef(zscore(val1b(:)),zscore(val2b(:)));
[r3,p3]=corrcoef(val1,val2);
[r4,p4]=corrcoef(zscore(val1),zscore(val2));
[rcorrected,pcorrected]=corrcoef(val1c,val2c);

r1=r1(2,1);
r2=r2(2,1);
r3=r3(2,1);
r4=r4(2,1);
rcorrected=rcorrected(2,1);
p1=p1(2,1);
p2=p2(2,1);
p3=p3(2,1);
p4=p4(2,1);
pcorrected=pcorrected(2,1);

[h1,b1]=hist(val1,100);
[h2,b2]=hist(val2,100);




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


figure('color',[1 1 1]), hold on
subplot(3,3,1), plot(val1b(:),val2b(:),'.'), title(['classic, r=',num2str(r1),', p=',num2str(p1)]), xlim([min(val1b(:)) max(val1b(:))]), ylim([min(val2b(:)) max(val2b(:))])
%subplot(3,3,4), plot(zscore(val1b(:)),zscore(val2b(:)),'.'), title(['classic zscore, r=',num2str(r2),', p=',num2str(p2)]), xlim([min(zscore(val1b(:))) max(zscore(val1b(:)))]), ylim([min(zscore(val2b(:))) max(zscore(val2b(:)))])
subplot(3,3,2), plot(val1,val2,'.'), title(['PF, r=',num2str(r3),', p=',num2str(p3)]), xlim([min(val1(:)) max(val1(:))]), ylim([min(val2(:)) max(val2(:))])
%subplot(3,3,5), plot(zscore(val1),zscore(val2),'.'), title(['zscore PF, r=',num2str(r4),', p=',num2str(p4)]), xlim([min(zscore(val1(:))) max(zscore(val1(:)))]), ylim([min(zscore(val2(:))) max(zscore(val2(:)))])
subplot(3,3,3), plot(val1c,val2c,'.'), title(['low values corrected, r=',num2str(rcorrected),', p=',num2str(pcorrected)]), xlim([min(val1c(:)) max(val1c(:))]), ylim([min(val2c(:)) max(val2c(:))])

subplot(3,3,6), hold on
%plot(log(b1),h1,'k','linewidth',2), 
%plot(log(b2),h2,'r','linewidth',2),
plot(b1,log(h1),'k','linewidth',2), 
plot(b2,log(h2),'r','linewidth',2),
yl=[0 max(max([log(h1),log(h2)]))];
%plot(b1,h1,'k','linewidth',2), 
%plot(b2,h2,'r','linewidth',2),
%yl=[0 max(max([h1,h2]))];
line([level1 level1],yl,'color','b')
line([level2 level2],yl,'color','m')
ylim(yl)

%figure('color',[1 1 1]), hold on
subplot(3,3,4), imagesc(OcRS1), colorbar
subplot(3,3,5),imagesc(OcRS2), colorbar
subplot(3,3,9),imagesc(100*(rescale(OcRS2,0,1)-rescale(OcRS1,0,1))), caxis([-100 100]),colorbar

map1.rate=OcRS1;
map1.time=BW;
map2.rate=OcRS2;
map2.time=BW;

%figure('color',[1 1 1]), 
subplot(3,3,7), PlotPF(map1,'figure','old')
subplot(3,3,8), PlotPF(map2,'figure','old')


%keyboard
