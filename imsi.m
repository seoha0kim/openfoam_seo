function out = model
%
% imsi.m
%
% Model exported on Jun 24 2020, 16:55 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 3);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('type', 'native');
model.component('comp1').geom('geom1').feature('imp1').set('filename', '/home/sbkim/Work/git/openfoam_seo/sbD_H_damper_mass_L.mphbin');
model.component('comp1').geom('geom1').run;

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat1').propertyGroup.create('Murnaghan', 'Murnaghan');
model.component('comp1').material('mat1').propertyGroup.create('Lame', ['Lam' native2unicode(hex2dec({'00' 'e9'}), 'unicode') ' parameters']);

model.component('comp1').physics.create('solid', 'SolidMechanics', 'geom1');
model.component('comp1').physics('solid').create('fix1', 'Fixed', 2);
model.component('comp1').physics('solid').feature('fix1').selection.set([1 2 5]);
model.component('comp1').physics('solid').create('gr1', 'Gravity', 3);
model.component('comp1').physics('solid').feature('gr1').selection.set([1]);

model.component('comp1').mesh('mesh1').autoMeshSize(9);

model.component('comp1').material('mat1').label('Structural steel');
model.component('comp1').material('mat1').set('family', 'custom');
model.component('comp1').material('mat1').set('specular', 'custom');
model.component('comp1').material('mat1').set('customspecular', [0.7843137254901961 0.7843137254901961 0.7843137254901961]);
model.component('comp1').material('mat1').set('diffuse', 'custom');
model.component('comp1').material('mat1').set('customdiffuse', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat1').set('ambient', 'custom');
model.component('comp1').material('mat1').set('customambient', [0.6666666666666666 0.6666666666666666 0.6666666666666666]);
model.component('comp1').material('mat1').set('noise', true);
model.component('comp1').material('mat1').set('noisefreq', 1);
model.component('comp1').material('mat1').set('lighting', 'cooktorrance');
model.component('comp1').material('mat1').set('fresnel', 0.9);
model.component('comp1').material('mat1').set('roughness', 0.3);
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').descr('relpermeability_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', '475[J/(kg*K)]');
model.component('comp1').material('mat1').propertyGroup('def').descr('heatcapacity_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'44.5[W/(m*K)]' '0' '0' '0' '44.5[W/(m*K)]' '0' '0' '0' '44.5[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('def').descr('thermalconductivity_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'4.032e6[S/m]' '0' '0' '0' '4.032e6[S/m]' '0' '0' '0' '4.032e6[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').descr('electricconductivity_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').descr('relpermittivity_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalexpansioncoefficient', {'12.3e-6[1/K]' '0' '0' '0' '12.3e-6[1/K]' '0' '0' '0' '12.3e-6[1/K]'});
model.component('comp1').material('mat1').propertyGroup('def').descr('thermalexpansioncoefficient_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('def').set('density', '7850[kg/m^3]');
model.component('comp1').material('mat1').propertyGroup('def').descr('density_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Enu').set('youngsmodulus', '200e9[Pa]');
model.component('comp1').material('mat1').propertyGroup('Enu').descr('youngsmodulus_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Enu').set('poissonsratio', '0.30');
model.component('comp1').material('mat1').propertyGroup('Enu').descr('poissonsratio_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('l', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('m', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('n', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('l', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('m', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('n', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('l', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('m', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('n', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('l', '-3.0e11[Pa]');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('m', '-6.2e11[Pa]');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').set('n', '-7.2e11[Pa]');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').descr('l_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').descr('m_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Murnaghan').descr('n_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('lambLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('muLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('lambLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('muLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('lambLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('muLame', '');
model.component('comp1').material('mat1').propertyGroup('Lame').set('lambLame', '1.15e11[Pa]');
model.component('comp1').material('mat1').propertyGroup('Lame').set('muLame', '7.69e10[Pa]');
model.component('comp1').material('mat1').propertyGroup('Lame').descr('lambLame_symmetry', '');
model.component('comp1').material('mat1').propertyGroup('Lame').descr('muLame_symmetry', '');

model.study.create('std1');
model.study('std1').create('time', 'Transient');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').attach('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('t1', 'Time');
model.sol('sol1').feature('t1').create('fc1', 'FullyCoupled');
model.sol('sol1').feature('t1').create('d1', 'Direct');
model.sol('sol1').feature('t1').create('i1', 'Iterative');
model.sol('sol1').feature('t1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').create('so1', 'SOR');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').create('so1', 'SOR');
model.sol('sol1').feature('t1').feature.remove('fcDef');

model.result.create('pg1', 'PlotGroup3D');
model.result.create('pg2', 'PlotGroup3D');
model.result('pg1').create('surf1', 'Surface');
model.result('pg1').feature('surf1').set('expr', 'solid.mises');
model.result('pg1').feature('surf1').create('def', 'Deform');
model.result('pg2').create('arwv1', 'ArrowVolume');
model.result('pg2').create('surf1', 'Surface');
model.result('pg2').feature('arwv1').create('col', 'Color');
model.result('pg2').feature('arwv1').create('def', 'Deform');
model.result('pg2').feature('arwv1').feature('col').set('expr', 'comp1.solid.gr1.F_V_Mag');
model.result('pg2').feature('surf1').set('expr', '1');
model.result('pg2').feature('surf1').create('def', 'Deform');

model.nodeGroup.create('dset1solidlgrp', 'Results');
model.nodeGroup('dset1solidlgrp').set('type', 'plotgroup');
model.nodeGroup('dset1solidlgrp').placeAfter('plotgroup', 'pg1');

model.study('std1').feature('time').set('tlist', 'range(0,0.1,.1)');

model.sol('sol1').attach('std1');
model.sol('sol1').feature('v1').set('clist', {'range(0,0.1,.1)' '1.0E-4[s]'});
model.sol('sol1').feature('v1').feature('comp1_u').set('scalemethod', 'manual');
model.sol('sol1').feature('v1').feature('comp1_u').set('scaleval', '1e-2*0.30490567607793895');
model.sol('sol1').feature('t1').set('tlist', 'range(0,0.1,.1)');
model.sol('sol1').feature('t1').set('timemethod', 'genalpha');
model.sol('sol1').feature('t1').feature('aDef').set('cachepattern', true);
model.sol('sol1').feature('t1').feature('fc1').set('linsolver', 'd1');
model.sol('sol1').feature('t1').feature('d1').label('Suggested Direct Solver (solid)');
model.sol('sol1').feature('t1').feature('i1').label('Suggested Iterative Solver (solid)');
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('pr').feature('so1').set('relax', 0.8);
model.sol('sol1').feature('t1').feature('i1').feature('mg1').feature('po').feature('so1').set('relax', 0.8);
model.sol('sol1').runAll;

model.result('pg1').label('Stress (solid)');
model.result('pg1').feature('surf1').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z coordinate'});
model.result('pg1').feature('surf1').set('colortable', 'RainbowLight');
model.result('pg1').feature('surf1').set('resolution', 'normal');
model.result('pg1').feature('surf1').feature('def').set('scale', 1.7976931348623157E308);
model.result('pg1').feature('surf1').feature('def').set('scaleactive', false);
model.result('pg2').label('Volume Loads (solid)');
model.result('pg2').set('titletype', 'custom');
model.result('pg2').set('typeintitle', false);
model.result('pg2').set('descriptionintitle', false);
model.result('pg2').set('unitintitle', false);
model.result('pg2').set('frametype', 'spatial');
model.result('pg2').set('showlegendsunit', true);
model.result('pg2').feature('arwv1').label('Gravity 1');
model.result('pg2').feature('arwv1').set('expr', {'solid.gr1.F_Vx' 'solid.gr1.F_Vy' 'solid.gr1.F_Vz'});
model.result('pg2').feature('arwv1').set('descr', 'Load (spatial frame)');
model.result('pg2').feature('arwv1').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z coordinate'});
model.result('pg2').feature('arwv1').set('placement', 'gausspoints');
model.result('pg2').feature('arwv1').feature('col').set('coloring', 'gradient');
model.result('pg2').feature('arwv1').feature('col').set('topcolor', 'red');
model.result('pg2').feature('arwv1').feature('def').set('scale', 0);
model.result('pg2').feature('arwv1').feature('def').set('scaleactive', true);
model.result('pg2').feature('surf1').active(false);
model.result('pg2').feature('surf1').label('Gray Surfaces');
model.result('pg2').feature('surf1').set('const', {'solid.refpntx' '0' 'Reference point for moment computation, x coordinate'; 'solid.refpnty' '0' 'Reference point for moment computation, y coordinate'; 'solid.refpntz' '0' 'Reference point for moment computation, z coordinate'});
model.result('pg2').feature('surf1').set('coloring', 'uniform');
model.result('pg2').feature('surf1').set('color', 'gray');
model.result('pg2').feature('surf1').set('resolution', 'normal');
model.result('pg2').feature('surf1').feature('def').set('scale', 0);
model.result('pg2').feature('surf1').feature('def').set('scaleactive', true);

model.nodeGroup('dset1solidlgrp').label('Applied Loads (solid)');
model.nodeGroup('dset1solidlgrp').add('plotgroup', 'pg2');

out = model;
