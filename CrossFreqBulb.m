function CrossFreqBulb(EPochName,cha)

%CrossFreqBulb

if 0
    EPochName='S1';
    EPochName='R1';
    EPochName='W1';
    EPochName='S2';
    EPochName='R2';
    % EPochName='W2';
    %------------------------------------------------------------------------------------
    % cha=input('Wich channel? ');
    cha=23;
    end

%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------

load behavResources PreEpoch Movtsd

load StateEpochSB

SWSEpoch2=SWSEpoch;
REMEpoch2=REMEpoch;
Wake2=Wake;

load StateEpoch SWSEpoch REMEpoch MovEpoch GndNoiseEpoch WeirdNoiseEpoch NoiseEpoch

try
SWSEpoch=SWSEpoch-GndNoiseEpoch-WeirdNoiseEpoch-NoiseEpoch;
REMEpoch=REMEpoch-GndNoiseEpoch-WeirdNoiseEpoch-NoiseEpoch;
MovEpoch=MovEpoch-GndNoiseEpoch-WeirdNoiseEpoch-NoiseEpoch;
catch
SWSEpoch=SWSEpoch-GndNoiseEpoch-NoiseEpoch;
REMEpoch=REMEpoch-GndNoiseEpoch-NoiseEpoch;
MovEpoch=MovEpoch-GndNoiseEpoch-NoiseEpoch;   
end


%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------


eval(['load(''SpectrumDataL/Spectrum',num2str(cha),'.mat'')'])

Sptsd=tsd(t*1E4,Sp);

figure('color',[1 1 1]), 
 
subplot(3,2,1), hold on
plot(f,mean(Data(Restrict(Sptsd,and(SWSEpoch2,PreEpoch)))))
hold on, plot(f,mean(Data(Restrict(Sptsd,and(REMEpoch2,PreEpoch)))),'r')
hold on, plot(f,mean(Data(Restrict(Sptsd,and(Wake2,PreEpoch)))),'k')

subplot(3,2,2), hold on
plot(f,mean(Data(Restrict(Sptsd,and(SWSEpoch,PreEpoch)))))
hold on, plot(f,mean(Data(Restrict(Sptsd,and(REMEpoch,PreEpoch)))),'r')
hold on, plot(f,mean(Data(Restrict(Sptsd,and(MovEpoch,PreEpoch)))),'k')

subplot(3,2,3), hold on
plot(Data(Restrict(smooth_ghi,and(SWSEpoch2,PreEpoch))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(SWSEpoch2,PreEpoch)))),'.','markersize',1)
plot(Data(Restrict(smooth_ghi,and(REMEpoch2,PreEpoch))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(REMEpoch2,PreEpoch)))),'r.','markersize',1)
plot(Data(Restrict(smooth_ghi,and(Wake2,PreEpoch))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(Wake2,PreEpoch)))),'k.','markersize',1)

subplot(3,2,4), hold on
plot(Data(Restrict(smooth_ghi,and(SWSEpoch,PreEpoch))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(SWSEpoch,PreEpoch)))),'.','markersize',1)
plot(Data(Restrict(smooth_ghi,and(REMEpoch,PreEpoch))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(REMEpoch,PreEpoch)))),'r.','markersize',1)
plot(Data(Restrict(smooth_ghi,and(MovEpoch,PreEpoch))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(MovEpoch,PreEpoch)))),'k.','markersize',1)

subplot(3,2,5), hold on
plot(Data(Restrict(Movtsd,Restrict(smooth_ghi,and(SWSEpoch2,PreEpoch)))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(SWSEpoch2,PreEpoch)))),'.','markersize',1)
plot(Data(Restrict(Movtsd,Restrict(smooth_ghi,and(REMEpoch2,PreEpoch)))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(REMEpoch2,PreEpoch)))),'r.','markersize',1)
plot(Data(Restrict(Movtsd,Restrict(smooth_ghi,and(Wake2,PreEpoch)))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(Wake2,PreEpoch)))),'k.','markersize',1)

subplot(3,2,6), hold on
plot(Data(Restrict(Movtsd,Restrict(smooth_ghi,and(SWSEpoch,PreEpoch)))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(SWSEpoch,PreEpoch)))),'.','markersize',1)
plot(Data(Restrict(Movtsd,Restrict(smooth_ghi,and(REMEpoch,PreEpoch)))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(REMEpoch,PreEpoch)))),'r.','markersize',1)
plot(Data(Restrict(Movtsd,Restrict(smooth_ghi,and(MovEpoch,PreEpoch)))),Data(Restrict(smooth_Theta,Restrict(smooth_ghi,and(MovEpoch,PreEpoch)))),'k.','markersize',1)

%---------------------------------------------------------------

Ssws2=Data(Restrict(Sptsd,and(SWSEpoch2,PreEpoch)));
Srem2=Data(Restrict(Sptsd,and(REMEpoch2,PreEpoch)));
Swak2=Data(Restrict(Sptsd,and(Wake2,PreEpoch)));


Ssws=Data(Restrict(Sptsd,and(SWSEpoch,PreEpoch)));
Srem=Data(Restrict(Sptsd,and(REMEpoch,PreEpoch)));
Swak=Data(Restrict(Sptsd,and(MovEpoch,PreEpoch)));

[rsws2,psws2]=corrcoef(Ssws2);
[rrem2,prem2]=corrcoef(Srem2);
[rwak2,pwak2]=corrcoef(Swak2);

[rsws,psws]=corrcoef(Ssws);
[rrem,prem]=corrcoef(Srem);
[rwak,pwak]=corrcoef(Swak);


figure('color',[1 1 1]), 
 
subplot(3,2,1), imagesc(f,f,rsws2), axis xy
subplot(3,2,3), imagesc(f,f,rrem2), axis xy
subplot(3,2,5), imagesc(f,f,rwak2), axis xy

subplot(3,2,2), imagesc(f,f,rsws), axis xy
subplot(3,2,4), imagesc(f,f,rrem), axis xy
subplot(3,2,6), imagesc(f,f,rwak), axis xy


%---------------------------------------------------------------

eval(['load(''SpectrumDataH/Spectrum',num2str(cha),'.mat'')'])
Sp2=Sp;
f2=f;
t2=t;
S2tsd=tsd(t*1E4,Sp);

eval(['load(''SpectrumDataL/Spectrum',num2str(cha),'.mat'')'])
Stsd=tsd(t*1E4,Sp);

%---------------------------------------------------------------

if EPochName=='S1'
 EPoch=SWSEpoch;
end

if EPochName=='R1'
 EPoch=REMEpoch;
end

if EPochName=='W1'
 EPoch=MovEpoch;
end

if EPochName=='S2'
 EPoch=SWSEpoch2;
end

if EPochName=='R2'
 EPoch=REMEpoch2;
end

if EPochName=='W2'
 EPoch=Wake2;
end



EPoch=and(EPoch,PreEpoch);

eStsd=Restrict(Stsd,EPoch);
eS2tsd=Restrict(S2tsd,EPoch);

eSp=Data(eStsd);

eS2tsd=Restrict(eS2tsd,eStsd);
eSp2=Data(eS2tsd);

[r,p]=corrcoef(10*log10([eSp,eSp2]));

% figure('color',[1 1 1]),
% subplot(3,1,1), imagesc(r), axis xy, colorbar
% subplot(3,1,2), imagesc(log10(p)), axis xy, colorbar
% 
% [r2,p2]=corrcoef(10*log10([eSp(:,1:median(diff(f2))/median(diff(f)):end),eSp2]));
% subplot(3,1,3), imagesc(1:200,1:200,r2), axis xy, colorbar
%  

figure('color',[1 1 1]),
subplot(2,2,1), imagesc(0:20,20:200,SmoothDec(r(1:262,263:end),[1 1])), axis xy%, colorbar
subplot(2,2,3), imagesc(0:20,0:20,r(1:262,1:262)), axis xy%, colorbar
subplot(2,2,2), imagesc(20:200,20:200,SmoothDec(r(263:end,263:end),[1 1])), axis xy%, colorbar



