function varargout = Dicom_Viewer(varargin)
% DICOM_VIEWER MATLAB code for Dicom_Viewer.fig
%      DICOM_VIEWER, by itself, creates a new DICOM_VIEWER or raises the existing
%      singleton*.
%
%      H = DICOM_VIEWER returns the handle to a new DICOM_VIEWER or the handle to
%      the existing singleton*.
%
%      DICOM_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICOM_VIEWER.M with the given input arguments.
%
%      DICOM_VIEWER('Property','Value',...) creates a new DICOM_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Dicom_Viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Dicom_Viewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Dicom_Viewer

% Last Modified by GUIDE v2.5 13-Jul-2016 16:35:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Dicom_Viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @Dicom_Viewer_OutputFcn, ...
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


% --- Executes just before Dicom_Viewer is made visible.
function Dicom_Viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Dicom_Viewer (see VARARGIN)

% Choose default command line output for Dicom_Viewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Dicom_Viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Dicom_Viewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in series_list.
function series_list_Callback(hObject, eventdata, handles)
% hObject    handle to series_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns series_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from series_list
handles.output = hObject;
index = get(handles.series_list,'value');
if isempty(index)   
    return; 
end
handles.CurrentImage = handles.DataSet(index).data;
handles.CurrentInfo = handles.DataSet(index).tag;
set(handles.description_txt, 'String', handles.CurrentInfo.AcquisitionTime);
[x y z] = size(handles.CurrentImage);
hh = reslice_data(handles.CurrentImage);
% view1 
temp = get(handles.slider1,'Value');
if temp == 0
    immx = hh.reslice('x',1);
else
    immx = hh.reslice('x',int16( x * temp));
end
imshow(immx,[],'Parent',handles.view1);
% view2
temp = get(handles.slider2,'Value');
if temp == 0
    immy = hh.reslice('y',1);
else
    immy = hh.reslice('y',int16( y * temp));
end
imshow(immy,[],'Parent',handles.view2);
% view3
temp = get(handles.slider3,'Value');
if temp ==0
    immz = hh.reslice('z',1);
else
    immz = hh.reslice('z',int16( z * temp));
end
imshow(immz,[],'Parent',handles.view3);

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function series_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to series_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.output = hObject;
temp_folder = uigetdir('D:\QIN\image');
if temp_folder == 0
    return;
end
handles.DataSet = Load_Dicom_Series(temp_folder,'PatientName','SeriesDescription','AcquisitionTime');
lists = [];
len_set = length(handles.DataSet);
if len_set<1
    return
end
for i = 1: len_set
    temp_str = cellstr(handles.DataSet(i).tag.SeriesDescription);
    lists = [lists,temp_str];
end
handles.CurrentImage = handles.DataSet(1).data;
handles.CurrentInfo = handles.DataSet(1).tag;
set(handles.series_list,'string',lists);
index = get(handles.series_list,'value');
if isempty(index)   
    return; 
end

% refresh view
set(handles.description_txt, 'String', handles.CurrentInfo.AcquisitionTime);
hh = reslice_data(handles.CurrentImage);
immx = hh.reslice('x',1);
imshow(immx,[],'Parent',handles.view1);
immy = hh.reslice('y',1);
imshow(immy,[],'Parent',handles.view2);
immz = hh.reslice('z',1);
imshow(immz,[],'Parent',handles.view3);

guidata(hObject, handles);


% --- Executes on button press in select_series.
function select_series_Callback(hObject, eventdata, handles)
% hObject    handle to select_series (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;
slider = handles.slider1;
slider_txt = handles.slice1_txt;
view = handles.view1;
ori = 'x';
Slider_Callback_Templete(hObject, eventdata, handles,slider,slider_txt,view,ori)
guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;
slider = handles.slider2;
slider_txt = handles.slice2_txt;
view = handles.view2;
ori = 'y';
Slider_Callback_Templete(hObject, eventdata, handles,slider,slider_txt,view,ori)
guidata(hObject, handles);





% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;
slider = handles.slider3;
slider_txt = handles.slice3_txt;
view = handles.view3;
ori = 'z';
Slider_Callback_Templete(hObject, eventdata, handles,slider,slider_txt,view,ori)
guidata(hObject, handles);








% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_time_Callback(hObject, eventdata, handles)
% hObject    handle to slider_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.output = hObject;

time_points = length(handles.DataSet);
if time_points>0
    set(handles.slider_time, 'SliderStep', [1/time_points,1/time_points]);
end
index =int16( time_points * get(hObject,'Value')); 
if ~(index>0)
    index = 1;
end
handles.CurrentImage = handles.DataSet(index).data;
handles.CurrentInfo = handles.DataSet(index).tag;
set(handles.description_txt, 'String', handles.CurrentInfo.AcquisitionTime);
set(handles.text6, 'String', num2str(index));
% current data
[x y z] = size(handles.CurrentImage);
hh = reslice_data(handles.CurrentImage);
% view1
index =int16( x * get(handles.slider1,'Value')); 
if ~(index>0)
    index = 1;
end
set(handles.slider1, 'String', num2str(index));
immz = hh.reslice('x',index);
imshow(immz,[],'Parent',handles.view1);
% view 2
index =int16( y * get(handles.slider2,'Value')); 
if ~(index>0)
    index = 1;
end
set(handles.slider2, 'String', num2str(index));
immz = hh.reslice('y',index);
imshow(immz,[],'Parent',handles.view2);
% view 3
index =int16( z * get(handles.slider3,'Value')); 
if ~(index>0)
    index = 1;
end
set(handles.slider3, 'String', num2str(index));
immz = hh.reslice('z',index);
imshow(immz,[],'Parent',handles.view3);

guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function slider_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in seg_button.
function seg_button_Callback(hObject, eventdata, handles)
% hObject    handle to seg_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in overlay_button.
function overlay_button_Callback(hObject, eventdata, handles)
% hObject    handle to overlay_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get file
[filename,filepath] = uigetfile('D:/QIN/matlab/dicom_viewer/*.*');
handles.output = hObject;
if filename == 0
    return;
end
name = fullfile(filepath,filename);
data = load(name);
data_name = char(fieldnames(data));
% Set to overlayimage
handles.OverlayImage = data.(data_name);
% refresh view
%Show_Overlay(hObject,handles);
guidata(hObject, handles);


function edit_gray_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gray as text
%        str2double(get(hObject,'String')) returns contents of edit_gray as a double


% --- Executes during object creation, after setting all properties.
function edit_gray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_x as text
%        str2double(get(hObject,'String')) returns contents of edit_x as a double


% --- Executes during object creation, after setting all properties.
function edit_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_y as text
%        str2double(get(hObject,'String')) returns contents of edit_y as a double


% --- Executes during object creation, after setting all properties.
function edit_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_z_Callback(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_z as text
%        str2double(get(hObject,'String')) returns contents of edit_z as a double


% --- Executes during object creation, after setting all properties.
function edit_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Slider call back templete function
% Input several parameters and all slider function will call it
function Slider_Callback_Templete(hObject, ~, handles,slider,slider_txt,view,ori)
%slider: handles.slider
%slider_txt: slider's string text
%view: handles.view
%ori: x,y,z (text)
%
if ~isfield(handles,'CurrentImage')
    return;
end
[x,y,z] = size(handles.CurrentImage);

xx = 1;
switch ori
    case 'x'
       xx = x;
    case 'y'
       xx = y;
    case 'z' 
       xx = z;
    otherwise
       xx = x;
end
        
if xx>1
set(slider, 'SliderStep', [1/xx,1/xx]);
end
index =int16( xx * get(hObject,'Value')); 
if ~(index>0)
    index = 1;
end
set(slider_txt, 'String', num2str(index));
hh = reslice_data(handles.CurrentImage);

imm = hh.reslice(ori,index);
imshow(imm,[],'Parent',view);
if isfield(handles,'OverlayImage')
    vv = reslice_data(handles.OverlayImage);
    overlay = vv.reslice(ori,index);
    overlay = ind2rgb(overlay,[0 0 0;1 0 0]);
    hold on;
    hImage = imshow(overlay);
    set(hImage, 'AlphaData', 0.5);
    hold off;
end





