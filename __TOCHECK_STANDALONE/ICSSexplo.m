function [Res,Rest,R1,R2,Mb,Mbt,M,Mt,Vit,zones,OmS,OmtS]=ICSSexplo(namefile,varargin)%deb,fin,vitTh,smo)

%
%
%
%% Help menu
%
% -------------------------------------------------------------------------
% Input:
% -------------------------------------------------------------------------
%   - namefile (in text)
%     **************
%     ****option****
%     **************
%   - 'threshold'   : threshold of speed to avoid artefact when the mouse is staying still in a particular place ine the open field, (default value: 10)
%   - 'artefact'    : threshold to remove artefact (speed to elevated, default value: 40)
%   - 'smoothing'   : smoothing for the density plot of the occupancy map,(default value: 2)
%   - 'zone'        : define the zone of stimulation (must be the zone used in SMART)
%   - 'start'       : time of the beginning of the analysis (in s), (default value: 0)
%   - 'end'         : time of the end of the analysis (in s), (default value: end of the file)
%   - 'hist'        : size of the bin of the occupancy map, (default value: 100)
% 
% -------------------------------------------------------------------------
% Output: 
% -------------------------------------------------------------------------
%   Remark: when t is added at the end of the variable name : Result based on all the values (and not with the speed exclusion criteria)
%
%   - Res         : time in the different zones (in s) 
%                   if the stimulation zone is defined:               
%                           1st column : time ine the stimulation zone
%                           2nd column : time in all the intermediate zone(in black)
%                           3rd column : time in the target zone 1
%                           4th column : time in the target zone 2
%                           etc....
%                   if not
%                           1st column : time in all the intermediate zone(in black)
%                           2nd column : time in the target zone 1
%                           3rd column : time in the target zone 2  
%                           etc...
%   - M           : Matrix coming from SMART (see Below), begining and end defined in the option values
%   - Vit         : speed
%   - OmS         : occupancy map, output size: (hist x hist)
%
% Be carefull!!!   
%       M coming from SMART must be stored in the followig format
%       1st column: x values
%       2nd column: y values
%       3rd column: zone number
%       4th column: time (in s)
%
%
% ***  K. Benchenane, November 2010 ***
%



%--------------------------------------------------------------------------
%% Loading data
%--------------------------------------------------------------------------

try
    cd('C:\Users\Invité\Documents\My Dropbox\MasterMarie\Data\DATA_corrigees')
catch
    cd('D:\My Dropbox\MasterMarie\Data\DATA_corrigees')
end
    
M=dlmread(namefile);

%--------------------------------------------------------------------------
%% Default values
%--------------------------------------------------------------------------

Freq=1/median(diff(M(:,4)));
vitTh=10;
smo=[2 2];
deb=1;
fin=length(M);
sizeHist=100;
vitArt=40;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%% Parse parameter list
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

            for i = 1:2:length(varargin),

              if ~isa(varargin{i},'char'),
                error(['Parameter ' num2str(i) ' is not a property (type ''help ICSSexplo'' for details).']);
              end

              switch(lower(varargin{i})),

%                 case 'typeplot',
%                     typeplot = lower(varargin{i+1});
%                   if ~IsStringInList(typeplot,'brightness','threshold'),
%                     error('Incorrect value for property ''TypePlot'' (type ''help ICSSexplo'' for details).');
%                   end
% 
%                 case 'figure',
%                     fig = lower(varargin{i+1});
%                   if ~IsStringInList(fig,'new','existing'),
%                     error('Incorrect value for property ''figure'' (type ''help ICSSexplo'' for details).');
%                   end


                case 'threshold',
                  vitTh = varargin{i+1};
                  if ~isa(vitTh,'numeric'),
                    error('Incorrect value for property ''threshold'' (type ''help ICSSexplo'' for details).');
                  end

               case 'artefact',
                  vitArt = varargin{i+1};
                  if ~isa(vitArt,'numeric'),
                    error('Incorrect value for property ''artefact'' (type ''help ICSSexplo'' for details).');
                  end
                  
                case 'smoothing',
                  smo = varargin{i+1};
                  if ~isa(smo,'numeric'),
                    error('Incorrect value for property ''smoothing'' (type ''help ICSSexplo'' for details).');
                  end
                  smo=[smo smo];

                case 'start',
                  deb = varargin{i+1};
                  if ~isa(deb,'numeric'),
                    error('Incorrect value for property ''Start'' (type ''help ICSSexplo'' for details).');
                  end
                  deb=floor(deb*Freq);
                  if deb==0
                      deb=1;
                  end

                case 'end',
                  fin = varargin{i+1};
                  if ~isa(fin,'numeric'),
                    error('Incorrect value for property ''end'' (type ''help ICSSexplo'' for details).');
                  end
                  fin=floor(fin*Freq);
                  
                 
                case 'hist',
                  sizeHist = varargin{i+1};
                  if ~isa(sizeHist,'numeric'),
                    error('Incorrect value for property ''hist'' (type ''help ICSSexplo'' for details).');
                  end

                case 'zone',
                  zonestim = varargin{i+1};
                  if ~isa(sizeHist,'numeric'),
                    error('Incorrect value for property ''zone'' (type ''help ICSSexplo'' for details).');
                  end
                  

                otherwise,

                    error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help ICSSexplo'' for details).']);

              end
            end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

M=M(deb:fin,:);
Mt=M;
dt=1/Freq;

%--------------------------------------------------------------------------
%% Calcul speed
%--------------------------------------------------------------------------

for i=1:length(M)-1
    Vx = (M(i,1)-M(i+1,1))/(dt);
    Vy = (M(i,2)-M(i+1,2))/(dt);
    Vitesse(i) = sqrt(Vx^2+Vy^2);
end;

Vit=SmoothDec(Vitesse',1);
% M=M(Vit>vitTh,:);


% Remove artefact
M=M(find(Vit>vitTh&Vit<vitArt),:);
Mt=Mt(find(Vit<vitArt),:);


%--------------------------------------------------------------------------
%% Histogram
%--------------------------------------------------------------------------

[Om, x1, x2] = hist2d(M(:,1),M(:,2), sizeHist, sizeHist);
[Omt, x1, x2] = hist2d(Mt(:,1),Mt(:,2), sizeHist, sizeHist);

OmtS=SmoothDec(Omt,smo);
OmS=SmoothDec(Om,smo);
Qk=percentile(OmS(:),99);
Qkt=percentile(OmtS(:),99);

%--------------------------------------------------------------------------
%% Define zones
%--------------------------------------------------------------------------

zones=unique(M(:,3));
maxzones=length(zones);
zones=[zones,zeros(maxzones,1)];

for i=1:maxzones
    le(i)=length(find(M(:,3)==zones(i,1)));
end
[BE,id]=max(le);
zones(id,2)=1;

zonescolor{zones(id,1)}=[0 0 0];

colordefault{1}=[0 1 0];
colordefault{2}=[0 0 1];
colordefault{3}=[0 1 1];
colordefault{4}=[1 1 0];


try
    zonescolor{zonestim}=[1 0 0];
    zones(zones(:,1)==zonestim,2)=1;
    colordefault{2}=[0 1 0];
    colordefault{1}=[0 0 1];
end

restzones=zones(zones(:,2)==0,1)';


a=1;
for j=restzones
    zonescolor{j}=colordefault{a};
    a=a+1;
end


%--------------------------------------------------------------------------
%% Plot figure
%--------------------------------------------------------------------------

figure('Color',[1 1 1])

subplot(2,2,1),hold on
    plot(Mt(:,2),Mt(:,1),'k')
for z=zones(:,1)'
    plot(Mt(Mt(:,3)==z,2),Mt(Mt(:,3)==z,1),'Color',zonescolor{z})
end
    title(namefile)
    
subplot(2,2,3)
    imagesc(OmtS), axis xy
    caxis([0 Qkt])
    
subplot(2,2,2),hold on
    plot(M(:,2),M(:,1),'k')
for z=zones(:,1)'
    plot(M(M(:,3)==z,2),M(M(:,3)==z,1),'Color',zonescolor{z})
end

subplot(2,2,4)
    imagesc(OmS), axis xy
    caxis([0 Qk])
    
    
    
%--------------------------------------------------------------------------
%% Clacul occupation
%--------------------------------------------------------------------------    

c=1;
try
    Res(1)=length(find(M(:,3)==zonestim));
    c=2;
end

Res(c)=length(find(M(:,3)==zones(id)));
c=c+1;

for b=restzones
    Res(c)=length(find(M(:,3)==b));
    c=c+1;
end


c=1;
try
    Rest(1)=length(find(Mt(:,3)==zonestim));
    c=2;
end

Rest(c)=length(find(Mt(:,3)==zones(id)));
c=c+1;

for b=restzones
    Rest(c)=length(find(Mt(:,3)==b));  
    c=c+1;
end

Res=floor(Res/Freq*10)/10;
Rest=floor(Rest/Freq*10)/10;

% Zones=zones(:,1);

try
    zonestim;

    labels{1}='stim vs. ctrls';
    labels{2}='ctrl 1 vs. ctrl 2';
    labels{3}='stim';
    labels{4}='ctrl 1';
    labels{5}='ctrl 2';


    if length(restzones)>1
    
    R1=[2*Rest(1)/(Rest(3)+Rest(4)) Rest(3)/Rest(4) Rest(1)/(Rest(1)+Rest(2)+Rest(3)+Rest(4)) Rest(3)/(Rest(1)+Rest(2)+Rest(3)+Rest(4)) Rest(4)/(Rest(1)+Rest(2)+Rest(3)+Rest(4))];    
    R2=[2*Res(1)/(Res(3)+Res(4)) Res(3)/Res(4) Res(1)/(Res(1)+Res(2)+Res(3)+Res(4)) Res(3)/(Res(1)+Res(2)+Res(3)+Res(4)) Res(4)/(Res(1)+Res(2)+Res(3)+Res(4))];

    figure('Color',[1 1 1])
    
    subplot(4,2,1), 
    bar(log10(R1(1:2)),'k'),
    ylabel('stim vs ctrl zone (log)'), 
    title('without speed exclusion')
    set(gca,'xtick',[1:2])
    set(gca,'xticklabel',labels(1:2))
    
    subplot(4,2,2),
    bar(log10(R2(1:2)),'k'),
    ylabel('stim vs ctrl zone (log)'),
    title('with speed exclusion')
    set(gca,'xtick',[1:2])
    set(gca,'xticklabel',labels(1:2))
    
    subplot(4,2,3),
    bar(100*R1(3:5),'k'),
    ylabel('Percentage of total time')
    set(gca,'xtick',[1:3])
    set(gca,'xticklabel',labels(3:5))
    
    subplot(4,2,4),
    bar(100*R2(3:5),'k'),
    ylabel('Percentage of total time')    
    set(gca,'xtick',[1:3])
    set(gca,'xticklabel',labels(3:5))
    
%--------------------------------------------------------------------------

    Mb=M(:,3:4);
    Mb=[Mb,zeros(length(Mb),3)];
    Mb(Mb(:,1)==zonestim,3)=1;
    Mb(Mb(:,1)==restzones(1),4)=1;
    Mb(Mb(:,1)==restzones(2),5)=1;


    Mbt=Mt(:,3:4);
    Mbt=[Mbt,zeros(length(Mbt),3)];
    Mbt(Mbt(:,1)==zonestim,3)=1;
    Mbt(Mbt(:,1)==restzones(1),4)=1;
    Mbt(Mbt(:,1)==restzones(2),5)=1;

%--------------------------------------------------------------------------

%     figure('Color',[1 1 1]), 

    subplot(4,2,5), hold on
    plot(Mt(:,4),cumsum(Mbt(:,3)),'r','linewidth',2)
    plot(Mt(:,4),cumsum(Mbt(:,4)),'b','linewidth',2)
    plot(Mt(:,4),cumsum(Mbt(:,5)),'g','linewidth',2)

    subplot(4,2,6), hold on
    plot(M(:,4),cumsum(Mb(:,3)),'r','linewidth',2)
    plot(M(:,4),cumsum(Mb(:,4)),'b','linewidth',2)
    plot(M(:,4),cumsum(Mb(:,5)),'g','linewidth',2)

    subplot(4,2,7), hold on
    line([0 Mt(end,4)],[0 0],'Color',[0.7 0.7 0.7])
    plot(Mt(:,4),log10((0.1+cumsum(Mbt(:,3)))./(0.1+0.5*cumsum(Mbt(:,4)+Mbt(:,5)))),'r','linewidth',2)
    plot(Mt(:,4),log10((0.1+cumsum(Mbt(:,4)))./(0.1+cumsum(Mbt(:,5)))),'k','linewidth',2), ylim([-1 1])
    
    subplot(4,2,8), hold on
    line([0 M(end,4)],[0 0],'Color',[0.7 0.7 0.7])
    plot(M(:,4),log10((0.1+cumsum(Mb(:,3)))./(0.1+0.5*cumsum(Mb(:,4)+Mb(:,5)))),'r','linewidth',2)
    plot(M(:,4),log10((0.1+cumsum(Mb(:,4)))./(0.1+cumsum(Mb(:,5)))),'k','linewidth',2), ylim([-1 1])


    else
    
    R1=[Rest(1)/Rest(3) Rest(3)/Rest(2) Rest(1)/(Rest(1)+Rest(2)+Rest(3)) Rest(3)/(Rest(1)+Rest(2)+Rest(3))];
    R2=[Res(1)/Res(3) Res(3)/Res(2) Res(1)/(Res(1)+Res(2)+Res(3)) Res(3)/(Res(1)+Res(2)+Res(3))];
    
    

    Mb=M(:,3:4);
    Mb=[Mb,zeros(length(Mb),2)];
    Mb(Mb(:,1)==zonestim,3)=1;
    Mb(Mb(:,1)==restzones(1),4)=1;
    
    Mbt=Mt(:,3:4);
    Mbt=[Mbt,zeros(length(Mbt),3)];
    Mbt(Mbt(:,1)==zonestim,3)=1;
    Mbt(Mbt(:,1)==restzones(1),4)=1;
    
    
    
    figure('Color',[1 1 1])
    subplot(4,2,1), bar(log10(R1(1)),'k'), ylabel('Percentage stim vs. ctrl zone (log)'), title('without speed excllusion')
    subplot(4,2,2), bar(log10(R2(1)),'k'), ylabel('Percentage stim vs. ctrl zone (log)'), title('with speed excllusion')
    subplot(4,2,3), bar(100*R1(3:4),'k'), ylabel('Percentage of total time')
    subplot(4,2,4), bar(100*R2(3:4),'k'), ylabel('Percentage of total time')    
    
    subplot(4,2,5), hold on
    plot(Mt(:,4),cumsum(Mbt(:,3)),'r','linewidth',2)
    plot(Mt(:,4),cumsum(Mbt(:,4)),'b','linewidth',2)

    subplot(4,2,6), hold on
    plot(M(:,4),cumsum(Mb(:,3)),'r','linewidth',2)
    plot(M(:,4),cumsum(Mb(:,4)),'b','linewidth',2)

    subplot(4,2,7), hold on
    line([0 Mt(end,4)],[0 0],'Color',[0.7 0.7 0.7])
    plot(Mt(:,4),log10((0.1+cumsum(Mbt(:,3)))./(0.1+cumsum(Mbt(:,4)))),'k','linewidth',2), ylim([-1 1])
    
    subplot(4,2,8), hold on
    line([0 M(end,4)],[0 0],'Color',[0.7 0.7 0.7])
    plot(M(:,4),log10((0.1+cumsum(Mb(:,3)))./(0.1+cumsum(Mb(:,4)))),'k','linewidth',2), ylim([-1 1])
    
    
    
    end
   
catch
    
    R1=[];
    R2=[];
    Mb=[];
    Mbt=[];
    
end






