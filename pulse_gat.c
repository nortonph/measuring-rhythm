/*  pulse_gat.c
 *   takes 5 arguments: 
 *   events: 1-dimensional array of timestamps of events
 *   stepF:  pulse frequency is increased in stepF Hz steps
 *   stepO:  pulse offset is increased in stepO ms steps
 *   minF:   minimum pulse frequency (MUST BE INTEGER MULTIPLE OF stepF!!!)
 *   maxF:   maximum pulse frequency (MUST BE INTEGER MULTIPLE OF stepF!!!)
 *   returns two arrays of equal length, the first containing the frequency 
 *   values (freq) between minFreq and maxFreq in stepFreq steps, the other
 *   the root-mean-squared deviation (rmsd) of all events in the pattern 
 *   to the nearest event in the pulse of the corresponding frequency.
 */

#include <math.h>
#include <float.h>
#include <stdlib.h>
#include "mex.h"

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    /* input variables */
    double *events;
    double stepF;
    double stepO;
    double minF;
    double maxF;
    
    /* output variables */
    double *freq;
    double *rmsd;
    
    /* internal variables */
    int nEvents;
    int nOutVal;
    int nPulses;
    int iF;
    int iP;
    int iE;
    int intMinF;
    int intMaxF;
    int intFreq;
    double offset;
    double p;
    double startP;
    double stopP;
    double period;
    double meanSqrDev;
    double meanSqrDevTmp;
    double *pulse;
    double *eventDev;
    double eventDevTmp;
    double eventDevSum;

    /* check for correct number of in- and outputs */
    if(nrhs != 5) {
        mexErrMsgIdAndTxt("MyToolbox:pulse_gat:nrhs", "Five inputs required.");
    }
    if(nlhs != 2) {
        mexErrMsgIdAndTxt("MyToolbox:pulse_gat:nlhs", "Two outputs required.");
    }
    /* make sure the first input argument is double and a row vector */
    if( !mxIsDouble(prhs[0]) || 
         mxIsComplex(prhs[0])) {
        mexErrMsgIdAndTxt("MyToolbox:pulse_gat:notScalar", "Input event data must be type double.");
    }
    if(mxGetM(prhs[0]) != 1) {
        mexErrMsgIdAndTxt("MyToolbox:pulse_gat:notRowVector", "Input event data must be a row vector.");
    }
    /* make sure the input arguments 2-5 are scalar and type double */
    if( !mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) || mxGetNumberOfElements(prhs[1]) != 1 ||
        !mxIsDouble(prhs[2]) || mxIsComplex(prhs[2]) || mxGetNumberOfElements(prhs[2]) != 1 ||
        !mxIsDouble(prhs[3]) || mxIsComplex(prhs[3]) || mxGetNumberOfElements(prhs[3]) != 1 ||
        !mxIsDouble(prhs[4]) || mxIsComplex(prhs[4]) || mxGetNumberOfElements(prhs[4]) != 1) {
        mexErrMsgIdAndTxt("MyToolbox:pulse_gat:notDouble", "Inputs 2-5 must be a scalar of type double.");
    }

    /* get values from input arguments */
    events  = mxGetPr(prhs[0]);
    nEvents = mxGetN(prhs[0]);
    stepF   = mxGetScalar(prhs[1]);
    stepO   = mxGetScalar(prhs[2]);
    minF    = mxGetScalar(prhs[3]);
    maxF    = mxGetScalar(prhs[4]);

    /* calculate length of output arrays */
    nOutVal = (int) floor((maxF-minF) / stepF) + 1;
    
    /* create output arrays */
    plhs[0] = mxCreateDoubleMatrix(1,nOutVal,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1,nOutVal,mxREAL);

    /* get pointers to the real data in the output arrays */
    freq = mxGetPr(plhs[0]);
    rmsd = mxGetPr(plhs[1]);
    
    /* rmsd calculation */
    iF = 0;
    /* convert min and max frequency to integers */
    intMinF = minF / stepF;
    intMaxF = maxF / stepF;
    for (intFreq = intMinF; intFreq <= (intMaxF); intFreq++)
    {
        /* length of one pulse period */
        period  = 1/(intFreq*stepF);       

        /* set start & end of pulse to 1 period before & after sequence */
        startP  = period * floor((events[0] - 2 * period) / period);
        stopP   = events[nEvents-1] + period;

        /* stepwise increase offset & calculate meanSqrDev for each */
        meanSqrDev = DBL_MAX;
        for (offset = 0; offset <= period; offset += stepO)
        {
            /* create a pulse with the current offset */
            iP          = 0;
            pulse       = NULL;
            nPulses     = ceil((stopP-(startP+offset))/period);
            pulse       = mxMalloc(nPulses * sizeof *pulse);

            for (p = startP+offset; p <= stopP; p += period)
            {
                pulse[iP] = p;
                iP++;
            }
            
            /* calculate mean squared deviation for current pulse */
            eventDev    = NULL;
            eventDev    = mxMalloc(nEvents * sizeof *eventDev);

            for (iE = 0; iE < nEvents; iE++)
            {
                /* find min deviation of current event from pulse and square it */
                eventDev[iE] = DBL_MAX;
                for (iP = 0; iP < nPulses; iP++)
                {
                    eventDevTmp = fabs(pulse[iP] - events[iE]);
                    if (eventDevTmp < eventDev[iE])
                    {
                        eventDev[iE] = eventDevTmp;
                    }
                }
                eventDev[iE] = eventDev[iE] * eventDev[iE];
            }

            /* calculate mean squared deviation & save if minimum so far */
            eventDevSum     = 0;
            for (iE = 0; iE < nEvents; iE++)
            {
                eventDevSum += eventDev[iE];
            }
            meanSqrDevTmp = eventDevSum / nEvents;
            if (meanSqrDevTmp < meanSqrDev)
            {   
                meanSqrDev = meanSqrDevTmp;
            }
            mxFree(pulse);
            mxFree(eventDev);
        } /* end for (offset = 0; offset <= period; offset += stepO) */

        freq[iF]        = intFreq * stepF;
        rmsd[iF]        = sqrt(meanSqrDev);
        iF++;
    } /* end for (intFreq = intMinF; intFreq <= (intMaxF+1); intFreq++) */
}
