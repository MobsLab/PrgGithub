%FigurePresentationDehaene

cd('/media/HD-EG5/DataMMN/FigureSPresDehaene')

gene=0;


if 0
if ~gene
    
    load MatDehaeneFinal2
end
end



filename='/media/HD-EG5/DataMMN/FigureSPresDehaene';



if gene
    
        LFPnames{1}='Prefrontal Cortex, superfical layer';
        LFPnames{2}='Prefrontal Cortex, superfical layer';
        LFPnames{3}='Prefrontal Cortex, superfical layer';
        LFPnames{4}='Prefrontal Cortex, superfical layer';
        LFPnames{5}='Parietal Cortex, EEG';
        LFPnames{6}='Parietal Cortex, ECog';
        LFPnames{7}='Parietal Cortex, deep layer';
        LFPnames{8}='Parietal Cortex, deep layer';
        LFPnames{9}='Parietal Cortex, deep layer';
        LFPnames{10}='Auditory Cortex, EEG';
        LFPnames{11}='Auditory Cortex, ECog';
        LFPnames{12}='Auditory Cortex, deep layer';
        LFPnames{13}='Auditory Cortex, deep layer';
        LFPnames{14}='Auditory Cortex, superficial layer';
        LFPnames{15}='Auditory Cortex, superficial layer';


        cd('/media/HD-EG5/DataMMN/Mouse036/22052012/old')
        load LocalGlobal


        tps2=tps;
        Mlocalstd2=Mlocalstd;
        Mlocaldev2=Mlocaldev;
        MlocalstdXXXY2=MlocalstdXXXY;
        MlocaldevXXXY2=MlocaldevXXXY;
        Mglobalstd2=Mglobalstd;
        Mglobaldev2=Mglobaldev;

end

num=1;
%auditory EEG
%plotSingleLocalGlobalDetail(10, 2000, 1.5, 200, 1 ,0.01, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
plotSingleLocalGlobalDetail(10, 2000, 1.5, 1, 1 ,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
%or
%plotSingleLocalGlobalDetail(10, 5800, 1.5, 1, 1 ,0.05 ,tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
plotSingleLocalGlobalDetail(10, 5800, 1.5, 1, 1 ,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1; 

%auditory LFP
% % % plotSingleLocalGlobalDetail(15, 2500, 1.5, 500, 1 ,0.05, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
%plotSingleLocalGlobalDetail(15, 5800, 1.5, 1, 1 ,0.05, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
plotSingleLocalGlobalDetail(15, 2000, 1.5, 1, 1,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(15, 5800, 1.5, 1, 1 ,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

%prefrontal LFP
%plotSingleLocalGlobalDetail(4, 2000, 1.5, 200, 1 ,0.05, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
plotSingleLocalGlobalDetail(4, 2000, 1.5, 200, 1 ,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(4, 5800, 1.5, 200, 1 ,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;
% parietal EEG
%plotSingleLocalGlobalDetail(5, 2000, 0.8, 1, 1 ,0.05, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
plotSingleLocalGlobalDetail(5, 2000, 0.8, 1, 1,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(5, 5800, 0.8, 1, 1 ,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

% parietal LFP
plotSingleLocalGlobalDetail(8, 2000, 0.8, 1, 1 ,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(8, 5800, 0.8, 1, 1 ,0, tps2, Mlocalstd2,Mlocaldev2,MlocalstdXXXY2,MlocaldevXXXY2,Mglobalstd2,Mglobaldev2,LFPnames); 
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;







if gene


        cd('/media/HD-EG5/DataMMN/Mouse036/04062012/MMN-Mouse-36-04062012')
        load MatLocalGlobal

        tps3=tps;
        Mlocalstd3=Mlocalstd;
        Mlocaldev3=Mlocaldev;
        MlocalstdXXXX3=MlocalstdXXXX;
        MlocaldevXXXX3=MlocaldevXXXX;
        MlocalstdXXXY3=MlocalstdXXXY;
        MlocaldevXXXY3=MlocaldevXXXY;
        Mglobalstd3=Mglobalstd;
        Mglobaldev3=Mglobaldev;
end


%auditory EEG
%plotSingleLocalGlobalDetail(10, 2000, 1.5, 200, 6 ,0.01, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
plotSingleLocalGlobalDetail(10, 2000, 1.5, 1, 6 ,0, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
%or
%plotSingleLocalGlobalDetail(10, 5800, 1.5, 1, 6 ,0.05, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
plotSingleLocalGlobalDetail(10, 5800, 1.5, 1, 6 ,0, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

%auditory LFP
% % % plotSingleLocalGlobalDetail(15, 2500, 1.5, 500, 6 ,0.05, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
%plotSingleLocalGlobalDetail(15, 5800, 1.5, 1, 6 ,0.05, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
plotSingleLocalGlobalDetail(15, 2000, 1.5, 1, 6 ,0, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(15, 5800, 1.5, 1, 6 ,0, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

%prefrontal LFP
%plotSingleLocalGlobalDetail(4, 2000, 1.5, 200, 6 ,0.05, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
plotSingleLocalGlobalDetail(4, 2000, 1.5, 200, 6 ,0, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(4, 5800, 1.5, 200, 6 ,0, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

% parietal EEG
%plotSingleLocalGlobalDetail(5, 2000, 0.8, 1, 6 ,0.05, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
plotSingleLocalGlobalDetail(5, 2000, 0.8, 1, 6 ,0, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(5, 5800, 0.8, 1, 6 ,0, tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

% parietal LFP
plotSingleLocalGlobalDetail(8, 2000, 0.8, 1, 6 ,0,tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(8, 5800, 0.8, 1, 6 ,0,tps3, Mlocalstd3,Mlocaldev3,MlocalstdXXXY3,MlocaldevXXXY3,Mglobalstd3,Mglobaldev3,LFPnames); 

eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse036-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;


if gene

        LFPnames4{1}='Auditory Cortex, superfical layer';
        LFPnames4{2}='Auditory Cortex, superfical layer';
        LFPnames4{3}='Auditory Cortex, superfical layer';
        LFPnames4{4}='Auditory Cortex, superfical layer';
        LFPnames4{5}='Prefrontal Cortex, EEG';
        LFPnames4{6}='Parietal Cortex, EEG';
        LFPnames4{7}='Auditory Cortex, EEG';


        cd('/media/HD-EG5/DataMMN/Mouse039/11062012/lfp/MMN-Mouse-38-11062012')
        load MatLocalGlobal

        tps4=tps;
        Mlocalstd4=Mlocalstd;
        Mlocaldev4=Mlocaldev;
        MlocalstdXXXX4=MlocalstdXXXX;
        MlocaldevXXXX4=MlocaldevXXXX;
        MlocalstdXXXY4=MlocalstdXXXY;
        MlocaldevXXXY4=MlocaldevXXXY;
        Mglobalstd4=Mglobalstd;
        Mglobaldev4=Mglobaldev;

end

plotSingleLocalGlobalDetail(1, 2000, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(1, 5800, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(2, 2000, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(2, 5800, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(3, 2000, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(3, 5800, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(4, 2000, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(4, 5800, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(5, 2000, 0.8, 1, 6 ,0,  tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(5, 5800, 0.8, 1, 6 ,0,  tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(6, 2000, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(6, 5800, 0.8, 1, 6 ,0, tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(7, 2000, 0.8, 1, 6 ,0,  tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(7, 5800, 0.8, 1, 6 ,0,  tps4, Mlocalstd4,Mlocaldev4,MlocalstdXXXY4,MlocaldevXXXY4,Mglobalstd4,Mglobaldev4,LFPnames4);

eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

if gene

        cd('/media/HP Portable Drive/DataElectrophy/DataMMN/Mouse039/15062012/MMN-Mouse-39-15062012')

        load MatLocalGlobal


        tps5=tps;
        Mlocalstd5=Mlocalstd;
        Mlocaldev5=Mlocaldev;
        MlocalstdXXXX5=MlocalstdXXXX;
        MlocaldevXXXX5=MlocaldevXXXX;
        MlocalstdXXXY5=MlocalstdXXXY;
        MlocaldevXXXY5=MlocaldevXXXY;
        Mglobalstd5=Mglobalstd;
        Mglobaldev5=Mglobaldev;

end


plotSingleLocalGlobalDetail(1, 2000, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(1, 5800, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(2, 2000, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(2, 5800, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(3, 2000, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(3, 5800, 0.8, 1, 6 ,0,tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(4, 2000, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(4, 5800, 0.8, 1, 6 ,0,tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(5, 2000, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(5, 5800, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(6, 2000, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(6, 5800, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(7, 2000, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(7, 5800, 0.8, 1, 6 ,0, tps5, Mlocalstd5,Mlocaldev5,MlocalstdXXXY5,MlocaldevXXXY5,Mglobalstd5,Mglobaldev5,LFPnames4);

eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse039-13kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;


% 
% 
% cd('/media/HP Portable Drive/DataElectrophy/DataMMN/Mouse039/15062012/spikes/MMN-Mouse-39-15062012')
% 


%cd('/media/HD-EG5/DataMMN/Mouse035/20120524/MMN-Mouse-35-24052012')
% load MatLocalGlobal
% 
% LFPnames8{1}='Hpc LFP';
% LFPnames8{2}='Hpc LFP';
% LFPnames8{3}='Hpc LFP';
% LFPnames8{4}='Hpc LFP';
% LFPnames8{5}='Hpc LFP';
% LFPnames8{6}='Hpc LFP';
% LFPnames8{7}='Hpc LFP';
% LFPnames8{8}='Hpc LFP';
% 
% 
% tps8=tps;
% Mlocalstd8=Mlocalstd;
% Mlocaldev8=Mlocaldev;
% MlocalstdXXXX8=MlocalstdXXXX;
% MlocaldevXXXX8=MlocaldevXXXX;
% MlocalstdXXXY8=MlocalstdXXXY;
% MlocaldevXXXY8=MlocaldevXXXY;
% Mglobalstd8=Mglobalstd;
% Mglobaldev8=Mglobaldev;
% 
% 
% 
% plotSingleLocalGlobalDetail(1, 2000, 0.8, 1, 6 ,0, tps6, Mlocalstd6,Mlocaldev6,MlocalstdXXXY6,MlocaldevXXXY6,Mglobalstd6,Mglobaldev6,LFPnames6);
% %plotSingleLocalGlobalDetail(1, 5800, 0.8, 1, 6 ,0, tps6,Mlocalstd6,Mlocaldev6,MlocalstdXXXY6,MlocaldevXXXY6,Mglobalstd6,Mglobaldev6,LFPnames6);
%  
% 
% plotSingleLocalGlobalDetail(2, 2000, 0.8, 1, 6 ,0, tps6,Mlocalstd6,Mlocaldev6,MlocalstdXXXY6,MlocaldevXXXY6,Mglobalstd6,Mglobaldev6,LFPnames6);
% %plotSingleLocalGlobalDetail(2, 5800, 0.8, 1, 6 ,0, tps6,Mlocalstd6,Mlocaldev6,MlocalstdXXXY6,MlocaldevXXXY6,Mglobalstd6,Mglobaldev6,LFPnames6);
% 
% plotSingleLocalGlobalDetail(3, 2000, 0.8, 1, 6 ,0, tps6,Mlocalstd6,Mlocaldev6,MlocalstdXXXY6,MlocaldevXXXY6,Mglobalstd6,Mglobaldev6,LFPnames6);
% %plotSingleLocalGlobalDetail(3, 5800, 0.8, 1, 6 ,0,tps6,Mlocalstd6,Mlocaldev6,MlocalstdXXXY6,MlocaldevXXXY6,Mglobalstd6,Mglobaldev6,LFPnames6);
% 
% 
% plotSingleLocalGlobalDetail(4, 2000, 0.8, 1, 6 ,0, tps6,Mlocalstd6,Mlocaldev6,MlocalstdXXXY6,MlocaldevXXXY6,Mglobalstd6,Mglobaldev6,LFPnames6);
% %plotSingleLocalGlobalDetail(4, 5800, 0.8, 1, 6 ,0,tps6,Mlocalstd6,Mlocaldev6,MlocalstdXXXY6,MlocaldevXXXY6,Mglobalstd6,Mglobaldev6,LFPnames6);
% 




if gene
    
    
cd('/media/HD-EG5/DataMMN/Mouse035/20120524/MMN-Mouse-35-24052012')
load MatLocalGlobal

LFPnames8{1}='Hpc LFP';
LFPnames8{2}='Hpc LFP';
LFPnames8{3}='Hpc LFP';
LFPnames8{4}='Hpc LFP';
LFPnames8{5}='Hpc LFP';
LFPnames8{6}='Hpc LFP';
LFPnames8{7}='Hpc LFP';
LFPnames8{8}='Hpc LFP';


tps8=tps;
Mlocalstd8=Mlocalstd;
Mlocaldev8=Mlocaldev;
MlocalstdXXXX8=MlocalstdXXXX;
MlocaldevXXXX8=MlocaldevXXXX;
MlocalstdXXXY8=MlocalstdXXXY;
MlocaldevXXXY8=MlocaldevXXXY;
Mglobalstd8=Mglobalstd;
Mglobaldev8=Mglobaldev;

end

plotSingleLocalGlobalDetail(1, 2000, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(1, 5800, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(2, 2000, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(2, 5800, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(3, 2000, 0.8, 1, 6 ,0,tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(3, 5800, 0.8, 1, 6 ,0,tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(4, 2000, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(4, 5800, 0.8, 1, 6 ,0,tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(5, 2000, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(5, 5800, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(6, 2000, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(6, 5800, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(7, 2000, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(7, 5800, 0.8, 1, 6 ,0, tps8, Mlocalstd8,Mlocaldev8,MlocalstdXXXY8,MlocaldevXXXY8,Mglobalstd8,Mglobaldev8,LFPnames8);

eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse035-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;




if gene
cd('/media/HD-EG5/DataMMN/Mouse030/24112011/MMN-Mouse-30-24112011')


load MatLocalGlobal

LFPnames9{1}='Olfactory Bulb';
LFPnames9{2}='Olfactory Bulb';
LFPnames9{3}='Olfactory Bulb';
LFPnames9{4}='Hpc LFP';
LFPnames9{5}='Hpc LFP';
LFPnames9{6}='Hpc LFP';
LFPnames9{7}='Hpc LFP';
LFPnames9{8}='Auditory Cortex LFP';
LFPnames9{9}='Auditory Cortex LFP';
LFPnames9{10}='Auditory Cortex LFP';
LFPnames9{11}='Auditory Cortex LFP';
LFPnames9{12}='Thalamus LFP';
LFPnames9{13}='Thalamus LFP';
LFPnames9{14}='Olfactory Bulb';
LFPnames9{15}='Olfactory Bulb';


tps9=tps;
Mlocalstd9=Mlocalstd;
Mlocaldev9=Mlocaldev;
MlocalstdXXXX9=MlocalstdXXXX;
MlocaldevXXXX9=MlocaldevXXXX;
MlocalstdXXXY9=MlocalstdXXXY;
MlocaldevXXXY9=MlocaldevXXXY;
Mglobalstd9=Mglobalstd;
Mglobaldev9=Mglobaldev;

end 

plotSingleLocalGlobalDetail(1, 2000, 0.8, 1, 6 ,0, tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(1, 5800, 0.8, 1, 6 ,0, tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
 eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(2, 2000, 0.8, 1, 6 ,0, tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(2, 5800, 0.8, 1, 6 ,0, tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(3, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(3, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(4, 2000, 0.8, 1, 6 ,0, tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(4, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(5, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(5, 5800, 0.8, 1, 6 ,0, tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(6, 2000, 0.8, 1, 6 ,0, tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(6, 5800, 0.8, 1, 6 ,0, tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(7, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(7, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;



plotSingleLocalGlobalDetail(8, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(8, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(9, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(9, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(10, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(10, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(11, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(11, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(12, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(12, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;


plotSingleLocalGlobalDetail(13, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(13, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(14, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(14, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;

plotSingleLocalGlobalDetail(15, 2000, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(2000),''',''',filename,''')']), close, num=num+1;
plotSingleLocalGlobalDetail(15, 5800, 0.8, 1, 6 ,0,tps9, Mlocalstd9,Mlocaldev9,MlocalstdXXXY9,MlocaldevXXXY9,Mglobalstd9,Mglobaldev9,LFPnames9);
eval(['saveFigure(',num2str(gcf),',''Figure',num2str(num),'-Mouse030-10kHz-',num2str(5800),''',''',filename,''')']), close, num=num+1;




if gene
cd('/media/HD-EG5/DataMMN/FigureSPresDehaene')
save -v7.3 MatDehaeneFinal

end

