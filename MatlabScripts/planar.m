function [NoChange, Scaled, Fitted] = planar(User_Length, User_Width, p, q, divp, divq, KpMult, poreMult)
    
    %% NO CHANGE CASE
    ucP = ceil((User_Length*1000)/(divp*p));
    Kp = [(KpMult(:,1)*p) (KpMult(:,2)*q)]*1e-3;
    poreCoord = [(poreMult(1,:)*p); (poreMult(2,:)*q)]*1e-3;
    ucQ = ceil((User_Width*1000)/(divq*q));
    Length_og = (ucP*divp*p)/1000;
    Width_og = (ucQ*divq*q)/1000;

    disp(['Length_og calculated as: ', num2str(Length_og, 15)]);  % Show full precision

    NoChange.ucP = ucP;
    NoChange.Kp = Kp;
    NoChange.poreCoord = poreCoord;
    NoChange.ucQ = ucQ;
    NoChange.p = p;
    NoChange.q = q;
    NoChange.Length = Length_og;
    NoChange.Width = Width_og;

    %% PLANAR SCALE CASE
    ratio = q/p; 
    Xx = (User_Length*(ucP*p))-User_Length; 
    Yy = (User_Width*(ucQ*q))-User_Width;
    if Xx > Yy
        ucP_s = ucP; 
        p_s = ((User_Length*1000)/ucP_s)/divp; 
        q_s = p_s*ratio; ucQ_s = ceil(((User_Width*1000)/q_s)/divq);
    elseif Xx < Yy
        ucQ_s = ucQ; 
        q_s = ((User_Width*1000)/ucQ_s)/divq; 
        p_s = q_s/ratio; ucP_s = ceil(((User_Length*1000)/p_s)/divp);
    else
        ucP_s = ucP; 
        ucQ_s = ucQ;
        p_s = p; 
        q_s = q;
    end
    Length_s = (ucP_s*divp*p_s)/1000; 
    Width_s = (ucQ_s*divq*q_s)/1000;
    Kp_s = [KpMult(:,1)*p_s KpMult(:,2)*q_s]*1e-3;
    poreCoord_s = [poreMult(1,:)*p_s; poreMult(2,:)*q_s]*1e-3;

    Scaled.ucP = ucP_s;
    Scaled.Kp = Kp_s;
    Scaled.poreCoord = poreCoord_s;
    Scaled.ucQ = ucQ_s;
    Scaled.p = p_s;
    Scaled.q = q_s;
    Scaled.Length = Length_s;
    Scaled.Width = Width_s;

    %% PLANAR FIT CASE
    ucP_f = ucP; 
    ucQ_f = ucQ; p_f = ((User_Length*1000)/ucP)/divp; 
    q_f = ((User_Width*1000)/ucQ)/divq;
    Length_f = (ucP_f*divp*p_f)/1000; 
    Width_f = (ucQ_f*divq*q_f)/1000;
    Kp_f = [KpMult(:,1)*p_f KpMult(:,2)*q_f]*1e-3;
    poreCoord_f = [poreMult(1,:)*p_f; poreMult(2,:)*q_f]*1e-3;  

    Fitted.ucP = ucP_f;
    Fitted.Kp = Kp_f;
    Fitted.poreCoord = poreCoord_f;
    Fitted.ucQ = ucQ_f;
    Fitted.p = p_f;
    Fitted.q = q_f;
    Fitted.Length = Length_f;
    Fitted.Width = Width_f;
end