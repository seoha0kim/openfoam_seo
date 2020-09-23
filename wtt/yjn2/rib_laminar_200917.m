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
function [model,sb] = rib_laminar_200917(varargin)
%
% [model,sb] = rib_200915(varargin)
%
% Model exported on Sep 16 2020, 18:03 by COMSOL 5.5.0.359.

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

s_dir = 'git/openfoam_seo/wtt/yjn2/';

p_comsol = 2036;
seo_init

id_f = 1;
% id_sv = true;
id_sv = false;
% id_pl = true;
id_pl = false;

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

% %%
% 0.04*sc = 2.5
sb.scale = 2.5/0.04;

% %%
sb.B = 8.5/sb.scale;
sb.B = 8352.385221/1000/sb.scale;
sb.D = 2.5/sb.scale;

% %%
sb

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
sb.U = @(rey_n) (rey_n * Wind.air.mu(273.15+15) / Wind.air.rho(101325, 273.15+15) / sb.D);
sb.U(sb.Re)
sb.T_viv = @(rey_n) sb.B / sb.U(rey_n) / 0.2;
sb.T_viv(sb.Re)

% %%
sb.Re_target = Wind.air.rho(101325, 273.15+15) * 40 * sb.D / Wind.air.mu(273.15+15);
fprintf('Target Reynolds number = %e.\n',sb.Re_target)

% %%
sb.Re_pool = [150, 1e3, 1e4, 1e5, 2e5];

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

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/yjn2');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').activate('spf', true);

% %%
% mphsave(model,'rib_imsi')

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
model.component('comp1').geom('geom1').feature('imp1').set('filename', ...
    '/media/sbkim/2266B8F966B8CEB3/git/openfoam_seo/wtt/yjn2/yjn2_cfd_rib_200915.dxf');

model.component('comp1').geom('geom1').feature('imp1').set('knit', 'curve');
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
% model.component('comp1').geom('geom1').feature('csol1').selection('input').set({ ...
    % 'imp1(2)' 'imp1(3)' 'imp1(4)' 'imp1(5)'});
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'imp1'});

% %%
model.component('comp1').geom('geom1').create('del1', 'Delete');
% model.component('comp1').geom('geom1').feature('del1').selection('input').set('imp1(1)', [1 3]);
% model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1(1)', [1 2 3 4 5 6 7 19 20 21 29 30 31 32 37 38 39 40 41 42 43 51 52 53 54 55 57 58 59 62 66 70 72 75 76 78 80 83 84 85 87 89 92 93 94 96 98 101 102 104 106 109 110 112 114 115 116 117 118 125 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 145 146 158 165 171 172 174 176 179 180 182 184 187 188 190 192 195 196 198 200 203 204 206 208 211 212 214 216 219 220 222 224 227 228 230 232 235 236 238 239 241 245 246 248 250 253 254 256 258 261 262 264 266 269 270 272 274 277 278 280 282 285 286 288 290 293 294 296 298 301 302 304 306 309 310 312 313 314 315 317 318 319 320 321 322 323 324 325 326 327 329 330 331 332 333 334 335 337 338 340 341 363 364 365 366 367 368 369 370 371 372 373 374 377 389 390 391 407 408 409 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 439 440 443 444 459 470 473 474 477 478 481 482 485 486 489 490 493 494 495 496 497 498 499 500 501 502 503 504 505 506 511 523 524 527 528 531 532 535 536 539 540 543 544 547 548 551 552 555 556 559 560 563 564 567 568 571 572 575 576 579 580 583 584 587 588 591 592 594 595 596 597 598 599 600 601 602 603 604 605 607 608 609 610 611 612]);

model.component('comp1').geom('geom1').feature('del1').selection('input').init(2);
model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1', [1 2 3 4 5 16 17 18 19 20]);
model.component('comp1').geom('geom1').run('del1');

% model.component('comp1').geom('geom1').measure.selection.init(2);
% model.component('comp1').geom('geom1').measure.selection.all('del1(1)');

model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('del1', [1 32]);

% 19959.15556 [m], (19959.15556, -8.381909993E-7) [m].
% Point 1 (del1(2)) to 320 (del1(2)).
% Average coordinates: (157333.0083, -1067.977166) [m].
% Points: 1, 320 (del1(2)).

% [Sep 17, 2020 4:20 AM]
% Distance: 8352.385221 [m], (8352.385221, 2.328852133E-8) [m].
% Point 1 (del1) to 32 (del1).
% Average coordinates: (157127.4098, 10384.96539) [m].  Points: 1, 32 (del1).

% [Sep 16, 2020 10:39 PM]
% Distance: 12347.59452 [m], (12347.59452, 4.946377885E-8) [m].
% Point 2 (csol1) to 63 (csol1). Average coordinates: (157127.4098, -11160.59134) [m].
% Points: 2, 63 (csol1).

% %%
model.component('comp1').geom('geom1').create('sca1', 'Scale');
model.component('comp1').geom('geom1').feature('sca1').set('factor', '1e-3');
% model.component('comp1').geom('geom1').feature('sca1').selection('input').set({'del1(1)' 'del1(2)'});
model.component('comp1').geom('geom1').feature('sca1').selection('input').set({'del1'});

model.component('comp1').geom('geom1').create('mov1', 'Move');
model.component('comp1').geom('geom1').feature('mov1').setIndex('displx', '-157.1274098', 0);
model.component('comp1').geom('geom1').feature('mov1').setIndex('disply', '-10.38496539', 0);
model.component('comp1').geom('geom1').feature('mov1').selection('input').set({'sca1'});

% out = model;

% %%
model.component('comp1').geom('geom1').create('sca2', 'Scale');
model.component('comp1').geom('geom1').feature('sca2').set('factor', sprintf('1/%d',sb.scale));
model.component('comp1').geom('geom1').feature('sca2').selection('input').set({'mov1'});

model.component('comp1').geom('geom1').create('mir1', 'Mirror');
model.component('comp1').geom('geom1').feature('mir1').selection('input').set({'sca2'});
model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('pos', {'-1.5' '-1.5/2'});
model.component('comp1').geom('geom1').feature('r1').set('size', [4.5 1.5]);
model.component('comp1').geom('geom1').create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('c1').set('pos', {'0' '.02'});
model.component('comp1').geom('geom1').feature('c1').set('r', 0.2);
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('pos', [-0.5 -0.5]);
model.component('comp1').geom('geom1').feature('r2').set('size', [2 1]);
model.component('comp1').geom('geom1').create('r3', 'Rectangle');
model.component('comp1').geom('geom1').feature('r3').set('pos', {'-.75/2' '-.75/2'});
model.component('comp1').geom('geom1').feature('r3').set('size', [1 0.75]);

% %%
% mphsave(model,'rib_imsi')

% %%
model.component('comp1').geom('geom1').create('co1', 'Compose');
% model.component('comp1').geom('geom1').feature('co1').set('formula', '(r1+c1+r2+r3)-(mir1(1)+mir1(2))');
% model.component('comp1').geom('geom1').feature('co1').selection('input').set({'r1' 'c1' 'r2' 'r3' 'mir1(1)' 'mir1(2)'});
model.component('comp1').geom('geom1').feature('co1').set('formula', '(r1+c1+r2+r3)-(mir1)');
model.component('comp1').geom('geom1').feature('co1').selection('input').set({'r1' 'c1' 'r2' 'r3' 'mir1'});

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
model.component('comp1').selection('box1').set('xmin', -0.15);
model.component('comp1').selection('box1').set('xmax', 0.15);
model.component('comp1').selection('box1').set('ymin', -0.1);
model.component('comp1').selection('box1').set('ymax', 0.12);

% %%
model.component('comp1').selection.create('box2', 'Box');
model.component('comp1').selection('box2').set('entitydim', 1);
model.component('comp1').selection('box2').set('xmin', -0.15);
model.component('comp1').selection('box2').set('xmax', 0);
model.component('comp1').selection('box2').set('ymin', -0.1);
model.component('comp1').selection('box2').set('ymax', 0.12);

model.component('comp1').selection.create('box3', 'Box');
model.component('comp1').selection('box3').set('entitydim', 1);
model.component('comp1').selection('box3').set('xmin', 0);
model.component('comp1').selection('box3').set('xmax', 0.15);
model.component('comp1').selection('box3').set('ymin', -0.1);
model.component('comp1').selection('box3').set('ymax', 0.12);

model.component('comp1').selection.create('box4', 'Box');
model.component('comp1').selection('box4').set('entitydim', 1);
model.component('comp1').selection('box4').set('xmin', -1.6);
model.component('comp1').selection('box4').set('xmax', -1.4);
model.component('comp1').selection('box4').set('ymin', -1);
model.component('comp1').selection('box4').set('ymax', 1);
model.component('comp1').selection('box4').set('condition', 'inside');
% model.component('comp1').selection('box4').set('condition', 'allvertices');
% mphviewselection(model,'box4')

model.component('comp1').selection.create('box5', 'Box');
model.component('comp1').selection('box5').set('entitydim', 1);
model.component('comp1').selection('box5').set('xmin', 2.9);
model.component('comp1').selection('box5').set('xmax', 3.1);
model.component('comp1').selection('box5').set('ymin', -1);
model.component('comp1').selection('box5').set('ymax', 1);
model.component('comp1').selection('box5').set('condition', 'inside');
% mphviewselection(model,'box5')

model.component('comp1').selection.create('box6', 'Box');
model.component('comp1').selection('box6').set('entitydim', 1);
model.component('comp1').selection('box6').set('xmin', -1.6);
model.component('comp1').selection('box6').set('xmax', 3.1);
model.component('comp1').selection('box6').set('ymin', -.8);
model.component('comp1').selection('box6').set('ymax', -.7);
model.component('comp1').selection('box6').set('condition', 'inside');
% mphviewselection(model,'box6')

model.component('comp1').selection.create('box7', 'Box');
model.component('comp1').selection('box7').set('entitydim', 1);
model.component('comp1').selection('box7').set('xmin', -1.6);
model.component('comp1').selection('box7').set('xmax', 3.1);
model.component('comp1').selection('box7').set('ymin', .7);
model.component('comp1').selection('box7').set('ymax', .8);
model.component('comp1').selection('box7').set('condition', 'inside');
% mphviewselection(model,'box7')

% model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');

% %%
model.component('comp1').physics('spf').create('inl1', 'InletBoundary', 1);
model.component('comp1').physics('spf').feature('inl1').selection.set([1]);
model.component('comp1').physics('spf').create('out1', 'OutletBoundary', 1);
% model.component('comp1').physics('spf').feature('out1').selection.set([229]);
model.component('comp1').physics('spf').feature('out1').selection.set([36]);
model.component('comp1').physics('spf').create('sym1', 'Symmetry', 1);
model.component('comp1').physics('spf').feature('sym1').selection.set([2 3]);

% %%
sb.U_in = sb.U(150);

% %%
% model.component('comp1').physics('spf').prop('PhysicalModelProperty').set('IncludeGravity', true);
model.component('comp1').physics('spf').feature('inl1').set('U0in', sb.U_in);

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
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp').selection.named('box1');

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

% %%
model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
% model.component('comp1').mesh('mesh1').feature('size').set('hauto', 3);
% model.component('comp1').mesh('mesh1').feature('size').set('hauto', 2);
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 4);
model.component('comp1').mesh('mesh1').feature('fq2').feature('size1').set('hauto', 9);
model.component('comp1').mesh('mesh1').feature('fq3').feature('size1').set('hauto', 9);
model.component('comp1').mesh('mesh1').feature('fq1').feature('size1').set('hauto', 9);

model.component('comp1').mesh('mesh1').run;

% mphsave(model,sprintf('rib_upper_laminarTa_Re%d_of',sb.Re))

% %%
% model.study.create('std1');
% model.study('std1').create('stat', 'Stationary');

% %%
% model.component('comp1').view('view1').axis.set('xmin', -1.7249999046325684);
% model.component('comp1').view('view1').axis.set('xmax', 3.2249999046325684);
% model.component('comp1').view('view1').axis.set('ymin', -1.3424468040466309);
% model.component('comp1').view('view1').axis.set('ymax', 1.3424468040466309);

% %%
% mphsave(model,'rib_imsi')

% %% [markdown]
% ## Study

% %%
model.sol.create('sol1');
model.sol('sol1').study('std1');

% %%
model.study('std1').feature('stat').set('notlistsolnum', 1);
model.study('std1').feature('stat').set('notsolnum', '1');
model.study('std1').feature('stat').set('listsolnum', 1);
model.study('std1').feature('stat').set('solnum', '1');

% %%
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');

% %%
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature('fc1').set('initstep', 0.01);
model.sol('sol1').feature('s1').feature('fc1').set('minstep', 1.0E-4);
model.sol('sol1').feature('s1').feature('fc1').set('dtech', 'auto');
model.sol('sol1').feature('s1').feature('fc1').set('maxiter', 100);
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('d1').label('Direct, fluid flow variables (spf)');
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
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'd1');
model.sol('sol1').feature('s1').feature('fc1').set('initstep', 0.01);
model.sol('sol1').feature('s1').feature('fc1').set('minstep', 1.0E-4);
model.sol('sol1').feature('s1').feature('fc1').set('dtech', 'auto');
model.sol('sol1').feature('s1').feature('fc1').set('maxiter', 100);
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');
model.result.dataset('dset1').set('geom', 'geom1');

% %%
if 0
model.result.create('pg1', 'PlotGroup2D');
model.result('pg1').label('Velocity (spf)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('surf1', 'Surface');
model.result('pg1').feature('surf1').label('Surface');
model.result('pg1').feature('surf1').set('smooth', 'internal');
model.result('pg1').feature('surf1').set('data', 'parent');
model.result.create('pg2', 'PlotGroup2D');
model.result('pg2').label('Pressure (spf)');
model.result('pg2').set('frametype', 'spatial');
model.result('pg2').set('data', 'dset1');
model.result('pg2').feature.create('con1', 'Contour');
model.result('pg2').feature('con1').label('Contour');
model.result('pg2').feature('con1').set('expr', 'p');
model.result('pg2').feature('con1').set('number', 40);
model.result('pg2').feature('con1').set('levelrounding', false);
model.result('pg2').feature('con1').set('smooth', 'internal');
model.result('pg2').feature('con1').set('data', 'parent');
end

% %%
telap = toc(tcomp);
model.sol('sol1').runAll;
telap = toc(tcomp) - telap;
fprintf('Total elapsed time = %.3f s.\n',telap)

% %%
% model.result('pg1').run;

% %% [markdown]
% ## Post

% %%
if 0
model.result.numerical.create('int1', 'IntLine');
model.result.numerical('int1').set('intsurface', true);
% model.result.numerical('int1').selection.set([10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341]);
model.result.numerical('int1').selection.named('box1');
model.result.numerical('int1').set('expr', {'spf.T_stressx'});
model.result.numerical('int1').set('descr', {'Total stress, x component'});
model.result.numerical('int1').set('unit', {'N/m'});
model.result.table.create('tbl1', 'Table');
model.result.table('tbl1').comments('Line Integration 1');
model.result.numerical('int1').set('table', 'tbl1');
model.result.numerical('int1').setResult;
end

% %%
s_box = ['box',num2str(1)];
sb.res(1,1) = mphint2(model,'-spf.T_stressx / (1/2*spf.rho)','line','selection',s_box) / ((sb.U_in^2) * sb.D);
sb.res(1,2) = mphint2(model,'-spf.T_stressy / (1/2*spf.rho)','line','selection',s_box) / ((sb.U_in^2) * sb.D);
sb.res(1,3) = mphint2(model,'(-spf.T_stressx*y + -spf.T_stressy*-x) / (1/2*spf.rho)','line','selection',s_box) / ((sb.U_in^2) * sb.D^2);
fprintf('%f, %f, %f\n',sb.res(1,:))

% %%
mphsave(model,sprintf('rib_upper_laminar_Re%d',sb.Re))
save(sprintf('rib_upper_laminar_Re%d',sb.Re),'sb')

% %% [markdown]
% # Laminar: Transient

% %%
model.study.create('std2');
model.study('std2').create('time', 'Transient');
model.study('std2').feature('time').activate('spf', true);
model.study('std2').feature('time').set('tlist', ...
    sprintf('range(0,0.1,.9)*%.2e range(1,1/2^6,2^4)*%.2e', sb.T_viv(150)*[1 1]));

model.sol.create('sol2');
model.sol('sol2').study('std2');

model.study('std2').feature('time').set('notlistsolnum', 1);
model.study('std2').feature('time').set('notsolnum', '1');
model.study('std2').feature('time').set('listsolnum', 1);
model.study('std2').feature('time').set('solnum', '1');

model.study('std2').feature('time').set('useinitsol', true);
model.study('std2').feature('time').set('initstudy', 'std1');
model.study('std2').feature('time').set('solnum', 'last');
model.study('std2').feature('time').set('usesol', true);
model.study('std2').feature('time').set('notstudy', 'std1');

model.sol('sol2').create('st1', 'StudyStep');
model.sol('sol2').feature('st1').set('study', 'std2');
model.sol('sol2').feature('st1').set('studystep', 'time');
model.sol('sol2').create('v1', 'Variables');
model.sol('sol2').feature('v1').set('control', 'time');
model.sol('sol2').create('t1', 'Time');

model.sol('sol2').feature('t1').set('tlist', ...
    sprintf('range(0,0.1,.9)*%.2e range(1,1/2^6,2^4)*%.2e', sb.T_viv(150)*[1 1]));

model.sol('sol2').feature('t1').set('plot', 'off');
model.sol('sol2').feature('t1').set('plotgroup', 'Default');
model.sol('sol2').feature('t1').set('plotfreq', 'tout');
model.sol('sol2').feature('t1').set('probesel', 'all');
model.sol('sol2').feature('t1').set('probes', {});
model.sol('sol2').feature('t1').set('probefreq', 'tsteps');
model.sol('sol2').feature('t1').set('rtol', 0.005);
model.sol('sol2').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol2').feature('t1').set('atolglobalfactor', 0.05);
model.sol('sol2').feature('t1').set('atolglobalvaluemethod', 'factor');
model.sol('sol2').feature('t1').set('atolmethod', {'comp1_p' 'scaled' 'comp1_u' 'global'});
model.sol('sol2').feature('t1').set('atolvaluemethod', {'comp1_p' 'factor' 'comp1_u' 'factor'});
model.sol('sol2').feature('t1').set('atolfactor', {'comp1_p' '1' 'comp1_u' '0.1'});
model.sol('sol2').feature('t1').set('estrat', 'exclude');
model.sol('sol2').feature('t1').set('rhoinf', 0.5);
model.sol('sol2').feature('t1').set('predictor', 'constant');
model.sol('sol2').feature('t1').set('maxorder', 2);
model.sol('sol2').feature('t1').set('stabcntrl', true);
model.sol('sol2').feature('t1').set('bwinitstepfrac', '0.01');
model.sol('sol2').feature('t1').set('control', 'time');

model.sol('sol2').feature('t1').feature('aDef').set('cachepattern', true);
model.sol('sol2').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol2').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol2').feature('t1').feature('fc1').set('damp', 0.9);
model.sol('sol2').feature('t1').feature('fc1').set('stabacc', 'aacc');
model.sol('sol2').feature('t1').feature('fc1').set('aaccdim', 5);
model.sol('sol2').feature('t1').feature('fc1').set('aaccmix', 0.9);
model.sol('sol2').feature('t1').feature('fc1').set('aaccdelay', 1);
model.sol('sol2').feature('t1').feature('fc1').set('ntolfact', 0.5);
model.sol('sol2').feature('t1').feature('fc1').set('maxiter', 8);
model.sol('sol2').feature('t1').create('d1', 'Direct');
model.sol('sol2').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('t1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol2').feature('t1').feature('d1').label('Direct, fluid flow variables (spf)');
model.sol('sol2').feature('t1').create('i1', 'Iterative');
model.sol('sol2').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol2').feature('t1').feature('i1').set('prefuntype', 'left');
model.sol('sol2').feature('t1').feature('i1').set('itrestart', 50);
model.sol('sol2').feature('t1').feature('i1').set('rhob', 20);
model.sol('sol2').feature('t1').feature('i1').set('maxlinit', 50);
model.sol('sol2').feature('t1').feature('i1').set('nlinnormuse', 'on');
model.sol('sol2').feature('t1').feature('i1').label('AMG, fluid flow variables (spf)');
model.sol('sol2').feature('t1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').set('prefun', 'saamg');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').set('mgcycle', 'v');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').set('maxcoarsedof', 80000);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').set('strconn', 0.02);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').set('usesmooth', false);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').set('saamgcompwise', true);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('pr').create('sc1', 'SCGS');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('iter', 0);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('seconditer', 1);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('relax', 0.5);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('po').create('sc1', 'SCGS');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('iter', 1);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('seconditer', 1);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('relax', 0.5);
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol2').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol2').feature('t1').feature('fc1').set('linsolver', 'd1');
model.sol('sol2').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol2').feature('t1').feature('fc1').set('damp', 0.9);
model.sol('sol2').feature('t1').feature('fc1').set('stabacc', 'aacc');
model.sol('sol2').feature('t1').feature('fc1').set('aaccdim', 5);
model.sol('sol2').feature('t1').feature('fc1').set('aaccmix', 0.9);
model.sol('sol2').feature('t1').feature('fc1').set('aaccdelay', 1);
model.sol('sol2').feature('t1').feature('fc1').set('ntolfact', 0.5);
model.sol('sol2').feature('t1').feature('fc1').set('maxiter', 8);
model.sol('sol2').feature('t1').feature.remove('fcDef');
model.sol('sol2').attach('std2');
model.result.dataset('dset2').set('geom', 'geom1');

% %%
if 0
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
end

% %%
telap = toc(tcomp);
% model.sol('sol1').runAll;
model.sol('sol2').runAll;
telap = toc(tcomp) - telap;
fprintf('Total elapsed time = %.3f s.\n',telap)

% %%
t = [[0:0.1:.9]*sb.T_viv(150), [1:1/2^6:2^4]*sb.T_viv(150)]';

% %%
for ii=1:3
s_box = ['box',num2str(ii)];
y(1+(ii-1)*3,:) = mphint2(model, ...
    '-spf.T_stressx / (1/2*spf.rho)','line','selection',s_box, 'dataset','dset2') / ((sb.U_in^2) * sb.D);
y(2+(ii-1)*3,:) = mphint2(model, ...
    '-spf.T_stressy / (1/2*spf.rho)','line','selection',s_box, 'dataset','dset2') / ((sb.U_in^2) * sb.D);
y(3+(ii-1)*3,:) = mphint2(model, ...
    '(-spf.T_stressx*y + -spf.T_stressy*-x) / (1/2*spf.rho)','line','selection',s_box, ...
    'dataset','dset2') / ((sb.U_in^2) * sb.D^2);
end

% %%
n_t = floor(length(t)/2);
lc = n_t:n_t*2;
tn = t(lc);
d_t = mean(diff(tn))
std(diff(tn))

% %%
d_f = 1/n_t/d_t;
n_f = floor(n_t/2+1);
f = [0:n_f-1]*d_f;
yf = fft(y(:,lc)');

% %%
lc_fN_m = output(@() max(abs(yf(2:end,:))), 2)+1;

% %%
sb.res(2,1:9) = mean(y(:,lc)');
sb.res(2,10) = f(lc_fN_m(2))*sb.D/sb.U(150);
sb.res(2,11) = f(lc_fN_m(5))*sb.D/sb.U(150);
sb.res(2,12) = f(lc_fN_m(8))*sb.D/sb.U(150);
sb.res

% %%
id_pause = true;
figure(1)
clf
for jj=[2,3,1]
for ii = 1:3
subplot(1,3,ii)
% plot(t*f(lc_fN_m(ii+(jj-1)*3)),y(ii+(jj-1)*3,:),'Color',rgb('Navy'))
if jj == 1
    plot(t*f(lc_fN_m(ii+(jj-1)*3)),y(ii+(jj-1)*3,:),'Color',rgb('Navy'))
else
    plot(t*f(lc_fN_m(ii+(jj-1)*3)),y(ii+(jj-1)*3,:))
end
if id_pause
xlabel('Time [s]')
end
end
if id_pause
gcfG;gcfH;gcfLFont;gcfS;%gcfP
ylabel('$\mathrm{C_D}$')
% gcfX([1,2^4]*sb.T_viv(150)*f(lc_fN_m(2)))
gcfX([2^3,2^4]*sb.T_viv(150)*f(lc_fN_m(2)))
% end
% if id_pause
id_pause = false;
for ii = 1:3
subplot(1,3,ii)
yl = ylim;
plot([1 1]*tn(1)*f(lc_fN_m(ii+(jj-1)*3)), yl, 'r:')
% ylim(yl)
end
end
end

% %%
id_pause = true;
figure(2)
clf
for jj=[2,3,1]
for ii = 1:3
subplot(1,3,ii)
% plot(t*f(lc_fN_m(ii+(jj-1)*3)),y(ii+(jj-1)*3,:),'Color',rgb('Navy'))
if jj == 1
    loglog(f/f(lc_fN_m(ii+(jj-1)*3)),abs(yf(1:n_f,ii+(jj-1)*3) ),'Color',rgb('Navy'))
else
    loglog(f/f(lc_fN_m(ii+(jj-1)*3)),abs(yf(1:n_f,ii+(jj-1)*3) ))
end
if id_pause
xlabel('Frequency [Hz]')
end
end
if id_pause
gcfG;gcfH;gcfLFont;gcfS;%gcfP
ylabel('$\mathrm{C_D}$')
% gcfX([1,2^4]*sb.T_viv(150)*f(lc_fN_m(2)))
% gcfX([2^3,2^4]*sb.T_viv(150)*f(lc_fN_m(2)))
% end
% if id_pause
id_pause = false;
for ii = 1:3
subplot(1,3,ii)
loglog(f(lc_fN_m(ii+(jj-1)*3))/f(lc_fN_m(ii+(jj-1)*3)), ...
    abs(yf(lc_fN_m(ii+(jj-1)*3),ii+(jj-1)*3)),'ro','MarkerSize',6-3)
end
end
end

% %%
mphsave(model,sprintf('rib_upper_laminarT_Re%d',sb.Re))
save(sprintf('rib_upper_laminarT_Re%d',sb.Re),'sb')

% %% [markdown]
% # Laminar: Transient: Velocity iteration

% %%
model.param.set('seo_U_in', '0.05[m/s]');
model.component('comp1').physics('spf').feature('inl1').set('U0in', 'seo_U_in');

model.study.create('std3');
model.study('std3').create('time', 'Transient');
model.study('std3').feature('time').activate('spf', true);
model.study('std3').feature('time').set('tlist', 'range(0,0.1,.9)*1.22e+01 range(1,1/2^6,2^4)*1.22e+01');

model.study('std3').feature('time').set('useinitsol', true);
model.study('std3').feature('time').set('initstudy', 'std2');
model.study('std3').feature('time').set('usesol', true);
model.study('std3').feature('time').set('notstudy', 'std2');

model.study('std3').feature('time').set('useparam', true);
model.study('std3').feature('time').setIndex('pname', 'seo_U_in', 0);
model.study('std3').feature('time').setIndex('plistarr', '', 0);
model.study('std3').feature('time').setIndex('punit', 'm/s', 0);
model.study('std3').feature('time').setIndex('pname', 'seo_U_in', 0);
model.study('std3').feature('time').setIndex('plistarr', '', 0);
model.study('std3').feature('time').setIndex('punit', 'm/s', 0);
model.study('std3').feature('time').setIndex('plistarr', '0.1 0.15', 0);

% %%
model.sol.create('sol3');
model.sol('sol3').study('std3');

model.study('std3').feature('time').set('notlistsolnum', 1);
model.study('std3').feature('time').set('notsolnum', 'auto');
model.study('std3').feature('time').set('listsolnum', 1);
model.study('std3').feature('time').set('solnum', 'auto');

model.sol('sol3').create('st1', 'StudyStep');
model.sol('sol3').feature('st1').set('study', 'std3');
model.sol('sol3').feature('st1').set('studystep', 'time');
model.sol('sol3').create('v1', 'Variables');
model.sol('sol3').feature('v1').set('control', 'time');
model.sol('sol3').create('t1', 'Time');
model.sol('sol3').feature('t1').set('tlist', 'range(0,0.1,.9)*1.22e+01 range(1,1/2^6,2^4)*1.22e+01');
model.sol('sol3').feature('t1').set('plot', 'off');
% model.sol('sol3').feature('t1').set('plotgroup', 'pg1');
% model.sol('sol3').feature('t1').set('plotfreq', 'tout');
model.sol('sol3').feature('t1').set('probesel', 'all');
model.sol('sol3').feature('t1').set('probes', {});
model.sol('sol3').feature('t1').set('probefreq', 'tsteps');
model.sol('sol3').feature('t1').set('rtol', 0.005);
model.sol('sol3').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol3').feature('t1').set('atolglobalfactor', 0.05);
model.sol('sol3').feature('t1').set('atolglobalvaluemethod', 'factor');
model.sol('sol3').feature('t1').set('atolmethod', {'comp1_p' 'scaled' 'comp1_u' 'global'});
model.sol('sol3').feature('t1').set('atolvaluemethod', {'comp1_p' 'factor' 'comp1_u' 'factor'});
model.sol('sol3').feature('t1').set('atolfactor', {'comp1_p' '1' 'comp1_u' '0.1'});
model.sol('sol3').feature('t1').set('estrat', 'exclude');
model.sol('sol3').feature('t1').set('rhoinf', 0.5);
model.sol('sol3').feature('t1').set('predictor', 'constant');
model.sol('sol3').feature('t1').set('maxorder', 2);
model.sol('sol3').feature('t1').set('stabcntrl', true);
model.sol('sol3').feature('t1').set('bwinitstepfrac', '0.01');
model.sol('sol3').feature('t1').create('tp1', 'TimeParametric');
model.sol('sol3').feature('t1').feature.remove('tpDef');
model.sol('sol3').feature('t1').feature('tp1').set('control', 'time');
model.sol('sol3').feature('t1').set('control', 'time');
model.sol('sol3').feature('t1').feature('aDef').set('cachepattern', true);
model.sol('sol3').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol3').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol3').feature('t1').feature('fc1').set('damp', 0.9);
model.sol('sol3').feature('t1').feature('fc1').set('stabacc', 'aacc');
model.sol('sol3').feature('t1').feature('fc1').set('aaccdim', 5);
model.sol('sol3').feature('t1').feature('fc1').set('aaccmix', 0.9);
model.sol('sol3').feature('t1').feature('fc1').set('aaccdelay', 1);
model.sol('sol3').feature('t1').feature('fc1').set('ntolfact', 0.5);
model.sol('sol3').feature('t1').feature('fc1').set('maxiter', 8);
model.sol('sol3').feature('t1').create('d1', 'Direct');
model.sol('sol3').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol3').feature('t1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol3').feature('t1').feature('d1').label('Direct, fluid flow variables (spf)');
model.sol('sol3').feature('t1').create('i1', 'Iterative');
model.sol('sol3').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol3').feature('t1').feature('i1').set('prefuntype', 'left');
model.sol('sol3').feature('t1').feature('i1').set('itrestart', 50);
model.sol('sol3').feature('t1').feature('i1').set('rhob', 20);
model.sol('sol3').feature('t1').feature('i1').set('maxlinit', 50);
model.sol('sol3').feature('t1').feature('i1').set('nlinnormuse', 'on');
model.sol('sol3').feature('t1').feature('i1').label('AMG, fluid flow variables (spf)');
model.sol('sol3').feature('t1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').set('prefun', 'saamg');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').set('mgcycle', 'v');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').set('maxcoarsedof', 80000);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').set('strconn', 0.02);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').set('usesmooth', false);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').set('saamgcompwise', true);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('pr').create('sc1', 'SCGS');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('iter', 0);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('seconditer', 1);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('relax', 0.5);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('po').create('sc1', 'SCGS');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('iter', 1);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('seconditer', 1);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('relax', 0.5);
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol3').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol3').feature('t1').feature('fc1').set('linsolver', 'd1');
model.sol('sol3').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol3').feature('t1').feature('fc1').set('damp', 0.9);
model.sol('sol3').feature('t1').feature('fc1').set('stabacc', 'aacc');
model.sol('sol3').feature('t1').feature('fc1').set('aaccdim', 5);
model.sol('sol3').feature('t1').feature('fc1').set('aaccmix', 0.9);
model.sol('sol3').feature('t1').feature('fc1').set('aaccdelay', 1);
model.sol('sol3').feature('t1').feature('fc1').set('ntolfact', 0.5);
model.sol('sol3').feature('t1').feature('fc1').set('maxiter', 8);
model.sol('sol3').feature('t1').feature.remove('fcDef');
model.sol('sol3').attach('std3');

% %%
telap = toc(tcomp);
model.sol('sol3').runAll;
telap = toc(tcomp) - telap;
fprintf('Total elapsed time = %.3f s.\n',telap)

% %%
mphsave(model,sprintf('rib_upper_laminarTa_Re%d',sb.Re))
save(sprintf('rib_upper_laminarTa_Re%d',sb.Re),'sb')

% %% [markdown]
% # FINE
