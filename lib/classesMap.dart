import 'package:http/http.dart' as http;

List<String> getSubjectsFullName() {
  List<String> classesFullName = [
    'Deutsch',
    'Mathe',
    'Englisch',
    'Musik',
    'Kunst',
    'Chemie',
    'Biologie',
    'Geschichte',
    'Erdkunde',
    'Pädagogik',
    'Spanisch',
    'Spanisch',
    'Englisch VT',
    'Mathe VT',
    'Französisch',
    'Französisch',
    'Informatik',
    'Informatik Diff.',
    'Philosophie',
    'Philosophie',
    'Kath. Religion',
    'Ev. Religion',
    'Latein',
    'Latein',
    'Französisch',
    'Sport',
    'Mittagspause',
    'Mittagspause',
    'Litertur',
    'Lernzeit',
    'Physik Diff.',
    'Geschichte Diff.',
    'Kunst Diff.',
    'Politik',
    'Englisch Förder',
    'Deutsch Förder',
    'Mathe Förder',
    'Latein Förder',
    'Orientierungsstunde',
    'Nicht angegeben',
    'Physik'
  ];

  return classesFullName;
}

List<String> getSubjectsAbbreviation() {
  List<String> classesAbbreviation = [
    'D',
    'M',
    'E',
    'MU',
    'KU',
    'CH',
    'BI',
    'GE',
    'EK',
    'PA',
    'S8',
    'S10',
    'E VT',
    'M VT',
    'F5',
    'F6',
    'IF',
    'IFd',
    'PL',
    'PPL',
    'KR',
    'ER',
    'L6',
    'L',
    'F',
    'SP',
    'MP',
    'MP MH',
    'LIT',
    'LZ',
    'PHd',
    'GEd',
    'KUd',
    'PK',
    'E FÖ',
    'D FÖ',
    'M FÖ',
    'L FÖ',
    'OS',
    '&nbsp;',
    'PH'
  ];

  return classesAbbreviation;
}

Future<List<String>?> getAllClasses () async {
  Future<List<String>?> _getClassesList() async {
    try {
      var response = await http.get(
          Uri.http('janw.bplaced.net', 'annetteapp/data/klassenListe.txt'));
      if (response.statusCode == 200) {
        return response.body.split(',');
      }
      return null;} catch (e) {
      return null;
    }
  }
  return await _getClassesList();
}
