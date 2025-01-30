%CreateXYfromPos

load behavResources


fff=1;
plo=0;
setCu=0;

%FreqVideo=15; % Hz
FreqVideo=30; % Hz


% 
% 
% list=dir;
% a=1;
% 
% for i=1:length(list)
%     le=length(list(i).name);
%     if length(list(i).name)>12&list(i).name(le-4:le)=='.pos'
% NomPos=length(list(i).name);
%     end
% end
% 
% eval(['Postemp=load(''', NomPos,''');'])
%                                                         

Postemp=load('/Volumes/USBDisk1/Mouse013/20110420/ICSS-Mouse-13-20042011/ICSS-Mouse-13-20042011.pos');
 
                try
                load LFPData LFP% error
                rg=Range(LFP{1},'s');
                dur=rg(end)-rg(1);
                catch
                    dur=input('Tu fais un test, quelle est la duree de l''enregistrement? ');
                end
                
                FreqObs=length(Postemp)/dur;
                tps=[1:length(Postemp)]'/FreqObs;
                
                PosTemp=[tps,Postemp];
                Art=100;
                [PosC,speed]=RemoveArtifacts(PosTemp,Art);  
                
                figure(1), clf
                subplot(2,1,1),hold on
                plot(PosTemp(:,2),PosTemp(:,3)), xlim([0 400]), ylim([0 400])
                plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]),
                try
                    title(namePos{i}(27:end-9));
                end
                
                subplot(2,1,2),hist(speed,100)

                rep=input('Tracking ok? (o/n) : ','s');

                if rep=='n'

                while rep=='n'

                    Art=input('Speed limit for artefacts :');
                    [PosC,speed]=RemoveArtifacts(PosTemp,Art); 

                    if length(PosC)==length(PosTemp)-1
                        PosC=[PosC;PosC(end,:)];
                        speed=[speed;speed(end)];
                        elseif length(PosC)==length(PosTemp)-2
                        PosC=[PosC(1,:);PosC;PosC(end,:)];
                        speed=[speed(1);speed;speed(end)];
                        end


                        figure(1),clf
                        subplot(2,1,1),hold on
                        plot(PosTemp(:,2),PosTemp(:,3)), xlim([0 400]), ylim([0 400])
                        plot(PosC(:,2),PosC(:,3),'r'), xlim([0 400]), ylim([0 400]), 
                        try 
                            title(namePos{i}(27:end-9));
                        end
                        subplot(2,1,2),hist(speed,100)

                        rep=input('Tracking ok? (o/n) : ','s');
                end


                end

                PosC2=[ones(20,1)*PosC(1,2:3); PosC(:,2:3); ones(20,1)*PosC(end,2:3)];
                PosT=resample(PosC2(:,1:2),floor(FreqVideo/FreqObs*1E4),1E4);                     
                
                Postemp=PosT(21:end-20,:);
                
                
                

                
                
                
                
                
                
                
                
                
 Freq=FreqVideo;
%             
tps=[1:length(Postemp)]'/Freq;
%             % tps=rescale(tps,deb,lfp(end,1)-fin)*1E4;
%             tps2=rescale(tps,lfp(1,1),lfp(end,1))*1E4;
clear PosTotal
PosTotal(:,1)=tps;
PosTotal(:,2:3)=Postemp;
Pos=PosTotal;


%            Art=0.01;
%            [PosC,speed]=RemoveArtifacts(Pos,Art);

%             if length(PosC)==length(tps)-1
%                 PosC=[PosC;PosC(end,:)];
%                 speed=[speed;speed(end)];
%             elseif length(PosC)==length(tps)-2
%                 PosC=[PosC(1,:);PosC;PosC(end,:)];
%                 speed=[speed(1);speed;speed(end)];
%             end


for i=1:length(Pos)-1
Vx = (Pos(i,2)-Pos(i+1,2))*30;
Vy = (Pos(i,3)-Pos(i+1,3))*30;
Vitesse(i) = sqrt(Vx^2+Vy^2);
end;

Speed=SmoothDec(Vitesse',1);


X=tsd(tps*1E4,Pos(:,2));
Y=tsd(tps*1E4,Pos(:,3));
V=tsd(tps*1E4,[Speed;Speed(end)]);

%X2=tsd(tps2*1E4,PosC(:,2));
%Y2=tsd(tps2*1E4,PosC(:,3));
%V2=tsd(tps2*1E4,[speed;speed(end)]);



save behavResources -Append Pos Speed X Y V 
