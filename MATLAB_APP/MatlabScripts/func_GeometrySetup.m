function [Information, PreviewKP, PreviewPC, divp, divq, La] = func_GeometrySetup(Category, Geometry, Build, Param1, Param2, Diameter, User_Length, User_Width, pathDirectory)

    %% Geometry Setup
    switch Geometry
        %% P01
        case "P01"
        % SET UP THE KEY POINTS AND LINES
        KpMult = [0 0.5; 0 1.5; 0.5 2; 1.5 2; 2 1.5; 2 0.5; 1.5 0; 0.5 0; 0.5 0.5; 0.5 1.5; 1.5 1.5; 1.5 0.5];
        poreMult = [0.5 0.5 1.5 1.5; 0.5 1.5 1.5 0.5];
        La = [1 9; 9 12; 12 6; 2 10; 10 11; 11 5; 8 9; 9 10; 10 3; 7 12; 12 11; 11 4];

        % DEFINE RATIO OF PORE LENGTH (p) AND HEIGHT (q) TO THE ENTIRE CELL
        divp = 2; divq = 2;

        % CALCULATE PROPERTIES BASED ON User_Build
        % EVERYTHING RUNS ON p & q, SO NO MATTER THE User_Build THESE ARE THE PARAMETERS THAT NEED TO BE CARRIED FORWARD
        switch Build
            case 'p & q'
                p = Param1; q = Param2; 
                K = p*q; P = ((2*p)+(2*q))/1000;
            case 'K & p'
                K = Param1; p = Param2;
                q = (K*1000000)/p; P = ((2*p)+(2*q))/1000;
            case 'P & p'
                P = Param1; p = Param2;
                q = ((P*1000)-(2*p))/2; K = p*q;
        end

        [NoChange,Scaled,Fitted] = planar(User_Length, User_Width, p, q, divp, divq, KpMult, poreMult);

        % DEFINE p, q, K, P, A & B IF NaN IN ALL CASES
        NoChange.A = NaN; Scaled.A = NaN; Fitted.A = NaN; NoChange.B = NaN; Scaled.B = NaN; Fitted.B = NaN;
    
        %% P02
        case "P02"
        KpMult = [0 0.5; 0 0.75; 0.5 1.25; 4.5 1.25; 5 0.75; 5 0.5; 4.5 0; 0.5 0; 2 0.625; 2.5 1.125; 3 0.625; 2.5 0.125; 1.25 0.3125; 1.25 0.9375; 3.75 0.9375; 3.75 0.3125];
        poreMult = [1.25 2 1.25 2.5 3.75 3 3.75 2.5; 0.3125 0.625 0.9375 1.125 0.9375 0.625 0.3125 0.125];
        La = [1 13; 12 13; 12 16; 6 16; 2 14; 10 14; 10 15; 5 15; 8 13; 9 13; 9 14; 3 14; 7 16; 11 16; 11 15; 4 15];
        divp = 5; divq = 1.25;
        switch Build
            case 'p & q'
                p = Param1; q = Param2; 
                Kcalc = (2*(p*(0.3125*q)) + 8*(0.5*(1.25*p)*(0.1875*q)))/1000000;
            case 'K & p'
                K = Param1; p = Param2;
                q = round((((0.5*((K*1000000)))/2.5)/p)/0.3125);
            case 'A & p'
                A = Param1; p = Param2;
                q = round((1.25*p)/(0.1875*tan(deg2rad(A/2))));
        end
        [NoChange,Scaled,Fitted] = planar(User_Length, User_Width, p, q, divp, divq, KpMult, poreMult);
        NoChange.A = 2*(rad2deg(atan((1.25*NoChange.p)/(0.1875*NoChange.q)))); NoChange.B = 2*(rad2deg(atan((0.3125*NoChange.q)/(0.75*NoChange.p))));
        Fitted.A = 2*(rad2deg(atan((1.25*Fitted.p)/(0.1875*Fitted.q)))); Fitted.B = 2*(rad2deg(atan((0.3125*Fitted.q)/(0.75*Fitted.p))));
        Scaled.A = 2*(rad2deg(atan((1.25*Scaled.p)/(0.1875*Scaled.q)))); Scaled.B = 2*(rad2deg(atan((0.3125*Scaled.q)/(0.75*Scaled.p))));

        %% P03
        case "P03"
        KpMult = [0 1; 0 3; 1 4; 3 4; 4 3; 4 1; 3 0; 1 0; 1 1; 1 3; 3 3; 3 1; 0.5 0.5; 1.5 1.5; 0.5 2.5; 1.5 3.5; 2.5 0.5; 3.5 1.5; 2.5 2.5; 3.5 3.5; 0.5 1.5; 1.5 0.5; 2.5 1.5; 3.5 0.5; 0.5 3.5; 1.5 2.5; 2.5 3.5; 3.5 2.5];
        poreMult = [1 1.5 0.5 1 1.5 2.5 3 2.5 3.5 3 2.5 1.5; 1 1.5 2.5 3 2.5 3.5 3 2.5 1.5 1 1.5 0.5];
        La = [1 21; 21 9; 9 22; 22 23; 23 12; 12 24; 24 6; 2 25; 25 10; 10 26; 26 27; 27 11; 11 28; 28 5; 8 13; 13 9; 9 14; 14 15; 15 10; 10 16; 16 3; 7 17; 17 12; 12 18; 18 19; 19 11; 11 20; 20 4];
        divp = 4; divq = 4;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                Kc = ((p*q) + 4*((p*q)/2) + 4*((p*(q/2))/2))/1000000;
            case 'K & p'
                K = Param1; p = Param2;
                q = (K*1000000)/(4*p);              
            case 'A & p'
                A = Param1; p = Param2;
                q = p/(tan(deg2rad(A/2)));
        end
        [NoChange,Scaled,Fitted] = planar(User_Length, User_Width, p, q, divp, divq, KpMult, poreMult);
        NoChange.A = 2*rad2deg(atan((NoChange.p/2)/(NoChange.q/2))); NoChange.B = 2*rad2deg(atan((NoChange.q/2)/(NoChange.p/2)));
        Fitted.A = 2*rad2deg(atan((Fitted.p/2)/(Fitted.q/2))); Fitted.B = 2*rad2deg(atan((Fitted.q/2)/(Fitted.p/2)));
        Scaled.A = 2*rad2deg(atan((Scaled.p/2)/(Scaled.q/2))); Scaled.B = 2*rad2deg(atan((Scaled.q/2)/(Scaled.p/2)));

        %% P04
        case "P04"
        KpMult = [0 1; 0 2; 0.5 2; 1 2; 1.5 2; 2 2; 2 1; 1.5 0; 0.5 0; 0.5 1; 1 1; 1.5 1];
        poreMult = [0.5 0.5 1 1.5 1.5 1; 0 1 2 1 0 1];
        La = [1 9; 9 11; 11 8; 8 7; 2 10; 10 4; 4 12; 12 6; 9 10; 10 3; 8 12; 12 5];
        divp = 2; divq = 2;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                K = (4*((p/2)*q)/2)/1000000;
            case 'K & p'
                K = Param1; p = Param2;
                q = (K*1000000)/p;
            case 'A & p'
                A = Param1; p = Param2;
                q = (p/2)/tan(deg2rad(A/2));
        end
        [NoChange,Scaled,Fitted] = planar(User_Length, User_Width, p, q, divp, divq, KpMult, poreMult);
        NoChange.A = 2*rad2deg(atan((NoChange.p/2)/NoChange.q)); NoChange.B=NaN;
        Scaled.A = 2*rad2deg(atan((Scaled.p/2)/Scaled.q)); Scaled.B=NaN;
        Fitted.A = 2*rad2deg(atan((Fitted.p/2)/Fitted.q)); Fitted.B=NaN;

        %% P05
        case "P05"
        KpMult = [0 0.5; 0 4.5; 0.5 5; 0.75 5; 1.25 4.5; 1.25 0.5; 0.75 0; 0.5 0; 0.3125 1.25; 0.3125 3.75; 0.9375 3.75; 0.9375 1.25; 0.3125 0.5; 0.3125 2; 0.3125 3; 0.3125 4.5; 0.9375 0.5; 0.9375 2; 0.9375 3; 0.9375 4.5; 0.125 1.25; 0.5 1.25; 0.75 1.25; 1.125 1.25; 0.125 3.75; 0.5 3.75; 0.75 3.75; 1.125 3.75];
        poreMult = [0.125 0.3125 0.3125 0.9375 0.9375 1.125 1.125 0.9375 0.9375 0.3125 0.3125 0.125; 3.75 3.75 3 3 3.75 3.75 1.25 1.25 2 2 1.25 1.25];
        La = [1 13; 13 9; 9 14; 14 18; 18 12; 12 17; 17 6; 2 16; 16 10; 10 15; 15 19; 19 11; 11 20; 20 5; 8 22; 22 9; 9 21; 21 25; 25 10; 10 26; 26 3; 7 23; 23 12; 12 24; 24 28; 28 11; 11 27; 27 4];
        divp = 1.25; divq = 5;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                K = (((2*((0.1875*p)*(2.5*q))) + ((0.625*p)*(q))))/1000000;
            case "K & q"
                K = Param1; q = Param2;
                p = (((K*1000000)/2.5)/q)/0.625;
            case "P & q"
                P = Param1; q = Param2;
                p = ((P*1000)-(8*q))/2;
        end
        [NoChange,Scaled,Fitted] = planar(User_Length, User_Width, p, q, divp, divq, KpMult, poreMult);
        NoChange.A = NaN; Scaled.A = NaN; Fitted.A = NaN; 
        NoChange.B = NaN; Scaled.B = NaN; Fitted.B = NaN;

        %% P06
        case "P06"  % *2 (divp&q), too lazy to rewrite it out
        KpMult = [0 0.75; 0.125 0.625; 0.25 1; 0.375 0.625; 0.5 0.75; 0.625 0.625; 0.75 1; 0.875 0.625; 1 0.75; 0 0.25; 0.125 0.125; 0.25 0.5; 0.375 0.125; 0.5 0.25; 0.625 0.125; 0.75 0.5; 0.875 0.125; 1 0.25; 0.25 0; 0.75 0]*2;
        poreMult = [0.25 0.375 0.5 0.625 0.75 0.75 0.625 0.5 0.375 0.25 0.25; 1 0.625 0.75 0.625 1 0.5 0.125 0.25 0.125 0.5 1]*2;
        La = [1 2; 2 3; 3 4; 4 5; 5 6; 6 7; 7 8; 8 9; 10 11; 11 12; 12 13; 13 14; 14 15; 15 16; 16 17; 17 18; 3 12; 7 16; 12 19; 16 20];
        divp = 2; divq = 2;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                K = (p*q)/1000000;
            case 'K & p'
                K = Param1; p = Param2;
                q = (K*1000000)/p;
            case 'A & p'
                A = Param1; p = Param2;
                q = p/tan(deg2rad(A/2));
        end
        [NoChange,Scaled,Fitted] = planar(User_Length, User_Width, p, q, divp, divq, KpMult, poreMult);
        NoChange.A = 2*rad2deg(atan((NoChange.p/2)/(NoChange.q/2))); NoChange.B=NaN;
        Scaled.A = 2*rad2deg(atan((Scaled.p/2)/(Scaled.q/2))); Scaled.B=NaN;
        Fitted.A = 2*rad2deg(atan((Fitted.p/2)/(Fitted.q/2))); Fitted.B=NaN;

        %% T01 (DIAMOND)
        case "T01"
        KpMult = [0 0.5; 0.5 1; 1 0.5; 0.5 0];
        poreMult = [0 0.5 1 0.5; 0.5 1 0.5 0];
        La = [1 2; 2 3; 3 4; 1 4];
        divp = 1; divq = 1;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                K = ((p*q)/2)/1000000; P = 4*(sqrt((p^2)+(q^2))/2)/1000;
            case 'K & p'
                K = Param1; p = Param2;
                q = (2*(K*1000000))/p; P = 4*(sqrt((p^2)+(q^2))/2)/1000;
            case 'P & p'
                P = Param1; p = Param2;
                q = sqrt((500*P)^2 - p^2); K = ((p*q)/2)/1000000;
            case 'A & p'
                A = Param1; p = Param2;
                q = p/(tan(deg2rad(A/2)));
        end
        [NoChange, Scaled, Fitted] = tubular(Diameter, User_Length, divp, divq, p, q, KpMult, poreMult);
        NoChange.A = rad2deg(atan(NoChange.q/NoChange.p)); NoChange.B = 180-90-NoChange.A; NoChange.A=NoChange.A*2; NoChange.B=NoChange.B*2;
        Scaled.A = rad2deg(atan(Scaled.q/Scaled.p)); Scaled.B = 180-90-Scaled.A; Scaled.A=Scaled.A*2; Scaled.B=Scaled.B*2;
        Fitted.A = rad2deg(atan(Fitted.q/Fitted.p)); Fitted.B = 180-90-Fitted.A; Fitted.A=Fitted.A*2; Fitted.B=Fitted.B*2;

        %% T02 (BOW TIE)
      case "T02"
            KpMult = [0 0.5; 0 4.5; 1 4.5; 1 0.5; 0.5 2; 0.5 3; 0.5 0; 0.5 5];
            poreMult = [0 0 0.5 1 1 0.5; 0.5 4.5 3 4.5 0.5 2];
            La = [1 2; 2 6; 6 3; 3 4; 4 5; 5 1; 6 8; 5 7];
            divp = 1; divq = 5;
            switch Build
                case 'p & q'
                    p = Param1; q = Param2;
                    K = (2*((5*q)*(p/2)/2))/1000000;
                case 'K & q'
                    K = Param1; q = Param2;
                    p = (2*(K*1000000))/(5*q);
                case 'A & q'
                    A = Param1; q = Param2;
                    p = 2*((1.5*q)/tan(deg2rad(((180-A)/2))));
                case 'P & q'
                    P = Param1; q = Param2;
                    p = round(2*(sqrt(((((P*1000)-(8*q))/4)^2) - ((1.5*q)^2))));              
            end
            [NoChange, Scaled, Fitted] = tubular(Diameter, User_Length, divp, divq, p, q, KpMult, poreMult);
            NoChange.A = 180-(2*rad2deg(atan((1.5*NoChange.q)/(NoChange.p/2)))); NoChange.B=NaN;
            Scaled.A = 180-(2*rad2deg(atan((1.5*Scaled.q)/(Scaled.p/2)))); Scaled.B=NaN;
            Fitted.A = 180-(2*rad2deg(atan((1.5*Fitted.q)/(Fitted.p/2)))); Fitted.B=NaN;

        %% T03 (BRICK OPEN)
         case "T03"
        KpMult = [0 0; 0 0.5; 0 1; 1 1; 1 0.5; 1 0; 2 0.5; 2 1; 2 0];
        poreMult = [0 0 1 1 0; 0 1 1 0 0];
        La = [1 2; 2 3; 3 4; 4 5; 5 6; 5 7; 7 8; 7 9; 1 6];
        divp = 2; divq = 1;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                K = p*q; P = ((2*p)+(2*q))/1000;
            case 'K & p'
                K = Param1; p = Param2;
                q = (K*1000000)/p; P = ((2*p)+(2*q))/1000;
            case 'P & p'
                P = Param1; p = Param2;
                q = ((P*1000)-(2*p))/2; K = p*q;
        end
        [NoChange, Scaled, Fitted] = tubular(Diameter, User_Length, divp, divq, p, q, KpMult, poreMult);
        NoChange.A = NaN; Scaled.A = NaN; Fitted.A = NaN; NoChange.B = NaN; Scaled.B = NaN; Fitted.B = NaN;
            
        %% T04 (BRICK CLOSED)
        case "T04"
        KpMult = [0 0; 0 1; 1 1; 1 0; 2 1; 2 0];
        poreMult = [0 0 1 1 0; 0 1 1 0 0];
        La = [1 2; 2 3; 3 4; 4 1; 3 5; 5 6];
        divp = 2; divq = 1;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                K = p*q; P = ((2*p)+(2*q))/1000;
            case 'K & p'
                K = Param1; p = Param2;
                q = (K*1000000)/p; P = ((2*p)+(2*q))/1000;
            case 'P & p'
                P = Param1; p = Param2;
                q = ((P*1000)-(2*p))/2; K = p*q;
        end
        [NoChange, Scaled, Fitted] = tubular(Diameter, User_Length, divp, divq, p, q, KpMult, poreMult);
        NoChange.A = NaN; Scaled.A = NaN; Fitted.A = NaN; NoChange.B = NaN; Scaled.B = NaN; Fitted.B = NaN;

        %% T05 (CHEVRON OPEN)
        case "T05"
            KpMult = [0 1; 1 1; 2 0.5; 1 0; 0 0; 1 0.5; 0 0.5];
            poreMult = [0 1 0 1 2 1 0; 0 0.5 1 1 0.5 0 0];
            La = [1 2; 2 3; 3 4; 4 5; 5 6; 6 1; 6 7];
            divp = 2; divq = 1;
            switch Build
                case 'p & q'
                    p = Param1; q = Param2;
                    K = 2*((p*(q/2)))/1000000;
                case 'K & p'
                    K = Param1; p = Param2;
                    q = (K*1000000)/p;
                case 'A & p'
                    A = Param1; p = Param2;
                    q = 2*p*tan(deg2rad(A/2));
                case 'P & p'
                    P = Param1; p = Param2;
                    q = round(2*sqrt((((P*1000)-(2*p))/4)^2-(p^2)));
            end
            [NoChange, Scaled, Fitted] = tubular(Diameter, User_Length, divp, divq, p, q, KpMult, poreMult);
            NoChange.A = 2*rad2deg(atan((NoChange.q/2)/NoChange.p)); NoChange.B = NaN;
            Fitted.A = 2*rad2deg(atan((Fitted.q/2)/Fitted.p)); Fitted.B = NaN;
            Scaled.A = 2*rad2deg(atan((Scaled.q/2)/Scaled.p)); Scaled.B = NaN;

        %% T06 (CHEVRON CLOSED)
        case "T06"
        KpMult = [0 0; 1 0.5; 0 1; 1 1; 2 0.5; 1 0; 2 1; 2 0];
        poreMult = [0 1 0 1 2 1 0; 0 0.5 1 1 0.5 0 0];
        La = [1 2; 2 3; 3 4; 4 5; 5 6; 6 1; 4 7; 6 8];
        divp = 2; divq = 1;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                K = 2*((p*(q/2)))/1000000;
            case 'K & p'
                K = Param1; p = Param2;
                q = (K*1000000)/p;
            case 'A & p'
                A = Param1; p = Param2;
                q = 2*p*tan(deg2rad(A/2));
            case 'P & p'
                P = Param1; p = Param2;
                q = round(2*sqrt((((P*1000)-(2*p))/4)^2-(p^2)));
        end
        [NoChange, Scaled, Fitted] = tubular(Diameter, User_Length, divp, divq, p, q, KpMult, poreMult);
        NoChange.A = 2*rad2deg(atan((NoChange.q/2)/NoChange.p)); NoChange.B = NaN;
        Fitted.A = 2*rad2deg(atan((Fitted.q/2)/Fitted.p)); Fitted.B = NaN;
        Scaled.A = 2*rad2deg(atan((Scaled.q/2)/Scaled.p)); Scaled.B = NaN;

        %% T07
        case "T07"
        KpMult = [0.25 0; 0.25 0.5; 0 0.5; 0 0.75; 0.5 0.75; 0.5 1; 0.75 1; 0.75 0.5; 1 0.5; 1 0.25; 0.5 0.25; 0.5 0];
        poreMult = [0.25 0.25 0 0 0.5 0.5 0.75 0.75 1 1 0.5 0.5; 0 0.5 0.5 0.75 0.75 1 1 0.5 0.5 0.25 0.25 0];
        La = [1 2; 2 3; 3 4; 4 5; 5 6; 6 7; 7 8; 8 9; 9 10; 10 11; 11 12; 12 1];
        divp = 1; divq = 1;
        switch Build
            case 'p & q'
                p = Param1; q = Param2;
                K = (((p/2)*(q/2))+(4*(((p/4)*(q/4)))))/1000000; % or pq/2
            case 'K & p'
                K = Param1; p = Param2;
                q = (2*(K*1000000))/p;
            case 'P & p'
                P = Param1; p = Param2;
                q = ((1000*P)-(2*p))/2;
        end
        [NoChange, Scaled, Fitted] = tubular(Diameter, User_Length, divp, divq, p, q, KpMult, poreMult);
        NoChange.A = NaN; NoChange.B = NaN; Fitted.A = NaN; Fitted.B = NaN; Scaled.A = NaN; Scaled.B = NaN;
    end

    %% KP & PORE COORDINATES
    poly = polyshape(NoChange.poreCoord(1,:),NoChange.poreCoord(2,:));
    NoChange.K = area(poly); NoChange.P = perimeter(poly);
    
    polyFit = polyshape(Fitted.poreCoord(1,:),Fitted.poreCoord(2,:));
    Fitted.K = area(polyFit); Fitted.P = perimeter(polyFit);
    
    polyScale = polyshape(Scaled.poreCoord(1,:),Scaled.poreCoord(2,:));
    Scaled.K = area(polyScale); Scaled.P = perimeter(polyScale);

    %% Info export to spreadsheet

    if Category == "Planar"
        original = cat(1,NoChange.Length,NoChange.Width,NoChange.p,NoChange.q,NoChange.K,NoChange.P,NoChange.A,NoChange.B,NoChange.ucP,NoChange.ucQ); 
        fitted = cat(1,Fitted.Length,Fitted.Width,Fitted.p,Fitted.q,Fitted.K,Fitted.P,Fitted.A,Fitted.B,Fitted.ucP,Fitted.ucQ); 
        scaled = cat(1,Scaled.Length,Scaled.Width,Scaled.p,Scaled.q,Scaled.K,Scaled.P,Scaled.A,Scaled.B,Scaled.ucP,Scaled.ucQ);
        rName = ["Scaffold Length (mm)","Scaffold Width (mm)","Pore Length: p ("+char(181)+"m)","Pore Width: q ("+char(181)+"m)","Pore Area: K (mm"+char(178)+")","Pore Perimeter: P (mm)","Major Pore Angle: A (deg)","Minor Pore Angle: B (deg)","Repeating Cells (X)","Repeating Cells (Y)"];
        cName = ["Original Geometry","Scaled Geometry","Fitted Geometry"];
        Information = array2table(cat(2,original,scaled,fitted),"RowNames",rName,"VariableNames",cName); Information.Variables = round(Information.Variables,3);
        writetable(Information,fullfile(pathDirectory, 'UserExports', 'info.xlsx'),'WriteRowNames',true)

    elseif Category == "Tubular"
        original = cat(1,NoChange.Length,Diameter,NoChange.p,NoChange.q,NoChange.K,NoChange.P,NoChange.A,NoChange.B,NoChange.ucP,NoChange.ucQ); 
        fitted = cat(1,Fitted.Length,Diameter,Fitted.p,Fitted.q,Fitted.K,Fitted.P,Fitted.A,Fitted.B,Fitted.ucP,Fitted.ucQ); 
        scaled = cat(1,Scaled.Length,Diameter,Scaled.p,Scaled.q,Scaled.K,Scaled.P,Scaled.A,Scaled.B,Scaled.ucP,Scaled.ucQ);
        rName = ["Scaffold Length (mm)","Scaffold Diameter (mm)","Pore Length: p ("+char(181)+"m)","Pore Width: q ("+char(181)+"m)","Pore Area: K (mm"+char(178)+")","Pore Perimeter: P (mm)","Major Pore Angle: A (deg)","Minor Pore Angle: B (deg)","Repeating Cells (X)","Repeating Cells (Y)"];
        cName = ["Original Geometry","Scaled Geometry","Fitted Geometry"];
        Information = array2table(cat(2,original,scaled,fitted),"RowNames",rName,"VariableNames",cName); Information.Variables = round(Information.Variables,3);
        writetable(Information,fullfile(pathDirectory, 'UserExports', 'info.xlsx'),'WriteRowNames',true)
    end

    % PREVIEWINFO
    PreviewKP = cat(2,NoChange.Kp,Scaled.Kp,Fitted.Kp);
    PreviewPC = cat(2,NoChange.poreCoord,Scaled.poreCoord,Fitted.poreCoord);
end