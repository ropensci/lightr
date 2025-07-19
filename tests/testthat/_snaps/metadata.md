# get_metadata all

    Code
      lr_get_metadata(test.file(), ext = c("TRM", "ROH", "ttt", "trt", "jdx", "jaz",
        "JazIrrad"))
    Message
      9 files found; importing metadata:
    Output
                       name user            datetime spec_model   spec_ID
      1  OceanOptics_period hugo                <NA>       <NA>      <NA>
      2            avantes2 <NA>                <NA>       <NA> 1305084U1
      3      avantes_export <NA>                <NA>       <NA> 0804016U1
      4     avantes_export2 <NA>                <NA>       <NA> 1305084U1
      5 avantes_export_long <NA>                <NA>       <NA> 1305084U1
      6     avantes_reflect <NA>                <NA>       <NA> 1305084U1
      7       avantes_trans <NA>                <NA>       <NA> 0804016U1
      8               irrad  jaz 2013-09-16 02:15:43       <NA>  JAZA2517
      9             jazspec  jaz 2011-08-29 16:23:13       <NA>  JAZA1479
        white_inttime dark_inttime sample_inttime white_avgs dark_avgs sample_avgs
      1           400          400            400          5         5           5
      2           150          150            150         10        10          10
      3           100          100            100         20        20          20
      4            95           95             95         20        20          20
      5           150          150            150         10        10          10
      6            95           95             95         20        20          20
      7           100          100            100         20        20          20
      8           495          495            495          3         3           3
      9            24           24             24          1         1           1
        white_boxcar dark_boxcar sample_boxcar
      1            0           0             0
      2            1           1             1
      3            0           0             0
      4            1           1             1
      5            1           1             1
      6            1           1             1
      7            0           0             0
      8            5           5             5
      9            0           0             0

# get_metadata recursive

    Code
      lr_get_metadata(test.file(), ext = "ProcSpec", subdir = TRUE)
    Message
      5 files found; importing metadata:
    Output
                         name       user            datetime  spec_model     spec_ID
      1             BB_PF21_4 Adminlocal 2006-06-23 09:39:09     USB4000  USB4C00008
      2     OceanOptics_Linux       hugo 2016-03-16 13:18:31     USB4000  USB4C00008
      3   OceanOptics_Windows doutrelant 2015-12-04 10:29:14      JazUSB    JAZA2982
      4 OceanOptics_badencode       user 2016-12-02 20:39:12 USB2000Plus USB2+H06330
      5              whiteref      gomez 2018-08-02 15:56:19     USB4000  USB4C00008
        white_inttime dark_inttime sample_inttime white_avgs dark_avgs sample_avgs
      1            10           10             10         40        40          40
      2           200          200            200          5         5           5
      3            60           60             60         15        15          15
      4            20           20             20        100       100         100
      5           500          500            500          5         5           5
        white_boxcar dark_boxcar sample_boxcar
      1           10          10            10
      2            0           0             0
      3            0           0             0
      4            5           5             5
      5            0           0             0

