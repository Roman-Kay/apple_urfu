import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/domain/services/message/message_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';


@RoutePage()
class ImageViewerScreen extends StatefulWidget {
  const ImageViewerScreen({Key? key,
    required this.type,
    this.fileId,
    required this.name,
    this.isDownload = false,
    required this.file
  }) : super(key: key);

  final String type;
  final String? fileId;
  final String name;
  final isDownload;
  final Uint8List? file;

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {

  Uint8List? file;
  bool isError = false;
  bool isLoading = false;

  getFile() async{
    if(mounted){
      if(widget.type == "message" && widget.fileId != null){
        setState(() {
          isLoading = true;
        });
        final response = await MessageService().getFile(widget.fileId!);

        if (response.result && response.value?.data != null) {
          Uint8List avatar = base64Decode(response.value!.data!);
          if(mounted){
            setState(() {
              file = avatar;
              isLoading = false;
            });
          }
        }
        else {
          setState(() {
            isError = true;
          });
        }

      }
      else if(widget.type == "expert" && widget.file != null){
        setState(() {
          file = widget.file;
        });
      }
    }
  }

  @override
  void initState() {
    getFile();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.basicwhiteColor,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () {
                context.router.maybePop();
              },
              icon: Image.asset(
                AppImeges.arrow_back_png,
                color: AppColors.darkGreenColor,
                height: 25.h,
                width: 25.w,
              )),
        ),
        actions: [
          // widget.isDownload ?
          //      IconButton(
          //         icon: Icon(Icons.download, size: 25),
          //         onPressed: () async{
          //           if(file != null){
          //             File newFile = await File.fromRawPath(file!);
          //
          //             Share.shareXFiles([XFile(newFile.path)]);
          //           }
          //         },
          //         color: AppColors.darkGreenColor,
          //      )
          //     :
          Container(),
        ],
        title: Text(
          widget.name,
          style: TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: AppColors.darkGreenColor
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: getImage(),
      ),
    );
  }

  Widget getImage(){
    if(isError){
      return SizedBox(
        height: MediaQuery.of(context).size.height / 1.2,
        child: ErrorWithReload(
          callback: () {
            getFile();
          },
        ),
      );
    }
    else if(isLoading){
      return SizedBox(
          height: MediaQuery.of(context).size.height / 1.3,
          child: ProgressIndicatorWidget());
    }
    else if(file != null){
      return Image.memory(
        file!,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      );
    }
    else{
      return Container();
    }
  }
}
