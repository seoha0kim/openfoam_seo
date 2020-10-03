function out = model
%
% imsi.m
%
% Model exported on Oct 3 2020, 14:40 by COMSOL 5.5.0.359.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/home/sbkim/Work/git/openfoam_seo/wtt/yjn2/deck2/');

model.param.set('seo_U_in', '0.036520[m/s]');
model.param.set('seo_B', '0.060000[m]');
model.param.set('seo_D', '0.045000[m]');

model.component.create('comp1', true);

model.component('comp1').geom.create('geom1', 2);

model.component('comp1').mesh.create('mesh1');

model.component('comp1').physics.create('spf', 'TurbulentFlowkeps', 'geom1');

model.study.create('std1');
model.study('std1').create('time', 'Transient');
model.study('std1').feature('time').activate('spf', true);

model.component('comp1').geom('geom1').create('imp1', 'Import');
model.component('comp1').geom('geom1').feature('imp1').set('type', 'dxf');
model.component('comp1').geom('geom1').feature('imp1').set('filename', '../yjn2_cfd_deck_200915.dxf');
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'solid');
model.component('comp1').geom('geom1').create('csol1', 'ConvertToSolid');
model.component('comp1').geom('geom1').feature('csol1').selection('input').set({'imp1'});
model.component('comp1').geom('geom1').create('del1', 'Delete');

model.label('imsi.mph');

model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').feature('imp1').set('alllayers', {'CS-DIML' 'CS-STEL-MAJR' 'dummy' '0' 'CENTER' 'CZ-SYMB' '3' '19 ' '1_CR-DEGN' '1'  ...
'7' '6' ''});
model.component('comp1').geom('geom1').feature('imp1').set('knit', 'curve');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').run('imp1');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').run('csol1');
model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1', [8 9 10 11 12 13 14 15 16 17 18 22 23 24 25 26 27 28 33 34 35 36 44 45 46 47 48 49 50 56 60 61 63 64 65 67 68 69 71 73 74 77 79 81 82 86 88 90 91 95 97 99 100 103 105 107 108 111 113 119 120 121 122 123 124 126 144 147 148 149 150 151 152 153 154 155 156 157 159 160 161 162 163 164 166 167 168 169 170 173 175 177 178 181 183 185 186 190 192 194 196 197 199 201 203 205 206 209 211 213 214 217 219 221 222 225 227 229 230 233 235 237 238 241 244 246 247 248 251 253 255 256 259 261 263 264 267 269 271 272 275 277 279 280 283 285 287 288 292 293 295 298 299 300 303 305 307 308 311 313 315 316 319 324 336 344 347 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 383 384 386 387 388 389 390 391 392 393 394 395 396 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 418 445 446 449 450 453 454 455 456 457 458 459 460 461 462 463 464 465 466 468 469 470 471 472 473 474 475 476 477 479 480 483 484 487 488 491 492 495 496 499 500 515 516 517 518 520 521 522 523 524 525 526 527 528 529 530 533 534 537 538 541 542 545 546 549 550 553 554 557 558 561 562 565 566 569 570 573 574 577 578 581 582 585 586 589 590 593 594 597 598 601 614 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637]);
model.component('comp1').geom('geom1').feature('del1').selection('input').init(2);
model.component('comp1').geom('geom1').feature('del1').selection('input').set('csol1', [2 9 10 11 15 16 17 24 26 27 28 29 30 31]);
model.component('comp1').geom('geom1').run('del1');

out = model;
