clear

cd('G:\FEAR_DATA\FEAR_ManipTest_Nov2015\Data_Matlab\FEAR_COND_DATA');
res=pwd;
list=dir;
%path? G:\FEAR_DATA\FEAR_ManipBulbectomie\EXT24-envC



for i=1:length(dir)
    if list(i).name(1)~='.'
        %create new folder
        if ~isdir([res '\' list(i).name '_copy'])
            mkdir([res '\' list(i).name '_copy'])
        end


        %copy files to new foler, except frames
        old_dir=cd([res '/' list(i).name]);
        res2=pwd;
        list2 = dir;
        for j=1:length(list2)
            if list(j).name(1)~='.'
            file2copy=[res2 '\' list2(j).name];
            destination=[res '\' list(i).name '_copy'];

            if list2(j).name(end-4:end) ~= '-0001' %except frames
                copyfile([file2copy],[destination]);
            end
            end
        end
    end
   % cd(old_dir)
end
