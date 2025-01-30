%CompTracking

% filename='Mouse02_13012011.avi';

try
cd('D:\My Dropbox\MasterMarie\Data\DataSmrAvi')
catch
cd('/Users/karimbenchenane/Dropbox/MasterMarie/Data/DataSmrAvi')
end

% try 
%     Wb;
% catch
try
    load DataTrackingOnline M
    load RawData5
catch
    [Pos,Track]=TrackMouse(filename); save RaxData5 Pos Track
[Res,Rest,R1,R2,Mb,Mbt,M,Mt,Vit,zones,OmS,OmtS]=ICSSexplo('M02_13012011_S6.txt','zone',6,'threshold',2,'artefact',20);
end
    Art=90;
    [Wos,speed]=RemoveArtifacts(Pos,Art);
    deb=1800;
%     deb=1;
    
    W=Wos(1:end,2:3);
    W2=Rotate(W,-1.95);

    Mb=[rescale(M(:,1),0, 100) rescale(M(:,2),2, 100)];
    W3=W2(deb:end,:);
    Wb=[rescale(W3(:,1),0, 100) rescale(W3(:,2),0, 110)];
% end

iniM=59; %gray
iniW=13; %blue


figure('Color',[1 1 1]),
subplot(2,1,1), 
plot(Mb(iniM:end,1),Mb(iniM:end,2),'Color',[0.7 0.7 0.7],'linewidth',1 )
hold on, plot(Wb(iniW:end,1),Wb(iniW:end,2),'linewidth',1)

hold on, plot(Mb(iniM,1),Mb(iniM,2),'go','MarkerFaceColor','g')
hold on, plot(Wb(iniW,1),Wb(iniW,2),'go','MarkerFaceColor','g')
hold on, plot(Mb(end,1),Mb(end,2),'ro','MarkerFaceColor','r')
hold on, plot(Wb(end,1),Wb(end,2),'ro','MarkerFaceColor','r')


Mt=Mb(iniM:end,:);
tpsM=(M(iniM:end,4)-M(iniM,4));

Wt=Wb(iniW:end,:);
tpsW=(Pos(deb+iniW-1:end,1)-Pos(deb+iniW-1,1));

tpsM=rescale(tpsM,0,tpsW(end));

MT=tsd(tpsM,Mt);
WT=tsd(tpsW,Wt);

Mc=Data(Restrict(MT,MT));
Wc=Data(Restrict(WT,MT));


[C,lag]=xcorr(Mc(:,1),Wc(:,1),'none');
subplot(2,1,2), plot(lag,C,'k','linewidth',2)
[BE,id]=max(C);
lag(id)

if 0
            figure('Color',[1 1 1]),

            plot(Mc(:,1),Mc(:,2),'Color',[0.7 0.7 0.7],'linewidth',1 )
            hold on, plot(Wc(:,1),Wc(:,2),'linewidth',1)
            i=1;
            a=[];

            while length(a)~=1
                clf
                plot(Mc(:,1),Mc(:,2),'Color',[0.7 0.7 0.7],'linewidth',1 )
                hold on, plot(Wc(:,1),Wc(:,2),'linewidth',1)

                try
                    plot(Mc(i,1),Mc(i,2),'ko','MarkerFaceColor','k')
                end
                try
                    plot(Wc(i,1),Wc(i,2),'bo','MarkerFaceColor','b')
                end
               a=input('continuer?');
               i=i+1;

            end

end


% close all
% clear

try
cd('D:\My Dropbox\MasterMarie\Data\DataSmrAvi')
catch
cd('/Users/karimbenchenane/Dropbox/MasterMarie/Data/DataSmrAvi')
end

load RawData5
Art=90;
[Wos,speed]=RemoveArtifacts(Pos,Art);
[wav,Nwav,mVal,mTim,dt,times]=loadSMR('Mouse02_13012011',13,27);

Wos=[Rescale(Wos(:,1),times(1),times(end)),Wos(:,2:3)];

X=tsd(Wos(:,1),Wos(:,2));
Y=tsd(Wos(:,1),Wos(:,3));
F=tsd(times,wav{1});
stim=ts(mTim);

stim=Restrict(stim,intervalSet(25*60*1E4,times(end)));

[C, B] = CrossCorr(Data(stim), Data(stim), 20, 250);
C(B==0)=0;


figure('Color',[1 1 1]), 
subplot(2,1,1),
plot(Data(X),Data(Y),'Color',[0.7 0.7 0.7])
hold on, plot(Data(Restrict(X,stim)),Data(Restrict(Y,stim)),'ro','MarkerFaceColor','r')
subplot(2,1,2),
plot(B,C,'k','linewidth',2)

binsize=50;

[occH, x1, x2] = hist2d(Data(Y),Data(X),binsize, binsize);
[xs, OLDMIN, OLDMAX] = rescale(Data(X), 0, binsize);
[ys, OLDMIN, OLDMAX] = rescale(Data(Y), 0, binsize);
occHs=SmoothDec(occH,[3,3]);

Xs=tsd(Range(X),rescale(Data(X), 0, binsize));
Ys=tsd(Range(Y),rescale(Data(Y), 0, binsize));

figure('Color',[1 1 1])

hold on
imagesc(occHs)
plot(2+xs,1+ys,'w')
plot(2+Data(Restrict(Xs,stim)),1+Data(Restrict(Ys,stim)),'ko','MarkerFaceColor','k')
xlim([0 binsize])
ylim([0 binsize])





