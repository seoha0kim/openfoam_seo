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
function [model,sb] = rib_turbulent_200918(varargin)
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

% model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');
model.component('comp1').physics.create('spf', 'TurbulentFlowkeps', 'geom1');

model.study.create('std1');
% model.study('std1').create('stat', 'Stationary');
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('spf', true);

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
mphsave(model,sprintf('rib_upper_turbulent_Re%d',sb.Re))
save(sprintf('rib_upper_turbulent_Re%d',sb.Re),'sb')

% %% [markdown]
% # FINE
