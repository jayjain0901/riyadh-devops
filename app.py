from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return '''
    <html>
        <body>
            <h1>Hello, World!</h1>
            <p>This is a simple Flask application deployed on Kubernetes</p>
            <p>Version: 1.0.0</p>
            <p>Environment: Production</p>
        </body>
    </html>
    '''

@app.route('/health')
def health():
    return {'status': 'healthy', 'version': '1.0.0'}

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
