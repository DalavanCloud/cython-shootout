# The Computer Language Benchmarks Game
# http://shootout.alioth.debian.org/
#
# Contributed by Sebastien Loisel
# Fixed by Isaac Gouy
# Sped up by Josh Goldfoot
# Dirtily sped up by Simon Descarpentries
# Used list comprehension by Vadim Zelenin

from libc.stdlib cimport malloc
from libc.math cimport sqrt

from sys       import argv

cdef double eval_A(long i, long j):
    cdef long ij = i + j
    return 1.0 / (((ij * (ij + 1)) >> 1) + i + 1)

cdef double *eval_A_times_u(double* u, long n):
    cdef long i, j
    #cdef double u_j
    cdef double* tmp = <double *> malloc(n*sizeof(double))

    for i in xrange(n):
        tmp[i] = 0.0
        for j in xrange(n):
            tmp[i] += eval_A(i, j) * u[j]
    #free(u)
    return tmp

cdef double *eval_At_times_u(double* u, long n):
    cdef long i,j
    #cdef double u_j
    cdef double* tmp = <double *> malloc(n*sizeof(double))
    
    for i in xrange(n):
        tmp[i] = 0.0
        for j in xrange(n):
            tmp[i] += eval_A(j,i) * u[j]
    #free(u)
    return tmp

cdef double *eval_AtA_times_u(double* u, long n):
    return eval_At_times_u(eval_A_times_u(u, n), n)

def main():
    cdef long n = int(argv[1])
    cdef double* u = <double *> malloc(n*sizeof(double))
    cdef double* v = <double *> malloc(n*sizeof(double))
    cdef double* tmp = <double *> malloc(n*sizeof(double))
    cdef double vBv, vv
    cdef long i
    for i in xrange(n):
        u[i] = 1.0

    for dummy in xrange(10):
        v = eval_AtA_times_u(u, n)
        u = eval_AtA_times_u(v, n)

    vBv = vv = 0.0
    for i in xrange(n):
        vBv += u[i] * v[i]
        vv += v[i] * v[i] 

    print "%0.9f" % (sqrt(vBv/vv))

main()
