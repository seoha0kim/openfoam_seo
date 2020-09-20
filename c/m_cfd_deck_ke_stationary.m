function [out,Wind,seo] = m_cfd_deck_ke_ke_stationary(Wind,seo,s_wdir,s_dxf_ifile)
%
% m_cfd_deck_laminar.m
%
% Model exported on Jul 11 2017, 22:08 by COMSOL 5.3.0.260.

import com.comsol.model.*
import com.comsol.model.util.*

ModelUtil.showProgress(false);

model = m_cfd_deck_pre(s_wdir,s_dxf_ifile,seo);
% [model,Wind,seo] = m_cfd_deck_ke(Wind,seo,s_wdir,s_dxf_ifile);

model.label('cfd_deck_ke_stationary.mph');

% model.comments(['Untitled\n\n']);
model.comments(['Flow Around an Inclined NACA 0012 Airfoil\n\nThis example simulates the flow around an inclined NACA 0012 airfoil at different angles of attack using the SST turbulence model. The results show good agreement with the experimental lift data of Ladson and the pressure data of Gregory and O' native2unicode(hex2dec({'20' '19'}), 'unicode') 'Reilly.']);

model.component('comp1').mesh.create('mesh1');

% model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');
% model.component('comp1').physics.create('spf', 'TurbulentFlowSST', 'geom1');

% model.study.create('std1');
% model.study('std1').create('time', 'Transient');
% model.study('std1').feature('time').activate('spf', true);

% model.study.create('std1');
% model.study('std1').create('wdi', 'WallDistanceInitialization');
% model.study('std1').feature('wdi').set('solnum', 'auto');
% model.study('std1').feature('wdi').set('notsolnum', 'auto');
% model.study('std1').feature('wdi').set('ngen', '5');
% model.study('std1').feature('wdi').activate('spf', true);
% model.study('std1').create('stat', 'Stationary');
% model.study('std1').feature('stat').set('solnum', 'auto');
% model.study('std1').feature('stat').set('notsolnum', 'auto');
% model.study('std1').feature('stat').set('ngen', '5');
% model.study('std1').feature('stat').activate('spf', true);

    model.param.set('seoA', sprintf('%.2f[m]',max(seo.A)));
    model.param.set('seoB', sprintf('%.2f[m]',seo.A(1)));
    model.param.set('seoD', sprintf('%.2f[m]',seo.A(2)));
    model.param.set('seox0', sprintf('%.2f[m]',seo.x(1)));
    model.param.set('seoy0', sprintf('%.2f[m]',seo.x(2)));

    model.param.set('seoiL1', sprintf('%.2f[m]',seo.A(1)*2));
    model.param.set('seoiL2', sprintf('%.2f[m]',seo.A(2)*5*2));
    model.param.set('seooL1', sprintf('%.2f[m]',seo.wtt.x(1)*1.5/6));
    model.param.set('seooL2', sprintf('%.2f[m]',seo.wtt.x(1)*4.5/6));
    model.param.set('seooL3', sprintf('%.2f[m]',seo.wtt.x(2)*.5));

    model.param.set('seoal', sprintf('%.2f[deg]',seo.alpha));

    model.param.set('U_inf', sprintf('%f[m/s]',seo.U_inf));
    model.param.set('T_vor', sprintf('%f[s]',seo.T_vor));

    model.param.set('sc_ke', '1');

    model.param.set('seo_k', '3/2*(U_inf*0.05)^2');
    model.param.set('seo_e', '0.09^0.75*seo_k^1.5/(seoB*0.07)');
    model.param.set('seo_lmix', '0.09*seo_k^(3/2)/seo_e');

fprintf(1,'\nke: Re: %.3g, U: %.3g, T: %.3g s.\n',seo.Re,seo.U_inf,seo.T_vor);

    % model.param.set('rho_inf', '1.2043[kg*m^-3]', 'Free-stream density');
    % model.param.set('mu_inf', '1.81397e-5[kg*m^-1*s^-1]', 'Free-stream dynamic viscosity');
    % % model.param.set('L', '180[m]', 'Domain reference length');
    % model.param.set('L', '100[m]', 'Domain reference length');
    % model.param.set('c', '37[m]', 'Chord length');
    % model.param.set('k_inf', '0.1*mu_inf*U_inf/(rho_inf*L)', 'Free-stream turbulent kinetic energy');
    % model.param.set('om_inf', '10*U_inf/L', 'Free-stream specific dissipation rate');

model.component('comp1').geom('geom1').run;
model.component('comp1').geom('geom1').run('csol1');

model.component('comp1').geom('geom1').create('mov1', 'Move');
% model.component('comp1').geom('geom1').feature.move('mov1', 5);
model.component('comp1').geom('geom1').feature('mov1').selection('input').set({'csol1'});
model.component('comp1').geom('geom1').feature('mov1').set('displx', '-seox0');
model.component('comp1').geom('geom1').feature('mov1').set('disply', '-seoy0');

% model.component('comp1').geom('geom1').create('mir1', 'Mirror');
% model.component('comp1').geom('geom1').feature('mir1').selection('input').set({'mov1'});
% model.component('comp1').geom('geom1').run('mir1');

model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('pos', {'-seoiL1/2' '-seoiL2/2*3/2'});
model.component('comp1').geom('geom1').feature('r1').set('size', {'seoiL1*3/2' 'seoiL2*3/2'});

% model.component('comp1').geom('geom1').create('c1', 'Circle');
% model.component('comp1').geom('geom1').feature('c1').set('r', 'seoiL');

model.component('comp1').geom('geom1').create('rot1', 'Rotate');
model.component('comp1').geom('geom1').feature('rot1').selection('input').set({'mov1'});
% model.component('comp1').geom('geom1').feature('rot1').selection('input').set({'mir1'});
model.component('comp1').geom('geom1').feature('rot1').set('rot', '-seoal');

model.component('comp1').geom('geom1').create('rot2', 'Rotate');
model.component('comp1').geom('geom1').feature('rot2').selection('input').set({'r1'});
model.component('comp1').geom('geom1').feature('rot2').set('rot', '-seoal');

model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('pos', {'-seooL1' '-seooL3'});
model.component('comp1').geom('geom1').feature('r2').set('size', {'seooL1+seooL2' 'seooL3*2'});

model.component('comp1').geom('geom1').create('co1', 'Compose');
model.component('comp1').geom('geom1').feature('co1').selection('input').set({'rot1' 'rot2' 'r2'});
model.component('comp1').geom('geom1').feature('co1').set('formula', '(r2-rot2)+(rot2-rot1)');

model.component('comp1').geom('geom1').run;

    model.component('comp1').selection.create('box1', 'Box');
    model.component('comp1').selection('box1').set('entitydim', 1);
    model.component('comp1').selection('box1').set('condition', 'inside');
    model.component('comp1').selection('box1').set('xmax', 'seoB/2*1.5');
    model.component('comp1').selection('box1').set('xmin', '-seoB/2*1.5');
    model.component('comp1').selection('box1').set('ymax', 'seoB/2*1.5');
    model.component('comp1').selection('box1').set('ymin', '-seoB/2*1.5');
    model.component('comp1').selection('box1').label('deck');

% model.component('comp1').selection.create('disk1', 'Disk');
% model.component('comp1').selection('disk1').set('r', 'seoiL*0.975');
% model.component('comp1').selection('disk1').set('entitydim', 1);

    model.component('comp1').selection.create('box2', 'Box');
    model.component('comp1').selection('box2').set('entitydim', 1);
    model.component('comp1').selection('box2').set('condition', 'inside');
    % model.component('comp1').selection('box2').set('condition', 'intersects');
    model.component('comp1').selection('box2').set('xmin', '-seooL1*1.1');
    model.component('comp1').selection('box2').set('xmax', '-seooL1*.9');
    model.component('comp1').selection('box2').set('ymin', '-seooL3*1.1');
    model.component('comp1').selection('box2').set('ymax', ' seooL3*1.1');
    model.component('comp1').selection('box2').label('inlet');

    model.component('comp1').selection.create('box3', 'Box');
    model.component('comp1').selection('box3').set('entitydim', 1);
    model.component('comp1').selection('box3').set('condition', 'inside');
    % model.component('comp1').selection('box3').set('condition', 'intersects');
    model.component('comp1').selection('box3').set('xmax', 'seooL2*1.1');
    model.component('comp1').selection('box3').set('xmin', 'seooL2*0.9');
    model.component('comp1').selection('box3').set('ymin', '-seooL3*1.1');
    model.component('comp1').selection('box3').set('ymax', ' seooL3*1.1');
    model.component('comp1').selection('box3').label('outlet');

    model.component('comp1').selection.create('box4', 'Box');
    model.component('comp1').selection('box4').set('entitydim', 1);
    model.component('comp1').selection('box4').set('condition', 'inside');
    % model.component('comp1').selection('box4').set('condition', 'intersects');
    model.component('comp1').selection('box4').set('xmax', ' seooL2*1.1');
    model.component('comp1').selection('box4').set('xmin', '-seooL1*1.1');
    model.component('comp1').selection('box4').set('ymax', ' seooL3*1.1');
    model.component('comp1').selection('box4').set('ymin', ' seooL3*0.9');
    model.component('comp1').selection('box4').label('top');

    model.component('comp1').selection.create('box5', 'Box');
    model.component('comp1').selection('box5').set('entitydim', 1);
    model.component('comp1').selection('box5').set('condition', 'inside');
    % model.component('comp1').selection('box5').set('condition', 'intersects');
    model.component('comp1').selection('box5').set('xmax', ' seooL2*1.1');
    model.component('comp1').selection('box5').set('xmin', '-seooL1*1.1');
    model.component('comp1').selection('box5').set('ymax', '-seooL3*0.9');
    model.component('comp1').selection('box5').set('ymin', '-seooL3*1.1');
    model.component('comp1').selection('box5').label('bottom');

    model.component('comp1').selection.create('uni1', 'Union');
    model.component('comp1').selection('uni1').set('entitydim', 1);
    model.component('comp1').selection('uni1').set('input', {'box4' 'box5'});
    model.component('comp1').selection('uni1').label('top_bottom');

model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('cs', 'Analytic');
model.component('comp1').material('mat1').propertyGroup.create('RefractiveIndex', 'Refractive index');

model.component('comp1').physics.create('spf', 'TurbulentFlowkeps', 'geom1');
model.component('comp1').physics('spf').create('inl1', 'InletBoundary', 1);
model.component('comp1').physics('spf').feature('inl1').selection.named('box2');
model.component('comp1').physics('spf').feature('inl1').set('U0in', 'U_inf*sc_ke');
model.component('comp1').physics('spf').create('out1', 'OutletBoundary', 1);
model.component('comp1').physics('spf').feature('out1').selection.named('box3');
% model.component('comp1').physics('spf').create('sym1', 'Symmetry', 1);
% model.component('comp1').physics('spf').feature('sym1').selection.named('box4');
% model.component('comp1').physics('spf').create('sym2', 'Symmetry', 1);
% model.component('comp1').physics('spf').feature('sym2').selection.named('box5');
model.component('comp1').physics('spf').create('sym1', 'Symmetry', 1);
model.component('comp1').physics('spf').feature('sym1').selection.named('uni1');

model.component('comp1').mesh('mesh1').create('bl1', 'BndLayer');
model.component('comp1').mesh('mesh1').create('ftri1', 'FreeTri');
model.component('comp1').mesh('mesh1').feature('bl1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('bl1').selection.set([2]);
model.component('comp1').mesh('mesh1').feature('bl1').create('blp', 'BndLayerProp');
model.component('comp1').mesh('mesh1').feature('bl1').feature('blp').selection.named('box1');
% model.component('comp1').mesh('mesh1').feature('bl1').feature('blp').selection.named('disk1');
model.component('comp1').mesh('mesh1').feature('ftri1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('ftri1').selection.set([1]);
model.component('comp1').mesh('mesh1').feature('ftri1').create('size1', 'Size');

% model.component('comp1').probe.create('bnd1', 'Boundary');
% model.component('comp1').probe.create('bnd2', 'Boundary');
% model.component('comp1').probe.create('bnd3', 'Boundary');
% model.component('comp1').probe('bnd1').selection.named('box1');
% model.component('comp1').probe('bnd2').selection.named('box1');
% model.component('comp1').probe('bnd3').selection.named('box1');

model.component('comp1').material('mat1').label('Air');
model.component('comp1').material('mat1').set('family', 'air');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/8.314/T');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/8.314/T,pA)'; 'T' 'd(pA*0.02897/8.314/T,T)'});
model.component('comp1').material('mat1').propertyGroup('def').func('rho').set('plotargs', {'pA' '0' '1'; 'T' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat1').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('args', {'T'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('plotargs', {'T' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.component('comp1').material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'0[S/m]' '0' '0' '0' '0[S/m]' '0' '0' '0' '0[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.component('comp1').material('mat1').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.component('comp1').material('mat1').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat1').propertyGroup('def').addInput('pressure');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});

model.component('comp1').physics('spf').feature('fp1').set('MixingLengthLimit', 'Manual');
model.component('comp1').physics('spf').feature('fp1').set('l_mix_lim', 'seo_lmix');
% model.component('comp1').physics('spf').feature('init1').set('u_init', {'U_inf'; '0'; '0'});
model.component('comp1').physics('spf').feature('init1').set('u_init', {'U_inf*sc_ke'; '0'; '0'});

% model.component('comp1').physics('spf').feature('init1').set('k_init', 'spf.kinit');
% model.component('comp1').physics('spf').feature('init1').set('ep_init', 'spf.epinit');
model.component('comp1').physics('spf').feature('init1').set('k_init', 'seo_k');
model.component('comp1').physics('spf').feature('init1').set('ep_init', 'seo_e');

model.component('comp1').physics('spf').feature('inl1').set('U0in', 'U_inf');
model.component('comp1').physics('spf').feature('inl1').set('IT', 0.05);
model.component('comp1').physics('spf').feature('inl1').set('LT', '0.07*seoB');

model.component('comp1').mesh('mesh1').feature('size').set('hauto', seo.mesh.id_bd);
model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('hauto', seo.mesh.id_ft);
model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').set('table', 'cfd');
% model.component('comp1').mesh('mesh1').feature('ftri1').feature('size1').selection.geom('geom1');
model.component('comp1').mesh('mesh1').run;

model.frame('mesh1').sorder(1);

% model.component('comp1').probe('bnd1').set('type', 'integral');
% model.component('comp1').probe('bnd1').set('expr', '-spf.T_stressx/(1/2*spf.rho*U_inf^2*seoB)');
% model.component('comp1').probe('bnd1').set('unit', '1');
% model.component('comp1').probe('bnd1').set('descr', '-spf.T_stressx/(1/2*spf.rho*U_inf^2*seoB)');
% model.component('comp1').probe('bnd1').set('table', 'tbl1');
% model.component('comp1').probe('bnd1').set('window', 'window1');
% model.component('comp1').probe('bnd2').set('type', 'integral');
% model.component('comp1').probe('bnd2').set('expr', '-spf.T_stressy/(1/2*spf.rho*U_inf^2*seoB)');
% model.component('comp1').probe('bnd2').set('unit', '1');
% model.component('comp1').probe('bnd2').set('descr', '-spf.T_stressy/(1/2*spf.rho*U_inf^2*seoB)');
% model.component('comp1').probe('bnd2').set('table', 'tbl1');
% model.component('comp1').probe('bnd2').set('window', 'window1');
% model.component('comp1').probe('bnd3').set('type', 'integral');
% model.component('comp1').probe('bnd3').set('expr', '(-spf.T_stressx*y+spf.T_stressy*x)/(1/2*spf.rho*U_inf^2*seoB^2)');
% model.component('comp1').probe('bnd3').set('unit', '1');
% model.component('comp1').probe('bnd3').set('descr', '(-spf.T_stressx*y+spf.T_stressy*x)/(1/2*spf.rho*U_inf^2*seoB^2)');
% model.component('comp1').probe('bnd3').set('table', 'tbl1');
% model.component('comp1').probe('bnd3').set('window', 'window1');

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').create('se1', 'Segregated');
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').create('d2', 'Direct');
model.sol('sol1').feature('s1').feature('se1').create('ss1', 'SegregatedStep');
model.sol('sol1').feature('s1').feature('se1').create('ss2', 'SegregatedStep');
model.sol('sol1').feature('s1').feature('se1').create('ll1', 'LowerLimit');
model.sol('sol1').feature('s1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('s1').feature.remove('fcDef');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('s1').set('plot', true);
model.sol('sol1').feature('s1').feature('se1').set('maxsegiter', 300);
model.sol('sol1').feature('s1').feature('se1').set('segstabacc', 'segcflcmp');
model.sol('sol1').feature('s1').feature('se1').set('subinitcfl', 3);
model.sol('sol1').feature('s1').feature('se1').feature('ss1').label('Velocity u, Pressure p');
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('segvar', {'comp1_u' 'comp1_p'});
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('subdamp', 0.5);
model.sol('sol1').feature('s1').feature('se1').feature('ss2').label('Turbulence variables');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('segvar', {'comp1_k' 'comp1_ep'});
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('linsolver', 'd2');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subdamp', 0.35);
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subtermconst', 'itertol');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subiter', 3);
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subntolfact', 1);
model.sol('sol1').feature('s1').feature('se1').feature('ll1').set('lowerlimit', 'comp1.k 0 comp1.ep 0 ');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d2').set('linsolver', 'pardiso');

% try
    model.sol('sol1').runAll;
% catch

% end

out = model;

%
%%  FINE
%