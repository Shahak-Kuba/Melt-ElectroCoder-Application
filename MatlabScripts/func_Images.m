function [ax1, ax2, ax3, ax4] = func_Images(Generated_PreviewKP, Generated_PreviewPC, geo_divp, geo_divq, geo_La, Generated_Information,Category,Diameter,pathDirectory)

numColumns = 2;
Kp = Generated_PreviewKP(:, 1:numColumns);
Kp_s = Generated_PreviewKP(:, numColumns + 1 : 2*numColumns);
Kp_f = Generated_PreviewKP(:, 2*numColumns + 1 : 3*numColumns);
poreCoord = Generated_PreviewPC(:, 1:numColumns);
poreCoord_s = Generated_PreviewPC(:, numColumns + 1 : 2*numColumns);
poreCoord_f = Generated_PreviewPC(:, 2*numColumns + 1 : 3*numColumns);

divp = geo_divp;
divq = geo_divq;
La = geo_La;

% CALL P & Q FOR EACH CASE
Generated_Information = table2array(Generated_Information(:,2:4));
p = Generated_Information(3,1);
q = Generated_Information(4,1);
p_s = Generated_Information(3,2);
q_s = Generated_Information(4,2);
p_f = Generated_Information(3,3);
q_f = Generated_Information(4,3);

% NUMBER OF REPEATS FOR PREVIEW
Nx = 3; Ny = 3;

% REPEAT POINTS
Ko = Kp; Kf = Kp_f; Ks = Kp_s;

for i = 0:Nx-1
    Ko = [Ko; Kp(:,1)+i*((p*divp)/1000) Kp(:,2)];
end
for i = 0:Nx-1
    Kf = [Kf; Kp_f(:,1)+i*((p_f*divp)/1000) Kp_f(:,2)];
end
for i = 0:Nx-1
    Ks = [Ks; Kp_s(:,1)+i*((p_s*divp)/1000) Kp_s(:,2)];
end
Ko_x = Ko; Kf_x = Kf; Ks_x = Ks;

for i = 0:Ny-1
    Ko = [Ko; Ko_x(:,1) Ko_x(:,2)+i*((q*divq)/1000)];
end
for i = 0:Ny-1
    Kf = [Kf; Kf_x(:,1) Kf_x(:,2)+i*((q_f*divq)/1000)];
end
for i = 0:Ny-1
    Ks = [Ks; Ks_x(:,1) Ks_x(:,2)+i*((q_s*divq)/1000)];
end
clear Ko_x Kf_x Ks_x

% REPEAT LINES
Lo = La; Lf = La; Ls = La;
for i = 1:length(Ko)
    Lo = [Lo; La+i*size(Kp,1)*[1 1]];
end
for i = 1:length(Kf)
    Lf = [Lf; La+i*size(Kp_f,1)*[1 1]];
end
for i = 1:length(Ks)
    Ls = [Ls; La+i*size(Kp_s,1)*[1 1]];
end

% FIGURE GENERATION
figure('Visible','off');

subplot(2,2,1); hold on; axis equal % SCALED CELL
    fill(poreCoord_s(1,:),poreCoord_s(2,:),[.7 .7 .7],'EdgeColor','none');
    scatter(Kp(:,1), Kp(:,2), 50, 'black','filled');
    scatter(Kp_s(:,1), Kp_s(:,2), 50, 'blue','filled');
    for i = 1:length(La)
        plot([Kp(La(i,1),1) Kp(La(i,2),1)],[Kp(La(i,1),2) Kp(La(i,2),2)],'Color','k','LineWidth',1);
        plot([Kp_s(La(i,1),1) Kp_s(La(i,2),1)],[Kp_s(La(i,1),2) Kp_s(La(i,2),2)],'Color','b','LineWidth',1);
    end
    xmax = max([Kp(:,1); Kp_s(:,1)]); xlim([0 xmax]); xticks([0,(xmax/4),(xmax/2),3*(xmax/4),xmax]); xlabel("mm","FontWeight","bold");
    ymax = max([Kp(:,2); Kp_s(:,2)]); ylim([0 ymax]); yticks([0,(ymax/4),(ymax/2),3*(ymax/4),ymax]); ylabel("mm","FontWeight","bold");
    grid on; grid minor; title('Scaled Cell');
    set(gca,"FontSize",14); ytickformat('%.2f'); xtickformat('%.2f');
    ax1 = gca;
hold off

subplot(2,2,2); hold on; axis equal % FITTED CELL
    fill(poreCoord_f(1,:),poreCoord_f(2,:),[.7 .7 .7],'EdgeColor','none');
    scatter(Kp(:,1), Kp(:,2), 50, 'black','filled');
    scatter(Kp_f(:,1), Kp_f(:,2), 50, 'blue','filled');
    for i = 1:length(La)
        plot([Kp(La(i,1),1) Kp(La(i,2),1)],[Kp(La(i,1),2) Kp(La(i,2),2)],'Color','k','LineWidth',1);
        plot([Kp_f(La(i,1),1) Kp_f(La(i,2),1)],[Kp_f(La(i,1),2) Kp_f(La(i,2),2)],'Color','b','LineWidth',1);
    end
    xmax = max([Kp(:,1); Kp_s(:,1)]); xlim([0 xmax]); xticks([0,(xmax/4),(xmax/2),3*(xmax/4),xmax]); xlabel("mm","FontWeight","bold");
    ymax = max([Kp(:,2); Kp_s(:,2)]); ylim([0 ymax]); yticks([0,(ymax/4),(ymax/2),3*(ymax/4),ymax]); ylabel("mm","FontWeight","bold");
    grid on; grid minor; title('Fitted Cell');
    set(gca,"FontSize",14); ytickformat('%.2f'); xtickformat('%.2f');
    ax2 = gca;
hold off

subplot(2,2,3); hold on; axis equal % SCALED PREVIEW
    scatter(Ko(:,1),Ko(:,2),5,'black','filled');
    scatter(Ks(:,1),Ks(:,2),10,'blue','filled');
    for i = 1:length(Ko)
        pl1 = plot([Ko(Lo(i,1),1) Ko(Lo(i,2),1)],[Ko(Lo(i,1),2) Ko(Lo(i,2),2)], 'Color','k','LineWidth',0.5,'Linestyle',':');
    end
    for i = 1:length(Ks)
        pl2 = plot([Ks(Ls(i,1),1) Ks(Ls(i,2),1)],[Ks(Ls(i,1),2) Ks(Ls(i,2),2)], 'Color','b','LineWidth',0.5);
    end
    legend([pl1,pl2],'Original','Scaled',Location='southeast');
    ymax = max([Ko(:,2); Ks(:,2)]); ylim([0 ymax]); yticks([0,(ymax/4),(ymax/2),3*(ymax/4),ymax]); ylabel("mm","FontWeight","bold");
    xmax = max([Ko(:,1); Ks(:,1)]); xlim([0 xmax]); xticks([0,(xmax/4),(xmax/2),3*(xmax/4),xmax]); xlabel("mm","FontWeight","bold");
    grid on; grid minor; title('Scaled Preview');
    set(gca,"FontSize",14); ytickformat('%.2f'); xtickformat('%.2f');
    ax3 = gca;
hold off

subplot(2,2,4); hold on; axis equal % FITTED PREVIEW
    scatter(Ko(:,1),Ko(:,2),5,'black','filled');
    scatter(Kf(:,1),Kf(:,2),10,'blue','filled');
    for i = 1:length(Ko)
        pl3 = plot([Ko(Lo(i,1),1) Ko(Lo(i,2),1)],[Ko(Lo(i,1),2) Ko(Lo(i,2),2)], 'Color','k','LineWidth',0.5,'Linestyle',':');
    end
    for i = 1:length(Kf)
        pl4 = plot([Kf(Lf(i,1),1) Kf(Lf(i,2),1)],[Kf(Lf(i,1),2) Kf(Lf(i,2),2)], 'Color','b','LineWidth',0.5);
    end
    legend([pl3,pl4],'Original','Fitted',Location='southeast');
    ymax = max([Ko(:,2); Kf(:,2)]); ylim([0 ymax]); yticks([0,(ymax/4),(ymax/2),3*(ymax/4),ymax]); ylabel("mm","FontWeight","bold");
    xmax = max([Ko(:,1); Kf(:,1)]); xlim([0 xmax]); xticks([0,(xmax/4),(xmax/2),3*(xmax/4),xmax]); xlabel("mm","FontWeight","bold");
    grid on; grid minor; title('Fitted Preview');
    set(gca,"FontSize",14); ytickformat('%.2f'); xtickformat('%.2f');
    ax4 = gca;
hold off

end