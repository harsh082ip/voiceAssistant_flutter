import 'dart:convert';

import 'package:http/http.dart' as http;
import '../secretApi.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];
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
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dalle(prompt);
            return res;
          default:
            final res = await chatGPT(prompt);
            return res;
        }
      }
    } catch (e) {
      return e.toString();
    }
    return 'Some Error Occured';
  }

  Future<String> chatGPT(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIkey'
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": messages,
          }));
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
    } catch (e) {
      return e.toString();
    }
    return 'Some Error Occured';
  }

  Future<String> dalle(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $openAIkey'
          },
          body: jsonEncode({
            'prompt': prompt,
            'n': 1,
          }));
      print(res.body);
      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();

        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      }
    } catch (e) {
      return e.toString();
    }
    return 'Some Error Occured';
  }
}
