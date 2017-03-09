%Audio recorder and analyzer has been built using GUIDE in MATLAB. It is a 
%simple yet powerful program for interactive display for sound visualization 
%in the form of waveforms and spectrograms. It can read and write audio files 
%in .wav format and run on any system with MATLAB R2012 and above. 

%By Roshni Biswas and Sonali Patro
%PD Lab Project, NIT Rourkela
%Guide: Prof. AK Turuk


function varargout = lab1(varargin)
% LAB1 MATLAB code for lab1.fig
%      LAB1, by itself, creates a new LAB1 or raises the existing
%      singleton*.
%
%      H = LAB1 returns the handle to a new LAB1 or the handle to
%      the existing singleton*.
%
%      LAB1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAB1.M with the given input arguments.
%
%      LAB1('Property','Value',...) creates a new LAB1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before lab1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to lab1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help lab1

% Last Modified by GUIDE v2.5 03-Nov-2016 00:55:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lab1_OpeningFcn, ...
                   'gui_OutputFcn',  @lab1_OutputFcn, ...
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


% --- Executes just before lab1 is made visible.
function lab1_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to lab1 (see VARARGIN)

% Choose default command line output for lab1
handles.output = hObject;
% set the sample rate (Hz)
 handles.Fs       = 8192;
 % create the recorder
 handles.recorder = audiorecorder(handles.Fs,8,1);
 % assign a timer function to the recorder
 set(handles.recorder,'TimerPeriod',1,'TimerFcn',{@audioTimer,hObject});
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes lab1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = lab1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1,'reset');
filename=get(handles.edit1,'string');
[y,fs]=audioread(get(handles.edit1,'string'));
sound(y);
%x=fft(y,1);
if(get(handles.radiobutton1,'Value') == 1)
axes(handles.axes1);
hold on
plot(y);
hold off
end
if(get(handles.radiobutton2,'Value') == 1)
 M = round (0.02*fs); % 20 ms window 
 N = 2^nextpow2 (4*M); % zero padding for interpolation 
 w = hamming (M); % hamming command 
 axes(handles.axes1);
 hold on
 spectrogram (y, w, 60, N, fs, 'yaxis'); % draw the spectrogram using 60% overlapping of the windows 
 hold off
end
info=audioinfo(filename);
set(handles.edit2,'string',struct2str(info));




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1,'reset');
record(handles.recorder);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileName= uigetfile('*.wav','select a wave file');
%nwavfile{1,1}=fullfile(pathname,filesep,filename);
%ExPath = fullfile(FilePath,FileName);
set(handles.edit1,'string',FileName);

function audioTimer(hObject,varargin)
% get the handle to the figure/GUI  (this is the handle we passed in 
 % when creating the timer function in myGuiName_OpeningFcn)
 hFigure = varargin{2};
 % get the handles structure so we can access the plots/axes
 handles = guidata(hFigure);
 % get the audio samples
 samples  = getaudiodata(hObject);
 % etc.

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%y=0;
fs=44100;
stop(handles.recorder);
 recorder = handles.recorder;
 y=getaudiodata(recorder);
 filename = [datestr(now,'yyyy-mm-dd_HHMMSS') '.wav'];
 audiowrite(filename,y,fs);
 [s]=audioread(filename);
 sound(s);
if(get(handles.radiobutton1,'Value') == 1)
axes(handles.axes1);
hold on
plot(y);
hold off
end
if(get(handles.radiobutton2,'Value') == 1)
 M = round (0.02*fs); % 20 ms window 
 N = 2^nextpow2 (4*M); % zero padding for interpolation 
 w = hamming (M); % hamming command 
 axes(handles.axes1);
 hold on
 spectrogram (y, w, 60, N, fs, 'yaxis'); % draw the spectrogram using 60% overlapping of the windows 
 hold off
end
 info=audioinfo(filename);
 set(handles.edit2,'string',struct2str(info));


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, ~)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F = getframe(handles.axes1);
Image = frame2im(F);
filename = [datestr(now,'yyyy-mm-dd_HHMMSS') '.jpg'];
imwrite(Image, filename)


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hLine = plot(rand(1,10));
hLine.ButtonDownFcn = 'disp(''This executes'')';
hLine.Tag = 'DoNotIgnore';
h = zoom;
h.ButtonDownFilter = @mycallback;
h.Enable = 'on';
% mouse click on the line
%
function [flag] = mycallback(obj,event_obj)
% If the tag of the object is 'DoNotIgnore', then return true.
objTag = obj.Tag;
if strcmpi(objTag,'DoNotIgnore')
   flag = true;
else
   flag = false;
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton6.
function pushbutton6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hLine = plot(rand(1,10));
hLine.ButtonDownFcn = 'disp(''This executes'')';
hLine.Tag = 'DoNotIgnore';
h = zoom;
h.ButtonDownFilter = @mycallback;
h.Enable = 'on';
% mouse click on the line
%
function [flag] = mycallback(obj,event_obj)
% If the tag of the object is 'DoNotIgnore', then return true.
objTag = obj.Tag;
if strcmpi(objTag,'DoNotIgnore')
   flag = true;
else
   flag = false;
end
