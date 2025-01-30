%FigureBehaviorICSSsleep

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';

sav=0;


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';

cd([filename,'Mouse026/20120109'])

load ParametersAnalyseICSS M o varargin
PlotAnalysisQuantifExploJan2012; %close all

[Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},'y',varargin{3},15,varargin{7},varargin{8},varargin{9},varargin{10},varargin{11},varargin{12},varargin{13},varargin{14},varargin{15},varargin{16},'positions','s','limitNbTrial',4);

figure('color',[1 1 1]), imagesc(mapS.rate), axis xy

figure('color',[1 1 1]), imagesc(OcRS1), axis xy
load('MyColormaps','mycmap')
numfig1=gcf;
set(numfig1,'Colormap',mycmap)

figure('color',[1 1 1]), imagesc(OcRS2), axis xy
load('MyColormaps','mycmap')
numfig2=gcf;
set(numfig2,'Colormap',mycmap)


ca=caxis;
%ca=[0 0.45];
figure(numfig2), caxis(ca)
figure(numfig1), caxis(ca)


VisuQuantifEpochTrialNeuron(M,6,[7],1,30)



if sav
    
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''FigureBehaviorMouse029Sleep', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end
clear
close all
end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';

cd([filename,'Mouse029/20120207'])

load ParametersAnalyseICSS M o varargin
PlotAnalysisQuantifExploJan2012;

%close all
[Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9},varargin{10},varargin{11},varargin{12},varargin{13},'n','positions','s','limitNbTrial',4);
%[Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},'y',varargin{3},15,varargin{7},varargin{8},varargin{9},varargin{10},varargin{11},varargin{12},varargin{13},varargin{14},varargin{15},varargin{16},'positions','s');

figure('color',[1 1 1]), imagesc(mapS.rate), axis xy

figure('color',[1 1 1]), imagesc(OcRS1), axis xy
load('MyColormaps','mycmap')
numfig1=gcf;
set(numfig1,'Colormap',mycmap)

figure('color',[1 1 1]), imagesc(OcRS2), axis xy
load('MyColormaps','mycmap')
numfig2=gcf;
set(numfig2,'Colormap',mycmap)


ca=caxis;
%ca=[0 0.45];
figure(numfig2), caxis(ca)
figure(numfig1), caxis(ca)

 VisuQuantifEpochTrialNeuron(M,12,[1,2],1,20)


if sav
    
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''FigureBehaviorMouse026Sleep', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end
clear
close all
end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';


cd([filename,'Mouse035/20120515'])

load ParametersAnalyseICSS M N o varargin
PlotAnalysisQuantifExploJan2012;

%close all

%[Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},'y',varargin{3},15,varargin{7},varargin{8},varargin{9},varargin{10},varargin{11},varargin{12},varargin{13},varargin{14},varargin{15},varargin{16},'positions','s');
[Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9},15,varargin{11},varargin{12},varargin{13},varargin{14},varargin{15},'n','positions','s');


figure('color',[1 1 1]), imagesc(mapS.rate), axis xy

figure('color',[1 1 1]), imagesc(OcRS1), axis xy
load('MyColormaps','mycmap')
numfig1=gcf;
set(numfig1,'Colormap',mycmap)

figure('color',[1 1 1]), imagesc(OcRS2), axis xy
load('MyColormaps','mycmap')
numfig2=gcf;
set(numfig2,'Colormap',mycmap)


ca=caxis;
%ca=[0 0.45];
figure(numfig2), caxis(ca)
figure(numfig1), caxis(ca)


VisuQuantifEpochTrialNeuron(M,23,[4,13],1,15)


if sav
    
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''FigureBehaviorMouse035Sleep', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end
clear
close all
end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


filename='/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data/';

 cd([filename,'Mouse042/20120801'])
 
 
 
load ParametersAnalyseICSS M N o varargin
PlotAnalysisQuantifExploJan2012;

%close all

%[Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},'y',varargin{3},15,varargin{7},varargin{8},varargin{9},varargin{10},varargin{11},varargin{12},varargin{13},varargin{14},varargin{15},varargin{16},'positions','s');
% [Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9},15,varargin{11},varargin{12},varargin{13},varargin{14},varargin{15},'n','positions','s');


figure('color',[1 1 1]), imagesc(mapS.rate), axis xy

figure('color',[1 1 1]), imagesc(OcRS1), axis xy
load('MyColormaps','mycmap')
numfig1=gcf;
set(numfig1,'Colormap',mycmap)

figure('color',[1 1 1]), imagesc(OcRS2), axis xy
load('MyColormaps','mycmap')
numfig2=gcf;
set(numfig2,'Colormap',mycmap)


ca=caxis;
%ca=[0 0.45];
figure(numfig2), caxis(ca)
figure(numfig1), caxis(ca)



 VisuQuantifEpochTrialNeuron(10:13,12,[4,12],3,15);
 
 
 
if sav
    
    for i=1:20
        try
            eval(['saveFigure(',num2str(i),',''FigureBehaviorMouse042Sleep', num2str(i),''',''/Users/karimbenchenane/Documents/Data/DataEnCours/ManipesICSSok/Data'')'])
        end
    end
 clear
close all
end


