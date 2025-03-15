from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Base de datos en memoria (diccionario de recordatorios)
recordatorios = {}

# Ruta para la página de inicio (lista de recordatorios)
@app.route('/')
def index():
    return render_template('index.html', recordatorios=recordatorios)

# Ruta para crear un nuevo recordatorio
@app.route('/crear', methods=['GET', 'POST'])
def crear():
    if request.method == 'POST':
        # Obtener el título y la descripción del formulario
        titulo = request.form['titulo']
        descripcion = request.form['descripcion']
        
        # Crear un nuevo recordatorio con un ID único
        recordatorio_id = len(recordatorios) + 1
        recordatorios[recordatorio_id] = {'titulo': titulo, 'descripcion': descripcion}
        
        return redirect(url_for('index'))
    
    return render_template('crear.html')

# Ruta para editar un recordatorio
@app.route('/editar/<int:id>', methods=['GET', 'POST'])
def editar(id):
    recordatorio = recordatorios.get(id)
    if not recordatorio:
        return redirect(url_for('index'))

    if request.method == 'POST':
        # Obtener los nuevos datos del formulario
        recordatorio['titulo'] = request.form['titulo']
        recordatorio['descripcion'] = request.form['descripcion']
        
        return redirect(url_for('index'))

    return render_template('editar.html', recordatorio=recordatorio, id=id)

# Ruta para eliminar un recordatorio
@app.route('/eliminar/<int:id>')
def eliminar(id):
    if id in recordatorios:
        del recordatorios[id]
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)

