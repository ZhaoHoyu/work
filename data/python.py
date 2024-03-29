import pandas as pd			#pandas是一个强大的分析结构化数据的工具集


# 将csv文件内数据读出
ngData=pd.read_csv('../data/namegender.csv')

#添加新列‘名字长度’（length）
ngList=[]                                       			#准备一个列表，把新列的数据存入其中
for index,row in ngData.iterrows():			                #遍历数据表，计算每一位名字的长度
    ngList.append(len(row['realname']))
ngData['length']=ngList                                     #注明列名，就可以直接添加新列
ngData.to_csv('../data/namegender.csv',index=False)         #把数据写入数据集，index=False表示不加索引
#注意这里的ngData['length']=ngList是直接在原有数据基础上加了一列新的数据，也就是说现在的ngData已经具备完整的3列数据
#不用再在to_csv中加mode=‘a’这个参数，实现不覆盖添加。

#查看修改后的csv文件
ngData1=pd.read_csv('../data/namegender.csv')
print("new ngData:\n",ngData1)
