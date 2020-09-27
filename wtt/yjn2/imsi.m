function out = model
%
% imsi.m
%
% Model exported on Sep 27 2020, 18:43 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/media/sbkim/2266B8F966B8CEB3/git/openfoam_seo/wtt/yjn2');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'TurbulentFlowSST', 'geom1');

model.study.create('std1');
model.study('std1').create('wdi', 'WallDistanceInitialization');
model.study('std1').feature('wdi').set('solnum', 'auto');
model.study('std1').feature('wdi').set('notsolnum', 'auto');
model.study('std1').feature('wdi').set('ngen', '5');
model.study('std1').feature('wdi').activate('spf', true);
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').set('initialtime', '0');
model.study('std1').feature('time').set('solnum', 'auto');
model.study('std1').feature('time').set('notsolnum', 'auto');
model.study('std1').feature('time').activate('spf', true);

out = model;
