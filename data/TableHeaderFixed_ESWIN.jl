using CSV
using DataFrames,Statistics,Dates
# DelimitedFiles,StringEncodings


# savepath = raw"C:\Users\F1_001\Desktop\ZJ\tst.xlsx"
filepath = raw"D:\data\FPGA_DEMURA\ESWIN\#1\t"
# data = CSV.read(raw"D:\data\FPGA_DEMURA\ESWIN\#1\t\G32.csv",DataFrame,header=0)
datalist = readdir(filepath)

t1 = Dates.now()
c = 0
for filename in datalist
    file = joinpath(filepath,filename)
    data = CSV.read(file,DataFrame,header=0)
    h,w = size(data)
    for i in 1:1:85
        for j in 1:1:w
            # println(data[i+100,j])
            data[i,j] = data[i+100,j]
            data[h-i+1,j] = data[h-i-100,j]
        end
    end
    CSV.write(file,data;header=false)
end


