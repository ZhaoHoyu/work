import CSV,XLSX
using DataFrames,Statistics,Dates
# DelimitedFiles,StringEncodings


savepath = raw"E:\i29\SS验证\212_RGB_POR.xlsx"
filepath = raw"E:\i29\SS验证\tst"

datalist = readdir(filepath)

function dyduv(data)
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
    min_Lv = findmin(Lv_list)[1]
    max_Lv = findmax(Lv_list)[1]
    dY = min_Lv[1]/max_Lv[1]
    duv = findmax(uv_list)[1]
    # sheet[2+c,2] = dY
    # sheet[2+c,3] = duv[1]
    # sheet[2+c,4] = min_Lv[1]
    # sheet[2+c,5] = max_Lv[1]
    return dY,duv,min_Lv,max_Lv
    end
end

function duvWRTCenter(data)
    center_list = [72,73,88,89]
    # data = CSV.read(file,DataFrame,header=1)
    x = 0
    y = 0
    for i in center_list
        x += data[i,3]
        y += data[i,4]
    end
    u = 4*x/(-2*x+12*y+3)/4
    v = 9*y/(-2*x+12*y+3)/4
    duvWRTCenter = 0
    cord = "None"
    for j in 1:160
        xi = data[j,3]
        yi = data[j,4]
        ui = 4*xi/(-2*xi+12*yi+3)
        vi = 9*yi/(-2*xi+12*yi+3)
        duv = sqrt((ui-u)^2+(vi-v)^2)
        if duv >= duvWRTCenter
            duvWRTCenter = duv
            cord = "$j"
        end
    end
    # println(typeof(cord))
    return duvWRTCenter,cord
end

function duvWorstNeighbor(data)
    duvWorstNeighbor = 0
    cord = "None"
    for i in 18:31
        for j in 1:8
            x = data[i+(j-1)*16,3]
            y = data[i+(j-1)*16,4]
            u = 4*x/(-2*x+12*y+3)/4
            v = 9*y/(-2*x+12*y+3)/4
            nei = [-1,1,-16,16]
            duv = 0
            for m in 1:4
                xm = data[i+(j-1)*16+nei[m],3]
                ym = data[i+(j-1)*16+nei[m],4]
                um = 4*xm/(-2*xm+12*ym+3)/4
                vm = 9*ym/(-2*xm+12*ym+3)/4
                duv = sqrt((um-u)^2+(vm-v)^2)
                if duv >= duvWorstNeighbor
                    duvWorstNeighbor = duv
                    cord = "$(i+(j-1)*16)"
                end
            end
        end
    end
    corner = [1,16,145,160]
    corner_app = [1,16,-1,16,-16,1,-1,-16]
    ct = 1
    for p in 1:4
        xc = data[corner[p],3]
        yc = data[corner[p],4]
        uc = 4*xc/(-2*xc+12*yc+3)/4
        vc = 9*yc/(-2*xc+12*yc+3)/4
        n = 1
        while n < 3
            xx = data[corner[p]+corner_app[ct],3]
            yy = data[corner[p]+corner_app[ct],4]
            ux = 4*xx/(-2*xx+12*yy+3)/4
            vy = 9*yy/(-2*xx+12*yy+3)/4
            duvx = sqrt((ux-uc)^2+(vy-vc)^2)
            if duvx >= duvWorstNeighbor
                Float64(duvWorstNeighbor) = duvx
                cord = "$(corner[p])"
            end
            n += 1
            ct += 1
        end
    end
    return duvWorstNeighbor,cord
end


t1 = Dates.now()
XLSX.openxlsx(savepath, mode="w") do xf
    sheet = xf[1]
    XLSX.rename!(sheet, "uniformity")
    # sheet[1,2] = "min"
    sheet[1,2] = "dY"
    sheet[1,3] = "duv"
    sheet[1,4] = "min Lv"
    sheet[1,5] = "max Lv"
    sheet[1,6] = "duvWRTCenter"
    sheet[1,7] = "worst neighbor duv"
    sheet[1,8] = "duvWRTCenter_coordiante"
    sheet[1,9] = "worst neighbor duv_coordiate"
    c = 0
    for filename in datalist
        file = joinpath(filepath,filename)
        data = CSV.read(file,DataFrame,header=1)
        name = match(r"(.*).csv",filename)
        sheet[c+2,1] = string(name[1])
        # da = dyduv(data)
        # db = duvWRTCenter(data)
        # dc = duvWorstNeighbor(data)
        dY,duv,min_Lv,max_Lv = dyduv(data)
        duvWRTCenter1 = duvWRTCenter(data)
        duvWorstNeighbor1 = duvWorstNeighbor(data)
        sheet[2+c,2] = dY
        sheet[2+c,3] = duv
        sheet[2+c,4] = min_Lv
        sheet[2+c,5] = max_Lv
        sheet[2+c,6] = duvWRTCenter1[1]
        sheet[2+c,7] = duvWorstNeighbor1[1]
        sheet[2+c,8] = duvWRTCenter1[2]
        sheet[2+c,9] = duvWorstNeighbor1[2]
        c += 1
    end
    t2 = Dates.now()
    println(t2-t1)
end