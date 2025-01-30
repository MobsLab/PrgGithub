function Create_ArtificialRefAvi_fromFrames(dirName,FramesFolder,nom_AviOut,plo)

% Create_ArtificialRefAvi_fromFrames(dirName,framesFolder,nom_AviOut,plo)

%% load file
lis=dir([dirName,'/',FramesFolder]);

%% get frequency
i_start=3;
while isempty(strfind(lis(i_start).name,'frame'))
    i_start=i_start+1;
end
load([dirName,'/',FramesFolder,'/',lis(i_start).name]);
t_start=datas.time(6)+60*datas.time(5)+360*datas.time(4);

i_stop=length(lis);
while isempty(strfind(lis(i_stop).name,'frame'))
    i_stop=i_stop-1;
end
load([dirName,'/',FramesFolder,'/',lis(i_stop).name]);
t_stop=datas.time(6)+60*datas.time(5)+360*datas.time(4);

freq=(i_stop-i_start)/(t_stop-t_start);
freq=22;

%% create avifile
try
    aviobj=avifile([dirName,'/',nom_AviOut],'fps',freq,'compression','None','quality',50);
    
     if plo, figure, namefig=gcf;end 
    for i=50:length(lis)-100
        
        clear datas Frame_temp
        load([FramesFolder,'/',lis(i).name]);
        
        if exist('datas','var')
            Frame_temp=datas.image;
            
            if plo
                figure(namefig), 
                hold off, imagesc(Frame_temp)
            end
            mov=getframe;
            aviobj = addframe(aviobj,mov);

        end
    end
    
    aviobj=close(aviobj);
    disp(['        ->  ',nom_AviOut,'.avi has been created.'])
    keyboard
catch
    keyboard
    disp(['        Problem creating ',nom_AviOut,'.avi !!'])
end