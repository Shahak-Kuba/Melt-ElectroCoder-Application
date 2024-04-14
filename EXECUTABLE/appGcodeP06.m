%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE P06 (PLANAR HEARTBEAT)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = p/1000; q = q/1000;

for n = 1:Layers

    if Correction == "Off"
        phase = 0; amp1 = 0; amp2 = 0;
    elseif Correction == "On" && Mode == "First layer only"
        phase = pha*(1); amp1 = amp*(1); amp2 = amp1*2;
    elseif Correction == "On" && Mode == "Second layer onwards"
        phase = pha*(n-1); amp1 = amp*(n-1); amp2 = amp1*2;
    elseif Correction == "On" && Mode == "All layers"
        phase = pha*(n); amp1 = amp*(n); amp2 = amp1*2;
    end

    % starts/ends
    rightStart = "G1 X"+((p/4)+phase)+' Y-'+((q/4)+amp1)+' Z0 F'+Speed+newline+'G1 X'+(p/4)+' Y'+((0.625*q)+amp2)+' Z0 F'+Speed;
    leftStart = "G1 X-"+((p/4)+phase)+' Y-'+((q/4)+amp1)+' Z0 F'+Speed+newline+'G1 X-'+(p/4)+' Y'+((0.625*q)+amp2)+' Z0 F'+Speed;
    % lines
    cellRight = "G1 X"+(p/4)+' Y-'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X'+(p/4)+' Y'+((q/4)+amp2)+' Z0 F'+Speed+newline+"G1 X"+(p/4)+' Y-'+((q/4)+amp2)+' Z0 F'+Speed+newline+'G1 X'+(p/4)+' Y'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X'+(p/4)+' Y-'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X'+(p/4)+' Y'+((q/4)+amp2)+' Z0 F'+Speed+newline+"G1 X"+(p/4)+' Y-'+((q/4)+amp2)+' Z0 F'+Speed+newline+'G1 X'+(p/4)+' Y'+((0.625*q)+amp2)+' Z0 F'+Speed;
    cellLeft = "G1 X-"+(p/4)+' Y-'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X-'+(p/4)+' Y'+((q/4)+amp2)+' Z0 F'+Speed+newline+"G1 X-"+(p/4)+' Y-'+((q/4)+amp2)+' Z0 F'+Speed+newline+'G1 X-'+(p/4)+' Y'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X-'+(p/4)+' Y-'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X-'+(p/4)+' Y'+((q/4)+amp2)+' Z0 F'+Speed+newline+"G1 X-"+(p/4)+' Y-'+((q/4)+amp2)+' Z0 F'+Speed+newline+'G1 X-'+(p/4)+' Y'+((0.625*q)+amp2)+' Z0 F'+Speed;
    lineUp = "G1 X0 Y"+(q*2)+' Z0 F'+Speed; 
    lineDown = "G1 X0 Y-"+(q*2)+' Z0 F'+Speed;
    % tails
    tailRight = "G1 X"+(p/4)+' Y-'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X'+((p/4)-phase)+' Y'+((q/4)+amp1)+' Z0 F'+Speed+newline+"G1 X"+Tail+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(q)+' Z0 F'+Speed+newline+'G1 X-'+Tail+' Y0 Z0 F'+Speed;
    tailLeft = "G1 X-"+(p/4)+' Y-'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X-'+((p/4)-phase)+' Y'+((q/4)+amp1)+' Z0 F'+Speed+newline+"G1 X-"+Tail+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(q)+' Z0 F'+Speed+newline+'G1 X'+Tail+' Y0 Z0 F'+Speed;   
    tailUp = "G1 X0 Y"+(Tail+q)+' Z0 F'+Speed+newline+'G1 X-'+(p)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+Tail+' Z0 F'+Speed; 
    tailDown = "G1 X0 Y-"+(Tail+q)+' Z0 F'+Speed+newline+'G1 X-'+(p)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+Tail+' Z0 F'+Speed; 
    % corners
    cornerRight = "G1 X"+(p/4)+' Y-'+((0.625*q)+amp2)+' Z0 F'+Speed+newline+'G1 X'+((p/4)-phase)+' Y'+((q/4)+amp1)+' Z0 F'+Speed+newline+"G1 X"+Tail+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(Tail+(q/2))+' Z0 F'+Speed+newline+'G1 X-'+(Tail+(p/2))+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+Tail+' Z0 F'+Speed;
    cornerLeft = "G1 X0 Y"+(Tail+q)+' Z0 F'+Speed+newline+'G1 X-'+(Tail+(p/2))+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(Tail+(q/2))+' Z0 F'+Speed+newline+'G1 X'+Tail+' Y0 Z0 F'+Speed; 

    % Horizontal cells right
    fprintf(fileID, '\n%s%.0f\n\n', '; Horizontal Layer: ',n);
    for y = 1:ucQ
        fprintf(fileID, '%s\n',rightStart);
        for x = 1:ucP
            fprintf(fileID, '%s\n',cellRight);
        end
        fprintf(fileID, '%s\n',tailRight);

        % Horizontal cells left            
        fprintf(fileID, '%s\n',leftStart);
        for x = 1:ucP
            fprintf(fileID, '%s\n',cellLeft);
        end
        fprintf(fileID, '%s\n',tailLeft);
    end

    fprintf(fileID, '%s\n',rightStart);
    for e = 1:ucP
        fprintf(fileID, '%s\n',cellRight);
    end
    fprintf(fileID, '%s\n',cornerRight);

    for y = 1:ucP
        % Vertical layer
        fprintf(fileID, '\n%s%.0f\n\n', '; Vertical Layer: ',n);
        for x = 1:ucQ
            fprintf(fileID, '%s\n',lineUp);
        end
        fprintf(fileID, '%s\n',tailUp);

        for x = 1:ucQ
            fprintf(fileID, '%s\n',lineDown);
        end
        fprintf(fileID, '%s\n',tailDown);
    end

    for e = 1:ucQ
        fprintf(fileID, '%s\n',lineUp);
    end
    fprintf(fileID, '%s\n',cornerLeft);  
end