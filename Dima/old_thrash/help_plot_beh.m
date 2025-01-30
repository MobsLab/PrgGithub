        dir_in = '/media/mobsrick/DataMOBs71/Mouse-714/27022018_Mouse-714-UMaze-Day3/FEAR-Mouse-714-27022018-Cond_0';
        name = 'behavResources.mat';
        
        fig_out = 'occup_overall_M714_condall_27022018';
        dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Behavior_UMaze/Mouse714/27022018/';

        
        
        for i=1:1:4
            a = load([dir_in num2str(i-1) '/' name], 'Occup');
            Occup_merged(i,1:7) = a.Occup;
        end
        
        Occup_mean = mean(Occup_merged,1);
        Occup_std = std(Occup_merged,1);
        

        bar(Occup_mean(1:2))
        hold on
        errorbar(Occup_mean(1:2), Occup_std(1:2),'.', 'Color', 'r');
        hold on
        try,set(gca,'Xtick',[1,2],'XtickLabel',{ZoneLabels{1:2}}),end
        colormap copper
        ylabel('% time spent')
        xlim([0.5 2.5])
        box off
%         title('=15min');
        
        saveas(gcf, [dir_out fig_out '.fig']);
        saveFigure(gcf,fig_out,dir_out);
        
        
        
        fig_out = 'occup_overall_M714_post04_28022018';
        dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Behavior_UMaze/Mouse714/28022018/';

        
        
        bar(Occup(1:2))
        hold on
        try,set(gca,'Xtick',[1,2],'XtickLabel',{ZoneLabels{1:2}}),end
        colormap copper
        ylabel('% time spent')
        xlim([0.5 2.5])
        box off
%         title('=15min');
        
        saveas(gcf, [dir_out fig_out '.fig']);
        saveFigure(gcf,fig_out,dir_out);
        
        
        
        
        
        %% 3min for pretests
        
        T=Range(Ytsd);
% f-min time slices
f=3;

% 3min slice
        int = intervalSet(0, f*60*1E4);
        Xtsd_slice = Restrict(Xtsd,int);
        Ytsd_slice = Restrict(Ytsd,int);
   
        
 % Calculate the occupancy for 3min slice
    Xtemp = Data(Xtsd_slice); Ytemp = Data(Ytsd_slice); T1 = Range(Ytsd_slice);
    a=find((~isnan(Xtemp))); b=find((~isnan(Ytemp)));
    Xtemp=Xtemp(a); Ytemp=Ytemp(b); T1=T1(b);
    if not(isempty('Zone'))
            for t=1:length(Zone)
                try
                    ZoneIndices{t}=find(diag(Zone{t}(floor(Xtemp*Ratio_IMAonREAL),floor(Ytemp*Ratio_IMAonREAL))));
                    Xtemp2=Xtemp*0;
                    Xtemp2(ZoneIndices{t})=1;
                    ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
                    Occup_slice(t)=size(ZoneIndices{t},1)./size(Xtemp,1);
                    FreezeTime_slice(t)=length(Data(Restrict(Xtsd_slice,and(FreezeEpoch,ZoneEpoch{t}))))./...
                        length(Data((Restrict(Xtsd_slice,ZoneEpoch{t}))));
                catch
                    ZoneIndices{t}=[];
                    ZoneEpoch{t}=intervalSet(0,0);
                    Occup_slice(t)=0;
                    FreezeTime_slice(t)=0;
                end
            end
        else
            for t=1:2
                ZoneIndices{t}=[];
                ZoneEpoch{t}=intervalSet(0,0);
                Occup_slice(t)=0;
                FreezeTime_slice(t)=0;
            end
    end

        bar(Occup_slice(1:2))
        hold on
        try,set(gca,'Xtick',[1,2],'XtickLabel',{ZoneLabels{1:2}}),end
        colormap copper
        ylabel('% time spent')
        xlim([0.5 2.5])
        box off