import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/model/songlist/songlist_response_by_level.dart';
import 'package:skating_app/provider/db_menu_provider_coach.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/widgets/custom_buttons.dart';
import 'package:skating_app/widgets/custom_form_fields.dart';

class SongManagementScreen extends StatefulWidget {
  const SongManagementScreen({
    super.key,
  });

  @override
  State<SongManagementScreen> createState() => _SongManagementScreenState();
}

class _SongManagementScreenState extends State<SongManagementScreen> {
  late SongProvider songProvider;
  List<SongList> songList = [];
  int myIndex = 0;
  late DBMenuProviderCoach menuProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      songProvider = Provider.of<SongProvider>(context, listen: false);
      menuProvider = Provider.of<DBMenuProviderCoach>(context, listen: false);
      menuProvider.addListener(_listenerCallback);
      getSongList();
    });
  }

  void _listenerCallback() {
    if (menuProvider.isReload) {
      if (menuProvider.selectedIndex == myIndex) {
        menuProvider.resetReload();
        getSongList();
      }
    }
  }

  Future<void> getSongList() async {
    AppUtils.showLoaderDialog(context, true);

    List<Future<Map<String, dynamic>>> requests = [];
    for (int level = 1; level <= 3; level++) {
      requests.add(songProvider.songListByLevel(
          context: context, level: level.toString()));
    }

    List<Map<String, dynamic>> responses = await Future.wait(requests);
    List<SongList> combinedSongList = [];

    for (var response in responses) {
      if (response["status"]) {
        SongListResponseByLevel songListResponse =
            SongListResponseByLevel.fromJson(response["data"]);
        if (songListResponse.code == 1) {
          combinedSongList.addAll(songListResponse.data ?? []);
        }
      }
    }

    AppUtils.showLoaderDialog(context, false);

    // Update state with the combined list
    setState(() {
      songList = combinedSongList;
    });
  }

// Import your ColorManager and styles if they're in a different file

  void showUploadDialog(BuildContext context) {
    String? selectedDifficulty;
    List<String> difficultyList = ["Easy", "Medium", "Hard"];

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController singerController = TextEditingController();
        TextEditingController difficultyController = TextEditingController();

        Uint8List? selectedSong;
        Uint8List? selectedImage;
        String? selectedSongFileName;

        return StatefulBuilder(
          builder: (context, setState) {
            // Function to pick the song file and update fields
            void pickSong() async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.audio);
              if (result != null && result.files.single.bytes != null) {
                setState(() {
                  selectedSong = result.files.single.bytes;
                  selectedSongFileName = result.files.single.name;

                  // Update the fields with placeholder metadata (you can customize this)
                  nameController.text = selectedSongFileName ?? "Unknown";
                  singerController.text = "Unknown"; // Example default
                  difficultyController.text = "1"; // Example default
                });
              }
            }

            // Function to pick the image file and update fields
            void pickImage() async {
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.image);
              if (result != null && result.files.single.bytes != null) {
                setState(() {
                  selectedImage = result.files.single.bytes;
                });
              }
            }

            return AlertDialog(
              backgroundColor:
                  ColorManager.colorSecondary, // Set dialog background color
              title: Text(
                "Upload Song",
                style: getBoldStyle(
                  fontSize: 18,
                  color: ColorManager.textColorWhite,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButtonWithIcon(
                      title: "Choose song file",
                      onClick: pickSong,
                      icon: Icons.file_upload,
                    ),
                    if (selectedSongFileName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Selected song: $selectedSongFileName",
                          style: getRegularStyle(
                              fontSize: 14,
                              color: ColorManager.textColorLightBlack),
                        ),
                      ),
                    SizedBox(height: 10),

                    CustomButtonWithIcon(
                      title: "Choose image file",
                      onClick: pickImage,
                      icon: Icons.image,
                    ),
                    if (selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            selectedImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(height: 10),

                    // Input fields for song metadata
                    CustomTextField(
                      controller: nameController,
                      hint: "Name",
                      hintStyle: getRegularStyle(
                          color: ColorManager.textColorWhite,
                          fontSize: FontSize.s16),
                      textStyle: getRegularStyle(
                          color: ColorManager.textColorWhite,
                          fontSize: FontSize.s16),
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: singerController,
                      hint: "Singer",
                      hintStyle: getRegularStyle(
                          color: ColorManager.textColorWhite,
                          fontSize: FontSize.s16),
                      textStyle: getRegularStyle(
                          color: ColorManager.textColorWhite,
                          fontSize: FontSize.s16),
                    ),
                    SizedBox(height: 10),
                    CustomDropdownField(
                      hint: "Difficulty Level",
                      hintStyle: getRegularStyle(
                          color: ColorManager.textColorWhite,
                          fontSize: FontSize.s16),
                      textStyle: getRegularStyle(
                          color: ColorManager.textColorWhite,
                          fontSize: FontSize.s16),
                      value: (selectedDifficulty ?? "").isEmpty
                          ? null
                          : selectedDifficulty,
                      items: difficultyList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(child: Text(value)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedDifficulty = value;
                      },
                    ),
                    // TextField(
                    //   controller: difficultyController,
                    //   decoration: InputDecoration(
                    //     labelText: "Difficulty Level",
                    //     labelStyle:
                    //         getRegularStyle(color: ColorManager.textColorWhite),
                    //     filled: true,
                    //     fillColor: ColorManager.colorPrimary,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //       borderSide:
                    //           BorderSide(color: ColorManager.colorAccent),
                    //     ),
                    //   ),
                    //   keyboardType: TextInputType.number,
                    //   style:
                    //       getRegularStyle(color: ColorManager.textColorWhite),
                    // ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: getRegularStyle(
                        fontSize: 14, color: ColorManager.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Show a loading indicator while uploading
                    AppUtils.showLoaderDialog(context, true);

                    // Call the upload function (make sure the upload function is async)
                    final result = await songProvider.uploadSong(
                      context: context,
                      musicData: selectedSong!,
                      imageData: selectedImage!,
                      difficultyLevel:
                          AppUtils.getDifficultyLevel(selectedDifficulty),
                      singer: singerController.text,
                      songName: nameController.text,
                    );

                    // Hide the loading indicator after upload
                    AppUtils.showLoaderDialog(context, false);

                    if (result['status'] == true) {
                      // If the upload is successful, refresh the song list
                      await getSongList(); // Fetch updated song list
                      Navigator.pop(context); // Close the upload dialog
                    } else {
                      // Handle the error case, show error message
                      AppUtils.showToast(result['error'] ?? 'Upload failed');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.colorAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Upload",
                    style: getRegularStyle(
                        fontSize: 14, color: ColorManager.textColorWhite),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Song Management", // Title for the screen
              style: getBoldStyle(
                fontSize: FontSize.s26,
                color: ColorManager.textColorWhite,
              ),
            ),
            SizedBox(height: 3.sp),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.sp),
                child: SizedBox(
                  width: 20.w,
                  child: CustomButton(
                    title: "+ Create Song",
                    onClick: () => showUploadDialog(context),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8), // Space between title and song list
            Expanded(
              child: ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.sp),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: ColorManager.colorAccent, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: ColorManager.colorSecondary,
                      // Item background
                      title: Row(
                        children: [
                          // Label indicating the level
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 4),
                            decoration: BoxDecoration(
                              color: ColorManager
                                  .darkGrey, // Choose a color for the label
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Lvl. ${songList[index].difficultyLevel}",
                              style: TextStyle(
                                color: ColorManager.white, // Label text color
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: 4), // Space between label and song title
                          // Song title
                          Expanded(
                            child: Text(
                              "${songList[index].name} - ${songList[index].singer}",
                              style: getBoldStyle(
                                  fontSize: 16,
                                  color: ColorManager.textColorWhite),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        "Uploaded on ${songList[index].createTime}",
                        style: getRegularStyle(
                            fontSize: 14, color: ColorManager.textColorWhite),
                      ),
                      trailing: ClipOval(
                        child: InkWell(
                          onTap: () {
                            // Edit song action
                          },
                          child: Icon(
                            Icons.edit,
                            color: ColorManager.textColorWhite, // Icon color
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
