#########
fpca.score <- function(data.m, grids.u, muhat, eigenvals, eigenfuncs, sig2hat, K, grid_sep){
  ##estimated conditional principal component scores (BLUPs): \hat{E(\xi_k|Y)}, k=1,...,K
  ##Name:FPcScore
  ##para:
  ##     data.m -- data matrix; same as input for fpca.mle
  ##     grids.u -- grid of time points used in evaluating the mean and eigenfunctions (on the original scale); (returned by fpca. mle)
  ##     muhat,eigenvals, eigenfuncs, sig2hat -- (estimated) mean, eigenvalues, eigenfunctions and noise variance; (returned by fpca.mle)
  ##     K -- number of eigenfunctions used in the model, i.e., (estimated) dimension of the process
  ##     grid_sep -- grid 간격
  ##return: first K conditional PC scores (the BLUP estimates): n by K
  temp <- table(data.m[,1])
  n <- length(temp)             # number of curves;
  m.l <- as.vector(temp)        # m.l -- number of time points per curve
  result <- matrix(0, n, K)       # First K FPC scores for each subject
  
  N <- length(grids.u)        # number of time points on the grid
  evalmat <- diag(eigenvals[1:K])  # diagonal matrix of the first K (estimated) eigenvalues
  current <- 0  # current index
  eigenfuncs.u <- t(eigenfuncs)   # dimmension: grid_length by K
  
  # 정확한 grid의 index 구하기 위해 실제 time points와 1:1 매칭
  tt <- sort(unique(data.m[,3]))
  tt <- cbind(tt, seq(0.0001, 1, length.out=length(tt)))
  data.u <- matrix(as.numeric(as.vector(data.m[,-1])),   # convert obs matrix to be numierc
                   nrow=nrow(data.m[,-1]),
                   ncol=ncol(data.m[,-1]))    
  # grid 반올림할 간격 설정
  if (grid_sep == 1) {
    interval <- 0
  } else if (grid_sep == 0.1) {
    interval <- 1
  } else if (grid_sep == 0.01) {
    interval <- 2
  } else if (grid_sep == 0.001) {
    interval <- 3
  } else {
    interval <- 4
  }
  
  for (i in 1:n){
    Y <- as.vector(data.u[(current+1):(current+m.l[i]),1])  # observed  measurements of ith curve
    meastime <- data.u[(current+1):(current+m.l[i]),2]      # measurement times of the ith curve
    meastime2 <- tt[which(tt[,1] %in% meastime), 2]
    # round한 gridpoint와 timepoints를 비교해서(같은 것 여러개 나옴) 같은 것의 2번째 값 사용
    gridtime <- apply(matrix(meastime), 1, function(x){ which( round(grids.u, interval) %in% x )[2] })   
    muy <- muhat[gridtime]
    Phiy  <- matrix(eigenfuncs.u[gridtime,1:K], ncol=K)
    Sigy <- Phiy %*% evalmat %*% t(Phiy) + sig2hat * diag(m.l[i])
    temp.y <- matrix(Y-muy)
    result[i,] <- evalmat %*% t(Phiy) %*% solve(Sigy, temp.y)   # PACE 방법으로 PC score 계산
    current <- current + m.l[i]
    
    # # gridpoint와 실제 timepoint가 비슷한지 비교하기 위함
    # print(i)
    # print(rbind(meastime, grids.u[gridtime]))
  }
  return(result)
}