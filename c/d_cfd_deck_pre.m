% function out = d_cfd_deck_pre()
%
% d_cfd_deck_pre.m
%
% Model exported on Jul 11 2017, 22:08 by COMSOL 5.3.0.260.
%   Kim, Saang Bum
%   saangkim@gmail.com, sbkim1601@gmail.com, sbkimwind@gmail.com, sbkim@tesolution
%   Copyright (c) 1991-2017 by SeoHa Lab.
%   2017-06-12T09:08:47+09:00
%   2017-07-17T14:14:12+09:00
%   2017-09-06T00:07:58+09:00


%
%%  PART 0.     Opening
%
    fclose all; close all, clc, clear all, tic
    tcomp = tic;
    % s_dir = 'bridges/금빛노을/comsol/';
    % s_dir = 'bridges/웅천소호/comsol/';
    s_dir = 'bridges/우정의다리/comsol/comp/';
    % s_dir = 'bridges/Mauritius/comsol/';
    if 0
        % s_wdir = ['~/Work/Work/',s_dir];
        s_wdir = ['/home/sbkim/Work/',s_dir];
        cd( s_wdir );
        g_const = 9.80665;
        subindex = @(A,r,c) A(r,c);
    else
        [ subindex, id_f, id_pl, id_sv, g_const, s_d, s_dir, s_wdir ] = seo_init( s_dir );
    end
    tic
    id_f = 1;
    id_sv = true;
    % id_sv = false;
    id_pl = true;
    % id_pl = false;

    try
        % addpath('/usr/local/comsol52a/multiphysics/mli');
        addpath('/media/sbkim/7f2b85a5-d6fb-4859-81a4-6d7c5d628c00/usr/local/comsol53/multiphysics/mli');
        mphstart(2036);
        import com.comsol.model.*
        import com.comsol.model.util.*
    catch
        fprintf(1,'No comsol mphserver running or already connected!\n')
    end

    % [LASTMSG, LASTID] = lastwarn
    warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
    warning('OFF','Control:ltiobject:TFComplex')


%
%%  PART I.     Pre Process
%

    %
    %%  FILE IO
    %
        in_seok0 = 'log/d_cfd_deck_pre';
        in_seok = sprintf('%s_%s',in_seok0,datestr(now,'yymmdd_HHMMSS'));
        s_ifile = [in_seok,'_o'];

        % fid = fopen(s_ifile,'a+');
        fid = fopen(s_ifile,'w');
        fprintf(fid,'%% 0\n');
        fprintf(fid,'%% 1 CFD of bridge deck\n');
        fprintf(fid,'%% 2 Pre-process\n');
        fprintf(fid,'%% 3\n');
        fprintf(fid,'%% 4 Saang Bum Kim; sbkimwind@gmail.com\n');
        fprintf(fid,'%% 5\n');
        fprintf(fid,'%% 6 Date: %s\n',datestr(now));
        fprintf(fid,'%% 7\n');
        clear s_ifile_post ifile_p_ii ii id_ifile ifile_p

    %
    %%  Model
    %
        clear Wind seo

        %
        %%  Air
        %
            %   T   [degK]
            Wind.T0 = 273.15 + 20;
            Wind.T0 = 300;
            Wind.T0 = 291.15;                                                %   18 [degC]
            %   p   [Pa]
            Wind.p0 = 101.325e3;
            %   rho
            Wind.rho0 = Wind.p0*28.97e-3/8.314/Wind.T0;
            Wind.eta0o = -7.887E-12*Wind.T0^2+4.427E-08*Wind.T0+5.204E-06;
            Wind.eta0 = -8.38278000E-07 + Wind.T0*8.35717342E-08 - Wind.T0^2*7.69429583E-11 + Wind.T0^3*4.64372660E-14 - Wind.T0^4*1.06585607E-17;
            Wind.k0o = 10^(0.8616*log10(abs(Wind.T0))-3.7142);
            Wind.k0o = -2.27583562E-03 + Wind.T0*1.15480022E-04 + Wind.T0^2*-7.90252856E-08  + Wind.T0^3*4.11702505E-11 - Wind.T0^4*7.43864331E-15;
            Wind.nu0o = (-7.887E-12*Wind.T0^2+4.427E-08*Wind.T0+5.204E-06)/(Wind.p0*28.8e-3/8.314/Wind.T0);
            Wind.nu0 = -5.86912450E-06 + Wind.T0*5.01274491E-08 + Wind.T0^2*7.50108343E-11 + Wind.T0^3*1.80336823E-15 - Wind.T0^4*2.91688030E-18;
            Wind.cs0 = sqrt(1.4*287*Wind.T0);
            Wind.Cp0o = 0.0769*Wind.T0+1076.9;
            Wind.Cp0 = 1.04763657E+03 - Wind.T0*3.72589265E-01 + Wind.T0^2*9.45304214E-04 - Wind.T0^3*6.02409443E-07 + Wind.T0^4*1.28589610E-10;

            Wind.terrain = [
            %   al   zG  zb z0
                0.12 500 5  0.01;
                0.16 600 10 0.05;
                0.22 700 15 0.3;
                0.29 700 30 1.0;
            ];

        %
        %%  Design Wind
        %
            seo.id_terrain = 2;
            % seo.z = 21.907;
            seo.z = 49.194;
            seo.al = Wind.terrain(seo.id_terrain,1);

            seo.U_0 = 30.3;
            seo.U_d = seo.U_0*(Wind.terrain(2,2)/10)^Wind.terrain(2,1)*(seo.z/Wind.terrain(2,2))^seo.al;
            % seo.U_d = 30.44;
            seo.U_inf_F = 1.3*seo.U_d;

        %
        %%  Design Desk
        %
            % s_dxf_ifile = 'deck2.dxf';
            % s_dxf_ifile = 'friend_cs.dxf';
            % s_dxf_ifile = 'deck_comp_v2.dxf';
            s_dxf_ifile = 'deck_comp_v3.dxf';
            seo.lam_s = 1;

            model = m_cfd_deck_pre(s_wdir,s_dxf_ifile,seo);
            mphsave(model,'mph/cfd_deck_pre')

            % x = model.geom('geom1').getVertexCoord * 1e-3;
            % x = model.geom('geom1').getVertexCoord * 1e3;
            x = model.geom('geom1').getVertexCoord * 1e0;
            save mat/deck_vertices x

            seo.A_F = max(x') - min(x');
            seo.x_F = (max(x') + min(x'))/2;


            close(figure(1))
            hf1 = figure(1);
            clf
            plot(x(1,:)-seo.x_F(1),x(2,:)-seo.x_F(2), '-o','Color',[0 0 .5],'MarkerSize',6/2)
            axis equal
            grid
            gcfLFont
            xlabel('x-coordinate [$m$]')
            ylabel('y-coordinate [$m$]')
            xlim(seo.A_F(1)*[-1 1])
            % h = legend('Drag','Lift','Moment');
            % h.Interpreter = 'latex';
            % lx = h.Position;
            % h.Position = lx - [0 .5 0 0]*0;
            if id_sv
                export_fig -transparent -m3 f/deck.png
                close(hf1)
                % clear model
                % eval(sprintf('save mat/res_%s',datestr(now,'yymmdd_HHMMSS')));
            end
            clear x

            seo.St0 = 0.2;

            seo.Re = Wind.rho0 * seo.U_inf_F * seo.A_F / Wind.eta0;
            seo.T_vor = seo.A_F / seo.St0 / seo.U_inf_F;
            fprintf(fid,'\n');
            fprintf(fid,'Deck\n');
            fprintf(fid,'B:% 10.3f\nD:% 10.3f\n',seo.A_F(1),seo.A_F(2));
            fprintf(fid,'x:% 10.3f\ny:% 10.3f\n',seo.x_F(1),seo.x_F(2));
            fprintf(fid,'\n');
            fprintf(fid,'Wind\n');
            fprintf(fid,'Wind speed: % 10.3f\n',seo.U_inf_F);
            fprintf(fid,'Reynolds number: % 10.3e\n',seo.Re);
            fprintf(fid,'Period of vortex: % 10.3e\n',seo.T_vor);

        %
        %%  Wind Tunnel
        %
            if 1
                seo.lam_s = 80;
                seo.wtt.x = [6,1.5*2]*seo.lam_s;
                seo.lam_s = 1;
                seo.A = seo.A_F/seo.lam_s;
                seo.x = seo.x_F/seo.lam_s;
                seo.U_inf = seo.U_inf_F / (seo.lam_s^(1/2));
            else
                seo.lam_s = 80;
                seo.A = seo.A_F/seo.lam_s;
                seo.x = seo.x_F/seo.lam_s;
                seo.wtt.x = [6,1.5*2];
                seo.U_inf = seo.U_inf_F / (seo.lam_s^(1/2));
            end


clear model
eval(sprintf('save mat/res_cfd_deck_pre_%s',datestr(now,'yymmdd_HHMMSS')))
fprintf(1,'Elapsed time is % 11.1f minutes.\n',(toc - tcomp)/60);
fprintf(fid,'\nElapsed time is % 11.1f minutes.',(toc - tcomp)/60);
fprintf(fid,'\n');
fprintf(fid,'\n#');
fprintf(fid,'\n#   FINE');
fprintf(fid,'\n#');
fclose(fid);

%
%%  FINE
%