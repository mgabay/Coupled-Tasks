import argparse

def pure_length(a,b,L,n,alpha,beta):
    """ Compute the length the pure strategy solution """
    F = alpha + 2*beta
    gamma = L - alpha * a - beta*(a+b)
    k = n // ( (beta+1)*(F+1) )
    n1 = n % ( (beta+1)*(F+1) )
    k1 = n1 // (F+1)
    r = n1 % (F+1)
    r1 = r - (alpha + 1)
    r2 = r - (alpha + beta + 1)

    lgt = ((beta+1)*k+k1)*(a+2*L+b)-k*gamma
    if k1 > 0: lgt -= gamma
    ext = -lgt-1
    #print "F k k1 r r1 r2"
    #print F,k,k1,r,r1,r2

    if r == 0:
        ext = beta * (a+b)
        if k1 != 0 and beta != 0: ext += gamma
    elif r <= alpha + 1:
        ext = r*a+L+b
    elif r <= alpha + beta + 1:
        ext = r*a + L + (r1+1)*b
        if k1 != 0 and r1 >= k1: ext += gamma
    else:
        ext = a + r2 * (a+b) + 2*L + b
        if k1 != 0 and r2 > k1: ext += gamma

    return lgt + ext


def test_all(a, b, L, n):
    opt = []
    minv = n*L

    alpha = L // a
    beta = 0
    rem = L - alpha * a

    while alpha >= 0:
        beta = rem // (a+b)
        v = pure_length(a,b,L,n,alpha,beta)
        if v < minv:
            minv = v
            opt = [(alpha, beta)]
        elif v == minv: opt.append((alpha,beta))

        alpha -= 1
        rem = L - alpha * a

    return minv, opt


def main():
    parser = argparse.ArgumentParser(description="Compute the value of the pure strategy solution")
    parser.add_argument("-i", metavar=("a","b","L"), type=int, nargs=3,
            default=[5,3,100], help="The instance")
    parser.add_argument("-n", metavar="n", type=int,
            default=30, help="The number of jobs")
    parser.add_argument('-p', nargs=2, metavar=('alpha', 'beta'),
            default=[1,0], type=int, help="The profile")
    parser.add_argument('-a', action='store_true', help="Test all saturated profiles.")
    parser.add_argument('-r', nargs=2, type=int, metavar=('r1','r2'), help="Test all profiles for n = r1 to r2.")

    args = parser.parse_args()
    a, b, L = args.i
    n = args.n

    if args.r:
        r1, r2 = args.r
        print "n\tCmax\tProfiles"
        for i in xrange(r1,r2+1):
            mn, opt = test_all(a,b,L,i)
            print str(i)+"\t"+str(mn)+"\t"+str(opt)
            #for o in opt:
            #    al, be = o
            #    if al != 0:
            #        print str(i)+"\t"+str(mn)+"\t"+str(opt)
            #        break

    elif args.a:
        mn, opt = test_all(a,b,L,n)
        print "Opt = "+str(mn)
        print "Solutions: "+str(opt)

    else:
        alpha, beta = args.p
        print "("+str(alpha)+","+str(beta)+") - n="+str(n)+" :\t"+\
            str(pure_length(a,b,L,n,alpha,beta))

if __name__ == "__main__":
    main()
