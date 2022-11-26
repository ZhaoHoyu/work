import CSV,XLSX
using DataFrames,Statistics,Dates
# DelimitedFiles,StringEncodings


savepath = raw"C:\Users\F1_001\Desktop\ZJ\tst.xlsx"
filepath = raw"C:\Users\F1_001\Desktop\ELVSS Knee数据处理模板\q"

datalist = readdir(filepath)

t1 = Dates.now()
XLSX.openxlsx(savepath, mode="w") do xf
    sheet = xf[1]
    # sht1 = xf[2]
    XLSX.rename!(sheet, "1")
    # XLSX.rename!(sht1, "2")
    sheet[1,19] = "slope"
    sheet[1,20] = "intercept"
    sheet[1,21] = "Lv_cal"
    sheet[1,22] = "dif_Lv%"

# string.format()
c = 0
for filename in datalist
    file = joinpath(filepath,filename)
    data = CSV.read(file,DataFrame,header=0)
    # name = match(r"(.*).csv",filename)
    # sheet[c+2,1] = string(name[1])
    for i = 2:405
        for j = 1:18
            sheet[c+i,j] = string(data[i,j])
            sheet[1,j] = string(data[1,j])
            sheet[2+c,19] = "=@INDEX(LINEST(D$(2+c):D$(22+c),B$(2+c):B$(22+c)),1)"
            sheet[2+c,20] = "=@INDEX(LINEST(D$(2+c):D$(22+c),B$(2+c):B$(22+c)),2)"
            sheet[i,21] = "=B$i*\$S\$2+\$T\$2"
            sheet[i,22] = "=(U$i-D$i)/D$i%"
        end
    end
    c += 405
end
end

