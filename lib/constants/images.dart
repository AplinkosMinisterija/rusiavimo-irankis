import 'package:aplinkos_ministerija/constants/strings.dart';

class SymbolImages {
  SymbolImages._();

  //Level 1

  static const List<String> level1New = [
    Strings.corrosion,
    Strings.fishy,
    Strings.gas_tank,
    Strings.warning,
    Strings.boomb,
    Strings.flame,
    Strings.flamable,
    Strings.breathing,
    Strings.skull,
  ];

  static const List<String> level1NewDescriptions = [
    'Korozija',
    'Aplinka',
    'Dujų balionas',
    'Šauktukas',
    'Sprogstanti bomba',
    'Liepsna',
    'Liepsnojantis lankas',
    'Pavojai sveikatai',
    'Kaukolė ir sukryžiuoti kaulai',
  ];

  static const List<String> level1Old = [
    Strings.X,
    Strings.X,
    Strings.F,
    Strings.F,
    Strings.O,
    Strings.T,
    Strings.T,
    Strings.C,
    Strings.N,
    Strings.E,
  ];

  static const List<String> level1OldDescriptions = [
    'Kenksminga',
    'Dirginanti',
    'Labai degi',
    'Ypač degi',
    'Oksiduojanti',
    'Toksiška',
    'Labai toksiška',
    'Ardanti (ėsdinanti)',
    'Aplinkai pavojinga',
    'Sprogstamoji',
  ];

  //Level 2

  static const List<String> level2New = [
    Strings.boomb,
    Strings.breathing,
    Strings.skull,
  ];

  static const List<String> level2NewDescriptions = [
    'Sprogstanti bomba',
    'Pavojai sveikatai',
    'Kaukolė ir sukryžiuoti kaulai',
  ];

  static const List<String> level2Old = [
    Strings.E,
    Strings.X,
    Strings.X,
    Strings.T,
    Strings.T,
  ];

  static const List<String> level2OldDescription = [
    'Sprogstamoji',
    'Kenksminga',
    'Dirginanti',
    'Toksiška',
    'Labai toksiška',
  ];
}
