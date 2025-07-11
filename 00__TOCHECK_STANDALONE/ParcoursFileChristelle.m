
%ParcoursFileChristelle

res=pwd;
list=dir;

DataRef{1}=num1;
DataRef{2}=num2;

l=length(list);

Freq=[];
F=[];
S2M=[];
S3M=[];
S2Mt=[];
S3Mt=[];
S2Me=[];
S3Me=[];           
            
a=1;

for i=1:l
    
    
    le=length(list(i).name);
    
    if le>4&list(i).name(le-2:le)=='txt'
        
        try 
	    lfp=load(list(i).name);
	    list(i).name
	    try
	    eval(['load ',['Data',list(i).name(1:le-4)],' DataCh'])
	    DataRef=DataCh;
	    end

            [FPeak,Peak,FPeak3,Peak3,FPeakt,Peakt,FPeak3t,Peak3t,FPeake,Peake,FPeak3e,Peak3e,f,S2m,S3m,S2mt,S3mt,S2me,S3me,DataCh]=LFPThetaSpectrum(lfp,DataRef);
            ti1=['Figure',list(i).name];
            ti2=['FigureExmple',list(i).name];
	    figure(num1),subplot(1,4,1:2), title(list(i).name)
	    figure(num2),subplot(1,4,1:2), title(list(i).name)
            saveFigure(num1,ti1,res)
            saveFigure(num2,ti2,res)
	    name=list(i).name;
	    nameRecording{a}=list(i).name;
            eval(['save ',['Data',list(i).name(1:le-4)],' FPeak Peak FPeak3 Peak3 FPeakt Peakt FPeak3t Peak3t FPeake Peake FPeak3e Peak3e f S2m S3m S2mt S3mt S2me S3me DataCh name'])
            
            
            Freq=[FPeak,FPeakt,FPeake,FPeak3,FPeak3t,FPeak3e,Peak,Peakt,Peake,Peak3,Peak3t,Peak3e];
            F=[F;Freq];
            S2M=[S2M;S2m];
            S3M=[S3M;S3m];
            S2Mt=[S2Mt;S2mt];
            S3Mt=[S3Mt;S3mt];
            S2Me=[S2Me;S2me];
	    S3Me=[S3Me;S3me];
            a=a+1;
 %       catch
 %           try
	   % lfp=load(list(i).name);
	   %   list(i).name
 %           [FPeak,Peak,FPeak3,Peak3,FPeake,Peake,f,S2m,S3m,S2mt,S3mt,S2me,S3me,DataCh]=LFPThetaSpectrum(lfp);
 %           ti1=['Figure',list(i).name];
 %           ti2=['FigureExmple',list(i).name];
%	    figure(num1),subplot(1,4,1:2), title(list(i).name)
%	    figure(num2),subplot(1,4,1:3), title(list(i).name)
%            saveFigure(num1,ti1,res)
%            saveFigure(num2,ti2,res)
%	    eval(['save ',['Data',list(i).name],' FPeak Peak FPeak3 Peak3 FPeake Peake f S2m S3m S2mt S3mt S2me S3me DataCh'])
%            Freq=[FPeak,FPeak3,FPeake,Peak,Peak3,Peake];
%            F=[F;Freq];
%            S2M=[S2M;S2m];
%            S3M=[S3M;S3m];
%            S2Mt=[S2Mt;S2mt];
%            S3Mt=[S3Mt;S3mt];
%            S2Me=[S2Me;S2me];
 %           end
       end
    end
    
end
    
[mS2M,sS2M,eS2M]=MeanDifNan(S2M);
[mS2Mt,sS2Mt,eS2Mt]=MeanDifNan(S2Mt);
[mS2Me,sS2Me,eS2Me]=MeanDifNan(S2Me);
[mS3M,sS3M,eS3M]=MeanDifNan(S3M);
[mS3Mt,sS3Mt,eS3Mt]=MeanDifNan(S3Mt);
[mS3Me,sS3Me,eS3Me]=MeanDifNan(S3Me);


figure('Color',[1 1 1]), hold on
subplot(1,3,1),hold on
plot(f,mS2M,'k','linewidth',2)
plot(f,mS2M+(eS2M),'k','linewidth',1)
plot(f,mS2M-(eS2M),'k','linewidth',1)
ylabel(['Power'])
xlabel(['Frequency (Hz)'])
title('Entire session')

subplot(1,3,2),hold on
plot(f,(mS2Mt),'k','linewidth',2)
plot(f,(mS2Mt)+(eS2Mt),'k','linewidth',1)
plot(f,(mS2Mt)-(eS2Mt),'k','linewidth',1)
ylabel(['Power'])
xlabel(['Frequency (Hz)'])
title('Theta Epoch')

subplot(1,3,3),hold on
plot(f,(mS2Me),'k','linewidth',2)
plot(f,(mS2Me)+(eS2Me),'k','linewidth',1)
plot(f,(mS2Me)-(eS2Me),'k','linewidth',1)
ylabel(['Power'])
xlabel(['Frequency (Hz)'])
title('Example Epoch')

figure('Color',[1 1 1]), hold on
subplot(1,3,1),hold on
plot(f,(mS3M),'k','linewidth',2)
plot(f,(mS3M)+(eS3M),'k','linewidth',1)
plot(f,(mS3M)-(eS3M),'k','linewidth',1)
ylabel(['Power (10*log10)'])
xlabel(['Frequency (Hz)'])
title('Entire session')

subplot(1,3,2),hold on
plot(f,(mS3Mt),'k','linewidth',2)
plot(f,(mS3Mt)+(eS3Mt),'k','linewidth',1)
plot(f,(mS3Mt)-(eS3Mt),'k','linewidth',1)
ylabel(['Power (10*log10)'])
xlabel(['Frequency (Hz)'])
title('Theta Epoch')

subplot(1,3,3),hold on
plot(f,(mS3Me),'k','linewidth',2)
plot(f,(mS3Me)+(eS3Me),'k','linewidth',1)
plot(f,(mS3Me)-(eS3Me),'k','linewidth',1)
ylabel(['Power (10*log10)'])
xlabel(['Frequency (Hz)'])
title('Example Epoch')


figure('Color',[1 1 1]), hold on
subplot(2,3,1), plot(f,S2M)
ylabel(['Power'])
xlabel(['Frequency (Hz)'])
title('Entire session')
subplot(2,3,2), plot(f,S2Mt)
title('Theta Epoch')
ylabel(['Power'])
xlabel(['Frequency (Hz)'])
subplot(2,3,3), plot(f,S2Me)
title('Example Epoch')
ylabel(['Power'])
xlabel(['Frequency (Hz)'])
subplot(2,3,4), plot(f,S3M)
title('Entire session')
ylabel(['Power (10*log10)'])
xlabel(['Frequency (Hz)'])
subplot(2,3,5), plot(f,S3Mt)
title('Theta Epoch')
ylabel(['Power (10*log10)'])
xlabel(['Frequency (Hz)'])
subplot(2,3,6), plot(f,S3Me)
title('Exemple Epoch')
ylabel(['Power (10*log10)'])
xlabel(['Frequency (Hz)'])

[mean(F(:,1:6))',stdError(F(:,1:6))']
[mean(F(:,7:12))',stdError(F(:,7:12))']

figure('Color',[1 1 1]), hold on
imagesc(F(:,1:6))
set(gca,'ytick',[1:size(F,1)])
set(gca,'yticklabel',nameRecording), colorbar
set(gca,'xtick',[1:6])
set(gca,'xticklabel',{'All','Theta','Ex','All','Theta','Ex'})
xlabel('normal                               (10*log10)')