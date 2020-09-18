function out = model
%
% imsi.m
%
% Model exported on Sep 18 2020, 13:40 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/yjn2');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'TurbulentFlowkeps', 'geom1');

model.study.create('std1');
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('spf', true);

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('type', 'dxf');
model.component('comp1').geom('geom1').feature('imp1').set('filename', '/media/sbkim/2266B8F966B8CEB3/git/openfoam_seo/wtt/yjn2/yjn2_cfd_rib_200915.dxf');
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'curve');
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'imp1'});
model.component('comp1').geom('geom1').create('del1', 'Delete');
model.component('comp1').geom('geom1').feature('del1').selection('input').init(2);
model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1', [1 2 3 4 5 16 17 18 19 20]);
model.component('comp1').geom('geom1').run('del1');
model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('del1', [1 32]);
model.component('comp1').geom('geom1').create('sca1', 'Scale');
model.component('comp1').geom('geom1').feature('sca1').set('factor', '1e-3');
model.component('comp1').geom('geom1').feature('sca1').selection('input').set({'del1'});
model.component('comp1').geom('geom1').create('mov1', 'Move');
model.component('comp1').geom('geom1').feature('mov1').setIndex('displx', '-157.1274098', 0);
model.component('comp1').geom('geom1').feature('mov1').setIndex('disply', '-10.38496539', 0);
model.component('comp1').geom('geom1').feature('mov1').selection('input').set({'sca1'});
model.component('comp1').geom('geom1').create('sca2', 'Scale');
model.component('comp1').geom('geom1').feature('sca2').set('factor', '1/6.250000e+01');
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
model.component('comp1').geom('geom1').create('co1', 'Compose');
model.component('comp1').geom('geom1').feature('co1').set('formula', '(r1+c1+r2+r3)-(mir1)');
model.component('comp1').geom('geom1').feature('co1').selection('input').set({'r1' 'c1' 'r2' 'r3' 'mir1'});
model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat1').propertyGroup('def').func.create('cs', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('an1', 'Analytic');
model.component('comp1').material('mat1').propertyGroup('def').func.create('an2', 'Analytic');
model.component('comp1').material('mat1').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.component('comp1').material('mat1').propertyGroup.create('NonlinearModel', 'Nonlinear model');
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
model.component('comp1').material('mat1').propertyGroup('def').func('cs').set('args', 'T');
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
model.component('comp1').material('mat1').propertyGroup('def').func('an2').set('args', 'T');
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

model.component('comp1').selection.create('box1', 'Box');
model.component('comp1').selection('box1').set('entitydim', 1);
model.component('comp1').selection('box1').set('xmin', -0.15);
model.component('comp1').selection('box1').set('xmax', 0.15);
model.component('comp1').selection('box1').set('ymin', -0.1);
model.component('comp1').selection('box1').set('ymax', 0.12);
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
model.component('comp1').selection('box4').set('xmin', 2.8);
model.component('comp1').selection('box4').set('xmax', 3.2);
model.component('comp1').selection('box4').set('ymin', -1);
model.component('comp1').selection('box4').set('ymax', 1);
model.component('comp1').selection('box1').set('condition', 'inside');

model.component('comp1').physics('spf').create('inl1', 'InletBoundary', 1);
model.component('comp1').physics('spf').feature('inl1').selection.set([1]);
model.component('comp1').physics('spf').create('out1', 'OutletBoundary', 1);
model.component('comp1').physics('spf').feature('out1').selection.named('box4');
model.component('comp1').physics('spf').create('sym1', 'Symmetry', 1);
model.component('comp1').physics('spf').feature('sym1').selection.set([2 3]);
model.component('comp1').physics('spf').feature('inl1').set('U0in', 0.054779966833822843);

model.component('comp1').mesh('mesh1').create('bl1', 'BndLayer');
model.component('comp1').mesh('mesh1').create('fq2', 'FreeQuad');
model.component('comp1').mesh('mesh1').create('fq3', 'FreeQuad');
model.component('comp1').mesh('mesh1').create('fq1', 'FreeQuad');
model.component('comp1').mesh('mesh1').feature('bl1').selection.geom('geom1', 2);
model.component('comp1').mesh('mesh1').feature('bl1').selection.set([4]);
model.component('comp1').mesh('mesh1').feature('bl1').create('blp', 'BndLayerProp');
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
model.component('comp1').mesh('mesh1').feature('size').set('table', 'cfd');
model.component('comp1').mesh('mesh1').feature('size').set('hauto', 4);
model.component('comp1').mesh('mesh1').feature('fq2').feature('size1').set('hauto', 9);
model.component('comp1').mesh('mesh1').feature('fq3').feature('size1').set('hauto', 9);
model.component('comp1').mesh('mesh1').feature('fq1').feature('size1').set('hauto', 9);
model.component('comp1').mesh('mesh1').run;

model.label('rib_upper_turbulent_Re150.mph');

model.component('comp1').selection('box4').set('condition', 'inside');

model.study.create('std2');
model.study('std2').create('stat', 'Stationary');
model.study('std2').feature('stat').activate('spf', true);
model.study.remove('std1');

model.sol.create('sol1');
model.sol('sol1').study('std2');

model.study('std2').feature('stat').set('notlistsolnum', 1);
model.study('std2').feature('stat').set('notsolnum', '1');
model.study('std2').feature('stat').set('listsolnum', 1);
model.study('std2').feature('stat').set('solnum', '1');

model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std2');
model.sol('sol1').feature('st1').set('studystep', 'stat');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'stat');
model.sol('sol1').create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('s1').create('se1', 'Segregated');
model.sol('sol1').feature('s1').feature('se1').feature.remove('ssDef');
model.sol('sol1').feature('s1').feature('se1').create('ss1', 'SegregatedStep');
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('segvar', {'comp1_u' 'comp1_p'});
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('subdamp', 0.5);
model.sol('sol1').feature('s1').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('d1').label('Direct, fluid flow variables (spf)');
model.sol('sol1').feature('s1').feature('se1').feature('ss1').set('linsolver', 'd1');
model.sol('sol1').feature('s1').feature('se1').feature('ss1').label('Velocity u, Pressure p');
model.sol('sol1').feature('s1').feature('se1').create('ss2', 'SegregatedStep');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('segvar', {'comp1_k' 'comp1_ep'});
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subdamp', 0.35);
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subiter', 3);
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subtermconst', 'itertol');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('subntolfact', 1);
model.sol('sol1').feature('s1').create('d2', 'Direct');
model.sol('sol1').feature('s1').feature('d2').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('d2').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature('d2').label('Direct, turbulence variables (spf)');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').set('linsolver', 'd2');
model.sol('sol1').feature('s1').feature('se1').feature('ss2').label('Turbulence variables');
model.sol('sol1').feature('s1').feature('se1').set('segstabacc', 'segcflcmp');
model.sol('sol1').feature('s1').feature('se1').set('subinitcfl', 3);
model.sol('sol1').feature('s1').feature('se1').set('subkppid', 0.65);
model.sol('sol1').feature('s1').feature('se1').set('subkdpid', 0.05);
model.sol('sol1').feature('s1').feature('se1').set('subkipid', 0.05);
model.sol('sol1').feature('s1').feature('se1').set('subcfltol', 0.1);
model.sol('sol1').feature('s1').feature('se1').set('maxsegiter', 300);
model.sol('sol1').feature('s1').feature('se1').create('ll1', 'LowerLimit');
model.sol('sol1').feature('s1').feature('se1').feature('ll1').set('lowerlimit', 'comp1.k 0 comp1.ep 0 ');
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
model.sol('sol1').feature('s1').create('i2', 'Iterative');
model.sol('sol1').feature('s1').feature('i2').set('linsolver', 'gmres');
model.sol('sol1').feature('s1').feature('i2').set('prefuntype', 'left');
model.sol('sol1').feature('s1').feature('i2').set('itrestart', 50);
model.sol('sol1').feature('s1').feature('i2').set('rhob', 20);
model.sol('sol1').feature('s1').feature('i2').set('maxlinit', 200);
model.sol('sol1').feature('s1').feature('i2').set('nlinnormuse', 'on');
model.sol('sol1').feature('s1').feature('i2').label('AMG, turbulence variables (spf)');
model.sol('sol1').feature('s1').feature('i2').create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('prefun', 'saamg');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('mgcycle', 'v');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('maxcoarsedof', 50000);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('strconn', 0.01);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('usesmooth', false);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').set('saamgcompwise', true);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linerelax', 0.7);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('iter', 0);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('seconditer', 1);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('pr').feature('sl1').set('relax', 0.5);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').create('sl1', 'SORLine');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('linesweeptype', 'ssor');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('linerelax', 0.7);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('iter', 1);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('linealgorithm', 'mesh');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('linemethod', 'uncoupled');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('seconditer', 1);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('po').feature('sl1').set('relax', 0.5);
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('s1').feature('i2').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std2');

model.result.dataset('dset1').set('geom', 'geom1');
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
model.result.dataset.create('edg1', 'Edge2D');
model.result.dataset('edg1').label('Exterior Walls');
model.result.dataset('edg1').set('data', 'dset1');
model.result.dataset('edg1').selection.geom('geom1', 1);
model.result.dataset('edg1').selection.set([10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33]);
model.result.dataset('edg1').selection.inherit(false);
model.result.create('pg3', 'PlotGroup2D');
model.result('pg3').label('Wall Resolution (spf)');
model.result('pg3').set('frametype', 'spatial');
model.result('pg3').set('data', 'dset1');
model.result('pg3').feature.create('line1', 'Line');
model.result('pg3').feature('line1').label('Wall Resolution');
model.result('pg3').feature('line1').set('expr', 'spf.Delta_wPlus');
model.result('pg3').feature('line1').set('linetype', 'tube');
model.result('pg3').feature('line1').set('smooth', 'internal');
model.result('pg3').feature('line1').set('data', 'parent');
model.result('pg3').feature('line1').feature.create('hght1', 'Height');
model.result('pg3').feature('line1').feature('hght1').label('Height Expression');
model.result('pg3').feature('line1').feature('hght1').set('heightdata', 'expr');
model.result('pg3').feature('line1').feature('hght1').set('expr', 'spf.WRHeightExpr');

model.sol('sol1').runAll;

model.result('pg1').run;

out = model;
