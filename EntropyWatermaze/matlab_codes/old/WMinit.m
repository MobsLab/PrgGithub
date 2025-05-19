       %Constants--subject to change
       Rz=10;     %Subject to change:for Zone measure--radius of zone
       loc=1;     %Subject to change: location of platform (1=top-left corner, 2=top-right
                  %corent, 3=botom-left corner, 4=bottom-right of tank)
       sc=60/106; %Subject to change: This depends on the raw data that has been
                  %received from Your watermaze software. In
                  %Actimetric software, after importing data (from
                  %*.wmdf files) we needed this scale to resize the
                  %data to be fittable to the size of the tank with
                  %radius of 60 cm
       Xctr=67;   %Subject to change:this is almost the center of tank in the data
                  %obtained from Actimetric software. Please note
                  %(0,0) point is on the top-left corner.
       Yctr=69;
       
        Del_Xp=26.2; %Subject to change: This is x-postion of the platform wrt center;
                    %26.2 and 21.2 was used in both Frontiers in
                    %Integrative Neuroscience papers
                     %platform from the center of tank obtained by
                     %trial and error; 
        Del_Yp=21.2; 
        %The location of platform (Xp,Yp) are as follows
        if loc==4
          Xp=Xctr+Del_Xp;
          Yp=Yctr+Del_Yp;
        end
        
        if loc==3
          Xp=Xctr-Del_Xp;
          Yp=Yctr+Del_Yp;
          
        end
        
        if loc==2
          Xp=Xctr+Del_Xp;
          Yp=Yctr-Del_Yp;
          
        end
        
        if loc==1
          Xp=Xctr-Del_Xp;
          Yp=Yctr-Del_Yp;
        end