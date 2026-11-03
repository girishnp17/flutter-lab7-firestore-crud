import 'package:flutter/material.dart';

import '../models/person_record.dart';
import '../services/people_repository.dart';

class PeopleRecordsScreen extends StatefulWidget {
  final bool firebaseReady;

  const PeopleRecordsScreen({super.key, required this.firebaseReady});

  @override
  State<PeopleRecordsScreen> createState() => _PeopleRecordsScreenState();
}

class _PeopleRecordsScreenState extends State<PeopleRecordsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _deptController = TextEditingController();

  PeopleRepository? _repository;

  @override
  void initState() {
    super.initState();
    if (widget.firebaseReady) {
      _repository = PeopleRepository();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _repository == null) return;
    await _repository!.addPerson(PersonRecord(
      name: _nameController.text.trim(),
      rollOrEmpId: _idController.text.trim(),
      department: _deptController.text.trim(),
    ));
    _nameController.clear();
    _idController.clear();
    _deptController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee / Student Records (Firestore)')),
      body: Column(
        children: [
          if (!widget.firebaseReady)
            Container(
              width: double.infinity,
              color: Colors.orange.shade100,
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Firebase not configured — run `flutterfire configure` and connect a '
                'real Firebase project to use this screen.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                    validator: _required,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _idController,
                    decoration:
                        const InputDecoration(labelText: 'Roll No. / Employee ID', border: OutlineInputBorder()),
                    validator: _required,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _deptController,
                    decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.firebaseReady ? _save : null,
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Save to Firestore'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_repository == null) {
      return const Center(child: Text('No data — connect Firestore to see records here.'));
    }
    return StreamBuilder<List<PersonRecord>>(
      stream: _repository!.watchPeople(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('No data — connect Firestore to see records here.'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final people = snapshot.data!;
        if (people.isEmpty) {
          return const Center(child: Text('No records yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: people.length,
          itemBuilder: (context, i) {
            final p = people[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${p.department} • ${p.rollOrEmpId}'),
              ),
            );
          },
        );
      },
    );
  }
}
