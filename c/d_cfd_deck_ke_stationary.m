% function out = d_cfd_deck_turbulent()
%
% d_cfd_deck_turbulent.m
%
% Model exported on Jul 11 2017, 22:08 by COMSOL 5.3.0.260.
%   Kim, Saang Bum
%   saangkim@gmail.com, sbkim1601@gmail.com, sbkimwind@gmail.com, sbkim@tesolution
%   Copyright (c) 1991-2017 by SeoHa Lab.
%   2017-06-12T09:08:47+09:00
%   2017-07-17T14:14:12+09:00
%   2017-09-22T19:16:12+09:00

%
%%  PART 0.     Opening
%
    fclose all; close all, clc, clear all, tic
    tcomp = tic;
    % s_dir = 'bridges/금빛노을/comsol/';
    % s_dir = 'bridges/우정의다리/comsol/comp/';
    s_dir = 'bridges/Myanmar/comsol/operation/';
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
        s_u = getenv('UserDOMAIN');
        if strcmpi(s_u,'bnes')
            addpath('g:/Program Files/COMSOL/COMSOL53/Multiphysics/mli');
        else
            addpath('/media/sbkim/7f2b85a5-d6fb-4859-81a4-6d7c5d628c00/usr/local/comsol53/multiphysics/mli');
        end
        mphstart(2036);
        % mphstart(2037);
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
        in_seok0 = 'log/d_cfd_deck_turbulence';
        in_seok = sprintf('%s_%s',in_seok0,datestr(now,'yymmdd_HHMMSS'));
        s_ifile = [in_seok,'_o'];

        % fid = fopen(s_ifile,'a+');
        fid = fopen(s_ifile,'w');
        fprintf(fid,'%% 0\n');
        fprintf(fid,'%% 1 CFD of bridge deck\n');
        fprintf(fid,'%% 2 Turbulence k-e\n');
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
            try
                model = mphload('mph/cfd_deck_pre');
            catch
                model = m_cfd_deck_pre(s_wdir,s_dxf_ifile,seo);
                mphsave(model,'mph/cfd_deck_pre')
            end

            try
                load mat/deck_vertices x
                if 0
                    x = x * 1e3;
                    save mat/deck_vertices x
                end
            catch
                % x = model.geom('geom1').getVertexCoord * 1e-3;
                % x = model.geom('geom1').getVertexCoord * 1e3;
                x = model.geom('geom1').getVertexCoord;
                save mat/deck_vertices x
            end
            seo.A_F = max(x') - min(x');
            seo.x_F = (max(x') + min(x'))/2;
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
            if 0
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

        %
        %   Turbulence model
        %
            Wind.C_mu = 0.09;
            Wind.C_e1 = 1.44;
            Wind.C_e2 = 1.92;
            Wind.C_3RDT = -0.33;
            Wind.sig_k = 1;
            Wind.sig_e = 1.3;
            Wind.k_nu = 0.41;
            Wind.k_B = 5.2;

            % seo.U_inf = 4918;
            seo.I_u = 0.05;
            seo.L_t = seo.A(1)*0.07;

            Wind.ke_k = 3/2*(seo.U_inf*seo.I_u).^2;
            Wind.ke_e = (Wind.C_mu^0.75)*(Wind.ke_k.^1.5)./(seo.L_t);
            Wind.ke_nu = Wind.C_mu*(Wind.ke_k.^2)./Wind.ke_e;
            Wind.ke_nu_tild = Wind.ke_nu * 5;

            Wind.ke_lmix = (Wind.C_mu)*(Wind.ke_k.^1.5)./(Wind.ke_e);


%
%%  PART II.    Simulation
%
if 1
% if 0
    % Re_pool_ke = [1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9];
    Re_pool_ke = [];
    Re_pool_ke(1) = 100;
    Re_pool_ke(2) = 1000;
    seo.U_inf = 5;
    seo.Re = Wind.rho0 * seo.U_inf * seo.A / Wind.eta0;
    Re_pool_ke(3) = seo.Re(1);
    seo.U_inf = 10;
    seo.Re = Wind.rho0 * seo.U_inf * seo.A / Wind.eta0;
    Re_pool_ke(4) = seo.Re(1);
    seo.U_inf = 5;
    seo.Re = Wind.rho0 * seo.U_inf * seo.A_F / Wind.eta0;
    Re_pool_ke(5) = seo.Re(1);
    seo.U_inf = 10;
    seo.Re = Wind.rho0 * seo.U_inf * seo.A_F / Wind.eta0;
    Re_pool_ke(6) = seo.Re(1);
    seo.U_inf = 50;
    seo.Re = Wind.rho0 * seo.U_inf * seo.A_F / Wind.eta0;
    Re_pool_ke(7) = seo.Re(1);
    seo.U_inf = 100;
    seo.Re = Wind.rho0 * seo.U_inf * seo.A_F / Wind.eta0;
    Re_pool_ke(8) = seo.Re(1);
    n = length(Re_pool_ke);

    al_p = [-6:2:6];
    m = length(al_p);

    try
        save mat/res_ke_pre
    end

    % C_DLM_ke = zeros(n,m,3,3,8,2);
    C_DLM_ke = ones(n,m,3,3,8,2)*NaN;

    for ii = 1:n
    % for ii = 1
    % for ii = 3
    % for ii = 4

    for jj = 1:m
    % for jj = 4
        % jj = 1;
        % jj = 4;

        seo.alpha = al_p(jj);
        fprintf(fid,'\nAngle of attack: %03d [deg]',seo.alpha);
        fprintf(1,'\nAngle of attack: %03d [deg]',seo.alpha)
        tcomp = toc;

        seo.U_inf = Re_pool_ke(ii) * Wind.eta0 ./ (Wind.rho0 * seo.A);
        seo.T_vor = seo.A / seo.St0 ./ seo.U_inf;
        seo.Re = Wind.rho0 * seo.U_inf .* seo.A / Wind.eta0;
        fprintf(fid,'\n');
        fprintf(fid,'\nWind speed: % 10.3g, % 10.3g',seo.U_inf);
        fprintf(fid,'\nReynolds number: % 10.3g, % 10.3g',seo.Re);
        fprintf(fid,'\nPeriod of vortex: % 10.3g, % 10.3g',seo.T_vor);
        seo.U_inf = seo.U_inf(1);
        seo.T_vor = seo.T_vor(1);
        seo.Re = seo.Re(1);

        % seo.U_inf = 4918;
        % seo.I_u = 0.05;
        % seo.L_t = seo.A(1)*0.07;

        Wind.ke_k = 3/2*(seo.U_inf*seo.I_u).^2;
        Wind.ke_e = (Wind.C_mu^0.75)*(Wind.ke_k.^1.5)./(seo.L_t);
        Wind.ke_nu = Wind.C_mu*(Wind.ke_k.^2)./Wind.ke_e;
        Wind.ke_nu_tild = Wind.ke_nu * 5;

        Wind.ke_lmix = (Wind.C_mu)*(Wind.ke_k.^1.5)./(Wind.ke_e);

        fprintf(fid,'\nKinetic energy, k: % 10.3g',Wind.ke_k);
        fprintf(fid,'\nDissipation rate, e: % 10.3g',Wind.ke_e);
        fprintf(fid,'\nnu: % 10.3g',Wind.ke_nu);
        fprintf(fid,'\nnu_tilda: % 10.3g',Wind.ke_nu_tild);
        fprintf(fid,'\nl_mix: % 10.3g',Wind.ke_lmix);

        seo.mesh.id_bd = 8;
        seo.mesh.id_ft = 9;

        % for id_ft = 8:-1:1
        for id_ft = 8:-1:3
        for id_bd = id_ft:-1:max(1,id_ft-1)

            seo.mesh.id_ft = id_ft;
            seo.mesh.id_bd = id_bd;

            try
                model = mphload(sprintf('mph/deck_ke_stationary_ReL%03d_al%02d_m%d%d',10*log10(Re_pool_ke(ii)),jj,id_ft,id_bd));
                id_run = true;
            catch
                fprintf(fid,'\nNo saved mph file.');
                fprintf(1,'\nNo saved mph file.')
                try
                    [model,Wind,seo] = m_cfd_deck_ke_stationary(Wind,seo,s_wdir,s_dxf_ifile);
                    mphsave(model,sprintf('mph/deck_ke_stationary_ReL%03d_al%02d_m%d%d',10*log10(Re_pool_ke(ii)),jj,id_ft,id_bd))
                    fprintf(1,'\nElapsed time is % 11.1f minutes.',(toc - tcomp)/60)
                    fprintf(fid,'\nElapsed time is % 11.1f minutes.',(toc - tcomp)/60);
                    tcomp = toc;
                    id_run = true;
                catch
                    fprintf(fid,'\nNo convergence solution.');
                    fprintf(1,'\nNo convergence solution.')
                    % break
                    id_run = false;
                end
            end

            if id_run
                s_dset = 'dset1';

                C_D = mphint2(model,'-reacf(u)/(1/2*spf.rho*seoD*U_inf^2)', ...
                    'line','selection','box1','dataset',s_dset);
                % C_D = mphint2(model,'-(reacf(u)*cos(seoal*pi/180)+reacf(v)*sin(seoal*pi/180))/(1/2*spf.rho*seoD*U_inf^2)', ...
                %     'line','selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,1,1) = C_D;
                C_DLM_ke(ii,jj,1,1,id_ft,id_bd-id_ft+2) = C_D;
                % C_DLM_ke(id_ft,id_bd,1,1) = C_D;
                C_D = mphint2(model,'-spf.T_stressx/(1/2*spf.rho*seoD*U_inf^2)', ...
                    'line','selection','box1','dataset',s_dset);
                % C_D = mphint2(model,'-(spf.T_stressx*cos(seoal*pi/180)+spf.T_stressy*sin(seoal*pi/180))/(1/2*spf.rho*seoD*U_inf^2)', ...
                %     'line','selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,1,2) = C_D;
                C_DLM_ke(ii,jj,1,2,id_ft,id_bd-id_ft+2) = C_D;
                % C_DLM_ke(id_ft,id_bd,1,2) = C_D;
                C_D = mphint2(model,'(spf.nxmesh*p + spf.rho*spf.u_tau*spf.u_tangx/spf.uPlus)/(1/2*spf.rho*seoD*U_inf^2)', ...
                    'line','selection','box1','dataset',s_dset);
                % C_D = mphint2(model,'((spf.nxmesh*p + spf.rho*spf.u_tau*spf.u_tangx/spf.uPlus)*cos(seoal*pi/180)+(spf.nymesh*p + spf.rho*spf.u_tau*spf.u_tangy/spf.uPlus)*sin(seoal*pi/180))/(1/2*spf.rho*seoD*U_inf^2)', ...
                    % 'line','selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,1,3) = C_D;
                C_DLM_ke(ii,jj,1,3,id_ft,id_bd-id_ft+2) = C_D;
                % C_DLM_ke(id_ft,id_bd,1,3) = C_D;

                C_L = mphint2(model,'-reacf(v)/(1/2*spf.rho*seoB*U_inf^2)','line', ...
                    'selection','box1','dataset',s_dset);
                % C_L = mphint2(model,'-(-reacf(u)*sin(seoal*pi/180)+reacf(v)*cos(seoal*pi/180))/(1/2*spf.rho*seoB*U_inf^2)','line', ...
                %     'selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,2,1) = C_L;
                C_DLM_ke(ii,jj,2,1,id_ft,id_bd-id_ft+2) = C_L;
                % C_DLM_ke(id_ft,id_bd,2,1) = C_L;
                C_L = mphint2(model,'-spf.T_stressy/(1/2*spf.rho*seoB*U_inf^2)', ...
                    'line','selection','box1','dataset',s_dset);
                % C_L = mphint2(model,'-(-spf.T_stressx*sin(seoal*pi/180)+spf.T_stressy*cos(seoal*pi/180))/(1/2*spf.rho*seoB*U_inf^2)', ...
                %     'line','selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,2,2) = C_L;
                C_DLM_ke(ii,jj,2,2,id_ft,id_bd-id_ft+2) = C_L;
                % C_DLM_ke(id_ft,id_bd,2,2) = C_L;
                C_L = mphint2(model,'(spf.nymesh*p + spf.rho*spf.u_tau*spf.u_tangy/spf.uPlus)/(1/2*spf.rho*seoB*U_inf^2)', ...
                    'line','selection','box1','dataset',s_dset);
                % C_L = mphint2(model,'(-(spf.nxmesh*p + spf.rho*spf.u_tau*spf.u_tangx/spf.uPlus)*sin(seoal*pi/180)+(spf.nymesh*p + spf.rho*spf.u_tau*spf.u_tangy/spf.uPlus)*cos(seoal*pi/180))/(1/2*spf.rho*seoB*U_inf^2)', ...
                    % 'line','selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,2,3) = C_L;
                C_DLM_ke(ii,jj,2,3,id_ft,id_bd-id_ft+2) = C_L;
                % C_DLM_ke(id_ft,id_bd,2,3) = C_L;

                % RM: nose down
                C_M = mphint2(model,'-1*-(y*reacf(u)-x*reacf(v))/(1/2*spf.rho*seoB^2*U_inf^2)', ...
                    'line','selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,3,1) = C_M;
                C_DLM_ke(ii,jj,3,1,id_ft,id_bd-id_ft+2) = C_M;
                % C_DLM_ke(id_ft,id_bd,3,1) = C_M;
                C_M = mphint2(model,'-1*-(y*spf.T_stressx-x*spf.T_stressy)/(1/2*spf.rho*seoB^2*U_inf^2)', ...
                    'line','selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,3,2) = C_M;
                C_DLM_ke(ii,jj,3,2,id_ft,id_bd-id_ft+2) = C_M;
                % C_DLM_ke(id_ft,id_bd,3,2) = C_M;
                C_M = mphint2(model,'-1* (y*(spf.nxmesh*p + spf.rho*spf.u_tau*spf.u_tangx/spf.uPlus)-x*(spf.nymesh*p + spf.rho*spf.u_tau*spf.u_tangy/spf.uPlus))/(1/2*spf.rho*seoB^2*U_inf^2)', ...
                    'line','selection','box1','dataset',s_dset);
                % C_DLM_ke(ii,jj,3,3) = C_M;
                C_DLM_ke(ii,jj,3,3,id_ft,id_bd-id_ft+2) = C_M;
                % C_DLM_ke(id_ft,id_bd,3,3) = C_M;
            end
        end
        end

        % figure(1)
        % subplot(131)
        % for id_DLM = 1:3
        % clf
        % plot(C_DLM_ke(ii,jj,id_DLM,2))
        % hold on
        % plot(C_DLM_ke(ii,jj,id_DLM,2))
        % plot(C_DLM_ke(ii,jj,id_DLM,3))
        % plot(C_DLM_ke(ii,jj,id_DLM,3))
        % % pause
        % end
            save mat/res_ke C_DLM_ke
        end
    end
else
    load mat/res_ke C_DLM_ke
end

    % s_DLM = {'$C_D$','$C_L$','$C_M$'};
    s_DLM = {'Drag','Lift','Moment'};
    close(figure(1))
    hf1 = figure(1);
%     clf
    id_mesh = [8:-1:1];
    for id_CLM = 1:3
        subplot(1,3,id_CLM)
        for i1=1:3
            C_DLM_i = squeeze(C_DLM_ke(ii,jj,id_CLM,i1,id_mesh,2))*seo.A(2)/seo.A(1);
            C_DLM_i(C_DLM_i == 0) = NaN;
            C_DLM_i = fillmissing(C_DLM_i,'pchip');
            plot(C_DLM_i, '--o','Color',[0 0 .5], 'MarkerSize', 6/2)
            if i1 == 1
                hold on
                grid
                gcfLFont
                xlabel('Mesh resolution')
                % ylabel('Wind load coefficients')
                ylabel(s_DLM{id_CLM})
            end
            C_DLM_i = squeeze(C_DLM_ke(ii,jj,id_CLM,i1,id_mesh,1))*seo.A(2)/seo.A(1);
            C_DLM_i(C_DLM_i == 0) = NaN;
            C_DLM_i = fillmissing(C_DLM_i,'pchip');
            plot(C_DLM_i, '-s','Color',[0 0 .5], 'MarkerSize', 6/2)
        end
    end

%     plot(Re_pool(1:end-1), C_DLM2(1:end-1,1)*seo.A(2)/seo.A(1), '-o','Color',[0 0 .5])
%     hold on
%     plot(Re_pool(1:end-1), C_DLM2(1:end-1,2), '-^','Color',[0 0 .5])
%     plot(Re_pool(1:end-1),-C_DLM2(1:end-1,3), '-s','Color',[0 0 .5])
%     plot(Re_pool(1:end-1), C_DLM1(1:end-1,1)*seo.A(2)/seo.A(1), ':o','Color',[0 .5 0])
%     plot(Re_pool(1:end-1), C_DLM1(1:end-1,2), ':^','Color',[0 .5 0])
%     plot(Re_pool(1:end-1),-C_DLM1(1:end-1,3), ':s','Color',[0 .5 0])
%     hold off
%     grid
%     gcfLFont
%     xlabel('Reynolds number')
%     ylabel('Wind load coefficients')
%     h = legend('Drag','Lift','Moment');
%     h.Interpreter = 'latex';
%     lx = h.Position;
%     h.Position = lx - [0 .5 0 0]*0;
%     figure(hf1);
%     hold on
%     plot(Re_pool_ke, (C_DLM_ke(:,4,1,2))*seo.A(2)/seo.A(1), ':o','Color',rgb('ForestGreen'))
%     plot(Re_pool_ke, (C_DLM_ke(:,4,1,3))*seo.A(2)/seo.A(1), '-o','Color',rgb('Navy'))
%     set(gca,'XScale','log')
%     plot(Re_pool_ke, (C_DLM_ke(:,4,2,2)), ':^','Color',rgb('ForestGreen'))
%     plot(Re_pool_ke, (C_DLM_ke(:,4,2,3)), '-^','Color',rgb('Navy'))
%     plot(Re_pool_ke,-(C_DLM_ke(:,4,3,2)), ':s','Color',rgb('ForestGreen'))
%     plot(Re_pool_ke,-(C_DLM_ke(:,4,3,3)), '-s','Color',rgb('Navy'))
%     h = legend('Drag','Lift','Moment');

%     % export_fig -transparent -m3 f/C_DLM_ke_Re.png


%     id_Re = 3;
%     hf2 = figure(2);
%     clf
%     plot(al_p, (C_DLM_ke(end,:,1,2))*seo.A(2)/seo.A(1), ':o','Color',rgb('ForestGreen'))
%     % plot(al_p, (C_DLM_ke(id_Re,:,1,2)), ':o','Color',rgb('ForestGreen'))
%     hold on
%     grid
%     gcfLFont
%     xlabel('Angle of attack [$^o$]')
%     ylabel('Wind load coefficients')
%     plot(al_p, (C_DLM_ke(id_Re,:,1,3))*seo.A(2)/seo.A(1), '-o','Color',rgb('MidnightBlue'))
%     % plot(al_p, (C_DLM_ke(id_Re,:,1,3)), '-o','Color',rgb('MidnightBlue'))
%     plot(al_p, (C_DLM_ke(id_Re,:,2,2)), ':^','Color',rgb('ForestGreen'))
%     plot(al_p, (C_DLM_ke(id_Re,:,2,3)), '-^','Color',rgb('MidnightBlue'))
%     plot(al_p,-(C_DLM_ke(id_Re,:,3,2)), ':s','Color',rgb('ForestGreen'))
%     plot(al_p,-(C_DLM_ke(id_Re,:,3,3)), '-s','Color',rgb('MidnightBlue'))
%     h = legend(subindex(get(gca,'Children'),[5,3,1],1),'Drag','Lift','Moment');
%     h.Location = 'northwest';
%     h.Interpreter = 'latex';
%     lx = h.Position;
%     h.Position = lx - [0 .5 0 0]*0;

%     C_DLM_wtt = [
%         0.146   -0.536  0.055
%         0.138   -0.370  0.008
%         0.128   -0.232  -0.033
%         0.119   -0.100  -0.061
%         0.118   0.059   -0.096
%         0.129   0.240   -0.127
%         0.165   0.509   -0.141
%     ];
%     plot(al_p,C_DLM_wtt(:,1),'--o','Color',[1,0,0])
%     % plot(al_p,C_DLM_wtt(:,1)*seo.A(1)/seo.A(2),'--o','Color',[1,0,0])
%     plot(al_p,C_DLM_wtt(:,2),'--^','Color',[1,0,0])
%     plot(al_p,C_DLM_wtt(:,3),'--s','Color',[1,0,0])
%     h = legend;
%     h.Interpreter = 'latex';
%     h = legend(subindex(get(gca,'Children'),[8,6,4,3,2,1],1), ...
%         '$\mathrm{Drag}_\mathrm{CFD}$','$\mathrm{Lift}_\mathrm{CFD}$','$\mathrm{Moment}_\mathrm{CFD}$', ...
%         '$\mathrm{Drag}_\mathrm{WTT}$','$\mathrm{Lift}_\mathrm{WTT}$','$\mathrm{Moment}_\mathrm{WTT}$');

%     % export_fig -transparent -m3 f/C_DLM_ke_al.png


%     ii = 3;
%     jj = 2;
%     jj = 6;
%     jj = 4;
%     model = mphload(sprintf('mph/deck_ke_stationary_ReL%03d_al%02d',10*log10(Re_pool_ke(ii)),jj));



%     % close(gcf)
%     close(figure(3))
%     figure(3)
%     clf
%     mphmesh(model,'mesh1')
%     xl = xlim;
%     xy = ylim;
%     xlabel('')
%     ylabel('')
%     title('')
%     gcfLFont
%     axis off
%     maximize

%     h = gca;
%     h1 = h.Children;
%     h1(1).EdgeColor = 'none';
%     h1(2).EdgeColor = 'none';
%     h1(4).EdgeColor = 'none';
%     h1(3).LineWidth = 1e-3;
%     h1(5).LineWidth = 1e-3;
%     h1(3).EdgeColor = 'k';
%     h1(5).EdgeColor = 'k';

%     cva = h.CameraViewAngle;
%     h.CameraViewAngle = cva * .5;

%     % export_fig -transparent -m3 f/meshFull.png
%     % export_fig -transparent f/meshFull1.png

%     xlim([-1 1]*seo.A(1)/2*1.5)
%     h.CameraViewAngle = cva * .4;
%     % export_fig -transparent f/meshDetail_00.png
%     % export_fig -transparent -m3 f/meshDetail_m4.png
%     % export_fig -transparent -m3 f/meshDetail_p4.png

%     model.result.remove('pg1');
%     model.result.create('pg1', 'PlotGroupD');
%     model.result('pg1').label('Velocity (spf)');
%     model.result('pg1').set('frametype', 'spatial');
%     try
%         model.result('pg1').set('data', 'dset4');
%     catch
%         model.result('pg1').set('data', 'dset1');
%     end
%     model.result('pg1').feature.create('surf1', 'Surface');
%     model.result('pg1').feature('surf1').label('Surface');
%     model.result('pg1').feature('surf1').set('data', 'parent');
%     close(figure(3))
%     figure(3)
%     mphplot(model,'pg1')
%     xl = xlim;
%     xy = ylim;
%     xlabel('')
%     ylabel('')
%     title('')
%     gcfLFont
%     axis off
%     maximize
%     h = gca;
%     h1 = h.Children;
%     h1(1).EdgeColor = 'none';
%     cva = h.CameraViewAngle;
%     xlim([-2 5]*seo.A(1)/2*1.5)
%     h.CameraViewAngle = cva * .4;
%     % export_fig -transparent -m3 f/U.png


%     model.result.remove('pg1');
%     model.result.create('pg1', 'PlotGroup2D');
%     model.result('pg1').label('Pressure (spf)');
%     try
%         model.result('pg1').set('data', 'dset4');
%     catch
%         model.result('pg1').set('data', 'dset1');
%     end
%     model.result('pg1').set('frametype', 'spatial');
%     model.result('pg1').feature.create('con1', 'Contour');
%     model.result('pg1').feature('con1').label('Contour');
%     model.result('pg1').feature('con1').set('expr', 'p');
%     model.result('pg1').feature('con1').set('number', 40);
%     model.result('pg1').feature('con1').set('data', 'parent');
%     % model.result('pg1').set('edges', false);
%     model.result('pg1').feature('con1').set('contourtype', 'filled');
%     close(figure(3))
%     figure(3)
%     mphplot(model,'pg1')
%     xl = xlim;
%     xy = ylim;
%     xlabel('')
%     ylabel('')
%     title('')
%     gcfLFont
%     axis off
%     maximize
%     h = gca;
%     h1 = h.Children;
%     h1(1).EdgeColor = 'none';
%     cva = h.CameraViewAngle;
%     % xlim([-2 5]*seo.A(1)/2*1.5)
%     xlim([-2 2]*seo.A(1)/2*1.5)
%     h.CameraViewAngle = cva * .4;
%     % export_fig -transparent -m3 f/p.png


% if 0
%     close(hf1)
%     close(hf2)
%     clear hf1 fh2 h

%     clear model
%     eval(sprintf('save mat/res_%s',datestr(now,'yymmdd_HHMMSS')));
% end


%%  stop the clock !!!
    tcomp = toc;
    fprintf(1,'Elapsed Time = % 12.4f Seconds.\n',(toc - tcomp)/60);
    fprintf(fid,'\nElapsed Time = % 12.4f Seconds.\n',(toc - tcomp)/60);
    fprintf(fid,'\n%%');
    fprintf(fid,'\n%%%%  FINE');
    fprintf(fid,'\n%%');
    %   e : +8
    try,
        beep
        beep
        beep
    end

% close all
% fclose all

return


%
%%  FINE
%