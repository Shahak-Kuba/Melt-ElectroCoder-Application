%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE T04 (TUBULAR BRICK - CLOSED)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f = Speed;

x = p/1000; E = q/1000;

%% BY CELL

for n = 1:Layers
    switch Correction
        case "Off"
            fprintf(fileID, '\n%s%.0f\n\n', '; Layer: ',n);

            cell1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E,'F',f,'G1','X',x,'E',0,'F',f);
            end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E,'F',f);
            cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E,'F',f,'G1','X-',x,'E',0,'F',f);

            for i = 1:ucP+1 %+1
                %% CELL 1 END 0
                for y = 1:ucP*2
                    fprintf(fileID, '%s',cell1);
                end
                fprintf(fileID, '%s',end0);

                %% CELL 2 END 0
                for z = 1:ucP*2
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

            for i = 1:ucP+1
                %% CELL 1 END 0
                for y = 1:ucP*2
                    if y == 1
                        cell1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X',0,'E-',E+amp1,'F',f,'G1','X',x+pha2,'E',amp2,'F',f);
                    else
                        cell1 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X-',pha2,'E-',E+amp2,'F',f,'G1','X',x+pha2,'E',amp2,'F',f);
                    end
                    fprintf(fileID, '%s',cell1);
                end
                end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E+amp2,'F',f);
                fprintf(fileID, '%s',end0);

                %% CELL 2 END 0
                for z = 1:ucP*2
                    if z == 1
                        cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X',0,'E-',E+0,'F',f,'G1','X-',x+pha2,'E',amp2,'F',f);
                        end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E+amp2,'F',f);
                    else
                        cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                            'G1','X',pha2,'E-',E+amp2,'F',f,'G1','X-',x+pha2,'E',amp2,'F',f);
                        end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E+amp1,'F',f);
                    end

                    if n == 1 && n ~= Layers
                        if i == ucP+1 && z == ucP*2
                            cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                                'G1','X',0,'E-',E,'F',f,'G1','X-',x+pha,'E',amp,'F',f);
                            end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E+amp,'F',f);
                        end

                    elseif n > 1 && n ~= Layers
                        if i == ucP+1 && z == ucP*2
                            cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                                'G1','X',pha2,'E-',E+amp2,'F',f,'G1','X-',x+pha2+pha,'E',amp2,'F',f);
                            end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E+amp,'F',f);
                        end

                    elseif n == Layers
                        if i == ucP+1 && z == ucP*2
                            cell2 = sprintf('%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n', ...
                                'G1','X',pha2,'E-',E+amp2,'F',f,'G1','X-',x+pha2,'E',amp2,'F',f);
                            end0 = sprintf('%s %s%.4f %s%.4f %s%.4f\n','G1','X',0,'E-',E+amp2,'F',f);
                        end
                    end
                    fprintf(fileID, '%s',cell2);
                end
                fprintf(fileID, '%s',end0);
            end
    end
end