%genLFPScanFrequency

% Load Information
res=pwd;
load([res,'/LFPData/InfoLFP']);
load ScanFrequency

tempREF=Data(Fq15kHz2(9))';
tempREF(tempREF>2000)=nan;
tempREF(tempREF<-2000)=nan;
    
for num=1:length(InfoLFP.structure);
    tempC=Data(Fq15kHz2(i))';
    tempC(tempC>2000)=nan;
    tempC(tempC<-2000)=nan;
    figure, imagesc(tempC-tempREF)
    title([' 10 kHz intensity gradient',InfoLFP.structure(i)])
end


for freq=[5:5:30]

    figure, hold on
    
    eval(['tempC=Data(Fq',num2str(freq),'kHz4)'';'])
    tempC(42,:)=[];
    
    tempC(tempC>2500)=nan;
    tempC(tempC<-2500)=nan;
    
    eval(['temp=Data(Fq',num2str(freq),'kHz4(5))'';'])
    temp(42,:)=[];
    temp(temp>2500)=nan;
    temp(temp<-2500)=nan;
    plot(nanmean(temp)-nanmean(tempC),'k')
    
    eval(['temp=Data(Fq',num2str(freq),'kHz4(2))'';'])
    temp(42,:)=[];
    temp(temp>2500)=nan;
    temp(temp<-2500)=nan;   
    plot(nanmean(temp)-nanmean(tempC),'b')

    eval(['temp=Data(Fq',num2str(freq),'kHz4(30))'';'])
    temp(42,:)=[];
    temp(temp>2500)=nan;
    temp(temp<-2500)=nan;    
    plot(nanmean(temp)-nanmean(tempC),'m')

    eval(['temp=Data(Fq',num2str(freq),'kHz4(24))'';'])
    temp(42,:)=[];
    temp(temp>2500)=nan;
    temp(temp<-2500)=nan;   
    plot(nanmean(temp)-nanmean(tempC),'r')

    eval(['temp=Data(Fq',num2str(freq),'kHz4(20))'';'])
    temp(42,:)=[];
    temp(temp>2500)=nan;
    temp(temp<-2500)=nan;   
    plot(nanmean(temp)-nanmean(tempC),'g')

    title(num2str(freq))

end


smo=1;
lim=5500;
pval=0.05;
for i=1:length(InfoLFP.structure);
    a=i-1;
    %--------------------------------------------------------------
    %<><><><><><><><><><><><><><> 5kHz <><><><><><><><><><><><><><>
    %--------------------------------------------------------------
    temp5kHz1=Data(Fq5kHz1(i))';
    Ms5kHz1=[temp5kHz1(:,1:size(temp5kHz1,2)-1)];
    Ms5kHz1(Ms5kHz1>lim)=nan;
    Ms5kHz1(Ms5kHz1<-lim)=nan;
    
    temp5kHz2=Data(Fq5kHz2(i))';
    Ms5kHz2=[temp5kHz2(:,1:size(temp5kHz2,2)-1)];
    Ms5kHz2(Ms5kHz2>lim)=nan;
    Ms5kHz2(Ms5kHz2<-lim)=nan;
    
    temp5kHz3=Data(Fq5kHz3(i))';
    Ms5kHz3=[temp5kHz3(:,1:size(temp5kHz3,2)-1)];
    Ms5kHz3(Ms5kHz3>lim)=nan;
    Ms5kHz3(Ms5kHz3<-lim)=nan;
    
    temp5kHz4=Data(Fq5kHz4(i))';
    Ms5kHz4=[temp5kHz4(:,1:size(temp5kHz4,2)-1)];
    Ms5kHz4(Ms5kHz4>lim)=nan;
    Ms5kHz4(Ms5kHz4<-lim)=nan;
    
    [M5kHz1,S1,E5kHz1]=MeanDifNan(RemoveNan(Ms5kHz1));
    [M5kHz2,S2,E5kHz2]=MeanDifNan(RemoveNan(Ms5kHz2));
    [M5kHz3,S3,E5kHz3]=MeanDifNan(RemoveNan(Ms5kHz3));
    [M5kHz4,S4,E5kHz4]=MeanDifNan(RemoveNan(Ms5kHz4));
    
    [h5kHz1,p5kHz1]=ttest2(RemoveNan(Ms5kHz1),RemoveNan(Ms5kHz4));
    
    rg5kHz=Range(Fq5kHz1(i),'ms');
    pr5kHz=rescale(p5kHz1,-1000, -1200);
    tps5kHz=Range(Fq5kHz1(i),'ms');
    
    figure, subplot(3,2,1)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1),smo),'k','linewidth',2),
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1+E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1-E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2),smo),'r','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2+E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2-E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3),smo),'g','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3+E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3-E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4),smo),'b','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4+E5kHz4),smo),'b')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4-E5kHz4),smo),'b')
    hold on, plot(rg5kHz(p5kHz1<pval),pr5kHz(p5kHz1<pval),'kx')
    title([' 5 kHz intensity gradient',InfoLFP.structure(i)])
    hold on, axis([-50 150 -200 200])
    
    %---------------------------------------------------------------
    %<><><><><><><><><><><><><><> 10kHz <><><><><><><><><><><><><><>
    %---------------------------------------------------------------
    temp10kHz1=Data(Fq10kHz1(i))';
    Ms10kHz1=[temp10kHz1(:,1:size(temp10kHz1,2)-1)];
    Ms10kHz1(Ms10kHz1>lim)=nan;
    Ms10kHz1(Ms10kHz1<-lim)=nan;
    
    temp10kHz2=Data(Fq10kHz2(i))';
    Ms10kHz2=[temp10kHz2(:,1:size(temp10kHz2,2)-1)];
    Ms10kHz2(Ms10kHz2>lim)=nan;
    Ms10kHz2(Ms10kHz2<-lim)=nan;
    
    temp10kHz3=Data(Fq10kHz3(i))';
    Ms10kHz3=[temp10kHz3(:,1:size(temp10kHz3,2)-1)];
    Ms10kHz3(Ms10kHz3>lim)=nan;
    Ms10kHz3(Ms10kHz3<-lim)=nan;
    
    temp10kHz4=Data(Fq10kHz4(i))';
    Ms10kHz4=[temp10kHz4(:,1:size(temp10kHz4,2)-1)];
    Ms10kHz4(Ms10kHz4>lim)=nan;
    Ms10kHz4(Ms10kHz4<-lim)=nan;
    
    [M10kHz1,S1,E10kHz1]=MeanDifNan(RemoveNan(Ms10kHz1));
    [M10kHz2,S2,E10kHz2]=MeanDifNan(RemoveNan(Ms10kHz2));
    [M10kHz3,S3,E10kHz3]=MeanDifNan(RemoveNan(Ms10kHz3));
    [M10kHz4,S4,E10kHz4]=MeanDifNan(RemoveNan(Ms10kHz4));
    
    [h10kHz1,p10kHz1]=ttest2(RemoveNan(Ms10kHz1),RemoveNan(Ms10kHz4));
    
    rg10kHz=Range(Fq10kHz1(i),'ms');
    pr10kHz=rescale(p10kHz1,-1000, -1200);
    tps10kHz=Range(Fq10kHz1(i),'ms');
    
    hold on, subplot(3,2,2)
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz1),smo),'k','linewidth',2),
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz1+E10kHz1),smo),'k')
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz1-E10kHz1),smo),'k')
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz2),smo),'r','linewidth',2)
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz2+E10kHz2),smo),'r')
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz2-E10kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3),smo),'g','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3+E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3-E5kHz3),smo),'g')
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz4),smo),'b','linewidth',2)
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz4+E10kHz4),smo),'b')
    hold on, plot(tps10kHz(1:end-1),SmoothDec((M10kHz4-E10kHz4),smo),'b')
    hold on, plot(rg10kHz(p10kHz1<pval),pr10kHz(p10kHz1<pval),'kx')
    title([' 10 kHz intensity gradient',InfoLFP.structure(i)])
    hold on, axis([-50 150 -200 200])
    
    
    %--------------------------------------------------------------
    %<><><><><><><><><><><><><><> 15kHz <><><><><><><><><><><><><><>
    %--------------------------------------------------------------
    temp5kHz1=Data(Fq15kHz1(i))';
    Ms5kHz1=[temp5kHz1(:,1:size(temp5kHz1,2)-1)];
    Ms5kHz1(Ms5kHz1>lim)=nan;
    Ms5kHz1(Ms5kHz1<-lim)=nan;
    
    temp5kHz2=Data(Fq15kHz2(i))';
    Ms5kHz2=[temp5kHz2(:,1:size(temp5kHz2,2)-1)];
    Ms5kHz2(Ms5kHz2>lim)=nan;
    Ms5kHz2(Ms5kHz2<-lim)=nan;
    
    temp5kHz3=Data(Fq15kHz3(i))';
    Ms5kHz3=[temp5kHz3(:,1:size(temp5kHz3,2)-1)];
    Ms5kHz3(Ms5kHz3>lim)=nan;
    Ms5kHz3(Ms5kHz3<-lim)=nan;
    
    temp5kHz4=Data(Fq15kHz4(i))';
    Ms5kHz4=[temp5kHz4(:,1:size(temp5kHz4,2)-1)];
    Ms5kHz4(Ms5kHz4>lim)=nan;
    Ms5kHz4(Ms5kHz4<-lim)=nan;
    
    [M5kHz1,S1,E5kHz1]=MeanDifNan(RemoveNan(Ms5kHz1));
    [M5kHz2,S2,E5kHz2]=MeanDifNan(RemoveNan(Ms5kHz2));
    [M5kHz3,S3,E5kHz3]=MeanDifNan(RemoveNan(Ms5kHz3));
    [M5kHz4,S4,E5kHz4]=MeanDifNan(RemoveNan(Ms5kHz4));
    
    [h5kHz1,p5kHz1]=ttest2(RemoveNan(Ms5kHz1),RemoveNan(Ms5kHz4));
    
    rg5kHz=Range(Fq15kHz1(i),'ms');
    pr5kHz=rescale(p5kHz1,-1000, -1200);
    tps5kHz=Range(Fq15kHz1(i),'ms');
    
    hold on, subplot(3,2,3)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1),smo),'k','linewidth',2),
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1+E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1-E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2),smo),'r','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2+E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2-E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3),smo),'g','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3+E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3-E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4),smo),'b','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4+E5kHz4),smo),'b')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4-E5kHz4),smo),'b')
    hold on, plot(rg5kHz(p5kHz1<pval),pr5kHz(p5kHz1<pval),'kx')
    title([' 15 kHz intensity gradient',InfoLFP.structure(i)])
    hold on, axis([-50 150 -200 200])
    
    %--------------------------------------------------------------
    %<><><><><><><><><><><><><><> 20kHz <><><><><><><><><><><><><><>
    %--------------------------------------------------------------
    temp5kHz1=Data(Fq20kHz1(i))';
    Ms5kHz1=[temp5kHz1(:,1:size(temp5kHz1,2)-1)];
    Ms5kHz1(Ms5kHz1>lim)=nan;
    Ms5kHz1(Ms5kHz1<-lim)=nan;
    
    temp5kHz2=Data(Fq20kHz2(i))';
    Ms5kHz2=[temp5kHz2(:,1:size(temp5kHz2,2)-1)];
    Ms5kHz2(Ms5kHz2>lim)=nan;
    Ms5kHz2(Ms5kHz2<-lim)=nan;
    
    temp5kHz3=Data(Fq20kHz3(i))';
    Ms5kHz3=[temp5kHz3(:,1:size(temp5kHz3,2)-1)];
    Ms5kHz3(Ms5kHz3>lim)=nan;
    Ms5kHz3(Ms5kHz3<-lim)=nan;
    
    temp5kHz4=Data(Fq20kHz4(i))';
    Ms5kHz4=[temp5kHz4(:,1:size(temp5kHz4,2)-1)];
    Ms5kHz4(Ms5kHz4>lim)=nan;
    Ms5kHz4(Ms5kHz4<-lim)=nan;
    
    [M5kHz1,S1,E5kHz1]=MeanDifNan(RemoveNan(Ms5kHz1));
    [M5kHz2,S2,E5kHz2]=MeanDifNan(RemoveNan(Ms5kHz2));
    [M5kHz3,S3,E5kHz3]=MeanDifNan(RemoveNan(Ms5kHz3));
    [M5kHz4,S4,E5kHz4]=MeanDifNan(RemoveNan(Ms5kHz4));
    
    [h5kHz1,p5kHz1]=ttest2(RemoveNan(Ms5kHz1),RemoveNan(Ms5kHz4));
    
    rg5kHz=Range(Fq20kHz1(i),'ms');
    pr5kHz=rescale(p5kHz1,-1000, -1200);
    tps5kHz=Range(Fq20kHz1(i),'ms');
    
    hold on, subplot(3,2,4)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1),smo),'k','linewidth',2),
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1+E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1-E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2),smo),'r','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2+E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2-E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3),smo),'g','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3+E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3-E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4),smo),'b','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4+E5kHz4),smo),'b')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4-E5kHz4),smo),'b')
    hold on, plot(rg5kHz(p5kHz1<pval),pr5kHz(p5kHz1<pval),'kx')
    title([' 20 kHz intensity gradient',InfoLFP.structure(i)])
    hold on, axis([-50 150 -200 200])
    
    %--------------------------------------------------------------
    %<><><><><><><><><><><><><><> 25kHz <><><><><><><><><><><><><><>
    %--------------------------------------------------------------
    temp5kHz1=Data(Fq25kHz1(i))';
    Ms5kHz1=[temp5kHz1(:,1:size(temp5kHz1,2)-1)];
    Ms5kHz1(Ms5kHz1>lim)=nan;
    Ms5kHz1(Ms5kHz1<-lim)=nan;
    
    temp5kHz2=Data(Fq25kHz2(i))';
    Ms5kHz2=[temp5kHz2(:,1:size(temp5kHz2,2)-1)];
    Ms5kHz2(Ms5kHz2>lim)=nan;
    Ms5kHz2(Ms5kHz2<-lim)=nan;
    
    temp5kHz3=Data(Fq25kHz3(i))';
    Ms5kHz3=[temp5kHz3(:,1:size(temp5kHz3,2)-1)];
    Ms5kHz3(Ms5kHz3>lim)=nan;
    Ms5kHz3(Ms5kHz3<-lim)=nan;
    
    temp5kHz4=Data(Fq25kHz4(i))';
    Ms5kHz4=[temp5kHz4(:,1:size(temp5kHz4,2)-1)];
    Ms5kHz4(Ms5kHz4>lim)=nan;
    Ms5kHz4(Ms5kHz4<-lim)=nan;
    
    [M5kHz1,S1,E5kHz1]=MeanDifNan(RemoveNan(Ms5kHz1));
    [M5kHz2,S2,E5kHz2]=MeanDifNan(RemoveNan(Ms5kHz2));
    [M5kHz3,S3,E5kHz3]=MeanDifNan(RemoveNan(Ms5kHz3));
    [M5kHz4,S4,E5kHz4]=MeanDifNan(RemoveNan(Ms5kHz4));
    
    [h5kHz1,p5kHz1]=ttest2(RemoveNan(Ms5kHz1),RemoveNan(Ms5kHz4));
    
    rg5kHz=Range(Fq25kHz1(i),'ms');
    pr5kHz=rescale(p5kHz1,-1000, -1200);
    tps5kHz=Range(Fq25kHz1(i),'ms');
    
    hold on, subplot(3,2,5)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1),smo),'k','linewidth',2),
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1+E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1-E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2),smo),'r','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2+E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2-E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3),smo),'g','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3+E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3-E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4),smo),'b','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4+E5kHz4),smo),'b')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4-E5kHz4),smo),'b')
    hold on, plot(rg5kHz(p5kHz1<pval),pr5kHz(p5kHz1<pval),'kx')
    title([' 25 kHz intensity gradient',InfoLFP.structure(i)])
    hold on, axis([-50 150 -200 200])
    
    %--------------------------------------------------------------
    %<><><><><><><><><><><><><><> 30kHz <><><><><><><><><><><><><><>
    %--------------------------------------------------------------
    temp5kHz1=Data(Fq30kHz1(i))';
    Ms5kHz1=[temp5kHz1(:,1:size(temp5kHz1,2)-1)];
    Ms5kHz1(Ms5kHz1>lim)=nan;
    Ms5kHz1(Ms5kHz1<-lim)=nan;
    
    temp5kHz2=Data(Fq30kHz2(i))';
    Ms5kHz2=[temp5kHz2(:,1:size(temp5kHz2,2)-1)];
    Ms5kHz2(Ms5kHz2>lim)=nan;
    Ms5kHz2(Ms5kHz2<-lim)=nan;
    
    temp5kHz3=Data(Fq30kHz3(i))';
    Ms5kHz3=[temp5kHz3(:,1:size(temp5kHz3,2)-1)];
    Ms5kHz3(Ms5kHz3>lim)=nan;
    Ms5kHz3(Ms5kHz3<-lim)=nan;
    
    temp5kHz4=Data(Fq30kHz4(i))';
    Ms5kHz4=[temp5kHz4(:,1:size(temp5kHz4,2)-1)];
    Ms5kHz4(Ms5kHz4>lim)=nan;
    Ms5kHz4(Ms5kHz4<-lim)=nan;
    
    [M5kHz1,S1,E5kHz1]=MeanDifNan(RemoveNan(Ms5kHz1));
    [M5kHz2,S2,E5kHz2]=MeanDifNan(RemoveNan(Ms5kHz2));
    [M5kHz3,S3,E5kHz3]=MeanDifNan(RemoveNan(Ms5kHz3));
    [M5kHz4,S4,E5kHz4]=MeanDifNan(RemoveNan(Ms5kHz4));
    
    [h5kHz1,p5kHz1]=ttest2(RemoveNan(Ms5kHz1),RemoveNan(Ms5kHz4));
    
    rg5kHz=Range(Fq30kHz1(i),'ms');
    pr5kHz=rescale(p5kHz1,-1000, -1200);
    tps5kHz=Range(Fq30kHz1(i),'ms');
    
    hold on, subplot(3,2,6)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1),smo),'k','linewidth',2),
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1+E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz1-E5kHz1),smo),'k')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2),smo),'r','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2+E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz2-E5kHz2),smo),'r')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3),smo),'g','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3+E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz3-E5kHz3),smo),'g')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4),smo),'b','linewidth',2)
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4+E5kHz4),smo),'b')
    hold on, plot(tps5kHz(1:end-1),SmoothDec((M5kHz4-E5kHz4),smo),'b')
    hold on, plot(rg5kHz(p5kHz1<pval),pr5kHz(p5kHz1<pval),'kx')
    title([' 30 kHz intensity gradient',InfoLFP.structure(i)])
    hold on, axis([-50 150 -200 200])
    
end



% Load Information
res=pwd;
load([res,'/LFPData/InfoLFP']);
load ScanFrequency
clear LFP
load([res,'/LFPData/LFP',num2str(31)]);
LFP2=ResampleTSD(LFP,500);
signalTone=Data(LFP2);
tpsTone=Range(LFP2);

figure, 
hold on, title(['15kHz - intensity level 4 - ',InfoLFP.structure(31)])
for i=1:50
test=find(tpsTone(:,1)<Fq15kHz_int4(i)+10 & tpsTone(:,1)>Fq15kHz_int4(i)-10);
hold on, plot(1:601,signalTone(test-100:test+500)+i*1500,'b','linewidth',1)
hold on, plot(101,min(axis):max(axis),'r','linewidth',2);
end






% Load Information
res=pwd;
load([res,'/LFPData/InfoLFP']);

lim=1500;
smo=0.5;
for i=1:31; 
    %---------------------------------------------------------------------------
    %<><><><><><><><><><><><><><> Local Effect <><><><><><><><><><><><><><><
    %---------------------------------------------------------------------------
    tempA=Data(LFPFq5kHz(i))';
    MsA=[tempA(:,1:size(tempA,2)-1)];
    MsA(MsA>lim)=nan;
    MsA(MsA<-lim)=nan;
    
    tempB=Data(LFPFq10kHz(i))';
    MsB=[tempB(:,1:size(tempB,2)-1)];
    MsB(MsB>lim)=nan;
    MsB(MsB<-lim)=nan;
    
    tempC=Data(LFPFq15kHz(i))';
    MsC=[tempC(:,1:size(tempC,2)-1)];
    MsC(MsC>lim)=nan;
    MsC(MsC<-lim)=nan;
    
    tempD=Data(LFPFq20kHz(i))';
    MsD=[tempD(:,1:size(tempD,2)-1)];
    MsD(MsD>lim)=nan;
    MsD(MsD<-lim)=nan;
    
    tempE=Data(LFPFq25kHz(i))';
    MsE=[tempE(:,1:size(tempE,2)-1)];
    MsE(MsE>lim)=nan;
    MsE(MsE<-lim)=nan;
    
    tempF=Data(LFPFq30kHz(i))';
    MsF=[tempF(:,1:size(tempF,2)-1)];
    MsF(MsF>lim)=nan;
    MsF(MsF<-lim)=nan;
    
    [Ma,S1,Ea]=MeanDifNan(RemoveNan(MsA));
    [Mb,S2,Eb]=MeanDifNan(RemoveNan(MsB));
    [Mc,S3,Ec]=MeanDifNan(RemoveNan(MsC));
    [Md,S4,Ed]=MeanDifNan(RemoveNan(MsD));
    [Me,S5,Ee]=MeanDifNan(RemoveNan(MsE));
    [Mf,S6,Ef]=MeanDifNan(RemoveNan(MsF));
    
    rg=Range(LFPFq5kHz(i),'ms');
    tps=Range(LFPFq5kHz(i),'ms');
    
    figure, subplot(6,3,1)
    hold on, plot(tps(1:end-1),SmoothDec((Ma),smo),'r','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Ma+Ea),smo),'k') 
    hold on, plot(tps(1:end-1),SmoothDec((Ma-Ea),smo),'k') 
    title([' 5 kHz > ',InfoLFP.structure(i)])
    hold on, subplot(6,3,4)
    hold on, plot(tps(1:end-1),SmoothDec((Mb),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mb+Eb),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mb-Eb),smo),'r') 
    title([' 10 kHz > ',InfoLFP.structure(i)])
    hold on, subplot(6,3,7)
    hold on, plot(tps(1:end-1),SmoothDec((Mc),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mc+Ec),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mc-Ec),smo),'r') 
    title([' 15 kHz > ',InfoLFP.structure(i)])
    hold on, subplot(6,3,10)
    hold on, plot(tps(1:end-1),SmoothDec((Md),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Md+Ed),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Md-Ed),smo),'r')
    title([' 20 kHz > ',InfoLFP.structure(i)]) 
    hold on, subplot(6,3,13)
    hold on, plot(tps(1:end-1),SmoothDec((Me),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Me+Ee),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Me-Ee),smo),'r') 
    title([' 25 kHz > ',InfoLFP.structure(i)])
    hold on, subplot(6,3,16)
    hold on, plot(tps(1:end-1),SmoothDec((Mf),smo),'k','linewidth',2), 
    hold on, plot(tps(1:end-1),SmoothDec((Mf+Ef),smo),'r') 
    hold on, plot(tps(1:end-1),SmoothDec((Mf-Ef),smo),'r') 
    title([' 30 kHz > ',InfoLFP.structure(i)])

end






