import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'每日任务'**
  String get appTitle;

  /// No description provided for @tabToday.
  ///
  /// In zh, this message translates to:
  /// **'今日'**
  String get tabToday;

  /// No description provided for @tabStats.
  ///
  /// In zh, this message translates to:
  /// **'统计'**
  String get tabStats;

  /// No description provided for @tabMe.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get tabMe;

  /// No description provided for @greetingMorning.
  ///
  /// In zh, this message translates to:
  /// **'早上好，{name}'**
  String greetingMorning(Object name);

  /// No description provided for @greetingAfternoon.
  ///
  /// In zh, this message translates to:
  /// **'下午好，{name}'**
  String greetingAfternoon(Object name);

  /// No description provided for @greetingEvening.
  ///
  /// In zh, this message translates to:
  /// **'晚上好，{name}'**
  String greetingEvening(Object name);

  /// No description provided for @greetingNight.
  ///
  /// In zh, this message translates to:
  /// **'夜深了，{name}'**
  String greetingNight(Object name);

  /// No description provided for @todayCompleted.
  ///
  /// In zh, this message translates to:
  /// **'已完成 {done}/{total}'**
  String todayCompleted(int done, int total);

  /// No description provided for @streakDays.
  ///
  /// In zh, this message translates to:
  /// **'连续 {count} 天'**
  String streakDays(int count);

  /// No description provided for @noTasksToday.
  ///
  /// In zh, this message translates to:
  /// **'今天没有安排任务'**
  String get noTasksToday;

  /// No description provided for @noTasksHint.
  ///
  /// In zh, this message translates to:
  /// **'点击下方「添加任务」开始规划吧'**
  String get noTasksHint;

  /// No description provided for @addTask.
  ///
  /// In zh, this message translates to:
  /// **'添加任务'**
  String get addTask;

  /// No description provided for @done.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get done;

  /// No description provided for @undo.
  ///
  /// In zh, this message translates to:
  /// **'撤销'**
  String get undo;

  /// No description provided for @edit.
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @progressOf.
  ///
  /// In zh, this message translates to:
  /// **'{progress} / {target} {unit}'**
  String progressOf(String progress, String target, Object unit);

  /// No description provided for @setProgressTitle.
  ///
  /// In zh, this message translates to:
  /// **'输入进度'**
  String get setProgressTitle;

  /// No description provided for @setProgressHint.
  ///
  /// In zh, this message translates to:
  /// **'0 – {target}'**
  String setProgressHint(int target);

  /// No description provided for @dayCompleteToast.
  ///
  /// In zh, this message translates to:
  /// **'今日任务全部完成'**
  String get dayCompleteToast;

  /// No description provided for @taskCompletedToast.
  ///
  /// In zh, this message translates to:
  /// **'「{name}」已完成'**
  String taskCompletedToast(Object name);

  /// No description provided for @syncToTodayTitle.
  ///
  /// In zh, this message translates to:
  /// **'同步到今天？'**
  String get syncToTodayTitle;

  /// No description provided for @syncToTodayMessage.
  ///
  /// In zh, this message translates to:
  /// **'今天的「{name}」已经生成。是否把修改同步到今天的任务？'**
  String syncToTodayMessage(Object name);

  /// No description provided for @syncToTodayYes.
  ///
  /// In zh, this message translates to:
  /// **'同步到今天'**
  String get syncToTodayYes;

  /// No description provided for @syncToTodayNo.
  ///
  /// In zh, this message translates to:
  /// **'仅从明天起'**
  String get syncToTodayNo;

  /// No description provided for @statsTitle.
  ///
  /// In zh, this message translates to:
  /// **'统计'**
  String get statsTitle;

  /// No description provided for @thisWeek.
  ///
  /// In zh, this message translates to:
  /// **'本周'**
  String get thisWeek;

  /// No description provided for @last12Weeks.
  ///
  /// In zh, this message translates to:
  /// **'最近 12 周'**
  String get last12Weeks;

  /// No description provided for @currentStreak.
  ///
  /// In zh, this message translates to:
  /// **'当前连续'**
  String get currentStreak;

  /// No description provided for @longestStreak.
  ///
  /// In zh, this message translates to:
  /// **'最长连续'**
  String get longestStreak;

  /// No description provided for @daysUnit.
  ///
  /// In zh, this message translates to:
  /// **'{count} 天'**
  String daysUnit(int count);

  /// No description provided for @perTask.
  ///
  /// In zh, this message translates to:
  /// **'各项任务'**
  String get perTask;

  /// No description provided for @taskTotal.
  ///
  /// In zh, this message translates to:
  /// **'累计 {amount} {unit}'**
  String taskTotal(Object amount, Object unit);

  /// No description provided for @completionRate.
  ///
  /// In zh, this message translates to:
  /// **'完成率 {percent}%'**
  String completionRate(int percent);

  /// No description provided for @heatLess.
  ///
  /// In zh, this message translates to:
  /// **'少'**
  String get heatLess;

  /// No description provided for @heatMore.
  ///
  /// In zh, this message translates to:
  /// **'多'**
  String get heatMore;

  /// No description provided for @noStatsYet.
  ///
  /// In zh, this message translates to:
  /// **'完成第一个任务后这里会显示统计'**
  String get noStatsYet;

  /// No description provided for @meTitle.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get meTitle;

  /// No description provided for @sectionProfile.
  ///
  /// In zh, this message translates to:
  /// **'个人'**
  String get sectionProfile;

  /// No description provided for @nickname.
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get nickname;

  /// No description provided for @avatarChar.
  ///
  /// In zh, this message translates to:
  /// **'头像字符'**
  String get avatarChar;

  /// No description provided for @sectionAppearance.
  ///
  /// In zh, this message translates to:
  /// **'外观'**
  String get sectionAppearance;

  /// No description provided for @colorScheme.
  ///
  /// In zh, this message translates to:
  /// **'配色方案'**
  String get colorScheme;

  /// No description provided for @customAccent.
  ///
  /// In zh, this message translates to:
  /// **'自定义主题色'**
  String get customAccent;

  /// No description provided for @appearanceMode.
  ///
  /// In zh, this message translates to:
  /// **'深浅色'**
  String get appearanceMode;

  /// No description provided for @modeSystem.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get modeSystem;

  /// No description provided for @modeLight.
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get modeLight;

  /// No description provided for @modeDark.
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get modeDark;

  /// No description provided for @sectionTasks.
  ///
  /// In zh, this message translates to:
  /// **'任务管理'**
  String get sectionTasks;

  /// No description provided for @manageTasks.
  ///
  /// In zh, this message translates to:
  /// **'管理任务'**
  String get manageTasks;

  /// No description provided for @newTask.
  ///
  /// In zh, this message translates to:
  /// **'新建任务'**
  String get newTask;

  /// No description provided for @sectionGeneral.
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get sectionGeneral;

  /// No description provided for @dayStartHour.
  ///
  /// In zh, this message translates to:
  /// **'一天开始时间'**
  String get dayStartHour;

  /// No description provided for @dayStartFooter.
  ///
  /// In zh, this message translates to:
  /// **'在此时间之前打卡仍算作前一天。'**
  String get dayStartFooter;

  /// No description provided for @reminder.
  ///
  /// In zh, this message translates to:
  /// **'提醒通知'**
  String get reminder;

  /// No description provided for @reminderTime.
  ///
  /// In zh, this message translates to:
  /// **'提醒时间'**
  String get reminderTime;

  /// No description provided for @reminderBody.
  ///
  /// In zh, this message translates to:
  /// **'还有 {count} 项任务未完成'**
  String reminderBody(int count);

  /// No description provided for @reminderBodyGeneric.
  ///
  /// In zh, this message translates to:
  /// **'看看今天的任务吧'**
  String get reminderBodyGeneric;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In zh, this message translates to:
  /// **'未获得通知权限'**
  String get reminderPermissionDenied;

  /// No description provided for @sectionData.
  ///
  /// In zh, this message translates to:
  /// **'数据'**
  String get sectionData;

  /// No description provided for @exportBackup.
  ///
  /// In zh, this message translates to:
  /// **'导出 JSON 备份'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In zh, this message translates to:
  /// **'导入 JSON 备份'**
  String get importBackup;

  /// No description provided for @resetData.
  ///
  /// In zh, this message translates to:
  /// **'重置所有数据'**
  String get resetData;

  /// No description provided for @resetConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'确定重置？'**
  String get resetConfirmTitle;

  /// No description provided for @resetConfirmMessage.
  ///
  /// In zh, this message translates to:
  /// **'所有任务、记录和设置都会被删除，且无法恢复。'**
  String get resetConfirmMessage;

  /// No description provided for @importConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'导入备份？'**
  String get importConfirmTitle;

  /// No description provided for @importConfirmMessage.
  ///
  /// In zh, this message translates to:
  /// **'导入会覆盖当前所有数据。'**
  String get importConfirmMessage;

  /// No description provided for @importSuccess.
  ///
  /// In zh, this message translates to:
  /// **'导入成功'**
  String get importSuccess;

  /// No description provided for @importFailed.
  ///
  /// In zh, this message translates to:
  /// **'导入失败：{error}'**
  String importFailed(Object error);

  /// No description provided for @exportSuccess.
  ///
  /// In zh, this message translates to:
  /// **'备份已导出'**
  String get exportSuccess;

  /// No description provided for @resetDone.
  ///
  /// In zh, this message translates to:
  /// **'已重置'**
  String get resetDone;

  /// No description provided for @saved.
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get saved;

  /// No description provided for @themePreview.
  ///
  /// In zh, this message translates to:
  /// **'主题预览'**
  String get themePreview;

  /// No description provided for @about.
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get about;

  /// No description provided for @version.
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get version;

  /// No description provided for @activeTasks.
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get activeTasks;

  /// No description provided for @pausedTasks.
  ///
  /// In zh, this message translates to:
  /// **'已暂停'**
  String get pausedTasks;

  /// No description provided for @pause.
  ///
  /// In zh, this message translates to:
  /// **'暂停'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In zh, this message translates to:
  /// **'恢复'**
  String get resume;

  /// No description provided for @archive.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get archive;

  /// No description provided for @archiveConfirmTitle.
  ///
  /// In zh, this message translates to:
  /// **'删除「{name}」？'**
  String archiveConfirmTitle(Object name);

  /// No description provided for @archiveConfirmMessage.
  ///
  /// In zh, this message translates to:
  /// **'任务会被归档，历史记录仍保留在统计中。'**
  String get archiveConfirmMessage;

  /// No description provided for @dragToReorder.
  ///
  /// In zh, this message translates to:
  /// **'按住右侧拖动可排序'**
  String get dragToReorder;

  /// No description provided for @editTask.
  ///
  /// In zh, this message translates to:
  /// **'编辑任务'**
  String get editTask;

  /// No description provided for @templates.
  ///
  /// In zh, this message translates to:
  /// **'快速模板'**
  String get templates;

  /// No description provided for @fieldName.
  ///
  /// In zh, this message translates to:
  /// **'名称'**
  String get fieldName;

  /// No description provided for @fieldNameHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：背单词'**
  String get fieldNameHint;

  /// No description provided for @fieldIcon.
  ///
  /// In zh, this message translates to:
  /// **'图标'**
  String get fieldIcon;

  /// No description provided for @fieldIconHint.
  ///
  /// In zh, this message translates to:
  /// **'输入一个字符或选择图标'**
  String get fieldIconHint;

  /// No description provided for @fieldColor.
  ///
  /// In zh, this message translates to:
  /// **'颜色'**
  String get fieldColor;

  /// No description provided for @fieldType.
  ///
  /// In zh, this message translates to:
  /// **'类型'**
  String get fieldType;

  /// No description provided for @typeCount.
  ///
  /// In zh, this message translates to:
  /// **'计数'**
  String get typeCount;

  /// No description provided for @typeOnce.
  ///
  /// In zh, this message translates to:
  /// **'一次性'**
  String get typeOnce;

  /// No description provided for @typeDuration.
  ///
  /// In zh, this message translates to:
  /// **'时长'**
  String get typeDuration;

  /// No description provided for @fieldTarget.
  ///
  /// In zh, this message translates to:
  /// **'每日目标'**
  String get fieldTarget;

  /// No description provided for @fieldStep.
  ///
  /// In zh, this message translates to:
  /// **'每次打卡'**
  String get fieldStep;

  /// No description provided for @fieldUnit.
  ///
  /// In zh, this message translates to:
  /// **'单位'**
  String get fieldUnit;

  /// No description provided for @fieldRepeat.
  ///
  /// In zh, this message translates to:
  /// **'重复'**
  String get fieldRepeat;

  /// No description provided for @repeatDaily.
  ///
  /// In zh, this message translates to:
  /// **'每天'**
  String get repeatDaily;

  /// No description provided for @repeatWeekdays.
  ///
  /// In zh, this message translates to:
  /// **'工作日'**
  String get repeatWeekdays;

  /// No description provided for @repeatCustom.
  ///
  /// In zh, this message translates to:
  /// **'自选'**
  String get repeatCustom;

  /// No description provided for @weekdayShort1.
  ///
  /// In zh, this message translates to:
  /// **'一'**
  String get weekdayShort1;

  /// No description provided for @weekdayShort2.
  ///
  /// In zh, this message translates to:
  /// **'二'**
  String get weekdayShort2;

  /// No description provided for @weekdayShort3.
  ///
  /// In zh, this message translates to:
  /// **'三'**
  String get weekdayShort3;

  /// No description provided for @weekdayShort4.
  ///
  /// In zh, this message translates to:
  /// **'四'**
  String get weekdayShort4;

  /// No description provided for @weekdayShort5.
  ///
  /// In zh, this message translates to:
  /// **'五'**
  String get weekdayShort5;

  /// No description provided for @weekdayShort6.
  ///
  /// In zh, this message translates to:
  /// **'六'**
  String get weekdayShort6;

  /// No description provided for @weekdayShort7.
  ///
  /// In zh, this message translates to:
  /// **'日'**
  String get weekdayShort7;

  /// No description provided for @errorNameLength.
  ///
  /// In zh, this message translates to:
  /// **'名称需为 1–20 个字'**
  String get errorNameLength;

  /// No description provided for @errorTarget.
  ///
  /// In zh, this message translates to:
  /// **'目标至少为 1'**
  String get errorTarget;

  /// No description provided for @errorStep.
  ///
  /// In zh, this message translates to:
  /// **'每次打卡需在 1 与目标之间'**
  String get errorStep;

  /// No description provided for @errorRepeat.
  ///
  /// In zh, this message translates to:
  /// **'至少选择一天'**
  String get errorRepeat;

  /// No description provided for @errorNumber.
  ///
  /// In zh, this message translates to:
  /// **'请输入整数'**
  String get errorNumber;

  /// No description provided for @unitCount.
  ///
  /// In zh, this message translates to:
  /// **'个'**
  String get unitCount;

  /// No description provided for @unitTimes.
  ///
  /// In zh, this message translates to:
  /// **'次'**
  String get unitTimes;

  /// No description provided for @unitMinutes.
  ///
  /// In zh, this message translates to:
  /// **'分钟'**
  String get unitMinutes;

  /// No description provided for @unitSets.
  ///
  /// In zh, this message translates to:
  /// **'套'**
  String get unitSets;

  /// No description provided for @tplVocabulary.
  ///
  /// In zh, this message translates to:
  /// **'背单词'**
  String get tplVocabulary;

  /// No description provided for @tplExercises.
  ///
  /// In zh, this message translates to:
  /// **'练习题'**
  String get tplExercises;

  /// No description provided for @tplReading.
  ///
  /// In zh, this message translates to:
  /// **'阅读'**
  String get tplReading;

  /// No description provided for @tplWorkout.
  ///
  /// In zh, this message translates to:
  /// **'运动'**
  String get tplWorkout;

  /// No description provided for @tplListening.
  ///
  /// In zh, this message translates to:
  /// **'听力'**
  String get tplListening;

  /// No description provided for @seedVocabulary.
  ///
  /// In zh, this message translates to:
  /// **'背单词'**
  String get seedVocabulary;

  /// No description provided for @seedMath.
  ///
  /// In zh, this message translates to:
  /// **'数学练习题'**
  String get seedMath;

  /// No description provided for @seedReading.
  ///
  /// In zh, this message translates to:
  /// **'阅读'**
  String get seedReading;

  /// No description provided for @seedWorkout.
  ///
  /// In zh, this message translates to:
  /// **'运动'**
  String get seedWorkout;

  /// No description provided for @defaultNickname.
  ///
  /// In zh, this message translates to:
  /// **'同学'**
  String get defaultNickname;

  /// No description provided for @widgetTitle.
  ///
  /// In zh, this message translates to:
  /// **'今日任务'**
  String get widgetTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
