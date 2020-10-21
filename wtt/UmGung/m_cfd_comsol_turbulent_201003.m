% %%
% Model exported on Sep 16 2020, 18:03 by COMSOL 5.5.0.359.
function [model,sb] = m_cfd_comsol_turbulent_201003(varargin)

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
% # YJN2: rib

% %% [markdown]
% Saang Bum Kim <br>
% 2020-07-01 17:50

% %%
% !comsol mphserver -silent &

% %%
%
%%  PART 0.     Opening
%
% fclose all; close all
% clc
% clear all
tcomp = tic;
telap = toc(tcomp);

s_dir = 'git/openfoam_seo/wtt/UmGung/';

p_comsol = 2036;
seo_init

id_f = 1;
% id_sv = true;
id_sv = false;
% id_pl = true;
id_pl = false;

% %%
    id_narrow = true;
    id_geo = 1;

% %%
    optargs = {id_geo, id_narrow};

    % only want 1 optional inputs at most
        numvarargs = length(varargin);
        if numvarargs > length(optargs)
            error('myfuns:somefun2Alt:TooManyInputs', ...
                sprintf('requires at most %d optional inputs',length(optargs)));
        end

    % now put these defaults into the valuesToUse cell array,
    % and overwrite the ones specified in varargin.
        % optargs(1:numvarargs) = varargin;
        % or ...
        % [optargs{1:numvarargs}] = varargin{:};
        % id = find(~isempty(varargin));
        id = cellfun(@(x)~isempty(x), varargin);
        optargs(id) = varargin(id);

    % Place optional args in memorable variable names
        [id_geo, id_narrow] = optargs{:};

% %% [markdown]
% # Smilarity

% %% [markdown]
% ## Blockage ratio

% %% [markdown]
% $$\mathrm{
% % \begin{empheq}[left=\empheqlbrace]{align}
% \left\{
% \begin{aligned}\mathrm{
%  < 3 - 5 \% : recommended \\
%  < 10 \% : Dr. Kwon, Dae \, Kun \\
%  > 10 \% : correction}
% \end{aligned}
% \right.
% % \end{empheq}
% }$$

% %% [markdown]
% ## Small wind tunnel for 2d section models

% %% [markdown]
% - Wind.wtt.s.B = 4.5 m = 1.5 + 3
% - Wind.wtt.s.D = 1.5 m
%   - 5% = 0.15/2 = 0.075
%   - 3% = 0.015*3 = 0.045
%   - 2% = 0.015*2 = 0.03
% - Wind.wtt.s.d = .04 m

% %% [markdown]
% ## Reynold Number

% %% [markdown]
% ### Geometry

% %%

% deck
% [Oct 5, 2020 5:05 PM] Distance: 0.4 [m], (0.4, 0) [m].  Point 1 (imp2(2)) to 3 (imp2(2)).
% Average coordinates: (880.6135465, 65.00383976) [m].  Points: 1, 3 (imp2(2)).
% fence
% [Oct 5, 2020 5:06 PM] Distance: 1.29096516 [m], (-0.3226314382, -1.25) [m].
% Point 34 (imp2(1)) to 1 (imp2(2)).
% Average coordinates: (880.5748622, 65.62883976) [m].  Points: 34 (imp2(1)); 1 (imp2(2)).

% [Oct 5, 2020 5:07 PM] Average coordinates: (11169.06529, 9789.834377) [m].
% Points: 1, 11 (imp1(2)); 34 (imp2(1)); 1 (imp2(2)).
% [Oct 5, 2020 5:07 PM] Average coordinates: (9751.135286, 9489.659377) [m].
% Points: 5 (imp1(2)); 34 (imp2(1)); 1 (imp2(2)); 11 (imp1(1)).

% %%
% sb.geo.id = 1;

% for id_geo = 1:2
% for id_al = 1:3
for id_geo = 1
% for id_al = 3
% for id_al = 4:5
for id_al = 1
% for id_al = 1:3

switch id_al
    case 1
        sb.alpha = 0;
        sb.s_al = '000';
    case 2
        sb.alpha = -2.5;
        sb.s_al = 'm25';
    case 3
        sb.alpha = 2.5;
        sb.s_al = 'p25';
    case 4
        sb.alpha = -5;
        sb.s_al = 'm50';
    case 5
        sb.alpha = 5;
        sb.s_al = 'p50';
end

sb.geo.id = id_geo;

switch sb.geo.id
    case 1
        sb.s_geo = 'upper';
        % sb.alpha = 0;

% deck

% [Oct 8, 2020 3:52 PM] Distance: 27.97 [m], (27.97, 0) [m].  Point 9 (sca1) to 329 (sca1).
% Average coordinates: (164.7070639, 18.861) [m].  Points: 9, 329 (sca1).
% [Oct 8, 2020 3:54 PM] Distance: 9.723908679 [m], (8.62, 4.5) [m].  Point 85 (sca1) to 121 (sca1).
% Average coordinates: (160.3920639, 17.45) [m].  Points: 85, 121 (sca1).

% %%

% maximize B
sb.geo.x_c = 164.7070639;
sb.geo.B = 27.97;

% centering
sb.geo.y_c = 17.45 - 4.5/2 + 2.66;
sb.geo.D = 4.5;

% centering
% sb.geo.x_c_fence = 880.6135465;
% sb.geo.y_c_fence = 65.00383976;

% sb.geo.x_c_fence = 880.6135465 - 6.799999711;
% sb.geo.y_c_fence = 65.00383976 - 1.577699914;

% sb.geo.x_c_fence2 = 6.799999711;
% sb.geo.y_c_fence2 = 1.577699914 + 0.04949992841;

    case 2
        fprintf('Error: geo.id == 2')
    % otherwise
end

% %%
% 0.045*sc = 4.5
sb.scale = 4.5/0.045;
fprintf('Scale = %f\n',sb.scale);

% %%
sb.B = sb.geo.B/sb.scale;
sb.D = sb.geo.D/sb.scale;

fprintf('B_ori = %f, D_ori = %f\n',sb.geo.B,sb.geo.D);
fprintf('B = %f, D = %f\n',sb.B,sb.D);

% %%
% sb.narrow = true;
sb.narrow = id_narrow;

% %% [markdown]
% $$\mathrm{
% \mathfrak{R\!\:\!e} = \frac{\rho \, U \, D}{\mu} \\
% \mathfrak{S\!\:\!t} = \frac{f \, D}{U}
% }$$

% %%
Wind = m_wind;
sb.Re = 150;
% Wind.air.mu(273.15+15)
% Wind.air.rho(101325, 273.15+15)
sb.U = @(rey_n) (rey_n * Wind.air.mu(273.15+15) / Wind.air.rho(101325, 273.15+15) / sb.B);
% sb.U(sb.Re)
sb.T_viv = @(rey_n) sb.B / sb.U(rey_n) / 0.2;
% sb.T_viv(sb.Re)

% %%
sb.Re_target = Wind.air.rho(101325, 273.15+15) * 40 * sb.B / Wind.air.mu(273.15+15);
fprintf('Target Reynolds number = %e.\n',sb.Re_target)
fprintf('Wind speed = %e [m/s], Period for vortex shedding = %e [s].\n', ...
    sb.U(sb.Re_target),sb.T_viv(sb.Re_target))
fprintf('Start Reynolds number = %e.\n',sb.Re)
fprintf('Wind speed = %e [m/s], Period for vortex shedding = %e [s].\n', ...
    sb.U(sb.Re),sb.T_viv(sb.Re))

% %%
sb.Re_pool = [150, 1e3, 1e4, 1e5, 2e5];
sb.Re_n = length(sb.Re_pool);

% %% [markdown]
% # Turbulent model

% %% [markdown]
% - $k - \epsilon$: start
% - $k - \epsilon$

% %% [markdown]
% - y+ (wall lift off inviscous units) in a Low reynolds k-ep

% %% [markdown]
% # Parameter Setting

% %%
% wtt.

% %% [markdown]
% # Laminar

% %%
%
%%  PART II.    COMSOL
%
%
% cfd_2d_laminar_00.m
%
% Model exported on Sep 16 2020, 09:04 by COMSOL 5.5.0.359.
if 1
% if 0

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/UmGung/');

model.param.set('seo_U_in', sprintf('%f[m/s]',sb.U(150)));
model.param.set('seo_B', sprintf('%f[m]',sb.B));
model.param.set('seo_D', sprintf('%f[m]',sb.D));

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

% model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');
model.component('comp1').physics.create('spf', 'TurbulentFlowkeps', 'geom1');

model.study.create('std1');
% model.study('std1').create('stat', 'Stationary');
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('spf', true);

% %%
% mphsave(model,'deck_imsi')

% %%
% model.component('comp1').geom('geom1').create('imp1', 'Import');
% model.component('comp1').geom('geom1').feature('imp1').set('filename', ...
    % '/home/sbkim/Work/git/openfoam_seo/wtt/yjn2/yjn2_cfd_deck_200915.dxf');
% model.component('comp1').geom('geom1').runPre('fin');

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('type', 'dxf');
% model.component('comp1').geom('geom1').feature('imp1').set('filename', ...
    % '/home/sbkim/Work/git/openfoam_seo/wtt/yjn2/yjn2_cfd_deck_200915.dxf');
% model.component('comp1').geom('geom1').feature('imp1').set('alllayers', ...
    % {'CS-DIML' 'CS-STEL-MAJR' 'dummy' '0' 'CENTER' 'CZ-SYMB' '3' '19 ' '1_CR-DEGN' '1'  ...
% '7' '6' ''});
% model.component('comp1').geom('geom1').feature('imp1').set('filename', ...
%     '~/Work/git/openfoam_seo/wtt/jbk/dxf/pylon_cfd.dxf');
% '/home/sbkim/2266B8F966B8CEB3/git/openfoam_seo/wtt/jbk/dxf/pylon_cfd.dxf');
% model.component('comp1').geom('geom1').feature('imp1').set('filename', ...
%     'H:\git\openfoam_seo\wtt\jbk\dxf\pylon_cfd.dxf');
model.component('comp1').geom('geom1').feature('imp1').set('filename', ...
    'dxf/deck_cfd.dxf');
    % '../dxf/deck_cfd_simplified.dxf');

% if 1
if 0
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'solid');
elseif 0
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'curve');
else
model.component('comp1').geom('geom1').feature('imp1').set('knit', false);
model.component('comp1').geom('geom1').feature('imp1').set('repairgeom', false);
end
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
% model.component('comp1').geom('geom1').feature('csol1').selection('input').set({ ...
    % 'imp1(2)' 'imp1(3)' 'imp1(4)' 'imp1(5)'});
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'imp1'});
% model.component('comp1').geom('geom1').feature('imp1').set('alllayers', {'DIM' '0'});

% %%
model.component('comp1').geom('geom1').create('sca1', 'Scale');
model.component('comp1').geom('geom1').feature('sca1').set('factor', '1e-3');
% model.component('comp1').geom('geom1').feature('sca1').selection('input').set({'del1(1)' 'del1(2)'});
model.component('comp1').geom('geom1').feature('sca1').selection('input').set({'csol1'});

model.component('comp1').geom('geom1').create('mov1', 'Move');
model.component('comp1').geom('geom1').feature('mov1').setIndex('displx', ...
    sprintf('-%f',sb.geo.x_c), 0);
model.component('comp1').geom('geom1').feature('mov1').setIndex('disply', ...
    sprintf('-%f',sb.geo.y_c), 0);
model.component('comp1').geom('geom1').feature('mov1').selection('input').set({'sca1'});

if 0
model.component('comp1').geom('geom1').create('imp2', 'Import');
model.component('comp1').geom('geom1').feature('imp2').set('type', 'dxf');
model.component('comp1').geom('geom1').feature('imp2').set('filename', ...
    '../dxf/fence_cfd.dxf');
    % '/home/sbkim/Work/git/openfoam_seo/wtt/jbk/dxf/fence_cfd.dxf');

model.component('comp1').geom('geom1').create('mov2', 'Move');
model.component('comp1').geom('geom1').feature('mov2').setIndex('displx', ...
    sprintf('-%f',sb.geo.x_c_fence), 0);
model.component('comp1').geom('geom1').feature('mov2').setIndex('disply', ...
    sprintf('-%f',sb.geo.y_c_fence), 0);
model.component('comp1').geom('geom1').feature('mov2').selection('input').set({'imp2'});

model.component('comp1').geom('geom1').create('mir1', 'Mirror');
model.component('comp1').geom('geom1').feature('mir1').selection('input').set({'mov2(1)'});

model.component('comp1').geom('geom1').create('mov3', 'Move');
model.component('comp1').geom('geom1').feature('mov3').selection('input').set({'mir1' 'mov2(2)'});
model.component('comp1').geom('geom1').feature('mov3').set('displx', sb.geo.x_c_fence2);
model.component('comp1').geom('geom1').feature('mov3').set('disply', sb.geo.y_c_fence2);

model.component('comp1').geom('geom1').measure.selection.init;
model.component('comp1').geom('geom1').measure.selection.set({'mov1(1)' 'mov3(1)' 'mov3(2)'});

% %%
% model.component('comp1').geom('geom1').create('del1', 'Delete');
% % model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1', [7 8 9 10 19 20]);
% model.component('comp1').geom('geom1').feature('del1').selection('input').init(2);
% switch id_geo
%     case 1
%         model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1', ...
%             [1 3 4 5 6 7 8 12 13 14 18 19 20 21 22 23 25]);
%     case 2
%         model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1', ...
%             [2 9 10 11 15 16 17 24 26 27 28 29 30 31]);
%     % otherwise
% end

% model.component('comp1').geom('geom1').run('del1');

% model.component('comp1').geom('geom1').measure.selection.init(2);
% model.component('comp1').geom('geom1').measure.selection.all('del1(1)');

% model.component('comp1').geom('geom1').measure.selection.init(0);
% model.component('comp1').geom('geom1').measure.selection.set('del1', [1 32]);
end

% out = model;

% %%
model.component('comp1').geom('geom1').create('sca2', 'Scale');
model.component('comp1').geom('geom1').feature('sca2').set('factor', sprintf('1/%d',sb.scale));
% model.component('comp1').geom('geom1').feature('sca2').set('isotropic', '1/100');
% model.component('comp1').geom('geom1').feature('sca2').selection('input').set({'mov1' 'mov3'});
model.component('comp1').geom('geom1').feature('sca2').selection('input').set({'mov1'});

model.component('comp1').geom('geom1').create('mir2', 'Mirror');
model.component('comp1').geom('geom1').feature('mir2').selection('input').set({'sca2'});
model.component('comp1').geom('geom1').feature('mir2').set('pos', [0 0.1]);

model.component('comp1').geom('geom1').create('rot2', 'Rotate');
% model.component('comp1').geom('geom1').feature('rot2').selection('input').set({'sca2'});
model.component('comp1').geom('geom1').feature('rot2').selection('input').set({'mir2'});
model.component('comp1').geom('geom1').feature('rot2').set('rot', sb.alpha);

model.component('comp1').geom('geom1').create('r1', 'Rectangle');
if sb.narrow
    model.component('comp1').geom('geom1').feature('r1').set('pos', {'-1.5/2' '-1.5/2'});
    model.component('comp1').geom('geom1').feature('r1').set('size', [4.5-2 1.5]);
else
    model.component('comp1').geom('geom1').feature('r1').set('pos', {'-1.5' '-1.5/2'});
    model.component('comp1').geom('geom1').feature('r1').set('size', [4.5 1.5]);
end
model.component('comp1').geom('geom1').create('c1', 'Circle');
% model.component('comp1').geom('geom1').feature('c1').set('pos', {'0' '.02'});
model.component('comp1').geom('geom1').feature('c1').set('pos', {'0' '.02*0'});
model.component('comp1').geom('geom1').feature('c1').set('r', 0.2);
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('pos', [-0.5 -0.5]);
model.component('comp1').geom('geom1').feature('r2').set('size', [2 1]);
model.component('comp1').geom('geom1').create('r3', 'Rectangle');
model.component('comp1').geom('geom1').feature('r3').set('pos', {'-.75/2' '-.75/2'});
model.component('comp1').geom('geom1').feature('r3').set('size', [1 0.75]);

% %%
% mphsave(model,'deck_imsi')

% %%
model.component('comp1').geom('geom1').create('co1', 'Compose');
% model.component('comp1').geom('geom1').feature('co1').set('formula', '(r1+c1+r2+r3)-(mir1(1)+mir1(2))');
% model.component('comp1').geom('geom1').feature('co1').selection('input').set({'r1' 'c1' 'r2' 'r3' 'mir1(1)' 'mir1(2)'});
% model.component('comp1').geom('geom1').feature('co1').set('formula', '(r1+c1+r2+r3)-(mir1)');
% model.component('comp1').geom('geom1').feature('co1').selection('input').set({'r1' 'c1' 'r2' 'r3' 'mir1'});

% mphsave(model,'deck_imsi')

if 0
model.component('comp1').geom('geom1').feature('co1').set('formula', ...
    '(r1+c1+r2+r3)-(rot2(1)+rot2(2)+rot2(3))');
model.component('comp1').geom('geom1').feature('co1').selection('input').set( ...
    {'r1' 'c1' 'r2' 'r3' 'rot2(1)' 'rot2(2)' 'rot2(3)'});
else
model.component('comp1').geom('geom1').feature('co1').set('formula', ...
    '(r1+c1+r2+r3)-(rot2)');
model.component('comp1').geom('geom1').feature('co1').selection('input').set( ...
    {'r1' 'c1' 'r2' 'r3' 'rot2'});
end

model.component('comp1').geom('geom1').run;

% %% [markdown]
% ## material

% %%
model.component('comp1').material.create('mat1', 'Common');

% %%
model.component('comp1').material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('cs', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('an1', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('an2', 'Analytic');
model.component('comp1').material('mat1').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.component('comp1').material('mat1').propertyGroup.create('NonlinearModel', 'Nonlinear model');

% %%
model.component('comp1').material('mat1').label('Air');
model.component('comp1').material('mat1').set('family', 'air');

model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('fununit', 'Pa*s');

model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('fununit', 'J/(kg*K)');

model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/R_const[K*mol/J]/T');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/R_const/T,pA)'; 'T' 'd(pA*0.02897/R_const/T,T)'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('argunit', 'Pa,K');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('fununit', 'kg/m^3');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('plotargs', {'pA' '0' '1'; 'T' '0' '1'});

model.component('comp1').material('mat1').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('fununit', 'W/(m*K)');

model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*R_const[K*mol/J]/0.02897*T)');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('args', {'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('fununit', 'm/s');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('plotargs', {'T' '273.15' '373.15'});

model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('funcname', 'alpha_p');
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('expr', '-1/rho(pA,T)*d(rho(pA,T),T)');
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('args', {'pA' 'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('argunit', 'Pa,K');
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('fununit', '1/K');
model.component('comp1').material('mat1').propertyGroup('def').func('an1').set('plotargs', {'pA' '101325' '101325'; 'T' '273.15' '373.15'});

model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('funcname', 'muB');
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('expr', '0.6*eta(T)');
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('args', {'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('argunit', 'K');
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('fununit', 'Pa*s');
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('plotargs', {'T' '200' '1600'});

model.component('comp1').material('mat1').propertyGroup('def').set('thermalexpansioncoefficient', '');
model.component('comp1').material('mat1').propertyGroup('def').set('molarmass', '');
model.component('comp1').material('mat1').propertyGroup('def').set('bulkviscosity', '');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalexpansioncoefficient', {'alpha_p(pA,T)' '0' '0' '0' 'alpha_p(pA,T)' '0' '0' '0' 'alpha_p(pA,T)'});
model.component('comp1').material('mat1').propertyGroup('def').set('molarmass', '0.02897[kg/mol]');
model.component('comp1').material('mat1').propertyGroup('def').set('bulkviscosity', 'muB(T)');

model.component('comp1').material('mat1').propertyGroup('def').descr('thermalexpansioncoefficient_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').descr('molarmass_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').descr('bulkviscosity_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').descr('relpermeability_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').descr('relpermittivity_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T)');
model.component('comp1').material('mat1').propertyGroup('def').descr('dynamicviscosity_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.component('comp1').material('mat1').propertyGroup('def').descr('ratioofspecificheat_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'0[S/m]' '0' '0' '0' '0[S/m]' '0' '0' '0' '0[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').descr('electricconductivity_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T)');
model.component('comp1').material('mat1').propertyGroup('def').descr('heatcapacity_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('density', 'rho(pA,T)');
model.component('comp1').material('mat1').propertyGroup('def').descr('density_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k(T)' '0' '0' '0' 'k(T)' '0' '0' '0' 'k(T)'});
model.component('comp1').material('mat1').propertyGroup('def').descr('thermalconductivity_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').set('soundspeed', 'cs(T)');
model.component('comp1').material('mat1').propertyGroup('def').descr('soundspeed_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat1').propertyGroup('def').addInput('pressure');

model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').descr('n_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').descr('ki_symmetry', '');

model.component('comp1').material('mat1').propertyGroup('NonlinearModel').set('BA', '(def.gamma+1)/2');
model.component('comp1').material('mat1').propertyGroup('NonlinearModel').descr('BA_symmetry', '');

% %% [markdown]
% ## physics

% %%
model.component('comp1').selection.create('box1', 'Box');
model.component('comp1').selection('box1').set('entitydim', 1);
model.component('comp1').selection('box1').set('xmin', -1.6);
model.component('comp1').selection('box1').set('xmax', -1.4);
model.component('comp1').selection('box1').set('ymin', -1);
model.component('comp1').selection('box1').set('ymax', 1);
model.component('comp1').selection('box1').set('condition', 'inside');
% model.component('comp1').selection('box1').set('condition', 'allvertices');
% mphviewselection(model,'box1')

model.component('comp1').selection.create('box2', 'Box');
model.component('comp1').selection('box2').set('entitydim', 1);
model.component('comp1').selection('box2').set('xmin', 2.9);
model.component('comp1').selection('box2').set('xmax', 3.1);
model.component('comp1').selection('box2').set('ymin', -1);
model.component('comp1').selection('box2').set('ymax', 1);
model.component('comp1').selection('box2').set('condition', 'inside');
% mphviewselection(model,'box2')

if sb.narrow
model.component('comp1').selection('box1').set('xmin', -.8);
model.component('comp1').selection('box1').set('xmax', -.7);
model.component('comp1').selection('box2').set('xmin', 1.7);
model.component('comp1').selection('box2').set('xmax', 1.8);
end

model.component('comp1').selection.create('box3', 'Box');
model.component('comp1').selection('box3').set('entitydim', 1);
model.component('comp1').selection('box3').set('xmin', -1.6);
model.component('comp1').selection('box3').set('xmax', 3.1);
model.component('comp1').selection('box3').set('ymin', -.8);
model.component('comp1').selection('box3').set('ymax', -.7);
model.component('comp1').selection('box3').set('condition', 'inside');
% mphviewselection(model,'box3')

model.component('comp1').selection.create('box4', 'Box');
model.component('comp1').selection('box4').set('entitydim', 1);
model.component('comp1').selection('box4').set('xmin', -1.6);
model.component('comp1').selection('box4').set('xmax', 3.1);
model.component('comp1').selection('box4').set('ymin', .7);
model.component('comp1').selection('box4').set('ymax', .8);
model.component('comp1').selection('box4').set('condition', 'inside');

% %%
model.component('comp1').selection.create('box5', 'Box');
model.component('comp1').selection('box5').set('entitydim', 1);
model.component('comp1').selection('box5').set('xmin', -0.15);
model.component('comp1').selection('box5').set('xmax', 0.15);
model.component('comp1').selection('box5').set('ymin', -0.1);
model.component('comp1').selection('box5').set('ymax', 0.12);

model.component('comp1').selection.create('box6', 'Box');
model.component('comp1').selection('box6').set('entitydim', 1);
model.component('comp1').selection('box6').set('xmin', -0.15);
model.component('comp1').selection('box6').set('xmax', 0);
model.component('comp1').selection('box6').set('ymin', -0.1);
model.component('comp1').selection('box6').set('ymax', 0.12);

model.component('comp1').selection.create('box7', 'Box');
model.component('comp1').selection('box7').set('entitydim', 1);
model.component('comp1').selection('box7').set('xmin', 0);
model.component('comp1').selection('box7').set('xmax', 0.15);
model.component('comp1').selection('box7').set('ymin', -0.1);
model.component('comp1').selection('box7').set('ymax', 0.12);

% mphviewselection(model,'box4')

% model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');

% %%
model.component('comp1').physics('spf').create('inl1', 'InletBoundary', 1);
% model.component('comp1').physics('spf').feature('inl1').selection.set([1]);
model.component('comp1').physics('spf').feature('inl1').selection.named('box1');
model.component('comp1').physics('spf').create('out1', 'OutletBoundary', 1);
% model.component('comp1').physics('spf').feature('out1').selection.set([229]);
% model.component('comp1').physics('spf').feature('out1').selection.set([36]);
model.component('comp1').physics('spf').feature('out1').selection.named('box2');
model.component('comp1').physics('spf').create('sym1', 'Symmetry', 1);
% model.component('comp1').physics('spf').feature('sym1').selection.set([2 3]);
model.component('comp1').physics('spf').feature('sym1').selection.named('box3');
model.component('comp1').physics('spf').create('sym2', 'Symmetry', 1);
model.component('comp1').physics('spf').feature('sym2').selection.named('box4');

% %%
% sb.U_in = sb.U(150);

% %%
% model.component('comp1').physics('spf').prop('PhysicalModelProperty').set('IncludeGravity', true);
model.component('comp1').physics('spf').feature('inl1').set('U0in', 'seo_U_in');
% model.component('comp1').physics('spf').feature('inl1').set('U0in', sb.U_in);
% model.component('comp1').physics('spf').feature('inl1').set('U0in', sb.U(150));

% %% [markdown]
% ## mesh

% %%
model.component('comp1').mesh('mesh1').create('bl1', 'BndLayer');
model.component('comp1').mesh('mesh1').create('fq2', 'FreeQuad');
model.component('comp1').mesh('mesh1').create('fq3', 'FreeQuad');
model.component('comp1').mesh('mesh1').create('fq1', 'FreeQuad');

% %%
model.component('comp1').mesh('mesh1').feature('bl1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('bl1').selection.set([4]);
model.component('comp1').mesh('mesh1').feature('bl1').create('blp', 'BndLayerProp');
% model.component('comp1').mesh('mesh1').feature('bl1').feature('blp').selection.set([10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341]);

% %%
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp').selection.named('box5');

model.component('comp1').mesh('mesh1').feature('fq2').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('fq2').selection.set([3]);
model.component('comp1').mesh('mesh1').feature('fq2').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('fq2').feature('size1').set('table', 'cfd');

model.component('comp1').mesh('mesh1').feature('fq3').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('fq3').selection.set([2]);
model.component('comp1').mesh('mesh1').feature('fq3').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('fq3').feature('size1').set('table', 'cfd');

model.component('comp1').mesh('mesh1').feature('fq1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('fq1').selection.set([1]);
model.component('comp1').mesh('mesh1').feature('fq1').create('size1', 'Size');
model.component('comp1').mesh('mesh1').feature('fq1').feature('size1').set('table', 'cfd');

% mphsave(model,'deck_imsi')

% %%
model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
% model.component('comp1').mesh('mesh1').feature('size').set('hauto', 3);
% model.component('comp1').mesh('mesh1').feature('size').set('hauto', 2);
switch sb.geo.id
    case 1
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 1);
    case 2
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 3);
end
model.component('comp1').mesh('mesh1').feature('fq2').feature('size1').set('hauto', 5);
model.component('comp1').mesh('mesh1').feature('fq3').feature('size1').set('hauto', 9);
model.component('comp1').mesh('mesh1').feature('fq1').feature('size1').set('hauto', 9);

model.component('comp1').mesh('mesh1').run;

% %% [markdown]
% ## Study

% %%
% model.param.set('seo_U_in', sprintf('%f[m/s]',sb.U(150)));
% model.component('comp1').physics('spf').feature('inl1').set('U0in', sb.U_in);

if 0
model.component('comp1').probe.create('bnd1', 'Boundary');
model.component('comp1').probe('bnd1').set('intsurface', true);
model.component('comp1').probe('bnd1').selection.named('box5');
model.component('comp1').probe('bnd1').set('expr', '-spf.T_stressx/(1/2*spf.rho*(seo_U_in^2)*seo_B)');

model.component('comp1').probe.create('bnd2', 'Boundary');
model.component('comp1').probe('bnd2').set('intsurface', true);
model.component('comp1').probe('bnd2').selection.named('box5');
model.component('comp1').probe('bnd2').set('expr', '-spf.T_stressy/(1/2*spf.rho*(seo_U_in^2)*seo_B)');

model.component('comp1').probe.create('bnd3', 'Boundary');
model.component('comp1').probe('bnd3').set('intsurface', true);
model.component('comp1').probe('bnd3').selection.named('box5');
model.component('comp1').probe('bnd3').set('expr', ...
    '(-spf.T_stressx*y + -spf.T_stressy*-x)/(1/2*spf.rho*(seo_U_in^2)*(seo_B^2))');
end

% model.sol.create('sol1');
% model.sol('sol1').study('std1');

model.study.create('std2');
model.study('std2').create('stat', 'Stationary');
model.study('std2').feature('stat').activate('spf', true);
model.study.remove('std1');

model.sol.create('sol1');
model.sol('sol1').study('std2');

model.study('std2').feature('stat').set('notlistsolnum', 1);
model.study('std2').feature('stat').set('notsolnum', '1');
model.study('std2').feature('stat').set('listsolnum', 1);
model.study('std2').feature('stat').set('solnum', '1');

model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std2');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('se1', 'Segregated');
model.sol('sol1').feature('s1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('s1').feature('se1').create('ss1', 'SegregatedStep');
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('segvar', {'comp1_u' 'comp1_p'});
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('subdamp', 0.5);
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('d1').label('Direct, fluid flow variables (spf)');
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('s1').feature('se1').feature('ss1').label('Velocity u, Pressure p');
model.sol('sol1').feature('s1').feature('se1').create('ss2', 'SegregatedStep');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('segvar', {'comp1_k' 'comp1_ep'});
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subdamp', 0.35);
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subiter', 3);
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subtermconst', 'itertol');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subntolfact', 1);
model.sol('sol1').feature('s1').create('d2', 'Direct');
model.sol('sol1').feature('s1').feature('d2').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d2').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('d2').label('Direct, turbulence variables (spf)');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('linsolver', 'd2');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').label('Turbulence variables');
model.sol('sol1').feature('s1').feature('se1').set('segstabacc', 'segcflcmp');
model.sol('sol1').feature('s1').feature('se1').set('subinitcfl', 3);
model.sol('sol1').feature('s1').feature('se1').set('subkppid', 0.65);
model.sol('sol1').feature('s1').feature('se1').set('subkdpid', 0.05);
model.sol('sol1').feature('s1').feature('se1').set('subkipid', 0.05);
model.sol('sol1').feature('s1').feature('se1').set('subcfltol', 0.1);
model.sol('sol1').feature('s1').feature('se1').set('maxsegiter', 300);
model.sol('sol1').feature('s1').feature('se1').create('ll1', 'LowerLimit');
model.sol('sol1').feature('s1').feature('se1').feature('ll1').set('lowerlimit', 'comp1.k 0 comp1.ep 0 ');
model.sol('sol1').feature('s1').create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('s1').feature('i1').set('prefuntype', 'left');
model.sol('sol1').feature('s1').feature('i1').set('itrestart', 50);
model.sol('sol1').feature('s1').feature('i1').set('rhob', 20);
model.sol('sol1').feature('s1').feature('i1').set('maxlinit', 200);
model.sol('sol1').feature('s1').feature('i1').set('nlinnormuse', 'on');
model.sol('sol1').feature('s1').feature('i1').label('AMG, fluid flow variables (spf)');
model.sol('sol1').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('prefun', 'saamg');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('mgcycle', 'v');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('maxcoarsedof', 80000);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('strconn', 0.02);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('usesmooth', false);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').set('saamgcompwise', true);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').create('sc1', 'SCGS');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('iter', 0);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('seconditer', 1);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('relax', 0.5);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').create('sc1', 'SCGS');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sc1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sc1').set('seconditer', 1);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sc1').set('relax', 0.5);
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').create('i2', 'Iterative');
model.sol('sol1').feature('s1').feature('i2').set('linsolver', 'gmres');
model.sol('sol1').feature('s1').feature('i2').set('prefuntype', 'left');
model.sol('sol1').feature('s1').feature('i2').set('itrestart', 50);
model.sol('sol1').feature('s1').feature('i2').set('rhob', 20);
model.sol('sol1').feature('s1').feature('i2').set('maxlinit', 200);
model.sol('sol1').feature('s1').feature('i2').set('nlinnormuse', 'on');
model.sol('sol1').feature('s1').feature('i2').label('AMG, turbulence variables (spf)');
model.sol('sol1').feature('s1').feature('i2').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('prefun', 'saamg');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('mgcycle', 'v');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('strconn', 0.01);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('usesmooth', false);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('saamgcompwise', true);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linerelax', 0.7);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('iter', 0);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('seconditer', 1);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('relax', 0.5);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('linerelax', 0.7);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('seconditer', 1);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('relax', 0.5);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std2');

% model.result.dataset('dset1').set('geom', 'geom1');

% model.result.dataset.create('edg1', 'Edge2D');
% model.result.dataset('edg1').label('Exterior Walls');
% model.result.dataset('edg1').set('data', 'dset1');
% model.result.dataset('edg1').selection.geom('geom1', 1);
% model.result.dataset('edg1').selection.set([10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33]);
% model.result.dataset('edg1').selection.inherit(false);

% %%
id_pause = true;
figure(1)
clf

telap = toc(tcomp);
% for ii=1:length(sb.Re_pool)
    ii = 4;
    model = mphload(sprintf('deck0_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re))
    load(sprintf('deck0_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re),'sb')
for ii=length(sb.Re_pool)

    sb.Re = sb.Re_pool(ii);

    % model.param.set('seo_U_in', sprintf('%f[m/s]',sb.U(150)));
    model.param.set('seo_U_in', sprintf('%f[m/s]',sb.U( sb.Re )));
    model.component('comp1').physics('spf').feature('inl1').set('U0in', 'seo_U_in');

    mphsave(model,sprintf('deck0_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re))
    save(sprintf('deck0_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re),'sb')

    model.sol('sol1').runAll;

    mphsave(model,sprintf('deck1_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re))
    save(sprintf('deck1_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re),'sb')

    sb.res(ii).C = s_cfd_comsol_DLM(model, sb, 'spf', 'dset1', 1);

    % sb.DLM(ii,1) = mphglobal(model,'bnd1');
    % sb.DLM(ii,2) = mphglobal(model,'bnd2');
    % sb.DLM(ii,3) = mphglobal(model,'bnd3');

    % figure(1)
    % for jj = 1:3
    %     subplot(1,3,jj)
    %     plot(sb.Re, sb.DLM(ii,jj),'o','Color',rgb('Navy'))
    % end
    % if id_pause
    %     gcfG;gcfH;gcfLFont;gcfS;%gcfP
    %     id_pause = false;
    % end

    % mphsave(model,sprintf('deck_lower_turbulent_Re%d',sb.Re))
    mphsave(model,sprintf('deck_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re))
    save(sprintf('deck_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re),'sb')

    telap = toc(tcomp) - telap;
    fprintf('Total elapsed time = %.3f s.\n',telap)
end

else
    sb.Re_n = length(sb.Re_pool);
    sb.Re = sb.Re_pool(sb.Re_n);

    model = mphload(sprintf('deck_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re));
    sb0 = load(sprintf('deck_%s_a%s_turbulent_Re%d', sb.s_geo, sb.s_al, sb.Re));
    sb = sb0.sb; clear sb0
    sb.Re_n = length(sb.Re_pool);
end

% if 0
% %% [markdown]
% ## SST

% %%
model.component('comp1').physics.create('spf2', 'TurbulentFlowSST', 'geom1');

model.study.create('std1');
model.study('std1').create('wdi', 'WallDistanceInitialization');
model.study('std1').feature('wdi').set('solnum', 'auto');
model.study('std1').feature('wdi').set('notsolnum', 'auto');
model.study('std1').feature('wdi').set('ngen', '5');
model.study('std1').feature('wdi').activate('spf', true);
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').set('solnum', 'auto');
model.study('std1').feature('stat').set('notsolnum', 'auto');
model.study('std1').feature('stat').set('ngen', '5');
model.study('std1').feature('stat').activate('spf2', true);

model.component('comp1').physics('spf2').create('inl1', 'InletBoundary', 1);
model.component('comp1').physics('spf2').feature('inl1').selection.named('box1');
model.component('comp1').physics('spf2').feature('inl1').set('U0in', 'seo_U_in');
model.component('comp1').physics('spf2').create('out1', 'OutletBoundary', 1);
model.component('comp1').physics('spf2').feature('out1').selection.named('box2');
model.component('comp1').physics('spf2').create('sym1', 'Symmetry', 1);
model.component('comp1').physics('spf2').feature('sym1').selection.named('box3');
model.component('comp1').physics('spf2').create('sym2', 'Symmetry', 1);
model.component('comp1').physics('spf2').feature('sym2').selection.named('box4');

if 0
model.component('comp1').probe.create('bnd4', 'Boundary');
model.component('comp1').probe('bnd4').set('intsurface', true);
model.component('comp1').probe('bnd4').selection.named('box5');
model.component('comp1').probe('bnd4').set('expr', '-spf2.T_stressx/(1/2*spf2.rho*(seo_U_in^2)*seo_B)');

model.component('comp1').probe.create('bnd5', 'Boundary');
model.component('comp1').probe('bnd5').set('intsurface', true);
model.component('comp1').probe('bnd5').selection.named('box5');
model.component('comp1').probe('bnd5').set('expr', '-spf2.T_stressy/(1/2*spf2.rho*(seo_U_in^2)*seo_B)');

model.component('comp1').probe.create('bnd6', 'Boundary');
model.component('comp1').probe('bnd6').set('intsurface', true);
model.component('comp1').probe('bnd6').selection.named('box5');
model.component('comp1').probe('bnd6').set('expr', ...
    '(-spf2.T_stressx*y + -spf2.T_stressy*-x)/(1/2*spf2.rho*(seo_U_in^2)*(seo_B^2))');
end

% model.component('comp1').physics('spf2').feature('inl1').set( ...
    % 'RANSVarOption', 'SpecifyTurbulentLengthScaleAndIntensity');

model.study('std1').feature('wdi').setIndex('activate', false, 1);
model.study('std1').feature('stat').setIndex('activate', false, 1);

model.sol.create('sol2');
model.sol('sol2').study('std1');

model.study('std1').feature('wdi').set('notlistsolnum', 1);
model.study('std1').feature('wdi').set('notsolnum', 'auto');
model.study('std1').feature('wdi').set('listsolnum', 1);
model.study('std1').feature('wdi').set('solnum', 'auto');
model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', 'auto');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', 'auto');

model.sol('sol2').create('st1', 'StudyStep');
model.sol('sol2').feature('st1').set('study', 'std1');
model.sol('sol2').feature('st1').set('studystep', 'wdi');
model.sol('sol2').create('v1', 'Variables');
model.sol('sol2').feature('v1').set('control', 'wdi');
model.sol('sol2').create('s1', 'Stationary');
model.sol('sol2').feature('s1').set('stol', 1.0E-6);
model.sol('sol2').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol2').feature('s1').feature('fc1').set('dtech', 'auto');
model.sol('sol2').feature('s1').feature('fc1').set('initstep', 0.01);
model.sol('sol2').feature('s1').feature('fc1').set('minstep', 1.0E-6);
model.sol('sol2').feature('s1').feature('fc1').set('maxiter', 50);
model.sol('sol2').feature('s1').create('d1', 'Direct');
model.sol('sol2').feature('s1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('s1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol2').feature('s1').feature('d1').label('Direct, wall distance (spf2)');
model.sol('sol2').feature('s1').create('i1', 'Iterative');
model.sol('sol2').feature('s1').feature('i1').set('linsolver', 'gmres');
model.sol('sol2').feature('s1').feature('i1').set('prefuntype', 'left');
model.sol('sol2').feature('s1').feature('i1').set('itrestart', 50);
model.sol('sol2').feature('s1').feature('i1').set('rhob', 20);
model.sol('sol2').feature('s1').feature('i1').set('maxlinit', 200);
model.sol('sol2').feature('s1').feature('i1').set('nlinnormuse', 'on');
model.sol('sol2').feature('s1').feature('i1').label('AMG, wall distance (spf2)');
model.sol('sol2').feature('s1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').set('prefun', 'saamg');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').set('mgcycle', 'v');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').set('strconn', 0.01);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').set('usesmooth', false);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').set('saamgcompwise', true);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('linerelax', 0.7);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('iter', 0);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('seconditer', 1);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sl1').set('relax', 0.5);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('linerelax', 0.7);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('seconditer', 1);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('po').feature('sl1').set('relax', 0.5);
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('s1').feature('i1').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol2').feature('s1').feature('fc1').set('linsolver', 'd1');
model.sol('sol2').feature('s1').feature('fc1').set('dtech', 'auto');
model.sol('sol2').feature('s1').feature('fc1').set('initstep', 0.01);
model.sol('sol2').feature('s1').feature('fc1').set('minstep', 1.0E-6);
model.sol('sol2').feature('s1').feature('fc1').set('maxiter', 50);
model.sol('sol2').feature('s1').feature.remove('fcDef');
model.sol('sol2').create('su1', 'StoreSolution');
model.sol('sol2').create('st2', 'StudyStep');
model.sol('sol2').feature('st2').set('study', 'std1');
model.sol('sol2').feature('st2').set('studystep', 'stat');
model.sol('sol2').create('v2', 'Variables');
model.sol('sol2').feature('v2').set('initmethod', 'sol');
model.sol('sol2').feature('v2').set('initsol', 'sol2');
model.sol('sol2').feature('v2').set('notsolmethod', 'sol');
model.sol('sol2').feature('v2').set('notsol', 'sol2');
model.sol('sol2').feature('v2').set('control', 'stat');
model.sol('sol2').create('s2', 'Stationary');
model.sol('sol2').feature('s2').feature('aDef').set('cachepattern', true);
model.sol('sol2').feature('s2').create('seDef', 'Segregated');
model.sol('sol2').feature('s2').create('se1', 'Segregated');
model.sol('sol2').feature('s2').feature('se1').feature.remove('ssDef');
model.sol('sol2').feature('s2').feature('se1').create('ss1', 'SegregatedStep');
% model.sol('sol2').feature('s2').feature('se1').feature('ss1').set('segvar', {'comp1_u' 'comp1_p' 'comp1_u2' 'comp1_p2'});
model.sol('sol2').feature('s2').feature('se1').feature('ss1').set('segvar', {'comp1_u2' 'comp1_p2'});
model.sol('sol2').feature('s2').feature('se1').feature('ss1').set('subdamp', 0.5);
model.sol('sol2').feature('s2').create('d1', 'Direct');
model.sol('sol2').feature('s2').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('s2').feature('d1').set('pivotperturb', 1.0E-13);
% model.sol('sol2').feature('s2').feature('d1').label('Direct, fluid flow variables (spf) (merged)');
model.sol('sol2').feature('s2').feature('d1').label('Direct, fluid flow variables (spf2)');
model.sol('sol2').feature('s2').feature('se1').feature('ss1').set('linsolver', 'd1');
% model.sol('sol2').feature('s2').feature('se1').feature('ss1').label('Merged variables');
model.sol('sol2').feature('s2').feature('se1').feature('ss1').label('Velocity u2, Pressure p2');
model.sol('sol2').feature('s2').feature('se1').create('ss2', 'SegregatedStep');
model.sol('sol2').feature('s2').feature('se1').feature('ss2').set('segvar', {'comp1_k2' 'comp1_om2'});
model.sol('sol2').feature('s2').feature('se1').feature('ss2').set('subdamp', 0.35);
model.sol('sol2').feature('s2').feature('se1').feature('ss2').set('subiter', 3);
model.sol('sol2').feature('s2').feature('se1').feature('ss2').set('subtermconst', 'itertol');
model.sol('sol2').feature('s2').feature('se1').feature('ss2').set('subntolfact', 1);
model.sol('sol2').feature('s2').create('d2', 'Direct');
model.sol('sol2').feature('s2').feature('d2').set('linsolver', 'pardiso');
model.sol('sol2').feature('s2').feature('d2').set('pivotperturb', 1.0E-13);
model.sol('sol2').feature('s2').feature('d2').label('Direct, turbulence variables (spf2)');
model.sol('sol2').feature('s2').feature('se1').feature('ss2').set('linsolver', 'd2');
model.sol('sol2').feature('s2').feature('se1').feature('ss2').label('Turbulence variables');

if 0
model.sol('sol2').feature('s2').feature('se1').create('ss3', 'SegregatedStep');
model.sol('sol2').feature('s2').feature('se1').feature('ss3').set('segvar', {'comp1_k' 'comp1_ep'});
model.sol('sol2').feature('s2').feature('se1').feature('ss3').set('subdamp', 0.35);
model.sol('sol2').feature('s2').feature('se1').feature('ss3').set('subiter', 3);
model.sol('sol2').feature('s2').feature('se1').feature('ss3').set('subtermconst', 'itertol');
model.sol('sol2').feature('s2').feature('se1').feature('ss3').set('subntolfact', 1);
model.sol('sol2').feature('s2').create('d3', 'Direct');
model.sol('sol2').feature('s2').feature('d3').set('linsolver', 'pardiso');
model.sol('sol2').feature('s2').feature('d3').set('pivotperturb', 1.0E-13);
model.sol('sol2').feature('s2').feature('d3').label('Direct, turbulence variables (spf)');
model.sol('sol2').feature('s2').feature('se1').feature('ss3').set('linsolver', 'd3');
model.sol('sol2').feature('s2').feature('se1').feature('ss3').label('Turbulence variables (2)');
end

model.sol('sol2').feature('s2').feature('se1').set('segstabacc', 'segcflcmp');
model.sol('sol2').feature('s2').feature('se1').set('subinitcfl', 2);
model.sol('sol2').feature('s2').feature('se1').set('subkppid', 0.65);
model.sol('sol2').feature('s2').feature('se1').set('subkdpid', 0.03);
model.sol('sol2').feature('s2').feature('se1').set('subkipid', 0.05);
model.sol('sol2').feature('s2').feature('se1').set('subcfltol', 0.08);
model.sol('sol2').feature('s2').feature('se1').set('maxsegiter', 300);
model.sol('sol2').feature('s2').feature('se1').create('ll1', 'LowerLimit');
% model.sol('sol2').feature('s2').feature('se1').feature('ll1').set('lowerlimit', 'comp1.om2 0 comp1.k 0 comp1.k2 0 comp1.ep 0 ');
model.sol('sol2').feature('s2').feature('se1').feature('ll1').set('lowerlimit', 'comp1.k2 0 comp1.om2 0 ');
model.sol('sol2').feature('s2').create('i1', 'Iterative');
model.sol('sol2').feature('s2').feature('i1').set('linsolver', 'gmres');
model.sol('sol2').feature('s2').feature('i1').set('prefuntype', 'left');
model.sol('sol2').feature('s2').feature('i1').set('itrestart', 50);
model.sol('sol2').feature('s2').feature('i1').set('rhob', 20);
model.sol('sol2').feature('s2').feature('i1').set('maxlinit', 200);
model.sol('sol2').feature('s2').feature('i1').set('nlinnormuse', 'on');
model.sol('sol2').feature('s2').feature('i1').label('AMG, fluid flow variables (spf2)');
model.sol('sol2').feature('s2').feature('i1').create('mg1', 'Multigrid');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').set('prefun', 'saamg');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').set('mgcycle', 'v');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').set('maxcoarsedof', 80000);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').set('strconn', 0.02);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').set('usesmooth', false);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').set('saamgcompwise', true);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('pr').create('sc1', 'SCGS');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('pr').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('pr').feature('sc1').set('iter', 0);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('pr').feature('sc1').set('seconditer', 1);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('pr').feature('sc1').set('relax', 0.5);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('po').create('sc1', 'SCGS');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('po').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('po').feature('sc1').set('iter', 1);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('po').feature('sc1').set('seconditer', 1);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('po').feature('sc1').set('relax', 0.5);
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('s2').feature('i1').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol2').feature('s2').create('i2', 'Iterative');
model.sol('sol2').feature('s2').feature('i2').set('linsolver', 'gmres');
model.sol('sol2').feature('s2').feature('i2').set('prefuntype', 'left');
model.sol('sol2').feature('s2').feature('i2').set('itrestart', 50);
model.sol('sol2').feature('s2').feature('i2').set('rhob', 20);
model.sol('sol2').feature('s2').feature('i2').set('maxlinit', 200);
model.sol('sol2').feature('s2').feature('i2').set('nlinnormuse', 'on');
model.sol('sol2').feature('s2').feature('i2').label('AMG, turbulence variables (spf2)');
model.sol('sol2').feature('s2').feature('i2').create('mg1', 'Multigrid');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').set('prefun', 'saamg');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').set('mgcycle', 'v');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').set('strconn', 0.01);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').set('usesmooth', false);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').set('saamgcompwise', true);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linerelax', 0.7);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('pr').feature('sl1').set('iter', 0);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('pr').feature('sl1').set('seconditer', 1);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('pr').feature('sl1').set('relax', 0.5);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('po').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('po').feature('sl1').set('linerelax', 0.7);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('po').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('po').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('po').feature('sl1').set('seconditer', 1);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('po').feature('sl1').set('relax', 0.5);
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('s2').feature('i2').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);

if 0
model.sol('sol2').feature('s2').create('i3', 'Iterative');
model.sol('sol2').feature('s2').feature('i3').set('linsolver', 'gmres');
model.sol('sol2').feature('s2').feature('i3').set('prefuntype', 'left');
model.sol('sol2').feature('s2').feature('i3').set('itrestart', 50);
model.sol('sol2').feature('s2').feature('i3').set('rhob', 20);
model.sol('sol2').feature('s2').feature('i3').set('maxlinit', 200);
model.sol('sol2').feature('s2').feature('i3').set('nlinnormuse', 'on');
model.sol('sol2').feature('s2').feature('i3').label('AMG, turbulence variables (spf)');
model.sol('sol2').feature('s2').feature('i3').create('mg1', 'Multigrid');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').set('prefun', 'saamg');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').set('mgcycle', 'v');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').set('strconn', 0.01);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').set('usesmooth', false);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').set('saamgcompwise', true);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('pr').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('pr').feature('sl1').set('linerelax', 0.7);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('pr').feature('sl1').set('iter', 0);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('pr').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('pr').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('pr').feature('sl1').set('seconditer', 1);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('pr').feature('sl1').set('relax', 0.5);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('po').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('po').feature('sl1').set('linerelax', 0.7);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('po').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('po').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('po').feature('sl1').set('seconditer', 1);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('po').feature('sl1').set('relax', 0.5);
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('s2').feature('i3').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
end

model.sol('sol2').feature('s2').feature.remove('fcDef');
model.sol('sol2').feature('s2').feature.remove('seDef');
model.sol('sol2').feature('v2').set('notsolnum', 'auto');
model.sol('sol2').feature('v2').set('notsolvertype', 'solnum');
model.sol('sol2').feature('v2').set('notlistsolnum', {'1'});
model.sol('sol2').feature('v2').set('notsolnum', 'auto');
model.sol('sol2').feature('v2').set('notlistsolnum', {'1'});
model.sol('sol2').feature('v2').set('notsolnum', 'auto');
model.sol('sol2').feature('v2').set('control', 'stat');
model.sol('sol2').feature('v2').set('solnum', 'auto');
model.sol('sol2').feature('v2').set('solvertype', 'solnum');
model.sol('sol2').feature('v2').set('listsolnum', {'1'});
model.sol('sol2').feature('v2').set('solnum', 'auto');
model.sol('sol2').feature('v2').set('listsolnum', {'1'});
model.sol('sol2').feature('v2').set('solnum', 'auto');
model.sol('sol2').attach('std1');

% %%
if 0
model.result.dataset('dset2').set('geom', 'geom1');

model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').label('Velocity (spf)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('data', 'dset2');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg1').feature('surf1').label('Surface');
model.result('pg1').feature('surf1').set('smooth', 'internal');
model.result('pg1').feature('surf1').set('data', 'parent');

model.result.create('pg2', 'PlotGroup2D');
model.result('pg2').label('Pressure (spf)');
model.result('pg2').set('frametype', 'spatial');
model.result('pg2').set('data', 'dset2');
model.result('pg2').feature.create('con1', 'Contour');
model.result('pg2').feature('con1').label('Contour');
model.result('pg2').feature('con1').set('expr', 'p');
model.result('pg2').feature('con1').set('number', 40);
model.result('pg2').feature('con1').set('levelrounding', false);
model.result('pg2').feature('con1').set('smooth', 'internal');
model.result('pg2').feature('con1').set('data', 'parent');

model.result.dataset.create('edg1', 'Edge2D');
model.result.dataset('edg1').label('Exterior Walls');
model.result.dataset('edg1').set('data', 'dset2');
model.result.dataset('edg1').selection.geom('geom1', 1);
model.result.dataset('edg1').selection.set([10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33]);
model.result.dataset('edg1').selection.inherit(false);

model.result.create('pg3', 'PlotGroup2D');
model.result('pg3').label('Wall Resolution (spf)');
model.result('pg3').set('frametype', 'spatial');
model.result('pg3').set('data', 'dset2');
model.result('pg3').feature.create('line1', 'Line');
model.result('pg3').feature('line1').label('Wall Resolution');
model.result('pg3').feature('line1').set('expr', 'spf.Delta_wPlus');
model.result('pg3').feature('line1').set('linetype', 'tube');
model.result('pg3').feature('line1').set('smooth', 'internal');
model.result('pg3').feature('line1').set('data', 'parent');
model.result('pg3').feature('line1').feature.create('hght1', 'Height');
model.result('pg3').feature('line1').feature('hght1').label('Height Expression');
model.result('pg3').feature('line1').feature('hght1').set('heightdata', 'expr');
model.result('pg3').feature('line1').feature('hght1').set('expr', 'spf.WRHeightExpr');

model.result.dataset('dset2').set('geom', 'geom1');
model.result.create('pg4', 'PlotGroup2D');
model.result('pg4').label('Velocity (spf2)');
model.result('pg4').set('frametype', 'spatial');
model.result('pg4').set('data', 'dset2');
model.result('pg4').feature.create('surf1', 'Surface');
model.result('pg4').feature('surf1').label('Surface');
model.result('pg4').feature('surf1').set('expr', 'spf2.U');
model.result('pg4').feature('surf1').set('smooth', 'internal');
model.result('pg4').feature('surf1').set('data', 'parent');

model.result.create('pg5', 'PlotGroup2D');
model.result('pg5').label('Pressure (spf2)');
model.result('pg5').set('frametype', 'spatial');
model.result('pg5').set('data', 'dset2');
model.result('pg5').feature.create('con1', 'Contour');
model.result('pg5').feature('con1').label('Contour');
model.result('pg5').feature('con1').set('expr', 'p2');
model.result('pg5').feature('con1').set('number', 40);
model.result('pg5').feature('con1').set('levelrounding', false);
model.result('pg5').feature('con1').set('smooth', 'internal');
model.result('pg5').feature('con1').set('data', 'parent');

model.result.dataset.create('edg2', 'Edge2D');
model.result.dataset('edg2').label('Exterior Walls 1');
model.result.dataset('edg2').set('data', 'dset2');
model.result.dataset('edg2').selection.geom('geom1', 1);
model.result.dataset('edg2').selection.set([10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33]);
model.result.dataset('edg2').selection.inherit(false);

model.result.create('pg6', 'PlotGroup2D');
model.result('pg6').label('Wall Resolution (spf2)');
model.result('pg6').set('frametype', 'spatial');
model.result('pg6').set('data', 'dset2');
model.result('pg6').feature.create('line1', 'Line');
model.result('pg6').feature('line1').label('Wall Resolution');
model.result('pg6').feature('line1').set('expr', 'spf2.Delta_wPlus');
model.result('pg6').feature('line1').set('linetype', 'tube');
model.result('pg6').feature('line1').set('smooth', 'internal');
model.result('pg6').feature('line1').set('data', 'parent');
model.result('pg6').feature('line1').feature.create('hght1', 'Height');
model.result('pg6').feature('line1').feature('hght1').label('Height Expression');
model.result('pg6').feature('line1').feature('hght1').set('heightdata', 'expr');
model.result('pg6').feature('line1').feature('hght1').set('expr', 'spf2.WRHeightExpr');
end

% model.component('comp1').probe('bnd1').genResult('none');
% model.component('comp1').probe('bnd2').genResult('none');
% model.component('comp1').probe('bnd3').genResult('none');

sb.Re_n = length(sb.Re_pool);

telap = toc(tcomp);
id_pause = true;
figure(1)
clf
for ii=1:sb.Re_n

    sb.Re = sb.Re_pool(ii);

% if 1
if 0
    model = mphload(sprintf('deck_lower_turbulentSST1_Re%d',sb.Re));
else
    % model.param.set('seo_U_in', sprintf('%f[m/s]',sb.U(150)));
    model.param.set('seo_U_in', sprintf('%f[m/s]',sb.U( sb.Re )));
    % model.component('comp1').physics('spf').feature('inl1').set('U0in', 'seo_U_in');
    model.component('comp1').physics('spf2').feature('inl1').set('U0in', 'seo_U_in');


% model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
% model.component('comp1').mesh('mesh1').feature('size').set('hauto', 3);
% model.component('comp1').mesh('mesh1').feature('size').set('hauto', 2);

% model.component('comp1').mesh('mesh1').feature('size').set('hauto', 4);
% model.component('comp1').mesh('mesh1').feature('fq2').feature('size1').set('hauto', 9);
% model.component('comp1').mesh('mesh1').feature('fq3').feature('size1').set('hauto', 9);
% model.component('comp1').mesh('mesh1').feature('fq1').feature('size1').set('hauto', 9);

% model.component('comp1').mesh('mesh1').feature('size').set('hauto', 4-3);

% model.component('comp1').mesh('mesh1').feature('fq2').feature('size1').set('hauto', 9-3);
% model.component('comp1').mesh('mesh1').feature('fq2').feature('size1').set('hauto', 1);
% model.component('comp1').mesh('mesh1').feature('fq3').feature('size1').set('hauto', 9-3);
% model.component('comp1').mesh('mesh1').feature('fq3').feature('size1').set('hauto', 5);
% model.component('comp1').mesh('mesh1').feature('fq1').feature('size1').set('hauto', 8);

% model.component('comp1').mesh('mesh1').run;


    % model.sol('sol1').runAll;
    model.sol('sol2').runAll;
    telap = toc(tcomp) - telap;
    fprintf('Total elapsed time = %.3f s.\n',telap)

    sb.res(ii+sb.Re_n).C = s_cfd_comsol_DLM2(model, sb, 'spf2', 'dset2', 1);
end

    mphsave(model,sprintf('deck_%s_a%s_turbulent_SST_Re%d', sb.s_geo, sb.s_al, sb.Re))
    save(sprintf('deck_%s_a%s_turbulent_SST_Re%d', sb.s_geo, sb.s_al, sb.Re),'sb')

end

end
end

if 0
id_pause = true;
figure(1)
clf
for ii=1:sb.Re_n
    sb.Re = sb.Re_pool(ii);
    figure(1)
    for jj = 1:3
        subplot(1,3,jj)
        plot(sb.Re, sb.DLM(ii,jj),'o','Color',rgb('Navy'))
        % plot(sb.Re, sb.DLM(ii+sb.Re_n,jj),'s','Color',rgb('Orange'))
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
    for jj = 1:3
        subplot(1,3,jj)
        % plot(sb.Re, sb.DLM(ii,jj),'o','Color',rgb('Navy'))
        plot(sb.Re, sb.DLM(ii+sb.Re_n,jj),'s','Color',rgb('Orange'))
    end
    for jj = 1:3
        subplot(1,3,jj)
        % plot(sb.Re, sb.DLM(ii,jj),'o','Color',rgb('Navy'))
        plot(sb.Re, sb.DLM(ii+sb.Re_n,jj),'d','Color',rgb('DeepPink'))
    end
end
end

% %% [markdown]
% # FINE
