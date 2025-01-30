%% Temp=f(certitude)


error={};
tps = 0; % this variable counts the total time of all concatenated data

            Mouse688.DLC.TailBase_X = tsd([],[]);
            Mouse688.DLC.TailBase_Y = tsd([],[]);
            Mouse688.DLC.BaseIncertitude=tsd([],[]);
            Mouse688.DLC.TailCenter_X = tsd([],[]);
            Mouse688.DLC.TailCenter_Y = tsd([],[]);
            Mouse688.DLC.CenterIncertitude=tsd([],[]);

for ff=1:length(FolderList.M688Fear)
    try cd([FolderList.M688Fear{ff}  '/Temperature'])
        if exist('Temperature.mat')>0
            load('behavResources_SB.mat')
            load('Temperature.mat')
            [filename,pathname]=uigetfile('*.csv','Select the DeepLabCut tracking file')
            DLC=csvread(fullfile(pathname,filename),3); %loads the csv from line 3 to the end (to skip the Header)
            
            tpsmax = max(Range(Temp.TailTemperatureTSD)); % use Behav.Xtsd to get precise end time
            rg1 = Range(Temp.TailTemperatureTSD);
            dt=Data(Temp.TailTemperatureTSD);
            dt=~isnan(dt);
            rg=rg1(dt);
            
            dt1 = DLC(:,17);
            dt2 = DLC(:,18);
            dt3 = DLC(:,19);
            dt4 = DLC(:,20);
            dt5 = DLC(:,21);
            dt6 = DLC(:,22);
            
            Mouse688.DLC.TailBase_X = tsd([Range(Mouse688.DLC.TailBase_X);rg+tps],[Data(Mouse688.DLC.TailBase_X);dt1]);
            Mouse688.DLC.TailBase_Y = tsd([Range(Mouse688.DLC.TailBase_Y);rg+tps],[Data(Mouse688.DLC.TailBase_Y);dt2]);
            Mouse688.DLC.BaseIncertitude=tsd([Range(Mouse688.DLC.BaseIncertitude);rg+tps],[Data(Mouse688.DLC.BaseIncertitude);dt3]);
            Mouse688.DLC.TailCenter_X = tsd([Range(Mouse688.DLC.TailCenter_X);rg+tps],[Data(Mouse688.DLC.TailCenter_X);dt4]);
            Mouse688.DLC.TailCenter_Y = tsd([Range(Mouse688.DLC.TailCenter_Y);rg+tps],[Data(Mouse688.DLC.TailCenter_Y);dt5]);
            Mouse688.DLC.CenterIncertitude=tsd([Range(Mouse688.DLC.CenterIncertitude);rg+tps],[Data(Mouse688.DLC.CenterIncertitude);dt6]);
            
            tps=tps + tpsmax;
        end
    catch error{ff}=FolderList.M688Fear{ff};
    end
end


temp=Data(Control.M688.FearTemp);
incertitude_center=Data(Mouse688.DLC.CenterIncertitude);
figure; plot(incertitude_center,temp(1:end-1),'.r')

a(:,1)=temp(1:end-1);
a(:,2)=incertitude_center;
b(:,1)=a(:,2)<0.5;
b(:,2)=a(:,2)>0.5;
c(:,1)=a(b(:,1),1); %certitude low
d(:,1)=a(b(:,2),1); % certitude high


nanmean(c)
nanmean(d)

%% X,Y,V=f(certitude)

error={};
tps = 0; % this variable counts the total time of all concatenated data
Mouse688.DLC.Xpos = tsd([],[]);
Mouse688.DLC.Ypos = tsd([],[]);
Mouse688.DLC.Speed = tsd([],[]);

for ff=1:length(FolderList.FearM669)
    try cd([FolderList.FearM669{ff}  '/Temperature'])
        if exist('Temperature.mat')>0
            load('behavResources_SB.mat')
            load('Temperature.mat')
            tpsmax=max(Range(Behav.Xtsd));
            rg=Range(Behav.Xtsd);
            rg2=rg(2:end);
            dt_1=Data(Behav.Xtsd);
            dt_2=Data(Behav.Ytsd);
            dt_3=Data(Behav.Vtsd);
            
            Mouse669.DLC.Xpos = tsd([Range(Mouse669.DLC.Xpos);rg+tps],[Data(Mouse669.DLC.Xpos);dt_1]);
            Mouse669.DLC.Ypos = tsd([Range(Mouse669.DLC.Ypos);rg+tps],[Data(Mouse669.DLC.Ypos);dt_2]);
            Mouse669.DLC.Speed = tsd([Range(Mouse669.DLC.Speed);rg2+tps],[Data(Mouse669.DLC.Speed);dt_3]);
            
            tps=tps + tpsmax;
        end
    catch error{ff}=FolderList.FearM669{ff};
    end
end

Xpos=Data(Mouse669.DLC.Xpos);
Ypos=Data(Mouse669.DLC.Ypos);
Speed=Data(Mouse669.DLC.Speed);

c(:,1)=a(b(:,1),1); %certitude low
d(:,1)=a(b(:,2),1); % certitude high

scatter(Xpos(1:end-1),Ypos(1:end-1),2,Data(Mouse669.DLC.CenterIncertitude),'filled')
colorbar
figure
plot(a(1:121702,2),Speed,'.r')
xlabel('Certitude')
ylabel('Speed')
title('Speed=f(Certitude) Fear sess Mouse 669')
vline(0.5,'--k','mean = 116 685          mean=5017')

speed1=Speed>20;
speed2=Speed<20;
nanmean(a(speed1,2))
nanmean(a(speed2,2))

sum(speed1)
sum(speed2)


%% Certitude FreezeAccEpoch

error={};
tps = 0; % this variable counts the total time of all concatenated data
Mouse669.DLC.CertitudeFz = tsd([],[]);

for ff=1:length(FolderList.FearM669)
    try cd([FolderList.FearM669{ff}  '/Temperature'])
        if exist('Temperature.mat')>0
            load('behavResources_SB.mat')
            load('Temperature.mat')
            tpsmax=max(Range(Restrict(Mouse669.DLC.CenterIncertitude,Behav.FreezeAccEpoch)));
            rg=Range(Restrict(Mouse669.DLC.CenterIncertitude,Behav.FreezeAccEpoch));
            dt=Data(Restrict(Mouse669.DLC.CenterIncertitude,Behav.FreezeAccEpoch));
            
            Mouse669.DLC.CertitudeFz = tsd([Range(Mouse669.DLC.CertitudeFz);rg+tps],[Data(Mouse669.DLC.CertitudeFz);dt]);
       
            tps=tps + tpsmax;
        end
    catch error{ff}=FolderList.FearM669{ff};
    end
end

CertitudeFz=Data(Mouse669.DLC.CertitudeFz);
nanmean(CertitudeFz)

