function QuantifEfficiencyICSSWake(n,pas,varargin)

load behavResources

try
    pas;
catch
    pas=50;
end

smo=2;
sizeMap=50;
thPF=0.3;
posArt=1;
sav=0;


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
                  
                                 
                 case 'thresholdPF',
                  thPF = varargin{i+1};
                  if ~isa(thPF,'numeric'),
                    error('Incorrect value for property ''thresholdPF'' (type ''help AnalysisQuantifExploJan2012'' for details).');
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
 
 
 
numfi=gcf;
jetinv=jet;
jetinv=jetinv(end:-1:1,:);


S=tsd([],[]);

[X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,TrackingEpoch,posArt);


Xmin=min(min(Data(X)));
Xmax=max(max(Data(X)));
Ymin=min(min(Data(Y)));
Ymax=max(max(Data(Y)));


figure('color',[1 1 1]),
num=gcf;
a=1;
for i=1:10
    try
        if tpsdeb{n}+i*pas<tpsfin{n}
Epoch=intervalSet((tpsdeb{n}+(i-1)*pas)*1E4,(tpsdeb{n}+i*pas)*1E4);
subplot(4,4,a),hold on,
plot(Data(X),Data(Y),'color',[0.7 0.7 0.7])
plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'k','linewidth',2)
plot(Data(Restrict(X,Restrict(stim,Epoch))),Data(Restrict(Y,Restrict(stim,Epoch))),'r.'), xlim([Xmin Xmax]), ylim([Ymin Ymax])
[Oc,OcS,OcR,OcRS]=OccupancyMapKB(Restrict(X,Epoch),Restrict(Y,Epoch),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
subplot(4,4,a+1), imagesc(OcS), axis xy, colormap(jetinv)
a=a+2;
        end
    end
end


Epoch=intervalSet((tpsdeb{n})*1E4,(tpsfin{n})*1E4);

figure('color',[1 1 1]),numfig2=gcf;
subplot(1,3,1), hold on
plot(Data(Restrict(X,TrackingEpoch)),Data(Restrict(Y,TrackingEpoch)),'color',[0.7 0.7 0.7])
plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'r','linewidth',2)
title('Trajectory and stimulation')
[Oc,OcS,OcR,OcRS]=OccupancyMapKB(Restrict(X,Epoch),Restrict(Y,Epoch),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close

[mapS,mapSs,statsS,pxS,pyS,Fr,si,PF,centre]=PlaceField(Restrict(stim,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch),'size',sizeMap,'limitmaze',limMaz,'smoothing',smo,'threshold',thPF);close

[r,p,rc,pc]=PlaceFiledCorrealtionFor2(OcS(:),mapS.count(:));

figure(numfig2)
subplot(1,3,2), imagesc(-OcS), axis xy, colormap(jetinv), ca=caxis; caxis([ca(1)-ca(1)/3 0]), title(['Occupation Map, r=',num2str(floor(r*1000)/1000),', p=',num2str(floor(p*1000)/1000)'])
subplot(1,3,3), imagesc(mapS.count), axis xy, colormap(jet), ca=caxis; caxis([0 ca(2)-ca(2)/3]), title(['Stimulation Density, rc=',num2str(floor(rc*1000)/1000),', pc=',num2str(floor(pc*1000)/1000)])

res=pwd;

if sav
    
    eval(['saveFigure(numfig2,''FigureEfficiencyICSS1'',''',res,''')'])
    eval(['saveFigure(numfig,''FigureEfficiencyICSS2'',''',res,''')'])
end

% 
% figure(gcf)
% Epoch=intervalSet((tpsdeb{n}+a+pas*1)*1E4,(tpsdeb{n}+b+pas*1)*1E4);
% subplot(3,4,3), hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7]), 
% plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'b','linewidth',2)
% plot(Data(Restrict(X,Restrict(stim,Epoch))),Data(Restrict(Y,Restrict(stim,Epoch))),'r.'), xlim([Xmin Xmax]), ylim([Ymin Ymax])
% [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Restrict(X,Epoch),Restrict(Y,Epoch),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
% subplot(3,4,4), imagesc(OcS), axis xy, colormap(jetinv)
% 
% figure(gcf)
% Epoch=intervalSet((tpsdeb{n}+a+pas*2)*1E4,(tpsdeb{n}+b+pas*2)*1E4);
% subplot(3,4,5),hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7]),  
% plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'g','linewidth',2)
% plot(Data(Restrict(X,Restrict(stim,Epoch))),Data(Restrict(Y,Restrict(stim,Epoch))),'r.'), xlim([Xmin Xmax]), ylim([Ymin Ymax])
% [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Restrict(X,Epoch),Restrict(Y,Epoch),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
% subplot(3,4,6), imagesc(OcS), axis xy, colormap(jetinv)
% 
% figure(gcf)
% Epoch=intervalSet((tpsdeb{n}+a+pas*3)*1E4,(tpsdeb{n}+b+pas*3)*1E4);
% subplot(3,4,7),hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7]),  
% plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'k','linewidth',2)
% plot(Data(Restrict(X,Restrict(stim,Epoch))),Data(Restrict(Y,Restrict(stim,Epoch))),'r.'), xlim([Xmin Xmax]), ylim([Ymin Ymax])
% [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Restrict(X,Epoch),Restrict(Y,Epoch),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
% subplot(3,4,8), imagesc(OcS), axis xy, colormap(jetinv)
% 
% figure(gcf)
% Epoch=intervalSet((tpsdeb{n}+a+pas*4)*1E4,(tpsdeb{n}+b+pas*4)*1E4);
% subplot(3,4,9),hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7]),  
% plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'b','linewidth',2)
% plot(Data(Restrict(X,Restrict(stim,Epoch))),Data(Restrict(Y,Restrict(stim,Epoch))),'r.'), xlim([Xmin Xmax]), ylim([Ymin Ymax])
% [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Restrict(X,Epoch),Restrict(Y,Epoch),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
% subplot(3,4,10), imagesc(OcS), axis xy, colormap(jetinv)
% 
% figure(gcf)
% Epoch=intervalSet((tpsdeb{n}+a+pas*5)*1E4,(tpsdeb{n}+b+pas*5)*1E4);
% subplot(3,4,11),hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7]),  
% plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'g','linewidth',2)
% plot(Data(Restrict(X,Restrict(stim,Epoch))),Data(Restrict(Y,Restrict(stim,Epoch))),'r.'), xlim([Xmin Xmax]), ylim([Ymin Ymax])
% [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Restrict(X,Epoch),Restrict(Y,Epoch),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',limMaz);close
% subplot(3,4,12), imagesc(OcS), axis xy, colormap(jetinv)



% 
% figure(gcf)
% 
% Epoch=intervalSet((tpsdeb{4}+a+pas*6)*1E4,(tpsdeb{4}+b+pas*6)*1E4);
% subplot(3,4,7),hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7]),  
% plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'k','linewidth',2)
% 
% Epoch=intervalSet((tpsdeb{4}+a+pas*7)*1E4,(tpsdeb{4}+b+pas*7)*1E4);
% subplot(3,4,8),hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7]),  
% plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'b','linewidth',2)
% 
% Epoch=intervalSet((tpsdeb{4}+a+pas*8)*1E4,(tpsdeb{4}+b+pas*8)*1E4);
% subplot(3,4,9),hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7]),  
% plot(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),'r','linewidth',2)
% 
% 
% [Oc,OcS,OcR,OcRS]=OccupancyMapKB(Restrict(X,Epoch),Restrict(Y,Epoch));