function [fileContent, AxesHandle, Time] = func_FlatViewer(pathDirectory, Generated_File, Speed)

    filename = convertCharsToStrings(Generated_File);
    filefolder = convertCharsToStrings(Generated_File(1:end-4));
    fileID = fopen(fullfile(pathDirectory,'\UserExports\',filefolder,filename),'r');
    if fileID == -1
        error('Unable to open the file.');
    end
    fileContent = textscan(fileID, '%s', 'Delimiter', '\n');
    fclose(fileID);
    
    %% Extract length, speed, width, X & E values
    length_pattern = 'length-?(\d+(\.\d+)?)mm';
    width_pattern = 'width-?(\d+(\.\d+)?)mm';
    length_match = regexp(filename, length_pattern, 'tokens');
    width_match = regexp(filename, width_pattern, 'tokens');
    
    if ~isempty(width_match)
        width_value = str2double(width_match{1}{1});
        fprintf('Extracted width value: %.2fmm\n', width_value);
    else
        fprintf('Width value not found.\n');
    end
    if ~isempty(length_match)
        length_value = str2double(length_match{1}{1});
        fprintf('Extracted length value: %.2fmm\n', length_value);
    else
        fprintf('Length value not found.\n');
    end

    pattern_speed = 'F([\d.]+)';
    speed_match = regexp(strjoin(fileContent{1}, ' '), pattern_speed, 'tokens');
    if ~isempty(speed_match)
        speed = str2double(speed_match{1}{1});
    else
        fprintf('Speed not found.\n');
    end

%% Extract values
xValues = [];
yValues = [];
expressionX = 'G1 X([+-]?\d*\.?\d+)';
expressionY = 'Y([+-]?\d*\.?\d+)';

for i = 1:numel(fileContent{1})
    cline = fileContent{1}{i};
    matchX = regexp(cline, expressionX, 'tokens');
    matchY = regexp(cline, expressionY, 'tokens');
    if ~isempty(matchX)
        xValue = str2double(matchX{1}{1});
        xValues = [xValues, xValue];
    end
    if ~isempty(matchY)
        yValue = str2double(matchY{1}{1});
        yValues = [yValues, yValue];
    end
end

% % Estimate print time
%     distArray = [];
%     timeArray = cat(1,xValues,yValues)'; timeArray = abs(timeArray);
%     for n = 1:length(timeArray)
%         dist = sqrt(timeArray(n,1)^2 + timeArray(n,2)^2);
%         distArray = [distArray, dist];
%     end
%     timeInMinutes = sum(distArray)/speed;
%     days = floor(timeInMinutes / (24 * 60));
%     hours = floor((timeInMinutes - days * 24 * 60) / 60);
%     minutes = floor(rem(timeInMinutes, 60));
%     seconds = floor(rem(timeInMinutes * 60, 60));
%     Time = sprintf('%02d:%02d:%02d:%02d', days, hours, minutes, seconds);
Time = "go fix";

    %% Filter and convert
    x = [0 cumsum(xValues)]';
    y = [0 cumsum(yValues)]';
    
    %% Plots
    figure(Visible="off"); hold on; axis equal; grid on; grid minor; axis off
    plot(x, y,'Color',[0.4940 0.1840 0.5560],'LineWidth',2); %set(gca, 'YDir', 'reverse');
    xlabel('X (mm)'); ylabel('Y (mm)'); title('Flat Gcode XY Visualisation');
    set(gca, 'color', 'white'); 
    AxesHandle = gca;
    savefig(gcf, fullfile(pathDirectory, 'UserExports', filefolder, 'top.fig'));
    hold off
end