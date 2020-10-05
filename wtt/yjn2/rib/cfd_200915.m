% -*- coding: utf-8 -*-
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
% # YJN2: arch rib

% %% [markdown]
% Saang Bum Kim <br>
% 2020-07-01 17:50

% %%
function [model,sb] = cfd_200915(varargin)
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

s_dir = 'git/openfoam_seo/wtt/yjn2/rib/';

p_comsol = 2036;
seo_init

id_f = 1;
% id_sv = true;
id_sv = false;
% id_pl = true;
id_pl = false;

% %% [markdown]
% # Pre

% %%
sb.geo

% %%
clear res
res.Re_pool = [150 1000 10000 100000 200000];
res.geo(1).s_geo = 'upper';
res.geo(2).s_geo = 'lower';

% %% [markdown]
% # Upper

% %%
sb.res(8).C.DLM
sb.res(9).C.DLM
sb.res(10).C.DLM

% %%
id_geo = 1;
% res.geo(id_geo).al_p = [0 2.5 -2.5 5.0 -5.0];
% res.geo(id_geo).s_al = {'000', 'm25', 'p25', 'm50', 'p50'};

% res.geo(id_geo).s_c{5} = rgb('Magenta');
% res.geo(id_geo).s_c{3} = rgb('Crimson');
% res.geo(id_geo).s_c{1} = rgb('Yellow');
% res.geo(id_geo).s_c{2} = rgb('Teal');
% res.geo(id_geo).s_c{4} = rgb('Indigo');

res.s_c{1} = rgb('Navy');
res.s_c{2} = rgb('Crimson');

res.s_c{3} = rgb('LightBlue');
res.s_c{4} = rgb('LightSalmon');

res.s_c{5} = rgb('Teal');
res.s_c{6} = rgb('Gold');


id_pause = true;
figure(1)
clf

for id_geo = 1:2
% for ll = [5 3 1 2 4]
for ll = 1
for ii = 1:5
    res.geo(id_geo).sb(ll).Re(ii) = res.Re_pool(ii);
    load(sprintf('rib_%s_turbulent_SST_Re%d', ...
        res.geo(id_geo).s_geo, res.Re_pool(ii)));

res.geo(id_geo).sb(ll).BD(ii,1:2) = [sb.B,sb.D];
% res.geo(id_geo).sb(ll).res(ii,1:6) = sb.res(ii).C.DLM(1:6);
% sc = [1 sb.D/sb.B (sb.D/sb.B)^2];
sc = [1 1 1];

for kk=1:3

res.geo(id_geo).sb(kk).res(ii,1:6) = sb.res(ii+5).C.DLM(kk,1:6)*diag([sc sc]);

    for jj=1:3
        subplot(1,3,jj)
        semilogx(sb.U(res.geo(id_geo).sb(ll).Re(ii)), ...
            res.geo(id_geo).sb(kk).res(ii,jj), ...
            'o', 'Color',res.s_c{id_geo+(kk-1)*2}, 'MarkerSize', 6-3)
            % 'Color',rgb('Navy'), 'MarkerSize', res.geo(id_geo).sb(.s_mk{2})
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
    for jj=1:3
        subplot(1,3,jj)
        h = semilogx(sb.U(res.geo(id_geo).sb(ll).Re(ii)), ...
            res.geo(id_geo).sb(kk).res(ii,jj+3), ...
            's', 'Color',res.s_c{id_geo+(kk-1)*2}, 'MarkerSize', 6-2);
        h.MarkerFaceColor = h.Color;
    end
end

end
end
end

% %% [markdown]
% # C_DLM

% %%
% [res.geo(1).sb(3).res(5,4:6)
C_DLM1 = ...
[res.geo(1).sb(1).res(5,4:6)
res.geo(1).sb(2).res(5,4:6)
res.geo(1).sb(3).res(5,4:6)
]%*diag([1 sb.D/sb.B sb.D^2/sb.B^2]) ...
% res.geo(1).sb(2).res(5,4:6)]%*diag([1 sb.D/sb.B sb.D^2/sb.B^2])
plot(C_DLM1*diag([1 10 10]))
gcfG;gcfH;gcfLFont;gcfS;%gcfP

% %%
C_DLM2 = ...
[res.geo(2).sb(1).res(5,4:6)
res.geo(2).sb(2).res(5,4:6)
res.geo(2).sb(3).res(5,4:6)]%*diag([1 sb.D/sb.B sb.D^2/sb.B^2])
plot([-2.5 0 2.5],C_DLM2*diag([1 1 10]))
gcfG;gcfH;gcfLFont;gcfS;%gcfP
plot([-2.5:2.5:2.5], C_DLM1*diag([1 1 10]),'--')

% %% [markdown]
% # FINE
