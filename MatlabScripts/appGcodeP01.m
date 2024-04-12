%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE P01 (PLANAR CROSSHATCH)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(fileID, '%s%.4f\n','F',Speed);

formatLine = '%s %s%.4f %s%.4f\n'; formatTail = '%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n'; formatCorner = '%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n'; 

lineRight = sprintf(formatLine,'G1','X',((ucP*(p*2))/1000),'Y',0);
lineLeft = sprintf(formatLine,'G1','X-',((ucP*(p*2))/1000),'Y',0);
lineUp = sprintf(formatLine,'G1','X',0,'Y',((ucQ*(q*2))/1000));
lineDown = sprintf(formatLine,'G1','X',0,'Y-',((ucQ*(q*2))/1000));
tailRight = sprintf(formatTail,'G1','X',(((p/2)/1000)+Tail),'Y',0,'G1','X',0,'Y-',(q/1000),'G1','X-',(((p/2)/1000)+Tail),'Y',0);
tailLeft = sprintf(formatTail,'G1','X-',(((p/2)/1000)+Tail),'Y',0,'G1','X',0,'Y-',(q/1000),'G1','X',(((p/2)/1000)+Tail),'Y',0);
tailUp = sprintf(formatTail,'G1','X',0,'Y',(((q/2)/1000)+Tail),'G1','X-',(p/1000),'Y',0,'G1','X',0,'Y-',(((q/2)/1000)+Tail));
tailDown = sprintf(formatTail,'G1','X',0,'Y-',(((q/2)/1000)+Tail),'G1','X-',(p/1000),'Y',0,'G1','X',0,'Y',(((q/2)/1000)+Tail));
cornerRight = sprintf(formatCorner,'G1','X',(((p/2)/1000)+Tail),'Y',0,'G1','X',0,'Y-',(((q/2)/1000)+Tail),'G1','X-',(((p/2)/1000)+Tail),'Y',0,'G1','X',0,'Y',(((q/2)/1000)+Tail));
cornerLeft = sprintf(formatCorner,'G1','X',0,'Y',(((q/2)/1000)+Tail),'G1','X-',(((p/2)/1000)+Tail),'Y',0,'G1','X',0,'Y-',(((q/2)/1000)+Tail),'G1','X',(((p/2)/1000)+Tail),'Y',0);

for n = 1:Layers
    fprintf(fileID, '\n%s%.0f\n\n', '; Horizontal Layer: ',n);
    for x = 1:ucQ
        fprintf(fileID, '%s%s%s%s',lineRight,tailRight,lineLeft,tailLeft);
    end
    fprintf(fileID, '%s%s', lineRight,cornerRight);
    fprintf(fileID, '\n%s%.0f\n\n', '; Vertical Layer: ',n);
    for x = 1:ucP
        fprintf(fileID, '%s%s%s%s', lineUp,tailUp,lineDown,tailDown);
    end
    fprintf(fileID, '%s%s', lineUp,cornerLeft);
end