function out = model
%
% imsi.m
%
% Model exported on Sep 16 2020, 22:40 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/yjn2');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');

model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').feature('stat').activate('spf', true);

model.label('rib_imsi.mph');

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('filename', '/media/sbkim/2266B8F966B8CEB3/git/openfoam_seo/wtt/yjn2/yjn2_cfd_rib_200915.dxf');
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'curve');
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').run('imp1');
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'imp1'});
model.component('comp1').geom('geom1').runPre('fin');
model.component('comp1').geom('geom1').measure.selection.init(0);
model.component('comp1').geom('geom1').measure.selection.set('csol1', [2 63]);

out = model;
