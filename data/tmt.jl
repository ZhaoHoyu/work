using CSV
using DataFrames,Statistics,Dates


# savepath = raw"D:\data\FPGA_DEMURA\sandy\D8_GRAY10.xlsx"
filepath = raw"C:\Users\F1_001\Desktop\tande"
# data = CSV.read(raw"D:\data\FPGA_DEMURA\ESWIN\#1\t\G32.csv",DataFrame,header=0)
datalist = readdir(filepath)

t1 = Dates.now()
for filename in datalist
    file = joinpath(filepath,filename)
    if occursin(".csv",filename)
        name1 = match(r".*PUC ON_(.*).csv",filename)
        name2 = match(r"(.*)ON_.*(.csv)",filename)
        name = join(name1,name2[1],name2[2])
        println(name)
        file1 = joinpath(filepath,name)
        data = CSV.read(file,DataFrame,header=0)
        CSV.write(file1,data;header=false)
    else ispath(file)
        nothing
    end
end

t2 = Dates.now()
println(t2-t1)