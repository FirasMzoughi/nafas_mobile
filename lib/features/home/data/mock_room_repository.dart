import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafas/features/home/domain/room.dart';

class MockRoomRepository {
  Future<List<Room>> getActiveRooms() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Room(
        id: '1',
        title: 'Anxiety Support Group',
        listenersCount: 145,
        speakersCount: 3,
        tags: ['Anxiety', 'Support', 'Listening'],
        speakerAvatars: ['Calm', 'Hope', 'Spirit'],
        listenerAvatars: List.generate(10, (index) => 'Mystery'),
      ),
      Room(
        id: '2',
        title: 'Late Night Thoughts',
        listenersCount: 89,
        speakersCount: 2,
        tags: ['Insomnia', 'Chat', 'Chill'],
        speakerAvatars: ['Mystery', 'Flow'],
        listenerAvatars: List.generate(5, (index) => 'Calm'),
      ),
      Room(
        id: '3',
        title: 'Overcoming Addiction',
        listenersCount: 210,
        speakersCount: 5,
        tags: ['Recovery', 'Strength', 'Together'],
        speakerAvatars: ['Spirit', 'Brave', 'Hope', 'Flow', 'Calm'],
        listenerAvatars: List.generate(15, (index) => 'Brave'),
      ),
      Room(
        id: '4',
        title: 'Mindfulness Meditation',
        listenersCount: 300,
        speakersCount: 1,
        tags: ['Meditation', 'Peace', 'Guided'],
        speakerAvatars: ['Calm'],
        listenerAvatars: List.generate(20, (index) => 'Flow'),
      ),
    ];
  }
}

final roomRepositoryProvider = Provider<MockRoomRepository>((ref) {
  return MockRoomRepository();
});

final activeRoomsProvider = FutureProvider<List<Room>>((ref) async {
  final repo = ref.read(roomRepositoryProvider);
  return repo.getActiveRooms();
});
