function Col = UMazeColors(Type)

% Part of maze
cols=redblue(7);
cols=cols([7,1,3,5,2],:);
cols(3,:)=[0.9,0.7,1];

switch lower(Type)
    case 'safe'
        Col = [0.6 0.6 1];

    case 'shock'
        Col = [1 0.6 0.6];
        
    case 'centershock'
        Col = [1 0.8 0.8];
        
    case 'centersafe'
        Col = [0.8 0.8 1];
        
    case 'center'
        Col = cols(3,:);
        
    case 'flxchr'
        Col = [0.2 0.2 0.2];

    case 'flx'
        Col = [0.4 0.4 0.4];

    case 'mdz'
        Col = [0.6 0.6 0.6];
        
    case 'sal'
        Col = [0.8 0.8 0.8];

end



end