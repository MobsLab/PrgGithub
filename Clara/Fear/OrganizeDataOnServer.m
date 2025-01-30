% OrganizeDataOnServer
% Clara 04.12.2015
res=pwd;
%res='G:\Manip-2258-259-297-298-299-HAB+TEST\Manip-2258-259-297-298-299-HAB+TEST';
%res='G:\Plethysmo\Data matlab\HAB\HAB';
%res='G:\Plethysmo\Data matlab\EXT\EXT';
%res='G:\FEAR_DATA\FEAR_ManipBulbectomieNov15\EXPLO+2wk';
%res='G:\FEAR_DATA\FEAR_ManipBulbectomieNov15\EXPLO+3wk';

% miceNb=[269:290];
% for k=1:length(miceNb)
%     mice{k}=num2str(mice(k));
%     mkdir([res '/M' mice{k} '/20151123']); 
%     cd ([res '/M' mice{k} ]); 
%     list=dir;
%     for i=1:length(list)
%         if list(i).name(1)~='.' & list(i).name(1:4)=='FEAR'
%             movefile([res '/M' mice{k} '/' list(i).name ],[res '/M' mice{k} '/20151123'])
%         end
%     end
% end

% miceNb=[269:290];
% for k=1:length(miceNb)
%     mice{k}=num2str(miceNb(k));
%     mkdir([res '/M' mice{k} '/20151203']); 
% end

%res1='\\NASDELUXE2\DataMOBsRAID\ProjetAversion\ManipNov15Bulbectomie';
%res1='/media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie';
%res1='\\NASDELUXE2\DataMOBsRAID\ProjetAversion\ManipDec15BulbectomiePlethysmo';
res1='\\NASDELUXE2\DataMOBsRAID\ProjetAversion\PAIN\manip258-259-291-297-298-299\PAIN';
list=dir;
    for i=1:length(list)
        if list(i).name(1)~='.' & list(i).name(1:4)=='FEAR'
            copyfile([res '/'  list(i).name],[res1 '/M' list(i).name(12:14)  '/20151216/FEAR-Mouse-'  list(i).name(12:14)  '-16122015-01-PAIN'])
            %copyfile([res '/'  list(i).name],[res1 '/M' list(i).name(12:14)  '/20151221/FEAR-Mouse-'  list(i).name(12:14)  '-21122015-01-EXPLO+3wk'])
            %copyfile([res '/'  list(i).name],[res1 '/M' list(i).name(12:14)  '/20151217/FEAR-Mouse-'  list(i).name(12:14)  '-15122017-01-EXT']) 
            %copyfile([res '/'  list(i).name],[res1 '/M' list(i).name(6:8)  '/20151210/FEAR-Mouse-'  list(i).name(6:8)  '-10122015-01-EXPLO+2wk']) 
            %copyfile([res '/'  list(i).name],[res1 '/M' list(i).name(12:14)  '/20151210/FEAR-Mouse-'  list(i).name(12:14)  '-10122015-01-EXPLO+2wk']) 

            %copyfile('/media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/FEAR-269-03122015-01-EXPLOpenF','/media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/M269/20151203/FEAR-269-03122015-01-EXPLO+6d') 
            
        end
    end
    
%     
%     list=dir;
%     for i=1:length(list)
%         if list(i).name(1)~='.' & list(i).name(1)=='M'
%             cd(list(i).name)
%             res2=pwd;
%             list2=dir;
%             for k=1:length(list2)
%                 if list2(k).name(1)~='.' & list2(k).name(end-6:end-4)=='plo'
%                     movefile([res2 '/' list2(k).name ],[res '/Hyperactivity/' list2(k).name])
%                 end
%             end
%             cd ..
%             copyfile([res '/'  list(i).name],[res '/M' list(i).name(6:8)  '/20151203/FEAR-Mouse-'  list(i).name(6:8)  '-03122015-01-EXPLO+6d']) 
%             copyfile('/media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/FEAR-269-03122015-01-EXPLOpenF','/media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/M269/20151203/FEAR-269-03122015-01-EXPLO+6d') 
%             
%             movefile([res '/' list(i).name ],[res '/M' list(i).name(6:8) '/20151123'])
%         end
%     end