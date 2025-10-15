#TCP通信程序客户端
import socket
#创建socket对象
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
#获取本地主机名
host=socket.gethostname()
#设置端口号
port=3210
#连接服务端，指定主机和端口
s.connect((host,port))
#接收小于1024字节的数据，打印接收的数据
while True:  
    data = input('请输入你的数据:')
    #发送数据到服务端  
    s.send(data.encode('utf-8'))
    #接收服务端数据  
    data = s.recv(1024)
    print(data.decode('utf-8'))
    if data.decode('utf-8') =='bye':
        break  
#关闭连接
s.close()
