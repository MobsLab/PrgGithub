function f1 = Display_CalibrationMFB_AB()
% GUI for Calibration Display
% Author AB (antoine.bergel[at]espci.fr
% Last Update 03/09/21

% str2 = '/media/nas6/ProjetReversalBehavior/CalibMFB';
% prompt = 'Select Calibration Directory';
% answer = get_lfp_directory(prompt,str2);
% 
% if isempty(answer)
%     return;
% elseif  ~isdir(char(answer))
%     error('Invalid Calibration Directory');
% else
%     seed = char(answer);
% end
seed = '/media/nas6/ProjetReversalBehavior/CalibMFB';

% Loading calibration files
d = dir(fullfile(seed,'*','*','NosePoke*'));
list_popup = unique({d(:).folder}');
list_popup = regexprep(list_popup,seed,'');
list_popup = regexprep(list_popup,'/M','M');
if isempty(list_popup)
    return;
end
list_popup=[{'*/*'};list_popup];


% Building Figure
f1 = figure('Units','normalized',...
    'HandleVisibility','Callback',...
    'IntegerHandle','off',...
    'Renderer','painters',...
    'MenuBar','none',...
    'Toolbar','figure',...
    'NumberTitle','off',...
    'Tag','MainFigure',...
    'PaperPositionMode','auto',...
    'Name','MFB Calibration Display');
%f1.DeleteFcn = {@delete_fcn};
set(f1,'Position',[.1 .1 .6 .6]);


%Parameters
L = 10;                      % Height top panels
l = 1;                       % Height info panel


% Panel1
iP = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','Panel1',...
    'Parent',f1);

e1 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','left',...
    'Parent',iP,...
    'String',seed,...
    'ToolTipString','Calibration Directory',...
    'Tag','Edit1');
p1 = uicontrol('Units','normalized',...
    'Style','popupmenu',...
    'Parent',iP,...
    'String',list_popup,...
    'ToolTipString','File Selection',...
    'Tag','Popup1');
b1 = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'HorizontalAlignment','center',...
    'String','Browse',...
    'Parent',iP,...
    'Tag','Button1');
b2 = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'HorizontalAlignment','center',...
    'String','Draw',...
    'Parent',iP,...
    'Tag','Button2');


% Panel2
mP = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','Panel2',...
    'Parent',f1);
ax1 = axes('Parent',mP,'Tag','Ax1');
ax2 = axes('Parent',mP,'Tag','Ax2');
ax3 = axes('Parent',mP,'Tag','Ax3');

% Position
iP.Position = [0 0 1 l/L];
mP.Position = [0 l/L 1 1-(l/L)];
e1.Position =       [0    .5    .8   .5];
b1.Position =       [.8    .5    .2   .5];
p1.Position =       [0    0    .8   .5];
b2.Position =       [.8    0    .2   .5];
ax1.Position =       [.1    .1    .4   .8];
ax2.Position =       [.6    .6    .3   .3];
ax3.Position =       [.6    .1    .3   .3];

% Callback attribution
handles = guihandles(f1);
set(handles.Button2,'Callback',{@display_Callback,handles});
set(handles.Button1,'Callback',{@browse_Callback,handles});
set(handles.Popup1,'Callback',{@display_Callback,handles});

end

function browse_Callback(~,~,handles)
handles.Edit1.String = uigetdir();
end

function display_Callback(~,~,handles)

handles.MainFigure.Pointer = 'watch';
drawnow;

seed = handles.Edit1.String;
remainder = char(handles.Popup1.String(handles.Popup1.Value,:));
path = fullfile(seed,remainder);
d = dir(fullfile(path,'NosePoke*'));

if isempty(d)
    error('Invalid calibration folder [%s]',path)
end

% Browse folder
voltage = NaN(length(d),1);
str_mfb = cell(length(d),1);
n_stims = NaN(length(d),1);
date_start = NaN(length(d),1);
date_end = NaN(length(d),1);
date_stims = NaN(length(d),50);
for i = 1:length(d)
    cur_path = char(d(i).folder);
    cur_folder = char(d(i).name);
    
    % voltage
    temp = regexp(cur_folder,'-','split');
    for j =1:length(temp)
        pattern = char(temp(j));
        if strcmp(pattern(end),'V')
            voltage(i) = str2num(pattern(1:end-1));
        elseif startsWith(pattern,'mfb','IgnoreCase',true)
            str_mfb{i} = char(pattern);
            
        end
    end
    
    % stim number & stim time
    dd = dir(fullfile(cur_path,cur_folder));
    ind_start = [dd(:).isdir]'.*contains({dd(:).name}','-0000');
    ind_end = contains({dd(:).name}','-0000.avi');
    ind_diary = contains({dd(:).name}','diary');
    if ~isempty(dd(ind_start==1))
        date_start(i) = dd(ind_start==1).datenum;
    end
    if ~isempty(dd(ind_end==1))
        date_end(i) = dd(ind_end==1).datenum;
    end

    % getting stims and stim times
    if ~isempty(dd(ind_diary==1))
        fid = fopen(fullfile(dd(ind_diary==1).folder,dd(ind_diary==1).name),'r');
        % reading diary
        all_lines=[];
        while ~feof(fid)
            all_lines=[all_lines;fgetl(fid)];
        end
        fclose(fid); 
        n_stims(i) = size(all_lines,1);
        date_stims(i,1:n_stims(i))=datenum(datestr(all_lines))';    
   end
    
end

% reformat date times to seconds
t_stims = (date_stims-repmat(date_start,[1 50]))*24*3600;
mean_ipi = mean(diff(t_stims'),'omitnan')';

% Draw results
ax = handles.Ax1;
cla(ax);
% line('XData',voltage,'YData',n_stims,'Parent',ax,...
%     'LineStyle','none',Marker,'o');
plot(voltage,n_stims,'ks','Parent',ax);
ax.XLabel.String= 'Voltage(V)';
ax.YLabel.String= '# stims';
ax.YLim = [0 50];
ax.XLim = [0 10];
grid(ax,'on');
ax.Title.String = 'Calibration Curve';

ax = handles.Ax2;
cla(ax);
% line('XData',voltage,'YData',n_stims,'Parent',ax,...
%     'LineStyle','none',Marker,'o');
plot(voltage,t_stims(:,1),'bo','Parent',ax);
ax.XLabel.String= 'Voltage(V)';
ax.YLabel.String= 'Time (s)';
%ax.YLim = [0 50];
ax.XLim = [0 10];
grid(ax,'on');
ax.Title.String = 'Timing 1st poke';

ax = handles.Ax3;
cla(ax);
plot(voltage,mean_ipi,'ro','Parent',ax);
ax.XLabel.String= 'Voltage(V)';
ax.YLabel.String= 'Time (s)';
%ax.YLim = [0 50];
ax.XLim = [0 10];
grid(ax,'on');
ax.Title.String = 'Inter-Poke Interval';

handles.MainFigure.Pointer = 'arrow';

end
