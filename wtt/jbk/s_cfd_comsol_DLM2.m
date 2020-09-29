% function sb = s_cfd_comsol_DLM(model, s_spf, s_dset, id_f)
function C = s_cfd_comsol_DLM2(model,sb,varargin)

% %%
    s_spf = 'spf2';
    s_dset = 'dset2';
    id_f = true;
    % s_B = 'seo_D';
    % s_D = 'seo_D';
    % s_DB = 'seo_D*seo_D';


% %%
    optargs = {s_spf,s_dset,id_f};

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
        [s_spf,s_dset] = optargs{:};

C.DLM(1,1) = mphint2(model, ...
    sprintf('-%s.T_stressx / (1/2*%s.rho*(seo_U_in^2))',s_spf,s_spf), ...
    'line','selection','box5','dataset',s_dset)/sb.D;
C.DLM(1,2) = mphint2(model, ...
    sprintf('-%s.T_stressy / (1/2*%s.rho*(seo_U_in^2))',s_spf,s_spf), ...
    'line','selection','box5','dataset',s_dset)/sb.D;
C.DLM(1,3) = mphint2(model, ...
    sprintf('(-%s.T_stressx*y + -%s.T_stressy*-x)/(1/2*%s.rho*(seo_U_in^2))', ...
        s_spf,s_spf,s_spf), ...
    'line','selection','box5','dataset',s_dset)/sb.D^2;

C.DLM(1,1+3) = mphint2(model, ...
    sprintf('(%s.nxmesh*p2 + %s.rho*%s.u_tau*%s.u_tangx/%s.uPlus) / (1/2*%s.rho*(seo_U_in^2))' ...
        ,s_spf,s_spf,s_spf,s_spf,s_spf,s_spf), ...
    'line','selection','box5','dataset',s_dset)/sb.D;
C.DLM(1,2+3) = mphint2(model, ...
    sprintf('(%s.nymesh*p2 + %s.rho*%s.u_tau*%s.u_tangy/%s.uPlus) / (1/2*%s.rho*(seo_U_in^2))' ...
        ,s_spf,s_spf,s_spf,s_spf,s_spf,s_spf), ...
    'line','selection','box5','dataset',s_dset)/sb.D;
C.DLM(1,3+3) = mphint2(model, ...
    sprintf('((%s.nxmesh*p2 + %s.rho*%s.u_tau*%s.u_tangx/%s.uPlus)*y + (%s.nymesh*p2 + %s.rho*%s.u_tau*%s.u_tangy/%s.uPlus)*-x)/(1/2*%s.rho*(seo_U_in^2))' ...
        ,s_spf,s_spf,s_spf,s_spf,s_spf,s_spf,s_spf,s_spf,s_spf,s_spf,s_spf), ...
    'line','selection','box5','dataset',s_dset)/sb.D^2;

if id_f
    id_pause = true;
    figure(1)
    % clf
    ii = 1;
    for jj = 1:3
        subplot(1,3,jj)
        plot(sb.Re, C.DLM(ii,jj),'o','Color',rgb('Navy'),'MarkerSize',6-3)
    end
    if id_pause
        gcfG;gcfH;gcfLFont;gcfS;%gcfP
        id_pause = false;
    end
    ii = 1;
    for jj = 1:3
        subplot(1,3,jj)
        h = plot(sb.Re, C.DLM(ii,jj+3),'o','Color',rgb('Navy'),'MarkerSize',6-3);
        h.MarkerFaceColor = h.Color;
    end
end

%
%%  FINE
%
