%% INPUTS
freq=30; % Hz, default 30Hz
BlockDistance=60; % duration in sec of each time block for distance

% Lounch AnalyOpenField


erasePreviousA=1; % 0 to keep existing files, 1 otherwise

%% INITIALISATION
res=pwd;
lis=dir(res);
scrsz = get(0,'ScreenSize');

if isempty(strfind(res,'/')),mark='\'; else mark='/';end
totaldist= [];



%% SCREEN FOR UNDONE OFFLINE TRACKING


for i=3:length(lis)
    filename=lis(i).name;
    if length(lis(i).name)>4 && strcmp(lis(i).name(6:10),'Mouse')
        % number of the mouse
        nameMouse=lis(i).name(12:end);
        nameMouse=strtok(nameMouse,'-');
        
        nPhase = filename(strfind(filename,'Phase')+5);
        
        disp(' ')
        disp(['           * * * Mouse ',nameMouse,'  Phase ',nPhase,' * * *'])
        
        % -------------------------------------------------
        % Check if tracking is done
        clear Dista x y;
        try
            
            load([filename,mark,'AnalyeDistance-A.mat'],'Dista', 'x', 'y','Ratio_IMAonREAL');
            disp('Distance analyze done!');
            Dista;
            x;
            y;
            PosOFF=PosMat;
        catch
            load([filename,mark,'InfoTracking.mat'],'PosMat','mask','ref');
            PosOFF=PosMat;
            
            
            
            
            %% Ask for all inputs and display
            
            
            figure,
            subplot(1,2,1), title('Click on two points to define a distance','Color','w')
            imagesc(ref(:,:)),colormap(bone);
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
            close;
            
            
        end
        
        % -------------------------------------------------
        %% Tracking Distance
        PosOFF=PosOFF(~isnan(PosOFF(:,2)),:);
        TimeInt=min(PosOFF(:,1)):1/freq:max(PosOFF(:,1));
        
        Xint=interp1(PosOFF(:,1),PosOFF(:,2),TimeInt);
        Yint=interp1(PosOFF(:,1),PosOFF(:,3),TimeInt);
        
        PosWork=[TimeInt',Xint',Yint'];
        ok='n';
        x=0;
        y=0;
        try
            clear x y Dista;
            load([filename,mark,'AnalyzeDistance-A.mat'],'x','y','Dista','PosWork');
        catch
            
            while ok~='y';
                figure('Color',[ 1 1 1])
                imagesc(mask); colormap gray
                hold on, plot(PosOFF(:,2),PosOFF(:,3),'r')
                hold on, plot(PosWork(:,2),PosWork(:,3))
                title('Define environment edges')
                
                [x,y]=ginput(2);
                hold on, line([x(1) x(1) x(2) x(2) x(1)], [y(1) y(2) y(2) y(1) y(1)], 'Color','k')
                %%ok=input('Are you satisfied with new environment edges (y/n)? ','s');
                
                choice = questdlg('Are you satisfied with new environment edges?', ...
                    'Do you like your edges?', ...
                    'Yes','No','No');
                
                switch choice
                    case 'Yes'
                        disp([choice ' coming right up.'])
                        ok = 'y';
                        break
                    case 'No'
                        disp([choice '  try again!'])
                        ok = 'n';
                        break
                end
                
                
                close;
            end
        end
        temp=[PosWork(:,1),PosWork(:,2)-mean(x),PosWork(:,3)-mean(y)];
        PosWork=temp;
        x=x-mean(x); y=y-mean(y);
        
        
        %% Show central zone
        
        
        %             figure('Color',[ 1 1 1])
        %             subplot(2,2,1)
        %             plot(PosWork(:,2),PosWork(:,3))
        %             hold on, line([x(1) x(1) x(2) x(2) x(1)], [y(1) y(2) y(2) y(1) y(1)], 'Color','k')
        
        CentralPercVal=10:10:90;
        for i=1:length(CentralPercVal)
            CentralPerc=CentralPercVal(i); % percentage, default 50%
            
            temp=realsqrt(CentralPerc*x(1)^2/100);
            CentralX=[-temp;temp];
            temp=realsqrt(CentralPerc*y(1)^2/100);
            CentralY=[-temp;temp];
            
            % percentage of time in central zone,
            PercTime(i)=sum(abs(PosWork(:,2))<CentralX(2) & abs(PosWork(:,3))<CentralY(2))/length(PosWork)*100;
            
            % plot 50% central zone
            if CentralPerc==50
                hold on, line([CentralX(1) CentralX(1) CentralX(2) CentralX(2) CentralX(1)], [CentralY(1) CentralY(2) CentralY(2) CentralY(1) CentralY(1)], 'Color','m')
                title(filename)
                legend({'Path','edges','50%central'}, 'Location','East')
                disp(['% time spent in central zone (50% surface)= ',num2str(PercTime(i))])
            end
        end
        
        %             subplot(2,2,2),bar(CentralPercVal,PercTime)
        %             xlabel('central zone (% surface)')
        %             ylabel('% time spent in central zone')
        
        
        
        
        %% distance parcourue
        
        IntervalDist=[0  60  120  180  240  300  360];
        Distphase=[];
        
        DistMat= [PosOFF(1:end-1,1) realsqrt(diff(PosOFF(:,2)).*diff(PosOFF(:,2))+diff(PosOFF(:,3)).*diff(PosOFF(:,3)))];
        for ta=1:length(IntervalDist)-1
            Dista=nansum(DistMat(DistMat(:,1)>=IntervalDist(ta) & DistMat(:,1)<IntervalDist(ta+1),2));
            Distphase = cat(2,Distphase, Dista);
        end
        %detail distance par block de temps
        tempdist = [str2num(nameMouse) Ratio_IMAonREAL Distphase];
        totaldist = cat(1,totaldist,tempdist);
        
        %On resume pour plotter au final
        Matdisttemp = [str2num(nameMouse)]
        
        %             subplot(2,2,3)
        %             bar(index/freq,Dista)
        %             title(['Run Distance per ',num2str(BlockDistance),'s block'])
        
        disp(['Total Runned distance ',num2str(sum(Distphase))])
        disp(['Total Runned distance with ratio ',num2str(sum(Distphase)./Ratio_IMAonREAL)])
       
        
        %% save Analyse
        
        filenameTronc=filename(1:strfind(filename,'.mat')-1);
        if isempty(filenameTronc), filenameTronc=[filename,mark,filename];
        end
        
        filenameTronc=[filename,mark,'AnalyzeDistance'];
        save([filenameTronc,'-A'],'PercTime','Dista','PosWork','x', 'y','totaldist','Ratio_IMAonREAL');
        %clear x y Perctime Dista PosWork Ratio_IMAonREAL ;
        
    end
    
    % -------------------------------------------------
    
    
    
    
    
    
    
end





