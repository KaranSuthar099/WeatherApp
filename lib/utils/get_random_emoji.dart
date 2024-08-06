import 'dart:math';

class GetRandomEmoji{
  static String getRandomEmoji(){
    
    const emojis = [
      '😀', '😂', '🥰', '😍', '😎', '😜', '😢', '😡', '🎉', '💡', '🔥', '💧',
      '🌟', '🌈', '🍕', '🍔', '🍎', '🚀', '⚽', '🎵', '🌍', '🌞', '⭐', '🌙',
      '🌸', '🍉', '🍦', '🎂', '☕', '📚', '🎨', '🎮', '✈️', '🚗', '🏠'
    ];
    final random = Random();
    return emojis[random.nextInt(emojis.length)];

  }
}