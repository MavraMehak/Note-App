import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyView extends StatefulWidget {
  final String userId;

  const MyView({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyView> createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection('users');
  String title = "";
  String descrip = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: titleController,
              icon: Icons.title,
              hint: "Enter Title",
              onChanged: (value) => setState(() => title = value),
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: descController,
              icon: Icons.description,
              hint: "Enter Description",
              onChanged: (value) => setState(() => descrip = value),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                backgroundColor: const Color.fromARGB(255, 154, 110, 231),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: _addNote,
              child: const Text('Add Note',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildNoteList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required IconData icon,
      required String hint,
      required Function(String) onChanged}) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 154, 110, 231)),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  void _addNote() {
    if (title.isNotEmpty && descrip.isNotEmpty) {
      ref
          .doc(widget.userId)
          .collection('notes')
          .add({'title': title, 'description': descrip});
      setState(() {
        title = "";
        descrip = "";
        titleController.clear();
        descController.clear();
      });
    }
  }

  Widget _buildNoteList() {
    return StreamBuilder(
      stream: ref.doc(widget.userId).collection('notes').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Notes Available",
                style: TextStyle(color: Colors.black54, fontSize: 16)),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot noteSnapshot = snapshot.data!.docs[index];
            final Map<String, dynamic> noteData =
                noteSnapshot.data() as Map<String, dynamic>;

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.note, color: Colors.deepPurple),
                title: Text(noteData['title'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(noteData['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () =>
                            _showEditDialog(noteSnapshot.id, noteData)),
                    IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteNote(noteSnapshot.id)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _deleteNote(String noteId) {
    ref.doc(widget.userId).collection('notes').doc(noteId).delete();
  }

  void _showEditDialog(String noteId, Map<String, dynamic> noteData) {
    TextEditingController titleController =
        TextEditingController(text: noteData['title']);
    TextEditingController descController =
        TextEditingController(text: noteData['description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Edit Note',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
                controller: titleController,
                icon: Icons.title,
                hint: 'Title',
                onChanged: (_) {}),
            const SizedBox(height: 10),
            _buildTextField(
                controller: descController,
                icon: Icons.description,
                hint: 'Description',
                onChanged: (_) {}),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 154, 110, 231)),
            onPressed: () {
              ref.doc(widget.userId).collection('notes').doc(noteId).update({
                'title': titleController.text,
                'description': descController.text,
              }).then((_) => Navigator.of(context).pop());
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
