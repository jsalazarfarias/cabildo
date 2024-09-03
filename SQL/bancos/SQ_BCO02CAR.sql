DROP SEQUENCE SISESMER.SQ_BCO02CAR;

CREATE SEQUENCE SISESMER.SQ_BCO02CAR
  START WITH 155315
  MAXVALUE 999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;


DROP PUBLIC SYNONYM SQ_BCO02CAR;

CREATE PUBLIC SYNONYM SQ_BCO02CAR FOR SISESMER.SQ_BCO02CAR;


