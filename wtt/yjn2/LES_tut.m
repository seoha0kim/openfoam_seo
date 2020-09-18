function out = model
%
% LES_tut.m
%
% Model exported on Sep 18 2020, 17:02 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/yjn2');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'LESRBVM', 'geom1');

model.study.create('std1');
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('spf', true);

model.component('comp1').geom('geom1').run;

model.param.set('lx', '2*pi[m]');
model.param.descr('lx', 'Length of channel section');
model.param.set('ly', '1[m]');
model.param.descr('ly', 'Maximum wall distance');
model.param.set('lz', '2/3*pi[m]');
model.param.descr('lz', 'Width of channel section');
model.param.set('Re_T', '395');
model.param.descr('Re_T', 'Turbulent Reynolds number');
model.param.set('rho', '1[kg/m^3]');
model.param.descr('rho', 'Density');
model.param.set('mu', '1[Pa*s]/Re_T');
model.param.descr('mu', 'Dynamic viscosity');
model.param.set('U', '26.3175[m/s]');
model.param.descr('U', 'Initial centerline velocity');
model.param.set('u_dist', '5[m/s]');
model.param.descr('u_dist', 'Disturbance amplitude');
model.param.set('k', '10[1/m]');
model.param.descr('k', 'Disturbance wave number');
model.param.set('F_x', '1[N/m^3]');
model.param.descr('F_x', 'Driving force');

model.component('comp1').geom('geom1').create('blk1', 'Block');
model.component('comp1').geom('geom1').feature('blk1').set('size', {'lx' '2*ly' 'lz'});
model.component('comp1').geom('geom1').feature('blk1').set('pos', {'0' '-ly' '0'});
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('blk1');
model.component('comp1').geom('geom1').create('pt1', 'Point');
model.component('comp1').geom('geom1').feature('pt1').setIndex('p', 'lx/2', 0);
model.component('comp1').geom('geom1').feature('pt1').setIndex('p', '-ly', 1);
model.component('comp1').geom('geom1').feature('pt1').setIndex('p', 'lz/2', 2);
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run;

model.component('comp1').physics('spf').feature('fp1').set('rho_mat', 'userdef');
model.component('comp1').physics('spf').feature('fp1').set('rho', 'rho');
model.component('comp1').physics('spf').feature('fp1').set('mu_mat', 'userdef');
model.component('comp1').physics('spf').feature('fp1').set('mu', 'mu');
model.component('comp1').physics('spf').feature('init1').set('u_init', {'U*(1-(y/ly)^2)+u_dist*cos(k*x)*cos(k*pi*y)*sin(3*k*x)' '4/pi*u_dist*sin(k*x)*sin(k*pi*y)*sin(3*k*x)' 'u_dist*sin(k*x)*cos(k*pi*y)*cos(3*k*x)'});
model.component('comp1').physics('spf').create('vf1', 'VolumeForce', 3);
model.component('comp1').physics('spf').feature('vf1').set('F', {'F_x' '0' '0'});
model.component('comp1').physics('spf').create('prpc1', 'PressurePointConstraint', 0);
model.component('comp1').physics('spf').feature('vf1').selection.all;
model.component('comp1').physics('spf').feature('prpc1').selection.set([5]);
model.component('comp1').physics('spf').create('pfc1', 'PeriodicFlowCondition', 2);
model.component('comp1').physics('spf').create('pfc2', 'PeriodicFlowCondition', 2);
model.component('comp1').physics('spf').feature('pfc1').selection.set([1 6]);
model.component('comp1').physics('spf').feature('pfc2').selection.set([3 4]);

model.component('comp1').mesh('mesh1').create('map1', 'Map');
model.component('comp1').mesh('mesh1').feature('map1').selection.set([1]);
model.component('comp1').mesh('mesh1').feature('map1').create('dis1', 'Distribution');
model.component('comp1').mesh('mesh1').feature('map1').feature('dis1').selection.set([1 6]);
model.component('comp1').mesh('mesh1').feature('map1').feature('dis1').set('numelem', 64);
model.component('comp1').mesh('mesh1').feature('map1').feature.duplicate('dis2', 'dis1');
model.component('comp1').mesh('mesh1').feature('map1').feature('dis2').selection.set([2 4]);
model.component('comp1').mesh('mesh1').feature('map1').feature('dis2').set('type', 'predefined');
model.component('comp1').mesh('mesh1').feature('map1').feature('dis2').set('elemcount', 64);
model.component('comp1').mesh('mesh1').feature('map1').feature('dis2').set('elemratio', 48);
model.component('comp1').mesh('mesh1').feature('map1').feature('dis2').set('method', 'geometric');
model.component('comp1').mesh('mesh1').feature('map1').feature('dis2').set('symmetric', true);
model.component('comp1').mesh('mesh1').run('map1');
model.component('comp1').mesh('mesh1').create('swe1', 'Sweep');
model.component('comp1').mesh('mesh1').feature('swe1').selection('sourceface').set([1]);
model.component('comp1').mesh('mesh1').feature('swe1').selection('targetface').set([6]);
model.component('comp1').mesh('mesh1').feature('swe1').create('dis1', 'Distribution');
model.component('comp1').mesh('mesh1').feature('swe1').feature('dis1').set('numelem', 64);
model.component('comp1').mesh('mesh1').run;

model.study('std1').feature('time').set('tlist', 'range(0,1.25,15)');

model.sol.create('sol1');
model.sol('sol1').study('std1');

model.study('std1').feature('time').set('notlistsolnum', 1);
model.study('std1').feature('time').set('notsolnum', '1');
model.study('std1').feature('time').set('listsolnum', 1);
model.study('std1').feature('time').set('solnum', '1');

model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'time');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'time');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').set('tlist', 'range(0,1.25,15)');
model.sol('sol1').feature('t1').set('plot', 'off');
model.sol('sol1').feature('t1').set('plotgroup', 'Default');
model.sol('sol1').feature('t1').set('plotfreq', 'tout');
model.sol('sol1').feature('t1').set('probesel', 'all');
model.sol('sol1').feature('t1').set('probes', {});
model.sol('sol1').feature('t1').set('probefreq', 'tsteps');
model.sol('sol1').feature('t1').set('rtol', 0.005);
model.sol('sol1').feature('t1').set('atolglobalmethod', 'scaled');
model.sol('sol1').feature('t1').set('atolglobalfactor', 0.05);
model.sol('sol1').feature('t1').set('atolglobalvaluemethod', 'factor');
model.sol('sol1').feature('t1').set('atolmethod', {'comp1_p' 'scaled' 'comp1_u' 'global'});
model.sol('sol1').feature('t1').set('atolvaluemethod', {'comp1_p' 'factor' 'comp1_u' 'factor'});
model.sol('sol1').feature('t1').set('atolfactor', {'comp1_p' '1' 'comp1_u' '0.1'});
model.sol('sol1').feature('t1').set('tstepsgenalpha', 'manual');
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').set('estrat', 'exclude');
model.sol('sol1').feature('t1').set('rhoinf', 0.5);
model.sol('sol1').feature('t1').set('predictor', 'constant');
model.sol('sol1').feature('t1').set('stabcntrl', true);
model.sol('sol1').feature('t1').set('bwinitstepfrac', '0.01');
model.sol('sol1').feature('t1').set('control', 'time');
model.sol('sol1').feature('t1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol1').feature('t1').feature('fc1').set('damp', 0.9);
model.sol('sol1').feature('t1').feature('fc1').set('stabacc', 'aacc');
model.sol('sol1').feature('t1').feature('fc1').set('aaccdim', 5);
model.sol('sol1').feature('t1').feature('fc1').set('aaccmix', 0.9);
model.sol('sol1').feature('t1').feature('fc1').set('aaccdelay', 1);
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.5);
model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 8);
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').set('linsolver', 'gmres');
model.sol('sol1').feature('t1').feature('i1').set('prefuntype', 'left');
model.sol('sol1').feature('t1').feature('i1').set('itrestart', 50);
model.sol('sol1').feature('t1').feature('i1').set('rhob', 20);
model.sol('sol1').feature('t1').feature('i1').set('maxlinit', 50);
model.sol('sol1').feature('t1').feature('i1').set('nlinnormuse', 'on');
model.sol('sol1').feature('t1').feature('i1').label('AMG, fluid flow variables (spf)');
model.sol('sol1').feature('t1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('prefun', 'saamg');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('mgcycle', 'v');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('maxcoarsedof', 80000);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('strconn', 0.02);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('usesmooth', false);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').set('saamgcompwise', true);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').create('sc1', 'SCGS');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('iter', 0);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('seconditer', 1);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('sc1').set('relax', 0.5);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').create('sc1', 'SCGS');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('linesweeptype', 'ssor');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('iter', 1);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsrelax', 0.7);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsmethod', 'lines_vertices');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('scgsvertexrelax', 0.7);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('seconditer', 1);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('sc1').set('relax', 0.5);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('cs').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('t1').create('d1', 'Direct');
model.sol('sol1').feature('t1').feature('d1').set('linsolver', 'pardiso');
model.sol('sol1').feature('t1').feature('d1').set('pivotperturb', 1.0E-13);
model.sol('sol1').feature('t1').feature('d1').label('Direct, fluid flow variables (spf)');
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('t1').feature('fc1').set('jtech', 'once');
model.sol('sol1').feature('t1').feature('fc1').set('damp', 0.9);
model.sol('sol1').feature('t1').feature('fc1').set('stabacc', 'aacc');
model.sol('sol1').feature('t1').feature('fc1').set('aaccdim', 5);
model.sol('sol1').feature('t1').feature('fc1').set('aaccmix', 0.9);
model.sol('sol1').feature('t1').feature('fc1').set('aaccdelay', 1);
model.sol('sol1').feature('t1').feature('fc1').set('ntolfact', 0.5);
model.sol('sol1').feature('t1').feature('fc1').set('maxiter', 8);
model.sol('sol1').feature('t1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.result.dataset('dset1').set('geom', 'geom1');
model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').label('Velocity (spf)');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('slc1', 'Slice');
model.result('pg1').feature('slc1').label('Slice');
model.result('pg1').feature('slc1').set('smooth', 'internal');
model.result('pg1').feature('slc1').set('data', 'parent');
model.result.remove('pg1');

model.sol('sol1').feature('t1').set('timestepgenalpha', '0.0025');
model.sol('sol1').feature('t1').set('consistent', false);

model.result.dataset('dset1').set('geom', 'geom1');
model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').label('Velocity (spf)');
model.result('pg1').set('showlooplevel', {'off' 'off' 'off'});
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('slc1', 'Slice');
model.result('pg1').feature('slc1').label('Slice');
model.result('pg1').feature('slc1').set('smooth', 'internal');
model.result('pg1').feature('slc1').set('data', 'parent');
model.result.remove('pg1');
model.result.dataset('dset1').set('geom', 'geom1');
model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').label('Velocity (spf)');
model.result('pg1').set('showlooplevel', {'off' 'off' 'off'});
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('slc1', 'Slice');
model.result('pg1').feature('slc1').label('Slice');
model.result('pg1').feature('slc1').set('smooth', 'internal');
model.result('pg1').feature('slc1').set('data', 'parent');
model.result.remove('pg1');
model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').run;
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').run;

model.component('comp1').view('view1').set('transparency', true);

model.result('pg1').feature('surf1').set('expr', 'spf.muT');
model.result('pg1').feature('surf1').set('descr', 'Turbulent dynamic viscosity');
model.result('pg1').run;

out = model;
