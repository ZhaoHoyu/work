import CSV,XLSX
using DataFrames,Statistics,Dates
# DelimitedFiles,StringEncodings


savepath = raw"E:\i29\SS验证\212_RGB_POR.xlsx"
filepath = raw"E:\i29\SS验证\212"

datalist = readdir(filepath)
# println(typeof(datalist))

# filename = "Uniformity_CA410_W_Band_12_Freq_60_20220727102848.CSV"
# b=XLSX.openxlsx("D:\\data\\VLC.xlsx")
# a=DelimitedFiles.readdlm("D:\\data\\亮度设定.csv")

# df = CSV.read(raw"D:\data\juliatest\PIEs_AJUN_ORB_G010.csv",DataFrame)
# file = CSV.File(open("1.csv", enc"UTF-8"))
#x = CSV.read("C:\\Users\\F1_001\\Desktop\\亮度设定.csv",ignore_invalid_chars=ture,skipstart=1)
# data = CSV.read("D:\\data\\LLCSHIFT\\PUCON\\2256416\\Uniformity_CA410_W_Band_12_Freq_60_20220727102848.CSV",DataFrame)
# data[3,4]
t1 = Dates.now()
XLSX.openxlsx(savepath, mode="w") do xf
    sheet = xf[1]
    XLSX.rename!(sheet, "uniformity")
    # sheet[1,2] = "min"
    sheet[1,2] = "dY"
    sheet[1,3] = "duv"
    sheet[1,4] = "min Lv"
    sheet[1,5] = "max Lv"

c = 0
for filename in datalist
    file = joinpath(filepath,filename)
    data = CSV.read(file,DataFrame,header=1)
    name = match(r"(.*).csv",filename)
    sheet[c+2,1] = string(name[1])
    Lv_list = []
    uv_list = []
    for i in 1:135
        x1 = Float64(data[i,3])
        # println(typeof(x1))
        y1 = Float64(data[i,4])
        u1 = 4*x1/(-2*x1+12*y1+3)
        v1 = 9*y1/(-2*x1+12*y1+3)
        Lv = Float64(data[i,2])
        push!(Lv_list,Lv)
        for j in 1:135
            if j != i
                x2 = Float64(data[j,3])
                y2 = Float64(data[j,4])
                u2 = 4*x1/(-2*x2+12*y2+3)
                v2 = 9*y1/(-2*x2+12*y2+3)
                uv = sqrt((u2-u1)^2+(v2-v1)^2)
                push!(uv_list,uv)
            end
        end
    min_Lv = findmin(Lv_list)
    max_Lv = findmax(Lv_list)
    dY = min_Lv[1]/max_Lv[1]
    duv = findmax(uv_list)
    sheet[2+c,2] = dY
    sheet[2+c,3] = duv[1]
    sheet[2+c,4] = min_Lv[1]
    sheet[2+c,5] = max_Lv[1]
    end
    c += 1
end

t2 = Dates.now()
println(t2-t1)
end