import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:shadowlazer/game_controller.dart';
class Player
{
  final GameController gameController;
  int maxHealth;
  int currentHealth;
  Rect playerRect;
  bool isDead = false;

  Player(this.gameController)
  {
    maxHealth = currentHealth = 300;
    final size = gameController.titleSize = 1.5;
    playerRect = Rect.fromLTWH(
      gameController.screenSize.width /2,
      gameController.screenSize.height /2,
      size,
      size,
    );
  }

  void render(Canvas c)
  {
    Paint color = Paint()..color = 0xFF0000FF as Color;
    c.drawRect(playerRect, color);
  }

  void update(double t)
  {
    if(!isDead && currentHealth <= 0)
      {
        print(currentHealth);
        isDead = true;
        gameController.initialize();
      }
  }

//  void resize()
//  {
//    screenSize = size;
//    titleSize = screenSize.width / 10;
//  }

  void onTapDown(TapDownDetails d)
  {
    print(d.globalPosition);
  }
}