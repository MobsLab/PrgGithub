function varargout = GetMissingExpeInfo_BaselineSleep(varargin)
% GETMISSINGEXPEINFO_BASELINESLEEP MATLAB code for GetMissingExpeInfo_BaselineSleep.fig
%      GETMISSINGEXPEINFO_BASELINESLEEP, by itself, creates a new GETMISSINGEXPEINFO_BASELINESLEEP or raises the existing
%      singleton*.
%
%      H = GETMISSINGEXPEINFO_BASELINESLEEP returns the handle to a new GETMISSINGEXPEINFO_BASELINESLEEP or the handle to
%      the existing singleton*.
%
%      GETMISSINGEXPEINFO_BASELINESLEEP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GETMISSINGEXPEINFO_BASELINESLEEP.M with the given input arguments.
%
%      GETMISSINGEXPEINFO_BASELINESLEEP('Property','Value',...) creates a new GETMISSINGEXPEINFO_BASELINESLEEP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GetMissingExpeInfo_BaselineSleep_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GetMissingExpeInfo_BaselineSleep_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GetMissingExpeInfo_BaselineSleep

% Last Modified by GUIDE v2.5 24-Jan-2025 11:30:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GetMissingExpeInfo_BaselineSleep_OpeningFcn, ...
                   'gui_OutputFcn',  @GetMissingExpeInfo_BaselineSleep_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GetMissingExpeInfo_BaselineSleep is made visible.
function GetMissingExpeInfo_BaselineSleep_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GetMissingExpeInfo_BaselineSleep (see VARARGIN)


% Choose default command line output for GetMissingExpeInfo_BaselineSleep
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

load('ExpeInfo.mat')
handles.ExpeInfo = ExpeInfo;
guidata(hObject, handles);


% UIWAIT makes GetMissingExpeInfo_BaselineSleep wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GetMissingExpeInfo_BaselineSleep_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
TempData = guidata(hObject);
items = get(hObject,'String');
TempData.ExpeInfo.Experimenter = strtrim(items(get(hObject,'Value'),:));
guidata(hObject,TempData)


% --- Executes during object creation, after setting all properties.
function Epxerimenter_List_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
LabMemberNomenclature
set(hObject,'string',strjoin(LabMemberName,'|'))



% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
TempData = guidata(hObject);
TempData.ExpeInfo.PreProcessingInfo.DoSpikes = hObject.Value;
guidata(hObject,TempData)


% --- Executes on selection change in popupmenu2.
function SpikeRegions_Callback(hObject, eventdata, handles)
TempData = guidata(hObject);
items = get(hObject,'String');
TempData.ExpeInfo.SpikeRegion = strtrim(items(get(hObject,'Value'),:));
guidata(hObject,TempData)

% --- Executes during object creation, after setting all properties.
function SpikeRegions_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
ChannelsToAnalyseNomenclature
set(hObject,'string',strjoin(locations_to_analyse,'|'))


function ImDone_Callback(hObject, eventdata, handles)
ExpeInfo = handles.ExpeInfo;
save('ExpeInfo.mat','ExpeInfo')
handles.figure1.delete
