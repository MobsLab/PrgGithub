function MakeMovieFromTracking(Ffile,fps)


tic

try
    fps;
catch
    fps=20;
end

lim=Inf;

res=pwd;

if isempty(strfind(res,'/')),mark='\'; else  mark='/';end



  eval(['cd(''',[res,mark,Ffile],''')'])
    list=dir;
    eval(['cd(''',res,''')'])
    %aviobj = avifile(['tempoutput.avi'],'fps', fps);
    aviobj = avifile([Ffile,'.avi'],'fps', fps);

try
    i=3;k=1;
    while (strcmp(list(i).name(1:5),'frame')&k<lim)
    eval(['temp=load(''',[res,mark,Ffile,mark,list(i).name],''');'])
    aviobj = addframe(aviobj,temp.datas.image);
    i=i+1;
    k=k+1;
    end
end
aviobj = close(aviobj);
     close
    disp('************ Movie done ************')
    
    
    
    
    if 0
    
if 0
    eval(['cd(''',[res,mark,Ffile],''')'])
    figure('color',[1 1 1]), numgcf=gcf;
%     set(gcf,'position',[20   444   484   324])
    list=dir;
    i=3;k=1;
    while (strcmp(list(i).name(1:5),'frame')&k<lim)
    temp=load([Ffile,mark,list(i).name]);
    figure(numgcf),imshow(temp.datas.image)
    mov(k) = getframe(numgcf);
    i=i+1;
    k=k+1;
    end

    close
    eval(['cd(''',res,''')'])
    disp('************ Making movie ************')
    movie2avi(mov,[Ffile,'.avi'],'fps',fps);
    disp('************ Movie done ************')

else

    eval(['cd(''',[res,mark,Ffile],''')'])
    list=dir;
    eval(['cd(''',res,''')'])
    %aviobj = avifile(['tempoutput.avi'],'fps', fps);
    aviobj = avifile([Ffile,'.avi'],'fps', fps);

    figure('color',[1 1 1]), numgcf=gcf;
%     set(gcf,'position',[20   444   484   324])    
    i=3;k=1;
    while (strcmp(list(i).name(1:5),'frame')&k<lim)
    eval(['temp=load(''',[res,mark,Ffile,mark,list(i).name],''');'])
    figure(numgcf),imshow(temp.datas.image)
    aviobj = addframe(aviobj,getframe(numgcf));
    i=i+1;
    k=k+1;
    end
    aviobj = close(aviobj);
     close
    disp('************ Movie done ************')

    
end

end


% 
% 
% %%% compress the video (or at least try)
% disp('please wait, compressing avi file....');
% command = sprintf('mencoder tempoutput.avi -ovc lavc -o %s','output.avi');
% [STATUSVAR,STATUSMESSAGE] = unix(command);
% delete('tempoutput.avi'); % remove temp file
%     
% if STATUSVAR ~= 0
%    error( STATUSMESSAGE );
% else
%    disp('compression completed');
% end
% %%%%%%%%


toc

