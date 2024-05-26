function File = func_FileSetup(startCommands,endCommands,Mode,Category,Geometry,Diameter,Layers,Tail,Speed,amp,pha,Correction,Resolution, ...
                Length,Width,p,q,K,P,A,B,ucP,ucQ,pathDirectory)

%% IMPORT NICELY
Length = table2array(Length); Width = table2array(Width);
p = table2array(p); q = table2array(q);
K = table2array(K); P = table2array(P);
A = table2array(A); B = table2array(B);
ucP = table2array(ucP); ucQ = table2array(ucQ);

% Convert from um to mm
pha = pha/1000; amp = amp/1000;

if isnan(A)
    A = "NaN";
else
    A = num2str(A);
end
if isnan(B)
    B = "NaN";
else
    B = num2str(B);
end

    %% File (for tubes, 'File' is needed to use the tubular viewer)
    if Correction == "On"
        nameFormat = '%s_%s%.2f%s%.2f%s%.2f%s%.2f%s%.0f%s%.0f%s%.3f%s%.3f.txt';
        if strcmp(Category, 'Planar')
            File = sprintf(nameFormat,upper(Geometry),'p-',p/1000,'mm_q-',q/1000,'mm_length-',Length,'mm_width-',Width,'mm_layers-',Layers,'_Speed-F',Speed,'_phase-',pha,'_amp-',amp);
        else
            File = sprintf(nameFormat,upper(Geometry),'p-',p/1000,'mm_q-',q/1000,'mm_length-',Length,'mm_diameter-',Diameter,'mm_layers-',Layers,'_Speed-F',Speed,'_phase-',pha,'_amp-',amp);
        end
    elseif Correction == "Off"
        nameFormat = '%s_%s%.2f%s%.2f%s%.2f%s%.2f%s%.0f%s%.0f.txt';
        if strcmp(Category, 'Planar')
            File = sprintf(nameFormat,upper(Geometry),'p-',p/1000,'mm_q-',q/1000,'mm_length-',Length,'mm_width-',Width,'mm_layers-',Layers,'_Speed-F',Speed);
        else
            File = sprintf(nameFormat,upper(Geometry),'p-',p/1000,'mm_q-',q/1000,'mm_length-',Length,'mm_diameter-',Diameter,'mm_layers-',Layers,'_Speed-F',Speed);
        end
    end

    % Remove the ".txt" extension for foldername
    [~, folder, ~] = fileparts(File);
    
    if Mode == "Select"
        Mode = "None";
    end
    
    %% File header  
    pathDirectory = pwd;
    gcodeFolderPath = fullfile(pathDirectory, 'UserExports', folder); 
    mkdir(gcodeFolderPath);
    fileID = fopen(fullfile(gcodeFolderPath,File),'w'); 
    
    fprintf(fileID, '; ===========================================\n');
    if Category == "Planar"
        fprintf(fileID, "; PLANAR "+upper(Geometry)+' GCODE\n');
        fprintf(fileID, "; Scaffold dimensions -> Length: "+Length+' mm, Width: '+Width+' mm\n');
        fprintf(fileID, "; Pore length (p) & width (q) -> p: "+p+' um, q: '+q+' um\n');
        fprintf(fileID, "; Pore area (K) & perimeter (P) -> K: "+K+' mm2, P: '+P+' mm\n');
        fprintf(fileID, "; Pore major (A) & minor (B) angles -> A: "+A+' deg, B: '+B+' deg\n');
        fprintf(fileID, "; Correction mode: "+Mode+"\n");
        fprintf(fileID, "; Correction factors -> amplitude: "+amp+" mm, phase: "+pha+' mm\n');
        fprintf(fileID, "; Layers: "+Layers+'\n');
    
    elseif Category == "Tubular"
        fprintf(fileID, "; TUBULAR "+upper(Geometry)+' GCODE GENERATOR\n');
        fprintf(fileID, "; Scaffold dimensions -> Length: "+Length+' mm, Mandrel Diameter: '+Diameter+' mm\n');
        fprintf(fileID, "; Pore length (p) & width (q) -> p: "+p+' um, q: '+q+' um\n');
        fprintf(fileID, "; Pore area (K) & perimeter (P) -> K: "+K+' mm2, P: '+P+' mm\n');
        fprintf(fileID, "; Pore major (A) & minor (B) angles -> A: "+A+' deg, B: '+B+' deg\n');
        fprintf(fileID, "; Correction mode: "+Mode+"\n");
        fprintf(fileID, "; Correction factors -> amplitude: "+amp+" mm, phase: "+pha+' mm\n');
        fprintf(fileID, "; Total pore area: "+K+' mm2\n');
        fprintf(fileID, "; Layers: "+Layers+'\n');
    end
    
    fprintf(fileID, '; Brenna L. Devlin :)\n');
    fprintf(fileID, '; ===========================================\n\n');
    fprintf(fileID, "G91\n\n");
    
    %% User specified start commands
    fprintf(fileID, startCommands +"\n\n");

    % RESOLUTION
    if Category == "Tubular"
        if Resolution == 0
            circum = pi*Diameter;
            eRes = round((2.5*200*32)/(circum),2); % QUT TARDIS (gear ratio*motor steps*microsteps)/(circumference of mandrel)
            fprintf(fileID, "M92 E"+eRes+'\n'+"M500\n\n");
        else
            fprintf(fileID, "M92 E"+Resolution+'\n'+"M500\n\n");
        end
    end

    %% Assign correct gcode
    switch Geometry
        case "P01"
            appGcodeP01
        case "P02"
            appGcodeP02     
        case "P03"
            appGcodeP03     
        case "P04"
            appGcodeP04     
        case "P05"
            appGcodeP05
        case "P06"
            appGcodeP06     
        case "T01"
            appGcodeT01
        case "T02"
            appGcodeT02     
        case "T03"
            appGcodeT03     
        case "T04"
            appGcodeT04     
        case "T05"
            appGcodeT05     
        case "T06"
            appGcodeT06     
        case "T07"
            appGcodeT07     
    end

    %% User specified end commands
    fprintf(fileID, "\n\n"+endCommands);
    fclose(fileID);  
end