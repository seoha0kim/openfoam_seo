% ---
% jupyter:
%   jupytext:
%     formats: ipynb,m:percent
%     text_representation:
%       extension: .m
%       format_name: percent
%       format_version: '1.3'
%       jupytext_version: 1.6.0
%   kernelspec:
%     display_name: Matlab
%     language: matlab
%     name: matlab
% ---

% %% [markdown]
% # m_cfd_of

% %% [markdown]
% Saang Bum Kim <br>
% 2020-09-21 08:30:46

% %%
function [model,sb] = m_cfd_of_201003(varargin)
%
% Model exported on Sep 16 2020, 18:03 by COMSOL 5.5.0.359.

% %%
% !comsol mphserver -silent &

% %%
%
%%  PART 0.     Opening
%
fclose all; close all
clc
clear all
tcomp = tic;
telap = toc(tcomp);

% s_dir = 'git/openfoam_seo/of/org/';
s_dir = 'git/openfoam_seo//wtt/yjn2/deck/';

seo_init

id_f = 1;
% id_sv = true;
id_sv = false;
% id_pl = true;
id_pl = false;

% id_jupyter = false;
id_jupyter = true;

% %%
clear sb

% %% [markdown]
% # Pre Process

% %% [markdown]
% ## from CSL: rid

% %%
cd ~/Work/git/openfoam_seo/wtt/yjn2/deck/

% %%
% model = mphload('imsi.mph')
% model = mphload('tower_large.mph')

for id_geo = 1:2
    for id_al = 1:3

clear sb

        if (id_geo == 1) & (id_al == 1)
            continue
        end

        switch id_geo
            case 1
                s_geo = 'upper';
            case 2
                s_geo = 'lower';
            % otherwise
                % body
        end
        switch id_al
            case 1
                s_al = '000';
            case 2
                s_al = 'm25';
            case 3
                s_al = 'p25';
            % otherwise
                % body
        end

% model = mphload('deck_upper_am25_turbulent_SST_Re200000.mph')
model = mphload(sprintf('deck_%s_a%s_turbulent_SST_Re200000.mph',s_geo,s_al))

% %%
% mphmesh(model)
% x = model.mesh("mesh1").getVertex();

% %%
[meshstats,meshdata] = mphmeshstats(model);

% %% [markdown]
% ### sb

% %%
sb.v.n = size(meshdata.vertex,2);
sb.v.x = meshdata.vertex;
sb.v.xn = [[sb.v.x;zeros(1,sb.v.n)],[sb.v.x;ones(1,sb.v.n)]];
sb.b4.n = size(meshdata.elem{2},2);
sb.b4.id = meshdata.elem{2}+1;
sb.b3.n = size(meshdata.elem{3},2);
sb.b3.id = meshdata.elem{3}+1;

% %%
sb.box_ids = model.selection.tags();

sb.box_n = length(sb.box_ids);
% for ii=1:7
% for ii=[1 4:7]
% sb.id_box = [5 6 7 1 2 3 4];
sb.id_box = [1 2 3 4 5 6 7 ];
for ii=1:sb.box_n
    % sb.box(ii) = mpheval(model,'X','selection',sprintf('box%d',ii));
    sb.box(ii) = mpheval(model,'X','selection',sb.box_ids(find(ii == sb.id_box)));
end

% %%
% for ii=1:7
% for ii=[1 4:7]
for ii=1:sb.box_n
    % ii = 1;
    sb.box(ii).n = size(sb.box(ii).t,2);
    for jj = 1:size(sb.box(ii).p,2)
        % jj = 1;
        x_ii = sb.box(ii).p(:,jj);
        lc1 = find(sb.v.x(1,:) == x_ii(1));
        lc2 = find(sb.v.x(2,lc1) == x_ii(2));
        lc = lc1(lc2);
        sb.box(ii).id(jj) = lc;
        if any(size(lc) ~= [1,1])
            fprintf('Error: %d %d', ii, jj)
        end
    end
    for jj = 1:sb.box(ii).n
        sb.box(ii).lc(:,jj) = sb.box(ii).id( sb.box(ii).t(:,jj)+1 );
    end
end

% %%
% save imsi_tower_200923 meshdata sb

% %% [markdown]
% ### data load

% %%
% whos -file imsi_tower_200923
% load imsi_tower_200923

% %%
% meshdata

% %%
if id_pl
lc = meshdata.elem{find(cellfun(@(x) strcmpi(x,'vtx'), meshdata.types))}+1;
id_pause = true;
figure(1)
for ii=1:length(lc)-1
    plot(meshdata.vertex(1,lc(ii+[0,1])),meshdata.vertex(2,lc(ii+[0,1])), ...
        'o-','Color',rgb('Navy'),'MarkerSize',6-3)
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
end
end

% %%
if id_pl
sb.box(1)
sb.box(1).d1(1:3)
sb.box(1).p(:,1:3)
sb.box(1).t(:,1:3)
sb.box(1).ve(1:3,:)
end

% %% [markdown]
% ### c_box

% %%
% if id_pl
if 1
id_pause = true;
figure(1)
clf
for jj=1:sb.box_n
for ii=1:size(sb.box(jj).t,2)
%     id = sb.box(jj).t(:,ii)+1;
%     x_id = sb.box(jj).p(:,id);

x_id = sb.v.x(:,sb.box(jj).lc(:,ii));

% plot(sb.box(1).p(1,ii),sb.box(1).p(2,ii),'o','MarkerSize',6-4)
plot(x_id(1,:),x_id(2,:),'-o','MarkerSize',6-4,'Color',rgb('Navy'))
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end

map({mean(x_id')}, {@(x) text(x(1),x(2),sprintf('%d',ii))})

x1 = x_id(:,1)';
x2 = x_id(:,2)';
xm = mean(x_id');
x1m = (x1+xm)/2;
x2m = (x2+xm)/2;
text(x1m(1),x1m(2),sprintf('%d',1),'FontSize',9,'Color',rgb('Crimson'))
text(x2m(1),x2m(2),sprintf('%d',2),'FontSize',9,'Color',rgb('Crimson'))

end
end
end
% figure(2)
% plot(sb.box(2).ve)
% if 0
if 1
jj = 3;
for ii=1:size(sb.box(jj).t,2)
    id = sb.box(jj).t(:,ii)+1;
    x_id = sb.box(jj).p(:,id);
% plot(sb.box(1).p(1,ii),sb.box(1).p(2,ii),'o','MarkerSize',6-4)
plot(x_id(1,:),x_id(2,:),'-s','MarkerSize',6-4,'Color',rgb('Orange'))
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
x_id = sb.v.x(:,sb.box(jj).lc(:,ii));
plot(x_id(1,:),x_id(2,:),'-d','MarkerSize',6-1,'Color',rgb('Crimson'))
end
end

% %% [markdown]
% ### triangular

% %%
if id_pl
i_34 = 'b3';
% i_34 = 'b4';
id_pause = true;
figure(1)
clf
for ii=1:sb.(i_34).n
% for ii=1:2^0
% for ii=1:2^2
% for ii=1:2^4
    plot(sb.v.x(1,sb.(i_34).id(:,ii)), sb.v.x(2,sb.(i_34).id(:,ii)), '-o', 'MarkerSize', 6-3)
    for jj=1:length(sb.(i_34).id(:,ii))
        text(sb.v.x(1,sb.(i_34).id(jj,ii)), sb.v.x(2,sb.(i_34).id(jj,ii)), sprintf('%d',jj))
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
end
end

% %% [markdown]
% ### quad

% %%
if id_pl
% i_34 = 'b3';
i_34 = 'b4';
id_pause = true;
figure(1)
clf
% for ii=1:sb.(i_34).n
% for ii=1:2^0
for ii=1:2^2
% for ii=1:2^4
    plot(sb.v.x(1,sb.(i_34).id(:,ii)), sb.v.x(2,sb.(i_34).id(:,ii)), '-o', 'MarkerSize', 6-3)
    for jj=1:length(sb.(i_34).id(:,ii))
        text(sb.v.x(1,sb.(i_34).id(jj,ii)), sb.v.x(2,sb.(i_34).id(jj,ii)), sprintf('%d',jj))
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
end
end

% %% [markdown]
% ### Whole

% %%
if id_pl
% i_34 = 'b3';
i_34 = 'b4';
id_pause = true;
figure(1)
clf
for ii=1:sb.(i_34).n
% for ii=1:2^0
% for ii=1:2^2
% for ii=1:2^10
    plot(sb.v.x(1,sb.(i_34).id(:,ii)), sb.v.x(2,sb.(i_34).id(:,ii)), '-o', 'MarkerSize', 6-3)
    for jj=1:length(sb.(i_34).id(:,ii))
        text(sb.v.x(1,sb.(i_34).id(jj,ii)), sb.v.x(2,sb.(i_34).id(jj,ii)), sprintf('%d',jj))
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
end
i_34 = 'b3';
% for ii=1:2^2
for ii=1:2^8
    plot(sb.v.x(1,sb.(i_34).id(:,ii)), sb.v.x(2,sb.(i_34).id(:,ii)), '-o', 'MarkerSize', 6-3)
    for jj=1:length(sb.(i_34).id(:,ii))
        text(sb.v.x(1,sb.(i_34).id(jj,ii)), sb.v.x(2,sb.(i_34).id(jj,ii)), sprintf('%d',jj))
    end
%     if id_pause
%         gcfG;gcfH;gcfLFont;gcfS;%gcfP
%         id_pause = false;
%     end
end
end

% %% [markdown]
% ### openFoam

% %%
% fid = fopen(sprintf('blockMeshDict_tower_1_%s.foam',datestr(now,'yymmdd')),'w+');
fid = fopen(sprintf('blockMeshDict_yjn2_deck_%s_a%s_%s.foam', ...
    s_geo,s_al,datestr(now,'yymmdd')),'w+');

fprintf(fid,'/*--------------------------------*- C++ -*----------------------------------*\\\n');
fprintf(fid,'| =========                 |                                                 |\n');
fprintf(fid,'| \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |\n');
fprintf(fid,'|   \\\\  /    O peration     | Web:      https://www.OpenFOAM.org              |\n');
fprintf(fid,'|  \\\\    /   A nd           | Version:  8                                     |\n');
fprintf(fid,'|    \\\\/     M anipulation  |                                                 |\n');
fprintf(fid,'\\*---------------------------------------------------------------------------*/\n');
fprintf(fid,'FoamFile\n');
fprintf(fid,'{\n');
fprintf(fid,'    version     2.0;\n');
fprintf(fid,'    format      ascii;\n');
fprintf(fid,'    class       dictionary;\n');
fprintf(fid,'    object      blockMeshDict;\n');
fprintf(fid,'}\n');
fprintf(fid,'// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //\n');
fprintf(fid,'\n');
fprintf(fid,'convertToMeters 1;\n');
fprintf(fid,'\n');
fprintf(fid,'vertices\n');
fprintf(fid,'(\n');

for ii=1:size(meshdata.vertex,2)
% for ii=1:2^4
    fprintf(fid,'(%f %f 0)\n',meshdata.vertex(:,ii) );
    % fprintf(fid,'(%.56f %.56f)\n',meshdata.vertex(:,ii) );
end

for ii=1:size(meshdata.vertex,2)
% for ii=1:2^4
    fprintf(fid,'(%f %f 1)\n',meshdata.vertex(:,ii) );
    % fprintf(fid,'(%.56f %.56f)\n',meshdata.vertex(:,ii) );
end

% fprintf(fid,'vertices #codeStream\n');
% fprintf(fid,'{\n');
% fprintf(fid,'    codeInclude\n');
% fprintf(fid,'    #{\n');
% fprintf(fid,'        #include "pointField.H"\n');
% fprintf(fid,'    #};\n');
% fprintf(fid,'\n');
% fprintf(fid,'    code\n');
% fprintf(fid,'    #{\n');
% fprintf(fid,'        pointField points(%d);\n'%int(np.shape(of_xyz)[1]/2));
% % for ii in range(len(of_xyz[0])):
% for ii in range(int(np.shape(of_xyz)[1]/2)):
%     fprintf(fid,'        points[%d] = point(%f, %f, %f);\n'%(ii,of_xyz[0][ii],of_xyz[1][ii],of_xyz[2][ii]));
% fprintf(fid,'\n');
% fprintf(fid,'        // Duplicate z points\n');
% fprintf(fid,'        label sz = points.size();\n');
% fprintf(fid,'        points.setSize(2*sz);\n');
% fprintf(fid,'        for (label i = 0; i < sz; i++)\n');
% fprintf(fid,'        {\n');
% fprintf(fid,'            const point& pt = points[i];\n');
% fprintf(fid,'            points[i+sz] = point(pt.x(), pt.y(), -pt.z());\n');
% % fprintf(fid,'            points[i+sz] = point(pt.x(), pt.y(), 1);\n');
% fprintf(fid,'        }\n');
% fprintf(fid,'\n');
% fprintf(fid,'        os << points;\n');
% fprintf(fid,'    #};\n');
% fprintf(fid,'};\n');

fprintf(fid,');\n');
fprintf(fid,'\n');
fprintf(fid,'blocks\n');
fprintf(fid,'(\n');
% fprintf(fid,'    hex (0 1 2 3 4 5 6 7) (20 20 1) simpleGrading (1 1 1)\n');

% if 0
i_34 = 'b4';
for ii=1:sb.(i_34).n
    % ii = 1;
    lc = sb.(i_34).id(:,ii);
    % if 0
    %     id_pause = true;
    %     figure(1)
    %     plot(sb.v.x(1,lc),sb.v.x(2,lc))
    %     for jj=1:length(sb.(i_34).id(:,ii))
    %         text(sb.v.x(1,sb.(i_34).id(jj,ii)), sb.v.x(2,sb.(i_34).id(jj,ii)), sprintf('%d',jj))
    %     end
    %     if id_pause
    %         gcfG;gcfH;gcfLFont;gcfS;%gcfP
    %         id_pause = false;
    %     end
    % end
    % s_lc = [lc(1:2)+sb.v.n;lc([2,1]);lc(3:4)+sb.v.n;lc([4,3])];
    s_lc = [lc(1) lc(1)+sb.v.n lc(2)+sb.v.n lc(2) lc(3) lc(3)+sb.v.n lc(4)+sb.v.n lc(4)];
    fprintf(fid, '    hex (%d %d %d %d %d %d %d %d) (1 1 1) simpleGrading (1 1 1)\n', s_lc-1);
    % if 0
    %     i_34 = 'b4';
    %     ii = 1;
    %     ii = 2;
    %     ii = 4;
    %     lc = sb.(i_34).id(:,ii);
    %     s_lc = [lc(1) lc(1)+sb.v.n lc(2)+sb.v.n lc(2) lc(3) lc(3)+sb.v.n lc(4)+sb.v.n lc(4)];

    %     id_pause = true;
    %     figure(1)
    %     % clf
    %     plot3(sb.v.xn(1,s_lc),sb.v.xn(2,s_lc),sb.v.xn(3,s_lc),'-o', ...
    %         'MarkerSize',6-3)
    %         % 'MarkerSize',6-3,'Color',rgb('Navy'))
    %     for jj=1:length(sb.(i_34).id(:,ii))
    %         text(sb.v.x(1,sb.(i_34).id(jj,ii)), sb.v.x(2,sb.(i_34).id(jj,ii)), sprintf('%d',jj))
    %     end
    %     if id_pause
    %         gcfG;gcfH;gcfLFont;gcfS;%gcfP
    %         id_pause = false;
    %     end
    % end
end
% end
i_34 = 'b3';
for ii=1:sb.(i_34).n
    lc = sb.(i_34).id(:,ii);
    s_lc = [lc(1) lc(1)+sb.v.n lc(2)+sb.v.n lc(2) lc(3) lc(3)+sb.v.n lc(3)+sb.v.n lc(3)];
    fprintf(fid, '    hex (%d %d %d %d %d %d %d %d) (1 1 1) simpleGrading (1 1 1)\n', s_lc-1);
end

fprintf(fid,');\n');
fprintf(fid,'\n');
fprintf(fid,'edges\n');
fprintf(fid,'(\n');
fprintf(fid,');\n');
fprintf(fid,'\n');
fprintf(fid,'boundary\n');
fprintf(fid,'(\n');
% fprintf(fid,'    movingWall\n');
fprintf(fid,'    top\n');
fprintf(fid,'    {\n');
% fprintf(fid,'        type wall;\n');
fprintf(fid,'        type symmetryPlane;\n');
fprintf(fid,'        faces\n');
fprintf(fid,'        (\n');
% fprintf(fid,'            (3 7 6 2)\n');
% if 0
%     id_pause = true;
%     figure(1)
%     clf
%     for ii=1:size(sb.box(4).t,2)
%         id = sb.box(4).t(:,ii)+1;
%         x_id = sb.box(4).p(:,id);
%     % plot(sb.box(1).p(1,ii),sb.box(1).p(2,ii),'o','MarkerSize',6-4)
%     plot(x_id(1,:),x_id(2,:),'-o','MarkerSize',6-4,'Color',rgb('Navy'))
%         if id_pause
%             gcfG;gcfH;gcfLFont;gcfS;%gcfP
%             id_pause = false;
%         end
%     end
% end
    % id_bd = 7;
    % id_bd = 5;
    id_bd = 4;
    for ii=1:sb.box(id_bd).n
        id = sb.box(id_bd).lc(:,ii);
        ids = [id+sb.v.n;id([2,1])];
        % x_id = sb.v.x(:,id);
        fprintf(fid,'            (%d %d %d %d)\n', ids-1 );
    end
fprintf(fid,'        );\n');
fprintf(fid,'    }\n');

if 0
% if 1
    fprintf(fid,'    fixedWalls\n');
    fprintf(fid,'    {\n');
    fprintf(fid,'        type wall;\n');
    % fprintf(fid,'        type symmetryPlane;\n');
    fprintf(fid,'        faces\n');
    fprintf(fid,'        (\n');
    % fprintf(fid,'            (1 5 4 0)\n');
        % for id_bd = 2:6
        % for id_bd = [1 4 5 6]
        for id_bd = 1:4
            for ii=1:sb.box(id_bd).n
                id = sb.box(id_bd).lc(:,ii);
                ids = [id+sb.v.n;id([2,1])];
                % ids = [id;id([2,1])+sb.v.n];
                % x_id = sb.v.x(:,id);
                fprintf(fid,'            (%d %d %d %d)\n', ids-1 );
            end
        end
        fprintf(fid,'        );\n');
        fprintf(fid,'    }\n');
else

    fprintf(fid,'    bottom\n');
    fprintf(fid,'    {\n');
    % fprintf(fid,'        type wall;\n');
    fprintf(fid,'        type symmetryPlane;\n');
    fprintf(fid,'        faces\n');
    fprintf(fid,'        (\n');
    % fprintf(fid,'            (3 7 6 2)\n');
    % if 0
    %     id_pause = true;
    %     figure(1)
    %     clf
    %     for ii=1:size(sb.box(4).t,2)
    %         id = sb.box(4).t(:,ii)+1;
    %         x_id = sb.box(4).p(:,id);
    %     % plot(sb.box(1).p(1,ii),sb.box(1).p(2,ii),'o','MarkerSize',6-4)
    %     plot(x_id(1,:),x_id(2,:),'-o','MarkerSize',6-4,'Color',rgb('Navy'))
    %         if id_pause
    %             gcfG;gcfH;gcfLFont;gcfS;%gcfP
    %             id_pause = false;
    %         end
    %     end
    % end
        id_bd = 3;
        for ii=1:sb.box(id_bd).n
            id = sb.box(id_bd).lc(:,ii);
            ids = [id+sb.v.n;id([2,1])];
            % ids = [id;id([2,1])+sb.v.n];
            % x_id = sb.v.x(:,id);
            fprintf(fid,'            (%d %d %d %d)\n', ids-1 );
        end
    fprintf(fid,'        );\n');
    fprintf(fid,'    }\n');

    fprintf(fid,'    inlet\n');
    fprintf(fid,'    {\n');
    % fprintf(fid,'        type wall;\n');
    fprintf(fid,'        type patch;\n');
    fprintf(fid,'        faces\n');
    fprintf(fid,'        (\n');
    % fprintf(fid,'            (3 7 6 2)\n');
    % if 0
    %     id_pause = true;
    %     figure(1)
    %     clf
    %     for ii=1:size(sb.box(4).t,2)
    %         id = sb.box(4).t(:,ii)+1;
    %         x_id = sb.box(4).p(:,id);
    %     % plot(sb.box(1).p(1,ii),sb.box(1).p(2,ii),'o','MarkerSize',6-4)
    %     plot(x_id(1,:),x_id(2,:),'-o','MarkerSize',6-4,'Color',rgb('Navy'))
    %         if id_pause
    %             gcfG;gcfH;gcfLFont;gcfS;%gcfP
    %             id_pause = false;
    %         end
    %     end
    % end
        id_bd = 1;
        for ii=1:sb.box(id_bd).n
            id = sb.box(id_bd).lc(:,ii);
            ids = [id+sb.v.n;id([2,1])];
            % ids = [id;id([2,1])+sb.v.n];
            % x_id = sb.v.x(:,id);
            fprintf(fid,'            (%d %d %d %d)\n', ids-1 );
        end
    fprintf(fid,'        );\n');
    fprintf(fid,'    }\n');

    fprintf(fid,'    outlet\n');
    fprintf(fid,'    {\n');
    % fprintf(fid,'        type wall;\n');
    fprintf(fid,'        type patch;\n');
    fprintf(fid,'        faces\n');
    fprintf(fid,'        (\n');
    % fprintf(fid,'            (3 7 6 2)\n');
    % if 0
    %     id_pause = true;
    %     figure(1)
    %     clf
    %     for ii=1:size(sb.box(4).t,2)
    %         id = sb.box(4).t(:,ii)+1;
    %         x_id = sb.box(4).p(:,id);
    %     % plot(sb.box(1).p(1,ii),sb.box(1).p(2,ii),'o','MarkerSize',6-4)
    %     plot(x_id(1,:),x_id(2,:),'-o','MarkerSize',6-4,'Color',rgb('Navy'))
    %         if id_pause
    %             gcfG;gcfH;gcfLFont;gcfS;%gcfP
    %             id_pause = false;
    %         end
    %     end
    % end
        id_bd = 2;
        for ii=1:sb.box(id_bd).n
            id = sb.box(id_bd).lc(:,ii);
            ids = [id+sb.v.n;id([2,1])];
            % ids = [id;id([2,1])+sb.v.n];
            % x_id = sb.v.x(:,id);
            fprintf(fid,'            (%d %d %d %d)\n', ids-1 );
        end
    fprintf(fid,'        );\n');
    fprintf(fid,'    }\n');

    fprintf(fid,'    deck\n');
    fprintf(fid,'    {\n');
    fprintf(fid,'        type wall;\n');
    % fprintf(fid,'        type symmetryPlane;\n');
    fprintf(fid,'        faces\n');
    fprintf(fid,'        (\n');
    % fprintf(fid,'            (3 7 6 2)\n');
    % if 0
    %     id_pause = true;
    %     figure(1)
    %     clf
    %     for ii=1:size(sb.box(4).t,2)
    %         id = sb.box(4).t(:,ii)+1;
    %         x_id = sb.box(4).p(:,id);
    %     % plot(sb.box(1).p(1,ii),sb.box(1).p(2,ii),'o','MarkerSize',6-4)
    %     plot(x_id(1,:),x_id(2,:),'-o','MarkerSize',6-4,'Color',rgb('Navy'))
    %         if id_pause
    %             gcfG;gcfH;gcfLFont;gcfS;%gcfP
    %             id_pause = false;
    %         end
    %     end
    % end
        id_bd = 5;
        for ii=1:sb.box(id_bd).n
            id = sb.box(id_bd).lc(:,ii);
            ids = [id+sb.v.n;id([2,1])];
            % ids = [id;id([2,1])+sb.v.n];
            % x_id = sb.v.x(:,id);
            fprintf(fid,'            (%d %d %d %d)\n', ids-1 );
        end
    fprintf(fid,'        );\n');
    fprintf(fid,'    }\n');
end

fprintf(fid,'    frontAndBack\n');
fprintf(fid,'    {\n');
fprintf(fid,'        type empty;\n');
fprintf(fid,'        faces\n');
fprintf(fid,'        (\n');

i_34 = 'b4';
for ii=1:sb.(i_34).n
    lc = sb.(i_34).id(:,ii)-1;
    fprintf(fid,'            (%d %d %d %d)\n', lc([2,1,3,4]) );
    fprintf(fid,'            (%d %d %d %d)\n', lc([1,2,4,3])+sb.v.n );
end
i_34 = 'b3';
for ii=1:sb.(i_34).n
    lc = sb.(i_34).id(:,ii)-1;
    fprintf(fid,'            (%d %d %d %d)\n', lc([2,1,3,3]) );
    fprintf(fid,'            (%d %d %d %d)\n', lc([1,2,3,3])+sb.v.n );
end
fprintf(fid,'        );\n');
fprintf(fid,'    }\n');
fprintf(fid,');\n');
fprintf(fid,'\n');
fprintf(fid,'mergePatchPairs\n');
fprintf(fid,'(\n');
fprintf(fid,');\n');
fprintf(fid,'\n');
fprintf(fid,'// ************************************************************************* //\n');

fclose(fid);

% %% [markdown]
% ### openFoam

% %%
% fid = fopen(sprintf('controlDict_rib_%s.foam',datestr(now,'yymmdd')),'w+');

% %% [markdown]
% ### openFoam

% %% [markdown]
% # Main Process

% %% [markdown]
% # Post Process
% %%
save(sprintf('res_cfd_of_%s_a%s_%s', ...
    s_geo,s_al,datestr(now(),'yymmdd')),'sb','meshdata')

end
end

% %% [markdown]
% # FINE
