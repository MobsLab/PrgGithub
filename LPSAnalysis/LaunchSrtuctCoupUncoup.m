%% LaunchStructCoupUncoup

%Parietalcoupled
struct='PaCx'
RipS=RpairSPa;
RipD=RpairDPa;
SpiD=SpairDPa;
SpiR=SpairRPa;
DelS=DpairSPa;
DelR=DpairRPa;

FigureScriptCoupUncoup
saveas(f,strcat('ParietalCoupled',num2str(g),'_',struct,'.fig'))
try
    saveFigure(f,strcat('ParietalCoupled',num2str(g),'_',struct),filename)
end
saveas(f,strcat('ParietalCoupled',num2str(g),'_',struct,'.png'))
close(f)


%PrefrontalCoupled

RipS=RpairSPF;
RipD=RpairDPF;
SpiD=SpairDPF;
SpiR=SpairRPF;
DelS=DpairSPF;
DelR=DpairRPF;

FigureScriptCoupUncoup
saveas(f,strcat('PrefrontalCoupled',num2str(g),'_',struct,'.fig'))
try
    saveFigure(f,strcat('PrefrontalCoupled',num2str(g),'_',struct),filename)
end
saveas(f,strcat('PrefrontalCoupled',num2str(g),'_',struct,'.png'))
close(f)

%ParietalUncoupled
struct='PaCx'
RipS=RunpairSPa;
RipD=RunpairDPa;
SpiD=SunpairDPa;
SpiR=SunpairRPa;
DelS=DunpairSPa;
DelR=DunpairRPa;

FigureScriptCoupUncoup
saveas(f,strcat('ParietalUncoupled',num2str(g),'_',struct,'.fig'))
try
    saveFigure(f,strcat('ParietalUncoupled',num2str(g),'_',struct),filename)
end
saveas(f,strcat('ParietalUncoupled',num2str(g),'_',struct,'.png'))
close(f)



%PrefrontalUncoupled

RipS=RunpairSPF;
RipD=RunpairDPF;
SpiD=SunpairDPF;
SpiR=SunpairRPF;
DelS=DunpairSPF;
DelR=DunpairRPF;

FigureScriptCoupUncoup
saveas(f,strcat('PrefrontalUncoupled',num2str(g),'_',struct,'.fig'))
try
    saveFigure(f,strcat('PrefrontalUncoupled',num2str(g),'_',struct),filename)
end
saveas(f,strcat('PrefrontalUncoupled',num2str(g),'_',struct,'.png'))
close(f)
