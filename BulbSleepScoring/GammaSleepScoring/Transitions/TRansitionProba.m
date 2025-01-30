
clear all, close all
m=1;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M60/20130415/';
m=2;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M82/20130730/';
m=3;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M83/20130729/';
m=4;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M123/LPSD1/';
m=5;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M51/09112012/';
m=6;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M61/20130415/';
m=7;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M147/';
m=8;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M148/20140828/';
m=9;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M243/01042015/';
m=10;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M244/09042015/';
m=11;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M251/21052015/';
m=12;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M252/21052015/';
m=13;
filename2{m}='/media/DataMOBSSlSc/SleepScoringMice/M177178/M177178-Sleep-22102014/M178/';

%% To execute
lim=[1,2,3,5,7,10,15,20];
for mm=1:m
    mm
    cd(filename2{mm})
    load('StateEpochSB.mat')
    AvSWS=[median(Stop(SWSEpoch)-Start(SWSEpoch))/1e4];
    AvRem=[median(Stop(REMEpoch)-Start(REMEpoch))/1e4];
    AvWake=[median(Stop(Wake)-Start(Wake))/1e4];
    MatX=[-0.7:3.2/99:2.5];
    MatY=[-1.5:3.5/99:2];
    t=Range(smooth_ghi);
    t=t(1:10:end);
    GhiSubSample=(Restrict(smooth_ghi,ts(t)));
    ThetaSubSample=(Restrict(smooth_Theta,ts(t)));
    gammadata=log(Data(GhiSubSample))-nanmean(log(Data(Restrict(smooth_ghi,SWSEpoch))));
    thetadata=log(Data(ThetaSubSample))-nanmean(log(Data(Restrict(smooth_Theta,SWSEpoch))));
    gammorig=Data(GhiSubSample);    thetorig=Data(ThetaSubSample);
    
    %% Look at time to next transition
    Wake=Or(Wake,NoiseEpoch);
    Wake=Or(Wake,GndNoiseEpoch);
    Wake=mergeCloseIntervals(Wake,3*1e4);
    ListTransitions=sort(unique([0;Start(SWSEpoch);Stop(SWSEpoch);Start(REMEpoch);Stop(REMEpoch);Start(Wake);Stop(Wake);max(t)]));
    DisttoTrans1=[];DisttoTrans2=[];
    for l=1:length(ListTransitions)-1
        DisttoTrans1=[DisttoTrans1;abs(t(find(t>ListTransitions(l) & t<ListTransitions(l+1)))-ListTransitions(l+1))];
        DisttoTrans2=[DisttoTrans2;abs(t(find(t>ListTransitions(l) & t<ListTransitions(l+1)))-ListTransitions(l))];
    end
    Val=cell(1,10);
    for xx=1:length(MatX)-1
        xx
        for yy=1:length(MatY)-1
            datpoints=find(gammadata<MatX(xx+1) & gammadata>MatX(xx) & thetadata<MatY(yy+1) & thetadata>MatY(yy));
            datpoints(datpoints>size(DisttoTrans1,1))=[];
            if isempty(datpoints)
                for p=1:10
                   Val{p}(xx,yy)=NaN; 
                end
            else
                
                Val{1}(xx,yy)=nanmean(DisttoTrans1(datpoints));
                Val{2}(xx,yy)=nanmean(DisttoTrans2(datpoints));
                for j=1:length(lim)
                    Val{2+j}(xx,yy)=nansum(DisttoTrans1(datpoints)>lim(j)*1e4)/length(datpoints);
                end
                
            end
        end
        
    end
    
    save MapsTransitionProba.mat Val
    clear Val
end


for j=4
    temp=nan(99,99);
    divmat=zeros(99,99);
    for mm=1:m
        cd(filename2{mm})
        load('MapsTransitionProba.mat')
        for xx=1:99
            for yy=1:99
                temp(xx,yy)=nanmean([temp(xx,yy),Val{j+2}(xx,yy)]);
                if not(isnan(Val{j+2}(xx,yy)))
                divmat(xx,yy)=divmat(xx,yy)+1;
                end
                %/nansum(Val{j+2}(:));
            end
        end
    end
    figure
    temp=1-temp;
    temp(isnan(temp))=-1
    subplot(121)
    imagesc(MatX,MatY,temp'), axis xy
    for xx=1:99
        temp(xx,:)=runmean(temp(xx,:),1);
    end
    for yy=1:99
        temp(:,yy)=runmean(temp(:,yy),1);
    end
    subplot(122)
    imagesc(MatX,MatY,temp'), axis xy
end

%  %For example, say I have some data:
% 
% % Define the range of the data that we wish to plot
% my_clim = [0 1];
% data=temp';
% X=MatX(1:99);
% Y=MatY(1:99);
% figure('units', 'normalized', 'outerposition', [0.1 0.1 0.8 0.8]);
% % Create a "junk" axes to get the appropriate colorbar
% linear_axes = subplot(1,1,1);
% linear_plot = pcolor(linear_axes, X ,Y, data);
% set(linear_plot, 'EdgeColor', 'none');
% colormap(jet(1024))
% cbar = colorbar('peer', linear_axes, 'Yscale', 'log');
% 
% % Now plot the data on a log scale, but keep the colorbar. This works, but
% % now the colorbar is not associated with the plot
% set(linear_axes, 'Visible', 'off')
% log_axes = axes('Position', get(linear_axes, 'Position'));
% log_plot = pcolor(log_axes, X, Y, log10(data));
% colormap(jet(1024)), caxis(log10(my_clim));
% set(gca, 'Xtick', linspace(-.005, .005, 17)), grid off
% title('PCOLOR Plot on Log Scale')
% set(log_plot, 'EdgeColor', 'none');
% 
% axis xy
%          