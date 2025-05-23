// avatar_modal.dart

import 'package:flutter/material.dart';

class AvatarModal extends StatefulWidget {
  final Function(String name, String avatarUrl) onSave;

  const AvatarModal({super.key, required this.onSave});

  @override
  State<AvatarModal> createState() => _AvatarModalState();
}

class _AvatarModalState extends State<AvatarModal> {
  final List<String> predefinedSeeds = [
    "Adrian", "Jamie", "Taylor", "Riley",
    "Jordan", "Casey", "Morgan", "Drew",
  ];

  String seed = "Adrian";
  String bgColor = "b6e3f4";
  String skinColor = "e0ac69";
  String hairColor = "2c1b18";
  String hairStyle = "short01";
  String facialHair = "none";
  String accessory = "none";
  String eyes = "variant01";
  String eyebrows = "variant01";
  String mouth = "variant01";
  String earrings = "none";

  String get avatarUrl {
    return '''
https://api.dicebear.com/8.x/adventurer/svg
?seed=$seed
&backgroundColor=$bgColor
&hair=$hairStyle
&hairColor=$hairColor
&skinColor=$skinColor
&facialHair=$facialHair
&accessories=${accessory != "none" ? accessory : ""}
&eyes=$eyes
&eyebrows=$eyebrows
&mouth=$mouth
&earrings=${earrings != "none" ? earrings : ""}
'''.replaceAll(RegExp(r'\s+'), "");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      title: const Text(
        "Create Adventurer Avatar",
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Controls ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT COLUMN
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Choose Seed"),
                        DropdownButton<String>(
                          value: seed,
                          isExpanded: true,
                          items: predefinedSeeds
                              .map((name) => DropdownMenuItem(
                                    value: name,
                                    child: Text(name),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => seed = val!),
                        ),
                        const SizedBox(height: 8),
                        const Text("Background Color"),
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Color(int.parse("0xFF$bgColor")),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: bgColor,
                                decoration: const InputDecoration(
                                  prefixText: "#",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                onChanged: (val) {
                                  if (val.length == 6) setState(() => bgColor = val);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text("Skin Color"),
                        DropdownButton<String>(
                          value: skinColor,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "e0ac69", child: Text("Light")),
                            DropdownMenuItem(value: "c68642", child: Text("Medium")),
                            DropdownMenuItem(value: "8d5524", child: Text("Dark")),
                          ],
                          onChanged: (val) => setState(() => skinColor = val!),
                        ),
                        const SizedBox(height: 8),
                        const Text("Hair Color"),
                        DropdownButton<String>(
                          value: hairColor,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "2c1b18", child: Text("Black")),
                            DropdownMenuItem(value: "b55239", child: Text("Brown")),
                            DropdownMenuItem(value: "dba279", child: Text("Blonde")),
                            DropdownMenuItem(value: "e5c3a6", child: Text("Light Blonde")),
                            DropdownMenuItem(value: "fff", child: Text("White")),
                          ],
                          onChanged: (val) => setState(() => hairColor = val!),
                        ),
                        const SizedBox(height: 8),
                        const Text("Hair Style"),
                        DropdownButton<String>(
                          value: hairStyle,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "short01", child: Text("Short")),
                            DropdownMenuItem(value: "long01", child: Text("Long")),
                            DropdownMenuItem(value: "bun01", child: Text("Bun")),
                            DropdownMenuItem(value: "afro01", child: Text("Afro")),
                            DropdownMenuItem(value: "mohawk01", child: Text("Mohawk")),
                          ],
                          onChanged: (val) => setState(() => hairStyle = val!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // RIGHT COLUMN
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Facial Hair"),
                        DropdownButton<String>(
                          value: facialHair,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "none", child: Text("None")),
                            DropdownMenuItem(value: "beardLight", child: Text("Beard (Light)")),
                            DropdownMenuItem(value: "beardMedium", child: Text("Beard (Medium)")),
                            DropdownMenuItem(value: "beardHeavy", child: Text("Beard (Heavy)")),
                            DropdownMenuItem(value: "moustacheFancy", child: Text("Fancy")),
                            DropdownMenuItem(value: "moustacheMagnum", child: Text("Magnum")),
                          ],
                          onChanged: (val) => setState(() => facialHair = val!),
                        ),
                        const SizedBox(height: 8),
                        const Text("Accessory"),
                        DropdownButton<String>(
                          value: accessory,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "none", child: Text("None")),
                            DropdownMenuItem(value: "glassesRound", child: Text("Glasses (Round)")),
                            DropdownMenuItem(value: "glassesSquare", child: Text("Glasses (Square)")),
                          ],
                          onChanged: (val) => setState(() => accessory = val!),
                        ),
                        const SizedBox(height: 8),
                        const Text("Eyes"),
                        DropdownButton<String>(
                          value: eyes,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "variant01", child: Text("Variant 01")),
                            DropdownMenuItem(value: "variant02", child: Text("Variant 02")),
                            DropdownMenuItem(value: "variant03", child: Text("Variant 03")),
                          ],
                          onChanged: (val) => setState(() => eyes = val!),
                        ),
                        const SizedBox(height: 8),
                        const Text("Eyebrows"),
                        DropdownButton<String>(
                          value: eyebrows,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "variant01", child: Text("Variant 01")),
                            DropdownMenuItem(value: "variant02", child: Text("Variant 02")),
                            DropdownMenuItem(value: "variant03", child: Text("Variant 03")),
                          ],
                          onChanged: (val) => setState(() => eyebrows = val!),
                        ),
                        const SizedBox(height: 8),
                        const Text("Mouth"),
                        DropdownButton<String>(
                          value: mouth,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "variant01", child: Text("Variant 01")),
                            DropdownMenuItem(value: "variant02", child: Text("Variant 02")),
                            DropdownMenuItem(value: "variant03", child: Text("Variant 03")),
                          ],
                          onChanged: (val) => setState(() => mouth = val!),
                        ),
                        const SizedBox(height: 8),
                        const Text("Earrings"),
                        DropdownButton<String>(
                          value: earrings,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: "none", child: Text("None")),
                            DropdownMenuItem(value: "hoop", child: Text("Hoop")),
                            DropdownMenuItem(value: "stud", child: Text("Stud")),
                          ],
                          onChanged: (val) => setState(() => earrings = val!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // --- Avatar Preview ---
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                onPressed: () {
                  widget.onSave(seed, avatarUrl);
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
