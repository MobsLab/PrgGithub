% HistogramDatasetSlowdyn
% 15.09.2018 KJ
%
% Infos
%   Give information about the subjects of the dataset
%
% SEE 
%   
%

clear
load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))


all_ages = cell2mat(Dir.age);
all_genders = cell2mat(Dir.gender);
all_subject = Dir.subject;


%% Sort by subjects

%unique
subject_age_genders = table(all_subject, all_ages, all_genders);   
subject_info=unique(subject_age_genders);
subject_info = table2cell(subject_info);

%info
subject_name = subject_info(:,1);
subject_age = cell2mat(subject_info(:,2));
subject_gender = cell2mat(subject_info(:,3));


%% On subjects
edges = 20:70;

% Man/woman
nb_man = sum(subject_gender==1);
nb_women = sum(subject_gender==2);

%men age
age_men = subject_age(subject_gender==1);
[histo_y.men, histo_x.men] = histcounts(age_men, edges, 'Normalization','count');
histo_x.men = histo_x.men(1:end-1) + diff(histo_x.men);
%women age
age_women = subject_age(subject_gender==2);
[histo_y.women, histo_x.women] = histcounts(age_women, edges, 'Normalization','count');
histo_x.women = histo_x.women(1:end-1) + diff(histo_x.women);


%% On nights
edges = 20:70;

% Man/woman
nb_man_night = sum(all_genders==1);
nb_women_night = sum(all_genders==2);

%men age
age_men = all_ages(all_genders==1);
[nights_y.men, nights_x.men] = histcounts(age_men, edges, 'Normalization','count');
nights_x.men = nights_x.men(1:end-1) + diff(nights_x.men);
%women age
age_women = all_ages(all_genders==2);
[nights_y.women, nights_x.women] = histcounts(age_women, edges, 'Normalization','count');
nights_x.women = nights_x.women(1:end-1) + diff(nights_x.women);



%% Plot
figure, hold on

%age of subjects
subplot(2,2,1), hold on
bar(histo_x.men, [histo_y.men ; histo_y.women]' , 'stacked');
ylim([0 6]),
legend('man', 'women')
title('Age of subjects ')

%subjects gender
subplot(2,2,2), hold on
bar(1,nb_man, 'b')
bar(2, nb_women, 'r')
set(gca,'xtick',1:2,'XtickLabel',{'men','women'}),
title('Men/Women')

%age
subplot(2,2,3), hold on
bar(nights_x.men, [nights_y.men ; nights_y.women]', 'stacked');
legend('man', 'women')
title('By nights')

%gender
subplot(2,2,4), hold on
bar(1,nb_man_night, 'b')
bar(2, nb_women_night, 'r')
set(gca,'xtick',1:2,'XtickLabel',{'men','women'}),
title('By nights')



