function [muPost,KappaPost,pvalPost,muPre,KappaPre,pvalPre,phPre,phPost]=ControlICSSLFP(n,stimu,tps)

% n num du LFP

plo=0; % if 1 erase all figures exepct last;

%-------------------------------------------------
%-------------------------------------------------

pas=5;
pstat=0.05;

filterMethod=0;


%-------------------------------------------------
%-------------------------------------------------


debutPre=100; %default value 100
finPre=680;  %default value 740
debutPost=1100; %default value 1100
%finPost=size(M,2); %default value size(M,2)

%debutPost=1000;
%finPost=size(M,2)-100;


%-------------------------------------------------
%-------------------------------------------------




try
    tps;    
    bef=tps(1);
    aft=tps(2);
catch
   bef=6000;
   aft=7000;
end

  

load LFPData
load behavResources

try
    load StimMFB
    burst;
catch
    st=Range(stim,'s');
    bu = burstinfo(st,0.5);
    burst=tsd(bu.t_start*1E4,bu.i_start);
    idburst=bu.i_start;

    save StimMFB stim burst idburst
end


figure('color',[1 1 1]), [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{n}, stimu, -bef, +aft,'BinSize',10); 

if plo
close
end

M=Data(matVal)';
tps=Range(matVal,'s');


%-----------------------------------------------------------------------
%-----------------------------------------------------------------------


% debutPre=100; %default value 100
% finPre=740;  %default value 740
% debutPost=1100; %default value 1100

try
    finPost;
catch
    
    finPost=size(M,2); %default value size(M,2)
end


%debutPost=1000;
%finPost=size(M,2)-100;
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------





Mpost=M(:,debutPost:finPost);
Mpre=M(:,debutPre:finPre);



idx=[];
for i=1:size(Mpost,1)
%     if length(find(Mpost(i,:)<-2.5*1E4))==0
        if length(find(Mpost(i,:)<-3.0*1E4))==0
    idx=[idx,i];
    end
end
Mpost=Mpost(idx,:)';

if size(Mpost,2)==0
    Mpost=M(:,debutPost:finPost)';
    disp('PROBLEM')
end



idx=[];
for i=1:size(Mpre,1)
    if length(find(Mpre(i,:)<-3.0*1E4))==0
%     if length(find(Mpre(i,:)<-2.5*1E4))==0
        
    idx=[idx,i];
    end
end
Mpre=Mpre(idx,:)';



tpsPre=tps(debutPre:finPre);
tpsPost=tps(debutPost:finPost);

%tpsPre=[1:size(Mpre,1)]'/1250;
%tpsPost=[1:size(Mpost,1)]'/1250;

figure('color',[1 1 1]), 
subplot(2,2,1), hold on, plot(tpsPre,Mpre,'k'), xlim([tpsPre(1) tpsPre(end)]),ylim([-5500 5500]), title('LFP in theta band, Before'), xlim([tpsPre(1) -0.12])
subplot(2,2,2), hold on, plot(tpsPost,Mpost,'k'), xlim([tpsPost(1) tpsPost(end)]),ylim([-5500 5500]), title('LFP in theta band, After'), xlim([tpsPost(1) 0.65])


fi=128;

Tpre=tsd(tpsPre*1E4,Mpre);
Tpost=tsd(tpsPost*1E4,Mpost);



if filterMethod
    
TpreF=FilterLFP(Tpre,[5 14],fi);
TpostF=FilterLFP(Tpost,[5 14],fi);

else
    
TpreF=Filter([Range(Tpre,'s') Data(Tpre)],'passband',[5 14],'filter','cheby2','order',4);
TpostF=Filter([Range(Tpost,'s') Data(Tpost)],'passband',[5 14],'filter','cheby2','order',4);

TpreF=tsd(TpreF(:,1)*1E4,TpreF(:,2:end));
TpostF=tsd(TpostF(:,1)*1E4,TpostF(:,2:end));

end
    
%figure('color',[1 1 1]), 

% 
% subplot(2,2,3), hold on, plot(Range(TpreF,'s'),Data(TpreF),'k'), xlim([tpsPre(1) tpsPre(end)]),ylim([-5500 5500]), title('Filtered LFP in theta band, After')
% subplot(2,2,4), hold on, plot(Range(TpostF,'s'),Data(TpostF),'k'), xlim([tpsPost(1) tpsPost(end)]),ylim([-5500 5500]), title('Filtered LFP in theta band, Before')



if filterMethod
    [b,a]=butterlow1(4/1250);
    MpreFlow = filtfilt(b,a,Mpre);
    MpostFlow = filtfilt(b,a,Mpost);


    MpreF=Data(TpreF)-MpreFlow;
    MpostF=Data(TpostF)-MpostFlow;

else
    MpreF=Data(TpreF);
    MpostF=Data(TpostF);
end

subplot(2,2,3), hold on, plot(Range(TpreF,'s'),MpreF,'k'), xlim([tpsPre(1) tpsPre(end)]),ylim([-1500 1500]), title('Filtered LFP in theta band, Before'), xlim([tpsPre(1) -0.12])
subplot(2,2,4), hold on, plot(Range(TpostF,'s'),MpostF,'k'), xlim([tpsPost(1) tpsPost(end)]),ylim([-1500 1500]), title('Filtered LFP in theta band, After'), xlim([tpsPost(1) 0.65])


if plo
close
end

figure('color',[1 1 1]), a=1;

for i=1:10
subplot(10,2,a), hold on, 
plot(tpsPre,Mpre(:,i),'k'),
plot(tpsPre,MpreF(:,i),'r','linewidth',2), xlim([tpsPre(1) tpsPre(end)]), xlim([tpsPre(1) -0.12]),ylim([-5500 5500])%,xlim([0 size(Mpre,1)/1250])
subplot(10,2,a+1), hold on, 
plot(tpsPost,Mpost(:,i),'k'),
plot(tpsPost,MpostF(:,i),'r','linewidth',2), xlim([tpsPost(1) tpsPost(end)]),ylim([-5500 5500]), xlim([tpsPost(1) 0.65])%,xlim([0 size(Mpost,1)/1250])
a=a+2;
end


rgpreF=Range(TpreF);
% rgpreF=rgpreF(1:550);
% zrPre = hilbert(MpreF(1:550,:));
zrPre = hilbert(MpreF);
phzrPre = atan2(imag(zrPre), real(zrPre));
phzrPre(phzrPre < 0) = phzrPre(phzrPre < 0) + 2 * pi;
phasePreTsd = tsd(rgpreF, phzrPre);

rgpostF=Range(TpostF);
% rgpostF=rgpostF(1:400);
% zrPost = hilbert(MpostF(1:400,:));
zrPost = hilbert(MpostF);
phzrPost = atan2(imag(zrPost), real(zrPost));
phzrPost(phzrPost < 0) = phzrPost(phzrPost < 0) + 2 * pi;
phasePostTsd = tsd(rgpostF, phzrPost);

if plo
close
end

figure ('color',[1 1 1]),
subplot(2,2,1), imagesc(tpsPre,[1:size(phzrPre,2)],phzrPre'), title('Before'), ylabel('Phase'), xlim([tpsPre(1) -0.12])
subplot(2,2,2), imagesc(tpsPost,[1:size(phzrPost,2)],phzrPost'),title('After'), xlim([tpsPost(1) 0.65])
subplot(2,2,3), imagesc(tpsPre,[1:size(phzrPre,2)],abs(zrPre)'), ca=caxis; ylabel('Power'), xlim([tpsPre(1) -0.12])
subplot(2,2,4), imagesc(tpsPost,[1:size(phzrPost,2)],abs(zrPost)'), caxis(ca), xlim([tpsPost(1) 0.65])

if plo
close
end

phPre=phzrPre';
phPost=phzrPost';


for i=1:size(phPre,2)
hpre(i,:)=hist(phPre(:,i),[0:0.3:2*pi]);
end
for i=1:size(phPost,2)
hpost(i,:)=hist(phPost(:,i),[0:0.3:2*pi]);
end


smo=0.05;
% smo=1;

figure ('color',[1 1 1]),
subplot(4,2,1),imagesc(tpsPre,[0:0.3:2*pi],SmoothDec(hpre(:,2:end)',[smo 0.05])), ca=caxis; caxis([0 ca(2)]); title(['Pre, max=',num2str(ca(2))]), ylabel('Phase distribution'), axis xy, xlim([tpsPre(1) -0.12])
subplot(4,2,2),imagesc(tpsPost,[0:0.3:2*pi],SmoothDec(hpost(:,2:end)',[smo 0.05])), ca2=caxis; caxis([0 ca2(2)]);  title(['Post, max=',num2str(ca2(2))]), axis xy, xlim([tpsPost(1) 0.65])



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



% pas=10;
% pstat=0.05;

nu=1;
for i=1:pas:size(phPre,2)
    
    figure, [muPre(nu), KappaPre(nu), pvalPre(nu)]=JustPoltMod(phPre(:,i),20); close
    nu=nu+1;
end

   nu2=1;
for i=1:pas:size(phPost,2)
 
    figure, [muPost(nu2), KappaPost(nu2), pvalPost(nu2)]=JustPoltMod(phPost(:,i),20); close
    nu2=nu2+1;
end

tpspre=tpsPre(1:pas:end);
tpspost=tpsPost(1:pas:end);

subplot(4,2,3),hold on
plot(tpspre,pvalPre,'color',[0.7 0.7 0.7],'linewidth',2)
plot(tpspre(pvalPre<pstat),pvalPre(pvalPre<pstat),'k.','linewidth',2), ylabel('p value'), xlim([tpsPre(1) tpsPre(end)]), xlim([tpsPre(1) -0.12])

subplot(4,2,4),hold on
plot(tpspost,pvalPost,'color',[0.7 0.7 0.7],'linewidth',2)
plot(tpspost(pvalPost<pstat),pvalPost(pvalPost<pstat),'r.','linewidth',2), xlim([tpsPost(1) tpsPost(end)]), xlim([tpsPost(1) 0.65])

subplot(4,2,5),hold on
plot(tpspre,muPre,'color',[0.7 0.7 0.7],'linewidth',2)
plot(tpspre(pvalPre<pstat),muPre(pvalPre<pstat),'k.','linewidth',2), ylabel('Phase (rad)'), xlim([tpsPre(1) tpsPre(end)]), xlim([tpsPre(1) -0.12])

subplot(4,2,6),hold on
plot(tpspost,muPost,'color',[0.7 0.7 0.7],'linewidth',2)
plot(tpspost(pvalPost<pstat),muPost(pvalPost<pstat),'r.','linewidth',2), xlim([tpsPost(1) tpsPost(end)]), xlim([tpsPost(1) 0.65])

subplot(4,2,7),hold on
plot(tpspre,KappaPre,'color',[0.7 0.7 0.7],'linewidth',2)
plot(tpspre(pvalPre<pstat),KappaPre(pvalPre<pstat),'k.','linewidth',2), ylabel('Kappa value'), xlim([tpsPre(1) tpsPre(end)]), xlim([tpsPre(1) -0.12])

subplot(4,2,8),hold on
plot(tpspost,KappaPost,'color',[0.7 0.7 0.7],'linewidth',2)
plot(tpspost(pvalPost<pstat),KappaPost(pvalPost<pstat),'r.','linewidth',2), xlim([tpsPost(1) tpsPost(end)]), xlim([tpsPost(1) 0.65])
