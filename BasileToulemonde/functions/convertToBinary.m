function binaryPos = convertToBinary(X,Y)
     
    Xd = Data(X);
    Yd = Data(Y);

    % Initialize the binary coordinates cell array
    binary_coords = zeros(length(Xd), 1);

    % Iterate through each coordinate pair
    for i = 1:length(Xd)
        x = Xd(i);
        y = Yd(i);
        
        if x < 0.4 && y < 0.4
            binary_coords(i) = 10;
        elseif x > 0.6 && y < 0.4
            binary_coords(i) = 01;
        elseif (x < 0.3 || x > 0.7) && y > 0.8
            binary_coords(i) = 11;
        else
            binary_coords(i) = 00;
        end
    end
    
    binaryPos = tsd(Range(X), binary_coords);
end