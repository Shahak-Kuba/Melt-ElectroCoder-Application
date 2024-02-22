%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE P05 (PLANAR AUXETIC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cellRight = "G1 X"+((0.3125*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+((1.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+((0.625*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+((1.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+((0.3125*p)/1000)+' Y0 Z0 F'+Speed;
tailRight = "G1 X"+((0.3125*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+((1.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+(((0.3125*p)/1000)+Tail)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(q/1000)+' Z0 F'+Speed+newline+'G1 X-'+Tail+' Y0 Z0 F'+Speed;
cellLeft = "G1 X-"+((0.3125*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+((1.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X-'+((0.625*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+((1.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X-'+((0.3125*p)/1000)+' Y0 Z0 F'+Speed;
tailLeft = "G1 X-"+((0.3125*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+((1.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X-'+(((0.3125*p)/1000)+Tail)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(q/1000)+' Z0 F'+Speed+newline+'G1 X'+Tail+' Y0 Z0 F'+Speed;
cornerRight = "G1 X"+((0.3125*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+((1.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+(((0.3125*p)/1000)+Tail)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(((q/2)/1000)+Tail)+' Z0 F'+Speed+newline+'G1 X-'+(((p/2)/1000)+Tail)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+Tail+' Z0 F'+Speed;
cellUp = "G1 X0 Y"+((1.25*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+((0.375*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+((2.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X-'+((0.375*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+((1.25*q)/1000)+' Z0 F'+Speed;
tailUp = "G1 X0 Y"+((1.25*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+((0.375*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+(((1.25*q)/1000)+Tail)+' Z0 F'+Speed+newline+'G1 X-'+(p/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+Tail+' Z0 F'+Speed;
cellDown = "G1 X0 Y-"+((1.25*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+((0.375*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+((2.5*q)/1000)+' Z0 F'+Speed+newline+'G1 X-'+((0.375*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+((1.25*q)/1000)+' Z0 F'+Speed;
tailDown = "G1 X0 Y-"+((1.25*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+((0.375*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(((1.25*q)/1000)+Tail)+' Z0 F'+Speed+newline+'G1 X-'+(p/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+Tail+' Z0 F'+Speed;
cornerLeft = "G1 X0 Y"+((1.25*q)/1000)+' Z0 F'+Speed+newline+'G1 X'+((0.375*p)/1000)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y'+(((1.25*q)/1000)+Tail)+' Z0 F'+Speed+newline+'G1 X-'+(((p/2)/1000)+Tail)+' Y0 Z0 F'+Speed+newline+'G1 X0 Y-'+(((q/2)/1000)+Tail)+' Z0 F'+Speed+newline+'G1 X'+Tail+' Y0 Z0 F'+Speed;

for n = 1:Layers
    % Horizontal cells right
    for y = 1:ucQ
        for x = 1:ucP
            fprintf(fileID, '%s\n',cellRight);
        end
        fprintf(fileID, '%s\n',tailRight);

        % Horizontal cells left
        for x = 1:ucP
            fprintf(fileID, '%s\n',cellLeft);
        end
        fprintf(fileID, '%s\n',tailLeft);
    end

    for e = 1:ucP
        fprintf(fileID, '%s\n',cellRight);
    end
    fprintf(fileID, '%s\n',cornerRight);

    for y = 1:ucP
        % Vertical layer
        for x = 1:ucQ
            fprintf(fileID, '%s\n',cellUp);
        end
        fprintf(fileID, '%s\n',tailUp);

        for x = 1:ucQ
            fprintf(fileID, '%s\n',cellDown);
        end
        fprintf(fileID, '%s\n',tailDown);
    end

    for e = 1:ucQ
        fprintf(fileID, '%s\n',cellUp);
    end
    fprintf(fileID, '%s\n',cornerLeft);
end