

clear all

Mouse=1224;
Session_type={'Fear','Cond','Ext'};
% [Mouse_names,TestPostSess,TestSess,CondSess,ExtSess,FearSess,TestPreSess,Hab24Sess,HabPreSess,Hab,Sess]=GetAllMouseTaskSessions_BM(Sess,Mouse_To_Do);
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    %Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    CondSessCorrections
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
end

for mouse = 1:length(Mouse_names)
    for sess=1:length(Session_type)
        if sess==1; Sess_To_use=FearSess.(Mouse_names{mouse});
        elseif sess==2; Sess_To_use=CondSess.(Mouse_names{mouse});
        else Sess_To_use=ExtSess.(Mouse_names{mouse});
        end
        Acc.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'accelero');
        LFP_1.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'lfp','channumber',1);
        OBSpec.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'spectrum','prefix','B_Low');
        Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(Sess_To_use,'Epoch','epochname','zoneepoch');
        ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){2},ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}){5});
        LFP_1.(Session_type{sess}).Fz.(Mouse_names{mouse})=Restrict(LFP_1.(Session_type{sess}).(Mouse_names{mouse}),Freeze_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        LFP_1.(Session_type{sess}).Fz_Shock.(Mouse_names{mouse})=Restrict(LFP_1.(Session_type{sess}).Fz.(Mouse_names{mouse}),ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) );
        LFP_1.(Session_type{sess}).Fz_Safe.(Mouse_names{mouse})=Restrict(LFP_1.(Session_type{sess}).Fz.(Mouse_names{mouse}),SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
    end
end

cd('/home/mobsmorty/Desktop/Data_Spectro/')

Y=Data(LFP_1.Fear.Fz.M1224);
delta = .0008;
X=(1:length(Y))'*delta;
x_start = X(1);
f = X(1);
x_end = X(end);
save('LFP_fear_Fz.mat','x_start','x_end','f','Y');

clear Y X x_start f x_end
Y=Data(LFP_1.Fear.Fz_Shock.M1224);
delta = .0008;
X=(1:length(Y))'*delta;
x_start = X(1);
f = X(1);
x_end = X(end);
save('LFP_fear_Fz_Shock.mat','x_start','x_end','f','Y');

clear Y X x_start f x_end
Y=Data(LFP_1.Fear.Fz_Safe.M1224);
delta = .0008;
X=(1:length(Y))'*delta;
x_start = X(1);
f = X(1);
x_end = X(end);
save('LFP_fear_Fz_Safe.mat','x_start','x_end','f','Y');


GUI_Wavelet_Analysis_AB

f1=2;
f2=6;
fs=1/f;
[B,A]  = butter(1,[f1 f2]/(fs/2),'bandpass');
Y_temp = filtfilt(B,A,Y);
t_smooth=1; %in seconds

X_filt= X(1:100:end);
Y_filt= Y(1:100:end);

% fl = max(round(t_smooth/(X_filt(2)-X_filt(1))),1);
% [Y_env_up,Y_env_down] = envelope(Y_filt,fl,'analytic');
fprintf('Smoothing [%.1f s]...',t_smooth);
f_filt = 1/(X_filt(2)-X_filt(1));
[Y_env_up,~] = envelope(Y_filt);

% %Gaussian smoothing
n = max(round(t_smooth*f_filt),1);
Y_env = conv(Y_env_up,gausswin(n)/n,'same');
fprintf(' done;\n');

% Subsampling envelope
ftemp = 5/t_smooth;
if ftemp < f_filt
    X_power = (X_filt(1):1/ftemp:X_filt(end))';
    Y_power = interp1(X_filt,Y_env,X_power);
else
    X_power = X_filt;
    Y_power = Y_env_up;
end





%%

plot(X_power,Y_power)









