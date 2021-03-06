
<<< setup


<<< generate

Tried aggregator 1 time.
MIP Presolve eliminated 5 rows and 1 columns.
MIP Presolve modified 15 coefficients.
Aggregator did 18 substitutions.
Reduced MIP has 35 rows, 48 columns, and 95 nonzeros.
Probing time =    0.00 sec.
Tried aggregator 1 time.
MIP Presolve eliminated 6 rows and 6 columns.
Aggregator did 2 substitutions.
Reduced MIP has 27 rows, 40 columns, and 79 nonzeros.
Presolve time =    0.00 sec.
Clique table members: 7.
MIP emphasis: balance optimality and feasibility.
Root relaxation solution time =    0.00 sec.

        Nodes                                         Cuts/
   Node  Left     Objective  IInf  Best Integer     Best Node    ItCnt     Gap         Variable B Parent  Depth

      0     0       30.0000     8                     30.0000        0         
                    38.0000     1                   Cuts:  10        8         
                    38.0000     1                   Fract:  1       10         
                    38.0000     3                    Cuts:  0       11         
*     5     1                   0       62.0000       44.0000       19   29.03%           id154 U      4      5
*    10+    2                   0       61.0000       44.0000       27   27.87%
*    36     3                   0       60.0000       50.0000       61   16.67%            id96 U     35      9

Implied bound cuts applied:  1
Gomory fractional cuts applied:  6

<<< solve


OBJECTIVE: 60
t =  [0 11 22 38 49 60]
Optimal = 98

<<< post process


<<< done

