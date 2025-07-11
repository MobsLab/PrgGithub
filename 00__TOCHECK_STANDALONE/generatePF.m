%generatePFs

sav=1;


FrPF=3;
sizePF=10;
nbPF=50;



Noise=1;
noise=1; % en pourcentage
FrNoise=FrPF*noise/100;

FrPF=FrPF*7;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%------------------------------------------------------------


if Noise==0;
    noise=0;
end

res=pwd;

cd /Users/karimbenchenane/Dropbox/ProjetEcoleCentraleParis/Mouse/DataSet2
load positions
positions = [posX(:,2), posY(:,2)];

eval(['cd(''',res,''')'])

%figure, plot(positions(:,1),positions(:,2))

positions(:,1)=rescale(positions(:,1),1,100);
positions(:,2)=rescale(positions(:,2),1,100);


X=tsd(posX(:,1)*1E4,positions(:,1));
Y=tsd(posX(:,1)*1E4,positions(:,2));

periodData=median(diff(Range(X)));
periodDataS=median(diff(Range(X,'s')));

cX=1:100/floor(sqrt(nbPF)):100;
cY=1:100/floor(sqrt(nbPF)):100;
a=1;
for i=1:length(cX)
for j=1:length(cX)
C(a,:)=[cX(i) cY(j)];
a=a+1;
end
end

nbPF=a-1;

try
    b;
    b=length(S)+1;
catch
    
b=1;
end

for i=b:nbPF

    try
        
        dis=tsd(Range(X),sqrt((Data(X)-C(i,1)).^2+(Data(Y)-C(i,2)).^2));
        EpochPF=thresholdIntervals(dis,sizePF/3,'Direction','Below');
        EpochPF=mergeCloseIntervals(EpochPF,500);
        EpochPF=dropShortIntervals(EpochPF,1000);

        timePF=Restrict(X,EpochPF);
        tpsPF=length(Range(timePF))*periodData;
        tpsPFS=length(Range(timePF))*periodDataS;    

        T=poissonKB(FrPF,tpsPFS);    
        Ts=ts(T'*1E4);
        vectps=[1:length(Range(timePF))]*periodData;

        Ts=Restrict(ts(vectps),Ts,'align','closest');
        rr=Range(Ts);
        id=find(ismember(vectps,rr));
        rg=Range(timePF);
        
        
         try
        
        EpochPF1a=thresholdIntervals(dis,sizePF/3,'Direction','Above');
        EpochPF1b=thresholdIntervals(dis,2*sizePF/3,'Direction','Below');
        EpochPF1=intersect(EpochPF1a,EpochPF1b);
        EpochPF1=mergeCloseIntervals(EpochPF1,500);
        EpochPF1=dropShortIntervals(EpochPF1,1000);

        timePF1=Restrict(X,EpochPF1);
        tpsPF1=length(Range(timePF1))*periodData;
        tpsPFS1=length(Range(timePF1))*periodDataS;    

        T1=poissonKB(FrPF/3,tpsPFS1);    
        Ts1=ts(T1'*1E4);
        vectps1=[1:length(Range(timePF1))]*periodData;

        Ts1=Restrict(ts(vectps1),Ts1,'align','closest');
        rr1=Range(Ts1);
        id1=find(ismember(vectps1,rr1));
        rg1=Range(timePF1);
        
         end
        
        try
        
        
            
        EpochPF2a=thresholdIntervals(dis,2*sizePF/3,'Direction','Above');
        EpochPF2b=thresholdIntervals(dis,sizePF,'Direction','Below');
        EpochPF2=intersect(EpochPF2a,EpochPF2b);
        EpochPF2=mergeCloseIntervals(EpochPF2,500);
        EpochPF2=dropShortIntervals(EpochPF2,1000);

        timePF2=Restrict(X,EpochPF2);
        tpsPF2=length(Range(timePF2))*periodData;
        tpsPFS2=length(Range(timePF2))*periodDataS;    

        T2=poissonKB(FrPF/10,tpsPFS2);    
        Ts2=ts(T2'*1E4);
        vectps2=[1:length(Range(timePF2))]*periodData;

        Ts2=Restrict(ts(vectps2),Ts2,'align','closest');
        rr2=Range(Ts2);
        id2=find(ismember(vectps2,rr2));
        rg2=Range(timePF2);
        
        
        end
        
        if Noise==1
        rgt=Range(X,'s');
        Tnoise=poissonKB(FrNoise,rgt(end)); 
        rgNoise=Tnoise*1E4;
        rgNoise=rgNoise';
        else
            Tnoise=[];
            rgNoise=[];
        end
        
        
        
        rgf=tsd(sort(unique(rg(id))),sort(unique(rg(id))));

        
%        keyboard
       try
        rgf=tsd(sort(unique([rg(id);rgNoise])),sort(unique([rg(id);rgNoise])));
        end
        
        try
        rgf=tsd(sort(unique([rg(id);rg1(id1);rgNoise])),sort(unique([rg(id);rg1(id1);rgNoise])));
        end
        
        try
        rgf=tsd(sort(unique([rg(id);rg2(id2);rgNoise])),sort(unique([rg(id);rg2(id2);rgNoise])));
        end
        
       
        try
        rgf=tsd(sort(unique([rg(id);rg1(id1);rg2(id2);rgNoise])),sort(unique([rg(id);rg1(id1);rg2(id2);rgNoise])));
        end
        
        S{b}=rgf;
        if length(S{b})>10
        b=b+1;
        end
        
    end
    
end


S=tsdArray(S);

for i=1:length(S)
spikes{i}=Range(S{i},'s');
end

eval(['cd(''',res,''')'])
%cd /Users/karimbenchenane/Dropbox/ProjetEcoleCentraleParis/Artificial

FrPF=FrPF/7;

if sav

save info FrPF sizePF nbPF Noise noise

save spikes spikes 

posX=[Range(X,'s') Data(X)];
posY=[Range(X,'s') Data(Y)];

save positions positions posX posY

save DataTsd S X Y

end


p=4;
figure('color',[1 1 1]), hold on
plot(Data(X), Data(Y),'color',[0.7 0.7 0.7])
z=0;
    while z<length(S)
try

z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'g.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'b.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'k.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'y.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'r.')


end

    end


