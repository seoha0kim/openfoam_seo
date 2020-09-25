function out = model
%
% imsi.m
%
% Model exported on Sep 26 2020, 00:32 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/jbk');

model.param.set('seo_U_in', '0.054780[m/s]');
model.param.set('seo_B', '0.133638[m]');
model.param.set('seo_D', '0.040000[m]');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'TurbulentFlowkeps', 'geom1');

model.study.create('std1');
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('spf', true);

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('type', 'dxf');
model.component('comp1').geom('geom1').feature('imp1').set('filename', 'dxf/pylon_cfd.dxf');
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'curve');
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'imp1'});
model.component('comp1').geom('geom1').create('del1', 'Delete');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').feature('imp1').set('knit', false);

model.label('imsi.mph');

model.component('comp1').geom('geom1').feature('imp1').set('alllayers', {'DIM' '0'});
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1', [7 8 9 10 19 20]);
model.component('comp1').geom('geom1').run('del1');

out = model;
