%PlotAnalysisQuantifExploJan2012

limT=4;

load ParametersAnalyseICSS

try 
    oS;
    o=oS;
    
end

le=length(varargin);
for i=1:le
    try
if varargin{i}(1)=='s'&varargin{i}(2)=='a'&varargin{i}(3)=='v'
    varargin{i+1}='n'; 
end
end
end

a=1;
while length(varargin)<20

varargin{le+a}=' ';
    a=a+1;
end
    
    try
       ff [Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9},varargin{10},varargin{11},varargin{12},varargin{13},varargin{14},varargin{15},varargin{16},varargin{17},varargin{18},varargin{19},varargin{20},'positions','s','limitnbtrial',4,'save','n');
    catch
        [Res,mapS,pxS,pyS,PF,X,Y,OcRS1,OcRS2]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8},varargin{9},varargin{10},varargin{11},varargin{12},varargin{13},varargin{14},varargin{15},varargin{16},varargin{17},varargin{18},varargin{19},varargin{20},'limitnbtrial',limT,'save','n');
        
    end
set(6,'Position',[98 574 1522 283])

