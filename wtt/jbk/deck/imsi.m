function out = model
%
% imsi.m
%
% Model exported on Oct 6 2020, 00:53 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/jbk/deck/');

model.param.set('seo_U_in', '0.013610[m/s]');
model.param.set('seo_B', '0.161000[m]');
model.param.set('seo_D', '0.036507[m]');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'TurbulentFlowkeps', 'geom1');

model.study.create('std1');
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('spf', true);

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('type', 'dxf');
model.component('comp1').geom('geom1').feature('imp1').set('filename', '../dxf/deck_cfd.dxf');
model.component('comp1').geom('geom1').feature('imp1').set('knit', false);
model.component('comp1').geom('geom1').feature('imp1').set('repairgeom', false);
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'imp1'});
model.component('comp1').geom('geom1').create('sca1', 'Scale');
model.component('comp1').geom('geom1').feature('sca1').set('factor', '1e-3');
model.component('comp1').geom('geom1').feature('sca1').selection('input').set({'csol1'});
model.component('comp1').geom('geom1').create('mov1', 'Move');
model.component('comp1').geom('geom1').feature('mov1').setIndex('displx', '-21.457556', 0);
model.component('comp1').geom('geom1').feature('mov1').setIndex('disply', '-18.936340', 0);
model.component('comp1').geom('geom1').feature('mov1').selection('input').set({'sca1'});
model.component('comp1').geom('geom1').create('imp2', 'Import');
model.component('comp1').geom('geom1').feature('imp2').set('type', 'dxf');
model.component('comp1').geom('geom1').feature('imp2').set('filename', '../dxf/fence_cfd.dxf');
model.component('comp1').geom('geom1').create('mov2', 'Move');
model.component('comp1').geom('geom1').feature('mov2').setIndex('displx', '-852.355991', 0);
model.component('comp1').geom('geom1').feature('mov2').setIndex('disply', '-42.442300', 0);
model.component('comp1').geom('geom1').feature('mov2').selection('input').set({'imp2'});
model.component('comp1').geom('geom1').feature('mov2').setIndex('displx', '-880.613546', 0);
model.component('comp1').geom('geom1').feature('mov2').setIndex('disply', '-65.003840', 0);
model.component('comp1').geom('geom1').feature('mov2').selection('input').set({'imp2'});
model.component('comp1').geom('geom1').feature('mov2').setIndex('displx', '-873.813547', 0);
model.component('comp1').geom('geom1').feature('mov2').setIndex('disply', '-63.426140', 0);
model.component('comp1').geom('geom1').feature('mov2').selection('input').set({'imp2'});
model.component('comp1').geom('geom1').feature('mov2').setIndex('displx', '-880.613546', 0);
model.component('comp1').geom('geom1').feature('mov2').setIndex('disply', '-65.003840', 0);
model.component('comp1').geom('geom1').feature('mov2').selection('input').set({'imp2'});

model.label('imsi.mph');

model.component('comp1').geom('geom1').run('mov2');
model.component('comp1').geom('geom1').run('mov2');
model.component('comp1').geom('geom1').create('mir1', 'Mirror');
model.component('comp1').geom('geom1').feature('mir1').selection('input').set({'mov2(1)'});
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').create('mov3', 'Move');
model.component('comp1').geom('geom1').feature('mov3').selection('input').set({'mir1' 'mov2(2)'});
model.component('comp1').geom('geom1').feature('mov3').set('displx', 6.799999711);
model.component('comp1').geom('geom1').feature('mov3').set('disply', '1.577699914 + 0.04949992841');
model.component('comp1').geom('geom1').run('mov3');
model.component('comp1').geom('geom1').run('mir1');
model.component('comp1').geom('geom1').run('mov3');
model.component('comp1').geom('geom1').feature('mov3').set('disply', '(1.577699914 + 0.04949992841)');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').measure.selection.init;
model.component('comp1').geom('geom1').measure.selection.set({'mov1(1)' 'mov3(1)' 'mov3(2)'});

out = model;
