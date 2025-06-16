// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:cached_memory_image/provider/cached_memory_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:garnetbook/bloc/message/chat/chat_bloc/chat_bloc.dart';
import 'package:garnetbook/bloc/message/chat/list_chat_cubit/list_chat_cubit.dart';
import 'package:garnetbook/data/models/auth/create_user.dart';
import 'package:garnetbook/data/models/message/message_chat_models/file_models.dart';
import 'package:garnetbook/data/models/message/message_chat_models/message_model.dart';
import 'package:garnetbook/data/models/others/file_view.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/controllers/pdf/pdf_controller.dart';
import 'package:garnetbook/domain/services/message/message_service.dart';
import 'package:garnetbook/ui/routing/app_router.dart';
import 'package:garnetbook/utils/colors.dart';
import 'package:garnetbook/utils/functions/date_formating_functions.dart';
import 'package:garnetbook/utils/images.dart';
import 'package:garnetbook/widgets/buttons/form_for_button.dart';
import 'package:garnetbook/widgets/dialogs/add_file_dialog.dart';
import 'package:garnetbook/widgets/error_handler/error_reload.dart';
import 'package:garnetbook/widgets/loaders/progress_indicator.dart';
import 'package:garnetbook/widgets/modal_sheets/image_bottom_sheet.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:measure_size/measure_size.dart';

@RoutePage()
class ClientMessagesChatScreen extends StatefulWidget {
  final String chatId;
  final String senderName;
  final bool isNew;
  final int? expertId;
  final FileView? view;

  const ClientMessagesChatScreen({
    super.key,
    required this.chatId,
    required this.isNew,
    this.expertId,
    this.view,
    required this.senderName});

  @override
  State<ClientMessagesChatScreen> createState() => _ClientMessagesChatScreenState();
}

class _ClientMessagesChatScreenState extends State<ClientMessagesChatScreen> {
  String myUserId = "";
  final service = MessageService();

  ScrollController scrollController = ScrollController();
  PagingController<int, Message> pagingController = PagingController(firstPageKey: 0);
  TextEditingController controller = TextEditingController();
  Map<int, double> width = {};


  @override
  void initState() {
    getUserId();

    pagingController.addPageRequestListener((pageKey) {
      context.read<ChatBloc>().add(ChatGetEvent(chatId: widget.chatId, pageKey: pageKey));
    });

    context.read<ChatBloc>().stream.listen((state) {
      if (mounted) {
        setState(() {
          pagingController.value = PagingState(
            nextPageKey: state.nextPageKey,
            error: state.error,
            itemList: state.list,
          );
        });
        checkIsRead(state.list);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pagingController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.basicwhiteColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                width: double.infinity,
                height: 60.h,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey50Color.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: AppColors.basicwhiteColor,
                ),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => context.router.maybePop(),
                                icon: Image.asset(
                                  AppImeges.arrow_back_png,
                                  color: AppColors.darkGreenColor,
                                  height: 25.h,
                                  width: 25.w,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              if(widget.expertId != null && widget.view != null && widget.view?.fileBase64 != null && widget.view?.fileBase64 != "")
                                CircleAvatar(
                                    radius: 19,
                                    backgroundImage: CachedMemoryImageProvider(
                                        "app://client_specialist_tabbar_${widget.expertId}",
                                        base64: widget.view?.fileBase64))
                              else
                                CircleAvatar(
                                  backgroundColor: AppColors.seaColor,
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.darkGreenColor,
                                  ),
                                  radius: 20,
                                ),
                              SizedBox(width: 12.w),
                              Flexible(
                                child: Text(
                                  widget.senderName,
                                  style: TextStyle(
                                    height: 1,
                                    fontSize: 16.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.darkGreenColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 20.w),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.focusedChild?.unfocus();
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 64.h, top: 60.h),
                child: PagedListView<int, Message>.separated(
                  scrollController: scrollController,
                  pagingController: pagingController,
                  reverse: true,
                  builderDelegate: PagedChildBuilderDelegate<Message>(
                    firstPageErrorIndicatorBuilder: (_) => widget.isNew ? Container() : ErrorWithReload(callback: () => pagingController.refresh()),
                    noItemsFoundIndicatorBuilder: (_) {
                      return Container();
                    },
                    newPageProgressIndicatorBuilder: (_) => ProgressIndicatorWidget(),
                    firstPageProgressIndicatorBuilder: (_) => ProgressIndicatorWidget(),
                    itemBuilder: (context, message, index) {
                      return GestureDetector(
                        onTap: () async {
                          if (message.timestamp == -1) {
                            final response = await service.createMessage(
                                CreateMessage(text: message.text, chatId: widget.chatId));

                            if (response.result) {
                              pagingController.refresh();
                            }
                          }
                        },
                        child: Align(
                          alignment: message.authorId != myUserId ? Alignment.centerLeft : Alignment.centerRight,
                          child: Container(
                            margin: EdgeInsets.only(
                              top: 18.h,
                              bottom: index == 0 ? 18.h : 0,
                              left: message.authorId == myUserId ? MediaQuery.of(context).size.width * 0.15 : 14.w,
                              right: message.authorId != myUserId ? MediaQuery.of(context).size.width * 0.15 : 14.w,
                            ),
                            decoration: message.authorId == myUserId
                                ? BoxDecoration(
                                color: AppColors.limeColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.r),
                                  topRight: Radius.circular(16.r),
                                  bottomLeft: Radius.circular(16.r),
                                ))
                                : BoxDecoration(
                                color: AppColors.blueBasicColor,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(16.r),
                                  bottomLeft: Radius.circular(16.r),
                                  bottomRight: Radius.circular(16.r),
                                )),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MeasureSize(
                                    onChange: (size) {
                                      setState(() {
                                        width[index] = size.width;
                                      });
                                    },
                                    child: message.type == "FILE"
                                      ? Container(
                                      height: 70,
                                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * 0.15 - 80.w),
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.basicwhiteColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: FormForButton(
                                        borderRadius: BorderRadius.circular(15),
                                        onPressed: () async {
                                          if (message.fileId != null) {
                                            if (message.filename == "file") {
                                              context.router.push(PdfViewerRoute(
                                                pathPDF: null,
                                                name: "Документ",
                                                type: "message",
                                                fileId: message.fileId!,
                                                isDownload: true,
                                              )).then((v){
                                                FocusScope.of(context).unfocus();
                                              });
                                            } else {
                                              context.router.push(
                                                ImageViewerRoute(
                                                  type: "message",
                                                  file: null,
                                                  fileId: message.fileId!,
                                                  isDownload: true,
                                                  name: "",
                                                ),
                                              ).then((v){
                                                FocusScope.of(context).unfocus();
                                              });
                                            }
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.file_open,
                                              color: AppColors.darkGreenColor,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "Открыть файл",
                                              style: TextStyle(fontWeight: FontWeight.w500, fontFamily: "Inter", fontSize: 16, color: AppColors.darkGreenColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                        : Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Text(
                                        message.text ?? "",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.darkGreenColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    constraints: BoxConstraints(
                                      minWidth: width[index] ?? 0,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          message.timestamp != -1 ? getTime(message.timestamp) : "Произошла ошибка",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            color: message.timestamp == -1 ? AppColors.redColor : AppColors.greenColor,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        message.timestamp != null && message.timestamp != -1
                                            ? SvgPicture.asset(
                                          message.authorId == myUserId ? 'assets/images/double_check_green.svg' : 'assets/images/double_check_blue.svg',
                                          width: 20.w,
                                          height: 20.h,
                                        )
                                            : message.timestamp != -1
                                            ? SvgPicture.asset(
                                          'assets/images/checkmark.svg',
                                          color: AppColors.greenColor,
                                          width: 20.h,
                                          height: 20.h,
                                        )
                                            : SvgPicture.asset(
                                          'assets/images/reload.svg',
                                          color: AppColors.redColor,
                                          width: 20.h,
                                          height: 20.h,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (context, index) => const SizedBox(height: 6),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(gradient: AppColors.gradientTurquoise),
                child: TextField(
                  cursorColor: AppColors.darkGreenColor,
                  controller: controller,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: (){
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.focusedChild?.unfocus();
                    }
                  },
                  toolbarOptions: ToolbarOptions(
                      copy: true,
                      paste: true,
                      cut: true,
                      selectAll: true
                  ),
                  style: TextStyle(color: AppColors.basicblackColor),
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 16.w, right: 16.w),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddFileDialog();
                            },
                          ).then((value) async{
                            if(value == "photo"){
                              showModalBottomSheet(
                                  context: context,
                                  useSafeArea: true,
                                  backgroundColor: AppColors.basicwhiteColor,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  builder: (builder) => ImagePickerBottomSheet()
                              ).then((image) async{
                                if (image != null && image.isAbsolute == true) {
                                  Uint8List? result = await FlutterImageCompress.compressWithFile(
                                    image.absolute.path,
                                    minHeight: 1080,
                                    minWidth: 1080,
                                    quality: 96,
                                    format: CompressFormat.webp,
                                  );

                                  if(result != null){
                                    String s = image.path;
                                    var pos = s.lastIndexOf('.');
                                    String resultName = (pos != -1) ? s.substring(pos) : s;
                                    String format = resultName.substring(1);

                                    String imageBase64 = base64Encode(result);

                                    Random random = Random();
                                    int randomNumber = random.nextInt(100);

                                    ImageView imageView = ImageView(
                                        name: "фото_документ_$randomNumber.$format",
                                        format: format,
                                        base64: imageBase64);

                                    validateMessage(imageView, "image");
                                  }
                                }
                              });
                            }
                            if(value == "doc"){
                              ImageView? imageView = await PdfFileController().pickPdfFile();
                              if(imageView != null){
                                validateMessage(imageView, "file");
                              }
                            }
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/images/paperclip.svg',
                          color: AppColors.darkGreenColor,
                          height: 20,
                        ),
                      ),
                    ),
                    suffixIcon: InkWell(
                      onTap: () async {
                        if (controller.text.isNotEmpty) {
                          String text = controller.text;

                          controller.clear();
                          FocusManager.instance.primaryFocus?.unfocus();

                          setState(() {
                            pagingController.itemList?.insert(
                                0,
                                Message(
                                  type: "MESSAGE",
                                  text: text,
                                  chatId: widget.chatId,
                                  authorId: myUserId,
                                ));
                          });

                          scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease);

                          final response = await service.createMessage(CreateMessage(text: text, chatId: widget.chatId));

                          if (response.result) {
                            if (response.value!.timestamp != null) {
                              if (pagingController.itemList != null && pagingController.itemList!.isNotEmpty) {
                                for (var element in pagingController.itemList!) {
                                  if (element.timestamp == null && element.text == text) {
                                    setState(() {
                                      element.timestamp = response.value!.timestamp!;
                                    });
                                    break;
                                  }
                                }
                              } else {
                                pagingController.refresh();
                              }
                            }
                          } else {
                            if (pagingController.itemList != null && pagingController.itemList!.isNotEmpty) {
                              for (var element in pagingController.itemList!) {
                                if (element.timestamp == null && element.text == text) {
                                  setState(() {
                                    element.timestamp = -1;
                                  });
                                  break;
                                }
                              }
                            }
                          }
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: AppColors.darkGreenColor,
                        size: 20,
                      ),
                    ),
                    hintText: 'Отправить сообщение...',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 24.h,
                    ),
                    hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.darkGreenColor,
                        decoration: TextDecoration.none,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getUserId() async {
    final storage = SharedPreferenceData.getInstance();
    final userId = await storage.getItem(SharedPreferenceData.clientIdKey);
    if (userId != "") {
      setState(() {
        myUserId = userId;
      });
    }
  }


  validateMessage(ImageView imageView, String type) async {
    if(imageView.base64 != null){
      FocusScope.of(context).unfocus();
      context.loaderOverlay.show();
      final messageService = MessageService();

      final response = await messageService.addFile(widget.chatId, MessageFileModels(
          data: imageView.base64!,
          name: type
      ));
      if (response.result) {
        context.loaderOverlay.hide();
        pagingController.refresh();
      }
      else {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 3),
            content: Text(
              'Произошла ошибка. Попробуйте повторить позже',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                fontFamily: 'Inter',
              ),
            ),
          ),
        );
      }
    }
  }


  checkIsRead(List<Message>? message) async {
    if (message != null && message.isNotEmpty) {
      List<String> messagesIds = [];
      message.forEach((element) {
        if (element.readed != true && element.id != null && element.authorId != myUserId) {
          if (!messagesIds.contains(element.id)) {
            messagesIds.add(element.id!);
          }
        }
      });

      if (messagesIds.isNotEmpty) {
        final response = await service.readMessage(MessageReadModel(messageIds: messagesIds));

        if(response.result){
          context.read<ListChatCubit>().check();
        }
      }
    }
  }

  String getTime(int? timeStamp) {
    if (timeStamp != null) {
      int newTimeStamp = timeStamp;
      DateTime myDateTime = DateTime.fromMillisecondsSinceEpoch(newTimeStamp);
      String time = DateFormatting().formatTime(myDateTime);

      return time;
    }
    return "";
  }
}
