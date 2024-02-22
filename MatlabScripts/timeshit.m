%% APPROXIMATE PRINT TIME
for i = 1:18
    fgetl(fileID); % Skip header lines
end

% lineNumber = 20; 
% for i = 1:lineNumber - 1
%     fgetl(fileID);
% end
% specificLine = fgetl(fileID);
% speedTest = regexp(specificLine, '[-+]?\d*\.?\d+', 'match');
% speedTest = str2double(speedTest);
% Speedy = speedTest(4); % Keep only the second numeric value
%Speedy = Speed;
numeric_values_array = [];

tline = fgetl(fileID);
while ischar(tline)
    % Extract all numeric values using regular expression
    numeric_values = regexp(tline, '[-+]?\d*\.?\d+', 'match');
    numeric_values = str2double(numeric_values);
    numeric_values_array = [numeric_values_array, numeric_values];
    tline = fgetl(fileID);
end
fclose(fileID);

% % FOR TUBULAR SCAFFOLDS (sum x & y abs distance values / speed for approximate print time)
% totaldist = sum(abs(numeric_values_array(:)));
% total_minutes = totaldist/Speedy;
% 
% % Calculate days, hours, minutes, and seconds
% days = floor(total_minutes / (24 * 60));
% remaining_minutes = total_minutes - days * 24 * 60;
% 
% hours = floor(remaining_minutes / 60);
% remaining_minutes = remaining_minutes - hours * 60;
% 
% minutes = floor(remaining_minutes);
% seconds = round((remaining_minutes - minutes) * 60);

% Format the result as a string
%Time = string(sprintf('%d days, %02d:%02d:%02d', days, hours, minutes, seconds));
Time = "Brenna to fix!";