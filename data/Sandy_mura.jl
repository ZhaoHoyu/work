import CSV,XLSX
using DataFrames,Statistics,Dates
# DelimitedFiles,StringEncodings

savepath = raw"D:\data\FPGA_DEMURA\Vth\vthon_ttt2.xlsx"
filepath = raw"D:\data\FPGA_DEMURA\Vth\vthon"

datalist = readdir(filepath)


# raw_start,raw_end = 750,850
# col_start,col_end = 1230,1330
function Sandy(filename)
    file = joinpath(filepath,filename)
    data = CSV.read(file,DataFrame,header=0)
    size_ = size(data)
    raw_start = Int64(size_[1]/2-50)
    raw_end = Int64(size_[1]/2+50)
    col_start = Int64(size_[2]/2-50)
    col_end = Int64(size_[2]/2+50)
    # println(raw_start,col_start)
    dt = []
    for i in raw_start+2:raw_end-2
        for j in col_start+2:col_end-2
            block = []
            a = data[i,j]
            for m in i-2:i+2
                for n in j-2:j+2
                    if m != i & n != j
                        b = data[m,n]
                        d = 1-min(a,b)/max(a,b)
                        # push!(dt,d)
                        push!(block,d)
                    end
                end
            end
            dmax = findmax(block)[1]
            push!(dt,dmax)
        end
    end
    return dt
end


t1 = Dates.now()
XLSX.openxlsx(savepath, mode="w") do xf
    sheet = xf[1]
    XLSX.rename!(sheet, "sandy")
    sheet[1,2] = "min"
    sheet[1,3] = "max"
    sheet[1,4] = "avg"
    sheet[1,5] = "std"
    sheet[1,6] = "std/avg"
    # sheet["A1"] = "this is a"
    # sheet["A2"] = "new file"
    # sheet["A3"] = "1111"
    # sheet["A4"] = 10000
    # sheet["A5"] = collect(1:5) 
    # sheet["B1", dim=1] = collect(1:4)
    # sheet["A7:C9"] = [ 1 2 3 ; 4 5 6 ; 7 8 9 ]


raw_start,raw_end = 750,850
col_start,col_end = 1230,1330

c = 2
for filename in datalist
    if occursin("csv",filename)
        dt = Sandy(filename)
        min = findmin(dt)
        max = findmax(dt)
        avg = mean(dt)
        std = Statistics.std(dt)
        std_avg = std/avg
        name = match(r"(.*).csv",filename)
        sheet[c,1] = string(name[1])
        sheet[c,2] = min[1]
        sheet[c,3] = max[1]
        sheet[c,4] = avg
        sheet[c,5] = std
        sheet[c,6] = std/avg
        c += 1
    end
end
end
t2 = Dates.now()
println(t2-t1)
