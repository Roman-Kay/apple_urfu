
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoaderOverlayWidget extends StatelessWidget {
  const LoaderOverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS ? SizedBox(
        width: 38,
        height: 38,
        child: CupertinoActivityIndicator(color: Colors.white)
      ) : SizedBox(
          width: 34,
          height: 34,
          child: CircularProgressIndicator(
      strokeWidth: 4,
      color: Colors.white,
    ) ,
    )
    );
  }
}
