
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/domain/controllers/pdf/pdf_controller.dart';
import 'package:garnetbook/domain/services/message/message_service.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';

@RoutePage()
class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({Key? key,
    required this.pathPDF,
    required this.name,
    this.fileId,
    required this.type,
    this.isDownload = false
  }) : super(key: key);

  final String? pathPDF;
  final String name;
  final bool isDownload;
  final String type;
  final String? fileId;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PDFViewController? _pdfViewController;
  String? file;
  bool isError = false;
  bool isLoading = false;
  bool pdfReady = false;
  int? _totalPages;

  getFile() async{
    if(mounted){
      if(widget.type == "message" && widget.fileId != null){
        setState(() {
          isLoading = true;
        });
        final response = await MessageService().getFile(widget.fileId!);

        if (response.result && response.value?.data != null) {

          await PdfFileController().createFileFromString(response.value!.data!).then((value) {

            if(mounted){
              setState(() {
                file = value;
                isLoading = false;
              });
            }
          });
        }
        else {
          setState(() {
            isError = true;
          });
        }
      }
      else if(widget.type == "expert" && widget.pathPDF != null){
        setState(() {
          file = widget.pathPDF;
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
          backgroundColor: AppColors.basicwhiteColor,
          centerTitle: true,
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
            // IconButton(
            //     icon: Icon(Icons.download, size: 25),
            //     onPressed: (){
            //
            //       // написать логику скачивания файла
            //
            //     },
            //     color: AppColors.darkGreenColor)
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
        body: getFileWidget(),
    );
  }


  Widget getFileWidget(){
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
      return PDFView(
        filePath: file,
        enableSwipe: true,
        autoSpacing: false,
        pageFling: false,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onError: (error) {
          debugPrint(error.toString());
        },
        onRender: (_pages) {
          setState(() {
            _totalPages = _pages;
            pdfReady = true;
          });
        },
        onViewCreated: (PDFViewController vc) {
          setState(() {
            _pdfViewController = vc;
          });
        },
        onPageChanged: (page, total) {

        },
        onPageError: (page, error) {
          debugPrint('$page: ${error.toString()}');
        },
      );
    }
    else{
      return Container();
    }
  }
}
