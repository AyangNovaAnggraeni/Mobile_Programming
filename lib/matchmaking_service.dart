import 'package:cloud_firestore/cloud_firestore.dart';

class MatchmakingService {
  static Future<String> findOrCreateRoom(String playerId) async {
    final rooms = await FirebaseFirestore.instance
        .collection('rooms')
        .where('player2Id', isNull: true)
        .get();

    if (rooms.docs.isNotEmpty) {
      final room = rooms.docs.first;
      await room.reference.update({
        'player2Id': playerId,
      });
      return room.id;
    }

    final newRoom = await FirebaseFirestore.instance
        .collection('rooms')
        .add({
      'player1Id': playerId,
      'player2Id': null,
      'player1Choice': null,
      'player2Choice': null,
      'player1Score': 0,
      'player2Score': 0,
      'roundResolved': false,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newRoom.id;
  }
}
