import 'block.dart';

class Weekday {
  final String name;
  List<Block> blocks;
  Weekday(this.name, this.blocks);

  ///Shell-Sort-Algorithmus, um die Stunden zu sortieren
  void sort() {
    int interval;
    for (interval = 0;
        interval < blocks.length / 3;
        // ignore: empty_statements, curly_braces_in_flow_control_structures
        interval = interval * 3 + 1);

    while (interval > 0) {
      for (int outer = interval; outer < blocks.length; ++outer) {
        var valueToInsert = blocks[outer];
        int inner = outer;
        while (inner > interval - 1 &&
            blocks[inner - interval].startTime >= valueToInsert.startTime) {
          blocks[inner] = blocks[inner - interval];
          inner -= interval;
        }

        blocks[inner] = valueToInsert;
      }

      interval--;
      interval = interval ~/ 3;
    }

    blocks.forEach((element) {
      print(element.name + " :: " + element.startTimeFormatted);
    });
  }
}
