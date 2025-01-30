function trymorph()
%   Testing morph.
%
%   Copyright 2011 Jonathan Hadida
%   ETS Montreal, Canada
%   Interventional Medical Imaging Laboratory
%
%   Contact: ariel dot hadida [a] google mail

    N = 30; % Morph length in frames
    
    % Load images
    fprintf('Loading images...');
    I1 = imread('1.jpg');
    I2 = imread('2.jpg');
    I3 = imread('3.jpg');
    fprintf(['done!' 10]);
    
    % Morph
    fprintf('First morphing sequence...');
    J1 = mat2gray(morph(I1,I2,N,'linear'));
    fprintf(['done!' 10]);
    
    fprintf('Second morphing sequence...');
    J2 = mat2gray(morph(I2,I3,N,'splinease'));
    fprintf(['done!' 10]);
    
    % Concatenate
    fprintf('Concatenating sequences...');
    J = cat(3,J1,J2);
    fprintf(['done!' 10]);
    
    % Play
    disp(['Playing sequence.' 10]);
    implay(J);

end