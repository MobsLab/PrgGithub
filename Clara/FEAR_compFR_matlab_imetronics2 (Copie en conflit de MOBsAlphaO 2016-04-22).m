
%% Freezing Matlab
clear; 
close all

% Define groups for CS+ CS-
CSplu_bip_GpNb=[270:274, 285:290];
for k=1:length(CSplu_bip_GpNb)
    CSplu_bip_Gp{k}=num2str(CSplu_bip_GpNb(k));
end
CSplu_bip_Gp=CSplu_bip_Gp';

CSplu_WN_GpNb=[280:284,275:279,269];
for k=1:length(CSplu_WN_GpNb)
    CSplu_WN_Gp{k}=num2str(CSplu_WN_GpNb(k));
end
CSplu_WN_Gp=CSplu_WN_Gp';
% Define SHAM/OBX groups

obxNb=[269:279];
for k=1:length(obxNb)
    obx{k}=num2str(obxNb(k));
end
obx=obx';
shamNb=[280:290];
for k=1:length(shamNb)
    sham{k}=num2str(shamNb(k));
end
sham=sham';

env = 'C';

res=pwd;
MouseList = {};
freezeTh=1.5;
offset=1;

Folder='G:\FEAR_DATA\FEAR_ManipBulbectomie\EXT24-envC';


%% Freezing MATLAB
list=dir(Folder);
a=1;
for i=1:length(list)
     if list(i).isdir==1&list(i).name(1)~='.'&list(i).name(1:4)=='FEAR' % if the folder is indeed a mouse name folder
        cd([Folder '\' list((i)).name])
        load Behavior.mat
%         csp=StimInfo(StimInfo(:,2)==7,1); % times of CS+
%         csm=StimInfo(StimInfo(:,2)==5,1); % times of CS-
    
        Mousename=list(i).name;
        Mousename = [Mousename(12:14)];
        MouseList_M{a}=Mousename;
        %MouseListC{a}=['M' Mousename(6:end)];
        if sum(strcmp(sham,Mousename))==1
            group='SHAM';
        elseif sum(strcmp(obx,Mousename))==1
            group='OBX';
        end

        hfig{a}=figure('Position',[680 333 1187 645]);
        subplot(2,4,1),plot(PosMat(:,2),PosMat(:,3)) 
        title(['M ' Mousename ' - ' group])
        subplot(2,5,2:4),plot(Range(Movtsd,'s'),Data(Movtsd),'k'), hold on
        ylim([0 60]),
        Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
        Ep=mergeCloseIntervals(Ep,0.3*1E4);
        Ep=dropShortIntervals(Ep,2*1E4);
        F_matlab_1=sum(End(Ep)-Start(Ep))*1E-4;
        
        if ~isempty(Start(Ep))
            for k=1:(length(Start(Ep))) 
                plot(Range(Restrict(Movtsd,subset(Ep,k)),'s'),Data(Restrict(Movtsd,subset(Ep,k))),'c'), hold on
            end
        end
       
        % récupérer les temps des sons       
        DiffTimes=diff(TTL(:,1));
        ind=DiffTimes>2;
        times=TTL(:,1);
        event=TTL(:,2);
        CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque série de son
        CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque série de son (CS+ ou CS-)
        
        %définir CS+ et CS- selon les groupes
        if sum(strcmp(Mousename,CSplu_bip_Gp))==1
            CSplu=4; %bip
            CSmin=3; %White Noise
        elseif sum(strcmp(Mousename,CSplu_WN_Gp))==1
            CSplu=3;
            CSmin=4;
        end
        
        %plotter CS+ et CS-
        line([CStimes(CSevent==CSmin) CStimes(CSevent==CSmin)+30], [0,0], 'Color', [0 1 0.5], 'LineWidth',2) %CS-
        line([CStimes(CSevent==CSplu) CStimes(CSevent==CSplu)+30], [0,0], 'Color', [1 0.5 0], 'LineWidth',2) %CS+
        CSinterval=intervalSet(CStimes,CStimes+30);

        F_matlab=sum(End(Ep)-Start(Ep))*1E-4;
        %title([sprintf('%.0f',F_matlab) ' sec'])
        bilan_M{2,1}(a,:) = Mousename;
        bilan_M{1,3}(a,:) = F_matlab;

    % plot histogram of movements over the whole session
         subplot(2,5,10)
        [Y,X]=hist(Data(Movtsd),80); 
        [Y2,X2]=hist(SmoothDec(Data(Movtsd),2),80); 
        plot(X,Y/sum(Y),'k','linewidth',1.5), hold on
        plot(X2,Y2/sum(Y2),'b','linewidth',1.5),
        legend ('raw','smo2')
        plot([freezeTh freezeTh],[0 0.4], 'Color', [0.7 0.7 0.7]) 
        ylim([0 0.3])
        xlim([0 20])
        title('Hist of Mvmt')

    %convertir en secondes    
    Ep_sec=intervalSet(Start(Ep)*1E-4,End(Ep)*1E-4);
    
    %scinder en 4 blocs DURING SOUND ONLY
    Ep1=and(Ep_sec, subset(CSinterval, 1:4));
    Ep2=and(Ep_sec, subset(CSinterval, 5:8));
    Ep3=and(Ep_sec, subset(CSinterval, 9:12));
    Ep4=and(Ep_sec, subset(CSinterval, 13:16));
    
    F1=sum(End(Ep1)-Start(Ep1));
    F2=sum(End(Ep2)-Start(Ep2));
    F3=sum(End(Ep3)-Start(Ep3));
    F4=sum(End(Ep4)-Start(Ep4));
    
    blocsFr_M=[F1,F2,F3,F4];
    bilan_M{1,1}(a,:)=blocsFr_M;
    
     % blocs all data SOUND + NO SOUND
    All_int1=intervalSet(0,CStimes(1));
    All_int2=intervalSet(CStimes(1),CStimes(5));
    All_int3=intervalSet(CStimes(5),CStimes(9));
    All_int4=intervalSet(CStimes(9),CStimes(13));
    All_int5=intervalSet(CStimes(13),CStimes(16)+30);
    
    EpAll1=and(Ep_sec,All_int1);
    EpAll2=and(Ep_sec,All_int2); 
    EpAll3=and(Ep_sec,All_int3);
    EpAll4=and(Ep_sec,All_int4);
    EpAll5=and(Ep_sec,All_int5);


    FAll1=sum(End(EpAll1)-Start(EpAll1));
    FAll2=sum(End(EpAll2)-Start(EpAll2));
    FAll3=sum(End(EpAll3)-Start(EpAll3));
    FAll4=sum(End(EpAll4)-Start(EpAll4));
    FAll5=sum(End(EpAll5)-Start(EpAll5));
    
    FAll_M=[FAll1,FAll2,FAll3,FAll4,FAll5];
    bilan_M{1,2}(a,:)=FAll_M;
    
     a=a+1; %incrément du nombre de souris
     end
end
cd(res)
save Data_Fear_Test_Imetronics.mat MouseList_M
save Data_Fear_Test_Imetronics.mat env


%% Freezing Imetronics
cd('G:\FEAR_DATA\FEAR_ManipBulbectomie\Data_Imetronics\EXT24-envC');
FolderIM=('G:\FEAR_DATA\FEAR_ManipBulbectomie\Data_Imetronics\EXT24-envC');
%cd('D:\DATA ACQUISITION\Data from imetronics\EXT');
%DATA_IMETRONICS = {'M263EXT_01.dat';'M264EXT_01.dat';'M265EXT_01.dat';'M266EXT_01.dat';'M267EXT_04.dat';'M268EXT_03.dat'};
%DATA_IMETRONICS = {'M263EXT_01.dat';'M265EXT_01.dat';'M267EXT_04.dat'};


listIM=dir(FolderIM);
a_im=1;
%DATA_IMETRONICS=[];
for i=1:length(listIM)
     if listIM(i).name(1)~='.'&listIM(i).name(1)=='M' % if the folder is indeed a mouse name folder
     DATA_IMETRONICS{a_im,1}=[listIM(i).name];
     a_im=a_im+1;
     end
end
for i=1:length(DATA_IMETRONICS)
    %Dat=importdata('D:\DATA ACQUISITION\Data from imetronics\HAB\M263HABenvtest_06.dat');
    MousenameIm=[DATA_IMETRONICS{i}(2:4)];
    Dat=importdata(DATA_IMETRONICS{i});
    Dat=Dat.data;
    PosLines=find(Dat(:,2)==9 & Dat(:,1)>0); % lines with 9 in 2nd column are related to changes in position
    Tps=Dat(PosLines,1);
    X=Dat(PosLines,10);
    Y=Dat(PosLines,11);
    
    T=Dat(PosLines,8);
    W=Dat(PosLines,9);
    MouseList_Im{i}=MousenameIm;
    %MouseListIm{i,2}=Tps(end);
    
    figure(hfig{i})
    subplot(2,5,5)
    plot(X,Y), xlim([0 30]), ylim([0 30])
    subplot(2,5,2:4),hold on
    
    PosLines=find(Dat(:,2)==9);
    FrData=Dat(PosLines,4); % '4' : data freeezing (cf notice)
    TpsFr=Dat(PosLines,1);
    StartFr=TpsFr(find(diff(FrData)==1)+1)*(1E-3)-offset; % +1 car décalage dû au diff  '-1' car Imetronics ne commence à compter le freezing qu' partir d'1sec
    StopFr=TpsFr(find(diff(FrData)==-1)+1)*(1E-3);
    % if freezing goes on until the end of the file
    if length(StartFr)-length(StopFr)==1 && StartFr(end)>StopFr(end)
        StopFr=[StopFr;TpsFr(end)*(1E-3)];
    elseif length(StartFr)-length(StopFr)==1 && StartFr(end)-StopFr(end)==0
        StartFr(end)=[];
    elseif length(StartFr)-length(StopFr)~=0
        keyboard
    end
    Ep_Im=intervalSet(StartFr,StopFr);
    Ep_Im=mergeCloseIntervals(Ep_Im,0.3);
    Ep_Im=dropShortIntervals(Ep_Im,2);
    
    
    PosLines=find(Dat(:,2)==14);
    TpsR=Dat(PosLines,1);

    %%figure, plot(T,X), hold on, plot(T,Y)
    %%figure, plot(X,Y)
    line([StartFr StopFr], [3 3],'Color','r', 'LineWidth',1)
    line([Start(Ep_Im) End(Ep_Im)], [3 3],'Color','r', 'LineWidth',3)
    
    %moyenne
    F_Im=(End(Ep_Im)-Start(Ep_Im));
    F_Im_moy=sum(F_Im); 
    %F=length(Ep_Im);
    %title(sprintf('%.0f',F_Im_moy));

    
    
    %diviser chaque session en 4 blocs
        %blocs Im during sounds
    Ep_Im1=and(Ep_Im, subset(CSinterval, 1:4)); 
    Ep_Im2=and(Ep_Im, subset(CSinterval, 5:8));
    Ep_Im3=and(Ep_Im, subset(CSinterval, 9:12));
    Ep_Im4=and(Ep_Im, subset(CSinterval, 13:16));
    
    
    F_Im1=sum(End(Ep_Im1)-Start(Ep_Im1)); %à mettre en pourcentage
    F_Im2=sum(End(Ep_Im2)-Start(Ep_Im2));
    F_Im3=sum(End(Ep_Im3)-Start(Ep_Im3));
    F_Im4=sum(End(Ep_Im4)-Start(Ep_Im4));

    subplot(2,5,6)
    bar([bilan_M{1,1}(i,1) F_Im1; bilan_M{1,1}(i,2) F_Im2; bilan_M{1,1}(i,3) F_Im3;bilan_M{1,1}(i,4) F_Im4])
    %attention à ce que les souris soient dans le même ordre!! condition?
    legend( 'matlab','Im')
    set(gca,'XTickLabel', {'CS-', 'CS+', 'CS+', 'CS+'})
    title ('during sound')
    ylim([0 100])

    subplot(2,5,8)
    bar(1, bilan_M{1,3}(i),'FaceColor',[0 0 0.3] )
    hold on, bar(2,F_Im_moy,'FaceColor', 'y')
    set(gca,'XTickLabel', {' '})
    title ('full session')
    ylim([0 500])
    
      % blocs all data SOUND + NO SOUND
    All_int1=intervalSet(0,CStimes(1));
    All_int2=intervalSet(CStimes(1),CStimes(5));
    All_int3=intervalSet(CStimes(5),CStimes(9));
    All_int4=intervalSet(CStimes(9),CStimes(13));
    All_int5=intervalSet(CStimes(13),CStimes(17));
    
    EpAll1_Im=and(Ep_Im,All_int1);
    EpAll2_Im=and(Ep_Im,All_int2); 
    EpAll3_Im=and(Ep_Im,All_int3);
    EpAll4_Im=and(Ep_Im,All_int4);
    EpAll5_Im=and(Ep_Im,All_int5);


    FAll1_Im=sum(End(EpAll1_Im)-Start(EpAll1_Im));
    FAll2_Im=sum(End(EpAll2_Im)-Start(EpAll2_Im));
    FAll3_Im=sum(End(EpAll3_Im)-Start(EpAll3_Im));
    FAll4_Im=sum(End(EpAll4_Im)-Start(EpAll4_Im));
    FAll5_Im=sum(End(EpAll5_Im)-Start(EpAll5_Im));
    
    subplot(2,5,7)
    bar([bilan_M{1,2}(i,1) FAll1_Im; bilan_M{1,2}(i,2) FAll2_Im; bilan_M{1,2}(i,3) FAll3_Im; bilan_M{1,2}(i,4) FAll4_Im; bilan_M{1,2}(i,5) FAll5_Im])
    title ('by period')
    ylim([0 250])
    xlim([0 6])
    
    bilan{1,1}(i,:)=bilan_M{1,2}(i,:);
    
    saveas(gcf, ['G:\FEAR_DATA\FEAR_ManipBulbectomie\Data_Imetronics\IndivFigures\' MousenameIm '.fig'])
    saveas(gcf, ['G:\FEAR_DATA\FEAR_ManipBulbectomie\Data_Imetronics\IndivFigures\' MousenameIm '.png'])
    
end

save Data_Matlab_Imetronic MouseList_Im

save bilan.mat bilan %save data matlab freezing by period (no Sound, CS-,CS+,CS+,CS+)
save bilan.mat MouseList_M


    
% BadLines=find(diff(Tps)~=0);
    % Tps=Tps(BadLines);
    % X=X(BadLines);
    % Y=Y(BadLines);
    % ts=timeseries([X,Y],Tps);
    % ts2=resample(ts,[min(Tps):10:max(Tps)]);
    % X1=(ts2.Data(:,1));
    % Y1=(ts2.Data(:,2));
