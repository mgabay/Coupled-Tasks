
<<< setup


<<< generate

Tried aggregator 1 time.
MIP Presolve eliminated 15 rows and 1 columns.
MIP Presolve modified 120 coefficients.
Aggregator did 120 substitutions.
Reduced MIP has 255 rows, 376 columns, and 630 nonzeros.
Probing time =    0.00 sec.
Tried aggregator 1 time.
MIP Presolve eliminated 15 rows and 15 columns.
Reduced MIP has 240 rows, 361 columns, and 600 nonzeros.
Presolve time =    0.00 sec.
Clique table members: 105.
MIP emphasis: balance optimality and feasibility.
Root relaxation solution time =    0.00 sec.

        Nodes                                         Cuts/
   Node  Left     Objective  IInf  Best Integer     Best Node    ItCnt     Gap         Variable B Parent  Depth

      0     0       90.0000   126                     90.0000        0         
                   100.1818    21                  Cuts:  142      123         
                   102.2014    19                  Fract:  28      159         
                   102.2014    18                    Cuts:  0      164         
                   102.2014    18                    Cuts:  0      167         
*    97    37                   0      188.0000      114.0000      299   39.36%           id816 D     96     36
    100    35      132.0000    13      188.0000      118.0000      312   37.23%           id298 U     99      7
    200    65      137.0000    11      188.0000      123.0000      452   34.57%           id543 U    199     12
    300    85      160.0000     9      188.0000      131.0000      608   30.32%           id725 D    298     17
    400   104      158.0000     8      188.0000      132.0000      757   29.79%           id382 D    399     17
    500   125      182.0000     8      188.0000      132.0000      884   29.79%           id536 U    499     22
    600   139    infeasible            188.0000      137.0000     1009   27.13%           id781 D    599     22
    700   152    infeasible            188.0000      138.0000     1159   26.60%           id550 U    699     20
*   728   139                   0      186.0000      138.0000     1197   25.81%           id739 D    727     34
*   751   140                   0      185.0000      138.0000     1228   25.41%           id900 D    749     35
    800   146    infeasible            185.0000      138.0000     1290   25.41%            id81 U    798     17
    900   156      149.0000     8      185.0000      138.0000     1416   25.41%            id88 D    898     17
   1000   171        cutoff            185.0000      140.1429     1537   24.25%           id858 D    998     21
Elapsed time =   0.20 sec. (tree size =  0.05 MB).
   1100   179      166.0000     8      185.0000      143.0000     1677   22.70%           id676 D   1099     22
   1200   186      143.0000    10      185.0000      143.0000     1797   22.70%           id858 D    512     12
   1300   197    infeasible            185.0000      144.0000     1911   22.16%            id81 U   1299     14
   1400   194      150.0000     7      185.0000      144.0000     2015   22.16%           id389 D   1398     16
   1500   202      182.0000     4      185.0000      144.0000     2128   22.16%           id774 D   1499     24
   1600   215      155.0000     8      185.0000      149.0000     2257   19.46%           id550 D   1599     19
   1700   222      161.0000     9      185.0000      149.0000     2378   19.46%           id732 D   1698     20
   1800   225      181.0000     2      185.0000      149.0000     2510   19.46%           id529 D   1799     27
   1900   233    infeasible            185.0000      149.0000     2626   19.46%            id88 U   1899     22
   2000   240      160.0000     8      185.0000      149.0000     2745   19.46%           id382 D   1998     18
Elapsed time =   0.37 sec. (tree size =  0.07 MB).
   2100   252        cutoff            185.0000      149.0000     2855   19.46%           id543 D   2098     26
   2200   262      173.0000     7      185.0000      149.0000     2976   19.46%           id732 D   2199     23
*  2290+  268                   0      184.0000      150.0000     3077   18.48%
   2300   271      180.0000     1      184.0000      150.0000     3082   18.48%           id851 D   2299     36
   2400   289      161.0000     7      184.0000      150.0000     3196   18.48%           id543 D   2398     22
   2500   297    infeasible            184.0000      154.0000     3315   16.30%           id865 U   2499     24
   2600   304      181.0000     3      184.0000      155.0000     3443   15.76%           id459 D   2598     27
   2700   313      155.0000     7      184.0000      155.0000     3564   15.76%           id466 U   2699     21
   2800   323    infeasible            184.0000      155.0000     3695   15.76%           id732 D   2798     25
   2900   323    infeasible            184.0000      155.0000     3806   15.76%           id879 U   2899     24
   3000   330    infeasible            184.0000      155.0000     3924   15.76%           id725 U   2999     21
Elapsed time =   0.55 sec. (tree size =  0.10 MB).
   3100   336      176.0000     9      184.0000      155.0000     4054   15.76%           id375 D   3098     23
   3200   349    infeasible            184.0000      155.0000     4178   15.76%           id466 U   3199     18
   3300   354    infeasible            184.0000      155.0000     4294   15.76%           id725 U   3299     18
   3400   368      176.0000     5      184.0000      155.0000     4421   15.76%           id732 D   3398     26
   3500   382    infeasible            184.0000      155.0000     4530   15.76%           id284 U   3498     22
   3600   386      172.0000     4      184.0000      156.0000     4651   15.22%           id865 D   3599     31
   3700   406      166.0000     9      184.0000      156.0000     4764   15.22%           id613 D   3698     21
   3800   426        cutoff            184.0000      156.0000     4888   15.22%           id816 D   3799     28
   3900   438    infeasible            184.0000      156.0000     5005   15.22%           id886 U   3899     28
   4000   444      164.0000     6      184.0000      158.0000     5115   14.13%           id823 D   3998     22
Elapsed time =   0.73 sec. (tree size =  0.13 MB).
   4100   448      178.0000     4      184.0000      160.0000     5239   13.04%           id536 D   4098     25
   4200   453      160.0000     7      184.0000      160.0000     5362   13.04%           id543 D   3042     20
   4300   469      166.0000     7      184.0000      160.0000     5486   13.04%           id620 D   4299     22
   4400   480    infeasible            184.0000      160.0000     5620   13.04%           id389 U   4399     20
   4500   483        cutoff            184.0000      161.0000     5724   12.50%           id459 D   4498     26
   4600   484      176.0000     5      184.0000      161.0000     5842   12.50%           id613 D   4599     26
   4700   497      182.0000     5      184.0000      161.0000     5968   12.50%           id459 D   4698     24
   4800   511      181.0000     3      184.0000      161.0000     6103   12.50%           id536 D   4798     27
   4900   522      179.0000     7      184.0000      161.0000     6220   12.50%           id893 D   4898     23
   5000   526    infeasible            184.0000      161.0000     6331   12.50%           id389 U   4999     20
Elapsed time =   0.89 sec. (tree size =  0.16 MB).
   5100   538      172.0000     7      184.0000      161.0000     6450   12.50%           id781 D   5099     25
   5200   543      164.0000     5      184.0000      161.0000     6561   12.50%           id466 D   5191     22
   5300   552      172.0000     6      184.0000      161.0000     6675   12.50%           id781 D   5298     26
   5400   560      173.0000     8      184.0000      161.0000     6784   12.50%           id543 D   5399     23
   5500   577      182.0000     6      184.0000      161.0000     6888   12.50%           id676 D   5499     25
   5600   577      167.0000     5      184.0000      162.0000     7003   11.96%           id823 D   5019     23
   5700   584      173.0000     6      184.0000      162.0000     7121   11.96%           id669 U   5699     22
   5800   592      167.0000     8      184.0000      162.0000     7241   11.96%           id879 U   5799     22
   5900   607      172.0000     5      184.0000      162.0000     7360   11.96%           id669 D   5898     27
   6000   628      168.0000    11      184.0000      164.0000     7474   10.87%           id676 D   5999     21
Elapsed time =   1.06 sec. (tree size =  0.19 MB).
   6100   632      170.0000     5      184.0000      164.0000     7596   10.87%           id536 D   6092     23
   6200   641      176.0000     4      184.0000      164.0000     7716   10.87%           id767 D   6199     24
   6300   644    infeasible            184.0000      165.0000     7822   10.33%            id88 U   6299     29
   6400   647    infeasible            184.0000      165.0000     7948   10.33%           id781 D   6398     26
   6500   644      177.0000     6      184.0000      166.0000     8056    9.78%           id851 U   6499     24
   6600   648      172.0000     7      184.0000      166.0000     8183    9.78%           id816 D   3060     26
   6700   652      166.0000     8      184.0000      166.0000     8305    9.78%           id536 U   4336     21
   6800   655      167.0000     6      184.0000      166.0000     8419    9.78%           id732 D   6799     23
   6900   646      181.0000     4      184.0000      166.0000     8520    9.78%           id613 D   6899     28
   7000   644      172.0000     5      184.0000      166.0000     8625    9.78%           id599 D   6993     25
Elapsed time =   1.22 sec. (tree size =  0.20 MB).
   7100   646      172.0000     4      184.0000      166.0000     8721    9.78%           id466 D   7099     26
   7200   647      173.0000     6      184.0000      167.0000     8849    9.24%           id823 D   3533     27
   7300   652      172.0000     4      184.0000      167.0000     8966    9.24%           id473 D   7299     27
   7400   654      178.0000     4      184.0000      167.0000     9075    9.24%           id599 U   7399     28
   7500   660      177.0000     7      184.0000      167.0000     9186    9.24%           id816 U   7498     27
   7600   660      173.0000     5      184.0000      167.0000     9313    9.24%           id851 D   7598     27
   7700   665    infeasible            184.0000      167.0000     9418    9.24%           id277 D   7699     28
   7800   664    infeasible            184.0000      167.0000     9525    9.24%           id466 U   7799     21
   7900   660      173.0000     5      184.0000      167.0000     9639    9.24%           id676 D   7899     25
   8000   657        cutoff            184.0000      168.0000     9732    8.70%           id865 D   7999     28
Elapsed time =   1.39 sec. (tree size =  0.20 MB).
   8100   664      174.0000     4      184.0000      168.0000     9855    8.70%           id186 D   8099     28
   8200   671      179.0000     2      184.0000      168.0000     9945    8.70%           id683 D   8199     30
*  8290+  665                   0      183.0000      170.0000    10031    7.10%
   8300   665      182.0000     2      183.0000      170.0000    10045    7.10%           id851 D   8298     26
   8400   657        cutoff            183.0000      170.0000    10160    7.10%           id865 D   8398     26
   8500   652      170.0000     6      183.0000      170.0000    10279    7.10%           id676 D   8499     23
   8600   656        cutoff            183.0000      170.0000    10392    7.10%           id536 D   8598     26
   8700   639      177.0000     7      183.0000      171.0000    10493    6.56%           id536 U   8699     25
   8800   613      182.0000     6      183.0000      172.0000    10595    6.01%           id676 D   8799     27
   8900   598        cutoff            183.0000      172.0000    10701    6.01%           id669 D   8898     28
   9000   581      182.0000     4      183.0000      172.0000    10809    6.01%           id459 U   8999     27
Elapsed time =   1.59 sec. (tree size =  0.18 MB).
   9100   572        cutoff            183.0000      172.0000    10906    6.01%           id543 D   9099     25
   9200   557    infeasible            183.0000      173.0000    11002    5.46%           id683 U   9199     28
   9300   542      182.0000     3      183.0000      173.0000    11105    5.46%           id459 D   9299     29
   9400   529        cutoff            183.0000      173.0000    11204    5.46%           id816 D   9399     33
   9500   511      176.0000     7      183.0000      173.0000    11318    5.46%           id879 D   7689     25
   9600   492      174.0000     5      183.0000      174.0000    11422    4.92%           id858 D   8002     28
   9700   471      181.0000     5      183.0000      175.0000    11527    4.37%           id459 D   9699     25
   9800   452        cutoff            183.0000      176.0000    11632    3.83%           id529 D   3556     28
   9900   424      182.0000     7      183.0000      176.0000    11744    3.83%           id676 D   4796     25
  10000   407      182.0000     3      183.0000      176.0000    11874    3.83%           id865 D   9999     28
Elapsed time =   1.78 sec. (tree size =  0.13 MB).
  10100   397      182.0000     6      183.0000      176.0000    11983    3.83%           id683 D  10099     25
  10200   379        cutoff            183.0000      176.0000    12094    3.83%           id459 D  10198     26
  10300   340        cutoff            183.0000      178.0000    12160    2.73%           id886 D   7531     32
  10400   257        cutoff            183.0000      179.0000    12195    2.19%           id879 D   7909     24
  10500   176    infeasible            183.0000      181.0000    12249    1.09%           id781 U   8460     26
  10600    93        cutoff            183.0000      182.0000    12300    0.55%           id676 D   5774     24
  10700    13        cutoff            183.0000      182.0000    12352    0.55%           id781 D   6581     25

Gomory fractional cuts applied:  29

<<< solve


OBJECTIVE: 183
t =  [0 11 17 23 38 61 78 84 99 105 122 145 160 166 172 183]
Optimal = 221

<<< post process


<<< done

