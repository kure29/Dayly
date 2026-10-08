// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '每日任务';

  @override
  String get tabToday => '今日';

  @override
  String get tabStats => '统计';

  @override
  String get tabMe => '我的';

  @override
  String greetingMorning(Object name) {
    return '早上好，$name';
  }

  @override
  String greetingAfternoon(Object name) {
    return '下午好，$name';
  }

  @override
  String greetingEvening(Object name) {
    return '晚上好，$name';
  }

  @override
  String greetingNight(Object name) {
    return '夜深了，$name';
  }

  @override
  String todayCompleted(int done, int total) {
    return '已完成 $done/$total';
  }

  @override
  String streakDays(int count) {
    return '连续 $count 天';
  }

  @override
  String get noTasksToday => '今天没有安排任务';

  @override
  String get noTasksHint => '点击下方「添加任务」开始规划吧';

  @override
  String get addTask => '添加任务';

  @override
  String get done => '完成';

  @override
  String get undo => '撤销';

  @override
  String get edit => '编辑';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get confirm => '确定';

  @override
  String get delete => '删除';

  @override
  String progressOf(String progress, String target, Object unit) {
    return '$progress / $target $unit';
  }

  @override
  String get setProgressTitle => '输入进度';

  @override
  String setProgressHint(int target) {
    return '0 – $target';
  }

  @override
  String get dayCompleteToast => '今日任务全部完成';

  @override
  String taskCompletedToast(Object name) {
    return '「$name」已完成';
  }

  @override
  String get syncToTodayTitle => '同步到今天？';

  @override
  String syncToTodayMessage(Object name) {
    return '今天的「$name」已经生成。是否把修改同步到今天的任务？';
  }

  @override
  String get syncToTodayYes => '同步到今天';

  @override
  String get syncToTodayNo => '仅从明天起';

  @override
  String get statsTitle => '统计';

  @override
  String get thisWeek => '本周';

  @override
  String get last12Weeks => '最近 12 周';

  @override
  String get currentStreak => '当前连续';

  @override
  String get longestStreak => '最长连续';

  @override
  String daysUnit(int count) {
    return '$count 天';
  }

  @override
  String get perTask => '各项任务';

  @override
  String taskTotal(Object amount, Object unit) {
    return '累计 $amount $unit';
  }

  @override
  String completionRate(int percent) {
    return '完成率 $percent%';
  }

  @override
  String get heatLess => '少';

  @override
  String get heatMore => '多';

  @override
  String get noStatsYet => '完成第一个任务后这里会显示统计';

  @override
  String get meTitle => '我的';

  @override
  String get sectionProfile => '个人';

  @override
  String get nickname => '昵称';

  @override
  String get avatarChar => '头像字符';

  @override
  String get sectionAppearance => '外观';

  @override
  String get colorScheme => '配色方案';

  @override
  String get customAccent => '自定义主题色';

  @override
  String get appearanceMode => '深浅色';

  @override
  String get modeSystem => '跟随系统';

  @override
  String get modeLight => '浅色';

  @override
  String get modeDark => '深色';

  @override
  String get sectionTasks => '任务管理';

  @override
  String get manageTasks => '管理任务';

  @override
  String get newTask => '新建任务';

  @override
  String get sectionGeneral => '通用';

  @override
  String get dayStartHour => '一天开始时间';

  @override
  String get dayStartFooter => '在此时间之前打卡仍算作前一天。';

  @override
  String get reminder => '提醒通知';

  @override
  String get reminderTime => '提醒时间';

  @override
  String reminderBody(int count) {
    return '还有 $count 项任务未完成';
  }

  @override
  String get reminderBodyGeneric => '看看今天的任务吧';

  @override
  String get reminderPermissionDenied => '未获得通知权限';

  @override
  String get sectionData => '数据';

  @override
  String get exportBackup => '导出 JSON 备份';

  @override
  String get importBackup => '导入 JSON 备份';

  @override
  String get resetData => '重置所有数据';

  @override
  String get resetConfirmTitle => '确定重置？';

  @override
  String get resetConfirmMessage => '所有任务、记录和设置都会被删除，且无法恢复。';

  @override
  String get importConfirmTitle => '导入备份？';

  @override
  String get importConfirmMessage => '导入会覆盖当前所有数据。';

  @override
  String get importSuccess => '导入成功';

  @override
  String importFailed(Object error) {
    return '导入失败：$error';
  }

  @override
  String get exportSuccess => '备份已导出';

  @override
  String get resetDone => '已重置';

  @override
  String get saved => '已保存';

  @override
  String get themePreview => '主题预览';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get activeTasks => '进行中';

  @override
  String get pausedTasks => '已暂停';

  @override
  String get pause => '暂停';

  @override
  String get resume => '恢复';

  @override
  String get archive => '删除';

  @override
  String archiveConfirmTitle(Object name) {
    return '删除「$name」？';
  }

  @override
  String get archiveConfirmMessage => '任务会被归档，历史记录仍保留在统计中。';

  @override
  String get dragToReorder => '按住右侧拖动可排序';

  @override
  String get editTask => '编辑任务';

  @override
  String get templates => '快速模板';

  @override
  String get fieldName => '名称';

  @override
  String get fieldNameHint => '例如：背单词';

  @override
  String get fieldIcon => '图标';

  @override
  String get fieldIconHint => '输入一个字符或选择图标';

  @override
  String get fieldColor => '颜色';

  @override
  String get fieldType => '类型';

  @override
  String get typeCount => '计数';

  @override
  String get typeOnce => '一次性';

  @override
  String get typeDuration => '时长';

  @override
  String get fieldTarget => '每日目标';

  @override
  String get fieldStep => '每次打卡';

  @override
  String get fieldUnit => '单位';

  @override
  String get fieldRepeat => '重复';

  @override
  String get repeatDaily => '每天';

  @override
  String get repeatWeekdays => '工作日';

  @override
  String get repeatCustom => '自选';

  @override
  String get weekdayShort1 => '一';

  @override
  String get weekdayShort2 => '二';

  @override
  String get weekdayShort3 => '三';

  @override
  String get weekdayShort4 => '四';

  @override
  String get weekdayShort5 => '五';

  @override
  String get weekdayShort6 => '六';

  @override
  String get weekdayShort7 => '日';

  @override
  String get errorNameLength => '名称需为 1–20 个字';

  @override
  String get errorTarget => '目标至少为 1';

  @override
  String get errorStep => '每次打卡需在 1 与目标之间';

  @override
  String get errorRepeat => '至少选择一天';

  @override
  String get errorNumber => '请输入整数';

  @override
  String get unitCount => '个';

  @override
  String get unitTimes => '次';

  @override
  String get unitMinutes => '分钟';

  @override
  String get unitSets => '套';

  @override
  String get tplVocabulary => '背单词';

  @override
  String get tplExercises => '练习题';

  @override
  String get tplReading => '阅读';

  @override
  String get tplWorkout => '运动';

  @override
  String get tplListening => '听力';

  @override
  String get seedVocabulary => '背单词';

  @override
  String get seedMath => '数学练习题';

  @override
  String get seedReading => '阅读';

  @override
  String get seedWorkout => '运动';

  @override
  String get defaultNickname => '同学';

  @override
  String get widgetTitle => '今日任务';
}
