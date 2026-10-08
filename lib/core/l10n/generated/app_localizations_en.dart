// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Daily Quest';

  @override
  String get tabToday => 'Today';

  @override
  String get tabStats => 'Stats';

  @override
  String get tabMe => 'Me';

  @override
  String greetingMorning(Object name) {
    return 'Good morning, $name';
  }

  @override
  String greetingAfternoon(Object name) {
    return 'Good afternoon, $name';
  }

  @override
  String greetingEvening(Object name) {
    return 'Good evening, $name';
  }

  @override
  String greetingNight(Object name) {
    return 'Still up, $name?';
  }

  @override
  String todayCompleted(int done, int total) {
    return '$done/$total done';
  }

  @override
  String streakDays(int count) {
    return '$count-day streak';
  }

  @override
  String get noTasksToday => 'Nothing scheduled today';

  @override
  String get noTasksHint => 'Tap \"Add task\" below to plan your day';

  @override
  String get addTask => 'Add task';

  @override
  String get done => 'Done';

  @override
  String get undo => 'Undo';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirm => 'OK';

  @override
  String get delete => 'Delete';

  @override
  String progressOf(String progress, String target, Object unit) {
    return '$progress / $target $unit';
  }

  @override
  String get setProgressTitle => 'Set progress';

  @override
  String setProgressHint(int target) {
    return '0 – $target';
  }

  @override
  String get dayCompleteToast => 'All done for today';

  @override
  String taskCompletedToast(Object name) {
    return '\"$name\" completed';
  }

  @override
  String get syncToTodayTitle => 'Apply to today?';

  @override
  String syncToTodayMessage(Object name) {
    return 'Today\'s \"$name\" already exists. Apply your changes to today as well?';
  }

  @override
  String get syncToTodayYes => 'Apply to today';

  @override
  String get syncToTodayNo => 'From tomorrow';

  @override
  String get statsTitle => 'Stats';

  @override
  String get thisWeek => 'This week';

  @override
  String get last12Weeks => 'Last 12 weeks';

  @override
  String get currentStreak => 'Current streak';

  @override
  String get longestStreak => 'Longest streak';

  @override
  String daysUnit(int count) {
    return '$count days';
  }

  @override
  String get perTask => 'By task';

  @override
  String taskTotal(Object amount, Object unit) {
    return '$amount $unit total';
  }

  @override
  String completionRate(int percent) {
    return '$percent% completed';
  }

  @override
  String get heatLess => 'Less';

  @override
  String get heatMore => 'More';

  @override
  String get noStatsYet => 'Stats appear after your first task';

  @override
  String get meTitle => 'Me';

  @override
  String get sectionProfile => 'Profile';

  @override
  String get nickname => 'Nickname';

  @override
  String get avatarChar => 'Avatar character';

  @override
  String get sectionAppearance => 'Appearance';

  @override
  String get colorScheme => 'Color scheme';

  @override
  String get customAccent => 'Custom accent';

  @override
  String get appearanceMode => 'Appearance';

  @override
  String get modeSystem => 'System';

  @override
  String get modeLight => 'Light';

  @override
  String get modeDark => 'Dark';

  @override
  String get sectionTasks => 'Tasks';

  @override
  String get manageTasks => 'Manage tasks';

  @override
  String get newTask => 'New task';

  @override
  String get sectionGeneral => 'General';

  @override
  String get dayStartHour => 'Day starts at';

  @override
  String get dayStartFooter =>
      'Check-ins before this time count toward the previous day.';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderTime => 'Reminder time';

  @override
  String reminderBody(int count) {
    return '$count tasks left today';
  }

  @override
  String get reminderBodyGeneric => 'Check today\'s tasks';

  @override
  String get reminderPermissionDenied => 'Notification permission denied';

  @override
  String get sectionData => 'Data';

  @override
  String get exportBackup => 'Export JSON backup';

  @override
  String get importBackup => 'Import JSON backup';

  @override
  String get resetData => 'Reset all data';

  @override
  String get resetConfirmTitle => 'Reset everything?';

  @override
  String get resetConfirmMessage =>
      'All tasks, history and settings will be deleted. This cannot be undone.';

  @override
  String get importConfirmTitle => 'Import backup?';

  @override
  String get importConfirmMessage => 'Importing replaces all current data.';

  @override
  String get importSuccess => 'Backup imported';

  @override
  String importFailed(Object error) {
    return 'Import failed: $error';
  }

  @override
  String get exportSuccess => 'Backup exported';

  @override
  String get resetDone => 'Reset complete';

  @override
  String get saved => 'Saved';

  @override
  String get themePreview => 'Theme preview';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get activeTasks => 'Active';

  @override
  String get pausedTasks => 'Paused';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get archive => 'Delete';

  @override
  String archiveConfirmTitle(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get archiveConfirmMessage =>
      'The task is archived; its history stays in your stats.';

  @override
  String get dragToReorder => 'Drag the handle to reorder';

  @override
  String get editTask => 'Edit task';

  @override
  String get templates => 'Templates';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldNameHint => 'e.g. Vocabulary';

  @override
  String get fieldIcon => 'Icon';

  @override
  String get fieldIconHint => 'Type a character or pick an icon';

  @override
  String get fieldColor => 'Color';

  @override
  String get fieldType => 'Type';

  @override
  String get typeCount => 'Count';

  @override
  String get typeOnce => 'Once';

  @override
  String get typeDuration => 'Duration';

  @override
  String get fieldTarget => 'Daily target';

  @override
  String get fieldStep => 'Per check-in';

  @override
  String get fieldUnit => 'Unit';

  @override
  String get fieldRepeat => 'Repeat';

  @override
  String get repeatDaily => 'Every day';

  @override
  String get repeatWeekdays => 'Weekdays';

  @override
  String get repeatCustom => 'Custom';

  @override
  String get weekdayShort1 => 'M';

  @override
  String get weekdayShort2 => 'T';

  @override
  String get weekdayShort3 => 'W';

  @override
  String get weekdayShort4 => 'T';

  @override
  String get weekdayShort5 => 'F';

  @override
  String get weekdayShort6 => 'S';

  @override
  String get weekdayShort7 => 'S';

  @override
  String get errorNameLength => 'Name must be 1–20 characters';

  @override
  String get errorTarget => 'Target must be at least 1';

  @override
  String get errorStep => 'Step must be between 1 and the target';

  @override
  String get errorRepeat => 'Pick at least one day';

  @override
  String get errorNumber => 'Enter a whole number';

  @override
  String get unitCount => 'pcs';

  @override
  String get unitTimes => 'times';

  @override
  String get unitMinutes => 'min';

  @override
  String get unitSets => 'sets';

  @override
  String get tplVocabulary => 'Vocabulary';

  @override
  String get tplExercises => 'Exercises';

  @override
  String get tplReading => 'Reading';

  @override
  String get tplWorkout => 'Workout';

  @override
  String get tplListening => 'Listening';

  @override
  String get seedVocabulary => 'Vocabulary';

  @override
  String get seedMath => 'Math exercises';

  @override
  String get seedReading => 'Reading';

  @override
  String get seedWorkout => 'Workout';

  @override
  String get defaultNickname => 'friend';

  @override
  String get widgetTitle => 'Today';
}
