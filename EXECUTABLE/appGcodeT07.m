%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE T07 (TUBULAR WAVE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = Speed;            % translation speed in X

x2 = (p/2)/1000; x4 = (p/4)/1000; e2 = (q/2)/1000; e4 = (q/4)/1000;
formatAB = '%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n';
formatEnd = '%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n';

componentsA = {'G1','X',x2,'E',0,'F',f,'G1','X',0,'E',e2,'F',f,'G1','X',x2,'E',0,'F',f,'G1','X',0,'E',e2,'F',f};
componentsB = {'G1','X',0,'E',e2,'F',f,'G1','X-',x2,'E',0,'F',f,'G1','X',0,'E',e2,'F',f,'G1','X-',x2,'E',0,'F',f};
componentsC = {'G1','X',x2,'E',0,'F',f,'G1','X',0,'E',e2,'F',f,'G1','X',x2,'E',0,'F',f,'G1','X',0,'E',e4,'F',f,'G1','X-',x4,'E',0,'F',f};
componentsD = {'G1','X',0,'E',e2,'F',f,'G1','X-',x2,'E',0,'F',f,'G1','X',0,'E',e2,'F',f,'G1','X-',x4,'E',0,'F',f,'G1','X',0,'E',e4,'F',f};

%% CORRECTION = OFF
if Correction == "Off"
    cellA = sprintf(formatAB, componentsA{:}); cellB = sprintf(formatAB, componentsB{:});
    end1 = sprintf(formatEnd, componentsC{:}); end2 = sprintf(formatEnd, componentsD{:});

    for n = 1:Layers
        fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);
        for i = 1:ucQ
            for y = 1:ucP-1
                fprintf(fileID, '%s',cellA);
            end
            fprintf(fileID, '%s',end1);
            for z = 1:ucP-1
                fprintf(fileID, '%s',cellB);
            end
            fprintf(fileID, '%s',end2);
        end
    end

    %% CORRECTION = ON -> MODE 1
elseif Correction == "On" && Mode == "First layer only"
    pha1 = pha*(1); pha2 = pha1; amp1 = amp*(1); amp2 = amp1;
    componentsA = {'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f,'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f};
    componentsB = {'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f,'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f};
    componentsC = {'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f,'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X',0,'E',e4+amp2,'F',f,'G1','X-',x4+pha2,'E-',amp2,'F',f};
    componentsD = {'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f,'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x4+pha2,'E-',amp2,'F',f,'G1','X',0,'E',e4+amp2,'F',f};
    cellA = sprintf(formatAB, componentsA{:}); cellB = sprintf(formatAB, componentsB{:});
    end1 = sprintf(formatEnd, componentsC{:}); end2 = sprintf(formatEnd, componentsD{:});

    for n = 1:Layers
        fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);
        for i = 1:ucQ
            for y = 1:ucP-1
                fprintf(fileID, '%s',cellA);
            end
            fprintf(fileID, '%s',end1);
            for z = 1:ucP-1
                fprintf(fileID, '%s',cellB);
            end
            fprintf(fileID, '%s',end2);
        end
    end

    %% CORRECTION = ON -> MODE 2
elseif Correction == "On" && Mode == "Second layer onwards"
    for n = 1:Layers
        pha1 = pha*(n-1); pha2 = pha1*2; amp1 = amp*(n-1); amp2 = amp1*2;

        componentsA = {'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f,'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f};
        componentsB = {'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f,'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f};
        componentsC = {'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f,'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X',0,'E',e4+amp2,'F',f,'G1','X-',x4+pha2,'E-',amp2,'F',f};
        componentsD = {'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f,'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x4+pha2,'E-',amp2,'F',f,'G1','X',0,'E',e4+amp2,'F',f};
        cellA = sprintf(formatAB, componentsA{:}); cellB = sprintf(formatAB, componentsB{:});
        end1 = sprintf(formatEnd, componentsC{:}); end2 = sprintf(formatEnd, componentsD{:});

        fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);
        for i = 1:ucQ
            for y = 1:ucP-1
                fprintf(fileID, '%s',cellA);
            end
            fprintf(fileID, '%s',end1);
            for z = 1:ucP-1
                fprintf(fileID, '%s',cellB);
                if n == 1 && n ~= Layers    % offset last leg of first layer
                    if i == ucQ && z == ucP-1
                        componentsD{1,3} = pha; componentsD{1,30} = 'X-'; componentsD{1,31} = pha+pha; componentsD{1,33} = e4+amp;
                    end
                elseif n > 1 && n ~= Layers % other layers
                    if i == ucQ && z == ucP-1
                        componentsD{1,3} = pha2+pha; componentsD{1,30} = 'X-'; componentsD{1,31} = (n*pha); componentsD{1,33} = e4+amp2+amp;
                    end
                elseif n == Layers  % return to origin last leg of last layer
                    if i == ucQ && z == ucP-1
                        componentsD{1,3} = pha2+pha; componentsD{1,31} = 0;
                    end
                else
                end
            end
            end2 = sprintf(formatEnd, componentsD{:}); fprintf(fileID, '%s',end2);
        end
    end

    %% CORRECTION = ON -> MODE 3
elseif Correction == "On" && Mode == "All layers"
    for n = 1:Layers
        fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);

        pha1 = pha*(n); pha2 = pha1*2; amp1 = amp*(n); amp2 = amp1*2;
        componentsA = {'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f,'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f};
        componentsB = {'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f,'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f};
        componentsC = {'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X-',pha2,'E',e2+amp2,'F',f,'G1','X',x2+pha2,'E-',amp2,'F',f,'G1','X',0,'E',e4+amp2,'F',f,'G1','X-',x4+pha2,'E-',amp2,'F',f};
        componentsD = {'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x2+pha2,'E-',amp2,'F',f,'G1','X',pha2,'E',e2+amp2,'F',f,'G1','X-',x4+pha2,'E-',amp2,'F',f,'G1','X',0,'E',e4+amp2,'F',f};
        cellA = sprintf(formatAB, componentsA{:}); cellB = sprintf(formatAB, componentsB{:});
        end1 = sprintf(formatEnd, componentsC{:}); end2 = sprintf(formatEnd, componentsD{:});

        for i = 1:ucQ
            for y = 1:ucP-1
                fprintf(fileID, '%s',cellA);
            end
            fprintf(fileID, '%s',end1);
            for z = 1:ucP-1
                fprintf(fileID, '%s',cellB);
                if n == 1 && n ~= Layers    % offset last leg of first layer
                    if i == ucQ && z == ucP-1
                        componentsD{1,3} = pha; componentsD{1,30} = 'X-'; componentsD{1,31} = 0; componentsD{1,33} = e4+amp2+amp;
                    end
                elseif n > 1 && n ~= Layers % other layers
                    if i == ucQ && z == ucP-1
                        componentsD{1,3} = pha2-pha; componentsD{1,30} = 'X-'; componentsD{1,31} = 0; componentsD{1,33} = e4+amp2+amp;
                    end
                elseif n == Layers  % return to origin last leg of last layer
                    if i == ucQ && z == ucP-1
                        componentsD{1,3} = pha2-pha; componentsD{1,31} = 0;
                    end
                else
                end
            end
            end2 = sprintf(formatEnd, componentsD{:}); fprintf(fileID, '%s',end2);
        end
    end
end