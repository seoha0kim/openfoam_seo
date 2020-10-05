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
% # JBK: tower

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

s_dir = 'git/openfoam_seo/wtt/yjn2/deck/';

p_comsol = 2036;
seo_init

id_f = 1;
% id_sv = true;
id_sv = false;
% id_pl = true;
id_pl = false;

% %% [markdown]
% # Upper

% %%
clear res
res.Re_pool = [150 1000 10000 100000 200000];
res.geo(1).s_geo = 'upper';
res.geo(2).s_geo = 'lower';

id_geo = 1;
res.geo(id_geo).al_p = [0 2.5 -2.5];
res.geo(id_geo).s_al = {'000', 'm25', 'p25'};

res.geo(id_geo).s_c{1} = rgb('Navy');
res.geo(id_geo).s_c{2} = rgb('Teal');
res.geo(id_geo).s_c{3} = rgb('Crimson');


id_pause = true;
figure(1)
clf

for ll = [3 1 2]
for ii = 1:5
    res.geo(id_geo).sb(ll).Re(ii) = res.Re_pool(ii);
    load(sprintf('deck_%s_a%s_turbulent_SST_Re%d', ...
        res.geo(id_geo).s_geo, res.geo(id_geo).s_al{ll}, res.Re_pool(ii)));

res.geo(id_geo).sb(ll).res(ii,1:6) = sb.res(ii).C.DLM(1:6);

    for jj=1:3
        subplot(1,3,jj)
        semilogx(sb.U(res.geo(id_geo).sb(ll).Re(ii)), ...
            res.geo(id_geo).sb(ll).res(ii,jj), ...
            'o', 'Color',res.geo(id_geo).s_c{ll}, 'MarkerSize', 6-3)
            % 'Color',rgb('Navy'), 'MarkerSize', res.geo(id_geo).sb(.s_mk{2})
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
    for jj=1:3
        subplot(1,3,jj)
        h = semilogx(sb.U(res.geo(id_geo).sb(ll).Re(ii)), ...
            res.geo(id_geo).sb(ll).res(ii,jj+3), ...
            's', 'Color',res.geo(id_geo).s_c{ll}, 'MarkerSize', 6-2);
        h.MarkerFaceColor = h.Color;
    end
end
end

% %% [markdown]
% # Lower

% %%
id_geo = 2;
res.geo(id_geo).al_p = [0 2.5 -2.5];
res.geo(id_geo).s_al = {'000', 'm25', 'p25'};

res.geo(id_geo).s_c{1} = rgb('Navy');
res.geo(id_geo).s_c{2} = rgb('Teal');
res.geo(id_geo).s_c{3} = rgb('Crimson');


id_pause = true;
figure(1)
clf

for ll = [3 1 2]
for ii = 1:5
    res.geo(id_geo).sb(ll).Re(ii) = res.Re_pool(ii);
    load(sprintf('deck_%s_a%s_turbulent_SST_Re%d', ...
        res.geo(id_geo).s_geo, res.geo(id_geo).s_al{ll}, res.Re_pool(ii)));

res.geo(id_geo).sb(ll).res(ii,1:6) = sb.res(ii).C.DLM(1:6);

    for jj=1:3
        subplot(1,3,jj)
        semilogx(sb.U(res.geo(id_geo).sb(ll).Re(ii)), ...
            res.geo(id_geo).sb(ll).res(ii,jj), ...
            'o', 'Color',res.geo(id_geo).s_c{ll}, 'MarkerSize', 6-3)
            % 'Color',rgb('Navy'), 'MarkerSize', res.geo(id_geo).sb(.s_mk{2})
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
    for jj=1:3
        subplot(1,3,jj)
        h = semilogx(sb.U(res.geo(id_geo).sb(ll).Re(ii)), ...
            res.geo(id_geo).sb(ll).res(ii,jj+3), ...
            's', 'Color',res.geo(id_geo).s_c{ll}, 'MarkerSize', 6-2);
        h.MarkerFaceColor = h.Color;
    end
end
end

% %% [markdown]
% # FINE
