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

s_dir = 'git/openfoam_seo/wtt/jbk/';

p_comsol = 2036;
seo_init

id_f = 1;
% id_sv = true;
id_sv = false;
% id_pl = true;
id_pl = false;

% %% [markdown]
% # Longitudianl

% %%
sb.s_geo = 'longitudinal';
sb.Re = 150;
load(sprintf('tower_%s_turbulent_Re%d', sb.s_geo, sb.Re));
sb

% %%
sb.res.C

% %%
clear res
res.sb(1).s_geo = 'longitudinal';
res.sb(2).s_geo = 'transverse';

res.sb(1).s_mk{1} = 'o';
res.sb(2).s_mk{1} = 's';
res.sb(1).s_mk{2} = 4;
res.sb(2).s_mk{2} = 5;

id_pause = true;
figure(1)
clf


for kk = 1:2
for ii = 1:sb.Re_n
    res.sb(kk).Re(ii) = sb.Re_pool(ii);
    load(sprintf('tower_%s_turbulent_Re%d', res.sb(kk).s_geo, res.sb(kk).Re(ii)));
    res.sb(kk).res(ii,1:6) = sb.res(ii).C.DLM(1:6);
    
    for jj=1:3
        subplot(1,3,jj)
        semilogx(sb.U(res.sb(kk).Re(ii)), res.sb(kk).res(ii,jj), res.sb(kk).s_mk{1}, ...
            'Color',rgb('Navy'), 'MarkerSize', res.sb(kk).s_mk{2})        
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
    for jj=1:3
        subplot(1,3,jj)
        h = semilogx(sb.U(res.sb(kk).Re(ii)), res.sb(kk).res(ii,jj+3), res.sb(kk).s_mk{1}, ...
            'Color',rgb('Navy'), 'MarkerSize', res.sb(kk).s_mk{2});        
        h.MarkerFaceColor = h.Color;
    end
end
end

% %%
clear res
res.sb(1).s_geo = 'longitudinal';
res.sb(2).s_geo = 'transverse';

res.sb(1).s_mk{1} = 'o';
res.sb(2).s_mk{1} = 's';
res.sb(1).s_mk{2} = 4;
res.sb(2).s_mk{2} = 5;

id_pause = true;
figure(1)
clf


for kk = 1:2
for ii = 1:sb.Re_n
    res.sb(kk).Re(ii) = sb.Re_pool(ii);
    load(sprintf('tower_%s_turbulent_Re%d', res.sb(kk).s_geo, res.sb(kk).Re(ii)));
    res.sb(kk).res(ii,1:6) = sb.res(ii).C.DLM(1:6);
    
    for jj=1:3
        subplot(1,3,jj)
        semilogx(res.sb(kk).Re(ii), res.sb(kk).res(ii,jj), res.sb(kk).s_mk{1}, ...
            'Color',rgb('Navy'), 'MarkerSize', res.sb(kk).s_mk{2})        
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
    for jj=1:3
        subplot(1,3,jj)
        h = semilogx(res.sb(kk).Re(ii), res.sb(kk).res(ii,jj+3), res.sb(kk).s_mk{1}, ...
            'Color',rgb('Navy'), 'MarkerSize', res.sb(kk).s_mk{2});        
        h.MarkerFaceColor = h.Color;
    end
end
end

% %% [markdown]
% # FINE
