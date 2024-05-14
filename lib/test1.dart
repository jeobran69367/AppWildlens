// suppression 1

const SizedBox(height: 10),
if (_image != null)
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
ElevatedButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => CameraPage(camera: camera),
),
);
},
style: ElevatedButton.styleFrom(
foregroundColor: Colors.white,
backgroundColor: Colors.blue,
padding:
const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
),
child: const Text("Retake"),
),
const SizedBox(width: 10),
ElevatedButton(
onPressed: () {
// Passer à l'étape suivante avec l'image sélectionnée
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => NextPage(_image!),
),
);
},
style: ElevatedButton.styleFrom(
foregroundColor: Colors.white,
backgroundColor: Colors.blue,
padding:
const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
),
child: const Text("Good"),
),
],
),