#TCP通信程序服务端
import socket
#创建socket对象
s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
#获取本地主机名
host = socket.gethostname()
print(host)
#设置端口号
port = 3210
#绑定端口
s.bind((host,port))
#设置最大连接数，超过后排队
s.listen(5)
print("等待连接……")
#建立客户端连接，并接收客户端的数据
clientsocket,addr = s.accept()
print(f"Connection from {addr}")

while True:
    #接收客户端数据
    d = clientsocket.recv(1024) 
    d = d.decode('utf-8')
    if d=='bye':
        break
    print(d)
    msg = "欢迎来到Python的TCP网络编程世界!\n"
    #发送信息给客户端
    clientsocket.send(msg.encode('utf-8'))
#发送结束标志
msg='bye'
clientsocket.send(msg.encode('utf-8'))

#关闭连接
clientsocket.close()
s.close()

