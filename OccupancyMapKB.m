function [Oc,OcS,OcR,OcRS]=OccupancyMapKB(X,Y,varargin)


for i = 1:2:length(varargin),

   %           if ~isa(varargin{i},'char'),
    %            error(['Parameter ' num2str(i) ' is not a property (type ''help ICSSexplo'' for details).']);
     %         end

              switch(lower(varargin{i})),

                case 'smoothing',
                  smo = varargin{i+1};
                  if ~isa(smo,'numeric'),
                    error('Incorrect value for property ''smoothing'' (type ''help ICSSexplo'' for details).');
                  end
                  
                case 'scale',
                  logg = varargin{i+1};
                  if ~isa(logg,'numeric'),
                    error('Incorrect value for property ''figure'' (type ''help ICSSexplo'' for details).');
                  end
                case 'epoch',
                  GoodEpoch = varargin{i+1};
                 
               case 'list',
                  list = varargin{i+1};
               
                 case 'size',
                  sizeMap = varargin{i+1};
                  if ~isa(sizeMap,'numeric'),
                    error('Incorrect value for property ''figure'' (type ''help ICSSexplo'' for details).');
                  end 
                  
                  case 'axis',
                  ca = varargin{i+1};
                  
                  case 'limitmaze',
                  lim = varargin{i+1};
                  
                  case 'video',
                  freqVideo = varargin{i+1};
                  if ~isa(freqVideo,'numeric'),
                    error('Incorrect value for property ''figure'' (type ''help PlaceField'' for details).');
                  end
                  
                  case 'largematrix',
                  LMatrix = varargin{i+1};  
                  
              end
end
 

LMatrix=1; 
oldversion=0;


try
    sizeMap;
    if size(sizeMap,1)==2
    sizeMap1=sizeMap(1);
    sizeMap2=sizeMap(2);
    else
    sizeMap1=sizeMap;
    sizeMap2=sizeMap;
        
    end
    
catch
    sizeMap1=50;
    sizeMap2=50;
    sizeMap=[sizeMap1,sizeMap2];
end
try
    smo;
catch
    smo=2;
end

try
    logg;
catch
    logg=0;
end

try
    GoodEpoch;
catch
    rg=Range(X);
    GoodEpoch=intervalSet(rg(1),rg(end));
end

try
    list;
catch
    list=length(Start(GoodEpoch)); 
end


try
    list;
catch
    list=[1:length(Start(GoodEpoch))];
end




try
    
freqVideo;
catch
    freqVideo=30;
end





figure('Color',[1 1 1]), 
%subplot(3,1,1), plot(Data(X), Data(Y))
subplot(2,1,1), hold on

if length(list)>1
        for i=list

            subepoch=subset(GoodEpoch,i);
            plot(Data(Restrict(X,subepoch)),Data(Restrict(Y,subepoch)),'b')  
            Xsub=Data(Restrict(X,subepoch));
            Ysub=Data(Restrict(Y,subepoch));    
            plot(Xsub(1),Ysub(1),'bo','markerfacecolor','b','linewidth',5)
%             ylim([0 20])
%             xlim([0 20])
        end
        %plot(Data(Xr),Data(Yr),'k','linewidth',2)  


else
    
        plot(Data(Restrict(X,GoodEpoch)),Data(Restrict(Y,GoodEpoch)),'b')  
        Xsub=Data(Restrict(X,GoodEpoch));
        Ysub=Data(Restrict(Y,GoodEpoch));    
        plot(Xsub(1),Ysub(1),'bo','markerfacecolor','b','linewidth',5)
%         ylim([0 300])
%         xlim([0 300]) 
    
end



try
lim(1:2)=sort(lim(1:2));
lim(3:4)=sort(lim(3:4));
end



if oldversion

        try
           try
            [occH, x1, x2] = hist2d([lim(1) ;Data(X) ;lim(2)], [lim(3) ;Data(Y) ;lim(4)], sizeMap1, sizeMap2);
           catch
            [occH, x1, x2] = hist2d([lim(1) ;Data(X) ;lim(2)], [lim(1) ;Data(Y) ;lim(2)], sizeMap1, sizeMap2);
           end
           occH(1,1)=0;
            occH(end,end)=0;
        catch
            [occH, x1, x2] = hist2d(Data(X), Data(Y), sizeMap1, sizeMap2);
        end

else


        try
           try
               pas12=(lim(2)-lim(1))/(sizeMap-2);
               pas34=(lim(4)-lim(3))/(sizeMap-2);
               
            [occH, x1, x2] = hist2d(Data(X), Data(Y), lim(1)-pas12/2:pas12:lim(2)+pas12/2, lim(3)-pas34/2:pas34:lim(4)+pas34/2);
           catch
              pas12=(lim(2)-lim(1))/(sizeMap-2);
            [occH, x1, x2] = hist2d(Data(X), Data(Y), lim(1)-pas/2:pas:lim(2)+pas/2, lim(1)-pas12/2:pas12:lim(2)+pas12/2);
           end

        catch
            [occH, x1, x2] = hist2d(Data(X), Data(Y), sizeMap, sizeMap);
        end



end





   sigmaS = 10;

% for x=1:smo;
% for y=1:smo; 
%     gw(x,y) = exp(-((x-5)*(x-5) + (y-5)*(y-5))/(2*sigmaS));
% end
% end
% 
% occHS = conv2(occH,gw,'same')/sum(sum(gw));

%occHS=SmoothDec(occH,[smo,smo]);



%--------------------------------------------------------------------------

% occHTemp=occH;
%     
%     largerMatrix = zeros(sizeMap+floor(sizeMap/4),sizeMap+floor(sizeMap/4));
%     largerMatrix(1+floor(sizeMap/8):sizeMap+floor(sizeMap/8),1+floor(sizeMap/8):sizeMap+floor(sizeMap/8)) = occH';
%     occH=largerMatrix/freqVideo;
%  
%  
%  largerMatrix = zeros(sizeMap+floor(sizeMap/4),sizeMap+floor(sizeMap/4));
% largerMatrix(1+floor(sizeMap/8):sizeMap+floor(sizeMap/8),1+floor(sizeMap/8):sizeMap+floor(sizeMap/8)) = occHTemp';
% largerMatrix=SmoothDec(largerMatrix,[smo,smo]);
%     occHS=largerMatrix/freqVideo;
% 

    
if LMatrix

        largerMatrix = zeros(sizeMap+floor(sizeMap/4),sizeMap+floor(sizeMap/4));
        largerMatrix(1+floor(sizeMap/8):sizeMap+floor(sizeMap/8),1+floor(sizeMap/8):sizeMap+floor(sizeMap/8)) = occH';
        
        occH=largerMatrix;
        
        largerMatrix=SmoothDec(largerMatrix,[smo,smo]);  

        % largerMatrix = zeros(250,250);
        % largerMatrix(26:225,26:225) = occH';
        occHS=largerMatrix/freqVideo;
else
    
    occH=occH';
    occHS=SmoothDec(occH/freqVideo,[smo,smo]);   
    
    
end

      
 %--------------------------------------------------------------------------     
    
    
if logg==1
subplot(2,1,2), imagesc(x1,x2,log(OccHS)), axis xy
else
subplot(2,1,2), imagesc(x1,x2,occH), axis xy
end
% ylim([0 300])
% xlim([0 300])
try
caxis([ca])
end

if logg==1
OcS=log(occHS);
else
OcS=occHS;
end

Oc=occH;
OcS=occHS;
OcR=Oc/sum(sum(Oc))*100;
OcRS=OcS/sum(sum(OcS))*100;

