import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piano/piano.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterMidi _flutterMidi = FlutterMidi();
  String fileName = "Guitars.sf2";
  List<String> items = ["Guitars", "Flute", "Yamaha"];
  late String value;
  @override
  void initState() {
    value = items[0];
    load('assets/$fileName');
    super.initState();
  }

  void load(String asset) async {
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load(asset);
    _flutterMidi.prepare(sf2: _byte, name: fileName);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Piano"),
        centerTitle: true,
        actions: [
          DropdownButton(
              value: value,
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: Text(
                              e,
                            )),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  this.value = value.toString();
                  fileName = "${value.toString()}.sf2";
                  load('assets/$fileName');
                });
              })
        ],
      ),
      body: Center(
        child: InteractivePiano(
          noteRange: NoteRange.forClefs([
            Clef.Treble,
          ]),
          highlightedNotes: [NotePosition(note: Note.A, octave: 3)],
          naturalColor: Colors.white,
          accidentalColor: Colors.black,
          keyWidth: 50,
          onNotePositionTapped: (position) {
            setState(() {
              _flutterMidi.playMidiNote(midi: position.pitch);
            });
          },
        ),
      ),
    );
  }
}
