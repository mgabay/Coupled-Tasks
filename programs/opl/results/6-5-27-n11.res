
<<< setup


<<< generate

Tried aggregator 1 time.
MIP Presolve eliminated 10 rows and 1 columns.
MIP Presolve modified 55 coefficients.
Aggregator did 59 substitutions.
Reduced MIP has 116 rows, 172 columns, and 319 nonzeros.
Probing time =    0.00 sec.
Tried aggregator 1 time.
MIP Presolve eliminated 10 rows and 10 columns.
Reduced MIP has 106 rows, 162 columns, and 299 nonzeros.
Presolve time =    0.00 sec.
Clique table members: 45.
MIP emphasis: balance optimality and feasibility.
Root relaxation solution time =    0.00 sec.

        Nodes                                         Cuts/
   Node  Left     Objective  IInf  Best Integer     Best Node    ItCnt     Gap         Variable B Parent  Depth

      0     0       60.0000    56                     60.0000        0         
                    70.1818     9                   Cuts:  63       51         
                    72.3636     6                  Fract:  11       63         
                    73.8831     9                    Cuts:  0       68         
                    73.8831    10                    Cuts:  0       70         
*    58    20                   0      124.0000       82.0000      157   33.87%           id344 D     57     16
*    81    24                   0      123.0000       85.0000      187   30.89%           id435 D     80     18
    100    21      100.0000     7      123.0000       88.0000      205   28.46%           id211 D     98      8
*   114    26                   0      122.0000       88.0000      222   27.87%           id414 U    113     18
    200    34      100.0000     4      122.0000       94.0000      350   22.95%           id148 D    199     11
    300    40        cutoff            122.0000       99.0000      484   18.85%           id435 D    299     14
    400    56      106.0000     6      122.0000      100.0000      608   18.03%           id386 D    389     11
    500    66      110.0000     5      122.0000      105.0000      729   13.93%           id351 U    499     12
    600    72      111.0000     4      122.0000      106.0000      840   13.11%           id351 U    598     12
    700    64      117.0000     5      122.0000      111.0000      948    9.02%           id351 D    341     13
    800    45        cutoff            122.0000      114.0000     1050    6.56%           id309 D    799     15

Gomory fractional cuts applied:  21

<<< solve


OBJECTIVE: 122
t =  [0 6 12 18 24 62 73 84 100 111 122]
Optimal = 160

<<< post process


<<< done

