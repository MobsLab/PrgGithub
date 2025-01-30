


savFig=0;

load LFPData
load SpikeData
load behavResources
load Waveforms

%-------------------------------------------------------------------------

plotAllWaveforms=1;

try 
    load Widebandstim;
    data;
catch
    SetCurrentSession
    channel=input('Which channel?: ');
    [data,indices] = GetWidebandData(channel);
    save Widebandstim -v7.3 data
end

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------


%Epoch1=intervalSet(0,1966*1E4); % Explo (spike detection)
%Epoch2=intervalSet(3374*1E4,4200*1E4); % sleep (spike detection)
%Epoch3=intervalSet(4200*1E4,5700*1E4); % ICSS sleep


Epoch1=intersect(ExploEpoch,TrackingEpoch);
Epoch2=SleepEpoch;
Epoch3=intervalSet(tpsdeb{8}*1E4,tpsfin{13}*1E4);

%-------------------------------------------------------------------------

stim1=Restrict(stim,Epoch1); 
stim2=Restrict(stim,Epoch2);
stim3=Restrict(stim,Epoch3);

s2=Range(stim2);
s2b = BURSTINFO(s2/1E4,0.8);
stim2=ts(s2b.t_start*1E4);

s3=Range(stim3);
s3b = burstinfo(s3/1E4,0.8);
stim3=ts(s3b.t_start*1E4);

%-------------------------------------------------------------------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------




X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
S1=Restrict(S,Epoch1);

Wide=tsd(data(:,1)*1E4,data(:,2));
clear data
Wide1=Restrict(Wide,Epoch1);
Wide2=Restrict(Wide,Epoch2);
Wide3=Restrict(Wide,Epoch3);


stim1=Restrict(stim,Epoch1); 
stim2=Restrict(stim,Epoch2);
stim3=Restrict(stim,Epoch3);


titl{1}='Explo (spike detection)';
titl{2}='sleep (spike detection)';
titl{3}='ICSS sleep';

figure, [fh, rasterAx, histAx, matVal1] = ImagePETH(Wide1, stim1, -20, +20,'BinSize',1);
Title(titl{1})

figure, [fh, rasterAx, histAx, matVal2] = ImagePETH(Wide2, stim2, -20, +20,'BinSize',1);
Title(titl{2})

figure, [fh, rasterAx, histAx, matVal3] = ImagePETH(Wide3, stim3, -20, +20,'BinSize',1);
Title(titl{3})

for j=1:2
    if j==1
        M=Data(matVal1)';
        stimM=stim1;
    elseif j==2
        M=Data(matVal2)';
        stimM=stim2;
    elseif j==3
        M=Data(matVal3)';
        stimM=stim3;
    end
    
    le=size(M,1);
    si=size(M,2);
    M2=[zeros(le,32)];
    for i=1:le
            [ME,id]=min(M(i,20:60));
            M2(i,1:32)=M(i,id+19-13:id+19+18);
    end
    [ME,id2]=sort(M2(:,15));
    M3=M2(id2(1:le-floor(le/5)),:);
    figure('color',[1 1 1]), imagesc(M3), caxis([-1E4 1E4])
    Title(titl{j})
    
    figure, RasterPETH(S{5}, stimM, -800, +800,'BinSize',1);
    Title(titl{j})
    
  
 
if plotAllWaveforms==1
    for n=1:6
        figure('color',[1 1 1]), hold on
        plot(mean(M3),'r','linewidth',2)
        plot(std(M3)+mean(M3),'r')
        plot(-std(M3)+mean(M3),'r')
        plot(mean(squeeze(W{n}(:,1,:))),'k','linewidth',2)
        plot(mean(squeeze(W{n}(:,1,:)))+std(squeeze(W{n}(:,1,:))),'k')
        plot(mean(squeeze(W{n}(:,1,:)))-std(squeeze(W{n}(:,1,:))),'k')
        Title([titl{j},'  ',cellnames{n}])
    end
    
else
    
      n=6;
figure('color',[1 1 1]), hold on
plot(mean(M3),'r','linewidth',2)
plot(std(M3)+mean(M3),'r')
plot(-std(M3)+mean(M3),'r')
plot(mean(squeeze(W{n}(:,1,:))),'k','linewidth',2)
plot(mean(squeeze(W{n}(:,1,:)))+std(squeeze(W{n}(:,1,:))),'k')
plot(mean(squeeze(W{n}(:,1,:)))-std(squeeze(W{n}(:,1,:))),'k')
Title(titl{j})
end   


    
end


%--------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------

%Epoch2good=intervalSet(4120*1E4,4200*1E4); % sleep (spike detection)
%stim2=Restrict(stim,Epoch2good);

savFig=0;
a=1;
for k=1:length(S)
    [C,B] = CrossCorr(Range(stim1), Range(stim1), 1, 800); C(B==0)=0;
    figure('color',[1 1 1]), [fh, rasterAx, histAx,dArea1] = RasterPETH(S{k}, stim1, -4000, +4000,'BinSize',30);
    title([cellnames{k},' ',titl{1}])
    num1=gcf;
    figure('color',[1 1 1]), 
    hold on, plotyy([-400:3:400],dArea1,B,C*3)
    area([-400:3:400],dArea1,'FaceColor','k')
    title([cellnames{k},' ',titl{1}])
    xlim([-400 400])
    num2=gcf;
    set(num2,'position',[100 500 1000 700])

    if savFig
%     eval(['saveFigure(num1,''figureICSS-Mouse-17-22062011-',num2str(a),''',''/media/DISK_1/Dropbox/MasterMarie/Figures'')'])
%     a=a+1;
    eval(['saveFigure(num2,''figureICSS-Mouse-17-22062011-',num2str(a),''',''/media/DISK_1/Dropbox/MasterMarie/Figures'')'])
    a=a+1;
    end
    close
    close


    [C,B] = CrossCorr(Range(stim2), Range(stim2), 1,800); C(B==0)=0;
    figure('color',[1 1 1]), [fh, rasterAx, histAx,dArea2] = RasterPETH(S{k}, stim2, -4000, +4000,'BinSize',30);
    title([cellnames{k},' ',titl{2}])
    num1=gcf;
    figure('color',[1 1 1]), 
    hold on, plotyy([-400:3:400],dArea2,B,C*3)
    area([-400:3:400],dArea2,'FaceColor','k')
    title([cellnames{k},' ',titl{2}])
    xlim([-400 400])
    num2=gcf;
    set(num2,'position',[100 500 1000 700])
    
    if savFig
%     eval(['saveFigure(num1,''figureICSS-Mouse-17-22062011-',num2str(a),''',''/media/DISK_1/Dropbox/MasterMarie/Figures'')'])
%     a=a+1;
    eval(['saveFigure(num2,''figureICSS-Mouse-17-22062011-',num2str(a),''',''/media/DISK_1/Dropbox/MasterMarie/Figures'')'])
    a=a+1;
    end
    close 
    close

    
    [C,B] = CrossCorr(Range(stim3), Range(stim3), 1, 800); C(B==0)=0;
    figure('color',[1 1 1]), [fh, rasterAx, histAx,dArea3] = RasterPETH(S{k}, stim3,  -4000, +4000,'BinSize',30);
    title([cellnames{k},' ',titl{3}])
    num1=gcf;
    figure('color',[1 1 1]), 
    hold on, plotyy([-400:3:400],dArea3,B,C*3)
    area([-400:3:400],dArea3,'FaceColor','k')
    title([cellnames{k},' ',titl{3}])
    xlim([-400 400])
    num2=gcf;
    set(num2,'position',[100 500 1000 700])

    if savFig
%     eval(['saveFigure(num1,''figureICSS-Mouse-17-22062011-',num2str(a),''',''/media/DISK_1/Dropbox/MasterMarie/Figures'')'])
%     a=a+1;
    eval(['saveFigure(num2,''figureICSS-Mouse-17-22062011-',num2str(a),''',''/media/DISK_1/Dropbox/MasterMarie/Figures'')'])
    a=a+1;
    end
    close 
    close
    
    figure('color',[1 1 1]), hold on
    plot([-400:3:400],dArea1,'b')
    plot([-400:3:400],dArea2,'k')
    plot([-400:3:400],dArea3,'r')
    title([cellnames{k},', b:',titl{1},', k:',titl{2},', r:',titl{3}])
    num3=gcf;

    if savFig
    set(num3,'position',[100 500 1000 700])
    eval(['saveFigure(num3,''figureICSS-Mouse-17-22062011Bilan-',num2str(a),''',''/media/DISK_1/Dropbox/MasterMarie/Figures'')'])
    a=a+1;
    end
end


%--------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------


%Epoch2good=intervalSet(4120*1E4,4200*1E4); % sleep (spike detection)
%stim2=Restrict(stim,Epoch2good);

figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{3}, stim1, -6000, +6000,'BinSize',10);
Mb=Data(matVal)';
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{2}, stim1, -6000, +6000,'BinSize',10);
Ma=Data(matVal)';
figure, plot(Range(matVal,'ms'),mean(Mb),'linewidth',2)
hold on, plot(Range(matVal,'ms'),mean(Ma),'r','linewidth',2)
title(titl{1})
ylim([-1000 1500])

figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{3}, stim2, -6000, +6000,'BinSize',10);
Mb=Data(matVal)';
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{2}, stim2, -6000, +6000,'BinSize',10);
Ma=Data(matVal)';
figure, plot(Range(matVal,'ms'),mean(Mb),'linewidth',2)
hold on, plot(Range(matVal,'ms'),mean(Ma),'r','linewidth',2)
title(titl{2})
ylim([-1000 1500])

figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{3}, stim3, -6000, +6000,'BinSize',10);
Mb=Data(matVal)';
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{2}, stim3, -6000, +6000,'BinSize',10);
Ma=Data(matVal)';
figure, plot(Range(matVal,'ms'),mean(Mb),'linewidth',2)
hold on, plot(Range(matVal,'ms'),mean(Ma),'r','linewidth',2)
title(titl{3})
ylim([-1000 1500])



%--------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------



%Epoch2good=intervalSet(4120*1E4,4200*1E4); % sleep (spike detection)

%Epoch2good=intervalSet(4150*1E4,4200*1E4); % sleep (spike detection)
%stim2=Restrict(stim,Epoch2good);


figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{3}, stim2, -6000, +6000,'BinSize',10);
Mb2=Data(matVal)';
%Mb2=zscore(Data(matVal)');
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{2}, stim2, -6000, +6000,'BinSize',10);
Ma2=Data(matVal)';
%Ma2=zscore(Data(matVal)');

figure, plot(Range(matVal,'ms'),mean(Mb2),'linewidth',2)
hold on, plot(Range(matVal,'ms'),mean(Ma2),'r','linewidth',2)
title(titl{2})
ylim([-1000 1500])


%Epoch3=intervalSet(4600*1E4,4800*1E4); % ICSS sleep
%stim3=Restrict(stim,Epoch3);

figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{3}, stim3, -6000, +6000,'BinSize',10);
Mb3=Data(matVal)';
%Mb3=zscore(Data(matVal)');
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFP{2}, stim3, -6000, +6000,'BinSize',10);
Ma3=Data(matVal)';
%Ma3=zscore(Data(matVal)');




 figure('color',[1 1 1]), plot(Range(matVal,'ms'),mean(Mb3),'r','linewidth',2)
hold on, plot(Range(matVal,'ms'),mean(Mb2),'k','linewidth',2)
plot(Range(matVal,'ms'),mean(Mb2)+stdError(Mb2),'k')
plot(Range(matVal,'ms'),mean(Mb2)-stdError(Mb2),'k')
plot(Range(matVal,'ms'),mean(Mb3)+stdError(Mb3),'r')
plot(Range(matVal,'ms'),mean(Mb3)-stdError(Mb3),'r')
title('Stratum Radiatum')
 figure('color',[1 1 1]), plot(Range(matVal,'ms'),mean(Ma3),'r','linewidth',2)
hold on, plot(Range(matVal,'ms'),mean(Ma2),'k','linewidth',2)
plot(Range(matVal,'ms'),mean(Ma2)+stdError(Ma2),'k')
plot(Range(matVal,'ms'),mean(Ma2)-stdError(Ma2),'k')
plot(Range(matVal,'ms'),mean(Ma3)+stdError(Ma3),'r')
plot(Range(matVal,'ms'),mean(Ma3)-stdError(Ma3),'r')
title('Pyramidale layer')



