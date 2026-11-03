import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/person_record.dart';

/// Thin wrapper around the `people` Firestore collection used to store
/// employee / student records. Requires a real Firebase project — see
/// lib/firebase_options.dart.
class PeopleRepository {
  final CollectionReference<Map<String, Object?>> _collection =
      FirebaseFirestore.instance.collection('people');

  Future<void> addPerson(PersonRecord person) => _collection.add(person.toMap());

  Stream<List<PersonRecord>> watchPeople() {
    return _collection.orderBy('name').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => PersonRecord.fromMap(doc.id, doc.data())).toList(),
        );
  }
}
