# import http.server
from http.server import HTTPServer, SimpleHTTPRequestHandler

PORT = 8010

class CustomHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html; charset=utf-8")
        self.end_headers()
        html = """
        <!DOCTYPE html>
        <html lang="zh-CN">
        <head>
            <meta charset="UTF-8">
            <title>Python 服务器</title>
        </head>
        <body>
            <h1>Python HTTP Server</h1>
            <p>访问成功！端口：8000</p>
            <p>中文显示测试：你好，世界！</p>
        </body>
        </html>
        """
        self.wfile.write(html.encode("utf-8"))

with HTTPServer(("", PORT), CustomHandler) as httpd:
    print(f"服务器运行中，访问 http://localhost:{PORT}")
    httpd.serve_forever()