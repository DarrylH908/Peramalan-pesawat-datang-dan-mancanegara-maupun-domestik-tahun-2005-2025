#Memuat Paket
library(vars)
library(lmtest)
library(dplyr)
library(tseries)
library(ggplot2)

#Memuat Dataset
domestik <- read.csv("D:\\Dataset\\Lalu lintas kedatangan domestik Indonesia 2003-2022.csv")
mancanegara <- read.csv("D:\\Dataset\\Lalu lintas Mancanegara Indonesia dan kurs tengah 2003-2022.csv")

#Memanggil fungsi 
domestik
mancanegara

#Menghapus data yang hilang
domestik <- subset(domestik,select=-c(X))
domestik

#Kita gabung datanya dulu
gabung <- merge(domestik,mancanegara,by='Tahun')
gabung

#Sekarang kita rename kolomnya dulu
gabung <- rename(gabung,
  Pesawat.Berangkat.Domestik = Pesawat.Berangkat,
  Pesawat.Datang.Domestik =Pesawat.Datang.x,
  Penumpang.Berangkat.Domestik = Penumpang.Berangkat.x,
  Penumpang.Datang.Domestik = Penumpang.Datang.x,
  Pesawat.Berangkat.Mancanegara = Pesawat.berangkat,
  Pesawat.Datang.Mancanegara = Pesawat.Datang.y,
  Penumpang.Berangkat.Mancanegara = Penumpang.Berangkat.y,
  Penumpang.Datang.Mancanegara = Penumpang.Datang.y
)
gabung

#sekarang kita plot penumpang datang dan berangkat mancanegara
ggplot(gabung,aes(x=Tahun))+
  geom_line(aes(y=Penumpang.Berangkat.Mancanegara,color='Berangkat Mancanegara'))+
  geom_line(aes(y=Penumpang.Datang.Mancanegara,color='Datang Mancanegara'))+
  scale_color_manual(values=c('Berangkat Mancanegara'='red','Datang Mancanegara'='blue'))+
  theme_minimal()

#Sekarang kita plot penumpang datang dan berangkat domestik
ggplot(gabung,aes(x=Tahun))+
  geom_line(aes(y=Penumpang.Berangkat.Domestik,color='Berangkat Domestik'))+
  geom_line(aes(y=Penumpang.Datang.Domestik,color='Datang Domestik'))+
  scale_color_manual(values=c('Berangkat Domestik'='red','Datang Domestik'='blue'))+
  theme_minimal()

#Sekarang kita akan melakukan tes adf
adf.test(gabung$Penumpang.Berangkat.Mancanegara,alternative='stationary',k=0)
adf.test(gabung$Penumpang.Datang.Mancanegara,alternative='stationary',k=0)
adf.test(gabung$Penumpang.Berangkat.Domestik,alternative='stationary',k=0)
adf.test(gabung$Penumpang.Datang.Domestik,alternative='stationary',k=0)

#Dari hasil penumpang berangkat dan datang mancanegara hasilnya 0.7031 dan 0.713 yang artinya data tidak stasioner,
#Sedangkan hasil penumpang berangkat dan datang domestik p valuenya 0.8648 dan 0.8509
#Kesimpulannya harus di differencing

#Kita differencing
diff1 <- diff(gabung$Penumpang.Berangkat.Mancanegara)
diff2 <- diff(gabung$Pesawat.Datang.Mancanegara)
diff3 <- diff(gabung$Penumpang.Berangkat.Domestik)
diff4 <- diff(gabung$Penumpang.Datang.Domestik)

#Sekarang kita lihat tes adfnya
adf.test(diff1,alternative='stationary',k=0)
adf.test(diff2,alternative='stationary',k=0)
adf.test(diff3,alternative='stationary',k=0)
adf.test(diff4,alternative='stationary',k=0)

#Hasil masih gak stasioner kita coba sampe stasioner
diff1 <- diff(diff1)
diff2 <- diff(diff2)
diff3 <- diff(diff3)
diff4 <- diff(diff4)

#Kita test adfnya lagi
adf.test(diff1,alternative='stationary',k=0)
adf.test(diff2,alternative='stationary',k=0)
adf.test(diff3,alternative='stationary',k=0)
adf.test(diff4,alternative='stationary',k=0)

#Sudah mulai bagus jadi kita modelkan
#Yang berangkat dan datang ke mancanegara hasilnya
#p-value 0.02174 dan datang hasilnya p-valuenya 0.01443
#Walaupun hasil adfnya yang untuk berangkat domestik dan datang domestik jelek
#Karena P valuenya 0.2921 dan 0.1098

#Periksa dimensinya
length(diff1)
length(diff2)
length(diff3)
length(diff4)
length(gabung$Tahun)


gabung$Tahun <- as.numeric(gabung$Tahun)
gabung$Tahun
#Sekarang kita bikin dataframenya
tabelhg <- data.frame( 
  Tahun = tail(gabung$Tahun,18),
  penumpang_berangkat_mancanegara=diff1,
  penumpang_datang_mancanegara = diff2,
  penumpang_berangkat_domestik = diff3,
  penumpang_datang_domestik = diff4)
tabelhg

#Sekarang kita bikin simulasi VAR
varsd <- VARselect(tabelhg[,-1],lag.max=10,type='trend')
plag <- varsd$selection['AIC(n)']
plag

simulasi <- VAR(tabelhg[,-1],p=plag,type='trend')
summary(simulasi)

#Sekarang kita plot IRF
irfs <- irf(simulasi,impulse='penumpang_berangkat_domestik',response='penumpang_datang_mancanegara')
plot(irfs)

#Sekarang kita lihat causalitasnya
causality(simulasi,cause='penumpang_berangkat_domestik')
causality(simulasi,cause='penumpang_datang_mancanegara')

#Berarti semuanya tidak granger cause karena p valuenya diatas 0.05

#Bikin tabel prediksi
prediksisaq <- predict(simulasi,n.ahead=3)
prediksisaq
tabelhgs <- data.frame( 
  Tahun = c(tabelhg$Tahun,seq(from=tail(tabelhg$Tahun,1)+1,by=1,length.out=3)),
  Datang_domestik = c(tabelhg$penumpang_datang_domestik,rep(NA,3)),
  Datang_mancanegara = c(tabelhg$penumpang_datang_mancanegara,rep(NA,3)),
  Berangkat_domestik = c(tabelhg$penumpang_berangkat_domestik,rep(NA,3)),
  Berangkat_mancanegara = c(tabelhg$penumpang_berangkat_mancanegara,rep(NA,3)),
  prediksi_datang_mancanegara=c(tabelhg$penumpang_datang_mancanegara,prediksisaq$fcst$penumpang_datang_mancanegara[,1]),
  prediksi_datang_domestik=c(tabelhg$penumpang_datang_domestik,prediksisaq$fcst$penumpang_datang_domestik[,1]),
  prediksi_berangkat_mancanegara=c(tabelhg$penumpang_berangkat_mancanegara,prediksisaq$fcst$penumpang_berangkat_mancanegara[,1]),
  prediksi_berangkat_domestik=c(tabelhg$penumpang_berangkat_domestik,prediksisaq$fcst$penumpang_berangkat_domestik[,1])
)

tabelhgs

#Kita bikin plot prediksinya
png('Prediksi peramalan pesawat datang dan berangkat dari mancanegara maupun domestik tahun 2005-2025.png')
ggplot(tabelhgs,aes(x=Tahun))+
  geom_line(aes(y=prediksi_datang_mancanegara,color='datang mancanegara'))+
  geom_line(aes(y=prediksi_datang_domestik,color='datang domestik'))+
  geom_line(aes(y=prediksi_berangkat_mancanegara,color='berangkat mancanegara'))+
  geom_line(aes(y=prediksi_berangkat_domestik,color='berangkat domestik'))+
  scale_color_manual(values=c('datang mancanegara'='red',
                              'datang domestik'='blue',
                              'berangkat mancanegara'='green',
                              'berangkat domestik'='yellow'))+
  theme_minimal()
dev.off()