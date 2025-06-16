import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:garnetbook/utils/colors.dart';

class ErrorWithReload extends StatefulWidget {
  final VoidCallback callback;
  String? text = "Не удалось загрузить данные";
  final bool? isWhite;

  ErrorWithReload({super.key, required this.callback, this.text, this.isWhite});

  @override
  State<ErrorWithReload> createState() => _ErrorWithReloadState();
}

class _ErrorWithReloadState extends State<ErrorWithReload> {
  @override
  void initState() {
    checkInternetConnection();
    super.initState();
  }

  void checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.first.name == 'none') {
      setState(() {
        widget.text = 'Отсутствует подключение к Интер';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.replay,
              color: widget.isWhite == true ? AppColors.basicwhiteColor : AppColors.darkGreenColor,
              size: 30,
            ),
            onPressed: widget.callback,
          ),
          const SizedBox(height: 5),
          Text(
            widget.text ?? 'Не удалось загрузить данные',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: widget.isWhite == true ? AppColors.basicwhiteColor : AppColors.darkGreenColor),
          ),
        ],
      ),
    );
  }
}
