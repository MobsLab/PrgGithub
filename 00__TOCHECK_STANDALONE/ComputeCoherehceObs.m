




EEG=LFP{10};
ECoG=LFP{11};
LfpS=LFP{15};
LfpD=LFP{13};

% EEG=LFP{3};
% ECoG=LFP{2};
% LfpS=LFP{1};
% LfpD=LFP{4};







%-------------------------------------------------------------------------
%%
% definition des periodes a analyser (a doit etre en sec)
%-------------------------------------------------------------------------

%Epoch=intervalSet(500*1E4, 870*1E4);

% deb=213;
% fin=214;

deb=a;
fin=a+25;     % on prend 25 sec
% fin=a+3;
%fin=a+0.5;

Epoch=intervalSet(deb*1E4,fin*1E4);
 



%-------------------------------------------------------------------------
%%
% definition des parametres
%-------------------------------------------------------------------------

smo=1;
   
movingwin=[(fin-deb)/10,(fin-deb)/100];
% movingwin=[2,0.1];
% movingwin=[0.7,0.01];
% movingwin=[0.5,0.01];
%movingwin=[0.3,0.01];
% movingwin=[0.1,0.01];

params.trialave = 0;
params.err = [1 0.05];

fp1=4/(fin-deb);
%fp1=55;
%fp2=150;
 %fp2=75;
fp2=25;


params.fpass = [fp1 fp2];

params.Fs = 1/median(diff(Range(Restrict(LfpS,Epoch), 's')));
params.tapers=[1 2];
params.tapers=[2 3];
params.tapers=[3 5];
%params.tapers=[5 9];
%  params.tapers=[10 19];

% params.pad=0;
%  params.pad=1;
 params.pad=2;
% params.pad=4;
% params.pad=6;


%-------------------------------------------------------------------------
%%
% calcul de la coherence (chronux)
%-------------------------------------------------------------------------



d1=Data(Restrict(LfpS,Restrict(LfpD,Epoch)));
d2=Data(Restrict(LfpD,Epoch));
[Cf,phif,S12f,S1f,S2f,t,f,confC,phierr]=cohgramc(d1-mean(d1),d2-mean(d2),movingwin,params);



%-------------------------------------------------------------------------
%%
% Affichage des résultats
%-------------------------------------------------------------------------



yl1=fp1;
yl2=fp2;

% yl1=0;
% yl2=30;

try 
    num;
catch
    
figure('color',[1 1 1]),
num=gcf;
end

if 0
    
figure(num)
subplot(7,1,1), hold on
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
ylim([min(min(d1),min(d2)) max(max(d1),max(d2))])

title(['moovingwin ', num2str(movingwin(1)),' & ', num2str(movingwin(2)),', tapers ', num2str(params.tapers(1)),  ' & ', num2str(params.tapers(2)), ', pad ', num2str(params.pad)])
subplot(7,1,2), imagesc(t,f,Cf'), axis xy, ylim([yl1 yl2])
subplot(7,1,3), imagesc(t,f,phif'), axis xy, ylim([yl1 yl2])

subplot(7,1,4), imagesc(t,f,10*log(S1f)'), axis xy, ylim([yl1 yl2])
subplot(7,1,5), imagesc(t,f,10*log(S2f)'), axis xy, ylim([yl1 yl2])

fvec=f'*ones(1,length(t));
subplot(7,1,6), imagesc(t,f,fvec.*(S1f)'), axis xy, ylim([yl1 yl2])
subplot(7,1,7), imagesc(t,f,fvec.*(S2f)'), axis xy, ylim([yl1 yl2])

else 

   
figure(num)
subplot(7,1,1), hold on
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
xlim([deb+movingwin(1)/2 fin-+movingwin(1)/2])
ylim([min(min(d1),min(d2)) max(max(d1),max(d2))])

title(['moovingwin ', num2str(movingwin(1)),' & ', num2str(movingwin(2)),', tapers ', num2str(params.tapers(1)),  ' & ', num2str(params.tapers(2)), ', pad ', num2str(params.pad)])
subplot(7,1,2), imagesc(t,f,SmoothDec(Cf',[smo smo])), axis xy, ylim([yl1 yl2])
subplot(7,1,3), imagesc(t,f,SmoothDec(phif',[smo smo])), axis xy, ylim([yl1 yl2])

subplot(7,1,4), imagesc(t,f,SmoothDec(10*log(S1f)',[smo smo])), axis xy, ylim([yl1 yl2])
subplot(7,1,5), imagesc(t,f,SmoothDec(10*log(S2f)',[smo smo])), axis xy, ylim([yl1 yl2])

fvec=f'*ones(1,length(t));
subplot(7,1,6), imagesc(t,f,SmoothDec(fvec.*(S1f)',[smo smo])), axis xy, ylim([yl1 yl2])
subplot(7,1,7), imagesc(t,f,SmoothDec(fvec.*(S2f)',[smo smo])), axis xy, ylim([yl1 yl2])


end


% 
% x1=a;
% x2=a+1;
% subplot(7,1,1), xlim([x1 x2])
% for i=2:7
% subplot(7,1,i), xlim([x1 x2]-deb)
% end
% 
% 
% figure('color',[1 1 1]),hold on
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpS,Epoch)),'k')
% plot(Range(Restrict(LfpS,Epoch),'s'),Data(Restrict(LfpD,Epoch)),'r')
% 
% plot(Range(Restrict(ECoG,Epoch),'s'),Data(Restrict(ECoG,Epoch)),'b')
% 

