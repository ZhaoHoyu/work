import CSV,XLSX
using DataFrames,Statistics,Dates


savepath = raw"C:\Users\F1_001\Desktop\tandem_LLC4sides.xlsx"
filepath = raw"C:\Users\F1_001\Desktop\TANDEMDE - 副本\S1\PUC ON"

datalist = readdir(filepath)


t1 = Dates.now()
XLSX.openxlsx(savepath,mode="w") do xf
    ct = 1
    oc = 1
    # ord = ["1000nit_W255","600nit W255","100nit W255","1000nit W8","600nit W31","100nit W31","4nit W255","10nit W255","4nit W186","10nit W123","4nit W136","10nit W90","4nit W90","10nit W59","4nit W66","10nit W43","4nit W48","10nit W32","4nit W35","10nit W23","4nit W32","10nit W21","4nit W28","10nit W19","4nit W23","10nits W15","4nit W17","10nits W11"]
    ord = ["1000nit_W255","600nit W255","100nit W255","1000nit W8","600nit W31","100nit W31","4nit W255","10nit W255","10nit W123","4nit W136","10nit W90","10nit W59","4nit W66","10nit W43","10nit W32","10nit W21","10nits W15","10nits W11"]
    # num = ["_POI_DataLLC POR #329 PUC O.csv","_POI_DataLLC POR #328 PUC O.csv","_POI_DataLLC DOE6 #431 PUC O.csv","_POI_DataLLC DOE6 #430 PUC O.csv","_POI_DataLLC DOE6 #241 PUC O.csv"]
    # num = ["_POI_DataPOR #565 PUC O.csv","_POI_DataPOR #540 PUC O.csv","_POI_DataPOR #354 PUC O.csv","_POI_DataPOR #277 PUC O.csv","_POI_DataPOR #186 PUC O.csv"]
    num = ["_POI_DataS1 POR #251 PUC O.csv","_POI_DataS1 POR #229 PUC O.csv","_POI_DataS1 POR #199 PUC O.csv","_POI_DataS1 POR #375 PUC O.csv","_POI_DataS1 DOE13 #268 PUC O.csv"]
    # while oc < 9
    for i in ord
        # for count in 1:5
        for j in num
        # println(typeof(filename[oc]))
        # if occursin(filename[oc],datalist)
        # if filename[oc] in datalist
        # for filename in datalist
            # println(filename)
        # if occursin(ord[oc],filename)
            # println(filename)
            filename = i*j
            file = joinpath(filepath,filename)
            # println(file)
            sheet = xf[1]
            sheet[1,ct] = string(filename)
            data = CSV.read(file,DataFrame,header=0)
            h,w = size(data)
                # println(h,w)
            df1 = data[1:h,2:2]
            df2 = data[1:h,3:4]
                # println(size(df))
            for r in 1:size(df2,1), c in 1:size(df2,2)
                sheet[XLSX.CellRef(r+1 , c+ct-1 )] = df2[r,c]
            end
            for r in 1:size(df1,1), c in 1:size(df1,2)
                sheet[XLSX.CellRef(r+1 , c+ct+1 )] = df1[r,c]
            end
            ct += 3
            # oc += 1
            # println(oc)
            # end
        end
        # end
    end
end
t2 = Dates.now()
println(t2-t1)











# t1 = Dates.now()
# XLSX.openxlsx(savepath,mode="w") do xf
#     ct = 1
#     for filename in datalist
#         file = joinpath(filepath,filename)
#         sheet = xf[1]
#         sheet[1,ct] = string(filename)
#         data = CSV.read(file,DataFrame,header=0)
#         h,w = size(data)
#             # println(h,w)
#         df1 = data[1:h,2:2]
#         df2 = data[1:h,3:4]
#             # println(size(df))
#         for r in 1:size(df2,1), c in 1:size(df2,2)
#             sheet[XLSX.CellRef(r+1 , c+ct-1 )] = df2[r,c]
#         end
#         for r in 1:size(df1,1), c in 1:size(df1,2)
#             sheet[XLSX.CellRef(r+1 , c+ct+1 )] = df1[r,c]
#         end
#         ct += 3
#     end
# end
# t2 = Dates.now()
# println(t2-t1)







# t1 = Dates.now()
# ct = 1
# for filename in datalist
#     file = joinpath(filepath,filename)
#     ct1 = ct
#     XLSX.openxlsx(savepath,mode="w") do xf
#         sheet = xf[1]
#         sheet[1,ct] = string(filename)
#         data = CSV.read(file,DataFrame,header=0)
#         h,w = size(data)
#         # println(h,w)
#         df = data[1:h,2:w]
#         # println(size(df))
#         for r in 1:size(df,1), c in 1:size(df,2)
#             sheet[XLSX.CellRef(r+1 , c+ct )] = df[r,c]
#         end
#     end
#     ct += 3
# end
# t2 = Dates.now()
# println(t2-t1)