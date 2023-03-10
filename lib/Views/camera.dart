import 'package:camera/camera.dart';
import '/utils/info_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _cameraController;
  XFile? image;
  bool isRearCamSelected = true;

  @override
  void initState() {
    // TODO: implement initState
    initCamera();
    super.initState();
  }

  Future initCamera() async{
    _cameraController = CameraController(
        widget.cameras[0],
        ResolutionPreset.medium
    );
    _cameraController.initialize().then((_){
      if(!mounted){
        return;
      }
      setState(() {
      });
    });
  }

  Future takePicture() async{
    if(!_cameraController.value.isInitialized){
      return null;
    }
    if(_cameraController.value.isTakingPicture){
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      image = await _cameraController.takePicture();
      //Navigator.pop(context, MaterialPageRoute(builder: (context) => Visits()));
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
      return null;
    }
  }

  Future<void> onCameraSwitch() async {
    final CameraDescription cameraDescription =
    (_cameraController.description == widget.cameras[0]) ? widget.cameras[1] : widget.cameras[0];
    if (_cameraController != null) {
      await _cameraController.dispose();
    }
    _cameraController = CameraController(cameraDescription, ResolutionPreset.medium);
    _cameraController.addListener(() {
      if (mounted) setState(() {});
      if (_cameraController.value.hasError) {
        Info.errorSnackBar('Camera error ${_cameraController.value.errorDescription}');
      }
    });

    try {
      await _cameraController.initialize();
    } on CameraException catch (e) {
      print(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            (_cameraController.value.isInitialized)
                ? CameraPreview(_cameraController)
                : Container(color: Colors.black,
              child: const Center(child: CircularProgressIndicator(),),),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    color: Colors.black
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 40,
                      icon: Icon(isRearCamSelected
                          ? CupertinoIcons.switch_camera
                          : CupertinoIcons.switch_camera_solid,
                        color: Colors.white,
                      ),
                      onPressed: (){
                        setState(() {
                          isRearCamSelected = !isRearCamSelected;
                        });
                        onCameraSwitch;
                      },
                    )),
                    Expanded(child: IconButton(
                      onPressed: takePicture,
                      iconSize: 50,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.circle, color: Colors.white,),
                    )),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
