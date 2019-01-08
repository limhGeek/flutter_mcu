import 'dart:async';

var a = 1;
var b = a;

main() {
  String str1 = "laifnsafn阿里上你说的nfsanf123d";
  RegExp regExp = RegExp("^\w+\$");
  Iterable<Match> math=regExp.allMatches(str1);
  math.forEach((tmp){
    print(tmp.group(0));
  });

}

Future periodic() async {

}
