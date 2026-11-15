import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/chat_message.dart';

const scopeRefusal =
    'Saya hanya dapat membantu seputar SiFinance dan keuangan, seperti '
    'pencatatan transaksi, anggaran, tabungan, dan perencanaan keuangan.';

abstract class ChatService {
  bool get isDemo;

  Future<String> reply({
    required String message,
    required List<ChatMessage> history,
    ChatAttachment? attachment,
  });

  void close() {}
}

ChatService createChatService() {
  const baseUrl = String.fromEnvironment('API_BASE_URL');
  return baseUrl.isEmpty ? DemoChatService() : ApiChatService(baseUrl: baseUrl);
}

class ApiChatService extends ChatService {
  ApiChatService({required String baseUrl, http.Client? client})
    : _baseUrl = baseUrl.replaceFirst(RegExp(r'/+$'), ''),
      _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;

  @override
  bool get isDemo => false;

  @override
  Future<String> reply({
    required String message,
    required List<ChatMessage> history,
    ChatAttachment? attachment,
  }) async {
    try {
      final recent = history.where((item) => !item.isError).toList();
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/api/chat'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'message': message,
              'history': recent
                  .skip(recent.length > 12 ? recent.length - 12 : 0)
                  .map((item) => item.toHistory())
                  .toList(),
              if (attachment != null) 'attachment': attachment.toJson(),
            }),
          )
          .timeout(const Duration(seconds: 100));
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        throw ChatException(
          body is Map && body['error'] is String
              ? body['error'] as String
              : 'Layanan AI sedang tidak tersedia. Coba lagi.',
        );
      }
      if (body is! Map || body['reply'] is! String) {
        throw const FormatException();
      }
      final reply = (body['reply'] as String).trim();
      if (reply.isEmpty) throw const FormatException();
      return reply;
    } on ChatException {
      rethrow;
    } on TimeoutException {
      throw const ChatException('Respons AI terlalu lama. Silakan coba lagi.');
    } on FormatException {
      throw const ChatException(
        'Respons server tidak valid. Silakan coba lagi.',
      );
    } catch (_) {
      throw const ChatException(
        'Server belum terhubung. Periksa koneksi dan API_BASE_URL.',
      );
    }
  }

  @override
  void close() => _client.close();
}

/// Respons tetap untuk mencoba UI sebelum mengisi API_BASE_URL.
class DemoChatService extends ChatService {
  @override
  bool get isDemo => true;

  @override
  Future<String> reply({
    required String message,
    required List<ChatMessage> history,
    ChatAttachment? attachment,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (attachment != null) {
      return 'Gambar berhasil dilampirkan. Analisis struk tersedia setelah '
          'backend AI terhubung. Mode demo belum membaca isi gambar.';
    }
    final normalized = message.toLowerCase().trim().replaceAll(
      RegExp(r'[?!.,]+$'),
      '',
    );
    const replies = {
      'bandingkan keuangan saya antara periode saat ini dengan sebelumnya':
          'Untuk membandingkan dua periode, kirim total pemasukan dan '
          'pengeluaran masing-masing periode. Data transaksi akun belum '
          'terhubung pada starter ini.',
      'cek keuangan per kategori':
          'Kirim daftar pengeluaran beserta kategorinya, misalnya makanan, '
          'transportasi, dan belanja. AI dapat membantu menghitung porsi '
          'tiap kategori setelah backend terhubung.',
      'simulasi rencana keuangan':
          'Sebutkan target tabungan, dana awal, dan tenggat waktunya. '
          'Kebutuhan menabung per bulan dapat dihitung dari selisih target '
          'dan dana awal, dibagi jumlah bulan.',
      'minta rekomendasi budget':
          'Mulai dari pemasukan bersih, kebutuhan wajib, cicilan, dan '
          'target tabungan. Kirim nominalnya agar anggaran dapat disusun '
          'sesuai kondisi keuanganmu.',
      'apa itu sifinance':
          'SiFinance membantu pencatatan keuangan individu dan keluarga '
          'melalui quick logging, smart budget alert, dan selective sharing. '
          'AI Chat membantu memahami transaksi dan merencanakan anggaran.',
      'halo': 'Halo! Ingin membahas anggaran atau pencatatan keuangan di SiFinance?',
    };
    return replies[normalized] ??
        '$scopeRefusal\n\nMode demo menyediakan empat balasan cepat. '
            'Hubungkan backend untuk percakapan keuangan dengan model AI.';
  }
}

class ChatException implements Exception {
  const ChatException(this.message);
  final String message;
}
