enum GroupIDs {
  c5A(5),
  c5B(10),
  c5C(15),
  c5D(20),
  c5E(25),
  c6A(30),
  c6B(35),
  c6C(40),
  c6D(45),
  c6F(50),
  c7A(55),
  c7B(60),
  c7C(65),
  c7D(70),
  c7F(75),
  c8A(80),
  c8B(85),
  c8C(90),
  c8D(95),
  c8E(100),
  c9A(105),
  c9B(110),
  c9C(115),
  c9D(120),
  c9E(122),
  EF(127),
  Q1(132),
  Q2(137);

  final int internalID;

  const GroupIDs(this.internalID);
}

extension GroupExt on GroupIDs {
  String get name {
    switch (this) {
      case GroupIDs.c5A:
        return '5A';
      case GroupIDs.c5B:
        return '5B';
      case GroupIDs.c5C:
        return '5C';
      case GroupIDs.c5D:
        return '5D';
      case GroupIDs.c5E:
        return '5E';
      case GroupIDs.c6A:
        return '6A';
      case GroupIDs.c6B:
        return '6B';
      case GroupIDs.c6C:
        return '6C';
      case GroupIDs.c6D:
        return '6D';
      case GroupIDs.c6F:
        return '6F';
      case GroupIDs.c7A:
        return '7A';
      case GroupIDs.c7B:
        return '7B';
      case GroupIDs.c7C:
        return '7C';
      case GroupIDs.c7D:
        return '7D';
      case GroupIDs.c7F:
        return '7F';
      case GroupIDs.c8A:
        return '8A';
      case GroupIDs.c8B:
        return '8B';
      case GroupIDs.c8C:
        return '8C';
      case GroupIDs.c8D:
        return '8D';
      case GroupIDs.c8E:
        return '8E';
      case GroupIDs.c9A:
        return '9A';
      case GroupIDs.c9B:
        return '9B';
      case GroupIDs.c9C:
        return '9C';
      case GroupIDs.c9D:
        return '9D';
      case GroupIDs.c9E:
        return '9E';
      case GroupIDs.EF:
        return 'EF';
      case GroupIDs.Q1:
        return 'Q1';
      case GroupIDs.Q2:
        return 'Q2';
      default:
        return 'unknown';
    }
  }

  static GroupIDs fromString({required String key}) {
    switch (key.toUpperCase()) {
      case '5A':
        return GroupIDs.c5A;
      case '5B':
        return GroupIDs.c5B;
      case '5C':
        return GroupIDs.c5C;
      case '5D':
        return GroupIDs.c5D;
      case '5E':
        return GroupIDs.c5E;
      case '6A':
        return GroupIDs.c6A;
      case '6B':
        return GroupIDs.c6B;
      case '6C':
        return GroupIDs.c6C;
      case '6D':
        return GroupIDs.c6D;
      case '6F':
        return GroupIDs.c6F;
      case '7A':
        return GroupIDs.c7A;
      case '7B':
        return GroupIDs.c7B;
      case '7C':
        return GroupIDs.c7C;
      case '7D':
        return GroupIDs.c7D;
      case '7F':
        return GroupIDs.c7F;
      case '8A':
        return GroupIDs.c8A;
      case '8B':
        return GroupIDs.c8B;
      case '8C':
        return GroupIDs.c8C;
      case '8D':
        return GroupIDs.c8D;
      case '8E':
        return GroupIDs.c8E;
      case '9A':
        return GroupIDs.c9A;
      case '9B':
        return GroupIDs.c9B;
      case '9C':
        return GroupIDs.c9C;
      case '9D':
        return GroupIDs.c9D;
      case '9E':
        return GroupIDs.c9E;
      case 'EF':
        return GroupIDs.EF;
      case 'Q1':
        return GroupIDs.Q1;
      case 'Q2':
        return GroupIDs.Q2;
      default:
        return GroupIDs.c5A;
    }
  }
}
