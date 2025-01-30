function [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,map2,mapS2,stats2,px2,py2,FR2,sizeFinal2,PrField2,C2,ScField2, Ts]=PlaceFieldPoisson(tsa,X,Y,varargin)

%[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField]
%tend en seconds

ok=0;

fac=1; %factor of diminution vs control firing rate

for i=1:length(varargin)
    try
        if varargin{i}=='limitmaze';
            varargin{i+1}=['[',num2str(varargin{i+1}(1)),' ',num2str(varargin{i+1}(2)),']'];
        end
    end
    
end


try
    eval(['[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField]=PlaceField(tsa,X,Y,''',varargin{1},''',',num2str(varargin{2}),',''',varargin{3},''',',num2str(varargin{4}),',''',varargin{5},''',',num2str(varargin{6}),',''',varargin{7},''',',num2str(varargin{8}),');']);
    ok=4;
catch
    eval(['[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField]=PlaceField(tsa,X,Y,''',varargin{1},''',',num2str(varargin{2}),',''',varargin{3},''',',num2str(varargin{4}),',''',varargin{5},''',',num2str(varargin{6}),');']);
    ok=1;
end

if ok==0
    try
    eval(['[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField]=PlaceField(tsa,X,Y,''',varargin{1},''',',num2str(varargin{2}),',''',varargin{3},''',',num2str(varargin{4}),');']);
    ok=2;
    end
end

if ok==0
    try
    eval(['[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField]=PlaceField(tsa,X,Y,''',varargin{1},''',',num2str(varargin{2}),');']);
    ok=3;
    end
end

if ok==0
try
    eval(['[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField]=PlaceField(tsa,X,Y);']);
    ok=0;
end
end

rg=Range(X,'s');
tend=rg(end)-rg(1);

T=poissonKB((length(Range(tsa))/(rg(end)-rg(1)))/fac,tend)+rg(1);
Ts=tsd(T'*1E4,T'*1E4);


if ok==1
    eval(['[map2,mapS2,stats2,px2,py2,FR2,sizeFinal2,PrField2,C2,ScField2]=PlaceField(Ts,X,Y,''',varargin{1},''',',num2str(varargin{2}),',''',varargin{3},''',',num2str(varargin{4}),',''',varargin{5},''',',num2str(varargin{6}),');']);
title('Poisson process')

elseif ok==4
    eval(['[map2,mapS2,stats2,px2,py2,FR2,sizeFinal2,PrField2,C2,ScField2]=PlaceField(Ts,X,Y,''',varargin{1},''',',num2str(varargin{2}),',''',varargin{3},''',',num2str(varargin{4}),',''',varargin{5},''',',num2str(varargin{6}),',''',varargin{7},''',',num2str(varargin{8}),');']);
title('Poisson process')

elseif ok==2
eval(['[map2,mapS2,stats2,px2,py2,FR2,sizeFinal2,PrField2,C2,ScField2]=PlaceField(Ts,X,Y,''',varargin{1},''',',num2str(varargin{2}),',''',varargin{3},''',',num2str(varargin{4}),');']);
title('Poisson process')
elseif ok==3
    eval(['[map2,mapS2,stats2,px2,py2,FR2,sizeFinal2,PrField2,C2,ScField2]=PlaceField(Ts,X,Y,''',varargin{1},''',',num2str(varargin{2}),');']);
title('Poisson process')
else
    eval(['[map2,mapS2,stats2,px2,py2,FR2,sizeFinal2,PrField2,C2,ScField2]=PlaceField(Ts,X,Y);']);
% title('Poisson process');
end



%ok
