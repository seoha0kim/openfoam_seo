function out = model
%
% imsi.m
%
% Model exported on Oct 5 2020, 17:11 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/jbk/deck/');

model.param.set('seo_U_in', '0.010978[m/s]');
model.param.set('seo_B', '0.199592[m]');
model.param.set('seo_D', '0.040660[m]');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'TurbulentFlowkeps', 'geom1');

model.study.create('std1');
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('spf', true);

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('type', 'dxf');

model.label('imsi.mph');

model.component('comp1').geom('geom1').run('');
model.component('comp1').geom('geom1').run('');
model.component('comp1').geom('geom1').feature('imp1').set('filename', '/home/sbkim/Work/git/openfoam_seo/wtt/jbk/dxf/deck_cfd.dxf');
model.component('comp1').geom('geom1').run('imp1');
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'curve');
model.component('comp1').geom('geom1').run('imp1');
model.component('comp1').geom('geom1').feature.duplicate('imp2', 'imp1');
model.component('comp1').geom('geom1').feature('imp2').set('filename', '/home/sbkim/Work/git/openfoam_seo/wtt/jbk/dxf/fence_cfd.dxf');
model.component('comp1').geom('geom1').run('imp2');
model.component('comp1').geom('geom1').measure.selection.init;
model.component('comp1').geom('geom1').measure.selection.set({'imp1(1)' 'imp1(2)' 'imp1(3)' 'imp2(1)' 'imp2(2)'});
model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('imp2(2)', [1 3]);
model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('imp2(1)', 34);
model.component('comp1').geom('geom1').measure.selection.set('imp2(2)', 1);
model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('imp2(1)', 34);
model.component('comp1').geom('geom1').measure.selection.set('imp2(2)', 1);
model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('imp1(2)', [1 11]);
model.component('comp1').geom('geom1').measure.selection.set('imp2(1)', 34);
model.component('comp1').geom('geom1').measure.selection.set('imp2(2)', 1);
model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('imp1(2)', 5);
model.component('comp1').geom('geom1').measure.selection.set('imp2(1)', 34);
model.component('comp1').geom('geom1').measure.selection.set('imp2(2)', 1);
model.component('comp1').geom('geom1').measure.selection.set('imp1(1)', 11);

out = model;
