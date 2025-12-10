import '../../../core/constants/enums/workout_type.dart';

class GifRepository {
  static String getGifUrl(WorkoutType workoutType, String stageName) {
    // Normalize strings for easier matching
    final stage = stageName.toLowerCase();

    // 1. Cycling
    if (workoutType == WorkoutType.cycling) {
      if (stage.contains('sprint') || stage.contains('attack')) {
        // Intense cycling
        return 'https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExczR0cnN2M2tjcDB1bW9sYjB6YmdtN2d4MnM3Nmkzc3gyaXV3ajQyMiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/SyK7sf06U8ficLm5Cf/giphy.gif';
      }
      else if (stage.contains('rest') || stage.contains('recovery')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3Z2I4bjZmdzdxNWMzdGFiNzQzd2piZjBneGJnNDJtN2E0YmFoYjgzdCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ftvphb1LgYP9SgoNGn/giphy.gif';
      }
      // Steady cycling
      return 'https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExYWZiOHNmMHNncTJ6ZHQ4NWhkaXMwY21sbmI5cmdvc3ZxN3J4cnJndyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/K4HgtO6wmyQaEkZP5a/giphy.gif';
    }

    // 2. Rowing
    if (workoutType == WorkoutType.rowing) {
      if (stage.contains('sprint')) {
        return 'https://media.giphy.com/media/v1.Y2lkPWVjZjA1ZTQ3dmgycGFycTlvaXA0OXdnOGNqcHc1a201ZHE3czdzaGdiY244eHR1ZCZlcD12MV9naWZzX3JlbGF0ZWQmY3Q9Zw/askFpJwK2UeQYPhqKz/giphy.gif';
      }
      else if (stage.contains('rest') || stage.contains('recovery')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHltdTdpYXhidDZ5ejhyMnp3M3JxdWpyYmNxajA4bGp5bDRrbGp3aCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/YWqlvTcGnT6JN0ZggR/giphy.gif';
      }
      return 'https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExYm5zZDNvMTNtNmdoYzZwNjY5a2drdTg1cTgzNnJod250bDB0aW13byZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/eS4ieTIEfrYnfPbC04/giphy.gif';
    }

    // 3. Kettlebell / Strength
    if (workoutType == WorkoutType.kettleBell) {
      if (stage.contains('halos')) {
        // Kettlebell Swing
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExbWRzNnN2eXZkaTJzYXVnM3hhb3d0MjdnZmRxb2JlcHF3cTdzYnlrcCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/cpIiirpxuqtCsf47WS/giphy.gif';
      }
      else if (stage.contains('slingshots')) {
        // Kettlebell Swing
        return 'https://gymvisual.com/img/p/1/6/9/0/3/16903.gif';
      }
      if (stage.contains('squat')) {
        // Goblet Squat
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExbmw1MzUyb3BpZDZ5enp6OGgxMmZnbmtrbXNzdWQwbTBwOTNwZm5zNSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/MdRI2tmI5e7HX7P76U/giphy.gif';
      }
      if (stage.contains('lunge')) {
        // Goblet Squat
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExZW16N2NwNDF4cnVxZGN2NjZ0eWM0MjI3a3FkaTZpbHhhN3RiNnk5bSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/58mTBYxhbSUJq/giphy.gif';
      }

      if (stage.contains('pushup') || stage.contains('push-up')) {
        // Pushups
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExMW8waGFuamNpcmY4bW44OHVzcGhxaTF5bjhwZmVuam8zZHNyZHBqYSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/xPsKvp0HaXD2FJ4g0J/giphy.gif';
      }
      else if (stage.contains('rest') || stage.contains('recovery')) {
        return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExN2NzbXcwNnYwZHlka3Q4a3lqdTNlMXcza3c5eWp4cXptMmI5a252dSZlcD12MV9naWZzX3NlYXJjaCZjdD1n/ZGmne7bRFBawmz5Gcr/giphy.gif';
      }
    }

    // Default / Resting / Warmup
    return 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExOHltdTdpYXhidDZ5ejhyMnp3M3JxdWpyYmNxajA4bGp5bDRrbGp3aCZlcD12MV9naWZzX3NlYXJjaCZjdD1n/YWqlvTcGnT6JN0ZggR/giphy.gif';
  }
}