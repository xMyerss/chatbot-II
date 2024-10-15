import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';  // Importar url_launcher

class HomeScreen extends StatelessWidget {
  // Método para abrir el enlace
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/photo.jpg')), // Aquí el logo de la universidad
            SizedBox(height: 20),
            Text('Carrera: Ingeniería en Software', style: TextStyle(fontSize: 18)),
            Text('Materia: Programación Móvil II', style: TextStyle(fontSize: 18)),
            Text('Grupo: 9B', style: TextStyle(fontSize: 18)),
            Text('Alumno: Pedro Josafat Ruiz Robles', style: TextStyle(fontSize: 18)),
            Text('Matrícula: 213537', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _launchURL('https://github.com/tu-usuario/tu-repositorio');  // Cambia esta URL
              },
              child: Text(
                'Repositorio GitHub',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                child: Text('Ir al ChatBot'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
