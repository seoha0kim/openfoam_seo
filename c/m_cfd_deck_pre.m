function out = m_cfd_deck_pre(s_wdir,s_dxf_ifile,seo)
%
% m_cfd_deck_pre.m
%
% Model exported on Jul 11 2017, 22:08 by COMSOL 5.3.0.260.


% s_wdir = '~/Work/bridges/금빛노을/comsol/';
% s_dxf_ifile = 'hacB.dxf'


import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

% model.modelPath(['/media/sbkim/011015fa-005e-40ac-b96a-ffbde3bf46c6/Krieg/Work/bridges/' native2unicode(hex2dec({'d6' '8c'}), 'unicode')  native2unicode(hex2dec({'c5' '54'}), 'unicode')  native2unicode(hex2dec({'cc' '9c'}), 'unicode') '/comsol']);
% model.modelPath(['~/Work/Work/bridges/금빛노을/comsol/']);
model.modelPath([s_wdir]);

model.label('cfd_deck.mph');

model.comments(['CFD analysis of bridge deck''s section model\n\n']);

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

% model.component('comp1').mesh.create('mesh1');

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('type', 'dxf');
% model.component('comp1').geom('geom1').feature('imp1').set('filename', ['/media/sbkim/011015fa-005e-40ac-b96a-ffbde3bf46c6/Krieg/Work/bridges/' native2unicode(hex2dec({'d6' '8c'}), 'unicode')  native2unicode(hex2dec({'c5' '54'}), 'unicode')  native2unicode(hex2dec({'cc' '9c'}), 'unicode') '/hacB.dxf']);
% model.component('comp1').geom('geom1').feature('imp1').set('filename', [s_wdir,'../',s_dxf_ifile]);
% model.component('comp1').geom('geom1').feature('imp1').set('filename', ['../',s_dxf_ifile]);
model.component('comp1').geom('geom1').feature('imp1').set('filename', ['dxf/',s_dxf_ifile]);

% model.component('comp1').geom('geom1').feature('imp1').set('alllayers', {'CS-CONC' 'CS-CONC-MAJR' '0'});
model.component('comp1').geom('geom1').feature('imp1').set('alllayers', {'zz_outline' '0' 'BARRIER' ''});
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'curve');
model.component('comp1').geom('geom1').create('sca1', 'Scale');
model.component('comp1').geom('geom1').feature('sca1').set('factor', sprintf('%f',1e-3/seo.lam_s));
model.component('comp1').geom('geom1').feature('sca1').selection('input').set({'imp1'});
model.component('comp1').geom('geom1').create('spl1', 'Split');
model.component('comp1').geom('geom1').feature('spl1').selection('input').set({'sca1'});
% model.component('comp1').geom('geom1').create('ccur1', 'ConvertToCurve');
% model.component('comp1').geom('geom1').feature('ccur1').selection('input').set({'spl1'});
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
% model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'ccur1'});
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'spl1'});
model.component('comp1').geom('geom1').run;

% model.component('comp1').physics.create('spf', 'LaminarFlow', 'geom1');

% model.component('comp1').view('view1').axis.set('xmin', -158.8984375);
% model.component('comp1').view('view1').axis.set('xmax', 29739.1015625);
% model.component('comp1').view('view1').axis.set('ymin', -5596.0498046875);
% model.component('comp1').view('view1').axis.set('ymax', 14537.3916015625);
% model.component('comp1').view('view1').axis.set('abstractviewlratio', -0.05000000074505806);
% model.component('comp1').view('view1').axis.set('abstractviewrratio', 0.05000000074505806);
% model.component('comp1').view('view1').axis.set('abstractviewbratio', -1.233489751815796);
% model.component('comp1').view('view1').axis.set('abstractviewtratio', 1.2334896326065063);
% model.component('comp1').view('view1').axis.set('abstractviewxscale', 31.80638313293457);
% model.component('comp1').view('view1').axis.set('abstractviewyscale', 31.806386947631836);

% model.study.create('std1');
% model.study('std1').create('time', 'Transient');

out = model;
