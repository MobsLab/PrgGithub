% ExtractDataFromImetronics
% Clara Nov 15
% Import the behavioral data from Imetronics

clear 
close all

%% Freezing Imetronics
%cd('G:\FEAR_DATA\FEAR_ManipBulbectomie\Data_Imetronics\EXT24-envC');
%cd('G:\FEAR_DATA\FEAR_ManipBulbectomie\Data_Imetronics\EXT24-envC');
cd('G:\FEAR_DATA\FEAR_ManipBulbectomie\Data_Imetronics\COND');
res=pwd;

MouseNb=[269:290];
for k=1:length(MouseNb)
    Mouse{k}=num2str(MouseNb(k));
end
%DATA_IMETRONICS = {'M263EXT_01.dat';'M264EXT_01.dat';'M265EXT_01.dat';'M266EXT_01.dat';'M267EXT_04.dat';'M268EXT_03.dat'};
%DATA_IMETRONICS = {'M270EXT24-envC_01.dat'};
DATA_IMETRONICS = {'M269COND_01.dat'};


%fichiers valid�s
%'M270EXT24-encC_01.dat';'M270EXT24-encC_02.dat';'M272EXT24-encC_01.dat';'M274EXT24-encC_01.dat';'M275EXT24-envC_reel_01.dat';
%'M276EXT24-envC_01.dat';'M277EXT24-envC_02.dat';'M278EXT24-envC_reel_01.dat';'M279EXT24-envC_reel_01.dat';'M280EXT24-envC_01';
%'M281EXT24-envC_02.dat';'M282EXT24-envC_01.dat';'M283EXT24-envC_03.dat';'M284EXT24-envC_01.dat';'M285EXT24-encC_reel_01.dat';
%'M286EXT24-encC_01.dat';'M287EXT24-encC_02.dat';'M288EXT24-encC_01.dat';'M289EXT24-encC_01.dat';'M290EXT24-envC_01.dat'
%'M269EXT24-envC_reel_01.dat'
%'M271COND_04.dat';'M275COND_01.dat';'M276COND_01.dat';'M277COND_01.dat';'M278COND_01.dat';'M279COND_01.dat';'M280COND_02.dat';
%'M281COND_04.dat';'M282COND_02.dat';'M283COND_01.dat'

% non-identifi�s
%'M273EXT24-encC_03.dat';'M275EXT24-envC_01.dat';'M275EXT24-envC_02.dat'
%'M280COND_04.dat'

%DATA_IMETRONICS = {'M274COND_01.dat';'M274COND_02.dat';'M275COND_01.dat'};
%'M265EXT_01.dat';'M267EXT_04.dat'};


dir_MATLAB={'G:\FEAR_DATA\FEAR_ManipBulbectomie\COND\FEAR-Mouse-269-25112015-01-COND'};
%'G:\FEAR_DATA\FEAR_ManipBulbectomie\Data_Imetronics\EXT48-envB'
%dir_MATLAB={'G:\FEAR_DATA\FEAR_ManipBulbectomie\EXT24-envC\FEAR-Mouse-269-26112015-01-EXT'};
%dir_MATLAB={'G:\FEAR_DATA\FEAR_ManipBulbectomie\EXT24-envC'};
L=length(DATA_IMETRONICS);
freezeTh=1.5;
offset=1;
figure('Position',  [12 10 1840 904])
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
    
    subplot(L,5,5*i)
    
    plot(X,Y), xlim([0 25]), ylim([0 25])
    h_movt=subplot(L,5,5*(i-1)+[2:4]);hold on
    set(gca, 'XTickLabel',[])
    
    PosLines=find(Dat(:,2)==9);
    FrData=Dat(PosLines,4); % '4' : data freeezing (cf notice)
    TpsFr=Dat(PosLines,1);
    StartFr=TpsFr(find(diff(FrData)==1)+1)*(1E-3)-offset; % +1 car d�calage d� au diff  '-1' car Imetronics ne commence � compter le freezing qu' partir d'1sec
    StopFr=TpsFr(find(diff(FrData)==-1)+1)*(1E-3);
    % if freezing goes on until the end of the file
    if length(StartFr)-length(StopFr)==1
        StopFr=[StopFr;TpsFr(end)*(1E-3)];
    end
    Ep_Im=intervalSet(StartFr,StopFr);
    Ep_Im=mergeCloseIntervals(Ep_Im,0.3);
    Ep_Im=dropShortIntervals(Ep_Im,2);
    
    
    PosLines=find(Dat(:,2)==14);
    TpsR=Dat(PosLines,1);

    %%figure, plot(T,X), hold on, plot(T,Y)
    %%figure, plot(X,Y)
    if ~isempty(StartFr)
        line([StartFr StopFr], [3 3],'Color','r', 'LineWidth',1)
        line([Start(Ep_Im) End(Ep_Im)], [3 3],'Color','r', 'LineWidth',3)
    end
    
    %moyenne
    F_Im=(End(Ep_Im)-Start(Ep_Im));
    F_Im_moy=sum(F_Im); 
    %F=length(Ep_Im);
    title([DATA_IMETRONICS{i} ' - M' dir_MATLAB{1}(end-18:end)]);
    
    cd(dir_MATLAB{1});
    load Behavior.mat
    subplot(L,5,5*(i-1)+1)
    plot(PosMat(:,2),PosMat(:,3)),
     xlim([0 25]),ylim([0 25])
    subplot(h_movt)
     plot(Range(Movtsd,'s'),Data(Movtsd),'k')
     ylim([0 50])
    Ep=thresholdIntervals(Movtsd,freezeTh,'Direction','Below');
    Ep=mergeCloseIntervals(Ep,0.3*1E4);
    Ep=dropShortIntervals(Ep,2*1E4);
    F_matlab_1=sum(End(Ep)-Start(Ep))*1E-4;

    if ~isempty(Start(Ep))
        for k=1:(length(Start(Ep))) 
            plot(Range(Restrict(Movtsd,subset(Ep,k)),'s'),Data(Restrict(Movtsd,subset(Ep,k))),'c'), hold on
        end
    end
    
% 
%     
%     
%     F_Im1=sum(End(Ep_Im1)-Start(Ep_Im1)); %� mettre en pourcentage
%     F_Im2=sum(End(Ep_Im2)-Start(Ep_Im2));
%     F_Im3=sum(End(Ep_Im3)-Start(Ep_Im3));
%     F_Im4=sum(End(Ep_Im4)-Start(Ep_Im4));

%     subplot(2,5,6)
%     bar([bilan_M{1,1}(i,1) F_Im1; bilan_M{1,1}(i,2) F_Im2; bilan_M{1,1}(i,3) F_Im3;bilan_M{1,1}(i,4) F_Im4])
%     %attention � ce que les souris soient dans le m�me ordre!! condition?
%     legend( 'matlab','Im')
%     set(gca,'XTickLabel', {'CS-', 'CS+', 'CS+', 'CS+'})
%     title ('during sound')
%     ylim([0 100])
% 
%     subplot(2,5,8)
%     bar(1, bilan_M{1,3}(i),'FaceColor',[0 0 0.3] )
%     hold on, bar(2,F_Im_moy,'FaceColor', 'y')
%     set(gca,'XTickLabel', {' '})
%     title ('full session')
%     ylim([0 500])
%     
%    
%     EpAll1_Im=and(Ep_Im,All_int1);
%     EpAll2_Im=and(Ep_Im,All_int2); 
%     EpAll3_Im=and(Ep_Im,All_int3);
%     EpAll4_Im=and(Ep_Im,All_int4);
%     EpAll5_Im=and(Ep_Im,All_int5);
% 
% 
%     FAll1_Im=sum(End(EpAll1_Im)-Start(EpAll1_Im));
%     FAll2_Im=sum(End(EpAll2_Im)-Start(EpAll2_Im));
%     FAll3_Im=sum(End(EpAll3_Im)-Start(EpAll3_Im));
%     FAll4_Im=sum(End(EpAll4_Im)-Start(EpAll4_Im));
%     FAll5_Im=sum(End(EpAll5_Im)-Start(EpAll5_Im));
% %     
%     subplot(2,5,7)
%     bar([bilan_M{1,2}(i,1) FAll1_Im; bilan_M{1,2}(i,2) FAll2_Im; bilan_M{1,2}(i,3) FAll3_Im; bilan_M{1,2}(i,4) FAll4_Im; bilan_M{1,2}(i,5) FAll5_Im])
%     title ('by period')
%     ylim([0 250])
%     xlim([0 6])
%     
%     bilan{1,1}(i,:)=bilan_M{1,2}(i,:);

cd(res);
end


% 
% save Data_Matlab_Imetronic MouseList_Im
% 
% save bilan.mat bilan %save data matlab freezing by period (no Sound, CS-,CS+,CS+,CS+)
% save bilan.mat MouseList_M
% 

    
% BadLines=find(diff(Tps)~=0);
    % Tps=Tps(BadLines);
    % X=X(BadLines);
    % Y=Y(BadLines);
    % ts=timeseries([X,Y],Tps);
    % ts2=resample(ts,[min(Tps):10:max(Tps)]);
    % X1=(ts2.Data(:,1));
    % Y1=(ts2.Data(:,2));
