function [NoChange, Scaled, Fitted] = tubular(Diameter, Length, divp, divq, p, q, KpMult, poreMult)
    circum = round(pi,4)*Diameter; pM = primes(500); %pM(2) = [];

    %% NO CHANGE
    ucP = ceil((Length*1000)/(divp*p)); ucQ = ceil((circum*1000)/(divq*q));
    Kp = [(KpMult(:,1)*p) (KpMult(:,2)*q)]*1e-3;
    poreCoord = [(poreMult(1,:)*p); (poreMult(2,:)*q)]*1e-3;

    NoChange.ucP = ucP;
    NoChange.Kp = Kp;
    NoChange.poreCoord = poreCoord;
    NoChange.ucQ = ucQ;
    NoChange.p = p;
    NoChange.q = q;
    NoChange.Length = Length;

    %% TUBULAR SCALE CASE
    ratio = q/p;
    [~, idx] = min(abs(ucQ-pM));

    ucQ_s = pM(idx);
    q_s = ((circum*1000)/(ucQ_s))/divq; 
    p_s = q_s/ratio;
    ucP_s = ceil(((Length*1000)/p_s)/divp);

    if ucP_s == 3
        ucP_s = ucP_s-1;
    end
    Length_s = (ucP_s*divp*p_s)/1000;

    Kp_s = [KpMult(:,1)*p_s KpMult(:,2)*q_s]*1e-3;
    poreCoord_s = [poreMult(1,:)*p_s; poreMult(2,:)*q_s]*1e-3;

    Scaled.ucP = ucP_s;
    Scaled.Kp = Kp_s;
    Scaled.poreCoord = poreCoord_s;
    Scaled.ucQ = ucQ_s;
    Scaled.p = p_s;
    Scaled.q = q_s;
    Scaled.Length = Length_s;

    %% TUBULAR FIT CASE
    [temp, indx] = min(abs(ucQ-pM));
    ucQ_f = pM(indx); q_f = ((circum*1000)/pM(indx))/divq; 
    
    Length_f = Length; ucP_f = round(ucP); 

    if ucP_f == 3
        ucP_f = ucP_f-1;
    end
    p_f = ((Length*1000)/ucP_f/divp);
    
    %p_f = p;
    %ucP_f = ceil(((Length*1000)/p_f)/divp);
    %Length_f = (ucP_f*divp*p_f)/1000;

    Kp_f = [KpMult(:,1)*p_f KpMult(:,2)*q_f]*1e-3;
    poreCoord_f = [poreMult(1,:)*p_f; poreMult(2,:)*q_f]*1e-3;

    Fitted.ucP = ucP_f;
    Fitted.Kp = Kp_f;
    Fitted.poreCoord = poreCoord_f;
    Fitted.ucQ = ucQ_f;
    Fitted.p = p_f;
    Fitted.q = q_f;
    Fitted.Length = Length_f;
end