function [r,p,rc,pc]=StabilityPFEpoch(S,X,Y,Epoch1,Epoch2,cellnames,varargin)

%
%(S,X,Y,Epoch1,Epoch2,cellnames,posArt)
%

smo=2;



smo=2.5;
sizeMap=50;
plo=0;
posArt=0;
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
 
 
 
 
 
 
 
load behavResources


if immobb==1
    
    try
        Vth;
        
    catch
        Vth=20;
    end
end

si=sizeMap;               

ep=TrackingEpoch-SleepEpoch;
ep=ep-RestEpoch;


[X,Y,S,stim,limMaz,limM,limMaze]=RemoveFalsePosition(X,Y,S,stim,ep,posArt);

if posArt>0
%     try
%         load xyMaz
%         xMaz;
%     [X,Y,S,stim]=FindOptimalPosition(X,Y,S,stim,xMaz,yMaz);
%     end
    
dis=tsd(Range(X),sqrt((Data(X)-max(Data(X))/2).^2+(Data(Y)-max(Data(Y))/2).^2));
EpochOk=thresholdIntervals(dis,limMaz(2)/2,'Direction','Below');

X=Restrict(X,EpochOk);
Y=Restrict(Y,EpochOk);
S=Restrict(S,EpochOk);
end
 
 try
            Vth;
            EpochMvt=thresholdIntervals(V,Vth, 'Direction','Above');
            %EpochMvt=intersect(ep,Mvt);  
            X=Restrict(X,EpochMvt);
            Y=Restrict(Y,EpochMvt);
            S=Restrict(S,EpochMvt);

 end
        
 
 


for a=1:length(S)
    try
map1=PlaceField(Restrict(S{a},Epoch1),Restrict(X,Epoch1),Restrict(Y,Epoch1),'smoothing',smo);close
map2=PlaceField(Restrict(S{a},Epoch2),Restrict(X,Epoch2),Restrict(Y,Epoch2),'smoothing',smo);close

MAP1{a}=map1.rate;
MAP2{a}=map2.rate;
[r(a),p(a),rc(a),pc(a)]=PlaceFiledCorrealtionFor2(MAP1{a}(:),MAP2{a}(:));

figure('color',[1 1 1])
subplot(2,2,1), imagesc(MAP1{a}), axis xy, colorbar, title(cellnames{a}),
subplot(2,2,2), imagesc(MAP2{a}), axis xy, colorbar, title(['r=',num2str(r(a)),', rc=',num2str(rc(a))]),
subplot(2,2,3), imagesc(MAP1{a}), axis xy, ca1=caxis;
subplot(2,2,4), imagesc(MAP2{a}), axis xy, ca2=caxis;
subplot(2,2,3), caxis([0 max(ca1(2),ca2(2))]), colorbar
subplot(2,2,4), caxis([0 max(ca1(2),ca2(2))]),colorbar
    end
end



