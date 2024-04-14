%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE T02 (TUBULAR BOW TIE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = str2double(A); B = str2double(B);

fxe = Speed*sin(deg2rad(A/2)); % x speed
fe = Speed*cos(deg2rad(A/2)); % e speed

E = (q/1000)+((2*((p/1000)/2))/tan(deg2rad(A/2)));
E1 = ((p/2)/1000)*tan(deg2rad(180-90-(A/2)));
X1 = (p/2)/1000;

for n = 1:Layers

    switch Correction
        case "Off"
            fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);

            cell1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X',0,'E-',E,'F',fe,'G1','X',X1,'E',E1,'F',fxe,'G1','X',0,'E-',E,'F',fe,'G1','X-',X1,'E',E1,'F',fxe);
            end1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X',0,'E-',E,'F',fe,'G1','X',X1,'E',E1,'F',fxe,'G1','X',0,'E-',E,'F',fe,'G1','X',X1,'E',E1,'F',fxe);
            cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X',0,'E-',E,'F',fe,'G1','X-',X1,'E',E1,'F',fxe,'G1','X',0,'E-',E,'F',fe,'G1','X',X1,'E',E1,'F',fxe);
            end2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X',0,'E-',E,'F',fe,'G1','X-',X1,'E',E1,'F',fxe,'G1','X',0,'E-',E,'F',fe,'G1','X',X1,'E',E1,'F',fxe);
            cellend = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X-',X1,'E-',E1,'F',fe,'G1','X-',X1,'E',E1,'F',fe);

            for j = 1:ucP
                for y = 1:ucQ-1
                    fprintf(fileID, '%s',cell1);
                end
                fprintf(fileID, '%s',end1);

                for z = 1:ucQ-1
                    fprintf(fileID, '%s',cell2);
                end
                fprintf(fileID, '%s',end2);
            end
            for i = 1:ucP
                fprintf(fileID, '%s',cellend);
            end

        case "On"
            fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);

            if Mode == "First layer only"
                pha1 = pha*(1); pha2 = pha1*2; amp1 = amp*(1); amp2 = amp1*2;
                disp('first layer only'); disp(pha1); disp(pha2); disp(amp1); disp(amp2);
            elseif Mode == "Second layer onwards"
                pha1 = pha*(n-1); pha2 = pha1*2; amp1 = amp*(n-1); amp2 = amp1*2;
                disp('second layer onwards'); disp(pha1); disp(pha2); disp(amp1); disp(amp2);
            elseif Mode == "All layers"
                pha1 = pha*(n); pha2 = pha1*2; amp1 = amp*(n); amp2 = amp1*2;
                disp('all layers'); disp(pha1); disp(pha2); disp(amp1); disp(amp2);
            end

            cell1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X-',0,'E-',E+amp2,'F',fe,'G1','X',X1+pha2,'E',E1+amp2,'F',fxe,'G1','X',0,'E-',E+amp2,'F',fe,'G1','X-',X1+pha2,'E',E1+amp2,'F',fxe);
            end1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X',0,'E-',E+amp2,'F',fe,'G1','X',X1+pha2,'E',E1+amp2,'F',fxe,'G1','X-',0,'E-',E+amp2,'F',fe,'G1','X',X1,'E',E1+amp2,'F',fxe);
            cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X',0,'E-',E+amp2,'F',fe,'G1','X-',X1+pha2,'E',E1+amp2,'F',fxe,'G1','X',0,'E-',E+amp2,'F',fe,'G1','X',X1+pha2,'E',E1+amp2,'F',fxe);
            end2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X',0,'E-',E+amp2,'F',fe,'G1','X-',X1+pha2,'E',E1+amp2,'F',fxe,'G1','X-',0,'E-',E+amp2,'F',fe,'G1','X',X1,'E',E1+amp2,'F',fxe);
            cellend = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X-',X1,'E-',E1,'F',fe,'G1','X-',X1,'E',E1,'F',fe);

            for j = 1:ucP
                %% CELL 1 & END 1
                for y = 1:ucQ-1
                    fprintf(fileID, '%s',cell1);
                end
                fprintf(fileID, '%s',end1);

                %% CELL 2 & END 2
                for z = 1:ucQ-1
                    fprintf(fileID, '%s',cell2);
                end

                if j == ucP && z == ucQ-1
                    end2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                        'G1','X',0,'E-',E+amp2,'F',fe, ...
                        'G1','X-',X1+pha2,'E',E1+amp2,'F',fxe, ...
                        'G1','X-',0,'E-',E+amp2,'F',fe, ...
                        'G1','X',X1+pha2,'E',E1+amp2,'F',fxe);
                end
                fprintf(fileID, '%s',end2);
            end

            %% CELL END
            for i = 1:ucP
                if n == 1 && n ~= Layers % offset last leg of first layer
                    if i == ucP
                        cellend = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X-',X1,'E-',E1,'F',fe, ...
                            'G1','X-',X1+pha,'E',E1+amp,'F',fe);
                    end

                elseif n > 1 && n ~= Layers % offset every sequential layer
                    if i == 1
                        cellend = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X-',X1+pha2,'E-',E1+amp2,'F',fe, ...
                            'G1','X-',X1,'E',E1+amp2,'F',fe);
                    elseif i == ucP
                        cellend = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X-',X1,'E-',E1+amp2,'F',fe, ...
                            'G1','X-',X1+pha,'E',E1+amp2+amp,'F',fe);
                    end

                elseif n == Layers % return to origin last leg of last layer
                    if i == 1
                        cellend = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X-',X1+pha2,'E-',E1+amp2,'F',fe, ...
                            'G1','X-',X1,'E',E1+amp2,'F',fe);
                    elseif i == ucP
                        cellend = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X-',X1,'E-',E1+amp2,'F',fe, ...
                            'G1','X-',X1,'E',E1+amp2,'F',fe);
                    end
                else
                end
                fprintf(fileID, '%s',cellend);
            end
    end
end