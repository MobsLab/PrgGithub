% waiting for a new script :)

%% 
% see ExploreSleepScorSubstages.m
% see RunSubstages.m
% see AnalyseNREMsubstages_SpectrumML.m

%% *
load('StateEpoch.mat','SWSEpoch','REMEpoch','MovEpoch')
I=intervalSet([],[]);
%
[SleepStages,Epochs,NamesStages]=PlotPolysomnoML(I,SWSEpoch,SWSEpoch,REMEpoch,MovEpoch);
%PlotPolysomnoML(N1,N3,SWS,REM,WAKE)
%Epochs={WAKE,REM,N1,N2,N3};

% WAKE=4, REM=3, N1=2, N2=1.5, N3=1, undetermined=0
% substages
Sta=[];
for ep=1:5
    if ~isempty(Epochs{ep})
        Sta=[Sta ; [Start(Epochs{ep},'s'),zeros(length(Start(Epochs{ep})),1)+ep] ];
    end
end
if ~isempty(Sta)
    Sta=sortrows(Sta,1);
    ind=find(diff(Sta(:,2))==0);
    Sta(ind+1,:)=[];
    
    % check WAKE -> REM transition
    a=find([Sta(:,2);0]==2 & [0;Sta(:,2)]==1 );
    ep='';if ~isempty(a),ep=[ep,' Warning! t=[',sprintf(' %g',floor(Sta(a-1,1))),' ]s'];end
    disp([sprintf('%d transitions WAKE -> REM ',length(a)),ep]);
end

%
figure(Gf), subplot(2,1,1), title(pwd), ylabel('Frequency (Hz)')
xlim(Sta(a(1)-1,1)+[-500 1000])
subplot(2,1,2), ylabel('theta/delta ratio(k) and movement (rgb)')
xlabel('Time (s)'),xlim(Sta(a(1)-1,1)+[-500 1000])

sta=Start(Epochs{1},'s');
sto=Stop(Epochs{1},'s');
L=sto-sta;
ind=find(sta==Sta(a(1)-1,1));
yl=ylim; subplot(2,1,2),
line([sta(ind),sto(ind)], 0.9*yl(2)*[1 1],'Linewidth',2,'Color','b')
text(sta(ind),0.94*yl(2),sprintf('%1.0fs',L(ind)),'Color','b')

%% RunSubstages.m

load('StateEpochSubStages.mat')

% spectrum
load('StateEpoch.mat','Spectro');
Sp=Spectro{1};
t=Spectro{2};
f=Spectro{3};
SPtsd=tsd(t*1E4,Sp);

%% Spectre moyen autour fin/deb epochs
sizeWindow=40;
figure('color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.4 0.6]),

factbig=3;
LLong=60; %criteria of SWSlength (s)
YL=[];

for i=1:3
    if i==1
        sto=Stop(REMEpoch); 
        tit=sprintf('Trig on stop REMEpoch (n=%d)',length(sto));
    else
        stta=Start(SWSEpoch);stto=Stop(SWSEpoch);
        ind=find(stto-stta>LLong*1E4);
        LongSWS=intervalSet(stta(ind),stto(ind));
        bigMvt=dropShortIntervals(SLEEPuMvtEpoch,factbig*1E4);  
        
        if i==2
            sto=Start(and(LongSWS,bigMvt)); 
            tit=sprintf('Trig on big (>%ds) SWSmicroMovement start (n=%d on N=%d SWS episods>%ds)',...
                factbig,length(sto),length(ind),LLong);
        else  
            sto=Start(and(LongSWS,SLEEPuMvtEpoch-bigMvt)); 
            tit=sprintf('Trig on small (<%ds) SWSmicroMovement (n=%d on N=%d SWS episods>%ds)',...
                factbig,length(sto),length(ind),LLong);
        end
    end
    
    xl=[-sizeWindow/3,2*sizeWindow/3];
    Isto=intervalSet(sto(1)+xl(1)*1E4,sto(1)+xl(2)*1E4);
    Mat=Data(Restrict(SPtsd,Isto));
    t_sto=Range(Restrict(SPtsd,Isto),'s');
    t_sto=t_sto-min(t_sto)+xl(1);
    
    
    for s=2:length(sto)
        Isto=intervalSet(sto(s)+xl(1)*1E4,sto(s)+xl(2)*1E4);
        Mat=Mat+Data(Restrict(SPtsd,Isto));
        
        subplot(3,6,6*(i-1)+5), hold on,
        plot(f,mean(Data(Restrict(SPtsd,intervalSet(sto(s)-5*1E4,sto(s))))))
        subplot(3,6,6*(i-1)+6), hold on,
        plot(f,mean(Data(Restrict(SPtsd,intervalSet(sto(s),sto(s)+5*1E4)))))
        subplot(3,6,6*(i-1)+4), hold on,
        temp=Restrict(Mmov,intervalSet(sto(s)-1*1E4,sto(s)+3*1E4));
        plot(Range(temp,'s')-1-min(Range(temp,'s')),Data(temp))
    end
    xlim([-1 3]),if i==3, xlabel('Time (s)');end;
    line([0 0],ylim,'Color','k'); title('Movement')
    
    subplot(3,6,6*(i-1)+5),  if i==3, xlabel('Frequency (Hz)'); end
    plot(f,mean(Mat(t_sto>-5 & t_sto<=0,:))/length(sto),'r','Linewidth',2)
    title('5s before'); YL=[YL,ylim];
    subplot(3,6,6*(i-1)+6), if i==3, xlabel('Frequency (Hz)'); end
    plot(f,mean(Mat(t_sto<=5 & t_sto>0,:))/length(sto),'r','Linewidth',2)
    title('5s after'); YL=[YL,ylim];
    
    subplot(3,6,6*(i-1)+(1:3)), 
    imagesc(t_sto,f,10*log10(Mat)'), axis xy,% caxis([20 65]);
    if i==3,  xlabel(pwd); else,xlabel('Time (s)'); end
    ylabel('Frequency (Hz)'); title(tit)
    ylim([min(f),max(f)]); xlim(xl)
    hold on, line([0 0],ylim,'Color','w');
    
end

for i=1:3
    subplot(3,6,6*(i-1)+5),ylim([0,max(YL)]);
    subplot(3,6,6*(i-1)+6),ylim([0,max(YL)]);
end


%%
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244
disp('- ChannelsToAnalyse/Bulb_deep')
temp=load('ChannelsToAnalyse/Bulb_deep.mat');
disp(sprintf('   ... Loading LFP%d.mat',temp.channel))
eval(sprintf('load(''LFPData/LFP%d.mat'')',temp.channel));
lfpBO=LFP;
disp(sprintf('   ... Loading Spectrum%d.mat',temp.channel))
eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',temp.channel));
SpBO=tsd(t*1E4,Sp);

disp('- ChannelsToAnalyse/PFCx_deep')
temp=load('ChannelsToAnalyse/PFCx_deep.mat');
disp(sprintf('   ... Loading LFP%d.mat',temp.channel))
eval(sprintf('load(''LFPData/LFP%d.mat'')',temp.channel));
lfpPFCx=LFP;
disp(sprintf('   ... Loading Spectrum%d.mat',temp.channel))
eval(sprintf('load(''SpectrumDataL/Spectrum%d.mat'')',temp.channel));
SpPFCx=tsd(t*1E4,Sp);

disp('- RunSubstages.m')
[WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;

%% BULB & PFCx Spectrum PETH substages transition
%[params]=SpectrumParametersML('newlow'); 
% --- N1 ---
%Mat1=nan(length(Start(N1)),length(1:0.1:20));Mat2=Mat1;
% for s=1:length(Start(N1))
%     try [S,f,Serr]=mtspectrumc(Data(Restrict(lfpBO,subset(N1,s))),params);
%     Mat1(s,:)=10*log10(interp1(f,S,1:0.1:20))';end
%     try [S,f,Serr]=mtspectrumc(Data(Restrict(lfpPFCx,subset(N1,s))),params);
%     Mat2(s,:)=10*log10(interp1(f,S,1:0.1:20))';end
%end

FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/';
% options
opt=0; %0=order by occurance, 1=order by epochLength, 2=order by OB, 3=order by PFC, 4=order by each
nameopt={'occurance','epochLength','OB3Hz','PF3Hz','Amp3Hz'};
for opt=0:1:4
    Cl=[];
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.4 0.6]),
    for n=1:length(NamesStages)
        clear epoch temp1 temp2 temp3 ind1 ind2 ind3
        eval(['epoch=',NamesStages{n},';'])
        Mat1=nan(length(Start(epoch)),length(f));Mat2=Mat1;
        for s=1:length(Start(epoch))
            Mat1(s,:)=10*log10(mean(Data(Restrict(SpBO,subset(epoch,s))),1));
            Mat2(s,:)=10*log10(mean(Data(Restrict(SpPFCx,subset(epoch,s))),1));
        end
        temp1=Stop(epoch)-Start(epoch); [temp1,ind1]=sort(temp1);
        temp2=mean(Mat1(:,find(f-3<0.5)),2); [temp2,ind2]=sort(temp2);
        temp3=mean(Mat2(:,find(f-3<0.5)),2); [temp3,ind3]=sort(temp3);
        if opt==1
            Mat1=Mat1(ind1,:); Mat2=Mat2(ind1,:);
        elseif opt==2
            Mat1=Mat1(ind2,:); Mat2=Mat2(ind2,:);
        elseif opt==3
            Mat1=Mat1(ind3,:); Mat2=Mat2(ind3,:);
        elseif opt==4
            Mat1=Mat1(ind2,:); Mat2=Mat2(ind3,:);
        end
        
        subplot(2,5,n),imagesc(f,1:size(Mat1,1),Mat1), axis xy;
        ylabel(['# episod, orderby ',nameopt{opt+1}]);  Cl=[Cl caxis];
        title(['OB mean Spectrum for ',NamesStages{n},' episods']);
        
        subplot(2,5,5+n),imagesc(f,1:size(Mat2,1),Mat2), axis xy;
        ylabel(['# episod, orderby ',nameopt{opt+1}]);  Cl=[Cl caxis];
        title(['PFCx mean Spectrum for ',NamesStages{n},' episods']);
    end
    for i=1:10
        subplot(2,5,i), xlabel('Frequency (Hz)');%caxis([min(Cl) max(Cl)]);
    end
    %saveFigure(gcf,['SpectrumNREMStages_orderby',nameopt{opt+1},'_',date],FolderToSave)
end

%% look OB 3Hz depending on substages

Mat1=nan(0,length(f));
Mat2=Mat1;
InfoMat=[];
for n=1:length(NamesStages)
    eval(['epoch=',NamesStages{n},';'])
    
    for s=1:length(Start(epoch))
        tempMat1(s,:)=10*log10(mean(Data(Restrict(SpBO,subset(epoch,s))),1));
        tempMat2(s,:)=10*log10(mean(Data(Restrict(SpPFCx,subset(epoch,s))),1));
    end
    Mat1=[Mat1;tempMat1];
    Mat2=[Mat2;tempMat2];
    InfoMat=[InfoMat;[n*ones(length(Start(epoch)),1),Start(epoch,'s'),Stop(epoch)-Start(epoch)]];
end

% criterions
[temp,ind1]=sort(InfoMat(:,2));
InfoMat=InfoMat(ind1,:);
Mat1=Mat1(ind1,:);
Mat2=Mat2(ind1,:);

figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.4 0.6]),
for n=1:length(NamesStages)
    ind=find(InfoMat(:,1)==n);
    temp1=nan(size(Mat1,1),length(f)); temp2=temp1;
    temp1(ind,:)=Mat1(ind,:);
    temp2(ind,:)=Mat2(ind,:);
    
    subplot(2,5,n),imagesc(f,1:size(temp1,1),temp1), axis xy;
    ylabel(['# episod, orderby ',nameopt{opt+1}]);  Cl=[Cl caxis];
    title(['OB mean Spectrum for ',NamesStages{n},' episods']);
    
    subplot(2,5,5+n),imagesc(f,1:size(temp2,1),temp2), axis xy;
    ylabel(['# episod, orderby ',nameopt{opt+1}]);  Cl=[Cl caxis];
    title(['PFCx mean Spectrum for ',NamesStages{n},' episods']);
end

% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>     
%% >>>>>>>>>>>>>> AnalyseNREMsubstages_SpectrumML.m >>>>>>>>>>>>>>>>>>>>>>>
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 

AnalyseNREMsubstages_SpectrumML;



%% >>>>>>>>>>>>>>>>>> fft >>>>>>>>>>>>>>>>>>>>>>>>>>>
N = length(x);
xdft = fft(x);
xdft = xdft(1:floor(N/2)+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/N:fs/2;

subplot(311), hold on, plot(freq,(psdx),'k'), xlim([0 8])
subplot(312), hold on, plot(freq,freq.*(psdx),'k'), xlim([0 8])
subplot(313), hold on, plot(freq,10*log10(psdx),'k'), xlim([0 8])




%% BULB & PFCx LFP imagePETH
% --- N1 ---
sta=Start(N1);sta=sta(sta>12E3);
figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.3 0.4 0.6]), F=gcf;

figure, [fh, r, h, matVal] =ImagePETH(lfpBO, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,1), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)'); title('OB lfp triggered by N1 starts'); 

figure, [fh, r, h, matVal] =ImagePETH(lfpPFCx, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,6),imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('PFCx lfp triggered by N1 starts'); 

% --- N2 ---
sta=Start(N2);sta=sta(sta>12E3);
figure, [fh, r, h, matVal] =ImagePETH(lfpBO, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,2), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('OB lfp triggered by N2 starts');

figure, [fh, r, h, matVal] =ImagePETH(lfpPFCx, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,7), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('PFCx lfp triggered by N2 starts'); 

% --- N3 ---
sta=Start(N3);sta=sta(sta>12E3);
figure, [fh, r, h, matVal] =ImagePETH(lfpBO, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,3), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('OB lfp triggered by N3 starts');

figure, [fh, r, h, matVal] =ImagePETH(lfpPFCx, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,8), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('PFCx lfp triggered by N3 starts'); 

% --- REM ---
sta=Start(REM);sta=sta(sta>12E3);
figure, [fh, r, h, matVal] =ImagePETH(lfpBO, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,4), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('OB lfp triggered by REM starts'); 

figure, [fh, r, h, matVal] =ImagePETH(lfpPFCx, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,9), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('PFCx lfp triggered by REM starts'); 

% --- WAKE ---
sta=Start(WAKE);sta=sta(sta>12E3);
figure, [fh, r, h, matVal] =ImagePETH(lfpBO, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,5), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('OB lfp triggered by WAKE starts');

figure, [fh, r, h, matVal] =ImagePETH(lfpPFCx, ts(sta), -12000, 15000);close
s=sum(Data(Restrict(matVal,intervalSet(0,3E3))),1); 
dt=Data(matVal)'; [s,ind]=sort(s);dt=dt(ind,:);
figure(F),subplot(2,5,10), imagesc(Range(matVal,'s')',size(dt,1),dt), axis xy
set(gca, 'XLim', [-1.2 1.5]); xlabel('Time (s)');title('PFCx lfp triggered by WAKE starts'); 
%% 



