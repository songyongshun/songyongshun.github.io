import socket

HOST = '127.0.0.1'  # 本地监听
PORT = 8000         # 端口改为 8000

def handle_client(conn):
	# 只做最简单的接收与响应（不判断 method/path）
	req = conn.recv(4096)
	req_text = req.decode('utf-8', errors='replace')
	print("----- Request -----")
	print(req_text)
	print("-------------------")

	body = "<html><head><title>Simple Socket HTTP Server</title></head><body><h1>Hello from Simple Socket HTTP Server</h1><p>这是用 Python socket 实现的最简 HTTP 服务器示例。</p></body></html>".encode('utf-8')

	# 在此处直接构建响应（状态行 + 头部 + 空行 + body）
	default_headers = {
		'Server': 'SimpleSocketHTTPServer',
		'Content-Type': 'text/html; charset=utf-8',
		'Content-Length': str(len(body)),
		'Connection': 'close',
	}
	status_line = 'HTTP/1.1 200 OK\r\n'
	header_lines = ''.join(f'{k}: {v}\r\n' for k, v in default_headers.items())
	response = (status_line + header_lines + '\r\n').encode('utf-8') + body

	conn.sendall(response)
	conn.close()

def run_server(host=HOST, port=PORT):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        # 允许端口重用，方便调试
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind((host, port))
        s.listen(5)
        print(f"Serving HTTP on {host}:{port} ...")
        while True:
            client_conn, client_addr = s.accept()
            print(f"Connection from {client_addr}")
            # 为简单示例：逐个处理请求（不并发）
            handle_client(client_conn)

if __name__ == '__main__':
    run_server()