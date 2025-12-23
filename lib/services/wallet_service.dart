import "dart:convert";
import 'package:http/http.dart' as http;


class WalletService {
  static const String _endpoint = "https://api.example.com/wallet";


  static Future<int> fetchWalletBalance(String userId) async {
    final response = await http.get(
      Uri.parse("$_endpoint/balance"),
      headers: {
        "Authorization" : "Bearer $userId",
        "Content-Type": "application/json",
      },
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['balance'];
    } else {  
    throw Exception("Failed to load wallet balance");
    }
  }
}