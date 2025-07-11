function f1 = GUI_Wavelet_Analysis_AB()
% GUI for Wavelet Analysis (in progress)
% Author AB (antoine.bergel[at]espci.fr
% Last Update 30/08/21

str2 = '/home/mobshamilton/Documents/MATLAB/LFP_data';
answer = get_lfp_directory('Select LFP directory',str2);

if isempty(answer)
    return;
elseif  ~isdir(char(answer))
    error('Invalid LFP Directory');
else
    seed = char(answer);
end

% Loading Traces
all_traces = struct('name',[],'folder',[],'X',[],'Y',[],'f_samp',[]);
d_lfp = dir(fullfile(seed,'LFP_*.mat'));
d_theta = dir(fullfile(seed,'LFP-theta_*.mat'));
d_all = [d_lfp;d_theta];
for i =1:length(d_all)
    all_traces(i).name = strrep(char(d_all(i).name),'_','/');
    all_traces(i).name = strrep(all_traces(i).name,'.mat','');
    all_traces(i).folder = char(d_all(i).folder);  
    data_lfp = load(fullfile(char(d_all(i).folder),char(d_all(i).name)));    
    all_traces(i).X = (data_lfp.x_start:data_lfp.f:data_lfp.x_end)';
    all_traces(i).Y = data_lfp.Y;
    all_traces(i).f_samp = 1/data_lfp.f;
    fprintf('LFP Data loaded [%s].\n',all_traces(i).name);
end


%Sorting LFP channels according to configuration
temp_ = {all_traces(:).name}';
ind_1 = find(~(cellfun('isempty',strfind(temp_,'LFP/')))==1);
ind_2 = find(~(cellfun('isempty',strfind(temp_,'LFP-theta/')))==1);


%Return if LFP channels are missing
if sum(ind_1)==0
    errordlg('No LFP channels found [%s].\n',seed);
    return;
end
if sum(ind_2)==0 || length(ind_2)<length(ind_1)
    warning('LFP-theta and LFP channels do not match. Mode spectrogramm only.');
    cb4_enable = 'off';
    cb12_enable = 'off';
else
    cb4_enable = 'on';
    cb12_enable = 'on';
end

traces_name = temp_(ind_1);
phases_name = temp_(ind_2);
traces = all_traces(ind_1);
phases = all_traces(ind_2);


% Finding start and end time
t_start = all_traces(1).X(1);
t_end = all_traces(1).X(end);
t_end_str = datestr(t_end/(24*3600),'HH:MM:SS.FFF');
t_start_str = datestr(t_start/(24*3600),'HH:MM:SS.FFF');


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
    'Name',sprintf('LFP Wavelet Analysis [%s]',seed));
%f1.DeleteFcn = {@delete_fcn};
set(f1,'Position',[.1 .1 .6 .6]);
clrmenu(f1);

%Parameters
channels = 0;                % # channels (top) 
bands = min(length(traces),8);      % # lfp (bottom)
% bands = 2;                   % # lfp (bottom)
L = 10;                      % Height top panels
l = 1;                       % Height info panel
cb1_def = 1;                 % freq correction
cb2_def = 0;                 % log scale
cb3_def = 1;                 % linkaxes all channels
cb4_def = 1;                 % early break (spectrogramm only)
cb11_def = 1;                % lfp display
cb12_def = 0;                % lfp filtered
cb21_def = 1;                % Hold on for spectrogram
cb31_def = 1;                % Hold on frequency coupling
cb32_def = 1;                % Ascend/Descend frequency coupling

delta = L-l;
N = channels+bands;
% Information Panel
iP = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','InfoPanel',...
    'Parent',f1);
iP.Position = [0 0 1 l/L];

efc = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String',2,...
    'Tag','Fc',...
    'Tooltipstring','Center Frequency');
efb = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String',2,...
    'Tag','Fb',...
    'Tooltipstring','Bandwidth');
efd = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String',1,...%.5
    'Tag','fdom_step',...
    'Tooltipstring','Step Frequency');

efa = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String',1.5,...
    'Tag','EditAutoscale',...
    'Tooltipstring','Autoscale factor');
efr = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String',1,...
    'Tag','EditGaussian',...
    'Tooltipstring','Gaussian smoothing (s)');
exc = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String',.5,...
    'Tag','EditExpCor',...
    'Tooltipstring','Exponential Correction factor');

pu = [];
for i=1:8
    p = uicontrol('Units','normalized',...
        'Style','popupmenu',... 
        'Parent',iP,...
        'String',sprintf('Popup%d',i),...
        'ToolTipString',sprintf('Ax%d',i),...
        'Visible','off',...
        'Tag',sprintf('Popup%d',i));
    p.UserData.index=i;
    %p.UserData.previous='';
    pu = [pu;p];
end
%Storing all_popups
f1.UserData.all_popups = pu;


e1 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Tooltipstring','Start Time',...
    'String',t_start_str,...
    'Parent',iP,...
    'Tag','Edit1');
e2 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Tooltipstring','End Time',...
    'String',t_end_str,...
    'Parent',iP,...
    'Tag','Edit2');
e2b = uicontrol('Units','normalized',...
    'Style','text',...
    'HorizontalAlignment','center',...
    'Tooltipstring','Current Time',...
    'String',t_start_str,...
    'Parent',iP,...
    'Tag','Edit2b');
e3 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String',channels,...
    'Tag','Edit3',...
    'Enable','off',...
    'Tooltipstring','# Trace Channels');
e4 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String',bands,...
    'Tag','Edit4',...
    'Tooltipstring','# LFP bands');
e5 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String','0.025',...
    'Tag','Edit5',...
    'Tooltipstring','Margin');
e6 = uicontrol('Units','normalized',...
    'Style','edit',...
    'HorizontalAlignment','center',...
    'Parent',iP,...
    'String','0.1',...
    'Tag','Edit6',...
    'Tooltipstring','Button Size');
cb1 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'Parent',iP,...
    'Value',cb1_def,...
    'Tag','Checkbox1',...
    'Tooltipstring','Multiply by n');
cb2 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'Parent',iP,...
    'Value',cb2_def,...
    'Tag','Checkbox2',...
    'Tooltipstring','Logarithmic Scale');
cb3 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'Parent',iP,...
    'Value',cb3_def,...
    'Tag','Checkbox3',...
    'Tooltipstring','Linkaxes all channels');
cb4 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'Parent',iP,...
    'Value',cb4_def,...
    'Enable',cb4_enable,...
    'Tag','Checkbox4',...
    'Tooltipstring','Early break (spectrogramm only)');

bl = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Reload',...
    'Tag','ButtonReload',...
    'Enable','off');
br = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Reset',...
    'Tag','ButtonReset');
bc = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Compute',...
    'Tag','ButtonCompute');
ba = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Autoscale',...
    'Tag','ButtonAutoScale');
be = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Export',...
    'Tag','ButtonExport',...
    'Enable','off');
bss = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Save Stats',...
    'Tag','ButtonSaveStats',...
    'Enable','off');
bsi = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Save Image',...
    'Tag','ButtonSaveImage',...
    'Enable','off');
bbs = uicontrol('Units','normalized',...
    'Style','pushbutton',...
    'Parent',iP,...
    'String','Batch Save',...
    'Tag','ButtonBatchSave',...
    'Enable','off');

% Info Panel Position
ipos = [0 0 1 1];
%t1.Position =       [ipos(3)/100     ipos(4)/2    4*ipos(3)/20   ipos(4)/2];
pu(1).Position=     [0     0    ipos(3)/12   ipos(4)/2];
pu(2).Position=     [ipos(3)/12     0   ipos(3)/12   ipos(4)/2];
pu(3).Position=     [ipos(3)/6     0    ipos(3)/12   ipos(4)/2];
pu(4).Position=     [3*ipos(3)/12     0    ipos(3)/12   ipos(4)/2];
pu(5).Position=     [0     ipos(4)/2    ipos(3)/12   ipos(4)/3];
pu(6).Position=     [ipos(3)/12     ipos(4)/2    ipos(3)/12   ipos(4)/3];
pu(7).Position=     [ipos(3)/6     ipos(4)/2    ipos(3)/12   ipos(4)/3];
pu(8).Position=     [3*ipos(3)/12     ipos(4)/2    ipos(3)/12   ipos(4)/3];
efc.Position = [7*ipos(3)/20     5.5*ipos(4)/10   ipos(3)/20   3.5*ipos(4)/10];
efd.Position = [8*ipos(3)/20     5.5*ipos(4)/10   ipos(3)/20   3.5*ipos(4)/10];
efb.Position = [9*ipos(3)/20     5.5*ipos(4)/10   ipos(3)/20   3.5*ipos(4)/10];
efa.Position = [7*ipos(3)/20     ipos(4)/10   ipos(3)/20   3.5*ipos(4)/10];
efr.Position = [8*ipos(3)/20     ipos(4)/10   ipos(3)/20   3.5*ipos(4)/10];
exc.Position = [9*ipos(3)/20     ipos(4)/10   ipos(3)/20   3.5*ipos(4)/10];

e1.Position = [5.2*ipos(3)/10     6.5*ipos(4)/10   ipos(3)/12   3*ipos(4)/10];
e2.Position = [5.2*ipos(3)/10     0           ipos(3)/12   3*ipos(4)/10];
e2b.Position = [5.2*ipos(3)/10     3.25*ipos(4)/10           ipos(3)/12   3*ipos(4)/10];

e3.Position = [6.5*ipos(3)/10     2.75*ipos(4)/5   ipos(3)/20   3.5*ipos(4)/10];
e4.Position = [6.5*ipos(3)/10     ipos(4)/10   ipos(3)/20   3.5*ipos(4)/10];
e5.Position = [6*ipos(3)/10      2.75*ipos(4)/5           ipos(3)/20   3.5*ipos(4)/10];
e6.Position = [6*ipos(3)/10     ipos(4)/10           ipos(3)/20   3.5*ipos(4)/10];
cb1.Position = [10*ipos(3)/20     3*ipos(4)/4           ipos(3)/50   ipos(4)/4];
cb2.Position = [10*ipos(3)/20     2*ipos(4)/4           ipos(3)/50   ipos(4)/4];
cb3.Position = [10*ipos(3)/20     ipos(4)/4           ipos(3)/50   ipos(4)/4];
cb4.Position = [10*ipos(3)/20     0           ipos(3)/50   ipos(4)/4];

bl.Position = [7*ipos(3)/10     ipos(4)/2     .75*ipos(3)/10   4.5*ipos(4)/10];
br.Position = [7.75*ipos(3)/10     ipos(4)/2     .75*ipos(3)/10   4.5*ipos(4)/10];
bc.Position = [8.5*ipos(3)/10     ipos(4)/2     .75*ipos(3)/10   4.5*ipos(4)/10];
ba.Position = [9.25*ipos(3)/10     ipos(4)/2      .75*ipos(3)/10   4.5*ipos(4)/10];
be.Position = [7*ipos(3)/10     0      .75*ipos(3)/10    4.5*ipos(4)/10];
bss.Position = [7.75*ipos(3)/10     0      .75*ipos(3)/10    4.5*ipos(4)/10];
bsi.Position = [8.5*ipos(3)/10     0      .75*ipos(3)/10    4.5*ipos(4)/10];
bbs.Position = [9.25*ipos(3)/10     0      .75*ipos(3)/10    4.5*ipos(4)/10];

% Top Panel

%Botton Tab Group
mP = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','MainBotPanel',...
    'Parent',f1);
mP.Position = [0 l/L 1 (bands/N)*delta/L];

tabgp = uitabgroup('Units','normalized',...
    'Position',[0 0 1 1],...
    'Parent',mP,...
    'Tag','TabGroup');
tab0 = uitab('Parent',tabgp,...
    'Title','Traces',...
    'Tag','MainTab');
tab1 = uitab('Parent',tabgp,...
    'Title','Time-Frequency',...
    'Tag','FirstTab');
tab2 = uitab('Parent',tabgp,...
    'Title','Phase-Frequency',...
    'Tag','SecondTab');
tab3 = uitab('Parent',tabgp,...
    'Title','Frequency Coupling',...
    'Tag','ThirdTab');
tab4 = uitab('Parent',tabgp,...
    'Title','Correlation',...
    'Tag','FourthTab');

% Bottom Panels
bP = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','BotPanel',...
    'Position',[0 0 1 1],...
    'Parent',tab0);
uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','FirstBotPanel',...
    'Position',[0 0 1 1],...
    'Parent',tab1);
sbP = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','SecondBotPanel',...
    'Position',[0 0 1 1],...
    'Parent',tab2);
tbP = uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','ThirdBotPanel',...
    'Position',[0 0 1 1],...
    'Parent',tab3);
uipanel('Units','normalized',...
    'bordertype','etchedin',...
    'Tag','FourthBotPanel',...
    'Position',[0 0 1 1],...
    'Parent',tab4);

% handles.ScaleButton
sb = uicontrol('Style','togglebutton',...
    'Units','normalized',...
    'String','Scale',...
    'TooltipString','Scale Traces',...
    'Value',0,...
    'Tag','ScaleButton',...
    'Parent',bP);
mb = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','-',...
    'TooltipString','Zoom out',...
    'Tag','MinusButton',...
    'Parent',bP);
pb = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','+',...
    'TooltipString','Zoom in',...
    'Tag','PlusButton',...
    'Parent',bP);
rb = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','<->',...
    'TooltipString','Rescale',...
    'Tag','RescaleButton',...
    'Parent',bP);
bb = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','<<',...
    'TooltipString','Backward Step',...
    'Tag','BackButton',...
    'Parent',bP);
skb = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','>>',...
    'TooltipString','Forward Step',...
    'Tag','SkipButton',...
    'Parent',bP);
% handles.TagButton
tb = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','Tags',...
    'TooltipString','Tag Selection',...
    'UserData','',...
    'Enable','off',...
    'Tag','TagButton',...
    'Parent',bP);
% handles.nextTagButton
ntb = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','T >>',...
    'TooltipString','Next Tag',...
    'Tag','nextTagButton',...
    'Enable','off',...
    'Parent',bP);
% handles.prevTagButton
ptb = uicontrol('Style','pushbutton',...
    'Units','normalized',...
    'String','<< T',...
    'TooltipString','Previous Tag',...
    'Tag','prevTagButton',...
    'Enable','off',...
    'Parent',bP);


% % Checkbox Time Patches
% cb_tp = copyobj(myhandles.TimePatchBox,tP);
% %cb_tp.Tag = 'TimePatchBox';
% cb_tp.Units='normalized';

% BotPanel
bpos = [0 0 1 1];
sb.Position=[bpos(3)*56/60 bpos(4)*8.5/10 bpos(3)*3/60 bpos(4)/10];
mb.Position=[bpos(3)*56/60 bpos(4)*7.5/10 bpos(3)*3/60 bpos(4)/10];
pb.Position=[bpos(3)*56/60 bpos(4)*6.5/10 bpos(3)*3/60 bpos(4)/10];
rb.Position=[bpos(3)*56/60 bpos(4)*5.5/10 bpos(3)*3/60 bpos(4)/10];
bb.Position=[bpos(3)*56/60 bpos(4)*4.5/10 bpos(3)*3/60 bpos(4)/10];
skb.Position=[bpos(3)*56/60 bpos(4)*3.5/10 bpos(3)*3/60 bpos(4)/10];
tb.Position=[bpos(3)*56/60 bpos(4)*2.5/10 bpos(3)*3/60 bpos(4)/10];
ptb.Position=[bpos(3)*56/60 bpos(4)*1.5/10 bpos(3)*3/60 bpos(4)/10];
ntb.Position=[bpos(3)*56/60 bpos(4)*.5/10 bpos(3)*3/60 bpos(4)/10];

cb11 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'Parent',bP,...
    'Value',cb11_def,...
    'Tag','Checkbox11',...
    'Tooltipstring','LFP trace');
cb12 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'Parent',bP,...
    'Value',cb12_def,...
    'Enable',cb12_enable,...
    'Tag','Checkbox12',...
    'Tooltipstring','LFP filtered');
cb21 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'HorizontalAlignment','center',...
    'Parent',sbP,...
    'Value',cb21_def,...
    'Tag','BoxHold1',...
    'Tooltipstring','Hold on/off');
cb31 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'HorizontalAlignment','center',...
    'Parent',tbP,...
    'Value',cb31_def,...
    'Tag','BoxHold2',...
    'Tooltipstring','Hold on/off');
cb32 = uicontrol('Units','normalized',...
    'Style','checkbox',...
    'HorizontalAlignment','center',...
    'Parent',tbP,...
    'Value',cb32_def,...
    'Tag','Checkbox32',...
    'Tooltipstring','Ascend/Descend');
cb11.Position = [0 0 .02 .04];
cb12.Position = [0 .04 .02 .04];
cb21.Position = [.98 0 .02 .04];
cb31.Position = [.98 0 .02 .04];
cb32.Position = [.98 .04 .02 .04];

handles2 = guihandles(f1) ;
if ~isempty(handles2.TagButton.UserData)&&length(handles2.TagButton.UserData.Selected)>1
    handles2.TagButton.UserData=[];
end

%Feeding traces to Button Compute
% bc.UserData.traces = flipud(traces);
% bc.UserData.phases = flipud(phases);
% bc.UserData.traces_name = flipud(traces_name);
% bc.UserData.phases_name = flipud(phases_name);
bc.UserData.traces = traces;
bc.UserData.phases = phases;
bc.UserData.traces_name = traces_name;
bc.UserData.phases_name = phases_name;
bc.UserData.save_data = [];

handles1 = guihandles(f1);
handles2 = reset_Callback(br,[],handles1);
colormap(f1,'jet');
edit_Callback([handles2.Edit1 handles2.Edit2],[],handles2.CenterAxes);

end

function initialize_botPanel(handles)

fmin = 1;
fmax = 150;
bands = str2double(handles.Edit4.String);
bot_axes = findobj(handles.BotPanel,'Type','axes');
l = length(bot_axes);
    
if bands>l
    %create
    for k=l+1:bands
        %BotPanel
        axes('Parent',handles.BotPanel,'Tag',sprintf('Ax%d',k));
        
        %FirstBotPanel
        ax = axes('Parent',handles.FirstBotPanel,'Tag',sprintf('Ax%d',k));
        ax.YLim = [fmin fmax];
        c = colorbar(ax,'Tag',sprintf('Colorbar%d',k));
        uicontrol('Units','normalized',...
            'Style','edit',...
            'HorizontalAlignment','center',...
            'Parent',handles.FirstBotPanel,...
            'String',fmin,...
            'Tag',sprintf('fdom_min_%d',k),...
            'Callback',{@update_yaxis,ax,1,handles},...
            'Tooltipstring',sprintf('Min Frequency %d',k));
        uicontrol('Units','normalized',...
            'Style','edit',...
            'HorizontalAlignment','center',...
            'Parent',handles.FirstBotPanel,...
            'String',fmax,...
            'Tag',sprintf('fdom_max_%d',k),...
            'Callback',{@update_yaxis,ax,2,handles},...
            'Tooltipstring',sprintf('Max Frequency %d',k));
        uicontrol('Units','normalized',...
            'Style','edit',...
            'HorizontalAlignment','center',...
            'Parent',handles.FirstBotPanel,...
            'String',0,...
            'Tag',sprintf('cmin_%d',k),...
            'Callback', {@update_caxis,ax,c,1},...
            'Tooltipstring',sprintf('Colormin %d',k));
        uicontrol('Units','normalized',...
            'Style','edit',...
            'HorizontalAlignment','center',...
            'Parent',handles.FirstBotPanel,...
            'String',1,...
            'Tag',sprintf('cmax_%d',k),...
            'Callback', {@update_caxis,ax,c,2},...
            'Tooltipstring',sprintf('Colormax %d',k));
        
        %SecondBotPanel
        ax = axes('Parent',handles.SecondBotPanel,'Tag',sprintf('Ax%d',k));
        ax.YLim = [fmin fmax];
        ax.Title.String = sprintf('Theta-Phase %d',k);
        % 2nd axes
        ax2 = axes('Parent',handles.SecondBotPanel,'Tag',sprintf('Ax%d_r',k));
        ax2.Title.String = sprintf('2nd Theta-Phase %d',k);
        
        c = colorbar(ax,'Tag',sprintf('Colorbar%d',k));
        uicontrol('Units','normalized',...
            'Style','edit',...
            'HorizontalAlignment','center',...
            'Parent',handles.SecondBotPanel,...
            'String',fmin,...
            'Tag',sprintf('fdom_min_%d',k),...
            'Callback',{@update_yaxis,ax,1,handles},...
            'Tooltipstring',sprintf('Min Frequency %d',k));
        uicontrol('Units','normalized',...
            'Style','edit',...
            'HorizontalAlignment','center',...
            'Parent',handles.SecondBotPanel,...
            'String',fmax,...
            'Tag',sprintf('fdom_max_%d',k),...
            'Callback',{@update_yaxis,ax,2,handles},...
            'Tooltipstring',sprintf('Max Frequency %d',k));
        uicontrol('Units','normalized',...
            'Style','edit',...
            'HorizontalAlignment','center',...
            'Parent',handles.SecondBotPanel,...
            'String',0,...
            'Tag',sprintf('cmin_%d',k),...
            'Callback', {@update_caxis,[ax;ax2],c,1},...
            'Tooltipstring',sprintf('Colormin %d',k));
        uicontrol('Units','normalized',...
            'Style','edit',...
            'HorizontalAlignment','center',...
            'Parent',handles.SecondBotPanel,...
            'String',1,...
            'Tag',sprintf('cmax_%d',k),...
            'Callback', {@update_caxis,[ax;ax2],c,2},...
            'Tooltipstring',sprintf('Colormax %d',k));
        %Spectrogram
        ax = axes('Parent',handles.SecondBotPanel,'Tag',sprintf('Ax%d_s',k));
        ax.Title.String = sprintf('Spectrogram %d',k);
        
        %ThirdBotPanel
        ax = axes('Parent',handles.ThirdBotPanel,'Tag',sprintf('Ax%d',k));
        uicontrol('Units','normalized','Style','edit','HorizontalAlignment','center',...
            'Parent',handles.ThirdBotPanel,'String',0,'Tag',sprintf('ymin_low%d',k),...
            'Callback',{@update_yaxis,ax,1,handles},'Tooltipstring',sprintf('ymin_low%d',k));
        uicontrol('Units','normalized','Style','edit','HorizontalAlignment','center',...
            'Parent',handles.ThirdBotPanel,'String',1,'Tag',sprintf('ymax_low%d',k),...
            'Callback',{@update_yaxis,ax,2,handles},'Tooltipstring',sprintf('ymax_low%d',k));
        ax.Title.String = sprintf('Gamma-low %d',k);
        % Mid Gamma
        ax = axes('Parent',handles.ThirdBotPanel,'Tag',sprintf('Ax%d_mid',k));
        uicontrol('Units','normalized','Style','edit','HorizontalAlignment','center',...
            'Parent',handles.ThirdBotPanel,'String',0,'Tag',sprintf('ymin_mid%d',k),...
            'Callback',{@update_yaxis,ax,1,handles},'Tooltipstring',sprintf('ymin_mid%d',k));
        uicontrol('Units','normalized','Style','edit','HorizontalAlignment','center',...
            'Parent',handles.ThirdBotPanel,'String',1,'Tag',sprintf('ymax_mid%d',k),...
            'Callback',{@update_yaxis,ax,2,handles},'Tooltipstring',sprintf('ymax_mid%d',k));
        ax.Title.String = sprintf('Gamma-mid %d',k);
        % High Gamma
        ax = axes('Parent',handles.ThirdBotPanel,'Tag',sprintf('Ax%d_high',k));
        uicontrol('Units','normalized','Style','edit','HorizontalAlignment','center',...
            'Parent',handles.ThirdBotPanel,'String',0,'Tag',sprintf('ymin_high%d',k),...
            'Callback',{@update_yaxis,ax,1,handles},'Tooltipstring',sprintf('ymin_high%d',k));
        uicontrol('Units','normalized','Style','edit','HorizontalAlignment','center',...
            'Parent',handles.ThirdBotPanel,'String',1,'Tag',sprintf('ymax_high%d',k),...
            'Callback',{@update_yaxis,ax,2,handles},'Tooltipstring',sprintf('ymax_high%d',k));
        ax.Title.String = sprintf('Gamma-high %d',k);
        
        %FourthBotPanel
        ax = axes('Parent',handles.FourthBotPanel,'Tag',sprintf('Ax%d',k));
        ax.Title.String = sprintf('Gamma-low %d',k);
        % Mid Gamma
        ax = axes('Parent',handles.FourthBotPanel,'Tag',sprintf('Ax%d_mid',k));
        ax.Title.String = sprintf('Gamma-mid %d',k);
        % High Gamma
        ax = axes('Parent',handles.FourthBotPanel,'Tag',sprintf('Ax%d_high',k));
        ax.Title.String = sprintf('Gamma-high %d',k);
        
    end
elseif bands < l
    %delete
    for k=bands+1:l
        delete(findobj(handles.BotPanel,'Tag',sprintf('Ax%d',k)));
        
        delete(findobj(handles.FirstBotPanel,'Tag',sprintf('Ax%d',k)));
        delete(findobj(handles.FirstBotPanel,'Tag',sprintf('Colorbar%d',k)));
        delete(findobj(handles.FirstBotPanel,'Tag',sprintf('fdom_min_%d',k)));
        delete(findobj(handles.FirstBotPanel,'Tag',sprintf('fdom_max_%d',k)));
        delete(findobj(handles.FirstBotPanel,'Tag',sprintf('cmax_%d',k)));
        delete(findobj(handles.FirstBotPanel,'Tag',sprintf('cmin_%d',k)));
        
        delete(findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d',k)));
        delete(findobj(handles.SecondBotPanel,'Tag',sprintf('Colorbar%d',k)));
        delete(findobj(handles.SecondBotPanel,'Tag',sprintf('fdom_min_%d',k)));
        delete(findobj(handles.SecondBotPanel,'Tag',sprintf('fdom_max_%d',k)));
        delete(findobj(handles.SecondBotPanel,'Tag',sprintf('cmax_%d',k)));
        delete(findobj(handles.SecondBotPanel,'Tag',sprintf('cmin_%d',k)));
        delete(findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d_r',k)));
        delete(findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d_s',k)));
        
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d',k)));
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('ymin_low%d',k)));
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('ymax_low%d',k)));
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d_mid',k)));
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('ymin_mid%d',k)));
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('ymax_mid%d',k)));
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d_high',k)));
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('ymin_high%d',k)));
        delete(findobj(handles.ThirdBotPanel,'Tag',sprintf('ymax_high%d',k)));
        
        delete(findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d',k)));
        delete(findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d_mid',k)));
        delete(findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d_high',k)));
    end
else
    % Delete images if bands == l 
    delete(findobj(handles.MainFigure,'Tag','Image'));
    delete(findobj(handles.MainFigure,'Tag','Spectro'));
    delete(findobj(handles.MainFigure,'Tag','Spectro_ascend'));
    delete(findobj(handles.MainFigure,'Tag','Spectro_descend'));
    delete(findobj(handles.MainFigure,'Tag','Corr_low','-or','Tag','Corr_low_bar'));
    delete(findobj(handles.MainFigure,'Tag','Corr_mid','-or','Tag','Corr_mid_bar'));
    delete(findobj(handles.MainFigure,'Tag','Corr_high','-or','Tag','Corr_high_bar'));
    delete(findobj(handles.MainFigure,'Tag','Legend'));
end

% Position
bpos = [0 0 1 1];
N = length(findobj(handles.BotPanel,'Type','axes'));
margin = str2double(handles.Edit5.String);
w_button = .03;
h_button = 3*str2double(handles.Edit6.String)/N;
%w_button = str2double(handles.Edit6.String);
%h_button = 2*w_button;
w_box = .05;
c_margin = .02;
for k = 1:N
    % BotPanel
    ax = findobj(handles.BotPanel,'Tag',sprintf('Ax%d',k));
    ax.Position = [.07 ((N-k)/N)+margin .86 (1/N)-(2*margin)];
    
    % FirstBotPanel
    ax = findobj(handles.FirstBotPanel,'Tag',sprintf('Ax%d',k));
    ax.Position = [.07 ((N-k)/N)+margin .86 (1/N)-(2*margin)];
    c = findobj(handles.FirstBotPanel,'Tag',sprintf('Colorbar%d',k));
    c.Position = [1-w_button ((N-k)/N)+h_button+c_margin w_button/2 1/N-(2*(h_button+c_margin))];
    % Left buttons
    b1 = findobj(handles.FirstBotPanel,'Tag',sprintf('fdom_min_%d',k));
    b1.Position = [bpos(3)*.25/60 ((N-k)/N*bpos(4)) w_button h_button];
    b2 = findobj(handles.FirstBotPanel,'Tag',sprintf('fdom_max_%d',k));
    b2.Position = [bpos(3)*.25/60 ((N-k+1)/N*bpos(4))-h_button w_button h_button];
    % Right buttons
    b6 = findobj(handles.FirstBotPanel,'Tag',sprintf('cmin_%d',k));
    b6.Position = [bpos(3)-w_button ((N-k)/N*bpos(4)) w_button h_button];
    b7 = findobj(handles.FirstBotPanel,'Tag',sprintf('cmax_%d',k));
    b7.Position = [bpos(3)-w_button ((N-k+1)/N*bpos(4))-h_button w_button h_button];
    
    % SecondPanel
    ax = findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d',k));
    ax.Position = [.07 ((N-k)/N)+margin .27 (1/N)-(2*margin)];
    ax2 = findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d_r',k));
    ax2.Position = [.37 ((N-k)/N)+margin .27 (1/N)-(2*margin)];
    c = findobj(handles.SecondBotPanel,'Tag',sprintf('Colorbar%d',k));
    c.Position = [1-w_button-.3 ((N-k)/N)+h_button+c_margin w_button/2 1/N-(2*(h_button+c_margin))];
    % Left buttons
    b1 = findobj(handles.SecondBotPanel,'Tag',sprintf('fdom_min_%d',k));
    b1.Position = [bpos(3)*.25/60 ((N-k)/N*bpos(4)) w_button h_button];
    b2 = findobj(handles.SecondBotPanel,'Tag',sprintf('fdom_max_%d',k));
    b2.Position = [bpos(3)*.25/60 ((N-k+1)/N*bpos(4))-h_button w_button h_button];
    % Right Buttons
    b6 = findobj(handles.SecondBotPanel,'Tag',sprintf('cmin_%d',k));
    b6.Position = [bpos(3)-w_button-.3 ((N-k)/N*bpos(4)) w_button h_button];
    b7 = findobj(handles.SecondBotPanel,'Tag',sprintf('cmax_%d',k));
    b7.Position = [bpos(3)-w_button-.3 ((N-k+1)/N*bpos(4))-h_button w_button h_button];
    % Spectrogram
    ax = findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d_s',k));
    ax.Position = [.75 ((N-k)/N)+margin .2 (1/N)-(2*margin)];
    
    % ThirdBotPanel
    ax = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d',k));
    ax.Position = [.07 ((N-k)/N)+margin .25 (1/N)-(2*margin)];
    b1 = findobj(handles.ThirdBotPanel,'Tag',sprintf('ymin_low%d',k));
    b1.Position = [bpos(3)*.25/60 ((N-k)/N*bpos(4)) w_button h_button];
    b2 = findobj(handles.ThirdBotPanel,'Tag',sprintf('ymax_low%d',k));
    b2.Position = [bpos(3)*.25/60 ((N-k+1)/N*bpos(4))-h_button w_button h_button];
    % Mid
    ax = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d_mid',k));
    ax.Position = [.375 ((N-k)/N)+margin .25 (1/N)-(2*margin)];
    b1 = findobj(handles.ThirdBotPanel,'Tag',sprintf('ymin_mid%d',k));
    b1.Position = [.365-w_button ((N-k)/N*bpos(4)) w_button h_button];
    b2 = findobj(handles.ThirdBotPanel,'Tag',sprintf('ymax_mid%d',k));
    b2.Position = [.365-w_button ((N-k+1)/N*bpos(4))-h_button w_button h_button];
    % High
    ax = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d_high',k));
    ax.Position = [.68 ((N-k)/N)+margin .25 (1/N)-(2*margin)];
    b1 = findobj(handles.ThirdBotPanel,'Tag',sprintf('ymin_high%d',k));
    b1.Position = [.67-w_button ((N-k)/N*bpos(4)) w_button h_button];
    b2 = findobj(handles.ThirdBotPanel,'Tag',sprintf('ymax_high%d',k));
    b2.Position = [.67-w_button ((N-k+1)/N*bpos(4))-h_button w_button h_button];
    
    % ThirdBotPanel
    ax = findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d',k));
    ax.Position = [.07 ((N-k)/N)+margin .25 (1/N)-(2*margin)];
    ax = findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d_mid',k));
    ax.Position = [.35 ((N-k)/N)+margin .25 (1/N)-(2*margin)];
    ax = findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d_high',k));
    ax.Position = [.63 ((N-k)/N)+margin .25 (1/N)-(2*margin)];     
end

end

function resize_Figure(~,~,handles)

% Main Figure resize function
channels = str2double(handles.Edit3.String);
bands = str2double(handles.Edit4.String);
N = channels+bands;
L = 10;
l = 1;
delta = L-l;

%handles.TopPanel.Position = [0 (l+(bands/N)*delta)/L 1 (channels/N)*delta/L];
handles.MainBotPanel.Position = [0 l/L 1 (bands/N)*delta/L];
handles.InfoPanel.Position = [0 0 1 l/L];

end

function handles = reset_Callback(hObj,~,handles1)

initialize_botPanel(handles1);
handles = guihandles(hObj.Parent.Parent);

%Setting CenterAxes
handles.CenterAxes = findobj(handles.BotPanel,'Tag','Ax1');
all_topaxes = [];
all_botaxes = findobj(handles.BotPanel,'Type','Axes');
all_firstaxes = findobj(handles.FirstBotPanel,'Type','Axes');
all_axes = [all_topaxes;all_botaxes;all_firstaxes];

% Resize Function Attribution
set(handles.MainFigure,'ResizeFcn',{@resize_Figure,handles});
resize_Figure([],[],handles);

% Callback function Attribution
bands = str2double(handles.Edit4.String);
for i=1:bands
    pu = findobj(handles.InfoPanel,'Tag',sprintf('Popup%d',i));
    if strcmp(pu.Visible,'off')
        pu.Visible = 'on';
        traces_name = handles.ButtonCompute.UserData.traces_name;
        pu.String = traces_name;
        pu.Value = mod((i-1),length(traces_name))+1;
    end
    ax = findobj(handles.BotPanel,'Tag',sprintf('Ax%d',i));
    pu.Callback = {@update_popup_Callback,ax,handles};
    update_popup_Callback(pu,[],ax,handles);
end
for j=bands+1:8
    pu = findobj(handles.InfoPanel,'Tag',sprintf('Popup%d',j));
    pu.Visible = 'off';
    pu.UserData.trace = [];
    pu.UserData.phase = [];
    pu.UserData.name = [];
end
%checkbox11_Callback(handles.Checkbox11,[],handles);
%checkbox12_Callback(handles.Checkbox12,[],handles);



set(handles.Edit1,'Callback',{@edit_Callback,all_axes});
set(handles.Edit2,'Callback',{@edit_Callback,all_axes});
set(handles.Checkbox1,'Callback',{@checkbox1_Callback,handles});
set(handles.Checkbox2,'Callback',{@checkbox2_Callback,handles});
set(handles.Checkbox3,'Callback',{@checkbox3_Callback,handles});
set(handles.Checkbox11,'Callback',{@checkbox11_Callback,handles});
set(handles.Checkbox12,'Callback',{@checkbox12_Callback,handles});
set(handles.Checkbox32,'Callback',{@checkbox32_Callback,handles});

% set(handles.ButtonReload,'Callback',{@reload_Callback,handles});
set(handles.ButtonReset,'Callback',{@reset_Callback,handles});
set(handles.ButtonCompute,'Callback',{@compute_wavelet_Callback,handles});
set(handles.ButtonAutoScale,'Callback',{@buttonAutoScale_Callback,handles});
set(handles.EditAutoscale,'Callback',{@buttonAutoScale_Callback,handles});

% set(handles.ButtonExport,'Callback',{@export_wavelet_Callback,handles});
% set(handles.ButtonSaveImage,'Callback',{@saveimage_Callback,handles});
% set(handles.ButtonSaveStats,'Callback',{@savestats_Callback,handles});
% set(handles.ButtonBatchSave,'Callback',{@batchsave_Callback,handles});

%Interactive Control
edits = [handles.Edit1;handles.Edit2];
set(handles.prevTagButton,'Callback',{@template_prevTag_Callback,handles.TagButton,handles.CenterAxes,edits});
set(handles.nextTagButton,'Callback',{@template_nextTag_Callback,handles.TagButton,handles.CenterAxes,edits});
set(handles.PlusButton,'Callback',{@template_buttonPlus_Callback,handles.CenterAxes,edits});
set(handles.MinusButton,'Callback',{@template_buttonMinus_Callback,handles.CenterAxes,edits});
set(handles.RescaleButton,'Callback',{@template_buttonRescale_Callback,handles.CenterAxes,edits});
set(handles.SkipButton,'Callback',{@template_buttonSkip_Callback,handles.CenterAxes,edits});
set(handles.BackButton,'Callback',{@template_buttonBack_Callback,handles.CenterAxes,edits});
set(handles.TagButton,'Callback',{@template_button_TagSelection_Callback,handles.CenterAxes,edits,'single'});

% All Axes
for i=1:length(all_axes)
    value_template_axes = 1;
    set(all_axes(i),'ButtonDownFcn',{@template_axes_clickFcn,value_template_axes,[],[edits;handles.Edit2b]});
end
% Top Axes
set(handles.ScaleButton,'Callback',{@template_buttonScale_Callback,all_topaxes});


% Linking axes x
ax2 = findobj(handles.BotPanel,'Type','Axes');
ax3 = findobj(handles.FirstBotPanel,'Type','Axes');
linkaxes([ax2;ax3],'x');
% Linking axes y
for i =1:length(ax3)
   tag = ax3(i).Tag;
   ax4 = findobj(handles.SecondBotPanel,'Tag',tag);
   ax5 = findobj(handles.SecondBotPanel,'Tag',strcat(tag,'_r'));
   ax6 = findobj(handles.SecondBotPanel,'Tag',strcat(tag,'_s'));
   linkaxes([ax3(i);ax4;ax5;ax6],'y');
end
% Linking channels
checkbox3_Callback(handles.Checkbox3,[],handles);

% clearing UserData
handles.ButtonCompute.UserData.save_data = []; 

end

function checkbox1_Callback(hObj,~,handles)
% Multiply by n

handles.MainFigure.Pointer = 'watch';
drawnow;

%Building correction
exp_cor = str2double(handles.EditExpCor.String);

all_firstaxes = findobj(handles.FirstBotPanel,'Type','Axes');
all_secondaxes = findobj(handles.SecondBotPanel,'Type','Axes');
all_botaxes = [all_firstaxes;all_secondaxes];
images = findobj(all_botaxes,'Type','Image','-and','Visible','on');

for j=1:length(images)
    im = images(j);
    %correction = im.UserData.correction;
    % Updating correction
    Cdata = im.UserData.Cdata;
    freqdom = im.UserData.Ydata;
    correction = repmat((freqdom(:).^exp_cor),1,size(Cdata,2));
    correction = correction/correction(end,1);
    im.UserData.correction = correction;
    % X_temp = im.UserData.Xdata;
    %Mutltiply by n if box checked
     
    if hObj.Value
        im.CData = correction.*Cdata;
    else
        im.CData = Cdata;
    end
   
end
checkbox2_Callback(handles.Checkbox2,[],handles);
buttonAutoScale_Callback([],[],handles);
handles.MainFigure.Pointer = 'arrow';

end

function checkbox2_Callback(hObj,~,handles)
% Logarithmic display

handles.MainFigure.Pointer = 'watch';
drawnow;

all_firstaxes = findobj(handles.FirstBotPanel,'Type','Axes');
all_secondaxes = findobj(handles.SecondBotPanel,'Type','Axes');
all_botaxes = [all_firstaxes;all_secondaxes];
% Finding all images
im = findobj(all_botaxes,'Tag','Image');

if hObj.Value
    for i =1:length(all_botaxes)
        all_botaxes(i).YScale = 'log';
    end
    for j =1:length(im)
        X = im(j).UserData.Xdata;
        Y = im(j).UserData.Ydata;
        C = im(j).CData;
        [X2,Y2] = meshgrid(X,Y);
        %C_log = flipud(interp2(X2,Y2,flipud(C),X2,log(Y2)*max(Y)/exp(max(Y))));
        C_log = interp2(X2,Y2,flipud(C),X2,log(Y2)*max(Y)/log(max(Y)));
        im(j).CData = flipud(C_log);
    end
else
    for i =1:length(all_botaxes)
        all_botaxes(i).YScale = 'linear';
    end
    %checkbox1_Callback(handles.Checkbox1,[],handles);
    for j =1:length(im)
        if handles.Checkbox1.Value
            im(j).CData = im(j).UserData.Cdata.*im(j).UserData.correction;
        else
            im(j).CData = im(j).UserData.Cdata;
        end
    end
end
buttonAutoScale_Callback([],[],handles);
handles.MainFigure.Pointer = 'arrow';

end

function checkbox3_Callback(hObj,~,handles)
% Linking axes

ax3 = flipud(findobj(handles.FirstBotPanel,'Type','Axes'));
% Left buttons
all_buttons =[];
for k =2:str2double(handles.Edit4.String)
    b1 = findobj(handles.MainFigure,'Tag',sprintf('fdom_min_%d',k));
    b2 = findobj(handles.MainFigure,'Tag',sprintf('fdom_max_%d',k));
    all_buttons =[all_buttons ;b1;b2];
end
    
if ~hObj.Value
    for i =1:length(all_buttons)
        %all_buttons(i).Visible = 'on';
        all_buttons(i).Enable = 'on';
    end
    linkaxes(ax3,'off');
else
    for i =1:length(all_buttons)
        %all_buttons(i).Visible = 'on';
        all_buttons(i).Enable = 'off';
    end
    linkaxes(ax3,'y');
end

end

function checkbox11_Callback(hObj,~,handles)
% Display trace

t = findobj(handles.BotPanel,'Tag','Trace');
if hObj.Value
    for i =1:length(t)
        t(i).Visible ='on';
    end
else
    for i =1:length(t)
        t(i).Visible ='off';
    end
end
end

function checkbox12_Callback(hObj,~,handles)
% Display filtered signal

t = findobj(handles.BotPanel,'Tag','Phase');
if hObj.Value
    for i =1:length(t)
        t(i).Visible ='on';
    end
else
    for i =1:length(t)
        t(i).Visible ='off';
    end
end
end

function checkbox32_Callback(hObj,~,handles)

bands = str2double(handles.Edit4.String);
for k=1:bands
    ax1 = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d',k));
    ax2 = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d_mid',k));
    ax3 = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d_high',k));
    all_axes = [ax1;ax2;ax3];
    for j=1:3
        ax = all_axes(j);
        if hObj.Value
            l1 = findobj(ax,'Tag','Spectro_ascend');
            l2 = findobj(ax,'Tag','Spectro_descend');
            %ax.Title.String = 'Spectro-ascend';
            ax.Title.String = ax.UserData.t_ascend;
            ax.YLabel.String = 'ascend';
        else
            l1 = findobj(ax,'Tag','Spectro_descend');
            l2 = findobj(ax,'Tag','Spectro_ascend');
            %ax.Title.String = 'Spectro-descend';
            ax.Title.String = ax.UserData.t_descend;
            ax.YLabel.String = 'descend';
        end
        m=[];
        for i =1:length(l1)
            l1(i).Visible ='on';
            l2(i).Visible ='off';
            val_min = min(l1(i).YData);
            val_max = max(l1(i).YData);
            m=[m;val_min val_max];
        end
        if ~isempty(m(~isnan(m)))
            ax.YLim = [min(min(m)) max(max(m))];
        end
    end
end

end

function update_popup_Callback(hObj,~,ax,handles)

val = hObj.Value;
traces = handles.ButtonCompute.UserData.traces;
phases = handles.ButtonCompute.UserData.phases;
traces_name = handles.ButtonCompute.UserData.traces_name;

delete(findobj(ax,'type','line'));
% drawing trace
X = traces(val).X;
Y = traces(val).Y;
line('XData',X,'YData',Y,'Parent',ax,...
    'HitTest','off','Tag','Trace','Color','k');
hObj.UserData.trace = traces(val);
hObj.UserData.name = traces_name(val);

if ~isempty(phases)
    % drawing phase
    X_p = phases(val).X;
    Y_p = phases(val).Y;
    line('XData',X_p,'YData',Y_p,'Parent',ax,...
        'HitTest','off','Tag','Phase','Color',[.5 .5 .5]);
    hObj.UserData.phase = phases(val);
end
ax.YLimMode = 'auto';
ax.FontSize = 7;
%ax.YTick = '';

index = hObj.UserData.index;
all_ax = findobj(handles.MainBotPanel,'Tag',sprintf('Ax%d',index));
for i =1:length(all_ax)
    all_ax(i).YLabel.String = traces_name(val);
    all_ax(i).YLabel.FontSize=8;
end

checkbox11_Callback(handles.Checkbox11,[],handles);
checkbox12_Callback(handles.Checkbox12,[],handles);

end

function edit_Callback(hObj,~,ax)

if length(hObj)>1
    A = datenum(hObj(1).String);
    B1 = (A - floor(A))*24*3600;
    A = datenum(hObj(2).String);
    B2 = (A - floor(A))*24*3600;
    for i =1:length(ax)
        ax(i).XLim = [B1 B2];
    end
else
    A = datenum(hObj.String);
    B = (A - floor(A))*24*3600;
    hObj.String = datestr(B/(24*3600),'HH:MM:SS.FFF');
    
    switch hObj.Tag
        case 'Edit1',
            for i =1:length(ax)
                ax(i).XLim(1) = B;
            end
        case 'Edit2',
            for i =1:length(ax)
                ax(i).XLim(2) = B;
            end
    end
end

end

function update_caxis(hObj,~,ax,c,value)
switch value
    case 1
        for i =1:length(ax)
            ax(i).CLim(1) = str2double(hObj.String);
        end
    case 2
        for i =1:length(ax)
            ax(i).CLim(2) = str2double(hObj.String);
        end
end
c.Limits = ax(1).CLim;
end

function update_yaxis(hObj,~,ax,value,handles)

if length(hObj)>1
    ax.YLim = [str2double(hObj(1).String) str2double(hObj(2).String)];
else
    switch value
        case 1
            ax.YLim(1) = str2double(hObj.String);
        case 2
            ax.YLim(2) = str2double(hObj.String);
    end
end

% Update cousins
if ~handles.Checkbox3.Value
    e = findobj(hObj.Parent.Parent.Parent,'Tag',hObj.Tag);
else
    e=[];
    e_temp = findobj(hObj.Parent.Parent.Parent,'Type','uicontrol');
    for i=1:length(e_temp)
        if strfind(e_temp(i).Tag,hObj.Tag(1:end-2))
            e=[e;e_temp(i)];
        end
    end
end

for i =1:length(e)
    e(i).String = hObj.String;
end

end

function compute_wavelet_Callback(hObj,~,handles)

tic;
handles.MainFigure.Pointer = 'watch';
drawnow;
handles.MainFigure.UserData.success = false;
    
% Wavelet Parameters
bands = str2double(handles.Edit4.String);
Fb = str2double(handles.Fb.String);
Fc = str2double(handles.Fc.String);
fdom_step = str2double(handles.fdom_step.String);
delta_d  = 10;
bins = 0:delta_d:360;
flag_leg = 0;
%delta_r = str2double(handles.EditDelta.String);
delta_r = 100;
%exp_cor = .75;
exp_cor = str2double(handles.EditExpCor.String);

% Tag Selection
xlim1 = handles.CenterAxes.XLim(1);
xlim2 = handles.CenterAxes.XLim(2);
Time_indices = [xlim1,xlim2];
str = datestr((Time_indices(2)-Time_indices(1))/(24*3600),'HH:MM:SS.FFF');
Tag_Selection = {'CURRENT',handles.Edit1.String,str};

% % Test if axis limits matches Whole
% if round(Time_indices(1)-time_ref.Y(1))==0 && round(Time_indices(2)-time_ref.Y(end))==0
%     tag = 'WHOLE';
%     Tag_Selection ={tag,handles.Edit1.String,str};
% % Test if axis limits matches tag
% elseif ~isempty(handles.TagButton.UserData) 
%     tts1 = char(handles.TagButton.UserData.TimeTags_strings(1));
%     tts2 = char(handles.TagButton.UserData.TimeTags_strings(2));
%     if strcmp(handles.Edit1.String(1:9),tts1(1:9)) && strcmp(handles.Edit2.String(1:9),tts2(1:9))
%         tag = char(handles.TagButton.UserData.Name);
%         Tag_Selection ={tag,handles.Edit1.String,str};
%     end
% end

% % Loading Time Tags
% if (exist(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Tags.mat'),'file'))
%     data_tt = load(fullfile(DIR_SAVE,FILES(CUR_FILE).nlab,'Time_Tags.mat'));
%     tts1 = data_tt.TimeTags_strings(:,1);
%     tts2 = data_tt.TimeTags_strings(:,2);    
%     ind_tts =  find(strcmp(handles.Edit1.String,tts1).*strcmp(handles.Edit2.String,tts2)==1);
%     if ~isempty(ind_tts)
%         tag = char(data_tt.TimeTags(ind_tts(1)).Tag);
%         Tag_Selection ={tag,handles.Edit1.String,str};
%     end   
% end

% Saving structures
params = struct('Fb',Fb,'Fc',Fc,'fdom_step',fdom_step,'delta_d',delta_d,'bins',bins);
save_data = struct('Y_trace',[],'Y_phase',[],'f_phase',[],'trace_name',[],...
    'f_sub',[],'f_samp',[],'fdom_min',[],'fdom_max',[],'freqdom',[],'x_start',[],'x_end',...
    [],'Cdata',[],'Cdata_phase_ascend',[],'Cdata_phase_descend',[],'gamma_ascend',[],'gamma_descend',[]);

% Computing Wavelet Matrix
for k=1:bands
    
    % Variables
    %ax = findobj(handles.BotPanel,'Tag',sprintf('Ax%d',k));
    pu = findobj(handles.InfoPanel,'Tag',sprintf('Popup%d',k));
    trace = pu.UserData.trace;
    trace_name = pu.UserData.name;
    
    % Subsampling
    fdom_min = str2double(get(findobj(handles.FirstBotPanel,'Tag',sprintf('fdom_min_%d',k)),'String'));
    fdom_max = str2double(get(findobj(handles.FirstBotPanel,'Tag',sprintf('fdom_max_%d',k)),'String'));
    f_samp = pu.UserData.trace.f_samp;              % sampling frequency (2500 Hz)
    sub_samp = floor(f_samp/(2*fdom_max));          % subsampling frequency factor
    %sub_samp = 5;
    f_sub = f_samp/sub_samp;       

    [~,ind_1] = min((trace.X-xlim1).^2);
    [~,ind_2] = min((trace.X-xlim2).^2);
    X = trace.X(ind_1:ind_2);
    Y = trace.Y(ind_1:ind_2);
    Y_temp = Y(1:sub_samp:end);
    X_temp = X(1:sub_samp:end);
    % keeping trace
    Y_trace = Y_temp;
    X_trace = X_temp;
    
    % Computing Wavelet
    freqdom = fdom_min:fdom_step:fdom_max; 
    scales = Fc*f_sub./freqdom;
    fprintf('Computing Time-Frequency Spectrogramm (%s) ...',char(trace_name));
    coefs_wav   = cmorcwt(Y_temp,scales,Fb,Fc);
    Cdata = log10(abs(coefs_wav)).^2;
    fprintf(' done.\n');
    
    %Gaussian smoothing
    t_gauss = str2double(handles.EditGaussian.String);
    step = t_gauss*round(f_sub);
    Cdata_smooth = imgaussfilt(Cdata,[1 step]);
    %Cdata_smooth = imgaussfilt(Cdata,[1 1]);
    
    
    % First Tab
    ax = findobj(handles.FirstBotPanel,'Tag',sprintf('Ax%d',k));
    %correction_Cdata = repmat(sqrt(freqdom(:)),1,size(Cdata,2));
    correction_Cdata = repmat(freqdom(:).^exp_cor,1,size(Cdata,2));
    correction_Cdata = correction_Cdata/correction_Cdata(end,1);
    
    if handles.Checkbox1.Value
        im = imagesc('XData',X_temp,...
            'YData',freqdom,...
            'CData',Cdata_smooth.*correction_Cdata,...
            'Tag','Image',...
            'HitTest','off',...
            'Parent',ax);
    else
        im = imagesc('XData',X_temp,...
            'YData',freqdom,...
            'CData',Cdata_smooth,...
            'Tag','Image',...
            'HitTest','off',...
            'Parent',ax);
    end
    % Storing for Checkboxes
    im.UserData.correction = correction_Cdata;
    im.UserData.Cdata = Cdata_smooth;
    im.UserData.Ydata = freqdom;
    im.UserData.Xdata = X_temp;

    str_band = sprintf('Band %d - %d Hz',fdom_min,fdom_max);
    ax.Title.String = sprintf('%s (Duration %s) - %s',char(Tag_Selection(1)),char(Tag_Selection(3)),str_band);
    ax.Title.Visible = 'off';
    %ax.YLim = [fdom_min,fdom_max];
    
    % Case of early break
    early_break = handles.Checkbox4.Value;
    if early_break
        %Saving data
        save_data(k).trace_name = trace_name;
        save_data(k).X_trace = X_trace;
        save_data(k).Y_trace = Y_trace;
        save_data(k).X_phase = [];
        save_data(k).Y_phase = [];
        save_data(k).f_sub = f_sub;
        save_data(k).f_samp = f_samp;
        save_data(k).fdom_min = fdom_min;
        save_data(k).fdom_max = fdom_max;
        save_data(k).freqdom = freqdom;
        save_data(k).x_start = X_temp(1);
        save_data(k).x_end = X_temp(end);
        save_data(k).Cdata = Cdata;
        save_data(k).Cdata_phase_ascend = [];
        save_data(k).Cdata_phase_descend = [];
        save_data(k).gamma = [];
        save_data(k).gamma_ascend = [];
        save_data(k).gamma_descend = [];
        save_data(k).r_low = [];
        save_data(k).r_mid = [];
        save_data(k).r_high = [];
        save_data(k).lags = [];
        save_data(k).labels = [];
        continue;
    end
    
    % Second Panel
    % Spectrogram
    g_colors = get(groot,'defaultAxesColorOrder');
    ax = findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d_s',k));  
    set(ax,'XLim',[fdom_min,fdom_max]);
    if ~handles.BoxHold1.Value
        delete(ax.Children);
    end
    l = line('XData',mean(im.CData,2),...
        'Ydata',freqdom,...
        'Color',g_colors(mod(length(ax.Children),length(g_colors))+1,:),...
        'Tag','Spectro',...
        'Parent',ax);
    ax.XLim = [0, 1.1*max(l.XData)];
    [~,ind_freq] =max(l.XData);
    max_freq = im.YData(ind_freq);
    ax.Title.String = sprintf('Max Frequency - %.1f',max_freq);
    
    % Phase_frequency
    fprintf('Computing Phase-Frequency Spectrogramm (%s) ...',char(trace_name));
    phase = pu.UserData.phase;
    [~,ind_1] = min((phase.X-xlim1).^2);
    [~,ind_2] = min((phase.X-xlim2).^2);
    %keeping phase
    X_phase = phase.X(ind_1:ind_2);
    Y_phase = phase.Y(ind_1:ind_2);
    [Cdata_phase_ascend,Cdata_phase_descend] = compute_phase_spectrogramm(Cdata,X_temp,X_phase,Y_phase,bins);
    % Ascend
    ax = findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d',k));
    Cdata_phase = Cdata_phase_ascend;
    %correction_phase = repmat(sqrt(freqdom(:)),1,size(Cdata_phase,2));
    correction_phase = repmat(freqdom(:).^exp_cor,1,size(Cdata_phase,2));
    correction_phase = correction_phase/correction_phase(end,1);
    if handles.Checkbox1.Value
        im = imagesc('XData',bins(1:end-1)+0.5*delta_d,...
            'YData',freqdom,...
            'CData',Cdata_phase.*correction_phase,...
            'HitTest','off',...
            'Tag','Image',...
            'Parent',ax);
    else
        im = imagesc('XData',bins(1:end-1)+0.5*delta_d,...
            'YData',freqdom,...
            'CData',Cdata_phase,...
            'HitTest','off',...
            'Tag','Image',...
            'Parent',ax);
    end
    % Storing for Checkboxes
    im.UserData.correction = correction_phase;
    im.UserData.Cdata = Cdata_phase;
    im.UserData.Ydata = freqdom;
    im.UserData.Xdata = bins(1:end-1)+0.5*delta_d;
    
    [~,ind_phase] =max(max(im.CData,[],1));
    max_phase = im.XData(ind_phase);
    [~,ind_freq] =max(max(im.CData,[],2));
    max_freq = im.YData(ind_freq);
    ax.Title.String = sprintf('Peak Phase %.1f - Peak Frequency %.1f',max_phase,max_freq);
    %ax.YLim = [fdom_min,fdom_max];
    ax.XLim = [bins(1),bins(end)];
    
    % Descend
    ax = findobj(handles.SecondBotPanel,'Tag',sprintf('Ax%d_r',k));
    Cdata_phase = Cdata_phase_descend;
    if handles.Checkbox1.Value
        im = imagesc('XData',bins(1:end-1)+0.5*delta_d,...
            'YData',freqdom,...
            'CData',Cdata_phase.*correction_phase,...
            'HitTest','off',...
            'Tag','Image',...
            'Parent',ax);
    else
        im = imagesc('XData',bins(1:end-1)+0.5*delta_d,...
            'YData',freqdom,...
            'CData',Cdata_phase,...
            'HitTest','off',...
            'Tag','Image',...
            'Parent',ax);
    end
    % Storing for Checkboxes
    im.UserData.correction = correction_phase;
    im.UserData.Cdata = Cdata_phase;
    im.UserData.Ydata = freqdom;
    im.UserData.Xdata = bins(1:end-1)+0.5*delta_d;
    
    [~,ind_phase] =max(max(im.CData,[],1));
    max_phase = im.XData(ind_phase);
    [~,ind_freq] =max(max(im.CData,[],2));
    max_freq = im.YData(ind_freq);
    ax.Title.String = sprintf('Peak Phase %.1f - Peak Frequency %.1f',max_phase,max_freq);
    %ax.YLim = [fdom_min,fdom_max];
    ax.XLim = [bins(1),bins(end)];
    fprintf(' done.\n');
    
    % Third Panel
    % Giving othername to not disturb save
    if handles.Checkbox1.Value
        C_smooth = Cdata_smooth.*correction_Cdata;
        C_ascend = Cdata_phase_ascend.*correction_phase;
        C_descend = Cdata_phase_descend.*correction_phase;
    else
        C_smooth = Cdata_smooth;
        C_ascend = Cdata_phase_ascend;
        C_descend = Cdata_phase_descend;
    end
    % Computing glow_ascend,gmid_ascend,ghigh_ascend    
    val_inf = max(freqdom(1),20);
    val_sup = min(freqdom(end),50);
    if val_inf<=val_sup
        [~,i_1] = min((freqdom-val_inf).^2);
        [~,i_2] = min((freqdom-val_sup).^2);
        glow = mean(C_smooth(i_1:i_2,:),1);
        glow_ascend = mean(C_ascend(i_1:i_2,:),1);
        glow_descend = mean(C_descend(i_1:i_2,:),1);
    else
        glow = NaN(1,size(C_smooth,2));
        glow_ascend = NaN(1,size(C_ascend,2));
        glow_descend = NaN(1,size(C_descend,2));
    end
    val_inf = max(freqdom(1),50);
    val_sup = min(freqdom(end),100);
    if val_inf<=val_sup
        [~,i_1] = min((freqdom-val_inf).^2);
        [~,i_2] = min((freqdom-val_sup).^2);
        gmid = mean(C_smooth(i_1:i_2,:),1);
        gmid_ascend = mean(C_ascend(i_1:i_2,:),1);
        gmid_descend = mean(C_descend(i_1:i_2,:),1);
    else
        gmid = NaN(1,size(C_smooth,2));
        gmid_ascend = NaN(1,size(C_ascend,2));
        gmid_descend = NaN(1,size(C_descend,2));    
    end
    val_inf = max(freqdom(1),100);
    val_sup = min(freqdom(end),150);
    if val_inf<=val_sup
        [~,i_1] = min((freqdom-val_inf).^2);
        [~,i_2] = min((freqdom-val_sup).^2);
        ghigh = mean(C_smooth(i_1:i_2,:),1);
        ghigh_ascend = mean(C_ascend(i_1:i_2,:),1);
        ghigh_descend = mean(C_descend(i_1:i_2,:),1);
    else
        ghigh = NaN(1,size(C_smooth,2));
        ghigh_ascend = NaN(1,size(C_ascend,2));
        ghigh_descend = NaN(1,size(C_descend,2));
    end
    
    % Update frequency coupling spectrogramms
    % Gamma low
    ax = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d',k));
    if ~handles.BoxHold2.Value
        delete(ax.Children);
    else
        for j=1:length(ax.Children)
            ax.Children(j).LineWidth = 1;
        end
    end
    l_a = line('XData',bins(1:end-1)+0.5*delta_d,'Ydata',glow_ascend,...
        'Color',g_colors(mod(1,length(g_colors))+1,:),...
        'LineWidth',2,'Tag','Spectro_ascend','Parent',ax);
    l_d = line('XData',bins(1:end-1)+0.5*delta_d,'Ydata',glow_descend,...
        'Color',g_colors(mod(1,length(g_colors))+1,:),...
        'LineWidth',2,'Tag','Spectro_descend','Parent',ax);
    ax.XLim = [bins(1),bins(end)];
    [max_freq,ind_freq] = max(l_a.YData);
    ind_freq = l_a.XData(ind_freq);
    ax.UserData.t_ascend = sprintf('Peak Phase %.1f - Peak Frequency %.1f',ind_freq,max_freq);
    [max_freq,ind_freq] = max(l_d.YData);
    ind_freq = l_d.XData(ind_freq);
    ax.UserData.t_descend = sprintf('Peak Phase %.1f - Peak Frequency %.1f',ind_freq,max_freq);
    % Gamma mid    
    ax = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d_mid',k));
    if ~handles.BoxHold2.Value
        cla(ax);
    else
        for j=1:length(ax.Children)
            ax.Children(j).LineWidth = 1;
        end
    end
    l_a = line('XData',bins(1:end-1)+0.5*delta_d,'Ydata',gmid_ascend,...
        'Color',g_colors(mod(2,length(g_colors))+1,:),...
        'LineWidth',2,'Tag','Spectro_ascend','Parent',ax);
    l_d = line('XData',bins(1:end-1)+0.5*delta_d,'Ydata',gmid_descend,...
        'Color',g_colors(mod(2,length(g_colors))+1,:),...
        'LineWidth',2,'Tag','Spectro_descend','Parent',ax);
    ax.XLim = [bins(1),bins(end)];
    [max_freq,ind_freq] = max(l_a.YData);
    ind_freq = l_a.XData(ind_freq);
    ax.UserData.t_ascend = sprintf('Peak Phase %.1f - Peak Frequency %.1f',ind_freq,max_freq);
    [max_freq,ind_freq] = max(l_d.YData);
    ind_freq = l_d.XData(ind_freq);
    ax.UserData.t_descend = sprintf('Peak Phase %.1f - Peak Frequency %.1f',ind_freq,max_freq);
    % Gamma-high
    ax = findobj(handles.ThirdBotPanel,'Tag',sprintf('Ax%d_high',k));
    if ~handles.BoxHold2.Value
        delete(ax.Children);
        else
        for j=1:length(ax.Children)
            ax.Children(j).LineWidth = 1;
        end
    end
    l_a = line('XData',bins(1:end-1)+0.5*delta_d,'Ydata',ghigh_ascend,...
        'Color',g_colors(mod(3,length(g_colors))+1,:),...
        'LineWidth',2,'Tag','Spectro_ascend','Parent',ax);
    l_d = line('XData',bins(1:end-1)+0.5*delta_d,'Ydata',ghigh_descend,...
        'Color',g_colors(mod(3,length(g_colors))+1,:),...
        'LineWidth',2,'Tag','Spectro_descend','Parent',ax);
    ax.XLim = [bins(1),bins(end)];
    [max_freq,ind_freq] = max(l_a.YData);
    ind_freq = l_a.XData(ind_freq);
    ax.UserData.t_ascend = sprintf('Peak Phase %.1f - Peak Frequency %.1f',ind_freq,max_freq);
    [max_freq,ind_freq] = max(l_d.YData);
    ind_freq = l_d.XData(ind_freq);
    ax.UserData.t_descend = sprintf('Peak Phase %.1f - Peak Frequency %.1f',ind_freq,max_freq);
    
%     % Fourth Panel
%     all_topaxes = findobj(handles.TopPanel,'Type','Axes');
%     l_reg = flipud(findobj(all_topaxes,'Tag','Trace_Region'));
%     labels = [];
%     colors = [];
%     Ydata_reg = [];
%     for i = 1:length(l_reg)
%         labels = [labels;{l_reg(i).UserData.Name}];
%         colors = [colors;l_reg(i).Color];
%         [~,ind_1] = min((l_reg(i).XData-(X_temp(1)-1)).^2,[],'omitnan');
%         [~,ind_2] = min((l_reg(i).XData-(X_temp(end)+1)).^2,[],'omitnan');
%         Y = l_reg(i).YData(ind_1:ind_2);
%         X = l_reg(i).XData(ind_1:ind_2);
%         X = X(1):(X(end)-X(1))/(length(Y)-1):X(end);
%         Y_temp = interp1(X,Y,X_temp');
%         Y_temp = Y_temp(:)';
%         Ydata_reg = [Ydata_reg;Y_temp];
%     end

%     % Computing cross-correlations
%     l_width = .2;
%     m_size = 10;
%     if size(Ydata_reg,2)>0
%         delta_r = min(delta_r,floor(size(Ydata_reg,2)/(2*f_sub)));
%     end
%     n = round(delta_r*f_sub);
%     r_low = [];
%     r_mid = [];
%     r_high = [];
%     lags = delta_r*(-1:1/n:1);
%     for i = 1:length(l_reg)
%         r_low = [r_low;xcorr(Ydata_reg(i,:),glow,n,'coeff')];
%         r_mid = [r_mid;xcorr(Ydata_reg(i,:),gmid,n,'coeff')];
%         r_high = [r_high;xcorr(Ydata_reg(i,:),ghigh,n,'coeff')];
%     end
    
%     % Plotting
%     % Gamma low
%     ax = findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d',k));
%     delete(ax.Children);
%     for i=1:length(labels)
%         l = line('XData',lags,'YData',r_low(i,:),'Parent',ax,...
%             'Color',colors(i,:),'LineWidth',l_width,'Tag','Corr_low');
%     end
%     for i=1:length(labels)
%         [m,i_m] = max(r_low(i,:));
%         line('XData',l.XData(i_m),'YData',m,'Parent',ax,...
%             'Color',colors(i,:),'MarkerSize',m_size,'Marker','+',...
%             'LineWidth',2,'Tag','Corr_low_bar');
%     end
%     ax.XLim = [lags(1),lags(end)];
%     if ~isempty(r_low(~isnan(r_low)))
%         ax.YLim = [min(min(r_low,[],'omitnan'),[],'omitnan'),max(max(r_low,[],'omitnan'),[],'omitnan')];
%     end
%     % Gamma mid
%     ax = findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d_mid',k));
%     delete(ax.Children);
%     for i=1:length(labels)
%         l = line('XData',lags,'YData',r_mid(i,:),'Parent',ax,...
%             'Color',colors(i,:),'LineWidth',l_width,'Tag','Corr_mid');
%     end
%     for i=1:length(labels)
%         [m,i_m] = max(r_mid(i,:));
%         line('XData',l.XData(i_m),'YData',m,'Parent',ax,...
%             'Color',colors(i,:),'MarkerSize',m_size,'Marker','+',...
%             'LineWidth',2,'Tag','Corr_mid_bar');
%     end
%     ax.XLim = [lags(1),lags(end)];
%     if ~isempty(r_mid(~isnan(r_mid)))
%         ax.YLim = [min(min(r_mid,[],'omitnan'),[],'omitnan'),max(max(r_mid,[],'omitnan'),[],'omitnan')];
%     end
%     % Gamma-high
%     ax = findobj(handles.FourthBotPanel,'Tag',sprintf('Ax%d_high',k));
%     delete(ax.Children);
%     for i=1:length(labels)
%         l = line('XData',lags,'YData',r_high(i,:),'Parent',ax,...
%             'Color',colors(i,:),'LineWidth',l_width,'Tag','Corr_high');
%     end
%     for i=1:length(labels)
%         [m,i_m] = max(r_high(i,:));
%         line('XData',l.XData(i_m),'YData',m,'Parent',ax,...
%             'Color',colors(i,:),'MarkerSize',m_size,'Marker','+',...
%             'LineWidth',2,'Tag','Corr_high_bar');
%     end
%     ax.XLim = [lags(1),lags(end)];
%     if ~isempty(r_high(~isnan(r_high)))
%         ax.YLim = [min(min(r_high)),max(max(r_high))];
%     end
%     
%     %Legend Position
%     if flag_leg ==0 && ~isempty(labels)
%         lines = flipud(findobj(ax,'Tag','Corr_high'));
%         leg = legend(ax,lines,labels,'Visible','on',...
%             'Tag','Legend','Units','characters','Box','off');
%         flag_leg = 1;
%         handles.FourthBotPanel.Units = 'characters';
%         pos = handles.FourthBotPanel.Position;
%         leg.Position = [.9*pos(3) .05*pos(4) .1*pos(3) .9*pos(4)];
%         handles.FourthBotPanel.Units = 'normalized';
%         leg.Units = 'normalized';
%     end
    
    %Saving data
    save_data(k).trace_name = trace_name;
    save_data(k).X_trace = X_trace;
    save_data(k).Y_trace = Y_trace;
    save_data(k).X_phase = X_phase;
    save_data(k).Y_phase = Y_phase;
    save_data(k).f_sub = f_sub;
    save_data(k).f_samp = f_samp;
    save_data(k).fdom_min = fdom_min;
    save_data(k).fdom_max = fdom_max;
    save_data(k).freqdom = freqdom;
    save_data(k).x_start = X_temp(1);
    save_data(k).x_end = X_temp(end);
    save_data(k).Cdata = Cdata;
    save_data(k).Cdata_phase_ascend = Cdata_phase_ascend;
    save_data(k).Cdata_phase_descend = Cdata_phase_descend;
%     save_data(k).gamma = [glow;gmid;ghigh];
%     save_data(k).gamma_ascend = [glow_ascend;gmid_ascend;ghigh_ascend];
%     save_data(k).gamma_descend = [glow_descend;gmid_descend;ghigh_descend];
%     save_data(k).r_low = r_low;
%     save_data(k).r_mid = r_mid;
%     save_data(k).r_high = r_high; 
%     save_data(k).lags = lags;
%     save_data(k).labels = labels;
end

% Saving Data
hObj.UserData.save_data = save_data;
hObj.UserData.params = params;
hObj.UserData.Tag_Selection = Tag_Selection;
handles.TabGroup.SelectedTab = handles.FirstTab;

% Multiply b n
% checkbox1_Callback(handles.Checkbox1,[],handles);

% Apply log correction
if handles.Checkbox2.Value
    checkbox2_Callback(handles.Checkbox2,[],handles);
end

% Ascend/descend Spectro
if ~early_break
    checkbox32_Callback(handles.Checkbox32,[],handles);
end

% Autoscale
buttonAutoScale_Callback([],[],handles);

toc;
handles.MainFigure.Pointer = 'arrow';
handles.MainFigure.UserData.success = true;

end

function buttonAutoScale_Callback(~,~,handles)

bands = str2double(handles.Edit4.String);
channels = str2double(handles.Edit3.String);
panels = [handles.BotPanel;handles.FirstBotPanel;handles.SecondBotPanel];
coeff1 = str2double(handles.EditAutoscale.String);
coeff2 = 2*coeff1/3;
%coeff1 = 2;
%coeff2 = 1.5;

for i =1:length(panels)
    for j=1:max(bands,channels)
        ax = findobj(panels(i),'Tag',sprintf('Ax%d',j));
        ax_r = findobj(panels(i),'Tag',sprintf('Ax%d_r',j));
        ax_s = findobj(panels(i),'Tag',sprintf('Ax%d_s',j));
        
        c = findobj(panels(i),'Tag',sprintf('Colorbar%d',j));
        im = findobj(ax,'Type','Image','-and','Visible','on');
        im_r = findobj(ax_r,'Type','Image','-and','Visible','on');
        lines = findobj(ax,'Type','line','-and','Visible','on');
        lines_s = findobj(ax_s,'Type','line','-and','Visible','on');
        
        % Searching local max and min for all images in axes
        % Storing in X (timing) and Y (values)
        X=[];
        Y=[];
        for k=1:length(im)
            x_ind = max(ax.XLim(1),im(k).XData(1));
            y_ind = min(ax.XLim(2),im(k).XData(end));
            if y_ind>x_ind
                X = [X;x_ind y_ind];
                indexes = (im(k).XData>=x_ind).*(im(k).XData<=y_ind);
                [~,ind_min] = min((im(k).YData-ax.YLim(1)).^2);
                [~,ind_max] = min((im(k).YData-ax.YLim(2)).^2); 
                temp_ = im(k).CData(ind_min:ind_max,indexes==1);
                val_max = mean(mean(temp_,'omitnan'),'omitnan');
                val_min = min(min(temp_,[],'omitnan'),[],'omitnan');
                Y = [Y;val_min val_max];
                %Y = [Y;min(min(temp_,[],'omitnan'),[],'omitnan') max(max(temp_,[],'omitnan'),[],'omitnan')];
            end
        end
        if ~isempty(Y)  
            m = min(Y(:,1),[],'omitnan');
            M = max(Y(:,2),[],'omitnan');
            if ax.Parent == handles.FirstBotPanel
                M = coeff1*M;
            else
                M = coeff2*M;
            end
            button3 = findobj(panels(i),'Tag',sprintf('cmin_%d',j));
            button4 = findobj(panels(i),'Tag',sprintf('cmax_%d',j));
            button3.String = sprintf('%.1f',m);
            button4.String = sprintf('%.1f',M);
            c.Limits = [m,M];
            ax.CLim = [m,M];
        end
        
        % Searching local max and min for all images in axes
        % Storing in X (timing) and Y (values)
        X=[];
        Y=[];
        for k=1:length(im_r)
            x_ind = max(ax_r.XLim(1),im_r(k).XData(1));
            y_ind = min(ax_r.XLim(2),im_r(k).XData(end));
            if y_ind>x_ind
                X = [X;x_ind y_ind];
                indexes = (im_r(k).XData>=x_ind).*(im_r(k).XData<=y_ind);
                [~,ind_min] = min((im_r(k).YData-ax_r.YLim(1)).^2);
                [~,ind_max] = min((im_r(k).YData-ax_r.YLim(2)).^2); 
                temp_ = im_r(k).CData(ind_min:ind_max,indexes==1);
                val_max = mean(mean(temp_,'omitnan'),'omitnan');
                val_min = min(min(temp_,[],'omitnan'),[],'omitnan');
                Y = [Y;val_min val_max];
                %Y = [Y;min(min(temp_,[],'omitnan'),[],'omitnan') max(max(temp_,[],'omitnan'),[],'omitnan')];
            end
        end
        if ~isempty(Y)  
            m = min(Y(:,1),[],'omitnan');
            M = coeff2*max(Y(:,2),[],'omitnan');
            button3 = findobj(panels(i),'Tag',sprintf('cmin_%d',j));
            button4 = findobj(panels(i),'Tag',sprintf('cmax_%d',j));
            button3.String = sprintf('%.1f',m);
            button4.String = sprintf('%.1f',M);
            c.Limits = [m,M];
            ax_r.CLim = [m,M];
        end
        
        %Traces
        m=NaN;
        M=NaN;
        for k=1:length(lines)
            x_ind = ax.XLim(1);
            y_ind = ax.XLim(2);
            indexes = (lines(k).XData>x_ind).*(lines(k).XData<y_ind);
            M = max(max(lines(k).YData(indexes==1),[],'omitnan'),M);
            m = min(min(lines(k).YData(indexes==1),[],'omitnan'),m);
        end
        try
            if ~isnan(m) && ~isnan(M)
                ax.YLim = [m M];
            end
        catch
            warning('Problem autoscale axis %s',ax.Tag);
        end
        
        %Spectrogram
        if ~isempty(ax_s)
            m=NaN;
            M=NaN;
            for k=1:length(lines_s)
                x_ind = ax.YLim(1);
                y_ind = ax.YLim(2);
                indexes = (lines_s(k).YData>x_ind).*(lines_s(k).YData<y_ind);
                M = max(max(lines_s(k).XData(indexes==1),[],'omitnan'),M);
                m = min(min(lines_s(k).XData(indexes==1),[],'omitnan'),m);
            end
            if ~isnan(m) && ~isnan(M)
                delta = M-m;
                ax_s.XLim = [m M+.1*delta];
            end
        end
    end
end

%     %Automatic Scaling
%     bmin = findobj(handles.SecondBotPanel,'Tag',sprintf('cmin_%d',k));
%     bmax = findobj(handles.SecondBotPanel,'Tag',sprintf('cmax_%d',k));
%     c = findobj(handles.SecondBotPanel,'Tag',sprintf('Colorbar%d',k));
%     %val_max = max(max(im.CData));
%     val_max = 2*mean(mean(im.CData,1,'omitnan'),2,'omitnan');
%     val_min = min(min(im.CData));
%     ax.CLim =[val_min, val_max];
%     c.Limits = [val_min,val_max];
%     bmin.String = sprintf('%.1f',c.Limits(1));
%     bmax.String = sprintf('%.1f',c.Limits(2));
%     % Manual Scaling
%     %c_min = str2double(bmin.String);
%     %c_max = str2double(bmax.String);
%     %caxis(ax,[c_min c_max]);
%     %c = findobj(handles.FirstBotPanel,'Tag',sprintf('Colorbar%d',k));
%     %c.Limits = [c_min,c_max];
%     drawnow;

end
% 
% function template_axes_clickFcn(hObj,~,version,axes,edits)
% 
% f = get_parentfigure(hObj);
% pt_rp = get(hObj,'CurrentPoint');
% Xlim = get(hObj,'XLim');
% Ylim = get(hObj,'YLim');
% 
% if nargin<3
%     version = 0;
% end
% 
% switch version
%     case 0
%         % Single-line
%         all_axes = hObj;
%     case 1
%         % Muti-line (All axes in Figure affected)
%         all_axes = findobj(f,'Type','Axes');
%     case 2
%         % Multi-line (Only axes specified in arguments are affected)
%         all_axes = axes;
% end
% 
% if(pt_rp(1,1)>Xlim(1) && pt_rp(1,1)<Xlim(2) && pt_rp(1,2)>Ylim(1) && pt_rp(1,2)<Ylim(2))
%     set(hObj,'UserData',[pt_rp(1,1),pt_rp(1,2)]);
%     set(f,'WindowButtonMotionFcn', {@template_axes_motionFcn,hObj,all_axes});
%     if nargin>4
%         set(f,'WindowButtonUpFcn', {@template_axes_unclickFcn,hObj,all_axes,edits});
%     else
%         set(f,'WindowButtonUpFcn', {@template_axes_unclickFcn,hObj,all_axes});
%     end
%     
%     for i=1:length(all_axes)
%         line([pt_rp(1,1) pt_rp(1,1)],all_axes(i).YLim,'Tag','T1','Color', 'black','LineWidth',.5,'LineStyle','-','Parent', all_axes(i));
%         t2 = findobj(all_axes(i),'Tag','T2');
%         if isempty(t2)
%             line([pt_rp(1,1) pt_rp(1,1)],all_axes(i).YLim,'Tag','T2','Color', 'black','LineWidth',.5,'LineStyle','-','Parent', all_axes(i));
%         else
%             t2.XData = [pt_rp(1,1) pt_rp(1,1)];
%             %t2.Visible = 'on';
%         end
%         x = [pt_rp(1,1) pt_rp(1,1) pt_rp(1,1) pt_rp(1,1)];
%         y = [all_axes(i).YLim(1) all_axes(i).YLim(2) all_axes(i).YLim(2) all_axes(i).YLim(1)];
%         patch(x,y,[0.5 0.5 0.5],'EdgeColor','none','Tag','T3','FaceAlpha',.5,'LineWidth',.5,'Parent', all_axes(i));
%     end
%     
% end
% 
% if length(edits)>2
%     edits(3).String = datestr(pt_rp(1,1)/(24*3600),'HH:MM:SS.FFF');
% end
% 
% end
% 
% function template_axes_motionFcn(~,~,ax,all_axes)
% 
% pt = get(ax,'CurrentPoint');
% pt1 = get(ax,'UserData');
% 
% %all_axes = findobj(hObj,'Type','Axes');
% for i=1:length(all_axes)
%     c = findobj(all_axes(i),'Tag','T2');
%     d = findobj(all_axes(i),'Tag','T3');
%     if ~isempty(pt1)
%         set(c,'XData',[pt(1,1) pt(1,1)]);
%         set(d,'X',[pt1(1,1),pt1(1,1),pt(1,1),pt(1,1)]);
%     end    
% end
% 
% end
% 
% function template_axes_unclickFcn(hObj,~,ax,all_axes,edits)
% 
% pt1 = get(ax,'UserData');
% if ~isempty(pt1)
%     pt = get(ax,'CurrentPoint');
%     pt2 = [pt(1,1),pt(1,2)];
%     if pt1(1,1)~=pt2(1,1)
%         xlim1 = min(pt1(1,1),pt2(1,1));
%         xlim2 = max(pt1(1,1),pt2(1,1));
%         for k=1:length(all_axes)
%             all_axes(k).XLim =[xlim1,xlim2];
%         end
%         if nargin>3
%             edits(1).String = datestr(xlim1/(24*3600),'HH:MM:SS.FFF');
%             edits(2).String = datestr(xlim2/(24*3600),'HH:MM:SS.FFF');
%         end
%     end
%     
%     %all_axes = findobj(hObj,'Type','Axes');
%     for i=1:length(all_axes)
%         set(all_axes(i),'UserData',[]);
%         %delete(findobj(all_axes(i),'Tag','T1','-or','Tag','T2','-or','Tag','T3'));
%         delete(findobj(all_axes(i),'Tag','T1','-or','Tag','T3'));
%         if pt1(1,1)==pt2(1,1)
%             t2 = findobj(all_axes(i),'Tag','T2');
%             t2.Visible = 'off';
%             if ~strcmp(all_axes(i).Parent.Tag,'BotPanel')
%                 axis(all_axes(i),'auto y');
%             end
%             t2.YData = [all_axes(i).YLim(1) all_axes(i).YLim(2)];
%             t2.Visible = 'on';
%         else
%             delete(findobj(all_axes(i),'Tag','T2'));
%         end
%     end
% end
% 
% set(hObj,'WindowButtonUp','');
% set(hObj,'WindowButtonMotionFcn','');
% end
% 
% function template_buttonBack_Callback(~,~,ax,edits)
% 
% delta = ax(1).XLim(2)-ax(1).XLim(1);
% xlim1 = ax(1).XLim(1)-delta;
% xlim2 = ax(1).XLim(1);
% 
% for i=1:length(ax)
%     ax(i).XLim =[xlim1,xlim2];
% end
% if nargin>3
%     edits(1).String = datestr(xlim1/(24*3600),'HH:MM:SS.FFF');
%     edits(2).String = datestr(xlim2/(24*3600),'HH:MM:SS.FFF');
% end
% 
% end
% 
% function template_buttonMinus_Callback(~,~,ax,edits)
% 
% delta = ax(1).XLim(2)-ax(1).XLim(1);
% xlim2 = ax(1).XLim(2)+delta;
% xlim1 = ax(1).XLim(1);
% 
% for i=1:length(ax)
%     ax(i).XLim =[xlim1,xlim2];   
% end
% 
% if nargin>3
%     edits(1).String = datestr(xlim1/(24*3600),'HH:MM:SS.FFF');
%     edits(2).String = datestr(xlim2/(24*3600),'HH:MM:SS.FFF');
% end
% 
% end
% 
% function template_buttonPlus_Callback(~,~,ax,edits)
% 
% linkaxes(ax,'off')
% delta = ax(1).XLim(2)-ax(1).XLim(1);
% xlim2 = ax(1).XLim(2)-delta/2;
% xlim1 = ax(1).XLim(1);
% for i=1:length(ax)
%     ax(i).XLim =[xlim1,xlim2];
% end
% if nargin>3
%     edits(1).String = datestr(xlim1/(24*3600),'HH:MM:SS.FFF');
%     edits(2).String = datestr(xlim2/(24*3600),'HH:MM:SS.FFF');
% end
% 
% end
% 
% function template_buttonRescale_Callback(~,~,ax,edits)
% 
% l = findobj(ax,'Type','line','-not','Tag','T2','-not','Tag','Tick_peak','-not','Tag','Threshold');
% if length(l)>1
%     l = l(1);
% end
% 
% xlim1 = l.XData(1);
% xlim2 = l.XData(end);
% for i =1:length(ax)
%     ax(i).XLim =[xlim1,xlim2];
% end
% if nargin>3
%     edits(1).String = datestr(xlim1/(24*3600),'HH:MM:SS.FFF');
%     edits(2).String = datestr(xlim2/(24*3600),'HH:MM:SS.FFF');
% end
% 
% end
% 
% function template_buttonScale_Callback(hObj,~,ax)
% 
% %ax = findobj(handles.TopPanel,'Tag','Ax1');
% lines = findobj(ax,'Tag','Trace_Cerep');
% others = findobj(ax,'Tag','Trace_Region','-or','Tag','Trace_RegionGroup','-or','Tag','Trace_Pixel','-or','Tag','Trace_Box','-or','Tag','Trace_Mean');
% visible = findobj(ax,'Visible','on');
% others = visible(ismember(visible,others));
% 
% m = 0;
% M = 0;
% if isempty(others)
%     for k=1:length(lines)
%         m = min(m,min(lines(k).YData));
%         M = max(M,max(lines(k).YData));
%     end
% else
%     for k=1:length(others)
%         m = min(m,min(others(k).YData));
%         M = max(M,max(others(k).YData));
%     end
% end
% 
% switch hObj.Value
%     case 0
%         for i=1:length(lines)
%             scale = lines(i).UserData.scale;
%             lines(i).YData = (lines(i).YData)/scale;
%             lines(i).UserData.scale = 1;
%         end
%     case 1
%         for i=1:length(lines)
%             max_l = max(lines(i).YData);
%             scale = M/max_l;
%             lines(i).YData = lines(i).YData*scale;
%             lines(i).UserData.scale = scale;
%         end
% end
% 
% end
% 
% function template_buttonSkip_Callback(~,~,ax,edits)
% 
% delta = ax(1).XLim(2)-ax(1).XLim(1);
% xlim1 = ax(1).XLim(2);
% xlim2 = ax(1).XLim(2)+delta;
%     
% for i=1:length(ax)
%     ax(i).XLim =[xlim1,xlim2];
% end
% 
% if nargin>3
%     edits(1).String = datestr(xlim1/(24*3600),'HH:MM:SS.FFF');
%     edits(2).String = datestr(xlim2/(24*3600),'HH:MM:SS.FFF');
% end
% 
% end
% 
% function coefs = cmorcwt(EEG,scales,Fb,Fc)
% 
% signal = EEG';
% 
% LB = -8;
% UB = 8;
% N = 2000;
% 
% [psi,xval] = cmorwavf(LB,UB,N,Fb,Fc);
% 
% step = xval(2)-xval(1);
% psi_integ = cumsum(psi)*step;
% psi_integ = conj(psi_integ);
% 
% xval                  = xval-min(xval);
% dxval                 = xval(2);
% xmax                  = xval(length(xval));
% len                   = length(signal);
% coefs                 = zeros(length(scales),len);
% ind                   = 1;
% 
% for a = scales
%    
%     j = [1+floor([0:a*xmax]/(a*dxval))];
%     if length(j)==1 , j = [1 1]; end
%     f            = fliplr(psi_integ(j));
%     coefs(ind,:) = -sqrt(a)*wkeep(diff(conv(signal,f)),len);
%     ind          = ind+1;
%   
% end
% end
% 
% function [psi,X] = cmorwavf(LB,UB,N,Fb,Fc)
% %CMORWAVF Complex Morlet wavelet.
% %   [PSI,X] = CMORWAVF(LB,UB,N) returns the complex Morlet wavelet PSI with
% %   time-decay parameter, FB, and center frequency, FC, equal to 1. The
% %   general expression for the complex Morlet wavelet is: 
% %   PSI(X) = ((pi*FB)^(-0.5))*exp(2*pi*i*FC*X)*exp(-(X^2)/FB). 
% %   X is evaluated on an N-point regular grid in the interval [LB,UB].
% %
% %   [PSI,X] = CMORWAVF(LB,UB,N,FB,FC) returns values of the complex Morlet
% %   wavelet defined by a positive time-decay parameter, FB, and positive
% %   center frequency, FC. Adjusting the time-decay parameter, FB, results
% %   in a reciprocal decay in the frequency domain. Increasing FB results in
% %   slower decay of the wavelet in the time domain and narrower bandwidth
% %   in the frequency domain. Decreasing FB results in faster decay of the
% %   wavelet in the time domain and increased bandwidth in frequency.
% %
% %
% %   See also WAVEINFO.
% 
% %   M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi 09-Jun-99.
% %   Last Revision: 20-Dec-2010.
% %   Copyright 1995-2010 The MathWorks, Inc.
% 
% % Check arguments.
% %-----------------
% nbIn = nargin;
% switch nbIn
%     case {0,1,2} 
%         error(message('Wavelet:FunctionInput:NotEnough_ArgNum'));
%     case 3 
%         Fc = 1; Fb = 1;
%     case 4 
%         if ischar(Fb)
%             label = deblank(Fb);
%             ind   = strncmpi('cmor',label,4);
%             if isequal(ind,1)
%                 label(1:4) = [];
%                 len = length(label);
%                 if len>0
%                     ind = strfind(label,'-');
%                     if isempty(ind)
%                         Fc = []; Fb = []; % error
%                     else
%                         Fb = wstr2num(label(1:ind-1));
%                         label(1:ind) = [];
%                         Fc = wstr2num(label);
%                     end
%                 else
%                     Fb = []; Fc = [];
%                 end
%             else
%                 Fb = []; Fc = []; % error
%             end
%         else
%             Fb = []; Fc = []; % error
%         end
%         
%     case 5 
% end
% if isempty(Fc) || isempty(Fb) , err = 1; else err = 0; end
% if ~err , err = ~isnumeric(Fc) | ~isnumeric(Fb) | (Fc<=0) | (Fb<=0); end
% if err
%     error(message('Wavelet:WaveletFamily:Invalid_WavNum'))
% end
% 
% % Validate attributes on LB,UB, and N
% validateattributes(N,{'numeric'},{'scalar','integer','positive'},...
%     'cmorwavf','N');
% validateattributes(LB,{'numeric'},{'scalar'},'cmorwavf','LB');
% validateattributes(UB,{'numeric'},{'scalar','>',LB},'cmorwavf','UB');
% 
% % compute linearly-spaced grid of X values for wavelet
% X = linspace(LB,UB,N);  
% 
% % Compute values of the Complex Morlet wavelet.
% psi = ((pi*Fb)^(-0.5))*exp(2*1i*pi*Fc*X).*exp(-(X.*X)/Fb);
% end
% 
% function fig = get_parentfigure(fig)
% % if the object is a figure or figure descendent, return the
% % figure. Otherwise return [].
% while ~isempty(fig) && ~strcmp('figure', get(fig,'type'))
%     fig = get(fig,'parent');
% end
% 
% end
