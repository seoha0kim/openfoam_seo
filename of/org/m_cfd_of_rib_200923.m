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
%
%%  PART 0.     Opening
%
fclose all; close all
clc
clear all
tcomp = tic;
telap = toc(tcomp);

s_dir = 'git/openfoam_seo/of/org/';

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
cd ~/Work/git/openfoam_seo/wtt/yjn2/

% %%
model = mphload('rib_upper_laminarTa_Re150_of.mph')

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
for ii=1:7
    sb.box(ii) = mpheval(model,'X','selection',sprintf('box%d',ii));
end

% %%
% save imsi_rib_upper_200923 meshdata sb

% %% [markdown]
% ### data load

% %%
whos -file imsi200922
load imsi200922

% %%
meshdata

% %%
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

% %%
c_box1
c_box1.d1(1:3)
c_box1.p(:,1:3)
c_box1.t(:,1:3)
c_box1.ve(1:3,:)

% %% [markdown]
% ### c_box

% %%
id_pause = true;
figure(1)
for ii=1:size(c_box2.t,2)
    id = c_box2.t(:,ii)+1;
    x_id = c_box2.p(:,id);
% plot(c_box1.p(1,ii),c_box1.p(2,ii),'o','MarkerSize',6-4)
plot(x_id(1,:),x_id(2,:),'-o','MarkerSize',6-4,'Color',rgb('Navy'))
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
end
% figure(2)
% plot(c_box2.ve)

% %% [markdown]
% ### sb

% %%
sb.v.n = size(meshdata.vertex,2);
sb.v.x = meshdata.vertex;
sb.b4.n = size(meshdata.elem{2},2);
sb.b4.id = meshdata.elem{2}+1;
sb.b3.n = size(meshdata.elem{3},2);
sb.b3.id = meshdata.elem{3}+1;

% %% [markdown]
% ### triangular

% %%
i_34 = 'b3';
% i_34 = 'b4';
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

% %% [markdown]
% ### quad

% %%
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

% %% [markdown]
% ### Whole

% %%
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

% %% [markdown]
% ### openFoam

% %%
fid = fopen(sprintf('blockMeshDict_rid_%s.foam',datestr(now,'yymmdd')),'w+');

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

% for ii=1:size(meshdata.vertex,2)
for ii=1:2^4
    fprintf(fid,'(%f %f 0)\n',meshdata.vertex(:,ii) );
    % fprintf(fid,'(%.56f %.56f)\n',meshdata.vertex(:,ii) );
end

for ii=1:2^4
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




% %% [markdown]
% # Main Process

% %% [markdown]
% # Post Process

% %% [markdown]
% # FINE
