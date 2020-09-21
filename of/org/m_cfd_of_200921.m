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

s_dir = 'git/openfoam_seo/of/org/Mauritius';

seo_init

id_f = 1;
% id_sv = true;
id_sv = false;
% id_pl = true;
id_pl = false;

% id_jupyter = false;
id_jupyter = true;

% %%
clear seo

% %% [markdown]
% # Pre Process

% %%
s_angle_p = {'00','02','m2','04','m4','06','m6'};
angle_p   = [  0 ,  2 , -2 ,  4 , -4 ,  6 , -6];

% %%
id_angle = 5;

% %%
al = -angle_p(id_angle)*pi/180;
fprintf('Angle of attack: %d',(al*180/pi))
s_angle = s_angle_p(id_angle)

% %% [markdown]
% # Main Process

% %% [markdown]
% # Post Process

% %% [markdown]
% # FINE
