% Test the sound control

% Init the serial communication
s = serial('COM21');
%set(s,'BaudRate', 9600);
fopen(s);

pause(1);

fwrite(s, 0, 'uchar' );
fwrite(s, 1, 'uchar' );
fwrite(s, 192, 'uchar' );

% while s.BytesAvailable <= 0
% end

out = fread(s, 1, 'uchar');
disp(out);
out = fread(s, 1, 'uchar');
disp(out);
out = fread(s, 1, 'uchar');
disp(out);

fclose(s);
delete(s)