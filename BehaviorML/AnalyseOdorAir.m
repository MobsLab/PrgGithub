%% INITIALISATION
res=pwd;
lis=dir(res);
scrsz = get(0,'ScreenSize');


if isempty(strfind(res,'/')),mark='\'; else mark='/';end

%% INPUT
disttood = 3; %distance par rapport � la source odorante, default = 10cm
timeana = 300; %time in sec to analyse deffaut 60sec
TotTimeExpe = 360; %time in sec of the total experiment, default 360;
phase0fromend = 0; % if you want to analyze the end of the first phase 
MatRep = [];
totaldist = [];
BlockDistance = 60;%time in sec of the block distance analysis, default 360;

nmouse=input('Enter number of mice in the experiment: ');
   

figure('Color',[1 1 1],'Position',[scrsz(1:2),scrsz(3)/2,scrsz(4)]),numF = gcf;ifile=0;legendnumF=[];
for i=3:length(lis)
    
    filename=lis(i).name;
    if length(lis(i).name)>35 && strcmp('BULB',lis(i).name(1:4)) 
        ifile=ifile+1;
        % number of the mouse
        nameMouse=lis(i).name(12:end);
        nameMouse=strtok(nameMouse,'-');
        
        Phase = filename(strfind(filename,'Phase')+5);
        
        disp(' ')
        disp(['           * * * Mouse ',nameMouse,' Phase ',Phase,' * * *'])
        
        % -------------------------------------------------
        %Check if analyse  is done
        
        try
            
            load([filename,mark,'AnalyseOdor.mat'],'Ratio_IMAonREAL','xod','yod');
            TempInfo = load([filename,mark,'InfoTracking.mat']);
            disp('Odor analyze done!');
            TempPosWork = TempInfo.PosMat;
            Ratio_IMAonREAL;
            xod;
            yod;
            %c
            doAnalyse =0;
        catch
            doAnalyse =1;
            disp('Odor analyze  not done!');
            TempInfo = load([filename,mark,'InfoTracking.mat']);
            
            %% SCREEN FOR UNDONE OFFLINE TRACKING
            TempPosWork = TempInfo.PosMat;
            
            
           
            % -------------------------------------------------
            % Ratio Image
            % -------------------------------------------------
            
            subplot(1,2,1), title('Click on two points to define a distance','Color','w')
            imagesc(TempInfo.ref); colormap gray; axis image;
            
            for j=1:2
                [x,y]=ginput(1);
                hold on, plot(x,y,'+r')
                x1(j)=x; y1(j)=y;
            end
            line(x1,y1,'Color','r','Linewidth',2)
            
            answer = inputdlg({'Enter real distance (cm):'},'Define Real distance',1,{'45'});
            text(mean(x1)+10,mean(y1)+10,[answer{1},' cm'],'Color','r')
            
            d_xy=sqrt((diff(x1)^2+diff(y1)^2));
            Ratio_IMAonREAL=d_xy/str2num(answer{1});
            
            title(' do 2-')
            hold on, line([10 20]*Ratio_IMAonREAL,[10 10],'Color','k','Linewidth',3)
            text(15*Ratio_IMAonREAL,15,'10 cm','Color','k')
            save([res,mark,filename,mark,'InfoTracking.mat'],'-append','Ratio_IMAonREAL')
            
            
            % -------------------------------------------------
            % Odor source
            % -------------------------------------------------
%             figure('Name','c','Color',[1 1 1])
            subplot(1,2,1), title('Click on two points to define Odor Location Clic Var then Fix','Color','w')
            imagesc(TempInfo.ref); colormap gray; axis image;
            
            hold on, plot(TempPosWork(:,2),TempPosWork(:,3));
            
            for j=1:2
                [x,y]=ginput(1);
                hold on, plot(x,y,'+r')
                xod(j)=x; yod(j)=y;
            end
        end
        %-----Frequ aquisition----%
        
        freq = round(size(TempPosWork,1)/max(TempPosWork(:,1)));
        
        %--Take the time to analyse in PosMat to analyse as specified in input--%
        if str2num(Phase) ~= 0
            TempPosWork = TempPosWork([1:(freq*timeana)],:);
            
        elseif str2num(Phase) == 0 && phase0fromend == 0
            TempPosWork = TempPosWork([1:(freq*timeana)],:);
        elseif str2num(Phase) == 0 && phase0fromend == 1
            size(TempPosWork,1)
            (freq*timeana)
            fromend = size(TempPosWork,1)-(freq*timeana)
            TempPosWork = TempPosWork([fromend:end],:);
            
        end    
      
        
        % -------------------------------------------------
        % Distance to odor source
        % -------------------------------------------------
        
        PosWorkVar = [TempPosWork(:,1),TempPosWork(:,2)-xod(1), TempPosWork(:,3)-yod(1)];
        disttovar = [sqrt(PosWorkVar(:,2).*PosWorkVar(:,2)+PosWorkVar(:,3).*PosWorkVar(:,3)) ];
        
        PosWorkFix = [TempPosWork(:,1),TempPosWork(:,2)-xod(2), TempPosWork(:,3)-yod(2)];
        disttofix = [sqrt(PosWorkFix(:,2).*PosWorkFix(:,2)+PosWorkFix(:,3).*PosWorkFix(:,3)) ];
        
        
        
        
        ratiotot= size(TempPosWork);
        nbvar = le(disttovar(:,1), (disttood*Ratio_IMAonREAL));
        nbfix = le(disttofix(:,1), (disttood*Ratio_IMAonREAL));
        
        nbvar = sum(nbvar(:,1));
        nbfix = sum(nbfix(:,1));
        
        figure('Name','c','Color',[1 1 1])
        subplot(1,2,2)
        
        bar([1  2],[nbvar./ratiotot(1)  nbfix./ratiotot(1)] )
        set(gca,'XTick',1:2);
        set(gca,'XTickLabel', {'Var', 'Fix'});
        title([' Mouse ',nameMouse,' Phase ',Phase]);
        
        tempRep = [str2num(nameMouse) str2num(Phase) nbvar nbfix ratiotot];
        MatRep = vertcat(MatRep,tempRep);
        
        % -------------------------------------------------
        % Distance per block
        % -------------------------------------------------
        
        IntervalDist=[0 30 60 90 120 150 180 210 240 270 300 330 360];
        Distphase=[];
        
        DistMat= [TempInfo.PosMat(1:end-1,1) realsqrt(diff(TempInfo.PosMat(:,2)).*diff(TempInfo.PosMat(:,2))+diff(TempInfo.PosMat(:,3)).*diff(TempInfo.PosMat(:,3)))];
        for ta=1:length(IntervalDist)-1
            Dista=nansum(DistMat(DistMat(:,1)>=IntervalDist(ta) & DistMat(:,1)<IntervalDist(ta+1),2));
            Distphase = cat(2,Distphase, Dista);
        end
        tempdist = [str2num(nameMouse) str2num(Phase) Distphase];
        totaldist = cat(1,totaldist,tempdist);
        
        save ([res,mark,filename,mark,'AnalyseOdor.mat'],'tempRep','xod','yod','Ratio_IMAonREAL','TempPosWork','tempdist' );
        save([res,mark,'AnalyseOdorGen-',num2str(timeana),'sec',num2str(disttood),'cm.mat'],'MatRep','BlockDistance','totaldist');
        
        close c;
        if doAnalyse~= 1
        figure(numF)
        subplot(nmouse,3,ifile), 
        imagesc(TempInfo.ref); colormap bone;axis image; axis off
        
        Intervaltemps=[0 60 120 180 240 300 360];
        %Intervaltemps=[0 180 360];
        colori={'c','b','k','g','r','m'};
        for ti=1:length(Intervaltemps)-1
            if ifile==1;legendnumF=[legendnumF,{[num2str(Intervaltemps(ti)),'-',num2str(Intervaltemps(ti+1))]}];end
            indexi=find(TempInfo.PosMat(:,1)>=Intervaltemps(ti) & TempInfo.PosMat(:,1)<Intervaltemps(ti+1));
           hold on, plot(TempInfo.PosMat(indexi,2),TempInfo.PosMat(indexi,3),'Color',colori{ti})
        end
        %hold on, plot(TempPosWork(:,2) ,TempPosWork(:,3)); 
        title(['Mouse ',nameMouse,', ',num2str(timeana),'s, ',num2str(disttood),'cm']);
        
        else
        end
        
       
        
    end
    
    
    
    
    
end

 figure(numF), legend(legendnumF,'Location','SouthOutside');
 subplot(nmouse,3,2), text(0,-70,res(max([strfind(res,'\'),strfind(res,'/')])+1:end))
% figure('Color',[1 1 1])
% 
% subplot(4,4,i-3)
% bar(MatRep(MatRep(:,2)==0,3), MatRep(MatRep(:,2)==0,4))
% title(['temps var et temps fix-',num2str(timeana),'sec',num2str(disttood),'cm'])
% set(gca,'XTick',1:3)
% set(gca,'XTickLabel',{'Phase 0', 'Phase 1', 'Phase 2' })





figure('Name','','Color',[1 1 1],'Position',[scrsz(1:2),scrsz(3)/2,scrsz(4)/4])
subplot(2,4,1)
PlotErrorBar2(MatRep(MatRep(:,2)==0,3), MatRep(MatRep(:,2)==0,4), 0,2);
ylabel('Time at var and fix location'), title([num2str(timeana),'s, ',num2str(disttood),'cm']);
set(gca,'XTick',1:2)
set(gca,'XTickLabel',{'Var', 'Fix'})
axis([0 4 0 350]);

subplot(2,4,2)
PlotErrorBar2(MatRep(MatRep(:,2)==1,3), MatRep(MatRep(:,2)==1,4), 0,2);
ylabel('Time at var and fix location'), title([num2str(timeana),'s, ',num2str(disttood),'cm']);
set(gca,'XTick',1:2)
set(gca,'XTickLabel',{'Var', 'Fix'})
axis([0 4 0 350]);


subplot(2,4,3)
PlotErrorBar2(MatRep(MatRep(:,2)==2,3), MatRep(MatRep(:,2)==2,4), 0,2)
ylabel('Time at var and fix location'), title([num2str(timeana),'s, ',num2str(disttood),'cm']);
set(gca,'XTick',1:2)
set(gca,'XTickLabel',{'Var', 'Fix'})
axis([0 4 0 350]);


subplot(2,4,4)
%PlotErrorBar3(log(MatRep(MatRep(:,2)==0,3)./MatRep(MatRep(:,2)==0,4)), log(MatRep(MatRep(:,2)==1,3)./MatRep(MatRep(:,2)==1,4)), log(MatRep(MatRep(:,2)==2,3)./MatRep(MatRep(:,2)==2,4)),0,1)
%title(['Ratio Log temps var/temps fix-',num2str(timeana),'sec',num2str(disttood),'cm'])
PlotErrorBar3(MatRep(MatRep(:,2)==0,3)-MatRep(MatRep(:,2)==0,4), MatRep(MatRep(:,2)==1,3)-MatRep(MatRep(:,2)==1,4), MatRep(MatRep(:,2)==2,3)-MatRep(MatRep(:,2)==2,4),0,2)
ylabel('difference temps var-fix ');title(res(max([strfind(res,'\'),strfind(res,'/')])+1:end))
set(gca,'XTick',1:3)
set(gca,'XTickLabel',{'Phase 0', 'Phase 1', 'Phase 2' })


totaldist= [totaldist(:,1:2),totaldist(:,3:end)./Ratio_IMAonREAL];
meanDistPhase0 = [mean(totaldist(totaldist(:,2)==0,1:end))];
meanDistPhase1 = [mean(totaldist(totaldist(:,2)==1,1:end))];
meanDistPhase2 = [mean(totaldist(totaldist(:,2)==2,1:end))];

subplot(2,4,5)
bar([meanDistPhase0(:,3:end); meanDistPhase1(:,3:end); meanDistPhase2(:,3:end)],'grouped');colormap bone;
set(gca,'XTick',1:3)
set(gca,'XTickLabel',{'Phase 0', 'Phase 1', 'Phase 2' })
ylabel('Moy Dist per block time  ');

subplot(2,4,8)
PlotErrorBar3(MatRep(MatRep(:,2)==0,3)+MatRep(MatRep(:,2)==0,4), MatRep(MatRep(:,2)==1,3)+MatRep(MatRep(:,2)==1,4), MatRep(MatRep(:,2)==2,3)+MatRep(MatRep(:,2)==2,4),0,2)
ylabel('difference temps ToTal (var+fix) ');
set(gca,'XTick',1:3)
set(gca,'XTickLabel',{'Phase 0', 'Phase 1', 'Phase 2' })

saveFigure(numF,[res(max([strfind(res,'\'),strfind(res,'/')])+1:end),'Mouse-',nameMouse,'-',num2str(timeana),'s-',num2str(disttood),'cm'],[res,mark,'Figures'])

%clear all;




