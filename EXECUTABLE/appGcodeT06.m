%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE T06 (TUBULAR CHEVRON CLOSED)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = str2double(A); B = str2double(B);

f0 = Speed;
f = Speed*cos(deg2rad(180-90-(A/2)));

rep = Layers*ucP;

x = p/1000; E = (q/2)/1000;

%% BY CELL

for n = 1:Layers

    switch Correction
        case "Off"
            fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);

            end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X',x,'E-',E,'F',f,'G1','X-',x,'E-',E,'F',f);
            cell1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X',x,'E-',E,'F',f,'G1','X-',x,'E-',E,'F',f,'G1','X',x,'E',0,'F',f0);
            cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X',x,'E-',E,'F',f,'G1','X-',x,'E-',E,'F',f,'G1','X-',x,'E',0,'F',f0);

            for j = 1:ucP+1
                for y = 1:ucQ
                    fprintf(fileID, '%s',cell1);
                end
                fprintf(fileID, '%s',end0);
                for z = 1:ucQ
                    fprintf(fileID, '%s',cell2);
                end
                fprintf(fileID, '%s',end0);
            end

        case "On"
            fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);

            if ModeCorr == 0
                pha1 = 0; pha2 = 0; amp1 = 0; amp2 = 0;
            elseif ModeCorr == 1
                pha1 = pha*(1); pha2 = pha1*2; amp1 = amp*(1); amp2 = amp1*2;
            elseif ModeCorr == 2
                pha1 = pha*(n-1); pha2 = pha1*2; amp1 = amp*(n-1); amp2 = amp1*2;
            elseif ModeCorr == 3
                pha1 = pha*(n); pha2 = pha1*2; amp1 = amp*(n); amp2 = amp1*2;
            end
            
            cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                'G1','X',x+pha2,'E-',E,'F',f,'G1','X-',x+pha2,'E-',E,'F',f,'G1','X-',x+0,'E',0,'F',f0);

            for j = 1:ucP+1
                %% CELL 1 END 0
                for y = 1:ucQ
                    end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                        'G1','X',x+pha2,'E-',E,'F',f,'G1','X-',x+pha2,'E-',E,'F',f);
                    cell1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                        'G1','X',x+pha2,'E-',E,'F',f,'G1','X-',x+pha2,'E-',E,'F',f,'G1','X',x+0,'E',0,'F',f0);

                    fprintf(fileID, '%s',cell1);
                end
                fprintf(fileID, '%s',end0);

                %% CELL 2 END 0
                for z = 1:ucQ
                    cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                        'G1','X',x+pha2,'E-',E,'F',f,'G1','X-',x+pha2,'E-',E,'F',f,'G1','X-',x+0,'E',0,'F',f0);
                    end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                        'G1','X',x+pha2,'E-',E,'F',f,'G1','X-',x+pha2,'E-',E,'F',f);

                    if n == 1 && n ~= Layers
                        if j == ucP+1 && z == (ucP*2-1)
                            end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                                'G1','X',x+pha2,'E-',E,'F',f,'G1','X-',x+pha,'E-',E+amp,'F',f);
                        end
                    elseif n > 1 && n ~= Layers
                        if j == ucP+1 && z == (ucP*2-1)
                            end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                                'G1','X',x+pha2,'E-',E,'F',f,'G1','X-',x+pha2+pha,'E-',E+amp,'F',f);
                        end
                    elseif n == Layers
                        if j == ucP+1 && z == (ucP*2-1)
                            end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                                'G1','X',x+pha2,'E-',E,'F',f,'G1','X-',x+pha2,'E-',E,'F',f);
                        end
                    end
                    fprintf(fileID, '%s',cell2);
                end
                fprintf(fileID, '%s',end0);
            end
    end
end