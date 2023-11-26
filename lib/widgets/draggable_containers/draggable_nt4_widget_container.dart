import 'package:dot_cast/dot_cast.dart';
import 'package:elastic_dashboard/widgets/dialog_widgets/dialog_dropdown_chooser.dart';
import 'package:elastic_dashboard/widgets/draggable_containers/draggable_widget_container.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/accelerometer.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/camera_stream.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/command_scheduler.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/command_widget.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/differential_drive.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/encoder_widget.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/field_widget.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/fms_info.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/gyro.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/motor_controller.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/network_alerts.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/pid_controller.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/power_distribution.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/combo_box_chooser.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/robot_preferences.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/split_button_chooser.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/subsystem_widget.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/swerve_drive.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/multi-topic/three_axis_accelerometer.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/single_topic/match_time.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/single_topic/multi_color_view.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/single_topic/number_bar.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/single_topic/single_color_view.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/single_topic/text_display.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/single_topic/toggle_button.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/single_topic/toggle_switch.dart';
import 'package:elastic_dashboard/widgets/nt4_widgets/single_topic/voltage_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../dialog_widgets/dialog_text_input.dart';
import '../nt4_widgets/single_topic/boolean_box.dart';
import '../nt4_widgets/single_topic/graph.dart';
import '../nt4_widgets/nt4_widget.dart';
import '../nt4_widgets/single_topic/number_slider.dart';

class DraggableNT4WidgetContainer extends DraggableWidgetContainer {
  NT4Widget? child;

  DraggableNT4WidgetContainer({
    super.key,
    required super.dashboardGrid,
    required super.title,
    required super.initialPosition,
    required this.child,
    super.enabled = false,
    super.minWidth,
    super.minHeight,
    super.onUpdate,
    super.onDragBegin,
    super.onDragEnd,
    super.onDragCancel,
    super.onResizeBegin,
    super.onResizeEnd,
  }) : super();

  DraggableNT4WidgetContainer.fromJson({
    super.key,
    required super.dashboardGrid,
    required super.jsonData,
    super.enabled = false,
    super.onUpdate,
    super.onDragBegin,
    super.onDragEnd,
    super.onDragCancel,
    super.onResizeBegin,
    super.onResizeEnd,
    super.onJsonLoadingWarning,
  }) : super.fromJson();

  static double getMinimumWidth(NT4Widget? widget) {
    double normalSize = 128.0;

    switch (widget?.type) {
      case 'Gyro':
        return normalSize * 2;
      case 'Encoder':
        return normalSize * 2;
      case 'Camera Stream':
        return normalSize * 2;
      case 'Field':
        return normalSize * 3;
      case 'PowerDistribution':
        return normalSize * 3;
      case 'PIDController':
        return normalSize * 2;
      case 'DifferentialDrive':
        return normalSize * 2;
      case 'SwerveDrive':
        return normalSize * 2;
      case 'Subsystem':
        return normalSize * 2;
      case 'Command':
        return normalSize * 2;
      case 'Scheduler':
        return normalSize * 2;
      case 'FMSInfo':
        return normalSize * 3;
      case 'RobotPreferences':
        return normalSize * 2;
      case 'Alerts':
        return normalSize * 2;
    }

    return normalSize;
  }

  static double getMinimumHeight(NT4Widget? widget) {
    double normalSize = 128.0;

    switch (widget?.type) {
      case 'Gyro':
        return normalSize * 2;
      case 'Camera Stream':
        return normalSize * 2;
      case 'Field':
        return normalSize * 2;
      case 'PowerDistribution':
        return normalSize * 4;
      case 'PIDController':
        return normalSize * 3;
      case 'DifferentialDrive':
        return normalSize * 2;
      case 'SwerveDrive':
        return normalSize * 2;
      case 'Scheduler':
        return normalSize * 2;
      case 'RobotPreferences':
        return normalSize * 2;
      case 'Alerts':
        return normalSize * 2;
    }

    return normalSize;
  }

  @override
  void init() {
    super.init();

    minWidth = DraggableNT4WidgetContainer.getMinimumWidth(child);
    minHeight = DraggableNT4WidgetContainer.getMinimumHeight(child);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': child?.type,
      'properties': getChildJson(),
    };
  }

  @override
  void fromJson(Map<String, dynamic> jsonData,
      {Function(String errorMessage)? onJsonLoadingWarning}) {
    super.fromJson(jsonData, onJsonLoadingWarning: onJsonLoadingWarning);

    child = createChildFromJson(jsonData,
        onJsonLoadingWarning: onJsonLoadingWarning);
  }

  void refreshChild() {
    child?.refresh();
  }

  @override
  void dispose({bool deleting = false}) {
    super.dispose(deleting: deleting);

    child?.dispose(deleting: deleting);
  }

  @override
  void unSubscribe() {
    super.unSubscribe();

    child?.unSubscribe();
  }

  NT4Widget createChildFromJson(Map<String, dynamic> jsonData,
      {Function(String warningMessage)? onJsonLoadingWarning}) {
    if (!jsonData.containsKey('type')) {
      onJsonLoadingWarning?.call(
          'NetworkTables widget does not specify a widget type, defaulting to text display widget');
    }

    Map<String, dynamic> widgetProperties = {};

    if (jsonData.containsKey('properties')) {
      widgetProperties = tryCast(jsonData['properties']) ?? {};
    } else {
      onJsonLoadingWarning?.call(
          'Network tables widget does not have any properties, defaulting to an empty properties map.');
    }

    String type = tryCast(jsonData['type']) ?? '';
    switch (type) {
      case 'Boolean Box':
        return BooleanBox.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Toggle Switch':
        return ToggleSwitch.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Toggle Button':
        return ToggleButton.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Graph':
        return GraphWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Match Time':
        return MatchTimeWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Single Color View':
        return SingleColorView.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Multi Color View':
        return MultiColorView.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Number Bar':
        return NumberBar.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Number Slider':
        return NumberSlider.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Voltage View':
        return VoltageView.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Text Display':
      case 'Text View':
        return TextDisplay.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Gyro':
        return Gyro.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case '3-Axis Accelerometer':
      case '3AxisAccelerometer':
        return ThreeAxisAccelerometer.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Encoder':
      case 'Quadrature Encoder':
        return EncoderWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Accelerometer':
        return AccelerometerWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Motor Controller':
      case 'Nidec Brushless':
        if (type == 'Nidec Brushless') {
          onJsonLoadingWarning
              ?.call('Easter egg found: Nidec Brushless widget!');
        }
        return MotorController.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Field':
        return FieldWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'PowerDistribution':
      case 'PDP':
        return PowerDistribution.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'PIDController':
      case 'PID Controller':
        return PIDControllerWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'DifferentialDrive':
      case 'Differential Drivebase':
        return DifferentialDrive.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'SwerveDrive':
        return SwerveDriveWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'ComboBox Chooser':
        return ComboBoxChooser.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Split Button Chooser':
        return SplitButtonChooser.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Subsystem':
        return SubsystemWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Command':
        return CommandWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Scheduler':
        return CommandSchedulerWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'FMSInfo':
        return FMSInfo.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Camera Stream':
        return CameraStreamWidget.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'RobotPreferences':
        return RobotPreferences.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      case 'Alerts':
        return NetworkAlerts.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
      default:
        if (jsonData['type'] != null) {
          onJsonLoadingWarning?.call(
              'Unknown widget type: \'${jsonData['type']}\', defaulting to Text Display widget.');
        }
        return TextDisplay.fromJson(
          key: UniqueKey(),
          jsonData: widgetProperties,
        );
    }
  }

  Map<String, dynamic>? getChildJson() {
    return child!.toJson();
  }

  void changeChildToType(String? type) {
    if (type == null) {
      return;
    }

    if (type == child!.type) {
      return;
    }

    NT4Widget? newWidget;

    switch (type) {
      case 'Boolean Box':
        newWidget = BooleanBox(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Toggle Switch':
        newWidget = ToggleSwitch(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Toggle Button':
        newWidget = ToggleButton(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Graph':
        newWidget = GraphWidget(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Number Bar':
        newWidget = NumberBar(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Number Slider':
        newWidget = NumberSlider(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Voltage View':
        newWidget = VoltageView(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Text Display':
        newWidget = TextDisplay(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Match Time':
        newWidget = MatchTimeWidget(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Single Color View':
        newWidget = SingleColorView(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'Multi Color View':
        newWidget = MultiColorView(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
        break;
      case 'ComboBox Chooser':
        newWidget = ComboBoxChooser(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
      case 'Split Button Chooser':
        newWidget = SplitButtonChooser(
            key: UniqueKey(), topic: child!.topic, period: child!.period);
    }

    if (newWidget == null) {
      return;
    }

    child!.dispose(deleting: true);
    child!.unSubscribe();
    child = newWidget;

    minWidth = DraggableNT4WidgetContainer.getMinimumWidth(child);
    minHeight = DraggableNT4WidgetContainer.getMinimumHeight(child);

    refresh();
  }

  @override
  void showEditProperties(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Properties'),
          content: SizedBox(
            width: 353,
            child: SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, setState) {
                  List<Widget>? childProperties =
                      child?.getEditProperties(context);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...getContainerEditProperties(),
                      const SizedBox(height: 5),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: Text('Widget Type')),
                          DialogDropdownChooser<String>(
                            choices: child!.getAvailableDisplayTypes(),
                            initialValue: child!.type,
                            onSelectionChanged: (String? value) {
                              setState(() {
                                changeChildToType(value);
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      // Settings for the widget inside (only if there are properties)
                      if (childProperties != null &&
                          childProperties.isNotEmpty) ...[
                        Text('${child?.type} Widget Settings'),
                        const SizedBox(height: 5),
                        ...childProperties,
                        const Divider(),
                      ],
                      // Settings for the NT4 Connection
                      ...getNT4EditProperties(),
                    ],
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                child?.refresh();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> getNT4EditProperties() {
    return [
      const Text('Network Tables Settings (Advanced)'),
      const SizedBox(height: 5),
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Topic
          Flexible(
            child: DialogTextInput(
              onSubmit: (value) {
                child?.topic = value;
                child?.resetSubscription();
              },
              label: 'Topic',
              initialText: child?.topic,
            ),
          ),
          const SizedBox(width: 5),
          // Period
          Flexible(
            child: DialogTextInput(
              onSubmit: (value) {
                double? newPeriod = double.tryParse(value);
                if (newPeriod == null) {
                  return;
                }

                child!.period = newPeriod;
                child!.resetSubscription();
              },
              formatter: FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              label: 'Period',
              initialText: child!.period.toString(),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  WidgetContainer getDraggingWidgetContainer(BuildContext context) {
    return WidgetContainer(
      title: title,
      width: draggablePositionRect.width,
      height: draggablePositionRect.height,
      opacity: 0.80,
      child: ChangeNotifierProvider(
        create: (context) => NT4WidgetNotifier(),
        child: child,
      ),
    );
  }

  @override
  WidgetContainer getWidgetContainer(BuildContext context) {
    return WidgetContainer(
      title: title,
      width: displayRect.width,
      height: displayRect.height,
      opacity: (previewVisible) ? 0.25 : 1.00,
      child: Opacity(
        opacity: (enabled) ? 1.00 : 0.50,
        child: AbsorbPointer(
          absorbing: !enabled,
          child: ChangeNotifierProvider(
            create: (context) => NT4WidgetNotifier(),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        Positioned(
          left: displayRect.left,
          top: displayRect.top,
          child: getWidgetContainer(context),
        ),
        ...super.getStackChildren(model!),
      ],
    );
  }
}
