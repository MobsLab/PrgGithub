% Copyright:Hamid R. Maei
        clear all;
        display('Start reading:')

        N_animal=input('Enter the number of animals: ');
        t_end=589;
        display('Now enter the data one by one by clicking on *.wmdf files');
       
        filename=input('Name your file: ', 's');
        [p_xy]=read_data_wmdf(N_animal,t_end);
        [p_xy,N]=trimedfile(p_xy,t_end);
        save(filename,'p_xy');


