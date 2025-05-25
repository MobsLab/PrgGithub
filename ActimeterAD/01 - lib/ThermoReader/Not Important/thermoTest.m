% Test the temperature reading

% Init the serial communication
s = serial('COM21');
set(s,'BaudRate', 9600);

fopen(s);

while s.BytesAvailable <= 0
end

if s.BytesAvailable > 0
    out = fscanf(s, '%f', 4);
    disp(out);
end

fclose(s)
delete(s)