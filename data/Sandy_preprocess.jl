using CSV
using DataFrames,Statistics,Dates

savepath = raw"C:\Users\F1_001\Desktop\tst.xlsx"
filepath = raw"D:\data\FPGA_DEMURA\Vth\vthon"
# data = CSV.read(raw"D:\data\FPGA_DEMURA\ESWIN\#1\t\G32.csv",DataFrame,header=0)
datalist = readdir(filepath)

if savepath in readdir(dirname(savepath))
    Nothing
else
    XLSX.openxlsx(savepath, mode="w") do xf
    end
end

t1 = Dates.now()
for filename in datalist
    file = joinpath(filepath,filename)
    if occursin(".csv",filename)
        name = match(r"(.*).csv",filename)
        sheetname = string(name[1])
        XLSX.openxlsx(savepath,mode="rw") do xf
            # println(XLSX.sheetnames(xf))
            namelist = XLSX.sheetnames(xf)
            if sheetname in namelist
                sheet = xf["$sheetname"]
            else
                XLSX.addsheet!(xf,"$sheetname")
                sheet = xf["$sheetname"]
            end
            # XLSX.rename!(sheet, sheetname)
            data = CSV.read(file,DataFrame,header=0)
            h,w = size(data)
            df = data[Int64(h/2-50):Int64(h/2+49),Int64(w/2-50):Int64(w/2+49)]
            for r in 1:size(df,1), c in 1:size(df,2)
                sheet[XLSX.CellRef(r , c )] = df[r,c]
            end
        end
    else ispath(file)
        subfile = readdir(file)
        for subfilename in subfile
            file_ = joinpath(file,subfilename)
            name = match(r"(.*).csv",subfilename)
            sheetname = string(name[1])
            XLSX.openxlsx(savepath,mode="rw") do xf
                # println(XLSX.sheetnames(xf))
                namelist = XLSX.sheetnames(xf)
                if sheetname in namelist
                    sheet = xf["$sheetname"]
                else
                    XLSX.addsheet!(xf,"$sheetname")
                    sheet = xf["$sheetname"]
                end
                # XLSX.rename!(sheet, sheetname)
                data = CSV.read(file_,DataFrame,header=0)
                h,w = size(data)
                df = data[Int64(h/2-50):Int64(h/2+49),Int64(w/2-50):Int64(w/2+49)]
                for r in 1:size(df,1), c in 1:size(df,2)
                    sheet[XLSX.CellRef(r , c )] = df[r,c]
                end
            end
        end
    end
end



