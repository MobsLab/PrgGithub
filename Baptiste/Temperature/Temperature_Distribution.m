function Distribution= Temperature_Distribution(Mouse_name,FolderList,BodyPart)

%Put a Mouse name (number), the Folder List (in FolderList.Mxxx.App format)
%and the body part and it will plot the distribution figures associated 

Mouse_names={['M' num2str(Mouse_name)]};
i=1;

switch BodyPart
    case 'Tail'
        tsd_used='Temp.TailTemperatureTSD';
    case 'Body'
        tsd_used='Temp.BodyTemperatureTSD';
    case 'Mouse'
        tsd_used='Temp.MouseTemperatureTSD';
    case 'Room'
        tsd_used='Temp.RoomTemperatureTSD';
        case 'Tail_Room'
        tsd_used='tsd([Range(Temp.TailTemperatureTSD)],[Data(Temp.TailTemperatureTSD)-0.804.*Data(Temp.RoomTemperatureTSD)])';
    case 'Body_Room'
        tsd_used='tsd([Range(Temp.TailTemperatureTSD)],[Data(Temp.BodyTemperatureTSD)-0.561.*Data(Temp.RoomTemperatureTSD)])';
    case 'Mouse_Room'
        tsd_used='tsd([Range(Temp.TailTemperatureTSD)],[Data(Temp.MouseTemperatureTSD)-0.381.*Data(Temp.RoomTemperatureTSD)])';
end

% Generate Temperature during all sessions
app={'Total'};
error={};
tps = 0; % this variable counts the total time of all concatenated data
Distribution.(app{1}) = tsd([],[]);
for ff=1:length(FolderList.(Mouse_names{i}).Total)
    try cd([FolderList.(Mouse_names{i}).Total{ff}  '/Temperature'])
        load('Temperature.mat')

        tpsmax = max(Range(eval(tsd_used))); % use Behav.Xtsd to get precise end time
        if isempty(tpsmax); tpsmax=0; end
        rg = Range(eval(tsd_used));
        dt = Data(eval(tsd_used));
        Distribution.(app{1})= tsd([Range(Distribution.(app{1}));rg+tps],[Data(Distribution.(app{1}));dt]);
        tps=tps + tpsmax;
    catch error{ff}=FolderList.(Mouse_names{i}).Total{ff};
    end
end
        
% Generate Temperature during fear sessions
app={'Fear'};
error={};
tps = 0; % this variable counts the total time of all concatenated data
Distribution.(app{1}) = tsd([],[]);
for ff=1:length(FolderList.(Mouse_names{i}).Fear)
    try cd([FolderList.(Mouse_names{i}).Fear{ff}  '/Temperature'])
        load('Temperature.mat')

        tpsmax = max(Range(eval(tsd_used))); % use Behav.Xtsd to get precise end time
        if isempty(tpsmax); tpsmax=0; end
        rg = Range(eval(tsd_used));
        dt = Data(eval(tsd_used));
        Distribution.(app{1})= tsd([Range(Distribution.(app{1}));rg+tps],[Data(Distribution.(app{1}));dt]);
        tps=tps + tpsmax;
    catch error{ff}=FolderList.(Mouse_names{i}).Fear{ff};
    end
end


% Generate Temperature during freezing for fear sessions
app={'FearFz'};
error={};
tps = 0; % this variable counts the total time of all concatenated data
Distribution.(app{1}) = tsd([],[]);
for ff=1:length(FolderList.(Mouse_names{i}).Fear)
    try cd([FolderList.(Mouse_names{i}).Fear{ff}  '/Temperature'])
        load('Temperature.mat')
        load('behavResources_SB.mat')

        tpsmax = max(Range(Restrict(eval(tsd_used),Behav.FreezeAccEpoch))); % use Behav.Xtsd to get precise end time
        if isempty(tpsmax); tpsmax=0; end
        rg = Range(Restrict(eval(tsd_used),Behav.FreezeAccEpoch));
        dt = Data(Restrict(eval(tsd_used),Behav.FreezeAccEpoch));
        Distribution.(app{1})= tsd([Range(Distribution.(app{1}));rg+tps],[Data(Distribution.(app{1}));dt]);
        tps=tps + tpsmax;
    catch error{ff}=FolderList.(Mouse_names{i}).Fear{ff};
    end
end


for zones=[1 2 4 5]
    % Generate Temperature during freezing for fear sessions of zones
    app={'FearFz1','FearFz2','x','FearFz4','FearFz5'};
    error={};
    tps = 0; % this variable counts the total time of all concatenated data
    Distribution.(app{zones}) = tsd([],[]);
    for ff=1:length(FolderList.(Mouse_names{i}).Fear)
        try cd([FolderList.(Mouse_names{i}).Fear{ff}  '/Temperature'])
            load('Temperature.mat')
            load('behavResources_SB.mat')

            tpsmax = max(Range(Restrict(eval(tsd_used),and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{zones})))); % use Behav.Xtsd to get precise end time
            if isempty(tpsmax); tpsmax=0; end
            rg = Range(Restrict(eval(tsd_used),and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{zones})));
            dt = Data(Restrict(eval(tsd_used),and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{zones})));
            Distribution.(app{zones})= tsd([Range(Distribution.(app{zones}));rg+tps],[Data(Distribution.(app{zones}));dt]);
            tps=tps + tpsmax;
        catch error{ff}=FolderList.(Mouse_names{i}).Fear{ff};
        end
    end
end   

tpsmax = max(Range(Distribution.FearFz2));
Distribution.FearFzSafe=tsd([Range(Distribution.FearFz2);Range(Distribution.FearFz5)+tpsmax],[Data(Distribution.FearFz2);Data(Distribution.FearFz5)]);
tpsmax = max(Range(Distribution.FearFz1));
Distribution.FearFzShock=tsd([Range(Distribution.FearFz1);Range(Distribution.FearFz4)+tpsmax],[Data(Distribution.FearFz1);Data(Distribution.FearFz4)]);

figure
subplot(2,2,1)
a=Data(Distribution.Total);
b=Data(Distribution.Fear);
histfit(a); hold on; histfit(b);
pd1=fitdist(a,'Normal'); pd2=fitdist(b,'Normal');
xlabel('Temperature'); xlim([15 40]);
char_1=['mu = ' num2str(pd1.mu) '     sigma = ' num2str(pd1.sigma)];
char_2=['mu = ' num2str(pd2.mu) '     sigma = ' num2str(pd2.sigma)];
l=length(b)/length(a);
legend(['All sessions ' char_1],'',['Fear sessions     ' num2str(l) '     ' char_2])
title('All sessions / Fear sessions')
is_nan=sum(isnan(Data(Distribution.Fear)))/length(Distribution.Fear);
suptitle([BodyPart '     ' Mouse_names{1} '        NaN=' num2str(is_nan) '%'])

subplot(2,2,2)
a=Data(Distribution.Fear);
b=Data(Distribution.FearFz);
h_a=histfit(a); hold on; h_b=histfit(b);
pd1=fitdist(a,'Normal'); pd2=fitdist(b,'Normal');
xlabel('Temperature'); xlim([15 40]);
char_1=['mu = ' num2str(pd1.mu) '     sigma = ' num2str(pd1.sigma)];
char_2=['mu = ' num2str(pd2.mu) '     sigma = ' num2str(pd2.sigma)];
l=length(b)/length(a);
legend(['Fear sessions ' char_1],'',['Freezing     ' num2str(l) '     ' char_2])
title('Fear sessions / Freezing')

subplot(2,2,3)
a=Data(Distribution.FearFz);
b=[Data(Distribution.FearFz1);Data(Distribution.FearFz4)];
histfit(a); hold on; histfit(b);
pd1=fitdist(a,'Normal'); pd2=fitdist(b,'Normal');
xlabel('Temperature'); xlim([15 40]);
char_1=['mu = ' num2str(pd1.mu) '     sigma = ' num2str(pd1.sigma)];
char_2=['mu = ' num2str(pd2.mu) '     sigma = ' num2str(pd2.sigma)];
l=length(b)/length(a);
legend(['Freezing' char_1],'',['Shock zone Fz     ' num2str(l) '     ' char_2])
title('Freezing / Shock zone freezing')

subplot(2,2,4)
a=Data(Distribution.FearFz);
b=[Data(Distribution.FearFz2);Data(Distribution.FearFz5)];
histfit(a); hold on; histfit(b);
pd1=fitdist(a,'Normal'); pd2=fitdist(b,'Normal');
xlabel('Temperature'); xlim([15 40]);
char_1=['mu = ' num2str(pd1.mu) '     sigma = ' num2str(pd1.sigma)];
char_2=['mu = ' num2str(pd2.mu) '     sigma = ' num2str(pd2.sigma)];
l=length(b)/length(a);
legend(['Freezing' char_1],'',['Safe zone Fz     ' num2str(l) '     ' char_2])
title('Freezing / Safe zone freezing')
end