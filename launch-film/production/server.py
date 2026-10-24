from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
import re
root = Path('launch-film').resolve()
frames = Path('work/launch-film/frames').resolve()
frames.mkdir(parents=True, exist_ok=True)
class Handler(SimpleHTTPRequestHandler):
    def __init__(self,*args,**kwargs): super().__init__(*args,directory=str(root),**kwargs)
    def log_message(self,*args): pass
    def do_POST(self):
        match = re.fullmatch(r'/frame/(\d{1,3})', self.path)
        length = int(self.headers.get('Content-Length',0))
        if not match or int(match[1])>=450 or length>3000000:
            self.send_error(400); return
        (frames / ('%04d.jpg'%int(match[1]))).write_bytes(self.rfile.read(length))
        self.send_response(200); self.end_headers(); self.wfile.write(b'OK')
ThreadingHTTPServer(('127.0.0.1',8766),Handler).serve_forever()
