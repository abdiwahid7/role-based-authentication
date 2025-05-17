class EventFeedback {
  final String id;
  final String eventId;
  final String userId;
  final String comment;
  final int rating;

  EventFeedback({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.comment,
    required this.rating,
  });

  factory EventFeedback.fromMap(Map<String, dynamic> data, String id) {
    return EventFeedback(
      id: id,
      eventId: data['eventId'],
      userId: data['userId'],
      comment: data['comment'],
      rating: data['rating'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'userId': userId,
      'comment': comment,
      'rating': rating,
    };
  }
}