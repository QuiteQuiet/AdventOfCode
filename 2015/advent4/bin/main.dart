import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  String input = 'bgvyzdsv', hash = '';
  int next = 0;
  while (!hash.startsWith('00000')) {
    next++;
    hash = md5.convert(utf8.encode('$input$next')).toString();
  }
  print('Part 1: $next');
  while (!hash.startsWith('000000')) {
    next++;
    hash = md5.convert(utf8.encode('$input$next')).toString();
  }
  print('Part 2: $next');
}

