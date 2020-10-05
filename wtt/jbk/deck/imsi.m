function out = model
%
% imsi.m
%
% Model exported on Oct 6 2020, 01:20 by COMSOL 5.5.0.359.

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
model.component('comp1').geom('geom1').feature('mov2').setIndex('displx', '-880.613546', 0);
model.component('comp1').geom('geom1').feature('mov2').setIndex('disply', '-65.003840', 0);
model.component('comp1').geom('geom1').feature('mov2').selection('input').set({'imp2'});
model.component('comp1').geom('geom1').create('mir1', 'Mirror');
model.component('comp1').geom('geom1').feature('mir1').selection('input').set({'mov2(1)'});
model.component('comp1').geom('geom1').create('mov3', 'Move');
model.component('comp1').geom('geom1').feature('mov3').selection('input').set({'mir1' 'mov2(2)'});
model.component('comp1').geom('geom1').feature('mov3').set('displx', 6.799999711);
model.component('comp1').geom('geom1').feature('mov3').set('disply', 1.62719984241);
model.component('comp1').geom('geom1').measure.selection.init;
model.component('comp1').geom('geom1').measure.selection.set({'mov1(1)' 'mov3(1)' 'mov3(2)'});
model.component('comp1').geom('geom1').create('sca2', 'Scale');
model.component('comp1').geom('geom1').feature('sca2').set('factor', '1/100');
model.component('comp1').geom('geom1').feature('sca2').selection('input').set({'mov1' 'mov3'});
model.component('comp1').geom('geom1').create('mir2', 'Mirror');
model.component('comp1').geom('geom1').feature('mir2').selection('input').set({'sca2'});
model.component('comp1').geom('geom1').create('rot2', 'Rotate');
model.component('comp1').geom('geom1').feature('rot2').selection('input').set({'mir2'});
model.component('comp1').geom('geom1').feature('rot2').set('rot', 0);
model.component('comp1').geom('geom1').create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('r1').set('pos', {'-1.5/2' '-1.5/2'});
model.component('comp1').geom('geom1').feature('r1').set('size', [2.5 1.5]);
model.component('comp1').geom('geom1').create('c1', 'Circle');
model.component('comp1').geom('geom1').feature('c1').set('pos', {'0' '.02*0'});
model.component('comp1').geom('geom1').feature('c1').set('r', 0.2);
model.component('comp1').geom('geom1').create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('r2').set('pos', [-0.5 -0.5]);
model.component('comp1').geom('geom1').feature('r2').set('size', [2 1]);
model.component('comp1').geom('geom1').create('r3', 'Rectangle');
model.component('comp1').geom('geom1').feature('r3').set('pos', {'-.75/2' '-.75/2'});
model.component('comp1').geom('geom1').feature('r3').set('size', [1 0.75]);
model.component('comp1').geom('geom1').create('co1', 'Compose');
model.component('comp1').geom('geom1').feature('co1').set('formula', '(r1+c1+r2+r3)-(rot2)');
model.component('comp1').geom('geom1').feature('co1').selection('input').set({'r1' 'c1' 'r2' 'r3' 'rot2'});
model.component('comp1').geom('geom1').run('r3');

model.label('imsi.mph');

model.component('comp1').geom('geom1').runPre('rot2');
model.component('comp1').geom('geom1').feature('co1').set('formula', '(r1+c1+r2+r3)-(rot2(1)+rot2(2)+rot2(3))');
model.component('comp1').geom('geom1').runPre('fin');

out = model;
