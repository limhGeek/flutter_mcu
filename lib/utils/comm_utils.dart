import 'package:flutter_mcu/utils/date_utils.dart';

class CommUtil{
  static String getTimeDiff(int time){
    int current = DateTime.now().millisecondsSinceEpoch - time;
    double tmp = current / 1000 / 60;
    if (tmp < 1) {
      return "${(tmp * 60).toInt()}秒前";
    } else if (tmp < 60) {
      return "${tmp.toInt()}分钟前";
    } else if (tmp < 720) {
      return "${tmp ~/ 60}小时前";
    } else {
      if (DateUtil.getDateStrByMs(DateTime.now().millisecondsSinceEpoch,
          format: DateFormat.YEAR_MONTH_DAY) ==
          DateUtil.getDateStrByMs(time, format: DateFormat.YEAR_MONTH_DAY)) {
        return DateUtil.getDateStrByMs(time,format: DateFormat.HOUR_MINUTE);
      }else{
        return DateUtil.getDateStrByMs(time,format: DateFormat.YEAR_MONTH_DAY);
      }
    }
  }

  static String getMsTime(int time){
    if (DateUtil.getDateStrByMs(DateTime.now().millisecondsSinceEpoch,
        format: DateFormat.YEAR_MONTH_DAY) ==
        DateUtil.getDateStrByMs(time, format: DateFormat.YEAR_MONTH_DAY)) {
      return DateUtil.getDateStrByMs(time,format: DateFormat.HOUR_MINUTE);
    }else{
      return DateUtil.getDateStrByMs(time,format: DateFormat.ZH_MONTH_DAY);
    }
  }
  static const RollupSize_Units = ["GB", "MB", "KB", "B"];
  /// 返回文件大小字符串
  static String getImageSize(int size) {
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10)
            result = "$s1.$r1${RollupSize_Units[idx]}";
          else
            result = "$s1.0$r1${RollupSize_Units[idx]}";
        } else
          result = s1.toString() + RollupSize_Units[idx];
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }
}