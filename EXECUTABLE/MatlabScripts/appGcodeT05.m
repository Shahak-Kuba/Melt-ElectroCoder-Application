%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE T05 (TUBULAR CHEVRON OPEN)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = str2double(A); B = str2double(B);
f0 = Speed; f = Speed*cos(deg2rad(180-90-(A/2)));

x = p/1000; E = (q/2)/1000;

formatAB = '%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n'; formatCD = '%s %s%.4f %s%.4f %s%.4f\n';
componentsA = {'G1','X',x,'E',0,'F',f0,'G1','X',x,'E',E,'F',f,'G1','X',x,'E',0,'F',f0,'G1','X-',x,'E',E,'F',f};
componentsB = {'G1','X-',x,'E',0,'F',f0,'G1','X-',x,'E',E,'F',f,'G1','X-',x,'E',0,'F',f0,'G1','X',x,'E',E,'F',f};
componentsC = {'G1','X',x,'E',E,'F',f};
componentsD = {'G1','X-',x,'E',E,'F',f};

%% CORRECTION == OFF
if Correction == "Off"
    cellA = sprintf(formatAB, componentsA{:});
    cellB = sprintf(formatAB, componentsB{:});
    endC = sprintf(formatCD, componentsC{:});
    endD = sprintf(formatCD, componentsD{:});

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
            fprintf(fileID, '%s',endD);
        end
    end

    %% CORRECTION == ON -> MODE 1
elseif Correction == "On" && Mode == "First layer only"
    pha1 = pha*(1); pha2 = pha1; amp1 = amp*(1); amp2 = amp1;

    componentsA = {'G1','X',x+pha2,'E-',amp2,'F',f0,'G1','X',x,'E',E+amp2,'F',f,'G1','X',x,'E-',amp2,'F',f0,'G1','X-',x+pha2,'E',E+amp2,'F',f};
    componentsB = {'G1','X-',x+pha2,'E-',amp2,'F',f0,'G1','X-',x-pha2,'E',E+amp2,'F',f,'G1','X-',x+pha2,'E-',amp2,'F',f0,'G1','X',x+pha2,'E',E+amp2,'F',f};
    componentsC = {'G1','X',x+pha2,'E',E+amp2,'F',f};
    componentsD = {'G1','X-',x+pha2,'E',E+amp2,'F',f};
    cellA = sprintf(formatAB, componentsA{:});
    cellB = sprintf(formatAB, componentsB{:});
    endC = sprintf(formatCD, componentsC{:});
    endD = sprintf(formatCD, componentsD{:});

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
            fprintf(fileID, '%s',endD);
        end
    end

    %% CORRECTION == ON -> MODE 2
elseif Correction == "On" && Mode == "Second layer onwards"

    for n = 1:Layers
        pha1 = pha*(n-1); pha2 = pha1*2; amp1 = amp*(n-1); amp2 = amp1*2;

        componentsB = {'G1','X-',x+pha2,'E-',amp2,'F',f0,'G1','X-',x-pha2,'E',E+amp2,'F',f,'G1','X-',x+pha2,'E-',amp2,'F',f0,'G1','X',x+pha2,'E',E+amp2,'F',f};
        componentsC = {'G1','X',x+pha2,'E',E+amp2,'F',f};
        componentsD = {'G1','X-',x+pha2,'E',E+0,'F',f};
        cellB = sprintf(formatAB, componentsB{:});
        endC = sprintf(formatCD, componentsC{:});
        endD = sprintf(formatCD, componentsD{:});

        for i = 1:ucQ
            for y = 1:ucP
                componentsA = {'G1','X',x+pha2,'E-',amp2,'F',f0,'G1','X',x-pha2,'E',E+amp2,'F',f,'G1','X',x+pha2,'E-',amp2,'F',f0,'G1','X-',x+pha2,'E',E+amp2,'F',f};
                if y == ucP
                    componentsA = {'G1','X',x+pha2,'E-',amp2,'F',f0,'G1','X',x-pha2,'E',E+amp2,'F',f,'G1','X',x+pha2,'E-',amp2,'F',f0,'G1','X-',x+pha2,'E',E+0,'F',f};
                end
                cellA = sprintf(formatAB, componentsA{:}); fprintf(fileID, '%s',cellA);
            end
            fprintf(fileID, '%s',endC);
            for z = 1:ucP
                fprintf(fileID, '%s',cellB);
            end
            if n == 1 && n ~= Layers
                if i == ucQ && z == ucP
                    componentsD{1,3} = x+pha; componentsD{1,5} = E+amp;
                end
            elseif n > 1 && n ~= Layers
                if i == ucQ && z == ucP
                    componentsD{1,3} = x+pha2+pha; componentsD{1,5} = E+amp;
                end
            else
            end
            endD = sprintf(formatCD, componentsD{:}); fprintf(fileID, '%s',endD);
        end
    end

    %% CORRECTION == ON -> MODE 3
elseif Correction == "On" && Mode == "All layers"
end