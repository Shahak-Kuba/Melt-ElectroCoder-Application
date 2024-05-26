function [fileContent, AxesHandle] = func_TubeViewer(Generated_File)

    pathDirectory = pwd;
    filename = convertCharsToStrings(Generated_File);
    filefolder = convertCharsToStrings(Generated_File(1:end-4));
    fileID = fopen(fullfile(pathDirectory,'\UserExports\',filefolder,filename),'r');
    if fileID == -1
        error('Unable to open the file.');
    end
    fileContent = textscan(fileID, '%s', 'Delimiter', '\n');
    fclose(fileID);
    
    %% Extract diameter, speed, X & E values
    pattern_diameter = 'diameter-([0-9.]+)mm';
    diameter_match = regexp(filename, pattern_diameter, 'tokens');  
    if ~isempty(diameter_match)
        diameter = str2double(diameter_match{1}{1});
        fprintf('Diameter: %.2f\n', diameter);
    else
        fprintf('Diameter value not found in filename.\n');
    end
    disp('Mandrel diameter:'); disp(diameter);

    pattern_speed = 'F([\d.]+)';
    speed_match = regexp(strjoin(fileContent{1}, ' '), pattern_speed, 'tokens');
    if ~isempty(speed_match)
        speed = str2double(speed_match{1}{1});
    else
        fprintf('Speed not found.\n');
    end

    expressionX = 'G1 X([+-]?\d*\.?\d+)';
    expressionE = 'E([+-]?\d*\.?\d+)';
    xValues = [];
    eValues = [];
    for i = 1:numel(fileContent{1})
        cline = fileContent{1}{i};
        matchX = regexp(cline, expressionX, 'tokens');
        matchE = regexp(cline, expressionE, 'tokens');
        if ~isempty(matchX)
            xValue = str2double(matchX{1}{1});
            xValues = [xValues, xValue];
        end
        if ~isempty(matchE)
            eValue = str2double(matchE{1}{1});
            eValues = [eValues, eValue];
        end
    end
    eValues(1) = []; % skip over E rotation setting
    
    %% Filter and convert
    x = [0 cumsum(xValues)]';
    e = [0 cumsum(eValues)]';
    a = 360*e/(diameter*pi);

    %% Converting the polar coordinates to cartesian
    XView = [];
    AView = [];
    for i = 2:length(x)
        XView = [XView, linspace(x(i-1), x(i), 100)]; % change the last value to change how well the line matches a cylinder
        AView = [AView, linspace(a(i-1), a(i), 100)]; % the last value must match tho!!
    end    
    RView = (diameter/2)*ones(1, length(XView));
    AView = AView*pi/180;
    [XView(end), AView(end)];
    [xV, yV, zV] = pol2cart(AView, RView, XView);  
    xV = xV(1, :); yV = yV(1, :); zV = zV(1, :);
    
    %% Horizontal view
    figure(Visible="off"); hold on; axis equal; axis off; %grid on;
    plot(xV, zV,'Color','k','LineWidth',2);
    xlabel('X (mm)'); ylabel('Z (mm)'); title('XZ Visualisation');
    set(gca, 'color', 'white');
    savefig(gcf, fullfile(pathDirectory, 'UserExports', filefolder, 'front.fig'));
    hold off
    
    %% 3D view with mandrel
    figure(Visible="off"); hold on; axis equal; axis on; grid on; grid minor;
    
    % Plot cylinder
    [Xm,Ym,Zm] = cylinder(diameter/2);
    h = max(zV)*2; Zm = ceil(Zm*h);
    Zm = Zm(:,:)-(((h-max(zV)))/2);
    surf(Xm,Ym,Zm,'FaceColor',[.9 .9 .9],'EdgeColor','none')

    % Plot print
    plot3(xV, yV, zV, 'LineWidth', 2, 'Color','k');
    xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)'); title('3D Visualisation');
    view(45, 30); set(gca, 'color', 'white');
    AxesHandle = gca;
    savefig(gcf, fullfile(pathDirectory, 'UserExports', filefolder, 'im3D.fig'));
    hold off
end