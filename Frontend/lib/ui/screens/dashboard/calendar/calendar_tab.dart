import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/appointment/add_appointment_request.dart';
import 'package:skating_app/model/appointment/available_slots_response.dart';
import 'package:skating_app/model/login/login_response.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/appointment_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/popup_dialog/select_song_dialog.dart';
import 'package:skating_app/ui/screens/dashboard/home/practice/practice_tab.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  late AppointmentProvider appointmentProvider;
  List<SlotData> slotsList = [];
  String? selectedDate;
  List<int> durations = [10, 20, 30];
  Key _timePickerKey = UniqueKey();
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      appointmentProvider =
          Provider.of<AppointmentProvider>(context, listen: false);
      setCurrentDate();
      fetchAvailableSlots();
    });
  }

  setCurrentDate() {
    selectedDate =
        AppUtils.parseDate(DateTime.now().millisecondsSinceEpoch, "yyyy-MM-dd");

    setState(() {});
  }

  fetchAvailableSlots() {
    AppUtils.showLoaderDialog(context, true);

    print("selectedDate==${selectedDate}");

    appointmentProvider
        .getAvailableSlots(date: selectedDate ?? "", context: context)
        .then((response) async {
      AppUtils.showLoaderDialog(context, false);
      if (response["status"]) {
        AvailableSlotsResponse availableSlotsResponse =
            AvailableSlotsResponse.fromJson(response["data"]);
        if (availableSlotsResponse.code == 1) {
          slotsList = availableSlotsResponse.data ?? [];
          print("slot list length == ${slotsList.length}");
          setState(() {});
        }
      }
    });
  }

  bookAppointment(AddAppointmentRequest request) async {
    if (selectedDate == null) {
      AppUtils.showErrorToast("Please select date");
      return;
    }
    String uId =
        UserData.fromJson(await PreferenceManager.getUserData()).id ?? "";

    AppUtils.showLoaderDialog(context, true);

    appointmentProvider
        .bookAppointment(request: request, context: context)
        .then((response) async {
      AppUtils.showLoaderDialog(context, false);
      if (response["status"]) {
        if (response["data"]["code"] == 1) {
          AppUtils.showErrorToast("Appointment booked successfully");
          fetchAvailableSlots();
        } else {
          AppUtils.showErrorToast("${response["data"]["msg"]}");
        }
      }
    });
  }

/*   openSelectSongDialog() async {
    final Map<String, dynamic>? results = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SelectSongDialog();
        });

    // Update UI
    if (results != null) {
      selectedSong = results["songData"];
      setState(() {});
    }
  }
 */
  void openAppointmentDialog(SlotData slot) {
    final int slotDuration =
        slot.endTime.difference(slot.startTime).inMinutes; // Slot duration
    final List<int> durations = this
        .durations
        .where((duration) => duration <= slotDuration)
        .toList(); // Filter valid durations
    int selectedDuration = 10; // Default duration

    // Convert `TimeOfDay` or slot start/end times into `DateTime`
    DateTime slotStart = slot.startTime;
    DateTime slotEnd = slot.endTime;
    DateTime selectedStartTime = slotStart;

    SongListData? selectedSongList; // Store the selected song list

    // Function to update the selected time and handle constraints

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor:
                  ColorManager.colorSecondary, // Match project style
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              contentPadding: EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Slot Title
                    Text(
                      "Pick a time period from ${DateFormat.Hm().format(slot.startTime)} - ${DateFormat.Hm().format(slot.endTime)}",
                      style: getBoldStyle(
                        fontSize: FontSize.s18,
                        color: ColorManager.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Duration Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Select Duration:",
                          style: getBoldStyle(
                            fontSize: FontSize.s16,
                            color: ColorManager.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        DropdownButton<int>(
                          dropdownColor: ColorManager.colorAccent,
                          value: selectedDuration,
                          items: durations
                              .map((duration) => DropdownMenuItem<int>(
                                    value: duration,
                                    child: Text(
                                      "$duration mins",
                                      style: getMediumStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDuration = value!;
                              if (selectedStartTime
                                  .add(Duration(minutes: selectedDuration))
                                  .isAfter(slotEnd)) {
                                selectedStartTime = slotEnd.subtract(
                                    Duration(minutes: selectedDuration));
                                _timePickerKey = UniqueKey();
                              }
                              if (selectedSongList != null &&
                                  selectedDuration * 60 <
                                      selectedSongList!.songList!.fold(
                                          0,
                                          (sum, item) =>
                                              sum + item.duration!)) {
                                selectedSongList = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // Cupertino Time Picker
                    Text(
                      "Select Start Time:",
                      style: getBoldStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.white,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      height: 200.0,
                      child: CupertinoDatePicker(
                        key: _timePickerKey,
                        backgroundColor: ColorManager.colorLightRed,
                        mode: CupertinoDatePickerMode.time,
                        minuteInterval: 5,
                        initialDateTime: selectedStartTime ?? slotStart,
                        minimumDate: slotStart,
                        maximumDate: slotEnd
                            .subtract(Duration(minutes: selectedDuration)),
                        use24hFormat: true, // Use 24-hour format if needed
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() {
                            selectedStartTime = newTime;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    Text(
                      "${DateFormat.Hm().format(selectedStartTime)} to ${DateFormat.Hm().format(selectedStartTime.add(Duration(minutes: selectedDuration)))} selected",
                      style: getRegularStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.white,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    // Song List Selector
                    Text(
                      "Selected Song List:",
                      style: getBoldStyle(
                        fontSize: FontSize.s16,
                        color: ColorManager.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    selectedSongList != null
                        ? Text(
                            selectedSongList!.listName ?? "No list selected",
                            style: getMediumStyle(
                              fontSize: FontSize.s14,
                              color: ColorManager.white,
                            ),
                          )
                        : Text(
                            "No list selected",
                            style: getMediumStyle(
                              fontSize: FontSize.s14,
                              color: ColorManager.grey,
                            ),
                          ),
                    const SizedBox(height: 16.0),
                    CustomButton(
                      title: "Select Song List",
                      onClick: () async {
                        final result = await openSelectSongListDialog(
                            selectedDuration * 60);
                        if (result != null) {
                          setState(() {
                            selectedSongList = result;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Confirm Button
                    Align(
                      alignment: Alignment.center,
                      child: CustomButton(
                        title: "Confirm",
                        onClick: () async {
                          if (selectedSongList == null) {
                            AppUtils.showErrorToast(
                                "Please select a song list");
                            return;
                          }

                          // Process the selected time and duration
                          bookAppointment(
                            AddAppointmentRequest.fromJson({
                              'date': selectedDate,
                              'startTime':
                                  (selectedStartTime.millisecondsSinceEpoch),
                              'endTime': ((selectedStartTime
                                  .add(Duration(minutes: selectedDuration))
                                  .millisecondsSinceEpoch)),
                              'userId': UserData.fromJson(
                                          await PreferenceManager.getUserData())
                                      .id ??
                                  "",
                              'songlistId':
                                  selectedSongList!.songlistId.toString(),
                            }),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<SongListData?> openSelectSongListDialog(int timeLimit) async {
    final Map<String, dynamic>? results = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Dialog(
                  insetPadding: EdgeInsets.all(2.sp),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.sp),
                  ),
                  elevation: 10,
                  backgroundColor: ColorManager.colorPrimary,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Select or create a list",
                                style: getBoldStyle(
                                  fontSize: FontSize.s20,
                                  color: ColorManager.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.sp),
                              child: InkWell(
                                child: Icon(
                                  Icons.close,
                                  size: 8.sp,
                                  color: ColorManager.white,
                                ),
                                onTap: () {
                                  Navigator.pop(context, null);
                                },
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: PracticeTab(
                            onSongClick: (songList) {},
                            timeLimit: timeLimit,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          );
        });
    return results?["songListData"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              Wrap(
                children: [
                  _buildSingleDatePickerWithValue(),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Selected Date: ',
                      style: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _getValueText(
                        config.calendarType,
                        _singleDatePickerValueWithDefaultValue,
                      ),
                      style: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40.w,
                height: 50.h,
                margin: EdgeInsets.only(top: 5.sp),
                child: ListView.builder(
                  itemCount: slotsList.length,
                  itemBuilder: (context, index) {
                    final slot = slotsList[index];
                    return GestureDetector(
                      onTap: () {
                        if (slot.available &&
                            slot.endTime.difference(slot.startTime).inMinutes >=
                                durations.first) {
                          openAppointmentDialog(slot);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: slot.available
                              ? ColorManager.white
                              : ColorManager.colorGrey,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Colors.black12,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${DateFormat.Hm().format(slot.startTime)} - ${DateFormat.Hm().format(slot.endTime)}",
                              style: TextStyle(
                                color: slot.available
                                    ? ColorManager.black
                                    : ColorManager.colorDarkGrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (!slot.available)
                              Text("Booked",
                                  style: getBoldStyle(
                                      color: ColorManager.darkGrey))
                            else if (slot.endTime
                                    .difference(slot.startTime)
                                    .inMinutes <
                                durations.first)
                              Text("Too short",
                                  style: getBoldStyle(
                                      color: ColorManager.darkGrey))
                            else
                              Text(
                                "Available",
                                style: getBoldStyle(
                                  color: ColorManager.white,
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final config = CalendarDatePicker2Config(
    selectedDayHighlightColor: Colors.amber[900],
    weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    firstDayOfWeek: 1,
    controlsHeight: 50,
    dayMaxWidth: 40,
    animateToDisplayedMonthDate: true,
    controlsTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    dayTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    disabledDayTextStyle: const TextStyle(
      color: Colors.grey,
    ),
    monthTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    yearTextStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    centerAlignModePicker: true,
    useAbbrLabelForMonthModePicker: true,
    modePickersGap: 0,
    modePickerTextHandler: ({required monthDate, isMonthPicker}) {
      if (isMonthPicker ?? false) {
        // Custom month picker text
        return '${getLocaleShortMonthFormat(const Locale('en')).format(monthDate)}';
      }

      return null;
    },
    firstDate: DateTime(DateTime.now().year, DateTime.now().month),
    lastDate: DateTime(DateTime.now().year + 1),
    selectableDayPredicate: (day) =>
        !day
            .difference(DateTime.now().subtract(const Duration(days: 1)))
            .isNegative &&
        day.isBefore(DateTime.now().add(const Duration(days: 30))),
  );

  Widget _buildSingleDatePickerWithValue() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        SizedBox(
          width: 35.w,
          child: CalendarDatePicker2(
            displayedMonthDate: _singleDatePickerValueWithDefaultValue.first,
            config: config,
            value: _singleDatePickerValueWithDefaultValue,
            onValueChanged: (dates) {
              _singleDatePickerValueWithDefaultValue = dates;
              selectedDate = AppUtils.parseDate(
                  dates[0].millisecondsSinceEpoch, "yyyy-MM-dd");
              print("change selectedDate == ${selectedDate}");
              setState(() {});
              fetchAvailableSlots();
            },
          ),
        ),
        // const SizedBox(height: 10),
        // Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Text(
        //       'Selection(s):  ',
        //       style: getMediumStyle(
        //         color: Colors.white,
        //         fontSize: FontSize.s16,
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     Text(
        //       _getValueText(
        //         config.calendarType,
        //         _singleDatePickerValueWithDefaultValue,
        //       ),
        //       style: getMediumStyle(
        //         color: Colors.white,
        //         fontSize: FontSize.s16,
        //       ),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 25),
      ],
    );
  }

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 0)),
  ];

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}
