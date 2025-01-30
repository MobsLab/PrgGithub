Mice = [756 758 761 763 765 ; 757 759 760 762 764];

Gr(1,1)=5;
Gr(1,2)=5;

MatNum=[];
MiceNumber = [756 757 758 759 760 761 762 763 764 765];
for k = 1:size(Mice,1)
    for j = 1 : Gr(1,k)
        MatNum(k,j) = find(MiceNumber==Mice(k,j));
    end
end

% temperature (body, tail, eye) VS speed
clf
all_eye_vals = [];
all_body_vals = [];
all_tail_vals = [];
all_speed_vals = [];
for i = 1:5
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(MatNum(1,i))),'-16062018-Hab_00'])
    load('ManualTemp.mat')
    load('behavResources.mat')
    x = naninterp(Temp_body_InDegrees);
    y = interp1(Range(Vtsd,'s'),Data(Vtsd),Temp_time);
    subplot(131)
    plot(x,y,'.')
    hold on
    xlabel('body temperature (°C)')
    ylabel('speed (cm/s)')
    ylim([0 3])
    xlim([24 40])
    [R,P] = corrcoef(x',y');
    R_all_body(i) = R(1,2);
    P_all_body(i) = P(1,2);
    all_body_vals = [all_body_vals,Temp_body_InDegrees];
    y = interp1(Range(Vtsd,'s'),Data(Vtsd),[0:5:900]);
    all_speed_vals(i,:) = y;
    
    x = naninterp(Temp_eye_InDegrees);
    y = interp1(Range(Vtsd,'s'),Data(Vtsd),Temp_time);
    subplot(132)
    plot(x,y,'.')
    hold on
    xlabel('eyes temperature (°C)')
    ylabel('speed (cm/s)')
    xlim([24 40])
    [R,P] = corrcoef(x',y');
    R_all_eye(i) = R(1,2);
    P_all_eye(i) = P(1,2);
    all_eye_vals = [all_eye_vals,Temp_eye_InDegrees];
    
    x = naninterp(Temp_tail_InDegrees);
    y = interp1(Range(Vtsd,'s'),Data(Vtsd),Temp_time);
    subplot(133)
    plot(x,y,'.')
    hold on
    xlabel('tail temperature (°C)')
    ylabel('speed (cm/s)')
    xlim([24 40])
    [R,P] = corrcoef(x',y');
    R_all_tail(i) = R(1,2);
    P_all_tail(i) = P(1,2);
    all_tail_vals = [all_tail_vals,Temp_tail_InDegrees];
    
end


% speed n temperature over the exploration session 
for i = 1 : length(MiceNumber)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(MiceNumber(i)),'-12062018-Hab_00'])
    load('behavResources.mat')
    speed{i} = Data(Vtsd);
    for k = 1:10:900
        speed_sub{i}((k+9)/10) = nanmean(Data(Restrict(Vtsd,intervalSet(k*1e4,(k+10)*1e4))));
    end
    
    % temperature
    temp{i} = MouseTemp(:,2);
    MouseTemp(find(MouseTemp(:,1)==0),:) = [];
    MouseTemptsd = tsd(MouseTemp(:,1)*1e4,MouseTemp(:,2));
    for k = 1:10:900
        temp_sub{i}((k+9)/10) = nanmean(Data(Restrict(MouseTemptsd,intervalSet(k*1e4,(k+10)*1e4))));
    end
end

figure
cols = {'r','b'};
for k = 1:2
    for m=1:5
        
        subplot(211)
        plot(runmean(speed{MatNum(k,m)},300),'color',cols{k}), hold on
        
        title('speed')
        subplot(212)
        plot(runmean(double(temp{MatNum(k,m)}),20),'color',cols{k}), hold on
        title('temp')
       
    end
end

