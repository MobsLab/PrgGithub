% CompBulb


try 
cd /media/GeorgeBackUp/DataDisk2/DataBULB/Mouse047/20120921/BULB-Mouse-47-21092012
catch
cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/DatainVivo/doKO/Mouse047/20120921
end


load LFPData
load behavResources

Epoch1=intervalSet(tpsEvt{2}*1E4,tpsEvt{3}*1E4);
listLFPOK1=[[1:5],7,10,11,12,13,14,[16:24]];

LFP1=Restrict(LFP(listLFPOK1),Epoch1);


for i=1:6
Co1{i}=[0 0 0]; % Bulb
end

for i=7:9
Co1{i}=[0.6 0.6 0.6];  % EEG
end

for i=10:11
Co1{i}=[0.6 0.6 0.6];  % Cx Par
end

for i=12:14
Co1{i}=[0 0.5 0];   % Th Aud
end

for i=15:17
Co1{i}=[1 0 0];   % Cx Aud
end

for i=18:20
Co1{i}=[0 0 1];   % Hpc (???)
end



fac=0.5;
figure('color',[1 1 1]), hold on
for i=1:length(LFP1)
    plot(Range(LFP1{i},'s'),fac*Data(LFP1{i})/1000+fac*i+fac*2.5,'color',Co1{i})
end
a=Start(Epoch1,'s');
a=a+3;xlim([a a+3])
title('doKO')


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


try
    
cd /media/GeorgeBackUp/DataDisk2/DataBULB/Mouse030/22112011/MMN-Mouse-30-22112011

load LFPData
load behavResources

Epoch2=intervalSet(tpsEvt{13}*1E4,tpsEvt{14}*1E4);
Epoch2b=intervalSet(tpsEvt{13}*1E4,tpsEvt{13}*1E4+200*1E4);

listLFPOK2=[9,10,11,22,23,12,13,14,15,20,21,16,17,18,19]+1;

for i=1:5
Co2{i}=[0 0 0]; % Bulb
end

for i=6:9
Co2{i}=[0 0 1];  % Hpc (???)
end

for i=10:11
Co2{i}=[0 0.5 0]; % Th Aud
end

for i=12:15
Co2{i}=[1 0 0]; % Cx Aud
end


LFP2=Restrict(LFP(listLFPOK2),Epoch2);

fac=0.5;
figure('color',[1 1 1]), hold on
for i=1:length(LFP2)
	plot(Range(LFP2{i},'s'),fac*Data(LFP2{i})/1000+fac*i+fac*2.5,'color',Co2{i})
end
b=Start(Epoch2,'s');
b=b+3;xlim([b b+3])
title('wt')


end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

try
    cd /Users/karimbenchenane/Documents/Data/DataEnCours/Lisa/DatainVivo/wt/Mouse020/20110917/MMN-Mouse-20-17092011
catch
    cd /media/GeorgeBackUp/DataDisk2/DataBULB/Mouse020/20110917/MMN-Mouse-20-17092011
end


load LFPData
load behavResources tpsdeb tpsfin

Epoch3=intervalSet(tpsdeb{2}*1E4,tpsfin{3}*1E4);
Epoch3b=intervalSet(tpsdeb{2}*1E4,(tpsdeb{3}+80)*1E4);

LFP3=Restrict(LFP,Epoch3);

% listLFPOK3=[2,1,3:9];
try
listLFPOK3=[9,8,10:15];
listLFPOK3=listLFPOK3(end:-1:1);

LFP3=Restrict(LFP3(listLFPOK3),Epoch3);

catch
   listLFPOK3=[2,1,3:8];

listLFPOK3=listLFPOK3(end:-1:1);

LFP3=Restrict(LFP3(listLFPOK3),Epoch3); 
    
end

for i=1:3
Co3{i}=[0 0 0]; % Bulb
end

for i=4:5
Co3{i}=[1 0 0];  % Cx Aud
end

for i=6:8
Co3{i}=[0 0 1]; % Hpc
end



fac=1;
figure('color',[1 1 1]), hold on
for i=1:length(LFP3)
	plot(Range(LFP3{i},'s'),fac*Data(LFP3{i})/1000+fac*i+fac*2.5,'color',Co3{i})
end
c=Start(Epoch3,'s');
c=c+3;xlim([c c+3])
title('wt2')



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

try
    

cd /media/GeorgeBackUp/DataDisk2/DataBULB/Mouse036/data01


load LFPData
load behavResources tpsdeb tpsfin

rg=Range(LFP{1});
Epoch=intervalSet(rg(1),rg(end));

Epoch4b=intervalSet(380,724);


LFP4=Restrict(LFP,Epoch4);

% listLFPOK3=[2,1,3:9];
try
listLFPOK3=[9,8,10:15];
listLFPOK3=listLFPOK3(end:-1:1);

LFP3=Restrict(LFP3(listLFPOK3),Epoch3);

catch
   listLFPOK3=[2,1,3:8];

listLFPOK3=listLFPOK3(end:-1:1);

LFP3=Restrict(LFP3(listLFPOK3),Epoch3); 
    
end

for i=1:3
Co3{i}=[0 0 0]; % Bulb
end

for i=4:5
Co3{i}=[1 0 0];  % Cx Aud
end

for i=6:8
Co3{i}=[0 0 1]; % Hpc
end



fac=1;
figure('color',[1 1 1]), hold on
for i=1:length(LFP3)
	plot(Range(LFP3{i},'s'),fac*Data(LFP3{i})/1000+fac*i+fac*2.5,'color',Co3{i})
end
c=Start(Epoch3,'s');
c=c+3;xlim([c c+3])
title('wt3')



end





%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------



movingwin = [2, 0.05];
params.tapers=[10,19];

params.tapers=[3,5];


params.err = [2, 0.95];
params.trialave = 0;
params.Fs =1250;

Fh=300;
params.fpass = [0 Fh];
params.pad=2;

smo=500;


%--------------------------------------------------------------------------


Epoch1b=intervalSet(1000*1E4,1200*1E4);

k=1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP1{4},Epoch1b)),Data(Restrict(LFP1{3},Epoch1b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('doKO: 4 (bulb) vs 3 (bulb)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')

k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP1{4},Epoch1b)),Data(Restrict(LFP1{13},Epoch1b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('doKO: 4 (bulb) vs 13 (Th Aud)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')

k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP1{4},Epoch1b)),Data(Restrict(LFP1{19},Epoch1b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('doKO: 4 (bulb) vs 19 (Cx Aud)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')

k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP1{4},Epoch1b)),Data(Restrict(LFP1{16},Epoch1b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('doKO: 4 (bulb) vs 16 (Hpc)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')



k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP1{4},Epoch1b)),Data(Restrict(LFP1{11},Epoch1b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('doKO: 4 (bulb) vs 11 (Cx Par)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')



%--------------------------------------------------------------------------

try
    


k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP2{5},Epoch2b)),Data(Restrict(LFP2{1},Epoch2b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('wt: 5 (bulb) vs 1 (bulb)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')

k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP2{5},Epoch2b)),Data(Restrict(LFP2{11},Epoch2b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('wt: 5 (bulb) vs 11 (Th Aud)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')

k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP2{5},Epoch2b)),Data(Restrict(LFP2{13},Epoch2b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('wt: 5 (bulb) vs 13 (Cx Aud)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')

k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP2{5},Epoch2b)),Data(Restrict(LFP2{8},Epoch2b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('wt: 5 (bulb) vs 8 (Hpc)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')


end

%--------------------------------------------------------------------------


k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP3{8},Epoch3b)),Data(Restrict(LFP3{6},Epoch3b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('wt2: 8 (bulb) vs 3 (bulb)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')

k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP3{8},Epoch3b)),Data(Restrict(LFP3{4},Epoch3b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('wt2: 8 (bulb) vs 4 (Cx Aud)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')

k=k+1;
[C{k},phi{k},S12{k},S1{k},S2{k},f{k},confC{k},phistd{k}]=coherencyc(Data(Restrict(LFP3{8},Epoch3b)),Data(Restrict(LFP3{1},Epoch3b)),params);
figure('color',[1 1 1]), 
subplot(2,1,1), hold on
plot(f{k},smooth(10*log10(S1{k}),smo))
plot(f{k},smooth(10*log10(S2{k}),smo),'r'), title('wt2: 8 (bulb) vs 1 (Hpc)')
subplot(2,1,2),hold on, plot(f{k},smooth(C{k},smo),'k')
line([0 300],[confC{k} confC{k}],'color','r')


