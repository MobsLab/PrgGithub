%%ClinicDeltaLabelizor
% KJ 02.08.2017
% 
% -> Interface to score slow-waves / delta waves
% 
% 
% 
% 

classdef ClinicDeltaLabelizor < handle
    
    properties(Access=protected)
        
    end

    properties
        channels            %channels to work with
        
        after_disp          % time period to display after marker 
        ax_list             % axes of the figure
        before_disp         % time period to display before marker
        color_list          % list of colors used in the figure
        duration            % duration of the signals = number of point
        event_channels      % channels of the rectangles
        event_labels        % labels of the rectangles
        event_durations     % duration of the rectangles  
        event_starts        % begining of the rectangles
        fig                 % figure
        fs                  % sampling frequency
        ind                 % index of the current time marker, used to choose which part of signal to plot
        ind_event           % index of the current event marker
        nb_channel          % number of channels
        nb_event            % number of events (e.g slow waves)
        nb_ind              % number of time markers
        nextbutton          % button '>'
        nobutton            % button 'Not SW'
        prevbutton          % button '<'
        signals             % signals to plot
        plot_colors         % colors of the signals
        rec_colorlist        % color of the rectangles
        slidind             % slider
        time_events         % markers of events
        time_views          % markers of visualisation
        titles              % graph titles
        verticals           % timestamps of vertical lines
        vertical_colors     % colors of vertical lines
        yesbutton           % button 'Slow-waves'
        ymins               % ymin for each graph 
        ymaxs               % ymax for each plot
    end
    
    %methods
    methods
        
        %% Constructor
        function obj = ClinicDeltaLabelizor(signals, varargin)
            % Check number of parameters
            if nargin < 1 || mod(length(varargin),2) ~= 0,
              error('Incorrect number of parameters.');
            end
            
            % Parse parameter list
            for i = 1:2:length(varargin),
                if ~ischar(varargin{i}),
                    error(['Parameter ' num2str(i+2) ' is not a property.']);
                end
                switch(lower(varargin{i})),
                    case 'channels',
                        obj.channels = varargin{i+1};
                        if ~all(isint(obj.channels)) || isempty(obj.channels),
                            error('Incorrect value for property ''channels''.');
                        end
                    case 'fs',
                        obj.fs = varargin{i+1};
                        if ~isint(obj.fs) || obj.fs <=0,
                            error('Incorrect value for property ''Fs''.');
                        end
                    case 'displaywindow'
                        window_display = varargin{i+1};
                        if ~isfloat(window_display) || length(window_display)~=2,
                            error('Incorrect value for property ''DisplayWindow''.');
                        end
                    otherwise,
                        error(['Unknown property ''' num2str(varargin{i}) '''.']);
                end
            end
            
            obj.signals = signals;
            if isempty(obj.fs)
                obj.fs = 250;
            end
            if exist('window_display', 'var')
                obj.before_disp = window_display(1);
                obj.after_disp = window_display(2);
            else
                obj.before_disp = 3;
                obj.after_disp = 4;
            end
            obj.nb_channel = max(size(obj.signals));
            obj.duration = max(cellfun(@(v)max(v(1,:)), obj.signals));
            obj.titles =  cell(1,obj.nb_channel);
            obj.ymins = -5000 * ones(1,obj.nb_channel);
            obj.ymaxs = 5000 * ones(1,obj.nb_channel);
            obj.ind = 1;
            obj.time_views = 0:1:obj.duration;
            obj.time_events = [];
            obj.nb_ind = length(obj.time_views);
            obj.event_channels = [];
            obj.event_starts = [];
            obj.event_durations = [];
            obj.event_labels = [];
            obj.plot_colors = {'y','k','b','r','g',[0.5 0.5 0.5]};
            obj.rec_colorlist = {[0.75 0.75 0.75],'r','g'};
            obj.verticals = cell(1,obj.nb_channel);
            obj.vertical_colors = cell(1,obj.nb_channel);
            
        end
        
        function set_title(obj, title, channel)
            obj.titles{channel} = title;
        end
        
        
        % add predetections
        function add_rectangles(obj, timestamps, durations, channels)
            if length(timestamps)~=length(durations) || length(timestamps)~=length(channels)
                error('start, durations and channels must have th same length')
            end
            obj.event_starts = [obj.event_starts timestamps];
            obj.event_durations = [obj.event_durations durations];
            obj.event_channels = [obj.event_channels channels];
            obj.event_labels = [obj.event_labels ones(1,length(timestamps))*(-1)];
            obj.time_events = obj.event_starts;
            obj.ind_event = 1;
            obj.nb_event = length(obj.time_events);
        end
        
        % add verticals
        function add_verticals(obj, timestamps, channel, color)
            if nargin < 4
                color = 'b';
            end
            ind_color = length(obj.color_list) + 1;
            obj.color_list{ind_color} = color;
            obj.verticals{channel} = [obj.verticals{channel} timestamps];
            obj.vertical_colors{channel} = [obj.vertical_colors{channel} ones(1,length(timestamps))*ind_color];
        end
        
        % change time views
        function set_index_views(obj, timestamps)
            obj.time_views = sort(timestamps);
            obj.ind = 1;
            obj.nb_ind = length(timestamps);
        end
        function reset_time_views(obj)
            obj.time_views = 0:1:obj.duration;
            obj.ind = 1;
            obj.nb_ind = length(obj.time_views);
        end
        
        % change ylimits
        function set_ymin(obj, channel, ymin)
            obj.ymins(channel) = ymin;
        end
        function set_ymax(obj, channel, ymax)
            obj.ymaxs(channel) = ymax;
        end
        function autoscale_ylim(obj, channel)
            std_sig = std(obj.signals{channel}(2,:));
            obj.ymins(channel) = - std_sig * 5;
            obj.ymaxs(channel) = std_sig * 5;
        end
        
        
        %% Create the figure
        function run_window(obj)
            
            %  Create and then hide the UI as it is being constructed.
            obj.fig = figure('Name','SignalObserver','Visible','off','units','normalized','outerposition',[0 0 1 1]);

            % Construct the components.
            obj.slidind = uicontrol('Style','slider','units','normalized', 'Position',[0.08 0.03 0.3 0.025], 'value', obj.ind, 'min',1, 'max',obj.nb_event,...
                'Callback', @(handle,event)slidind_Callback(obj,handle,event));
            obj.prevbutton = uicontrol('Style','pushbutton', 'String','<','units','normalized','Position',[0.80 0.03 0.05 0.045], 'Callback',@(handle,event)prevbutton_Callback(obj,handle,event));
            obj.nextbutton = uicontrol('Style','pushbutton', 'String','>','units','normalized','Position',[0.85 0.03 0.05 0.045], 'Callback',@(handle,event)nextbutton_Callback(obj,handle,event));
            
            
            obj.yesbutton = uicontrol('Style','pushbutton', 'String','Slow-wave (1)','units','normalized','Position',[0.5 0.03 0.05 0.045],...
                'Backgroundcolor','g','Callback',@(handle,event)yesbutton_Callback(obj,handle,event));
            obj.nobutton = uicontrol('Style','pushbutton', 'String','Not SW (0)','units','normalized','Position',[0.55 0.03 0.05 0.045],...
                'Backgroundcolor','r','Callback',@(handle,event)nobutton_Callback(obj,handle,event));
            
            set(obj.fig,'KeyPressFcn', @(handle,event)key_pressed_fcn(obj,handle,event));
            
            %axes
            obj.ax_list = cell(1,obj.nb_channel);
            for ch=1:obj.nb_channel
                obj.ax_list{ch} = subplot(obj.nb_channel,1,ch);
            end
            
            %abscissa
            center = obj.time_views(obj.ind);
            if center > obj.before_disp
                x0 = center - obj.before_disp;
            else
                x0 = 0;
            end
            if center + obj.after_disp <= obj.duration
                xf = center + obj.after_disp;
            else
                xf = obj.duration;
            end
            
            %Plot
            for ch=1:obj.nb_channel
                set(obj.fig,'CurrentAxes',obj.ax_list{ch});
                xdata = obj.signals{ch}(1,:);
                t = xdata(xdata>=x0 & xdata<=xf);
                baseline = zeros(1, length(t));
                
                for k=2:size(obj.signals{ch},1)
                    ydata = obj.signals{ch}(k,xdata>=x0 & xdata<=xf);
                    plot(t,ydata,'LineWidth',1,'Color',obj.plot_colors{k}), hold on,
                end
                
                plot(t,baseline,'LineWidth',0.3, 'Color', [0.7 0.7,0.7]),
                y_min = obj.ymins(ch);
                y_max = obj.ymaxs(ch);
                ylim([y_min y_max]);
                xlim([x0 xf]);
                title(obj.ax_list{ch}, obj.titles{ch});
                
                %add verticals to plot
                if ~isempty(obj.verticals{ch})
                    vert = obj.verticals{ch};
                    vert_color = obj.vertical_colors{ch};
                    
                    vert_ok = vert>=x0 & vert<=xf;
                    vert = vert(vert_ok);
                    vert_color = vert_color(vert_ok);
                    
                    for i=1:length(vert)
                        hold on, line([vert(i) vert(i)], [y_min y_max], 'Color', obj.color_list{vert_color(i)});
                    end
                end
                
                %add rectangles to plot
                idx_rec = (1:length(obj.event_starts))==obj.ind_event & obj.event_channels==ch;
                rec_st = obj.event_starts(idx_rec);
                rec_ok = rec_st>=x0 & rec_st<xf;
                rec_st = rec_st(rec_ok);
                if any(rec_st)
                    rec_dur = obj.event_durations(idx_rec);
                    rec_dur = rec_dur(rec_ok);
                    rec_label = obj.event_labels(idx_rec);
                    rec_color = obj.rec_colorlist{rec_label(rec_ok)+2};

                    if rec_st + rec_dur > xf
                        rec_dur = xf - rec_st;
                    end
                    x_rec = [rec_st, rec_st+rec_dur, rec_st+rec_dur, rec_st];
                    y_rec = [y_min, y_min, y_max, y_max];
                    hold on, patch(x_rec, y_rec, rec_color, 'EdgeColor', 'None', 'FaceAlpha', 0.2); 
                end
            end

            % Make the window visible.
            obj.fig.Visible = 'on';    
        end
        
        
        %% Events and Callback
        function key_pressed_fcn(obj,handle,event)
            switch get(obj.fig, 'CurrentKey')
                case 'leftarrow'
                    prev(obj)
                case 'rightarrow'
                    next(obj)
                case 'pagedown'
                    prev_event(obj,10)
                case 'pageup'
                    next_event(obj,10)
                case 'downarrow'
                    prev_event(obj)
                case 'uparrow'
                    next_event(obj)
                case 'numpad0'
                    label_event(obj,0); 
                case 'numpad1'
                    label_event(obj,1); 
            end
        end
        
        function slidind_Callback(obj,handle,event)
            obj.ind_event = floor(handle.Value);
            if obj.ind_event==0
               obj.ind_event = obj.nb_event;
            end
            [~, idx] = min(abs(obj.time_views-obj.time_events(obj.ind_event)));
            obj.ind = idx;
            plot_curve(obj)
        end
        
        
        % < >
        function prevbutton_Callback(obj,handle,event)
           prev_event(obj); 
        end
        function nextbutton_Callback(obj,handle,event)
           next_event(obj); 
        end
        
        % upArrow downArrow
        function prev_event(obj,steps)
            if nargin < 2
                steps = 1;
            end
            if ~isempty(obj.time_events)
                obj.ind_event = mod((obj.ind_event - steps), obj.nb_event);
                if obj.ind_event==0
                    obj.ind_event = obj.nb_event;
                end
                [~, idx] = min(abs(obj.time_views-obj.time_events(obj.ind_event)));
                obj.ind = idx;
                plot_curve(obj)
            end
        end
        function next_event(obj,steps)
            if nargin < 2
                steps = 1;
            end
            if ~isempty(obj.time_events)
                obj.ind_event = mod((obj.ind_event + steps), obj.nb_event);
                if obj.ind_event==0
                    obj.ind_event = obj.nb_event;
                end
                [~, idx] = min(abs(obj.time_views-obj.time_events(obj.ind_event)));
                obj.ind = idx;
                plot_curve(obj)
            end
        end
        
        %leftArrow rightArrow
        function prev(obj, steps)
           if nargin < 2
               steps = 1;
           end
           obj.ind = mod((obj.ind - steps), obj.nb_ind);
           if obj.ind==0
               obj.ind = obj.nb_ind;
           end
           plot_curve(obj)
        end

        function next(obj, steps)
           if nargin < 2
               steps = 1;
           end
           obj.ind = mod((obj.ind + steps), obj.nb_ind);
           if obj.ind==0
               obj.ind = obj.nb_ind;
           end
           plot_curve(obj)
        end
        
        %It is a slow wave - button 1
        function yesbutton_Callback(obj,handle,event)
           label_event(obj,1); 
        end
        
        %It is NOT a slow wave - button 0
        function nobutton_Callback(obj,handle,event)
           label_event(obj,0);
        end

        
        %% Update curves
        function plot_curve(obj)
            center = obj.time_views(obj.ind);
            if center > obj.before_disp + 1
                x0 = center - obj.before_disp;
            else
                x0 = 0;
            end
            if center + obj.after_disp <= obj.duration
                xf = center + obj.after_disp;
            else
                xf = obj.duration;
            end
            
            %Plot
            for ch=1:obj.nb_channel
                set(obj.fig,'CurrentAxes',obj.ax_list{ch});
                cla;
                xdata = obj.signals{ch}(1,:);
                t = obj.signals{ch}(1,xdata>=x0 & xdata<=xf);
                baseline = zeros(1, length(t)); 
                
                for k=2:size(obj.signals{ch},1)
                    ydata = obj.signals{ch}(k,xdata>=x0 & xdata<=xf);
                    plot(t,ydata,'LineWidth',1,'Color',obj.plot_colors{k}), hold on,
                end
                
                plot(t,baseline,'LineWidth',0.3, 'Color', [0.7 0.7,0.7]), 
                y_min = obj.ymins(ch);
                y_max = obj.ymaxs(ch);
                ylim([y_min y_max]);
                xlim([x0 xf]);
                
                %add verticals to plot
                if ~isempty(obj.verticals{ch})
                    vert = obj.verticals{ch};
                    vert_color = obj.vertical_colors{ch};
                    
                    vert_ok = vert>=x0 & vert<=xf;
                    vert = vert(vert_ok);
                    vert_color = vert_color(vert_ok);
                    
                    for i=1:length(vert)
                        hold on, line([vert(i) vert(i)], [y_min y_max], 'Color', obj.color_list{vert_color(i)});
                    end
                end
                
                %add rectangles to plot
                idx_rec = (1:length(obj.event_starts))==obj.ind_event & obj.event_channels==ch;
                rec_st = obj.event_starts(idx_rec);
                rec_ok = rec_st>=x0 & rec_st<xf;
                rec_st = rec_st(rec_ok);
                if any(rec_st)
                    rec_dur = obj.event_durations(idx_rec);
                    rec_dur = rec_dur(rec_ok);
                    rec_label = obj.event_labels(idx_rec);
                    rec_color = obj.rec_colorlist{rec_label(rec_ok)+2};

                    if rec_st + rec_dur > xf
                        rec_dur = xf - rec_st;
                    end
                    x_rec = [rec_st, rec_st+rec_dur, rec_st+rec_dur, rec_st];
                    y_rec = [y_min, y_min, y_max, y_max];
                    hold on, patch(x_rec, y_rec, rec_color, 'EdgeColor', 'None', 'FaceAlpha', 0.2); 
                end
            end
            
        end
        
        
        %% label data
        function label_event(obj,label)
           obj.event_labels(obj.ind_event)=label;
           next_event(obj);
        end
        
        %% save data
        function save_labels(obj,filename,subject)
            
            if ~exist('subject','var')
               subject = 0;
            end
            
            so_idx = (obj.event_labels>=0);
            
            so_start = obj.event_starts(so_idx);
            so_durations = obj.event_durations(so_idx);
            so_end = so_start + so_durations;
            so_channel = obj.event_channels(so_idx);
            so_labels = obj.event_labels(so_idx);
            
            if ~isempty(so_start)
                for i=1:length(so_start)
                    ch = so_channel(i);
                    xdata = obj.signals{ch}(1,obj.signals{ch}(1,:)>=so_start(i) & obj.signals{ch}(1,:)<=so_end(i));
                    ydata = obj.signals{ch}(2,obj.signals{ch}(1,:)>=so_start(i) & obj.signals{ch}(1,:)<=so_end(i));
                    waveforms{i} = tsd(xdata'*1E4,ydata');
                end
                labels = so_labels;
                durations = so_durations;
            
                save(filename, 'waveforms', 'labels','durations','subject')
            
            end
        end
        
    end
end




