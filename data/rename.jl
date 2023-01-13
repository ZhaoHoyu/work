using CSV
using DataFrames,Statistics,Dates


# savepath = raw"D:\data\FPGA_DEMURA\sandy\D8_GRAY10.xlsx"
filepath = raw"D:\data\LTPS_Tandem_15d5\EN4_DEMO\LLC"
# data = CSV.read(raw"D:\data\FPGA_DEMURA\ESWIN\#1\t\G32.csv",DataFrame,header=0)
datalist = readdir(filepath)

t1 = Dates.now()
for filename in datalist
    file = joinpath(filepath,filename)
    if occursin(".csv",filename)
        name1 = match(r".*PUC ON_(.*).csv",filename)
        name2 = match(r"(.*)N_.*(.csv)",filename)
        name = string(name1[1])*string(name2[1])*string(name2[2])
        # println((name2))
        file1 = joinpath(filepath,name)
        data = CSV.read(file,DataFrame,header=0)
        CSV.write(file1,data;header=false)
    else ispath(file)
        dl1 = readdir(file)
        for subfile in dl1
            file1 = joinpath(file,subfile)
            dl2 = readdir(file1)
        #     println(dl2)
        #     if occursin(".csv",1)
        #         name1 = match(r"PIEs_AJUN_ORB_(.*)",dl2)
        #         name = string(filename)*string(subfile)*name1
        #         file2 = joinpath(file1,name)
        #         data = CSV.read(file1,DataFrame,header=0)
        #         CSV.write(file2,data;header=false)
        #     end
        # end
            for subfile2 in dl2
                file2 = joinpath(file1,subfile2)
                if occursin(".csv",subfile2)
                    name1 = match(r"PIEs_AJUN_ORB_(.*)",subfile2)
                    name = string(filename)*string(subfile)*string(name1[1])
                    # name2 = match(r"(.*)N_.*(.csv)",filename)
                    # name = string(file)*string()*string(name2[2])
                    # println((name2))
                    file3 = joinpath(filepath,name)
                    data = CSV.read(file2,DataFrame,header=0)
                    CSV.write(file3,data;header=false)
                end
            end
        end
    end
end

t2 = Dates.now()
println(t2-t1)