%Cumulative duration of sleep stages

load BigMat
nights = unique(MatREM(:,76));

% dataREM = MatREM(:,[1:2 76]);
% figure, hold on
% for n=1:length(nights)
%     night_infoREM = dataREM((dataREM(:,3)==nights(n)),:);
%     hold on, plot(night_infoREM(:,2), cumsum(night_infoREM(:,1)))
% end
% %correlation total duration N2/REM
% [a,~,c] = unique(MatREM(:,76));
% durREM = [a, accumarray(c,MatREM(:,1))];
% [a,~,c] = unique(MatN2(:,76));
% durN2 = [a, accumarray(c,MatN2(:,1))];
% scatter(durREM(:,2),durN2(:,2));

all_n1_rem = [];
all_n2_rem = [];
all_n3_rem = [];

%loop ove records
for n=1:length(nights)
    night_infoREM = MatREM((MatREM(:,76)==nights(n)),:);
    night_infoN1 = MatN1((MatN1(:,76)==nights(n)),:);
    night_infoN2 = MatN2((MatN2(:,76)==nights(n)),:);
    night_infoN3 = MatN3((MatN3(:,76)==nights(n)),:);

    t_rem = night_infoREM(:,2);
    t_n1 = night_infoN1(:,2);
    t_n2 = night_infoN2(:,2);
    t_n3 = night_infoN3(:,2);

    durcum_rem = cumsum(night_infoREM(:,1));
    durcum_n1 = cumsum(night_infoN1(:,1));
    durcum_n2 = cumsum(night_infoN2(:,1));
    durcum_n3 = cumsum(night_infoN3(:,1));

    debut = max([min(t_rem) min(t_n1) min(t_n2) min(t_n3)]);
    fin = max([t_rem;t_n1;t_n2;t_n3]);
    times = linspace(debut, fin, 30);

    data_n1_rem = zeros(length(times), 3);
    data_n2_rem = zeros(length(times), 3);
    data_n3_rem = zeros(length(times), 3);
    data_sws_rem = zeros(length(times), 3);

    for i=1:length(times)
        data_n1_rem(i,:) = [i max(durcum_n1(t_n1<=times(i))) max(durcum_rem(t_rem<=times(i)))];
        data_n2_rem(i,:) = [i max(durcum_n2(t_n2<=times(i))) max(durcum_rem(t_rem<=times(i)))];
        data_n3_rem(i,:) = [i max(durcum_n3(t_n3<=times(i))) max(durcum_rem(t_rem<=times(i)))];
    end
    
%     %stage duration in the last epoch
%     for i=2:length(times)
%         data_n1_rem(i,:) = [n max(durcum_n1(t_n1<=times(i)))-max(durcum_n1(t_n1<=times(i-1))) max(durcum_rem(t_rem<=times(i)))-max(durcum_rem(t_rem<=times(i-1)))];
%         data_n2_rem(i,:) = [n max(durcum_n2(t_n2<=times(i)))-max(durcum_n2(t_n2<=times(i-1))) max(durcum_rem(t_rem<=times(i)))-max(durcum_rem(t_rem<=times(i-1)))];
%         data_n3_rem(i,:) = [n max(durcum_n3(t_n3<=times(i)))-max(durcum_n3(t_n3<=times(i-1))) max(durcum_rem(t_rem<=times(i)))-max(durcum_rem(t_rem<=times(i-1)))];
%     end
        
    all_n1_rem = [all_n1_rem; data_n1_rem];
    all_n2_rem = [all_n2_rem; data_n2_rem];
    all_n3_rem = [all_n3_rem; data_n3_rem];

end
all_sws_rem = [all_n2_rem(:,1) all_n1_rem(:,2)+all_n2_rem(:,2)+all_n3_rem(:,2) all_n2_rem(:,3)];

%plot
figure, hold on
subplot(2,2,1), hold on
scatter(all_n1_rem(:,2),all_n1_rem(:,3),[],all_n1_rem(:,1),'filled'), hold on,
title('N1 REM'),xlabel('N1'), ylabel('REM')
subplot(2,2,2), hold on
scatter(all_n2_rem(:,2),all_n2_rem(:,3),[],all_n2_rem(:,1),'filled'), hold on,
title('N2 REM'),xlabel('N2'), ylabel('REM')
subplot(2,2,3), hold on
scatter(all_n3_rem(:,2),all_n3_rem(:,3),[],all_n3_rem(:,1),'filled'), hold on,
title('N3 REM'),xlabel('N3'), ylabel('REM')
subplot(2,2,4), hold on
scatter(all_sws_rem(:,2),all_sws_rem(:,3),[],all_sws_rem(:,1),'filled'), hold on,
title('SWS REM'),xlabel('SWS'), ylabel('REM')








