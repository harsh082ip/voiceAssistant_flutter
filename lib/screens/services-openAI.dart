import 'dart:convert';

import 'package:http/http.dart' as http;
import '../secretApi.dart';

class OpenAIService {
  Future<String> isArtPrompt(String prompt) async {
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIkey'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                "role": "user",
                "content":
                    "Does this message wants to generate an AI picture, image, art or anything similar?. $prompt. Simply answer with a yes or no.",
              }
            ]
          }));
      print(res.body);
      if (res.statusCode == 200) {
        print('woow');
      }
    } catch (e) {
      return e.toString();
    }
    return 'AI';
  }

  Future<String> chatGPT(String prompt) async {
    return 'CHATGPT';
  }

  Future<String> dalle(String prompt) async {
    return 'DALL-E';
  }
}
