%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GCODE T01 (TUBULAR DIAMOND)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

A = str2double(A); B = str2double(B);
f = Speed*cos(deg2rad(A/2));    % translation speed in X
rep = Layers*ucQ;               % number of repeated zigzag gcode lines 
x = Length; E = Length*tan(deg2rad(A/2));

fprintf(fileID, '%s%.4f\n','F',f);

format2 = '%s %s%.4f %s%.4f\n%s %s%.4f %s%.4f\n';
pair = sprintf(format2,'G1','X',Length,'E',E,'G1','X-',Length,'E',E);

%format1 = '%s %s%.4f %s%.4f %s%.4f\n%s %s%.4f %s%.4f %s%.4f\n'; 
%pair = sprintf(format1,'G1','X',Length,'E',E,'F',f,'G1','X-',Length,'E',E,'F',f);

for n = 1:rep
    fprintf(fileID, '%s',pair);
end