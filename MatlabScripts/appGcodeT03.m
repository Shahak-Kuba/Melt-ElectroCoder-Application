%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE T03 (TUBULAR BRICK - OPEN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rep = Layers*ucQ;
x = p/1000; E = (q/2)/1000;

formatAB = '%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n'; formatC = '%s %s%.4f %s%.4f\n';
componentsA = {'G1', 'X', x, 'E', 0,'G1', 'X', 0, 'E', E,'G1', 'X', x, 'E', 0,'G1', 'X', 0, 'E', E};
componentsB = {'G1', 'X-', x, 'E', 0,'G1', 'X', 0, 'E', E,'G1', 'X-', x, 'E', 0,'G1', 'X', 0, 'E', E};
componentsC = {'G1','X',0,'E',E};

fprintf(fileID, '%s%.4f\n','F',Speed);

%% CORRECTION = OFF
if Correction == "Off"
    cellA = sprintf(formatAB, componentsA{:});
    cellB = sprintf(formatAB, componentsB{:});
    endC = sprintf(formatC, componentsC{:});

    % Repeating loop
    for n = 1:Layers
        fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);
        for i = 1:ucQ
            for y = 1:ucP
                fprintf(fileID, '%s',cellA);
            end
            fprintf(fileID, '%s',endC);

            for z = 1:ucP
                fprintf(fileID, '%s',cellB);
            end
            fprintf(fileID, '%s',endC);
        end
    end

%% CORRECTION = ON -> MODE 1
elseif Correction == "On" && Mode == "First layer only"
    pha1 = pha*(1); pha2 = pha1; amp1 = amp*(1); amp2 = amp1;
    disp('first layer only'); disp(pha1); disp(pha2); disp(amp1); disp(amp2);

    componentsCA = {'G1', 'X', x+pha2, 'E-', amp2,'G1', 'X-', pha2, 'E', E+amp2,'G1', 'X', x+pha2, 'E-', amp2,'G1', 'X-', pha2, 'E', E+amp2};
    componentsCB = {'G1', 'X-', x+pha2, 'E-', amp2,'G1', 'X', pha2, 'E', E+amp2,'G1', 'X-', x+pha2, 'E-', amp2,'G1', 'X', pha2, 'E', E+amp2};

    cellA = sprintf(formatAB, componentsCA{:});
    cellB = sprintf(formatAB, componentsCB{:});
    endC = sprintf(formatC, componentsC{:});

    % Repeating loop
    for n = 1:Layers
        fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);
        for i = 1:ucQ
            for y = 1:ucP
                fprintf(fileID, '%s',cellA);
            end
            fprintf(fileID, '%s',endC);

            for z = 1:ucP
                fprintf(fileID, '%s',cellB);
            end
            fprintf(fileID, '%s',endC);
        end
    end

%% CORRECTION = ON -> MODE 2
elseif Correction == "On" && Mode == "Second layer onwards"

    % Repeating loop
    for n = 1:Layers
        fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);

        pha1 = pha*(n-1); pha2 = pha1*2; amp1 = amp*(n-1); amp2 = amp1*2;
        disp('second layer onwards'); disp(pha1); disp(pha2); disp(amp1); disp(amp2);

        componentsCA = {'G1', 'X', x+pha2, 'E-', amp2,'G1', 'X-', pha2, 'E', E+amp2,'G1', 'X', x+pha2, 'E-', amp2,'G1', 'X-', pha2, 'E', E+amp2};
        componentsCB = {'G1', 'X-', x+pha2, 'E-', amp2,'G1', 'X', pha2, 'E', E+amp2,'G1', 'X-', x+pha2, 'E-', amp2,'G1', 'X', pha2, 'E', E+amp2};


        for i = 1:ucQ
            for y = 1:ucP
                if y == ucP
                    componentsCA{1,18} = 0; componentsC{1,5} = E;
                else
                    componentsCA{1,18} = pha2;
                end
                cellCA = sprintf(formatAB, componentsCA{:}); fprintf(fileID, '%s',cellCA);
            end
            endC = sprintf(formatC, componentsC{:}); fprintf(fileID, '%s',endC);

            for z = 1:ucP
                if z == ucP
                    componentsCB{1,18} = 0;
                else
                    componentsCB{1,18} = pha2;
                end
                if n == 1 && n ~= Layers % MODE 2: offset last leg of first layer
                    if i == ucQ && z == ucP
                        componentsCB{1,20} = E+amp; componentsCB{1,18} = 0; componentsCB{1,15} = amp; componentsCB{1,13} = x+pha;
                        componentsC{1,5} = E+amp;
                    end
                elseif n > 1 && n ~= Layers % MODE 2: every other layer
                    if i == ucQ && z == ucP
                        componentsCB{1,20} = E+amp2+amp; componentsCB{1,18} = 0; componentsCB{1,15} = amp2+amp; componentsCB{1,13} = x+pha2+pha;
                        componentsC{1,5} = E+amp;
                    end
                elseif n == Layers % MODE 2: return on last layer
                    if i == ucQ && z == ucP
                        componentsCB{1,18} = 0;
                        componentsC{1,5} = E+amp2;
                    end
                end
                cellCB = sprintf(formatAB, componentsCB{:}); fprintf(fileID, '%s',cellCB);
            end
            endC = sprintf(formatC, componentsC{:}); fprintf(fileID, '%s',endC);
        end
    end

%% CORRECTION = ON -> MODE 3
elseif Correction == "On" && Mode == "All layers"

    % Repeating loop
    for n = 1:Layers
        fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);

        pha1 = pha*(n); pha2 = pha1*2; amp1 = amp*(n); amp2 = amp1*2;
        disp('all layers'); disp(pha1); disp(pha2); disp(amp1); disp(amp2);

        componentsCA = {'G1', 'X', x+pha2, 'E-', amp2,'G1', 'X-', pha2, 'E', E+amp2,'G1', 'X', x+pha2, 'E-', amp2,'G1', 'X-', pha2, 'E', E+amp2};
        componentsCB = {'G1', 'X-', x+pha2, 'E-', amp2,'G1', 'X', pha2, 'E', E+amp2,'G1', 'X-', x+pha2, 'E-', amp2,'G1', 'X', pha2, 'E', E+amp2};
        componentsC1 = {'G1','X',pha2,'E',E};
        componentsC2 = {'G1','X-',pha2,'E',E};

        cellA = sprintf(formatAB, componentsCA{:});
        cellB = sprintf(formatAB, componentsCB{:});
        endC1 = sprintf(formatC, componentsC1{:});
        endC2 = sprintf(formatC, componentsC2{:});

        for i = 1:ucQ
            for y = 1:ucP
                fprintf(fileID, '%s',cellA);
            end
            endC1 = sprintf(formatC, componentsC1{:}); fprintf(fileID, '%s',endC1);

            for z = 1:ucP
                fprintf(fileID, '%s',cellB);
            end
            if n == 1 && i == ucQ && z == ucP
                componentsC2{1,3} = pha2+pha1; componentsC2{1,5} = E+amp1;
            elseif (n > 1 && n ~= Layers) && i == ucQ && z == ucP
                componentsC2{1,3} = pha2+(pha1/2); componentsC2{1,5} = E+(amp1/2);
            end
            endC2 = sprintf(formatC, componentsC2{:}); fprintf(fileID, '%s',endC2);
        end
    end
end