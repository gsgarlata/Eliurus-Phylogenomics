          seed =  -1

       seqfile = template_input_path/seq_file_name
      Imapfile = template_input_path/Imap_file_name
       outfile = template_output_path/out.txt
      mcmcfile = template_output_path/mcmc.txt

 * speciesdelimitation = 0
 * speciesdelimitation = 1 0 2    * species delimitation rjMCMC algorithm0 and finetune(e)
 speciesdelimitation = 1 1 2 1 * species delimitation rjMCMC algorithm1 finetune (a m)
         speciestree = 0

   speciesmodelprior = 1  * 0: uniform LH; 1:uniform rooted trees; 2: uniformSLH; 3: uniformSRooted

  species&tree = 3  Emyox Emin Esp
                    4 4 4
                 (Emin,(Emyox, Esp));
        phase = 1 1 1
                  
       usedata = 1  * 0: no data (prior); 1:seq like
         nloci = n_partitions * number of data sets in seqfile

     cleandata = 0    * remove sites with ambiguity data (1:yes, 0:no)?

    thetaprior = 3 0.02   # invgamma(a, b) for theta
      tauprior = 3 0.002    # invgamma(a, b) for root tau & Dirichlet(a) for other tau's

*     heredity = 1 4 4
*    locusrate = 1 5

      finetune =  1: 5 0.00001 0.00001  0.00001 0.006 0.33 1.0  # finetune for GBtj, GBspr, theta, tau, mix, locusrate, seqerr

         print = 1 0 0 0   * MCMC samples, locusrate, heredityscalars, Genetrees
        burnin = 5000
      sampfreq = 100
       nsample = 20000
       checkpoint = 5000 5000
        * threads = 8 1 1
