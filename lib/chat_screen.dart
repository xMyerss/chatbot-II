import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();
  bool isConnected = true; // Manejaremos la conexión de forma básica

  // Método que envía el mensaje y obtiene la respuesta del bot
  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    // En lugar de verificar la conexión explícitamente, lo manejamos con un try-catch
    try {
      setState(() {
        messages.add({'user': _controller.text});
      });

      String botResponse = await _getBotResponse(_controller.text);
      setState(() {
        messages.add({'bot': botResponse});
      });

      _controller.clear();
    } catch (error) {
      setState(() {
        messages.add({'bot': 'No hay conexión a Internet. Por favor, intenta más tarde.'});
      });
    }
  }

  // Función que se comunica con la API de Gemini
  Future<String> _getBotResponse(String userMessage) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=AIzaSyAGdwOcMUCmtZeIHsYkO6i0XviL42kNwMg'
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    // Combinar el historial de mensajes en un solo string
    String conversationHistory = '';
    for (var message in messages) {
      if (message.containsKey('user')) {
        conversationHistory += "Usuario: ${message['user']}\n";
      } else if (message.containsKey('bot')) {
        conversationHistory += "Bot: ${message['bot']}\n";
      }
    }

    // Añadir el nuevo mensaje del usuario
    conversationHistory += "Usuario: $userMessage\n";

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": conversationHistory  // Enviar el historial completo de la conversación
            }
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No se recibió una respuesta del modelo';
      } else {
        return 'La API no devolvió ninguna respuesta válida';
      }
    } else {
      print('Error en la respuesta de la API: ${response.statusCode}');
      return 'Error con la IA. Código de error: ${response.statusCode}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message.keys.first == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(message.values.first),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,  // El botón sigue funcionando, pero el error se maneja en _sendMessage
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
