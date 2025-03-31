function Temp_data = ClickForFreezingTemperature(Folder,Behav,Params)

[file,path] = uigetfile('*.avi');
OBJ = VideoReader([path,file]);
WideFreezEpoch = intervalSet(Start(Behav.FreezeAccEpoch)-3*1e4,Stop(Behav.FreezeAccEpoch)+3*1e4);
WideFreezEpoch = mergeCloseIntervals(WideFreezEpoch,1*1e4);
TimeFreezing = Range(Restrict(Behav.Vtsd,WideFreezEpoch),'s');
TimeAll = Range(Behav.Vtsd,'s');
GoodFrames = find(ismember(TimeAll,TimeFreezing));
XPos = Data(Behav.Xtsd);
YPos = Data(Behav.Ytsd);
count = 0;

i = 1;
frame_num = 1;
dt_desired = 0.5; %take a frame every 500ms
dt = median(diff(Range(Behav.Xtsd,'s')));
FramesBetTimes = floor(dt_desired./dt);
global reply; reply=0;
fig = figure;
MousePlot = subplot(1,4,1:2);
MousePlot2 = subplot(1,4,3:4);
set(fig,'WindowKeyPressFcn',@KeepPosition);

% KeepButton = uicontrol(fig,'style','pushbutton',...
%     'units','normalized',...
%     'position',[0.8 0.8 0.15 0.1],...
%     'string','Keep',...
%     'tag','keeping',...
%     'callback', @KeepPosition);
%
% ChangeButton = uicontrol(fig,'style','pushbutton',...
%     'units','normalized',...
%     'position',[0.8 0.6 0.15 0.1],...
%     'string','Change',...
%     'tag','changing',...
%     'callback', @ChangePosition);

while hasFrame(OBJ)
    vidFrame = readFrame(OBJ);
    vidFrame = squeeze(vidFrame(:,:,1));
    
    if frame_num==1
        imagesc(vidFrame)
        title('click on centre of maze to get temperature')
        h = imellipse;
        BW_centre = createMask(h);
    end
    
    if ismember(frame_num,GoodFrames)
        if rem(frame_num-1,FramesBetTimes) == 0
            
            Xlimits = [max([1,floor(XPos(frame_num)/Params.pixratio)-50]),min([floor(XPos(frame_num)/Params.pixratio)+50,size(vidFrame,2)])];
            Ylimits = [max([1,floor(YPos(frame_num)/Params.pixratio)-50]),min([floor(YPos(frame_num)/Params.pixratio)+50,size(vidFrame,1)])];
            
            if count >0
                axes(MousePlot)
                imagesc(double(vidFrame).*double(BW_body+0.5)+double(vidFrame).*double(BW_tail+0.5)),clim([70 200])
                ylim([Ylimits(1) Ylimits(2)])
                xlim([Xlimits(1) Xlimits(2)])
                axes(MousePlot2)
                imagesc(double(vidFrame)),clim([70 200])
                ylim([Ylimits(1) Ylimits(2)])
                xlim([Xlimits(1) Xlimits(2)])
                title('Press A to keep, Z to change')
                uiwait
            end
            
            if reply==0
                try
                    axes(MousePlot2)
                    imagesc(vidFrame), clim([70 200])
                    ylim([Ylimits(1) Ylimits(2)])
                    xlim([Xlimits(1) Xlimits(2)])
                    title('click on tail')
                    h = imellipse;
                    BW_tail = createMask(h);
                    title('click on body')
                    h = imellipse(gca);
                    BW_body = createMask(h);
                catch
                    try
                        pause(1)
                        axes(MousePlot2)
                        imagesc(vidFrame), clim([70 200])
                        ylim([Ylimits(1) Ylimits(2)])
                        xlim([Xlimits(1) Xlimits(2)])
                        title('click on tail')
                        h = imellipse;
                        BW_tail = createMask(h);
                        title('click on body')
                        h = imellipse(gca);
                        BW_body = createMask(h);
                    catch
                        keyboard
                    end
                end
            end
            Temp_data.Time(i) = TimeAll(frame_num);
            
            RoomTempZone = double(BW_centre).*double(vidFrame);
            RoomTempZone(RoomTempZone==0) = NaN;
            Temp_data.Room.Mean(i) = nanmean(RoomTempZone(:));
            Temp_data.Room.Median(i) = nanmedian(RoomTempZone(:));
            Temp_data.Room.Std(i) = nanstd(RoomTempZone(:));
            Temp_data.Room.Max(i) = nanmax(RoomTempZone(:));
            
            if sum(BW_tail(:))<1000
                TailTempZone = double(BW_tail).*double(vidFrame);
                TailTempZone(TailTempZone==0) = NaN;
                Temp_data.Tail.Mean(i) = nanmean(TailTempZone(:));
                Temp_data.Tail.Median(i) = nanmedian(TailTempZone(:));
                Temp_data.Tail.Std(i) = nanstd(TailTempZone(:));
                Temp_data.Tail.Max(i) = nanmax(TailTempZone(:));
            else
                Temp_data.Tail.Mean(i) = NaN;
                Temp_data.Tail.Median(i) = NaN;
                Temp_data.Tail.Std(i) = NaN;
                Temp_data.Tail.Max(i) = NaN;
            end
            
            BodyTempZone = double(BW_body).*double(vidFrame);
            BodyTempZone(BodyTempZone==0) = NaN;
            Temp_data.Body.Mean(i) = nanmean(BodyTempZone(:));
            Temp_data.Body.Median(i) = nanmedian(BodyTempZone(:));
            Temp_data.Body.Std(i) = nanstd(BodyTempZone(:));
            Temp_data.Body.Max(i) = nanmax(BodyTempZone(:));
            
            i=i+1;
            count = count+1;
        end
    else
        count = 0;
    end
    frame_num = frame_num+1;
end


    function KeepPosition(obj,event) % keep ref in memory
        keyPressed = event.Key;
        if strcmpi(keyPressed,'A')
            reply=1;
            uiresume
        elseif  strcmpi(keyPressed,'Z')
            reply=0;
            uiresume
        end
    end

end