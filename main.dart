import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Spring at home'),
            SizedBox(height: 60),
            FieldAuth(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('button pressed!');
              },
              child: Text('далее'),
            )
          ],
        ),
      ),
    );
  }
}


class FieldAuth extends StatelessWidget {
  const FieldAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final FocusNode focusNode = FocusNode();

    // Устанавливаем фокус при построении виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });    

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.5 * 255).toInt()),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          focusNode: focusNode, //Привязываем фокус к полю
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            labelText: 'Введите номер телефона',
            filled: true,
            fillColor: Colors.white,
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            PhoneFormatter(),
          ],
        ),
      ),
    );
  }
}



class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Удаляем все символы, кроме цифр
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Если первый символ не +, 7, 8 или 9, не обрабатываем
    if (newValue.text.isNotEmpty &&
        !['+', '7', '8', '9'].contains(newValue.text[0])) {
      return oldValue; // Возвращаем предыдущее значение
    }

    // Если первый символ "+", оставляем его без добавления "7"
    if (newValue.text.startsWith('+') && newValue.text.length == 1) {
      return newValue;
    }

    // Логика обработки первых символов
    if (digits.startsWith('8')) {
      digits = '7${digits.substring(1)}'; // Заменяем 8 на 7
    } else if (digits.startsWith('9')) {
      digits = '7$digits'; // Добавляем 7 перед 9
    }

    // Формируем маску +7 (XXX) XXX-XX-XX
    String formattedNumber = '+7';
    if (digits.length > 1) {
      formattedNumber += ' (${digits.substring(1, digits.length > 4 ? 4 : digits.length)}';
    }
    if (digits.length > 4) {
      formattedNumber += ') ${digits.substring(4, digits.length > 7 ? 7 : digits.length)}';
    }
    if (digits.length > 7) {
      formattedNumber += '-${digits.substring(7, digits.length > 9 ? 9 : digits.length)}';
    }
    if (digits.length > 9) {
      formattedNumber += '-${digits.substring(9, digits.length > 11 ? 11 : digits.length)}';
    }
    if (digits.length > 1 && digits[1] != '9') {
      return oldValue; // Игнорируем ввод
    }


    // Возвращаем отформатированный номер
    return TextEditingValue(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }
}

