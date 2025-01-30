%test

% cd('D:\Data\ICSS-Sleep\Mouse006\03022011')
% filename='Mouse006-07022011-BN-BR-WR-WN.avi';

% try
%     load behavResources
% catch
% [Pos,Track]=TrackMouse(filename);
% save behavResources Pos Track
% end
% 
% [wav,Nwav,mVal,mTim,dt,times]=loadSMR('Mouse006_07022011_BN_BR_WR_WN',31,27);


try 
    load behavResources
    load LFPData
catch
    
    listCh=input('channels'' list : ');

    [Pos,Track,dur]=TrackMouse(filename);
    save behavResources Pos Track dur

    [wav,Nwav,mVal,mTim,dt,times]=loadSMR(filename,listCh,27);

    save LFPData wav Nwav mVal mTim dt times

end


% Art=90;
% [Wos,speed]=RemoveArtifacts(Pos,Art);
Wos=Pos;

% figure, plot(Pos(:,2),Pos(:,3))
% hold on, plot(Wos(:,2),Wos(:,3),'Color',[0.7 0.7 0.7])
 

OBJ = mmreader([filename,'.avi']);
dur = get(OBJ, 'Duration');

% vue sur le fichier spike2
%             dur=(31*60+37)*1E4;  %1.8822e+003
 dur=times(end);

Wos=[Rescale(Wos(:,1),6E4,dur-3E4),Wos(:,2:3)];
% 
% tpsVideo=[139 306 395 936]';
% tpsSpike2=[134 291 376 885]';
% 
% % p=polyfit(tpsSpike2,tpsVideo,1);
% p=polyfit(tpsVideo,tpsSpike2,1);
% 
% WosC=Wos(:,1);
% Wos(:,1)=Wos(:,1)*p(1)+p(2);


X=tsd(Wos(:,1),Wos(:,2));
Y=tsd(Wos(:,1),Wos(:,3));

stim=tsd(mTim,mTim);

[C, B] = crosscorr(Data(stim), Data(stim), 20, 250);
C(B==0)=0;

StimW=tsd(Wos(:,1),Wos(:,1));
stimW=Data(Restrict(StimW,stim,'align','prev'));

if 1
    
            figure('Color',[1 1 1])
            num=gcf;

            for i=250:length(Wos)  % 1600, 1900
                figure(gcf),clf,imagesc(Track(:,:,i))
                hold on, plot(Wos(:,2),Wos(:,3),'Color',[0.7 0.7 0.7])
                hold on, plot(Wos(i,2),Wos(i,3),'wo','MarkerFaceColor','w')
                 title([num2str(floor(Wos(i,1)/1E4)),' s,  ',num2str(floor(i/length(Wos)*100)),' %'])
                if ismember(Wos(i,1),stimW)
                hold on, plot(Wos(i-10:i+10,2),Wos(i-10:i+10,3),'r','linewidth',2)
                hold on, plot(Wos(i,2),Wos(i,3),'ko','MarkerFaceColor','k')
                pause(1)
                end 
                pause(0.5)
            end

end


figure('Color',[1 1 1]),
subplot(2,1,1),
plot(Data(X),max(Data(Y))-Data(Y),'Color',[0.7 0.7 0.7])
% hold on, plot(Data(Restrict(X,stim)),Data(Restrict(Y,stim)),'ro','MarkerFaceColor','r')

a=1;
for i=1:length(Wos)
                if ismember(Wos(i,1),stimW)
                    try
                hold on, plot(Wos(i-10:i+10,2),max(Wos(:,3))-Wos(i-10:i+10,3),'r','linewidth',2)
                    catch
                    try
                        hold on, plot(Wos(i:i+10,2),max(Wos(:,3))-Wos(i:i+10,3),'r','linewidth',2)
                    catch
                        hold on, plot(Wos(i-10:i,2),max(Wos(:,3))-Wos(i-10:i,3),'r','linewidth',2)
                    end
                    
                    end
                    
                hold on, plot(Wos(i,2),max(Wos(:,3))-Wos(i,3),'ko','MarkerFaceColor','k')
                numStim(a)=i;
                a=a+1;
                end 
end
            
hold on, plot(Data(Restrict(X,stim,'align','prev')),max(Data(Y))-Data(Restrict(Y,stim,'align','prev')),'k.')
hold on, scatter(Data(Restrict(X,stim,'align','prev')),max(Data(Y))-Data(Restrict(Y,stim,'align','prev')),60,mTim/1E4,'filled')

subplot(2,1,2),
plot(B,C,'k','linewidth',2)


