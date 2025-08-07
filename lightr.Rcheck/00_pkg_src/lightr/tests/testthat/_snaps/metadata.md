# get_metadata all

    Code
      lr_get_metadata(test.file(), ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz",
        "JazIrrad", "spc"))
    Message
      10 files found; importing metadata:
    Output
                        name user            datetime spec_model   spec_ID
      1          OceanOptics <NA> 2016-02-16 14:23:00       <NA>      <NA>
      2   OceanOptics_period hugo                <NA>       <NA>      <NA>
      3             avantes2 <NA>                <NA>       <NA> 1305084U1
      4       avantes_export <NA>                <NA>       <NA> 0804016U1
      5      avantes_export2 <NA>                <NA>       <NA> 1305084U1
      6  avantes_export_long <NA>                <NA>       <NA> 1305084U1
      7      avantes_reflect <NA>                <NA>       <NA> 1305084U1
      8        avantes_trans <NA>                <NA>       <NA> 0804016U1
      9                irrad  jaz 2013-09-16 02:15:43       <NA>  JAZA2517
      10             jazspec  jaz 2011-08-29 16:23:13       <NA>  JAZA1479
         white_inttime dark_inttime sample_inttime white_avgs dark_avgs sample_avgs
      1             NA           NA             NA         NA        NA          NA
      2            400          400            400          5         5           5
      3            150          150            150         10        10          10
      4            100          100            100         20        20          20
      5             95           95             95         20        20          20
      6            150          150            150         10        10          10
      7             95           95             95         20        20          20
      8            100          100            100         20        20          20
      9            495          495            495          3         3           3
      10            24           24             24          1         1           1
         white_boxcar dark_boxcar sample_boxcar
      1            NA          NA            NA
      2             0           0             0
      3             1           1             1
      4             0           0             0
      5             1           1             1
      6             1           1             1
      7             1           1             1
      8             0           0             0
      9             5           5             5
      10            0           0             0

# get_metadata recursive

    Code
      lr_get_metadata(test.file(), ext = c("ProcSpec", "spc", "RFL8", "TRM"), subdir = TRUE)
    Message
      12 files found; importing metadata:
    Condition
      Warning:
      This file contains 2 spectra and 'specnum' argument is missing. Returning the first spectrum by default.
    Output
                          name       user            datetime  spec_model     spec_ID
      1            OceanOptics       <NA> 2016-02-16 14:23:00        <NA>        <NA>
      2               avantes2       <NA>                <NA>        <NA>   1305084U1
      3          avantes_trans       <NA>                <NA>        <NA>   0804016U1
      4   J_PIR_AVRIL2016_0001       <NA>                <NA>        <NA>   0411041S1
      5                NEW0601       <NA>                <NA>        <NA>   0606052U1
      6                feather       <NA> 2016-10-06 09:40:00        <NA>   1511108U1
      7                  CRAIC       <NA> 2012-09-28 15:47:00        <NA>        <NA>
      8              BB_PF21_4 Adminlocal 2006-06-23 09:39:09     USB4000  USB4C00008
      9      OceanOptics_Linux       hugo 2016-03-16 13:18:31     USB4000  USB4C00008
      10   OceanOptics_Windows doutrelant 2015-12-04 10:29:14      JazUSB    JAZA2982
      11 OceanOptics_badencode       user 2016-12-02 20:39:12 USB2000Plus USB2+H06330
      12              whiteref      gomez 2018-08-02 15:56:19     USB4000  USB4C00008
         white_inttime dark_inttime sample_inttime white_avgs dark_avgs sample_avgs
      1             NA           NA             NA         NA        NA          NA
      2         150.00       150.00         150.00         10        10          10
      3         100.00       100.00         100.00         20        20          20
      4         130.00       130.00         130.00         10        10          10
      5          23.16        23.16          23.16          5         5           5
      6         639.26       639.26         639.26          3         3           3
      7             NA           NA             NA         NA        NA          NA
      8          10.00        10.00          10.00         40        40          40
      9         200.00       200.00         200.00          5         5           5
      10         60.00        60.00          60.00         15        15          15
      11         20.00        20.00          20.00        100       100         100
      12        500.00       500.00         500.00          5         5           5
         white_boxcar dark_boxcar sample_boxcar
      1            NA          NA            NA
      2             1           1             1
      3             0           0             0
      4             3           3             3
      5            12          12            12
      6             0           0             0
      7            NA          NA            NA
      8            10          10            10
      9             0           0             0
      10            0           0             0
      11            5           5             5
      12            0           0             0

