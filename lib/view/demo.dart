// import 'package:flutter/material.dart';
//
// // Model classes
// class CountryModel {
//   final int id;
//   final String title;
//   final List<StateModel> states;
//
//   CountryModel({required this.id, required this.title, required this.states});
// }
//
// class StateModel {
//   final int id;
//   final String name;
//   final List<String> cities;
//
//   StateModel({required this.id, required this.name, required this.cities});
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: CountrySelectionScreen(),
//     );
//   }
// }
//
// class CountrySelectionScreen extends StatefulWidget {
//   @override
//   _CountrySelectionScreenState createState() => _CountrySelectionScreenState();
// }
//
// class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
//   List<CountryModel> countries = [
//     CountryModel(id: 1, title: "Afghanistan", states: [
//       StateModel(id: 101, name: 'Badakhshan', cities: ['Fayzabad', 'Jurm']),
//       StateModel(
//           id: 102, name: 'Badghis', cities: ['Qala-e-Naw', 'Bala Murghab']),
//     ]),
//     CountryModel(id: 2, title: "Albania", states: [
//       StateModel(id: 201, name: 'Berat', cities: ['Berat', 'Poliçan']),
//       StateModel(id: 202, name: 'Dibër', cities: ['Peshkopi', 'Bulqizë']),
//     ]),
//   ];
//
//   CountryModel? selectedCountry;
//   StateModel? selectedState;
//   String? selectedCity;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Country, State, and City'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButton<CountryModel>(
//               hint: Text("Select Country"),
//               value: selectedCountry,
//               onChanged: (CountryModel? newValue) {
//                 setState(() {
//                   selectedCountry = newValue;
//                   selectedState = null;
//                   selectedCity = null;
//                 });
//               },
//               items: countries
//                   .map<DropdownMenuItem<CountryModel>>(
//                       (CountryModel value) => DropdownMenuItem<CountryModel>(
//                             value: value,
//                             child: Text(value.title),
//                           ))
//                   .toList(),
//             ),
//             if (selectedCountry != null) ...[
//               DropdownButton<StateModel>(
//                 hint: Text("Select State"),
//                 value: selectedState,
//                 onChanged: (StateModel? newValue) {
//                   setState(() {
//                     selectedState = newValue;
//                     selectedCity = null;
//                   });
//                 },
//                 items: selectedCountry!.states
//                     .map<DropdownMenuItem<StateModel>>(
//                         (StateModel value) => DropdownMenuItem<StateModel>(
//                               value: value,
//                               child: Text(value.name),
//                             ))
//                     .toList(),
//               ),
//             ],
//             if (selectedState != null) ...[
//               DropdownButton<String>(
//                 hint: Text("Select City"),
//                 value: selectedCity,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedCity = newValue;
//                   });
//                 },
//                 items: selectedState!.cities
//                     .map<DropdownMenuItem<String>>(
//                         (String city) => DropdownMenuItem<String>(
//                               value: city,
//                               child: Text(city),
//                             ))
//                     .toList(),
//               ),
//             ],
//             ElevatedButton(
//               onPressed: () {
//                 if (selectedCity != null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ResultScreen(
//                         country: selectedCountry!,
//                         state: selectedState!,
//                         city: selectedCity!,
//                       ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Please select a city")),
//                   );
//                 }
//               },
//               child: Text('Next'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ResultScreen extends StatelessWidget {
//   final CountryModel country;
//   final StateModel state;
//   final String city;
//
//   ResultScreen(
//       {required this.country, required this.state, required this.city});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Selected Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Country: ${country.title}", style: TextStyle(fontSize: 20)),
//             Text("State: ${state.name}", style: TextStyle(fontSize: 20)),
//             Text("City: $city", style: TextStyle(fontSize: 20)),
//           ],
//         ),
//       ),
//     );
//   }
// }
