## Prediksi Penumpang Datang dan Berangkat dari Mancanegara maupun Domestik Tahun 2005-2025
Prediksi ini bertujuan untuk mengetahui kedatangan dan keberangkatan penumpang baik dari dalam Negeri maupun luar negeri tahun 2005-2025, Menggunakan metode VAR (Vector AutoRegression), jumlah observasinya adalah dari tahun 2003-2025 tetapi setelah didifferencing jadi memakai tahun 2005-2025.

## Tools
Tools yang digunakan :
- Excel untuk membersihkan data.
- RStudio untuk memproses dan menganalisis data.

## Sumber Data
- Sumber : https://www.bps.go.id/id/statistics-table/1/MTQwMiMx/lalu-lintas-penerbangan-dalam-negeri-indonesia-tahun-2003-2022.html
- Sumber : https://www.bps.go.id/id/statistics-table/1/MTQwMiMx/lalu-lintas-penerbangan-dalam-negeri-indonesia-tahun-2003-2022.html

## Grafik

![Prediksi peramalan pesawat datang dan berangkat dari mancanegara maupun domestik tahun 2005-2025](https://github.com/user-attachments/assets/a5945054-be25-47d6-9b52-5e2ec28088ee)

## Metode Analisis
(1) Impor dan Pembersihan Data
- Mengahpus kolom yang tidak diperlukan.
- Menggabungkan Dataset berdasarkan tahun.
- Melakukan rename untuk kolom supaya mudah dianalisis.

(2) Visualisasi Data
- Menggunakan ggplot2 untuk memberikan hasil visualisasi perjalanan penumpang yang berangkat dan datang dari domestik maupun mancanegara.

(3) Uji ADF (Augmented Dickey Fuller)
- Uji ini bertujuan untuk memberikan hasil stasioner pada data yang akan dianalisis sehingga jika P-Value > 0.05 melakukan differencing.

(4) Model VAR (Vector AutoRegression)
- Menentukan jumlah lag yang optimal.
- Membangun model berdasarkan data yang sudah didifferencing.
- Menginterpretasikan hasil model.

(5) Impulse Response Function (IRF)
- Uji ini bertujuan untuk melihat perubahan pada variabel yang mempenagruhi variabel lainnya pada sistem.

(6) Uji kausalitas Granger (Granger Causality)
- Menguji hubungan sebab akibat antara jumlah penumpang yang berangkat dan datang dari domestik maupun mancanegara.

## Hasil dan Kesimpulan
- Berdasarkan hasil diatas pada model VAR tidak ditemukan hubungan kausalitas antara penumpang yang berangkat dan datang dari mancanegara maupun domestik.
- Prediksi ini menunjukkan tren yang akan datang pada penumpang yang akan melakukan perjalanan domestik maupun mancanegara sekaligus yang akan datang juga.

## Insight Bisnis
Dari hasil diatas keputusan yang akan dilakukan adalah harus :
(1) Memodernisasi tampilan bandara.
- Memperbaharui tampilan bandara di berbagai pelosok negeri dengan menyewa konsultan jasa arsitektur lokal maupun asing sehingga desain dan interior menarik bagi penumpang.
(2) Memurahkan harga tiket.
- Menekan biaya operasioanal seperti menurunkan harga avtur maupun meningkatkan efisiensi penggunaan pesawat. 
(3) Memperpanjang landasan pacu.
- Memperpanjang landasan pacu sehingga dapat digunakan untuk memuat pesawat berukuran besar seperti Airbus 380.
(4) Memaksimalkan pelayanan.
- Membuat ruang nyaman dengan desain modern supaya penumpang betah menunggu ketika pesawat delay.
- Membuat setiap ruang bermain bagi anak anak dibawah 10 tahun tetapi dekat dengan gate penerbangan yang akan dituju supaya tidak bosan menunggu lama.
- Memaksimalkan loket check in dan pelayanan maskapai.
- Memodernisasi sistem informasi manajemen bandara dan maskapai sehingga tidak ada yang saling berbenturan sistemnya.



