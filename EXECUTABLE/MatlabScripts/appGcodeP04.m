%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE P04 (PLANAR CHEVRON)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

q=q*2; p=p*2;

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

    cellStartR = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',(((p/4)/1000)+phase),'Y-',(((q/2)/1000)+amp1),'Z0 F',Speed);
    cellStartL = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X-',(((p/4)/1000)+phase),'Y-',(((q/2)/1000)+amp1),'Z0 F',Speed);   

    cellRight = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',((p/4)/1000),'Y',(((q/2)/1000)+amp2),'Z0 F',Speed,'G1','X',((p/4)/1000),'Y-',(((q/2)/1000)+amp2),'Z0 F',Speed,'G1','X',((p/4)/1000),'Y',(((q/2)/1000)+amp2),'Z0 F',Speed,'G1','X',((p/4)/1000),'Y-',(((q/2)/1000)+amp2),'Z0 F',Speed);
    cellLeft = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X-',((p/4)/1000),'Y',(((q/2)/1000)+amp2),'Z0 F',Speed,'G1','X-',((p/4)/1000),'Y-',(((q/2)/1000)+amp2),'Z0 F',Speed,'G1','X-',((p/4)/1000),'Y',(((q/2)/1000)+amp2),'Z0 F',Speed,'G1','X-',((p/4)/1000),'Y-',(((q/2)/1000)+amp2),'Z0 F',Speed);
    lineUp = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'Y',((ucQ*q)/1000),'Z0 F',Speed);
    lineDown = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'Y-',((ucQ*q)/1000),'Z0 F',Speed);

    cornerRight = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',Tail,'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',(((q/2)/1000)+Tail),'Z0 F',Speed,'G1','X-',(((p/4)/1000)+Tail),'Y',0,'Z0 F',Speed,'G1','X',0,'Y',Tail,'Z0 F',Speed);
    cornerLeft = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',0,'Y',(((q/2)/1000)+Tail),'Z0 F',Speed,'G1','X-',(((p/4)/1000)+Tail),'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',Tail,'Z0 F',Speed,'G1','X',Tail,'Y',0,'Z0 F',Speed);

    tailRight = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',Tail,'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',((q/2)/1000),'Z0 F',Speed,'G1','X-',Tail,'Y',0,'Z0 F',Speed);
    tailUp = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',0,'Y',(((q/2)/1000)+Tail),'Z0 F',Speed,'G1','X-',((p/2)/1000),'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',Tail,'Z0 F',Speed);
    tailDown = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X',0,'Y-',(((q/2)/1000)+Tail),'Z0 F',Speed,'G1','X-',((p/2)/1000),'Y',0,'Z0 F',Speed,'G1','X',0,'Y',Tail,'Z0 F',Speed);
    tailLeft = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
        'G1','X-',Tail,'Y',0,'Z0 F',Speed,'G1','X',0,'Y-',((q/2)/1000),'Z0 F',Speed,'G1','X',Tail,'Y',0,'Z0 F',Speed);

    cellEndR = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',(((p/4)/1000)-phase),'Y',(((q/2)/1000)+amp1),'Z0 F',Speed); 

    if (((p/4)/1000)-phase) < 0
        cellEndL = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',abs(((p/4)/1000)-phase),'Y',(((q/2)/1000)+amp1),'Z0 F',Speed);
    else
        cellEndL = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X-',(((p/4)/1000)-phase),'Y',(((q/2)/1000)+amp1),'Z0 F',Speed);
    end

    % Horizontal cells right
    fprintf(fileID, '\n%s%.0f\n\n', '; Horizontal Layer: ',n);
    for y = 1:ucQ
        fprintf(fileID, '%s',cellStartR);
        for x = 1:ucP
            fprintf(fileID, '%s',cellRight);
        end
        fprintf(fileID, '%s',cellEndR);
        fprintf(fileID, '%s',tailRight);

        % Horizontal cells left
        fprintf(fileID, '%s\n',cellStartL);
        for x = 1:ucP
            fprintf(fileID, '%s',cellLeft);
        end
        fprintf(fileID, '%s',cellEndL);
        fprintf(fileID, '%s',tailLeft);
    end

    fprintf(fileID, '%s',cellStartR);
    for e = 1:ucP
        fprintf(fileID, '%s',cellRight);
    end
    fprintf(fileID, '%s',cellEndR);
    fprintf(fileID, '%s',cornerRight);

    % Vertical layer
    fprintf(fileID, '\n%s%.0f\n\n', '; Vertical Layer: ',n);
    for x = 1:ucP
        fprintf(fileID, '%s%s%s%s', lineUp,tailUp,lineDown,tailDown);
    end
    fprintf(fileID, '%s%s', lineUp,cornerLeft);
end