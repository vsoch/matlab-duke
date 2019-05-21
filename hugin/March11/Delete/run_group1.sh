#!/bin/bash

# ------run_group1.sh-----------
#
# This script runs a loop of multiple FEAT analysis!
 
#-------SUBMITTING ON COMMAND LINE--------------
# 
# ./run_group1.sh

EXP_NAME=TAOS.01

# Loop through the subjects to delete old run data
for i in 178 189 191 201 202 204 211 214 218 225 229 234 250 270 277 281 291 296 302 304 305 306 307 314 323 324 330 331 332 344 350 357 363 364 365 367 370 375 376 380 383 387 389 398 399 400 401 411 416 425 426 431 432 433 443 446 452 453 454 455 456 457 458 459 460 461 EI0008 EI0010 EI0015 EI0018 EI0022 EI0023 EI0026 EI0027 EI0030 EI0031 EI0034 EI0037 EI0040 EI0041 EI0045 EI0046 EI0051 EI0058 EI0061 EI0068 EI0069 EI0073 EI0074 EI0076 EI0078 EI0079 EI0083 EI0085 EI0086 EI0087 EI0090 EI0097 EI0102 EI0105 EI0110 EI0113 EI0114 EI0117 EI0118 EI0123 EI0124 EI0125 EI0129 EI0130 EI0139 EI0145 EI0149 EI0150 EI0156 EI0157 EI0160 EI0163 EI0168 EI0169 EI0175 EI0182 EI0183 EI0187 EI0188 EI0189 EI0194 EI0195 EI0200 EI0202 EI0203 EI0206 EI0207 EI0212 EI0215 EI0216 EI0217 EI0221 EI0225 EI0226 EI0227 EI0228 EI0230 EI0231 EI0232 EI0234 EI0236 EI0238 EI0239 EI0240 EI0250 EI0251 EI0253 EI0254 EI0260 EI0261 EI0262 EI0265 EI0266 EI0270 EI0271 EI0280 EI0281 EI0283 EI0286 EI0287 EI0291 EI0293 EI0295 EI0297 EI0301 EI0302 EI0303 EI0304 EI0305 EI0308 EI0309 EI0311 EI0314 EI0315 EI0316 EI0319 EI0320 EI0322 EI0323 EI0326 EI0327 EI0328 EI0332 EI0334 EI0335 EI0338 EI0341 EI0344 EI0353 EI0354 EI0356 EI0358 EI0359 EI0360 EI0361 EI0363 EI0366 EI0368 EI0370 EI0373 EI0374 EI0375 EI0376 EI0381 EI0382 EI0383 EI0387 EI0388 EI0389 EI0392 EI0393 EI0395 EI0396 EI0397 EI0399 EI0400 EI0402 EI0403 EI0404 EI0406 EI0408 EI0410 EI0413 EI0415 EI0418 EI0419 EI0421 EI0427 EI0428 EI0429 EI0431 EI0435 EI0436 EI0438 EI0440 EI0441 EI0443 EI0444 EI0447 EI0448 EI0454 EI0455 EI0457 EI0460 EI0461 EI0463 EI0464 EI0467 EI0468 EI0475 EI0476 EI0478 EI0482 EI0485 EI0491 EI0494 EI0495 EI0497 EI0500 EI0501 EI0502 EI0503 EI0507 EI0508 EI0511 EI0512 EI0513 EI0516 EI0517 EI0522 EI0523 EI0524 EI0529 EI0530 EI0531 EI0535 EI0536 EI0537 EI0539 EI0540 EI0541 EI0543 EI0547 EI0548 EI0551 EI0552 EI0553 EI0554 EI0558 EI0559 EI0562 EI0563 EI0564 EI0565 EI0566 EI0567 EI0568 EI0572 EI0573 EI0574 EI0577 EI0588 EI0590
do


SUBJ=$i
 
qsub -v EXPERIMENT=$EXP_NAME Group1_delete.sh $SUBJ
 
done
