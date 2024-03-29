library(parallel)
#library(abind)
#library(zoo)

estimate.mixed.model <- function( y, kinship, make.positive=TRUE ) {
  y = y[!is.na(y)]
  if ( length(y) < 1 ) return(NULL)

  use.ids = intersect( names(y), colnames(kinship))
  match.kinship = match( use.ids, colnames(kinship), nomatch=0)
  K = kinship[match.kinship,match.kinship]
  K.eigen.trunc = K.eigen = eigen(K,symmetric=TRUE)
  if ( make.positive ) {
    w.eigen = which( K.eigen$values/K.eigen$values[1] > 1.0e-8 )
    neigen = length(w.eigen) # number of non-trivial principal components
    K.eigen.trunc = K.eigen
    K.eigen.trunc$values = K.eigen.trunc$values[w.eigen]
    K.eigen.trunc$vectors = K.eigen.trunc$vectors[,w.eigen]
  }
  match.phen = match( use.ids, names(y), nomatch=0)
  y = y[match.phen]
  y = scale(y)

  z = t(K.eigen.trunc$vectors) %*% y # transformed phenotype
  zz = z*z
  lambda = K.eigen.trunc$values

  opt.theta1 = optimise( interval=c( 0,1 ),
                         f =function(theta, zz, lambda ) { # log likelihood for mvn
                           u = theta[1]*lambda+1-theta[1]
                           u = ifelse ( abs(u)<1.0e-10, 1.0e-10 , u )
                           return(sum(zz/u) + sum( log(u)))
                         }, zz=zz, lambda=lambda)

  vg = opt.theta1$minimum[1]
  ve = 1-vg
  cat("estimated heritability", vg,"\n")
  E = K.eigen.trunc$vectors
  Lam = vg*K.eigen.trunc$values +ve
  V = Lam^(-0.5)
  inv.sqrt.sigma = ( E %*% diag(V) ) %*% t(E)

  mixed.model.data = list( y=y, K=K, vg=vg, ve=ve, inv.sqrt.sigma=inv.sqrt.sigma, eigen=K.eigen.trunc )
  return(mixed.model.data)
}


mixed.model.gwas <- function( y, genotypes, kinship=NULL, nperm=0 ) {
  # y is an  n-vector of phenotypes.
  # genotypes is a matrix of genotype dosages, n rows and p columns

  # Each element of y should be named (ie names(y) returns meaningful IDs as should rownames(genotypes))
  # so that the code can make sure the phenotypes and genotypes are correctly aligned and ordered.
  # K is the optional kinship matrix. If omitted then it is computed from the genotypes
  # nperm is the number of permutations to perform to determine genomewise significance.

  genos = apply( genotypes, 2, function( g ) {
    s = sd(g, na.rm=TRUE)
    mu = mean(g, na.rm=TRUE)
    if ( s > 0 ) {
      g = ifelse ( is.na(g), 0.0, (g-mu)/s )
    } else {
      g = rep(0, length(g));
    }
    return(g)
  })


  if ( is.null(kinship)) {
    kinship = make.kinship( genos )
  }

  mmd = estimate.mixed.model( y, kinship )

  use.ids = rownames(mmd$y)
  genos = genotypes[match( use.ids, rownames(genotypes), nomatch=0),]

  if ( nrow(genos) != length(use.ids)) {
    cat( "ERROR sample ids in genotypes do not match phenotypes\n")
    return(NULL);
  }

  mm.transformation = mmd$inv.sqrt.sigma
  mm.transformed.y = mm.transformation %*% mmd$y
  mm.transformed.g = mm.transformation %*% genos

  mm.gwas.cor =  cor( mm.transformed.y, mm.transformed.g )
  n = length(mm.transformed.y)
  df = n-2
  t.stat = mm.gwas.cor*sqrt(df)/(1.0e-10+sqrt(1-mm.gwas.cor*mm.gwas.cor))
  pval = 2*pt( abs(t.stat), df, lower.tail =FALSE )

  if ( nperm > 0 ) {
    perms = matrix( NA, ncol=nperm, nrow=n)
    for( i in 1:nperm ) {
      perms[,i] = sample(mm.transformed.y,replace=FALSE)
    }

    mm.gwas.cor.perm = cor( perms, mm.transformed.g )
    t.stat.perm = mm.gwas.cor.perm*sqrt(df)/(1.0e-10+sqrt(1-mm.gwas.cor.perm*mm.gwas.cor.perm))
    pval.perm = 2*pt( abs(t.stat.perm), df, lower.tail=FALSE)
    pval.perm.empirical = sapply( 1:ncol(pval.perm), function( i, pval.perm, pval ) { mean(pval[i] > pval.perm[,i]) }, pval.perm, pval )
    min.pval = apply(pval.perm,2,min)
    genomewide.pval = mean(pval<min.pval)
    results = list( pval=pval, h2=mmd$vg, pval.perm=pval.perm, pval.perm.empirical=pval.perm.empirical, genomewide.pval=genomewide.pval )
  } else {
    results = list( pval=pval, h2=mmd$vg)
  }

  return(results)
}

make.kinship <- function( genotypes, scale.genos=TRUE ) {

  if ( scale.genos ) {
    genos = apply( genotypes, 2, function( g ) {
      s = sd(g, na.rm=TRUE)
      mu = mean(g, na.rm=TRUE)
      if ( s > 0 ) {
        g = ifelse ( is.na(g), 0.0, (g-mu)/s )
      } else {
        g = rep(0, length(g));
      }
      return(g)
    })
    rownames(genos) = rownames(genotypes)
    genotypes = genos
  }

  kinship = genotypes %*% t(genotypes)/(ncol(genotypes)-1)
  colnames(kinship) = rownames(genotypes)
  rownames(kinship) = rownames(genotypes)

  cat("Built kinship dim", dim(kinship), "\n")

  return(kinship)
}

haplotype.dosage.mixed.model <- function( phenfile, phenotype, id.column="IID",
                                          grm.datafile=NULL, # "RData/MAGIC.snp.grm.RData",
                                          dosage.dir=NULL, # "../../5STITCH/STITCH_haplotypes/LD_pruned_haplotypes",
                                          chrs, thin=1,  n.perm=0, mc.cores=1, covar=NULL) {

  y=load_phenotypes(phenfile, phenotype, id.column=id.column)

  load(grm.datafile) # loads grm.data
  kinship = grm
  haplo.logP = NULL
  haplo.logP.perm = NULL
  mmd = NULL

  for ( chr in chrs ) {
    dosage.file=paste0(dosage.dir, "/", chr, ".hap.dosage.RData")
    load(dosage.file)
    hmap = hap.dosage.data$map
    hmap$start=hmap$bp
    hmap$end = c( hmap$bp[2:nrow(hmap)]-1,hmap$bp[nrow(hmap)]+100 )
    sites = 1:nrow(hmap)
    use.sites = sites %% thin == 0
    hmap = hmap[use.sites,]

    #    hmap = data.frame( chr=rep(chr,length(d$bp)), start=d$bp, end=c(d$bp.delta,100+d$bp.delta[length(d$bp.delta)])+d$bp-1 )
    if ( is.null(mmd)) {
      use.ids = sort(intersect(names(y), dimnames(hap.dosage.data$dosages)[[2]]))
      use.ids = intersect(use.ids, rownames(kinship))
      y = y[match(use.ids,names(y),nomatch=0)]
      if(!is.null(covar)){
        covar<-covar[match(use.ids,rownames(covar),nomatch=0),]
        y=lm(y~covar-1)$residuals
      }
      k.ids = match(use.ids,rownames(kinship),nomatch=0)
      kinship = kinship[k.ids,k.ids]
      mmd = estimate.mixed.model( y, kinship )
    }
    dosages=hap.dosage.data$dosages[use.sites,use.ids,]
    results = haplotype.dosage.mixed.model.chr( mmd, dosages, hmap, nperm=n.perm, mc.cores=mc.cores)

    haplo.logP = rbind(haplo.logP, cbind(results$logP, results$beta, results$se))
    haplo.logP.perm = rbind(haplo.logP.perm, results$logP.perm)
  }

  logP.max=NULL
  if ( n.perm>0) {
    logP.max = apply( haplo.logP.perm, 2, max, na.rm=TRUE)
    haplo.logP$perm.adj.pvalue = sapply( 1:nrow(haplo.logP),
                                         function( i, haplo.logP, haplo.logP.perm ) {
                                           mean(haplo.logP$logP[i] < logP.max )
                                         }, haplo.logP, haplo.logP.perm )
  }
  return(list(haplo.logP=haplo.logP, vg=mmd$vg, max.logP.perm=logP.max))
}

haplotype.dosage.mixed.model.chr <- function( mmd, haplotype.dosage, haplo.map, nperm=10, mc.cores=1, covar=NULL) {

  # haplotype.dosage is array with dims n.loci*n.individuals*n.founders

  mm.transformation = mmd$inv.sqrt.sigma
  y.transformed = mm.transformation %*% mmd$y

  n.loci = dim(haplotype.dosage)[1]
  n.id = dim(haplotype.dosage)[2]
  n.founders = dim(haplotype.dosage)[3]
  founders = 1:n.founders
  cat( "n.id=", n.id, " n.loci=", n.loci, " n.founders=", n.founders, "\n")
  if ( n.id==0 ) {
    cat( "ERROR sample ids in genotypes do not match phenotypes\n")
    return(NULL);
  }

  if ( nperm > 0 ) {
    perms = matrix( NA, ncol=nperm, nrow=n.id)
    for( i in 1:nperm ) {
      perms[,i] = sample(y.transformed,replace=FALSE)
    }
    #    perms[,1] = y.transformed
    logP.perm = matrix(0,nrow=n.loci,ncol=nperm)
  } else {
    perms = NULL
    logP.perm = NULL
  }

  logP = mclapply( 1:n.loci,  function( locus, haplotype.dosage, y.transformed, mm.transformation, perms ) {

    dose = haplotype.dosage[locus,,]
    dose_norm = 2*(dose/apply(dose,1,sum)) #make sure dosage for one MAGIC line sums to exactly 2
    dose.transformed = mm.transformation %*% dose_norm

    f = lm(y.transformed ~ dose.transformed -1 ,qr=TRUE)
    a = anova(f)
    logP = -log10(a[1,5])
    if ( !is.null(perms)) {
      ss = apply(perms, 2, function( y.p, f.qr) {
        res=qr.resid(f.qr, y.p)
        rss = sum(res*res)
        fit = y.p-res
        fss = sum(fit*fit)
        return(c(rss,fss))
      }, f$qr )
      rss = ss[1,]
      fss = ss[2,]
      F = (fss/f$rank)/(rss/(n.id-f$rank))
      lp.perm = -pf(F,f$rank,n.id-f$rank,low=FALSE,log.p=TRUE)/log(10)
    } else {
      lp.perm = FALSE
    }
    betas=coef(f)
    names(betas)=paste0("beta",seq(1:n.founders))
    SEs<-sqrt(diag(vcov(f)))
    names(SEs)=paste0("SE",seq(1:n.founders))
    return( c( logP, lp.perm, betas, SEs ))
  }, haplotype.dosage, y.transformed, mm.transformation, perms, mc.cores=mc.cores )

  logP = do.call( "rbind", logP )
  if ( nperm > 0 ) {
    logP.perm = logP[,seq(2,nperm+1)]
  } else {
    logP.perm = NULL
  }
  logP.true = data.frame( haplo.map, logP=logP[,1])

  results = list( logP=logP.true, logP.perm=logP.perm, beta=logP[, grepl("beta", colnames(logP))], se=logP[,grepl("SE", colnames(logP))])
  return(results)
}


