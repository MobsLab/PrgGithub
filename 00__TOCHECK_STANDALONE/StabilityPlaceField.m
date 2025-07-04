function [MAP,NbSpk,list,Rfr,Pfr,Rfrc,Pfrc,Rbeh,Pbeh,Rbehc,Pbehc,r,p,rc,pc]=StabilityPlaceField(NumNeuron,varargin)


%INPUT
% NumNeuron
% varargin:
%         'smoothing',smo         
%         'figure' plo 
%         'positions' posArt 
%         'immobility' immobb 
%         'save' sav 
%         'speed' Vth
%         'size',sizeMap  

load behavResources
load SpikeData S cellnames

try 
    load ParametersAnalyseICSS S
    S;
end

smo=2.5;
sizeMap=50;
plo=0;
posArt=0;
sav=0;
immobb=0;

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
                  elseif posArt=='s'
                      posArt=2;
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
         
                case 'speed',
                  Vth = varargin{i+1};
                  if ~isa(Vth,'numeric'),
                    error('Incorrect value for property ''speed'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end
                  
                case 'size',
                  sizeMap = varargin{i+1};
                  if ~isa(sizeMap,'numeric'),
                    error('Incorrect value for property ''size'' (type ''help AnalysisQuantifExploJan2012'' for details).');
                  end     
                
                  
              end
 end
 
if NumNeuron>0
 spikes=S{NumNeuron};
nomCell=cellnames{NumNeuron} ;
else
     spikes=stim;
nomCell='stimulation' ;
end
 
 
si=sizeMap;               

ep=TrackingEpoch-SleepEpoch;
ep=ep-RestEpoch;
[X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,ep,posArt);

if posArt>0
dis=tsd(Range(X),sqrt((Data(X)-max(Data(X))/2).^2+(Data(Y)-max(Data(Y))/2).^2));
EpochOk=thresholdIntervals(dis,limMaz(2)/2,'Direction','Below');

X=Restrict(X,EpochOk);
Y=Restrict(Y,EpochOk);
S=Restrict(S,EpochOk);
end
 
 

if immobb==1
    
    try
        Vth;
        
    catch
        Vth=20;
    end
end

 
 
si=sizeMap;

a=1;

for i=1:length(namePos)
    
      Epoch=intervalSet(tpsdeb{i}*1E4,tpsfin{i}*1E4);Epoch=intersect(Epoch,TrackingEpoch);

        try
            Vth;
            Mvt=thresholdIntervals(V,Vth, 'Direction','Above');
            Epoch=intersect(Epoch,Mvt);    
        end

      try
      
            map=PlaceField(Restrict(spikes,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch),'smoothing',smo,'size',si);title([namePos{i},' ',nomCell]); 
            num=gcf;
            if plo==0
                close(num)
                clear num
            end
            NbSpk(a)=length(Data(Restrict(spikes,Epoch)));
            valC{a}=map.count(:);
            valT{a}=map.time(:);
            valFr{a}=map.rate(:);
            MAP{i}=map.rate;
            [r(a),p(a),rc(a),pc(a)]=PlaceFiledCorrealtionFor2(valC{a},valT{a},4);
            list(a)=i;
            a=a+1;
%       catch
%           keyboard
      end
end


try
Epoch=ExploEpoch;
catch
    CreateExploEpoch
    Epoch=ExploEpoch;
end
Epoch=intersect(Epoch,TrackingEpoch);
 try
            Vth;
            Mvt=thresholdIntervals(V,Vth, 'Direction','Above');
            Epoch=intersect(Epoch,Mvt);    
 end

map=PlaceField(Restrict(spikes,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch),'smoothing',smo,'size',si);title(['Total ',' ',nomCell]); 
num=gcf;
if plo==0
    close(num)
    clear num
end
NbSpk(a)=length(Data(Restrict(spikes,Epoch)));
valC{a}=map.count(:);
valT{a}=map.time(:);
valFr{a}=map.rate(:);

MAP{i+1}=map.rate;
[r(a),p(a),rc(a),pc(a)]=PlaceFiledCorrealtionFor2(valC{a},valT{a},4);
 
 

A=[];
B=[];
for i=1:a
    A=[A,valFr{i}];
    B=[B,valT{i}];
end


[Rfr,Pfr,Rfrc,Pfrc]=PlaceFiledCorrealtion(A,4);

[Rbeh,Pbeh,Rbehc,Pbehc]=PlaceFiledCorrealtion(B,4);

figure('color',[1 1 1])
subplot(2,1,1), imagesc(Rfr)
set(gca,'ytick',[1:a-1])
set(gca,'yticklabel',namePos(list))
colorbar
title('Correlation Firing Map')
subplot(2,1,2), imagesc(Rfrc)
set(gca,'ytick',[1:a-1])
set(gca,'yticklabel',namePos(list))
ca=caxis;
caxis([-max(abs(ca)) max(abs(ca))])
colorbar
title('Corrected Correlation Firing Map')

if 1
            figure('color',[1 1 1])
            subplot(2,1,1), imagesc(Pfr)
            set(gca,'ytick',[1:a-1])
            set(gca,'yticklabel',namePos(list))
            caxis([0 0.05])
            colorbar
            title('Significativity Correlation Firing Map')
            subplot(2,1,2), imagesc(Pfrc)
            set(gca,'ytick',[1:a-1])
            set(gca,'yticklabel',namePos(list))
            caxis([0 0.05])
            colorbar
            title('Significativity Corrected Correlation Firing Map')
end

figure('color',[1 1 1])
subplot(2,1,1), bar([r;rc]',1)
title('Correlation Occupancy Map vs Spike density')
ylabel('Correlation')
xlabel('Session')
subplot(2,1,2), bar([p;pc]',1)
ylabel('Singificativity Correlation')
xlabel('Session')


if floor(sqrt(a))==sqrt(a)
    le1=sqrt(a);
    le2=sqrt(a);
else
    le1=floor(sqrt(a))+1;
    le2=floor(sqrt(a)); 
    if le1*le2<a
        le2=le2+1;
    end
end

figure('color',[1 1 1])
for i=1:a-1
   subplot(le1,le2,i), imagesc(MAP{list(i)}), axis xy, colorbar, title(namePos{list(i)}(24:end))
end

subplot(le1,le2,i+1), imagesc(MAP{length(MAP)}), axis xy, colorbar
title('total')    

set(gcf,'position',[371 69 1078 805])


if plo
        try
        ExploEpoch=intersect(ExploEpoch,TrackingEpoch); 
        PlaceField(Restrict(spikes,ExploEpoch),Restrict(X,ExploEpoch),Restrict(Y,ExploEpoch));title(['Total Explo ',nomCell])
        catch
        CreateExploEpoch
        ExploEpoch=intersect(ExploEpoch,TrackingEpoch);
        PlaceField(Restrict(spikes,ExploEpoch),Restrict(X,ExploEpoch),Restrict(Y,ExploEpoch));title([namePos{n},' ',nomCell])
        end



        ExploEpoch=intersect(ExploEpoch,TrackingEpoch); ExploEpoch=intersect(ExploEpoch,Mvt); 
        PlaceField(Restrict(spikes,ExploEpoch),Restrict(X,ExploEpoch),Restrict(Y,ExploEpoch));title(['Total Explo Mvt',nomCell])
end



