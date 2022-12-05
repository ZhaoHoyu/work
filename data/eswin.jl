using CSV
using DataFrames,Statistics,Dates
# DelimitedFiles,StringEncodings

# savepath = raw"C:\Users\F1_001\Desktop\ZJ\tst.xlsx"
filepath = raw"D:\data\FPGA_DEMURA\2"
# data = CSV.read(raw"D:\data\FPGA_DEMURA\ESWIN\#1\t\G32.csv",DataFrame,header=0)
datalist = readdir(filepath)

function datadeal(file)
    data = CSV.read(file,DataFrame,header=0)
    h,w = size(data)
#     Algorithm g2
#     for i in 1:1:85
#         for j in 1:1:w
#             # println(data[i+100,j])
#             data[i,j] = data[i+100,j]
#             data[h-i+1,j] = data[h-i-100,j]
#         end
#     end
#     Algorithm g3
    data[1:100,:] = data[100:199,:]
    data[h-99:h,:] = data[100:199,:]
    CSV.write(file,data;header=false)    
end

t1 = Dates.now()
c = 0
for filename in datalist
    file = joinpath(filepath,filename)
    if occursin(".csv",filename)
        datadeal(file)
#         Note:Algorithm g1
        # data = CSV.read(file,DataFrame,header=0)
        # h,w = size(data)
        # for i in 1:1:85
        #     for j in 1:1:w
        #         # println(data[i+100,j])
        #         data[i,j] = data[i+100,j]
        #         data[h-i+1,j] = data[h-i-100,j]
        #     end
        # end
        # CSV.write(file,data;header=false)
    else ispath(file)
        subfile = readdir(file)
        for subfilename in subfile
            file_ = joinpath(file,subfilename)
            datadeal(file_)
        end
    end
end
