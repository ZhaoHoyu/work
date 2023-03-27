import numpy as np
import pandas as pd
from pprint import pprint
import scipy.io as scio
import os

path = r'D:\python\MipiData_20191210_104354192_EI_70M.csv'


# CSV文件转为txt文件
def write2txt(a):
    txtName = os.path.dirname(path) + '\\' + os.path.basename(path)[:-4] + '.txt'
    f = open(txtName, 'w')
    for i in a:
        s = str(i).replace('[', '').replace(']', '')  # 去除[],这两行按数据不同，可以选择
        s = s.replace("'", '').replace(',', '') + '\n'  # 去除单引号，逗号，每行末尾追加换行符
        f.write(s)
    f.close()
    print('write2txt finish')


# CSV文件转为mat文件
# mat文件读取出来是一个字典,所以要保存为一个字典
def write2mat(a):
    txtName = os.path.dirname(path) + '\\' + os.path.basename(path)[:-4] + '.mat'
    scio.savemat(txtName, mdict={'data': a})
    print('write2mat finish')


# 读取CSV文件
def opendata(path):
    df = pd.read_csv(path, header=None, names=['row', 'col', 'in_t', 'Ramp', 'Off_t'])
    list_data = df.values.tolist()
    write2txt(list_data)
    write2mat(list_data)


if __name__ == '__main__':
    opendata(path)