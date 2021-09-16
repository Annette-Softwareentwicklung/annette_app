import 'package:annette_app/firebase/timetableUnitFirebaseInteraction.dart';
import 'package:annette_app/fundamentals/timetableUnit.dart';

Map<String, String> getSubjects() {
  Map<String, String> subjects = {
    'D': 'Deutsch',
    'M': 'Mathe',
    'E': 'Englisch',
    'MU': 'Musik',
    'KU': 'Kunst',
    'CH': 'Chemie',
    'BI': 'Biologie',
    'GE': 'Geschichte',
    'EK': 'Erdkunde',
    'PA': 'Pädagogik',
    'S8': 'Spanisch',
    'S10': 'Spanisch',
    'E VT': 'Englisch VT',
    'M VT': 'Mathe VT',
    'F5': 'Französisch',
    'F6': 'Französisch',
    'IF': 'Informatik',
    'IFd': 'Informatik Diff',
    'PL': 'Philosophie',
    'PPL': 'Philosophie',
    'KR': 'Kath. Religion',
    'ER': 'Ev. Religion',
    'L6': 'Latein',
    'L': 'Latein',
    'F': 'Französisch',
    'SP': 'Sport',
    'MP': 'Mittagspause',
    'MP MH': 'Mittagspause',
    'LIT': 'Literatur',
    'LZ': 'Lernzeit',
    'PHd': 'Physik Diff.',
    'GEd': 'Geschichte Diff.',
    'KUd': 'Kunst Diff.',
    'PK': 'Politik',
    'E FÖ': 'Englisch Förder',
    'D FÖ': 'Deutsch Förder',
    'M FÖ': 'Mathe Förder',
    'L FÖ': 'Latein Förder',
    'OS': 'Orientierungsstunde',
    '&nbsp;': 'Nicht angegeben',
    'PH': 'Physik',
    'SI': 'Schwimmen',
    'SW': 'Sowi',
    'L7': 'Latein',
    'F7': 'Französisch',
    'S9': 'Spanisch',
    'S11': 'Spanisch',
    'M LZ': 'Mathe',
    'E LZ': 'Englisch',
    'D LZ': 'Deutsch',
    'L LZ': 'Latein',
    'F LZ': 'Französisch',
  };
  return subjects;
}

// Function to retrieve the subject a user has
Future<Map<String, dynamic>> getUserSubjects(List<String> subjectCodes, List<String> subjectNames) async {

  List<TimeTableUnit> timetableUnits = await databaseGetAllTimeTableUnit();
  timetableUnits.sort((a, b) {
    return a.subject!.compareTo(b.subject!);
  });

  Map<String, String> allSubjects = getSubjects();

  ///Mittagspause herausfiltern
  int temp = timetableUnits.indexWhere((element) => element.subject == 'MP');
  while(temp != -1) {
    timetableUnits.removeAt(temp);
    temp = timetableUnits.indexWhere((element) => element.subject == 'MP');
  }
  temp = timetableUnits.indexWhere((element) => element.subject == 'MP MH');
  while(temp != -1) {
    timetableUnits.removeAt(temp);
    temp = timetableUnits.indexWhere((element) => element.subject == 'MP MH');
  }

  for (int i = 0; i < timetableUnits.length; i++) {
    String tempSubjectAbbreviation = timetableUnits[i].subject!;

    if (!subjectCodes.contains(tempSubjectAbbreviation)) {
      subjectCodes.add(tempSubjectAbbreviation);
    }
    if (tempSubjectAbbreviation.contains('LK')) {
      tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
          0, tempSubjectAbbreviation.indexOf('LK') - 1);
    } else if (tempSubjectAbbreviation.contains('GK')) {
      tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
          0, tempSubjectAbbreviation.indexOf('GK') - 1);
    } else if (tempSubjectAbbreviation.contains('Z1')) {
      tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
          0, tempSubjectAbbreviation.indexOf('Z1') - 1);
    } else if (tempSubjectAbbreviation.contains('Z2')) {
      tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
          0, tempSubjectAbbreviation.indexOf('Z2') - 1);
    } else if (tempSubjectAbbreviation.contains('VT')) {
      tempSubjectAbbreviation = tempSubjectAbbreviation.substring(
          0, tempSubjectAbbreviation.indexOf('VT') + 2);
    }

    late String tempSubjectFullName;

    if (allSubjects.containsKey(tempSubjectAbbreviation)) {
      tempSubjectFullName = allSubjects[tempSubjectAbbreviation]!;
    } else {
      tempSubjectFullName = tempSubjectAbbreviation;
    }

    if (tempSubjectFullName == 'Kath. Religion' ||
        tempSubjectFullName == 'Ev. Religion') {
      tempSubjectFullName = 'Religion';
    }

    if (!subjectNames.contains(tempSubjectFullName)) {
      subjectNames.add(tempSubjectFullName);
    }
  }

  return {
    "timetableUnits": timetableUnits,
    "subjectCodes": subjectCodes,
    "subjectNames": subjectNames
  };

}
