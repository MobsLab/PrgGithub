function A = DIRACTimeCourseFigs(A)

plotTimeCourse = false;

A = registerResource(A, 'ReactTimeCourseR', 'tsdArray', {1, 1}, ...
    'reactTimeCourseR', ...
    'reactivation correlation at time T');
A = registerResource(A, 'ReactTimeCourseRhi', 'tsdArray', {1, 1}, ...
    'reactTimeCourseRhi', ...
    'reactivation correlation at time T, upper end of bootstrap interval');
A = registerResource(A, 'ReactTimeCourseRlo', 'tsdArray', {1, 1}, ...
    'reactTimeCourseRlo', ...
    'reactivation correlation at time T, lower end of bootstrap interval');
warning off


% $$$     [A, pyr] = getResource(A, 'IsPyramid');
% $$$     pyr = find(pyr);

[A, frate_sleep1] = getResource(A, 'FRateSleep1');
[A, frate_sleep2] = getResource(A, 'FRateSleep2');
[A, frate_presleep1] = getResource(A, 'FRatePreSleep1');
[A, frate_postsleep2] = getResource(A, 'FRatePostSleep2');

[A, frate_binned_s1] = getResource(A, 'FRateBinnedS1');
[A, frate_binned_s2] = getResource(A, 'FRateBinnedS2');
[A, frate_maze] = getResource(A, 'FRateMaze');
pyr = max([frate_maze frate_sleep1 frate_sleep2], [], 2) > 0.5;

frate_maze = frate_maze(pyr);
frate_sleep1 = frate_sleep1(pyr);
frate_sleep2 = frate_sleep2(pyr);
frate_presleep1 = frate_presleep1(pyr);
frate_postsleep2 =  frate_postsleep2(pyr);

fr_s1 = Data(frate_binned_s1{1});
for i = 2:length(frate_binned_s1)
    fr_s1 = [fr_s1 Data(frate_binned_s1{i})];
end
fr_s1 = fr_s1(:,pyr);
fr_s1 = fr_s1';



fr_s2 = Data(frate_binned_s2{1});
for i = 2:length(frate_binned_s2)
    fr_s2 = [fr_s2 Data(frate_binned_s2{i})];
end
fr_s2 = fr_s2(:,pyr);
fr_s2 = fr_s2';

for i = 1:size(fr_s2, 2);

    [r,clo, chi] = ...
        nancorrcoef(log10(frate_maze ./ frate_presleep1), ...
        log10(fr_s2(:,i) ./ frate_sleep1), 0.05, 'bootstrap');

    R(i) = r(1,2);
    R_lo(i) = clo(1,2);
    R_hi(i) = chi(1,2);


end


t = Range(frate_binned_s2{1}, 's');
t = t - t(1) +180;

reactTimeCourseR = tsd(t(:), R(:));
reactTimeCourseRhi= tsd(t(:), R_hi(:));
reactTimeCourseRlo = tsd(t(:), R_lo(:));

if plotTimeCourse
    clf;
    plot(t, R);
    hold on 
    plot(t,R_hi, '--');
    plot(t,R_lo, '--');
    keyboard
end

A = SaveAllResources(A);
