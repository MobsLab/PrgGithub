function [Dir,nameSessions]=NREMstages_path(NamePath)
%
% NamePath= 'SD6h' or 'SD24h' or 'OR'
%
% list of related scripts in NREMstages_scripts.m

disp(['Loading paths for data ',NamePath])

if strcmp(NamePath,'SD6h')
    
    nameSessions{1}='DayBSL';
    nameSessions{2}='nightBSL';
    nameSessions{3}='DaySD6h';
    nameSessions{4}='nightSD6h';
    nameSessions{5}='Day+24h';
    nameSessions{6}='night+24h';
    
    % ------------ 294 ------------
    Dir{1,1}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160628';%ok
    Dir{1,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160628-night';% tout pourris
    Dir{1,3}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160629';% refait->Run
    Dir{1,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160629-night';
    Dir{1,5}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160630';%ok
    Dir{1,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160630-night';
    
    % ------------ 330 ------------
    Dir{2,1}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160628';% refait->Run
    Dir{2,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160628-night';
    Dir{2,3}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160629';% ->Run
    Dir{2,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160629-night';
    Dir{2,5}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160630';%ok
    Dir{2,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160630-night';
    
    % ------------ 393 ------------
    Dir{3,1}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160718'; % pas de signaux début rec
    Dir{3,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160718-night';
    %Dir{3,1}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160711';
    %Dir{3,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160711-night';
    Dir{3,3}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160719';% refait->Run
    Dir{3,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160719-night';
    Dir{3,5}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160720';% refait->Run
    Dir{3,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160720-night';
    
    % ------------ 394 ------------
    Dir{4,1}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160718';%ok
    Dir{4,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160718-night';
    Dir{4,3}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160719';% refait->Run
    Dir{4,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160719-night';
    Dir{4,5}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160720';% refait->Run
    Dir{4,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160720-night';
    
    % ------------ 395 ------------
    Dir{5,1}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160726';% refait->Run
    Dir{5,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160726-night';
    Dir{5,3}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160727';% refait
    Dir{5,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160727-night';
    Dir{5,5}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160728';%ok
    Dir{5,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160728-night';
    
    % ------------ 400 ------------
    Dir{6,1}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160726';%ok
    Dir{6,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160726-night';
    Dir{6,3}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160727';% refait
    Dir{6,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160727-night';
    Dir{6,5}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160728';%ok
    Dir{6,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160728-night';
    
    % ------------ 402 ------------
    Dir{7,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160830';
    Dir{7,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160830-night';
    Dir{7,3}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160831';
    Dir{7,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160831-night';
    Dir{7,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160901';
    Dir{7,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160901-night';
    
    % ------------ 403 ------------
    Dir{8,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160830';
    Dir{8,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160830-night';
    Dir{8,3}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160831';
    Dir{8,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160831-night';
    Dir{8,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160901';
    Dir{8,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160901-night';
    
elseif strcmp(NamePath,'SD24h')
    
    nameSessions{1}='DayBSL';
    nameSessions{2}='nightBSL';
    nameSessions{3}='DayPostSD';
    nameSessions{4}='nightPostSD';
    nameSessions{5}='DaySD+24h';
    nameSessions{6}='nightSD+24h';
    
    % ------------ 294 ------------
    Dir{1,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160906';
    Dir{1,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160906-night';% very short, rest is noise
    Dir{1,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160908';% high noise
    Dir{1,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160908-night';
    Dir{1,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160909';
    Dir{1,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160909-night';
    
    % ------------ 330 ------------
    Dir{2,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906';
    Dir{2,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160906-night';
    Dir{2,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160908';
    Dir{2,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160908-night';
    Dir{2,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160909';
    Dir{2,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160909-night';
    
    % ------------ 394 ------------
    Dir{3,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906';
    Dir{3,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160906-night';
    Dir{3,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908';
    Dir{3,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160908-night';
    Dir{3,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909';
    Dir{3,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160909-night';
    
    % ------------ 395 ------------
    Dir{4,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906';
    Dir{4,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160906-night';
    Dir{4,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160908';
    Dir{4,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160908-night';
    Dir{4,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160909';
    Dir{4,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160909-night';
    
    % ------------ 400 ------------
    Dir{5,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913';
    Dir{5,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160913-night';
    Dir{5,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160915';
    Dir{5,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160915-night';
    Dir{5,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160916';
    Dir{5,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160916-night';
    
    % ------------ 403 ------------
    Dir{6,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913';
    Dir{6,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160913-night';
    Dir{6,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915';
    Dir{6,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160915-night';
    Dir{6,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916';
    Dir{6,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160916-night';
    
    % ------------ 450 ------------
    Dir{7,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913';
    Dir{7,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160913-night';
    Dir{7,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915';
    Dir{7,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160915-night';
    Dir{7,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916';
    Dir{7,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20160916-night';
    
    % ------------ 451 ------------
    Dir{8,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913';
    Dir{8,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160913-night';
    Dir{8,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915';
    Dir{8,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160915-night';
    Dir{8,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916';
    Dir{8,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20160916-night';
    
elseif strcmp(NamePath,'OR')
    
    nameSessions{1}='DayBSL';
    nameSessions{2}='nightBSL';
    nameSessions{3}='DayORhab';
    nameSessions{4}='nightORhab';
    nameSessions{5}='DayORtest';
    nameSessions{6}='nightORtest';
    
    % ------------ 294 (bad learner)------------
    Dir{1,1}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160621'; % missing begining
    Dir{1,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160621-night';
    Dir{1,3}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160622';
    Dir{1,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160622-night';
    Dir{1,5}='/media/DataMOBsRAID/ProjetNREM/Mouse294/20160623';
    Dir{1,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse294/20160623-night';% no data
    
    % ------------ 330 (no neuron)------------
    Dir{2,1}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160621';
    Dir{2,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160621-night';
    Dir{2,3}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160622';
    Dir{2,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160622-night';
    Dir{2,5}='/media/DataMOBsRAID/ProjetNREM/Mouse330/20160623';
    Dir{2,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse330/20160623-night';
    
    % ------------ 393 ------------
    Dir{3,1}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160704';
    Dir{3,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160704-night';
    Dir{3,3}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160705';
    Dir{3,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160705-night';
    Dir{3,5}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160706';
    Dir{3,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse393/20160706-night';
    
    % ------------ 394 ------------
    Dir{4,1}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
    Dir{4,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160704-night';
    Dir{4,3}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160705';
    Dir{4,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160705-night';
    Dir{4,5}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160706';
    Dir{4,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse394/20160706-night';
    
    % ------------ 395 (bad learner)------------
    Dir{5,1}='/media/DataMOBsRAID/ProjetNREM/Mouse395/20160718';
    Dir{5,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160718-night';
    Dir{5,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160719';
    Dir{5,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160719-night';
    Dir{5,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160720';
    Dir{5,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse395/20160720-night';
    
    % ------------ 400 (bad learner)------------
    Dir{6,1}='/media/DataMOBsRAID/ProjetNREM/Mouse400/20160718';
    Dir{6,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160718-night';
    Dir{6,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160719';
    Dir{6,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160719-night';
    Dir{6,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160720';
    Dir{6,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse400/20160720-night';
    
    % ------------ 402 ------------
    Dir{7,1}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160822-PoolDayAndNight';
    Dir{7,2}='NaN';
    Dir{7,3}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160823';
    Dir{7,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160823-night';
    Dir{7,5}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160824';
    Dir{7,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse402/20160824-night';
    
    % ------------ 403 ------------
    Dir{8,1}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160822-PoolDayAndNight';
    Dir{8,2}='NaN';
    Dir{8,3}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160823';
    Dir{8,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160823-night';
    Dir{8,5}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160824';
    Dir{8,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160824-night';
    
    % ------------ 450 ------------
    Dir{9,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010';
    Dir{9,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010-night';
    Dir{9,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161011';
    Dir{9,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161011-night';
    Dir{9,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161012';
    Dir{9,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161012-night';
    
    % ------------ 451 ------------
    Dir{10,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161010';
    Dir{10,2}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161010-night';
    Dir{10,3}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161011';
    Dir{10,4}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161011-night';
    Dir{10,5}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161012';
    Dir{10,6}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161012-night';
    
else
    error('wrong input : choose between ''SD6h'' ''SD24h'' and ''OR'' !')
end