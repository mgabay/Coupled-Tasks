#!/usr/bin/python
import argparse, math, os, subprocess, shlex, sys


class CoupledTasks:
    """ Represents coupled tasks """

    def __init__ (self, a, b, L):
        self.a = a
        self.b = b
        self.L = L
        self.optprof = ()
        self.lst = []


    def compute_opt_cycle(self):
        beta = int(math.floor(self.L/(self.a + self.b)))
        R = int(math.floor(self.L - beta * (self.a + self.b)))
        if (R < self.a) :
            alpha = 0
            gamma = R
        else :
            alpha = 1
            gamma = R - self.a
    
        if (gamma < (beta + 1)*(self.a - self.b)):
            self.optprof = alpha, beta, gamma
            return alpha, beta, gamma

        alpha = int(math.floor(self.L / self.a))
        beta = 0
        gamma = self.L - alpha * self.a
        self.optprof = alpha, beta, gamma
        return self.optprof


    def gen_profile_list(self):
        al = self.optprof[0]
        be = self.optprof[1]
        ga = self.optprof[2]

        self.lst = []

        for i in xrange(0, al/2 + 1):
            self.lst.append((al - 2*i, be + i, ga + i*(self.a - self.b)))

        for i in xrange(1, be+1):
            if ( ga - i * (self.a - self.b) < 0 ):
                break
            self.lst.insert(0, (al + 2*i, be - i, ga - i * (self.a - self.b)))

        return self.lst


    def solve_pb(self):
        lst = self.lst

        lng = len(lst)
        max_gain = lst[0][2] + lst[-1][2]
        best = (lst[0], lst[-1])
        for i in reversed(xrange(0, lng - 1)):
            for j in reversed(xrange(1, i+1)):
                gain = lst[i][2] + lst[j][2]
                if (gain <= max_gain):
                    continue
                ret = self.solve(lst[i], lst[j])
                if (ret == True):
                    max_gain = gain
                    best = (lst[i], lst[j])
        return best

    def solve(self, p1, p2):
        f = open('data_script_py.dat','w')
        f.write('a = ' + str(self.a) + ';\n')
        f.write('b = ' + str(self.b) + ';\n')
        f.write('L = ' + str(self.L) + ';\n')
        f.write('alpha1 = ' + str(p1[0]) + ';\n')
        f.write('alpha2 = ' + str(p2[0]) + ';\n')
        f.write('beta1 = ' + str(p1[1]) + ';\n')
        f.write('beta2 = ' + str(p2[1]) + ';\n')
        f.close()
        print "==============================================================="
        print "=        Solving with profiles", p1, p2, "           ="
        print "==============================================================="
        sys.stdout.flush()
        command_line = "oplrun pcase.mod data_script_py.dat"
        args = shlex.split(command_line)
        ret = subprocess.call(args)
        os.remove('data_script_py.dat')
        return not(ret)


def enum_L_increasing(a, b, Lmin, Lmax):
    for i in range(Lmin, Lmax+1):
        ctasks = CoupledTasks(a, b, i)
        ctasks.compute_opt_cycle()
        if (ctasks.optprof[1] == 0):
            print i, "    ", ctasks.optprof;


def main():
    parser = argparse.ArgumentParser(description = 'Process some integers.')

    parser.add_argument('a', metavar = 'a', type = int, nargs = 1,
	    help = 'length of operation a')

    parser.add_argument('b', metavar = 'b', type = int, nargs = 1,
	    help = 'length of operation b')

    parser.add_argument('L', metavar = 'L', type = int, nargs = 1,
	    help = 'length of idle time L')

    parser.add_argument('-p', dest='ponly', action='store_true',
        help='computes the profile only')

    parser.add_argument('-v', dest='verbose', action='store_true',
        help='verbose mode')

    parser.add_argument('-e', dest='enum', action='store_true',
        help='enumerates all (alpha, 0) optimal profiles and returns')

    args = parser.parse_args()
    a = args.a.pop()
    b = args.b.pop()
    L = args.L.pop()

    if (args.enum >= 1):
        enum_L_increasing(a, b, L, 100*(a+b))
        return

    ct = CoupledTasks(a, b, L)

    ct.compute_opt_cycle()

    if (args.ponly):
        print ct.optprof
        return

    ct.gen_profile_list()
    opt = ct.solve_pb()
    print "==============================================================="
    print ""

    if (args.verbose):
        print "Optimal profiles:"
        for i in reversed(xrange(0,len(ct.lst))):
            print ct.lst[i]

    print "Optimal solution : ", opt[0], opt[1]
    print "GAIN : ", opt[0][-1] + opt[1][-1]


# Program
if (__name__ == "__main__"):
    main()
