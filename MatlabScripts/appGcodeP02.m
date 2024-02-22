%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE P02 (PLANAR SINGLE WAVE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

    cellStartR = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',(((p*2.5)/1000)+phase),'Y',(((0.375*q)/1000)+amp1),'Z0 F',Speed);
    cellStartL = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X-',(((p*2.5)/1000)+phase),'Y',(((0.375*q)/1000)+amp1),'Z0 F',Speed);
    cellStartU = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X-',(((p*1.5)/1000)+amp1),'Y',(((0.625*q)/1000)+phase),'Z0 F',Speed);
    cellStartD = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X-',(((p*1.5)/1000)+amp1),'Y-',(((0.625*q)/1000)+phase),'Z0 F',Speed);

    cellRight = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X',((p*2.5)/1000),'Y-',(((0.375*q)/1000)+amp2),'Z0 F',Speed,'G1','X',((p*2.5)/1000),'Y',(((0.375*q)/1000)+amp2),'Z0 F',Speed);
    cellLeft = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X-',((p*2.5)/1000),'Y-',(((0.375*q)/1000)+amp2),'Z0 F',Speed,'G1','X-',((p*2.5)/1000),'Y',(((0.375*q)/1000)+amp2),'Z0 F',Speed);
    cellUp = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X',(((p*1.5)/1000)+amp2),'Y',((0.625*q)/1000),'Z0 F',Speed,'G1','X-',(((p*1.5)/1000)+amp2),'Y',((0.625*q)/1000),'Z0 F',Speed);
    cellDown = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X',(((p*1.5)/1000)+amp2),'Y-',((0.625*q)/1000),'Z0 F',Speed,'G1','X-',(((p*1.5)/1000)+amp2),'Y-',((0.625*q)/1000),'Z0 F',Speed);

    cornerRight = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',((p*2.5)/1000),'Y-',(((0.375*q)/1000)+amp2),'Z0 F',Speed,'G1','X',(((p*2.5)/1000)-phase),'Y',(((0.375*q)/1000)+amp1),'Z0 F',Speed,'G1','X',Tail,'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',(((0.5*q)/1000)+Tail),'Z0 F',Speed,'G1','X-',(((0.5*p)/1000)+Tail),'Y',0,'Z0 F',Speed,'G1','X',0,'Y',Tail,'Z0 F',Speed);
    cornerLeft = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',(((p*1.5)/1000)+amp2),'Y',((0.625*q)/1000),'Z0 F',Speed,'G1','X-',(((p*1.5)/1000)+amp1),'Y',(((0.625*q)/1000)-phase),'Z0 F',Speed,'G1','X',0,'Y',Tail,'Z0 F',Speed,'G1','X-',(((0.5*p)/1000)+Tail),'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',(((0.5*q)/1000)+Tail),'Z0 F',Speed,'G1','X',Tail,'Y',0,'Z0 F',Speed);

    tailRight = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',((p*2.5)/1000),'Y-',(((0.375*q)/1000)+amp2),'Z0 F',Speed,'G1','X',(((p*2.5)/1000)-phase),'Y',(((0.375*q)/1000)+amp1),'Z0 F',Speed,'G1','X',Tail,'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',(q/1000),'Z0 F',Speed,'G1','X-',Tail,'Y',0,'Z0 F',Speed);
    tailUp = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',(((p*1.5)/1000)+amp2),'Y',((0.625*q)/1000),'Z0 F',Speed,'G1','X-',(((p*1.5)/1000)+amp1),'Y',(((0.625*q)/1000)-phase),'Z0 F',Speed,'G1','X',0,'Y',Tail,'Z0 F',Speed,'G1','X-',(p/1000),'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',Tail,'Z0 F',Speed);

    if (((p*2.5)/1000)-phase) < 0
        tailLeft = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
            'G1','X-',((p*2.5)/1000),'Y-',(((0.375*q)/1000)+amp2),'Z0 F',Speed,'G1','X',abs(((p*2.5)/1000)-phase),'Y',(((0.375*q)/1000)+amp1),'Z0 F',Speed,'G1','X-',Tail,'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',(q/1000),'Z0 F',Speed,'G1','X',Tail,'Y',0,'Z0 F',Speed);
    else
        tailLeft = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
            'G1','X-',((p*2.5)/1000),'Y-',(((0.375*q)/1000)+amp2),'Z0 F',Speed,'G1','X-',(((p*2.5)/1000)-phase),'Y',(((0.375*q)/1000)+amp1),'Z0 F',Speed,'G1','X-',Tail,'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',(q/1000),'Z0 F',Speed,'G1','X',Tail,'Y',0,'Z0 F',Speed);
    end

    if (((0.625*q)/1000)-phase) < 0
        tailDown = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
            'G1','X',(((p*1.5)/1000)+amp2),'Y-',((0.625*q)/1000),'Z0 F',Speed,'G1','X-',(((p*1.5)/1000)+amp1),'Y',abs(((0.625*q)/1000)-phase),'Z0 F',Speed,'G1','X',0,'Y-',Tail,'Z0 F',Speed,'G1','X-',(p/1000),'Y',0,'Z0 F',Speed,'G1','X',0,'Y',Tail,'Z0 F',Speed);
    else
        tailDown = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
            'G1','X',(((p*1.5)/1000)+amp2),'Y-',((0.625*q)/1000),'Z0 F',Speed,'G1','X-',(((p*1.5)/1000)+amp1),'Y-',(((0.625*q)/1000)-phase),'Z0 F',Speed,'G1','X',0,'Y-',Tail,'Z0 F',Speed,'G1','X-',(p/1000),'Y',0,'Z0 F',Speed,'G1','X',0,'Y',Tail,'Z0 F',Speed);
    end

    % Horizontal cells right
    fprintf(fileID, '\n%s%.0f\n\n', '; Horizontal Layer: ',n);
    for y = 1:ucQ
        fprintf(fileID, '%s',cellStartR);
        for x = 1:ucP-1
            fprintf(fileID, '%s',cellRight);
        end
        fprintf(fileID, '%s',tailRight);

        % Horizontal cells left
        fprintf(fileID, '%s',cellStartL);
        for x = 1:ucP-1
            fprintf(fileID, '%s',cellLeft);
        end
        fprintf(fileID, '%s',tailLeft);
    end

    fprintf(fileID, '%s',cellStartR);
    for e = 1:ucP-1
        fprintf(fileID, '%s',cellRight);
    end
    fprintf(fileID, '%s',cornerRight);

    for y = 1:ucP
        % Vertical layer
        fprintf(fileID, '\n%s%.0f\n\n', '; Vertical Layer: ',n);
        fprintf(fileID, '%s',cellStartU);
        for x = 1:ucQ-1
            fprintf(fileID, '%s',cellUp);
        end
        fprintf(fileID, '%s',tailUp);

        fprintf(fileID, '%s',cellStartD);
        for x = 1:ucQ-1
            fprintf(fileID, '%s',cellDown);
        end
        fprintf(fileID, '%s',tailDown);
    end

    fprintf(fileID, '%s',cellStartU);
    for e = 1:ucQ-1
        fprintf(fileID, '%s',cellUp);
    end
    fprintf(fileID, '%s',cornerLeft);
end