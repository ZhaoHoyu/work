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
    sheet[1,6] = "worst neighbor duv"

c = 0
for filename in datalist
    file = joinpath(filepath,filename)
    data = CSV.read(file,DataFrame,header=1)
    name = match(r"(.*).csv",filename)
    sheet[c+2,1] = string(name[1])
    Lv_list = []
    uv_list = []
    for i in 1:160
        x1 = Float64(data[i,3])
        # println(typeof(x1))
        y1 = Float64(data[i,4])
        u1 = 4*x1/(-2*x1+12*y1+3)
        v1 = 9*y1/(-2*x1+12*y1+3)
        Lv = Float64(data[i,2])
        push!(Lv_list,Lv)
        for j in 1:160
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

    uv_nb = []
    x8 = Float64(data[1,3])
    y8 = Float64(data[1,4])
    u8 = 4*x8/(-2*x8+12*y8+3)
    v8 = 9*y8/(-2*x8+12*y8+3)
    x9 = Float64(data[2,3])
    y9 = Float64(data[2,4])
    u9 = 4*x9/(-2*x9+12*y9+3)
    v9 = 9*y9/(-2*x9+12*y9+3)
    x10 = Float64(data[17,3])
    y10 = Float64(data[17,4])
    u10 = 4*x10/(-2*x10+12*y10+3)
    v10 = 9*y10/(-2*x10+12*y10+3)
    x11 = Float64(data[16,3])
    y11 = Float64(data[16,4])
    u11 = 4*x11/(-2*x11+12*y11+3)
    v11 = 9*y11/(-2*x11+12*y11+3)
    x12 = Float64(data[15,3])
    y12 = Float64(data[15,4])
    u12 = 4*x12/(-2*x12+12*y12+3)
    v12 = 9*y12/(-2*x12+12*y12+3)
    x13 = Float64(data[32,3])
    y13 = Float64(data[32,4])
    u13 = 4*x13/(-2*x13+12*y13+3)
    v13 = 9*y13/(-2*x13+12*y13+3)
    x14 = Float64(data[145,3])
    y14 = Float64(data[145,4])
    u14 = 4*x11/(-2*x11+12*y11+3)
    v14 = 9*y11/(-2*x11+12*y11+3)
    x15 = Float64(data[146,3])
    y15 = Float64(data[146,4])
    u15 = 4*x15/(-2*x15+12*y15+3)
    v15 = 9*y15/(-2*x15+12*y15+3)
    x16 = Float64(data[129,3])
    y16 = Float64(data[129,4])
    u16 = 4*x16/(-2*x16+12*y16+3)
    v16 = 9*y16/(-2*x16+12*y16+3)
    x17 = Float64(data[160,3])
    y17 = Float64(data[160,4])
    u17 = 4*x17/(-2*x17+12*y17+3)
    v17 = 9*y17/(-2*x17+12*y17+3)
    x18 = Float64(data[159,3])
    y18 = Float64(data[159,4])
    u18 = 4*x18/(-2*x18+12*y18+3)
    v18 = 9*y18/(-2*x18+12*y18+3)
    x19 = Float64(data[144,3])
    y19 = Float64(data[144,4])
    u19 = 4*x19/(-2*x19+12*y19+3)
    v19 = 9*y19/(-2*x19+12*y19+3)
    uv01 = sqrt((u9-u8)^2+(v9-v8)^2)
    uv02 = sqrt((u10-u8)^2+(v10-v8)^2)
    uv03 = sqrt((u12-u11)^2+(v12-v11)^2)
    uv04 = sqrt((u13-u11)^2+(v13-v11)^2)
    uv05 = sqrt((u15-u14)^2+(v15-v14)^2)
    uv06 = sqrt((u16-u14)^2+(v16-v14)^2)
    uv07 = sqrt((u18-u17)^2+(v18-v17)^2)
    uv08 = sqrt((u19-u17)^2+(v19-v17)^2)
    push!(uv_nb,uv01)
    push!(uv_nb,uv02)
    push!(uv_nb,uv03)
    push!(uv_nb,uv04)
    push!(uv_nb,uv05)
    push!(uv_nb,uv06)
    push!(uv_nb,uv07)
    push!(uv_nb,uv08)
    for m in 18:31
        for n in 1:8
            nb = []
            x3 = Float64(data[m+(n-1)*16,3])
            y3 = Float64(data[m+(n-1)*16,4])
            u3 = 4*x3/(-2*x3+12*y3+3)
            v3 = 9*y3/(-2*x3+12*y3+3)
            x4 = Float64(data[m+(n-1)*16-1,3])
            y4 = Float64(data[m+(n-1)*16-1,4])
            u4 = 4*x4/(-2*x4+12*y4+3)
            v4 = 9*y4/(-2*x4+12*y4+3)
            x5 = Float64(data[m+(n-1)*16+1,3])
            y5 = Float64(data[m+(n-1)*16+1,4])
            u5 = 4*x5/(-2*x5+12*y5+3)
            v5 = 9*y5/(-2*x5+12*y5+3)
            x6 = Float64(data[m+(n-1)*16-16,3])
            y6 = Float64(data[m+(n-1)*16-16,4])
            u6 = 4*x6/(-2*x6+12*y6+3)
            v6 = 9*y6/(-2*x6+12*y6+3)
            x7 = Float64(data[m+(n-1)*16+16,3])
            y7 = Float64(data[m+(n-1)*16+16,4])
            u7 = 4*x7/(-2*x7+12*y7+3)
            v7 = 9*y7/(-2*x7+12*y7+3)
            uv1 = sqrt((u4-u3)^2+(v4-v3)^2)
            uv2 = sqrt((u5-u3)^2+(v5-v3)^2)
            uv3 = sqrt((u6-u3)^2+(v6-v3)^2)
            uv4 = sqrt((u7-u3)^2+(v7-v3)^2)
            push!(nb,uv1)
            push!(nb,uv2)
            push!(nb,uv3)
            push!(nb,uv4)
            max_uv_nb = findmax(nb)
            push!(uv_nb,max_uv_nb[1])
        end
    end
    max_nb_duv = findmax(uv_nb)
    sheet[2+c,6] = max_nb_duv[1]
end

t2 = Dates.now()
println(t2-t1)
end
